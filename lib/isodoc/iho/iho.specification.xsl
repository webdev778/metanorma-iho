<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iho="https://www.metanorma.org/ns/iho" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/>
	
	

	<!-- <xsl:key name="kfn" match="iho:fn[local-name(..) = 'p' or local-name(..) = 'title']" use="@reference"/> -->
	<xsl:key name="kfn" match="iho:fn[local-name(..) = 'p' or ancestor::*[local-name() = 'title']]" use="@reference"/>
	
	
	
	<xsl:variable name="debug">false</xsl:variable>
	<xsl:variable name="pageWidth" select="210"/>
	<xsl:variable name="pageHeight" select="297"/>
	<xsl:variable name="marginLeftRight1" select="25.4"/>
	<xsl:variable name="marginLeftRight2" select="25.4"/>
	<xsl:variable name="marginTop" select="25.4"/>
	<xsl:variable name="marginBottom" select="25.4"/>
	
	
	<xsl:variable name="title-en" select="/iho:iho-standard/iho:bibdata/iho:title[@language = 'en']"/>
	<xsl:variable name="docidentifier" select="/iho:iho-standard/iho:bibdata/iho:docidentifier[@type = 'IHO']"/>
	<xsl:variable name="copyrightText" select="concat('© International Hydrographic Association ', /iho:iho-standard/iho:bibdata/iho:copyright/iho:from ,' – All rights reserved')"/>

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>			
		</contents>
	</xsl:variable>
	
	<xsl:template match="/">
		
		<xsl:variable name="xslfo">		
			<fo:root font-family="Arial, Cambria Math" font-size="12pt" xml:lang="{$lang}">
				<fo:layout-master-set>
					<!-- cover page -->
					<fo:simple-page-master master-name="cover" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
						<fo:region-body margin-top="0mm" margin-bottom="5mm" margin-left="0mm" margin-right="5mm"/>
					</fo:simple-page-master>
					
					<fo:simple-page-master master-name="first" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
						<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
						<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
						<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
						<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
						<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
					</fo:simple-page-master>				
					<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
						<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
						<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
						<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
						<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
						<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
					</fo:simple-page-master>
					<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
						<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
						<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
						<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
						<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
						<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
					</fo:simple-page-master>
					<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
						<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
						<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
						<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
						<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
						<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
					</fo:simple-page-master>
					<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
						<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
						<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
						<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
						<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
						<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
					</fo:simple-page-master>
					<!-- Preface pages -->
					<fo:page-sequence-master master-name="preface">
						<fo:repeatable-page-master-alternatives>
							<fo:conditional-page-master-reference master-reference="first" page-position="first"/>
							<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
							<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
						</fo:repeatable-page-master-alternatives>
					</fo:page-sequence-master>
					<!-- Document pages -->
					<fo:page-sequence-master master-name="document">
						<fo:repeatable-page-master-alternatives>						
							<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
							<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
						</fo:repeatable-page-master-alternatives>
					</fo:page-sequence-master>
					<fo:page-sequence-master master-name="document-portrait">
						<fo:repeatable-page-master-alternatives>						
							<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
							<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
						</fo:repeatable-page-master-alternatives>
					</fo:page-sequence-master>
					<fo:page-sequence-master master-name="document-landscape">
						<fo:repeatable-page-master-alternatives>						
							<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
							<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
						</fo:repeatable-page-master-alternatives>
					</fo:page-sequence-master>
				</fo:layout-master-set>
				
				<fo:declarations>
					<xsl:call-template name="addPDFUAmeta"/>
				</fo:declarations>
				
				<xsl:call-template name="addBookmarks">
					<xsl:with-param name="contents" select="$contents"/>
				</xsl:call-template>
				
				<!-- =========================== -->
				<!-- Cover Page -->
				<fo:page-sequence master-reference="cover">				
					<fo:flow flow-name="xsl-region-body">
						<fo:block-container position="absolute" left="14.25mm" top="28.20mm">
							<fo:table table-layout="fixed" width="181.1mm">
									<fo:table-column column-width="26mm"/>
									<fo:table-column column-width="45.3mm"/>
									<fo:table-column column-width="109.8mm"/>
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell><fo:block> </fo:block></fo:table-cell>
											<fo:table-cell>
												<fo:block-container width="45.3mm" height="19.3mm" background-color="rgb(241, 234, 202)" text-align="center" display-align="center" font-weight="bold">
													<fo:block>
														<xsl:value-of select="$docidentifier"/>
														<xsl:text> </xsl:text>
														<xsl:apply-templates select="/iho:iho-standard/iho:bibdata/iho:edition"/>
													</fo:block>
												</fo:block-container>
											</fo:table-cell>
											<fo:table-cell><fo:block> </fo:block></fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell display-align="after" text-align="right">
												<fo:block font-size="1">
													<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IHO))}" width="25.9mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image IHO"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell number-columns-spanned="2" border="0.5pt solid rgb(0, 21, 50)">
												<fo:block-container height="154.4mm" text-align="center" display-align="center">
													<fo:block font-size="28pt" font-weight="bold" color="rgb(0, 0, 76)">
														<xsl:value-of select="$title-en"/>
													</fo:block>
												</fo:block-container>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell>
												<fo:block font-size="1">
													<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-IHO))}" width="25.9mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo IHO"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-size="1">
													<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Text-IHO))}" width="25.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image Text IHO"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block-container width="79.2mm" height="66.3mm" margin-left="30.6mm" background-color="rgb(0, 172, 158)" text-align="right" display-align="after">
													<fo:block font-size="8pt" color="white" margin-left="-30mm" margin-right="5mm" margin-bottom="9mm">
														<xsl:apply-templates select="/iho:iho-standard/iho:boilerplate/iho:feedback-statement"/>
													</fo:block>
												</fo:block-container>					
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
						</fo:block-container>					
					</fo:flow>
				</fo:page-sequence>
				<!-- End Cover Page -->
				<!-- =========================== -->
				<!-- =========================== -->
							
				<!-- Preface Pages -->
				<fo:page-sequence master-reference="preface" format="i">
					<fo:static-content flow-name="xsl-footnote-separator">
						<fo:block>
							<fo:leader leader-pattern="rule" leader-length="30%"/>
						</fo:block>
					</fo:static-content>
					<xsl:call-template name="insertHeaderFooter">
						<xsl:with-param name="font-weight">normal</xsl:with-param>
					</xsl:call-template>
					<fo:flow flow-name="xsl-region-body">
						<fo:block> </fo:block>
						<fo:block break-after="page"/>
						<fo:block-container margin-left="7.5mm" margin-right="-2mm">
							<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black" padding-top="1mm" padding-left="1.8mm" padding-right="1mm">
								<fo:block>
									<xsl:apply-templates select="/iho:iho-standard/iho:boilerplate/*[local-name() != 'feedback-statement']"/>
								</fo:block>
							</fo:block-container>
						</fo:block-container>
						
						<fo:block break-after="page"/>
						
						<!-- Table of Contents -->
						<fo:block-container margin-right="-12.7mm">
							<fo:block-container margin-right="0mm">
								<fo:block color="rgb(14, 36, 133)" margin-bottom="15.5pt">
									<xsl:variable name="title-toc">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-toc'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-toc"/>
								</fo:block>
								<xsl:if test="$debug = 'true'">
									<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
										DEBUG
										contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
									<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
								</xsl:if>
								
								<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->							
									<fo:block>
										<xsl:if test="@level = 1">
											<xsl:attribute name="margin-top">6pt</xsl:attribute>
										</xsl:if>
									
										<fo:list-block>
											
											<xsl:attribute name="provisional-distance-between-starts">
												<xsl:choose>
													<xsl:when test="@level &gt;= 1 and @root = 'preface'">0mm</xsl:when>
													<xsl:when test="@level &gt;= 1 and @root = 'annex' and not(@type = 'annex')">13mm</xsl:when>
													<xsl:when test="@level &gt;= 1 and not(@type = 'annex')">10mm</xsl:when>													
													<xsl:otherwise>0mm</xsl:otherwise>
												</xsl:choose>											
											</xsl:attribute>
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
													<fo:block>
														<xsl:if test="@section != '' and not(@type = 'annex')"> <!-- output below   -->
															<xsl:value-of select="@section"/>
														</xsl:if>
													</fo:block>
												</fo:list-item-label>
													<fo:list-item-body start-indent="body-start()">
														<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
															<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">																
																<xsl:apply-templates select="title"/>
																<fo:inline keep-together.within-line="always">
																	<fo:leader font-size="9pt" font-weight="normal" leader-pattern="dots"/>
																	<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
																</fo:inline>
															</fo:basic-link>
														</fo:block>
													</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</fo:block>
									
								</xsl:for-each>
							</fo:block-container>
						</fo:block-container>
						
						<!-- Foreword, Introduction -->
						<xsl:call-template name="processPrefaceSectionsDefault"/>
						
					</fo:flow>
				</fo:page-sequence>
				<!-- End Preface Pages -->
				<!-- =========================== -->
				<!-- =========================== -->
				
				
				<!-- Document Pages -->
				
				
				
				<fo:page-sequence master-reference="document" initial-page-number="1" format="1" force-page-count="no-force">
					<fo:static-content flow-name="xsl-footnote-separator">
						<fo:block>
							<fo:leader leader-pattern="rule" leader-length="30%"/>
						</fo:block>
					</fo:static-content>
					<xsl:call-template name="insertHeaderFooter"/>
					<fo:flow flow-name="xsl-region-body">
						<fo:block-container>
							
							<fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt"><xsl:value-of select="$title-en"/></fo:block>
							
							<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']"/>
							<!-- Normative references  -->
							<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']"/>
							<!-- Terms and definitions -->
							<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms']"/>
							<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='definitions']"/>
							<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and local-name() != 'definitions' and not(@type='scope')]"/>
							
						</fo:block-container>
					</fo:flow>
				</fo:page-sequence>
				
				<xsl:if test="/iho:iho-standard/iho:annex">
					<fo:page-sequence master-reference="document">
						<fo:static-content flow-name="xsl-footnote-separator">
							<fo:block>
								<fo:leader leader-pattern="rule" leader-length="30%"/>
							</fo:block>
						</fo:static-content>
						<xsl:call-template name="insertHeaderFooter"/>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container>								
								<xsl:apply-templates select="/*/*[local-name()='annex']"/>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
				</xsl:if>
				
				<xsl:if test="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]">
					<fo:page-sequence master-reference="document">
						<fo:static-content flow-name="xsl-footnote-separator">
							<fo:block>
								<fo:leader leader-pattern="rule" leader-length="30%"/>
							</fo:block>
						</fo:static-content>
						<xsl:call-template name="insertHeaderFooter"/>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container>								
								<!-- Bibliography -->
								<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]"/>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
				</xsl:if>
				
				
				
				<!-- =========================== -->
				<!-- End Document Pages -->
				<!-- =========================== -->
				<!-- =========================== -->
				
			</fo:root>
		</xsl:variable>
		
		<xsl:apply-templates select="xalan:nodeset($xslfo)" mode="step2"/>
		
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">		
		<xsl:apply-templates mode="contents"/>			
	</xsl:template>

	<!-- element with title -->
	<xsl:template match="*[iho:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="iho:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &lt;= 2">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::iho:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::iho:term">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::iho:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::iho:annex">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents"/>
			</item>
			
		</xsl:if>	
		
	</xsl:template>
	

	<xsl:template match="iho:references/iho:bibitem" mode="contents"/>	
	<!-- ============================= -->
	<!-- END CONTENTS                                 -->
	<!-- ============================= -->
	<!-- ============================= -->
	
	

	
	<xsl:template match="/iho:iho-standard/iho:bibdata/iho:edition">
		<xsl:variable name="title-edition">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-edition'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$title-edition"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="iho:feedback-statement//iho:br" priority="2">
		<fo:block/>
	</xsl:template>
	
	
	<xsl:template match="node()">		
		<xsl:apply-templates/>			
	</xsl:template>
	

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="iho:annex/iho:title">
		<fo:block font-size="13pt" font-weight="bold" text-align="center" margin-bottom="12pt" keep-with-next="always">			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="iho:bibliography/iho:references[not(@normative='true')]/iho:title">
		<fo:block font-size="16pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="iho:title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
	
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">13pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>				
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
	
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>			
			<xsl:attribute name="space-before">
				<xsl:choose>
					<xsl:when test="$level = 1">13.5pt</xsl:when>
					<xsl:when test="$level &gt;= 2">3pt</xsl:when>
					<xsl:when test="ancestor::iho:preface">8pt</xsl:when>
					<xsl:when test="$level = 2 and ancestor::iho:annex">18pt</xsl:when>
					<xsl:when test="$level = 1">18pt</xsl:when>
					<xsl:when test="$level = ''">6pt</xsl:when><!-- 13.5pt -->
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			
			<xsl:apply-templates/>
		</xsl:element>
		
		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::iho:p)">
			<fo:block> <!-- margin-bottom="12pt" -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	
	<xsl:template match="iho:p">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="ancestor::iho:quote">justify</xsl:when>
					<xsl:when test="ancestor::iho:feedback-statement">right</xsl:when>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::iho:td/@align"><xsl:value-of select="ancestor::iho:td/@align"/></xsl:when>
					<xsl:when test="ancestor::iho:th/@align"><xsl:value-of select="ancestor::iho:th/@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:if test="parent::iho:dd">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[2][local-name() = 'license-statement'] and not(following-sibling::iho:p)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<!-- <xsl:attribute name="border">1pt solid red</xsl:attribute> -->
			
			<xsl:if test=".//iho:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				<!--  <xsl:if test="ancestor::iho:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if> -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->

	<xsl:variable name="p_fn">
		<!-- <xsl:for-each select="//iho:p/iho:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]"> -->
		<xsl:for-each select="//iho:fn[local-name(..) = 'p' or ancestor::*[local-name() = 'title']][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
			<!-- copy unique fn -->
			<fn gen_id="{generate-id(.)}">
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="node()"/>
			</fn>
		</xsl:for-each>
	</xsl:variable>
	
	<!-- iho:p/iho:fn -->
	<xsl:template match="iho:fn[local-name(..) = 'p' or ancestor::*[local-name() = 'title']]" priority="2">
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="reference" select="@reference"/>
		<xsl:variable name="number">
			<!-- <xsl:number level="any" count="iho:p/iho:fn"/> -->
			<xsl:value-of select="count(xalan:nodeset($p_fn)//fn[@reference = $reference]/preceding-sibling::fn) + 1"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="xalan:nodeset($p_fn)//fn[@gen_id = $gen_id]">
				<fo:footnote>
					<fo:inline font-size="70%" keep-with-previous.within-line="always" vertical-align="super"> <!--  -->
						<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
							<!-- <xsl:value-of select="@reference"/> -->
							<xsl:value-of select="$number + count(//iho:bibitem[ancestor::iho:references[@normative='true']]/iho:note)"/>
						</fo:basic-link>
					</fo:inline>
					<fo:footnote-body>
						<fo:block font-size="10pt" margin-bottom="12pt">
							<fo:inline id="footnote_{@reference}_{$number}" font-size="60%" vertical-align="super" keep-with-next.within-line="always" padding-right="1mm"> <!-- font-size="60%"  alignment-baseline="hanging" -->
								<xsl:value-of select="$number + count(//iho:bibitem[ancestor::iho:references[@normative='true']]/iho:note)"/>
							</fo:inline>
							<xsl:for-each select="iho:p">
									<xsl:apply-templates/>
							</xsl:for-each>
						</fo:block>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
					<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
						<xsl:value-of select="$number + count(//iho:bibitem/iho:note)"/>
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="iho:p/iho:fn/iho:p">
		<xsl:apply-templates/>
	</xsl:template>

	
	<xsl:template match="iho:ul | iho:ol" mode="ul_ol">
		<fo:list-block provisional-distance-between-starts="6mm">
			<xsl:apply-templates/>
		</fo:list-block>
		<xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="iho:ul//iho:note |  iho:ol//iho:note" priority="2"/>
	<xsl:template match="iho:ul//iho:note  | iho:ol//iho:note" mode="process">
		<fo:block id="{@id}">
			<xsl:apply-templates select="iho:name" mode="presentation"/>
			<xsl:apply-templates mode="process"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="iho:ul//iho:note/iho:name  | iho:ol//iho:note/iho:name" mode="process" priority="2"/>
	<xsl:template match="iho:ul//iho:note/iho:p  | iho:ol//iho:note/iho:p" mode="process" priority="2">		
		<fo:block font-size="11pt" margin-top="4pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="iho:ul//iho:note/* | iho:ol//iho:note/*" mode="process">		
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	
	<xsl:template match="iho:li">
		<fo:list-item id="{@id}" margin-bottom="12pt">
			<fo:list-item-label end-indent="label-end()">
				<fo:block line-height="115%">
					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:apply-templates/>
					<xsl:apply-templates select=".//iho:note" mode="process"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="iho:li//iho:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	
	
	<xsl:template match="iho:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">					
					<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>		
	</xsl:template>


	<xsl:template match="iho:formula/iho:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt" text-align="center">
			<xsl:apply-templates/>						
		</fo:block>
	</xsl:template>
	

		
	<xsl:template match="iho:references"><!-- [position() &gt; 1] -->
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		
	
	<!-- IHO documents:
			"[1] S57 edition 3.1: IHO Transfer Standard for Digital Hydrographic Data, International Hydrographic Organization (www.iho.int)”
			[{number}] {docID} edition {edition}: {title}, {author/organization}
			
			Non-IHO documents:
			Provide title and publisher -->
	<xsl:template match="iho:bibitem">
		<fo:list-block margin-bottom="12pt" provisional-distance-between-starts="12mm" line-height="115%">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:call-template name="processBibitem"/>						
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>	
	
	<xsl:template match="iho:bibitem/iho:edition">
		<xsl:text> edition </xsl:text>
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="iho:bibitem/iho:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iho:bibitem/iho:uri">
		<xsl:text> (</xsl:text>
		<fo:inline xsl:use-attribute-sets="link-style">
			<fo:basic-link external-destination="." fox:alt-text=".">
				<xsl:value-of select="."/>							
			</fo:basic-link>
		</fo:inline>
		<xsl:text>)</xsl:text>
	</xsl:template>
	
	<xsl:template match="iho:bibitem/iho:note" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="iho:bibitem/iho:note"/>
			</xsl:variable>
			<fo:inline font-size="8pt" keep-with-previous.within-line="always" baseline-shift="30%"> <!--85% vertical-align="super"-->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><xsl:text>)</xsl:text>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="4pt" start-indent="0pt">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" alignment-baseline="hanging" padding-right="3mm"><!-- font-size="60%"  -->
						<xsl:value-of select="$number"/><xsl:text>)</xsl:text>
					</fo:inline>
					<xsl:apply-templates/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="iho:example/iho:p" priority="2">
			<fo:block-container xsl:use-attribute-sets="example-p-style">
				<fo:block-container margin-left="0mm">
					<fo:block>
						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
	</xsl:template>


	
	<xsl:template match="iho:pagebreak">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- https://github.com/metanorma/mn-native-pdf/issues/214 -->
	<xsl:template match="iho:index"/>
	
	
	<xsl:template match="iho:preferred">

		<fo:block line-height="1.1">
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates select="ancestor::iho:term/iho:name" mode="presentation"/>				
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>
	



	<xsl:template name="insertHeaderFooter">		
		<xsl:param name="font-weight" select="'bold'"/>				
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="100%">
				<fo:block padding-top="12.5mm" text-align="right">
					<xsl:value-of select="$docidentifier"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container height="100%" margin-right="-10mm" display-align="after">
				<fo:block-container margin-right="0mm">
					<fo:block padding-bottom="17mm" font-size="10pt" text-align-last="justify">
						<fo:inline><xsl:value-of select="$copyrightText"/></fo:inline>
						<fo:inline keep-together.within-line="always">
							<fo:leader leader-pattern="space"/>
							<fo:inline font-weight="{$font-weight}"><fo:page-number/></fo:inline>
						</fo:inline>						
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even">
			<fo:block-container height="100%">
				<fo:block padding-top="12.5mm">
					<xsl:value-of select="$docidentifier"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even">
			<fo:block-container height="100%" margin-right="-10mm" display-align="after">
				<fo:block-container margin-right="0mm">
					<fo:block padding-bottom="17mm" font-size="10pt" text-align-last="justify">
						<fo:inline font-weight="{$font-weight}"><fo:page-number/></fo:inline>
						<fo:inline keep-together.within-line="always">
							<fo:leader leader-pattern="space"/>
							<xsl:value-of select="$copyrightText"/>
						</fo:inline>							
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	
	<xsl:template name="getListItemFormat">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">—</xsl:when> <!-- dash -->
			<xsl:otherwise> <!-- for ordered lists -->
				<xsl:choose>
					<xsl:when test="../@type = 'arabic'">
						<xsl:number format="a)" lang="en"/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet'">
						<xsl:number format="a)" lang="en"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="step2">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="step2"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="iho:pagebreak" mode="step2">	
	
		<!-- determine pagebreak is last element before </fo:flow> or not -->
		<xsl:variable name="isLast">
			<xsl:for-each select="ancestor-or-self::*[ancestor::fo:flow]">					
				<xsl:if test="following-sibling::*">false</xsl:if>
			</xsl:for-each>
		</xsl:variable>
	
		<xsl:if test="contains($isLast, 'false')">
	
			<xsl:variable name="orientation" select="normalize-space(@orientation)"/>
			<xsl:variable name="tree">
				<xsl:for-each select="ancestor::*[ancestor::fo:flow]">
					<element pos="{position()}">					
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:variable>
			
			<!-- close fo:page-sequence (closing preceding fo elements) -->
			<xsl:for-each select="xalan:nodeset($tree)//element">
				<xsl:sort data-type="number" order="descending" select="@pos"/>
				<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
					<xsl:value-of select="."/>				
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:for-each>
			<xsl:text disable-output-escaping="yes">&lt;/fo:flow&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;/fo:page-sequence&gt;</xsl:text>
			
			<!-- <pagebreak/> -->
			<!-- create a new fo:page-sequence (opening fo elements) -->
			
			<xsl:text disable-output-escaping="yes">&lt;fo:page-sequence master-reference="document</xsl:text><xsl:if test="$orientation != ''">-<xsl:value-of select="$orientation"/></xsl:if><xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
			<fo:static-content flow-name="xsl-footnote-separator">
				<fo:block>
					<fo:leader leader-pattern="rule" leader-length="30%"/>
				</fo:block>
			</fo:static-content>
			<xsl:call-template name="insertHeaderFooter"/>					
			<xsl:text disable-output-escaping="yes">&lt;fo:flow flow-name="xsl-region-body"&gt;</xsl:text>	
			
			<xsl:for-each select="xalan:nodeset($tree)//element">
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
					<xsl:value-of select="."/>
					<xsl:for-each select="@*[local-name() != 'pos']">
						<xsl:text> </xsl:text>
						<xsl:value-of select="local-name()"/>
						<xsl:text>="</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>"</xsl:text>
					</xsl:for-each>				
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:variable name="Image-IHO">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAOEAAADfCAIAAACPoSPwAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAh1QAAIdUBBJy0nQAAEYdJREFUeAHtnQlsHNUZx3dmba+9dmzHtxMntusEJ04IBJKQkEASVGhLqUI5SgGVVlSVKIKGCqoiaKWiFrVUasvVU1BatbSlFEGRAAEiKKTkgIQckMOJncN2Dl/xsWt7N7sz02/jxnm2d+3vjXf9nst/ZFlvZ7553ze/7z/3e2+MR/fvffjj3R7T9GACAS0JQJpapgVBCQSgUQEGiloSgEa1TAuCEghAowIMFLUkAI1qmRYEJRCARgUYKGpJABrVMi0ISiAAjQowUNSSADSqZVoQlEAAGhVgoKglAWhUy7QgKIEANCrAQFFLAtColmlBUAIBaFSAgaKWBKBRLdOCoAQC0KgAA0UtCUCjWqYFQQkEoFEBBopaEoBGtUwLghIIQKMCDBS1JACNapkWBCUQgEYFGChqSQAa1TItCEogAI0KMFDUkgA0qmVaEJRAABoVYKCoJQFoVMu0ICiBADQqwEBRSwLQqJZpQVACAWhUgIGilgSgUS3TgqAEAtCoAANFLQlAo1qmBUEJBKBRAQaKWhKARrVMC4ISCECjAgwUtSQAjWqZFgQlEIBGBRgoakkAGtUyLQhKIACNCjBQ1JIANKplWhCUQAAaFWCgqCUBaFTLtCAogQA0KsBAUUsC0KiWaUFQAgFoVICBopYEoFEt04KgBALQqAADRS0JQKNapgVBCQSgUQEGiloSgEa1TAuCEghAowIMFLUkAI1qmRYEJRCARgUYKGpJABrVMi0ISiAAjQowUNSSADSqZVoQlEAAGhVgoKglAWhUy7QgKIEANCrAQFFLAtColmlBUAIBaFSAgaKWBKBRLdOCoAQC0KgAA0UtCUCjWqYFQQkEoFEBBopaEoBGtUwLghIIQKMCDBS1JACNapkWBCUQgEYFGChqSQAa1TItCEogAI0KMFDUkgA0qmVaEJRAABoVYKCoJQFoVMu0ICiBADQqwEBRSwLQqJZpQVACAWhUgIGilgSgUS3TgqAEAmlCGcWpScBxhsVtGMN+Tv0f0OhUyyEp0rE9g7I0DJ/X609LSzuny7BtBy3Ltqz/bRXNH/ybalspxquNRm1bDItVNhNcqMSyOPzQwqkuUW1x13XhYoJaIY+EyDRm+LIuzMurm5Z7UV5ecZa/LMM3PT09PRa8Q3rss6KdkUhbOHyyr++D3u6G3t49gd6ecDi2EWRzTspxt0nbmRpo1HEKfL7fLLyIDgl8TH3R6P17P24Nh0Zyt621JWXrq2v4IqVT447urp8cPOAwU2hbt8+qvHlGhZSLDW2tTx5t9BgJ9qsxtvzs3vuZ7Jzrysq/UFZ+aUFBcWbWGOZDi+7ykKrt4/39/+nseO3kibfbTrWFQqRyNzEMVaqioIFGPR6/13tTVbWXKZGzmCKW9eiBfa2jkTlOdc60dbMrRy8ZY06Rz0caHcNg2CLHWTy9QNZFxLafPNLgkbpWJHUaxhXFJd+qrP7SjJn5Pt+wMBg/TNOclZNzK/1VVrX0BV9saX7myOF9vT1T65iqhUbpgBSyrOw0iWDIPtHFgSV/oqfLOEbGz5uQ4M7/4JXOSK1y9sy+pKDwB/PqrptZIbX3JgqnIjvnu7Xzv1ld89zRw786VH+sL+jxSgBPVO0kzJc/9UxCUJ9yF7adl5b20wsv2rjmqnUVs5Ii0CGiuRkZ6y+Yt3Xt1XdW18Su2uX356GqJq0AjU4aap4jy1qcm/f6qtUPzl/gT0vnrSNtVeb3P7t0+d+XrijP8MVuxfSeoFGd8mNZ182Y+dbqtZcXFU9CWF+trHzrijV1ubke+9yzqknwKu8CGpVnlqI1LOvG2VX/WL6yiHfbnpQoFk6f/vqqNZcUFHmGHqkmpd6kVgKNJhWn68os64ZZs/+yZJnUjaNrb+KKldnZ/16xamF+vrYnfWhUzJeismWtLip+7tJlWTJPNpIYa4Xf/89lKyro+K3ltSk0msRcu6rKcWbE7mAuoztuV+snZ6X5+dOfvmRJhtTLtuR4Hr8WaHR8Rim2cB5ftLhmWm6KvYxf/bqZFd+pmavhhSk0On7yUmhhWbfMnHXTrNkpdCFT9cPzF9TlandhCo3K5DDJtk5eRsYjdQsNmZfAo0M4HQ7Xd3fv7uw8HOgNRCKjDfhz6HXrI3V1Uu9r+ZW7tpwab8Ncb57WK1rWHdU1tXn57oIMRiIvtzTRK/jtPT29kTP0BphaPxVlZKwqLPra7Kqry8pHtrbhubm+Yvbaw40b2tti7/T1mKBRZXnIy8hcP7fWnft3T5383p5d1FwrtvqgmAwjFI0GotEjwaPPNzdRI6mfL1pcS8/nJac007y3Zu677W38Vl2SHqTNddlXpAOf6itY1rVl5e5ulZ5tbLh286YdPd0eas1If3SpMHi1MFjwem3DePXE8bXvbXivLU7LsHHJXVNeXpebp89zKGh03JSlxMBrml+vrHJR9UstTXft3B6iB5ljn4u93pMDAzdv23Kgp0fWC7UTuGlmhT7NTaBR2Qwmw54auWZnrywqkq2rqS94366PotRYiXObZZptA/1379oeln/P+eWZFRmKXiiMZgKNxpjYjuNQItl/MZVMZLLt1UUlOenSD+1/dmBfS3/fOEdQMTCv993W1heajonzOOW6vPwF2pzucc8USxk1rfjb8ss5ySMb0vPF+QVM4/hmhnFVsXTLpqPB4PMtzR5TokdNzLthPN546JbZlVJdcegRwaqCwp2nO+PHP7lzodEY77Is/62V1ZNGPt3rvXh6oay7V0+09FKHJNlTsGl+0t31YWfHqpJSKY8rCoueajgotUqKjHGuTxHYxNU69hy/vyqL1W9uqBa6tnjj1MlYjzn5iXq2vN16Sna9Rbm5/vRUNbKWCgYalcKVDGPbKcry+yVbkJwODeymO3QX3UopZMPY0nVa9j69zJ+dQxqd4JV3MoBBo8mgKFnHPL9fcg3Pkb6+rjNh1u386KoNozEY6JF8TZqXnj7LlwmNjsb5qZhTmSWt0aaBAeoK65KOYRwPhztJ4jITvXCqgEZliP1f2broKd85MDARBJZtdw+OViJTS65P+umYTPVcW5zruaSSaEfvLmVrC0+sWxx1/eyPRmWd+mSfc8k64NlDozxOybRyXByfOkJyZ+rR8UrvFvQkeHQtKuZAowqoRxKOsZIwmAzvpzdTn94tTyiHlC8wBuRPuwWSz6pGb4TJecU/ejUN5kCjCpIQtqQvDWOPKicw0YA8Lvr0BSJnJuAzaatCo0lDya+og15pSk4lWdkuH46SI8fJ8qbJPkygZgld4TPunUpu4Bjm0OgYcFK1qKG/X7bqGn9WHrWTcvnWx5mblUXdSKSc0uPYxlC/DhpFm5JY4o4FAi81H+O1yvTQs8YrS0svKy6RSvl5Y8M4Fuqn1oBSF4g0MmN5ZmZPwNWBzXaowb9PciTH0+FQt+SrqfPbmNQSNBrDeSjQe//Hu7nHDCv6Y2PxhDTa19ceGiiVedtELetWFxYdoOFtXU2fk2z0RE4OBoO9Z1ztEq4iHGMlnOtjcOiQZgz2DeL9p/eEYzAdZ5FhnAqHG4PBccxGLaYxGrh7kbiu4+T5fGtLy8R5nPKe7u6oHkPrTIA1Z0NhE5eAbb/X3h53yRgz15SULnYxcpht3VA2ozonZ4ya4y7a2CEdYdx6Jj4TGp04Q/kaDGNDe6vsWxwasez+ObVyt02OQz1S7rtAuod0Vzi8vfu0RKcUeQb8NaBRPqvkWZrG1u4uGlZEtsavVFZ9ccZMD//xqmU9cMG8RdOle7Zs7mhvpocPejz2h0ZldZIUeyMQDr9+8oRsXdTN6NlLlq4sLGaNHBaN3lFZ9dC8BbJeyP6vzcfkDtgufLBXgUbZqJJraBp/bjrmoldxqd//rxWrrqF7IHqhSh+8izvZtmnb98yZ+/sll6XLv+g/Ggi8SX1LJnJfGDcqtzOhUbfkJrieYe7o6nqTuijJT/TFhVdWXvn4xUvmZk+LjSZCp35q/kyN9+h/NGo6ztKCwheXr3zq0mWZsh30zgbzzNHDdD2qyYmeIsLzUXmNJG0N5xcH6+nTddRNVLZKun9aX1v7jerqTe1t2zo76GNLEZteeJpzcvNoTLLlxSWuR7ul7+L94egRfQ6i0KisNpJqb5qbOtpebG66rcplt2kaGpK+MEZ/SQzrl/X72wf6Y8NIaTPhXK8yFfSF0h/t/6RTvolJioLe2t7+uyONWgmUthQaTVG6edUaxqFA4Pv0GlaDqTcSuXfPR/38B1uTFTM0OlmkE/nxeukDns8dbki0fLLmOw/t2bW9s1N6rJ7UxweNpp7xeB5ouNB7du98R34okfEqllj+WP2BX9N+otNl6FD00OgQCnUFw+i3rNu3bd5KI3yrmP7Y2PDDT/bo87BpBANodAQQRT8NozUcvmHL+xtcPTGdSNC/PXTw2zt3RJhjmk7Ek9t1oVG35JK+nmmeDIdu3Pr+n+jOelKmiGU9uGfX3bt3nKFeynq8mo+73dBoXCyKZppmdzR6544P7/tou4thRaSCPtTbu27zpscO7IuNc6axQGmjoFGpzKbe2DDooekTDQfXbHzn1ZamVPijntNPH6pfvfGdN6hRi5Y3SSO2Wpd3obKjaMjaj9jsET9la5O1J3dyq3i9NJLj9Vvfv7bsyANza1eXlE7wO2OD29sfibxyvOWJhvoPTp9tGzoVBEqR66JRm9pG2Daz2S/lm+wTGtPlP3W8ZXehpNGX6ANcI1Q79s9Y5VIuDIM62Y1d58ilpkkrvHbiOA2Nu7ao+LbZVZ8vK6ev34404/x2nPpA78vHW15obtrVQ590MqbE4XNoy4xH9+99mN5zKG2I5TPN5Xn5NE7BUFjjFqgJxYe93bFPwIyYHIf6Ty7InmazRysijbafCe8JBkbUlPCn49TEBmLOJp0mtBm+gFycDA/s6+sbPpv9izbTcYqzslYUFH62qGRJYeHc7JyCzMwxepbS2M30UZH6YHBLRzt9EGxbd1dwsAOd0kSzN3iYoRYajUU0Wm3D4oz3IxHuswe5eCsknkd7h9QQyW5ckFAldsI4sZLTQUo0MmhmFvWkm+/3U2HauREYqXbL8fSEQ0f6B6hrfFco3BoOxZoqk9/BvziVToFZupzrk3kgn4R8TIKL0eIhp+euIFtCAy0D/Xupy1HsUD7icH5uZyD7RLvx6Mo1nqONRjVmpGNoSnYSRSDw7EkReLhlE4BG2ahgqIgANKoIPNyyCUCjbFQwVEQAGlUEHm7ZBKBRNioYKiIAjSoCD7dsAtAoGxUMFRGARhWBh1s2AWiUjQqGighAo4rAwy2bADTKRgVDRQSgUUXg4ZZNABplo4KhIgLQqCLwcMsmAI2yUcFQEQFoVBF4uGUTgEbZqGCoiAA0qgg83LIJQKNsVDBURAAaVQQebtkEoFE2KhgqIgCNKgIPt2wC0CgbFQwVEYBGFYGHWzYBaJSNCoaKCECjisDDLZsANMpGBUNFBKBRReDhlk0AGmWjgqEiAtCoIvBwyyYAjbJRwVARAWhUEXi4ZROARtmoYKiIADSqCDzcsglAo2xUMFREABpVBB5u2QSgUTYqGCoiAI0qAg+3bALQKBsVDBURgEYVgYdbNgFolI0KhooIQKOKwMMtmwA0ykYFQ0UEoFFF4OGWTQAaZaOCoSIC0Kgi8HDLJgCNslHBUBEBaFQReLhlE4BG2ahgqIgANKoIPNyyCUCjbFQwVEQAGlUEHm7ZBKBRNioYKiIAjSoCD7dsAtAoGxUMFRGARhWBh1s2AWiUjQqGighAo4rAwy2bADTKRgVDRQSgUUXg4ZZNABplo4KhIgLQqCLwcMsmAI2yUcFQEQFoVBF4uGUTgEbZqGCoiAA0qgg83LIJQKNsVDBURAAaVQQebtkEoFE2KhgqIgCNKgIPt2wC0CgbFQwVEYBGFYGHWzYBaJSNCoaKCECjisDDLZsANMpGBUNFBKBRReDhlk0AGmWjgqEiAtCoIvBwyyYAjbJRwVARAWhUEXi4ZRP4L/81MZBcCh3tAAAAAElFTkSuQmCC</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Logo-IHO">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Text-IHO">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
<xsl:variable name="titles" select="xalan:nodeset($titles_)"/><xsl:variable name="titles_">
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		
			<title-annex lang="zh">Annex </title-annex>
		
		
				
		<title-edition lang="en">
			
				<xsl:text>Edition </xsl:text>
			
			
		</title-edition>
		
		<title-edition lang="fr">
			
				<xsl:text>Édition </xsl:text>
			
		</title-edition>
		

		<title-toc lang="en">
			
				<xsl:text>Contents</xsl:text>
			
			
			
		</title-toc>
		<title-toc lang="fr">
			
				<xsl:text>Sommaire</xsl:text>
			
			
			</title-toc>
		
			<title-toc lang="zh">Contents</title-toc>
		
		
		
		<title-page lang="en">Page</title-page>
		<title-page lang="fr">Page</title-page>
		
		<title-key lang="en">Key</title-key>
		<title-key lang="fr">Légende</title-key>
			
		<title-where lang="en">where</title-where>
		<title-where lang="fr">où</title-where>
					
		<title-descriptors lang="en">Descriptors</title-descriptors>
		
		<title-part lang="en">
			
			
			
		</title-part>
		<title-part lang="fr">
			
			
			
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-subpart lang="en">			
			
		</title-subpart>
		<title-subpart lang="fr">		
			
		</title-subpart>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		
			<title-modified lang="zh">modified</title-modified>
		
		
		
		<title-source lang="en">
			
				<xsl:text>SOURCE</xsl:text>
						
			 
		</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
				
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
		<title-partly-supercedes lang="en">Partly Supercedes </title-partly-supercedes>
		<title-partly-supercedes lang="zh">部分代替 </title-partly-supercedes>
		
		<title-completion-date lang="en">Completion date for this manuscript</title-completion-date>
		<title-completion-date lang="zh">本稿完成日期</title-completion-date>
		
		<title-issuance-date lang="en">Issuance Date: #</title-issuance-date>
		<title-issuance-date lang="zh"># 发布</title-issuance-date>
		
		<title-implementation-date lang="en">Implementation Date: #</title-implementation-date>
		<title-implementation-date lang="zh"># 实施</title-implementation-date>

		<title-obligation-normative lang="en">normative</title-obligation-normative>
		<title-obligation-normative lang="zh">规范性附录</title-obligation-normative>
		
		<title-caution lang="en">CAUTION</title-caution>
		<title-caution lang="zh">注意</title-caution>
			
		<title-warning lang="en">WARNING</title-warning>
		<title-warning lang="zh">警告</title-warning>
		
		<title-amendment lang="en">AMENDMENT</title-amendment>
		
		<title-continued lang="en">(continued)</title-continued>
		<title-continued lang="fr">(continué)</title-continued>
		
	</xsl:variable><xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']"/>
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']"/>
	</xsl:variable><xsl:variable name="tab_zh">　</xsl:variable><xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable><xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable><xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/><xsl:variable name="linebreak" select="'&#8232;'"/><xsl:attribute-set name="root-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="link-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		
		
		
		
		
				
		
		
		
			<xsl:attribute name="font-family">Fira Code</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="permission-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-subject-style">
	</xsl:attribute-set><xsl:attribute-set name="requirement-inherit-style">
	</xsl:attribute-set><xsl:attribute-set name="recommendation-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-name-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-style">
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		
		
		

	</xsl:attribute-set><xsl:attribute-set name="example-style">
		
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-body-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-name-style">
		
		
		
		
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		
		
		
		
		
		
		
				
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-p-style">
		
		
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.7mm</xsl:attribute>			
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-name-style">
		
		
		
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		
				
				
	</xsl:attribute-set><xsl:variable name="table-border_">
		
	</xsl:variable><xsl:variable name="table-border" select="normalize-space($table-border_)"/><xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
			
		
		
		
		
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		
				
		
		
		
				
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="table-footer-cell-style">
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-example-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="xref-style">
		
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="eref-style">
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-style">
		
		
		
		
				
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:variable name="note-body-indent">10mm</xsl:variable><xsl:variable name="note-body-indent-table">5mm</xsl:variable><xsl:attribute-set name="note-name-style">
		
		
		
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-p-style">
		
		
		
				
					
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>			
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-style">
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-name-style">		
		
				
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-style">		
		
		
		
		
					
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">14mm</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-source-style">		
		
		
			<xsl:attribute name="text-align">right</xsl:attribute>			
				
				
	</xsl:attribute-set><xsl:attribute-set name="termsource-style">
		
		
		
		
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="origin-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="term-style">
		
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="figure-name-style">
		
		
				
		
		
		
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
		
		
		
		
		
		

		
		
		
			
	</xsl:attribute-set><xsl:attribute-set name="formula-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="figure-pseudocode-p-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-graphic-style">
		
		
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		
		
		
				

	</xsl:attribute-set><xsl:attribute-set name="tt-style">
		
		
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="domain-style">
				
	</xsl:attribute-set><xsl:attribute-set name="admitted-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="deprecates-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="definition-style">
		
		
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable><xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set><xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable><xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set><xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="list-style">
		
	</xsl:attribute-set><xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable><xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable><xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
	</xsl:template><xsl:template name="processMainSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" mode="contents"/>			
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |   /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]" mode="contents"/>	
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" mode="contents"/>		
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']" mode="contents"/>		
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')] |       /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]" mode="contents"/>
		
	</xsl:template><xsl:template name="processPrefaceSectionsDefault">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']"/>
	</xsl:template><xsl:template name="processMainSectionsDefault">			
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']"/>
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']"/>
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]"/>
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']"/>
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]"/>
	</xsl:template><xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template><xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<!-- <xsl:call-template name="add-zero-spaces"/> -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template><xsl:template match="*[local-name()='table']" name="table">
	
		<xsl:variable name="table-preamble">
			
			
		</xsl:variable>
		
		<xsl:variable name="table">
	
			<xsl:variable name="simple-table">	
				<xsl:call-template name="getSimpleTable"/>
			</xsl:variable>
		
			<!-- <xsl:if test="$namespace = 'bipm'">
				<fo:block>&#xA0;</fo:block>
			</xsl:if> -->
			
			
			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
					
			
				<xsl:call-template name="fn_name_display"/>
			
				
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>
			
			<!-- <xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="*[local-name()='thead']">
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> -->
			<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
			<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
			
			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
			
			<!-- <xsl:variable name="colwidths2">
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:call-template>
			</xsl:variable> -->
			
			<!-- cols-count=<xsl:copy-of select="$cols-count"/>
			colwidthsNew=<xsl:copy-of select="$colwidths"/>
			colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
			
			<xsl:variable name="margin-left">
				<xsl:choose>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
				
				
				
							
							
							
				
				
										
				
				
				
				
				
					<xsl:attribute name="space-after">18pt</xsl:attribute>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				
				
				
				
				
				
				
				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->
				
				
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					100%
							
					
				</xsl:variable>
				
				<xsl:variable name="table_attributes">
					<attribute name="table-layout">fixed</attribute>
					<attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></attribute>
					<attribute name="margin-left"><xsl:value-of select="$margin-left"/>mm</attribute>
					<attribute name="margin-right"><xsl:value-of select="$margin-left"/>mm</attribute>
					
					
					
					
					
					
					
									
									
									
									
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>
					
									
					
					
				</xsl:variable>
				
				
				<fo:table id="{@id}" table-omit-footer-at-break="true">
					
					<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">					
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
					</xsl:if>
					
					
					
					<xsl:choose>
						<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
							<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="xalan:nodeset($colwidths)//column">
								<xsl:choose>
									<xsl:when test=". = 1 or . = 0">
										<fo:table-column column-width="proportional-column-width(2)"/>
									</xsl:when>
									<xsl:otherwise>
										<fo:table-column column-width="proportional-column-width({.})"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
							<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:table>
				
				<xsl:variable name="colgroup" select="*[local-name()='colgroup']"/>				
				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>				
						<xsl:with-param name="colgroup" select="$colgroup"/>				
					</xsl:call-template>
				</xsl:for-each>
				
				<!-- insert footer as table -->
				<!-- <fo:table>
					<xsl:for-each select="xalan::nodeset($table_attributes)/attribute">
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:for-each select="xalan:nodeset($colwidths)//column">
						<xsl:choose>
							<xsl:when test=". = 1 or . = 0">
								<fo:table-column column-width="proportional-column-width(2)"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:table-column column-width="proportional-column-width({.})"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</fo:table>-->
				
				
				
				
				
			</fo:block-container>
		</xsl:variable>
		
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<xsl:choose>
			<xsl:when test="@width">
	
				<!-- centered table when table name is centered (see table-name-style) -->
				
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{@width}"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<xsl:copy-of select="$table-preamble"/>
									<fo:block>
										<xsl:call-template name="setTrackChangesStyles">
											<xsl:with-param name="isAdded" select="$isAdded"/>
											<xsl:with-param name="isDeleted" select="$isDeleted"/>
										</xsl:call-template>
										<xsl:copy-of select="$table"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				
				
				
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name() = 'name']"/><xsl:template match="*[local-name()='table']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="continued"/>
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="table-name-style">
				
				
				
				
				
				<xsl:choose>
					<xsl:when test="$continued = 'true'"> 
						<!-- <xsl:if test="$namespace = 'bsi'"></xsl:if> -->
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template><xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
							
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($table)/*/tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
								
								<!-- <xsl:if test="$namespace = 'bipm'">
									<xsl:for-each select="*[local-name()='td'][$curr-col]//*[local-name()='math']">									
										<word><xsl:value-of select="normalize-space(.)"/></word>
									</xsl:for-each>
								</xsl:if> -->
								
							</xsl:variable>
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​', ' '))"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>
							
						</xsl:for-each>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="text()" mode="td_text">
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:value-of select="translate(., $zero-space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template><xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template><xsl:template match="*[local-name()='math']" mode="td_text">
		<xsl:variable name="mathml">
			<xsl:for-each select="*">
				<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="math_text" select="normalize-space(xalan:nodeset($mathml))"/>
		<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
	</xsl:template><xsl:template match="*[local-name()='table2']"/><xsl:template match="*[local-name()='thead']"/><xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>
			
			
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template><xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">
				
				<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']" mode="presentation">
					<xsl:with-param name="continued">true</xsl:with-param>
				</xsl:apply-templates>
				
				
				
				
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tfoot']"/><xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooter2">
		<xsl:param name="cols-count"/>
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		<xsl:if test="../*[local-name()='tfoot'] or           $isNoteOrFnExist = 'true'">
		
			<fo:table-footer>
			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
				
				<!-- if there are note(s) or fn(s) then create footer row -->
				<xsl:if test="$isNoteOrFnExist = 'true'">
				
					
				
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							<!-- except gb -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- show Note under table in preface (ex. abstract) sections -->
							<!-- empty, because notes show at page side in main sections -->
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">										
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>										
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
					
				</xsl:if>
			</fo:table-footer>
		
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		
		<xsl:variable name="isNoteOrFnExistShowAfterTable">
			
		</xsl:variable>
		
		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">
		
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//*[local-name()='col'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:table keep-with-previous="always">
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">
					<xsl:choose>
						<xsl:when test="@name = 'border-top'">
							<xsl:attribute name="{@name}">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:when test="@name = 'border'">
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				
				
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:for-each select="xalan:nodeset($colgroup)//*[local-name()='col']">
							<fo:table-column column-width="{@width}"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							
							
							
							<!-- for BSI (not PAS) display Notes before footnotes -->
							
							
							<!-- except gb  -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										show Note under table in preface (ex. abstract) sections
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										empty, because notes show at page side in main sections
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
							
							<!-- for PAS display Notes after footnotes -->
							
							
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
				
			</fo:table>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='tbody']">
		
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			

			<xsl:apply-templates/>
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='name']/text()[1]" priority="2" mode="presentation_name">
		<xsl:choose>
			<xsl:when test="substring-after(., '—') != ''">
				<xsl:text>—</xsl:text><xsl:value-of select="substring-after(., '—')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='name']" mode="presentation_name">
		<xsl:apply-templates mode="presentation_name"/>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='name']/node()" mode="presentation_name">
		<xsl:apply-templates select="."/>
	</xsl:template><xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					
					
					
					
					
					
					
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					
					
					
				</xsl:if>
				
				
				
				
				
				
				
				
				
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<xsl:attribute name="height">8mm</xsl:attribute>
				</xsl:if> -->
				
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>center</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
			
			
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>					
			</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			 <!--  and ancestor::*[local-name() = 'thead'] -->
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<xsl:if test=".//*[local-name() = 'table']">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
								
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2"/><xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				
				
				
				
				
					<xsl:attribute name="font-size">12pt</xsl:attribute>					
				
				
				
				
				<!-- Table's note name (NOTE, for example) -->

				<fo:inline padding-right="2mm">
					
				
					
					
						<xsl:attribute name="font-size">11pt</xsl:attribute>
						<xsl:attribute name="padding-right">3mm</xsl:attribute>
					
					
					
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				
				
				
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process"/><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="fn_display">
		<xsl:variable name="references">
			
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<xsl:call-template name="create_fn"/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
				
					
					
					
					
					
					
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						
						
						
						
						
						
						
						
						<xsl:value-of select="@reference"/>
						
						
						
					</fo:inline>
					<fo:inline>
						
						<!-- <xsl:apply-templates /> -->
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			
			
			<xsl:apply-templates/>
		</fn>
	</xsl:template><xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			 <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="doc_ns">
						
					</xsl:variable>
					<xsl:variable name="ns">
						<xsl:choose>
							<xsl:when test="normalize-space($doc_ns)  != ''">
								<xsl:value-of select="normalize-space($doc_ns)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before(name(/*), '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
					<!-- <xsl:element name="{$ns}:table"> -->
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					<!-- </xsl:element> -->
				</xsl:variable>
				
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="2"/>
					<xsl:with-param name="table" select="$html-table"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="maxlength_dt">
			<xsl:for-each select="*[local-name() = 'dl'][1]">
				<xsl:call-template name="getMaxLength_dt"/>			
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="xalan:nodeset($references)//fn">
			<fo:block>
				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>								
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="85%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											
											<!-- <xsl:apply-templates /> -->
											<xsl:copy-of select="./node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
		
	</xsl:template><xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			
			
			
			
			
			
			
			
			
			
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				
				
				<xsl:value-of select="@reference"/>
				
				
			</fo:basic-link>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='dl']">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container>
			
				<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			
			
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<fo:block-container>
				
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				
				
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
						
						
							<fo:block margin-bottom="12pt" text-align="left">
								
								<xsl:variable name="title-where">
									
									
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-where'"/>
										</xsl:call-template>
									
								</xsl:variable>
								<xsl:value-of select="$title-where"/><xsl:text> </xsl:text>
								<xsl:apply-templates select="*[local-name()='dt']/*"/>
								<xsl:text/>
								<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
							</fo:block>
						
					</xsl:when>
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">
							
							
							
							
							<xsl:variable name="title-where">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-where'"/>
									</xsl:call-template>
																
							</xsl:variable>
							<xsl:value-of select="$title-where"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
							
							
							
							
							<xsl:variable name="title-key">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-key'"/>
									</xsl:call-template>
								
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
					<fo:block>
						
						
						
						
							<xsl:attribute name="margin-left">7mm</xsl:attribute>
						
						<fo:block>
							
							
							
								<xsl:attribute name="margin-left">-3.5mm</xsl:attribute>
							
							
							<fo:table width="95%" table-layout="fixed">
								
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'">
										<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
									</xsl:when>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
										
									</xsl:when>
								</xsl:choose>
								<!-- create virtual html table for dl/[dt and dd] -->
								<xsl:variable name="html-table">
									<xsl:variable name="doc_ns">
										
									</xsl:variable>
									<xsl:variable name="ns">
										<xsl:choose>
											<xsl:when test="normalize-space($doc_ns)  != ''">
												<xsl:value-of select="normalize-space($doc_ns)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-before(name(/*), '-')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
									<!-- <xsl:element name="{$ns}:table"> -->
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									<!-- </xsl:element> -->
								</xsl:variable>
								<!-- html-table<xsl:copy-of select="$html-table"/> -->
								<xsl:variable name="colwidths">
									<xsl:call-template name="calculate-column-widths">
										<xsl:with-param name="cols-count" select="2"/>
										<xsl:with-param name="table" select="$html-table"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
								<xsl:variable name="maxlength_dt">							
									<xsl:call-template name="getMaxLength_dt"/>							
								</xsl:variable>
								<xsl:call-template name="setColumnWidth_dl">
									<xsl:with-param name="colwidths" select="$colwidths"/>							
									<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
								</xsl:call-template>
								<fo:table-body>
									<xsl:apply-templates>
										<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
									</xsl:apply-templates>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="*[local-name()='dt']">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<!-- <xsl:for-each select="*[local-name()='dt']">
				<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="string-length(normalize-space(.))"/>
				</xsl:if>
			</xsl:for-each> -->
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template><xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates/>
			</td>
			<td>
				
				
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				
			</td>
		</tr>
		
	</xsl:template><xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			
			
			<fo:table-cell>
				
				<fo:block margin-top="6pt">
					
					
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						
					</xsl:if>
					
					
					
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					
					
					
					
					
					<xsl:apply-templates/>
					<!-- <xsl:if test="$namespace = 'gb'">
						<xsl:if test="ancestor::*[local-name()='formula']">
							<xsl:text>—</xsl:text>
						</xsl:if>
					</xsl:if> -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					
					<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if> -->
					
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<fo:table-row>
				<fo:table-cell>
					<fo:block margin-top="6pt">
						<xsl:if test="normalize-space($key_iso) = 'true'">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						<xsl:text>&#xA0;</xsl:text>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
		</xsl:if> -->
	</xsl:template><xsl:template match="*[local-name()='dd']" mode="dl"/><xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']"/><xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<fo:inline font-weight="bold">
			
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:variable name="_font-size">
				
				
				
				
				10
				
				
				
				
				
				
				
				
				
				
						
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='add']">
		<xsl:choose>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-20%"><!-- alignment-baseline="middle" -->
				<!-- <xsl:attribute name="width">7mm</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute> -->
				<xsl:attribute name="height">5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template><xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template><xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template><xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:variable name="len_str">
						<xsl:choose>
							<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
								<xsl:value-of select="$len_str_tmp * 1.5"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$len_str_tmp"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
					
					<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
						<xsl:message>
							div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
							len_str=<xsl:value-of select="$len_str"/>
							len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
						</xsl:message>
					</xsl:if> -->
					<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
					<len_str><xsl:value-of select="$len_str"/></len_str> -->
					<xsl:choose>
						<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
							<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$len_str"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| )','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| |,)','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">-</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template><xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template><xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/><xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@colspan" mode="simple-table-colspan"/><xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template><xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template><xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template><xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow"/>
		</xsl:apply-templates>
	</xsl:template><xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:when test="$language_current_2 != ''">
					<xsl:value-of select="$language_current_2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<!-- <xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>		
	</xsl:template><xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<fo:inline xsl:use-attribute-sets="mathml-style">
			
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				
				
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>			
		</fo:inline>
	</xsl:template><xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = ' '])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			<!-- if in msub, then don't add space -->
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"/>
			<!-- if next char in digit,  don't add space -->
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"/>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/><xsl:template match="*[local-name()='localityStack']"/><xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">
			
			
			
			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{$target}" fox:alt-text="{$target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<xsl:call-template name="add-zero-spaces-link-java">
									<xsl:with-param name="text" select="$target_text"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- output text from <link>text</link> -->
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/><xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'callout']">		
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template><xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>		
	</xsl:template><xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-modified'"/>
				</xsl:call-template>
			
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:text>—</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:text> — </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">	
				<fo:block id="{@id}" xsl:use-attribute-sets="formula-style">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">
			
			
			
			
			
			<fo:block-container margin-left="0mm">
				
				
				
				
				
				
					<xsl:if test="ancestor::iho:td">
						<xsl:attribute name="font-size">12pt</xsl:attribute>
					</xsl:if>
				

				
					<fo:block>
						
						
						
						
						
						
						<fo:inline xsl:use-attribute-sets="note-name-style">
							
							<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						</fo:inline>
						<xsl:apply-templates/>
					</fo:block>
				
				
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">						
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
				
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name'] |               *[local-name() = 'termnote']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'terms']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline>
				<xsl:apply-templates/>
				<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if> -->
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container id="{@id}">			
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<fo:block>
				
				<xsl:apply-templates/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			
			
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'image']">
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'title']">
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>
								
								
									<xsl:apply-templates select="." mode="cross_image"/>
									
							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style">
								<xsl:if test="not(@mimetype = 'image/svg+xml') and ../*[local-name() = 'name'] and not(ancestor::*[local-name() = 'table'])">
										
									<xsl:variable name="img_src">
										<xsl:choose>
											<xsl:when test="not(starts-with(@src, 'data:'))"><xsl:value-of select="concat($basepath, @src)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xsl:variable name="scale" select="java:org.metanorma.fop.Util.getImageScale($img_src, $width_effective, $height_effective)"/>
									<xsl:if test="number($scale) &lt; 100">
										<xsl:attribute name="content-width"><xsl:value-of select="$scale"/>%</xsl:attribute>
									</xsl:if>
								
								</xsl:if>
							
							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'image']" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src">
					<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
				</xsl:variable>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<!-- width=<xsl:value-of select="$width"/> -->
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<!-- height=<xsl:value-of select="$height"/> -->
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template><xsl:variable name="figure_name_height">14</xsl:variable><xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><xsl:variable name="image_dpi" select="96"/><xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/><xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/><xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image']) and *[local-name() = 'svg']]/*[local-name() = 'name']/*[local-name() = 'bookmark']" priority="2"/><xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image'])]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>
		
		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>
		
		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../*[local-name() = 'name']) != ''">
					<xsl:value-of select="../*[local-name() = 'name']"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>
					
					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					 
					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>
					
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>
											
											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
				
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					<fo:instream-foreign-object fox:alt-text="{$alt-text}">
						<xsl:attribute name="width">100%</xsl:attribute>
						<xsl:attribute name="content-height">100%</xsl:attribute>
						<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
						<xsl:variable name="svg_width" select="xalan:nodeset($svg_content)/*/@width"/>
						<xsl:variable name="svg_height" select="xalan:nodeset($svg_content)/*/@height"/>
						<!-- effective height 297 - 27.4 - 13 =  256.6 -->
						<!-- effective width 210 - 12.5 - 25 = 172.5 -->
						<!-- effective height / width = 1.48, 1.4 - with title -->
						<xsl:if test="$svg_height &gt; ($svg_width * 1.4)"> <!-- for images with big height -->
							<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
							<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
						<xsl:copy-of select="$svg_content"/>
					</fo:instream-foreign-object>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'image']/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template><xsl:template match="*[local-name() = 'svg'][not(@width and @height)]" mode="svg_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="svg_update"/>
			<xsl:variable name="viewbox">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="width">
				<xsl:value-of select="round(xalan:nodeset($viewbox)//item[3])"/>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:value-of select="round(xalan:nodeset($viewbox)//item[4])"/>
			</xsl:attribute>
			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template><xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template><xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale"/>
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template><xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
				<fo:inline-container inline-progression-dimension="100%">
					<fo:block-container height="{$height - 1}px" width="100%">
						<!-- DEBUG <xsl:if test="local-name()='polygon'">
							<xsl:attribute name="background-color">magenta</xsl:attribute>
						</xsl:if> -->
					<fo:block> </fo:block></fo:block-container>
				</fo:inline-container>
			</fo:basic-link>
		 </fo:block>
	  </fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template><xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template match="*[local-name() = 'title' or local-name() = 'name']//*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/><xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($contents)/doc">
						<xsl:choose>
							<xsl:when test="count(xalan:nodeset($contents)/doc) &gt; 1">
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>
										
										<xsl:apply-templates select="contents/item" mode="bookmark"/>
										
										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="contents"/>
										</xsl:call-template>
										
										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>
										
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="xalan:nodeset($contents)/doc">
								
									<xsl:apply-templates select="contents/item" mode="bookmark"/>
									
									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="contents"/>
									</xsl:call-template>
										
									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>
									
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="xalan:nodeset($contents)/contents/item" mode="bookmark"/>				
					</xsl:otherwise>
				</xsl:choose>
				
				
				
				
				
				
				
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template><xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)/figure">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:if test="xalan:nodeset($contents)/table">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				
				
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
				
				
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/> 
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="normalize-space(title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="title" mode="bookmark"/><xsl:template match="text()" mode="bookmark"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
				
				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/><xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template><xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
		<!-- 
		<xsl:for-each select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()">
			<xsl:value-of select="."/>
		</xsl:for-each>
		-->
		
	</xsl:template><xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">						
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>							
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">						
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>						
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template><xsl:template name="extractSection">
		<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template><xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'fn']" mode="contents"/><xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/><xsl:template match="*[local-name() = 'fn']" mode="contents_item"/><xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
		<fo:block-container margin-left="0mm">
			<xsl:copy-of select="@id"/>
			
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">
		
				
				
				<fo:block xsl:use-attribute-sets="sourcecode-style">
					<xsl:variable name="_font-size">
						
												
						
						
						10
						
						
						
						
								
						
						
						
												
						
								
				</xsl:variable>
				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				
				<xsl:apply-templates/>			
			</fo:block>
				
			
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces-java">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='label']" mode="presentation"/>
			<xsl:apply-templates select="@obligation" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='subject']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/@obligation" mode="presentation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'inherit']">
		<fo:block xsl:use-attribute-sets="requirement-inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template name="getSimpleTable"/>			
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<!-- <fo:table-column column-width="35mm"/>
						<fo:table-column column-width="115mm"/> -->
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template><xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">			
			<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
				<!-- <xsl:attribute name="border">1pt solid black</xsl:attribute> -->
				<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
				<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
				<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(165, 165, 165)</xsl:attribute>				
			</xsl:if>
			<xsl:if test="ancestor::*[local-name()='table']/@type = 'recommendtest'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>				
			</xsl:if> -->
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>				 
				<xsl:if test="parent::*[local-name()='tr']/preceding-sibling::*[local-name()='tr'] and not(*[local-name()='table'])">
					<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>					
				</xsl:if>
			</xsl:if> -->
			<!-- 2nd line and below -->
			
			<fo:block>			
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt" color="rgb(237, 193, 35)"> <!-- font-weight="bold" margin-bottom="4pt" text-align="center"  -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block> <!-- margin-bottom="10pt" -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<xsl:variable name="element">inline
			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'example']">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
			
			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
			<xsl:variable name="element">
				block				
				
				<xsl:if test=".//*[local-name() = 'table']">block</xsl:if> 
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="contains(normalize-space($element), 'block')">
					<fo:block xsl:use-attribute-sets="example-body-style">
						<xsl:apply-templates/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline>
						<xsl:apply-templates/>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']" mode="presentation">

		<xsl:variable name="element">
			block
			
			<xsl:if test="following-sibling::*[1][local-name() = 'table']">block</xsl:if> 
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			block
			
			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-p-style">
					
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template><xsl:template match="*[local-name() = 'termsource']" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<!-- <xsl:apply-templates /> -->
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>					
					
						<xsl:text>[</xsl:text>
					
					<!-- <xsl:apply-templates />					 -->
					<xsl:copy-of select="$termsource_text"/>
					
						<xsl:text>]</xsl:text>
					
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:variable name="localized.source">
		<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">source</xsl:with-param>
			</xsl:call-template>
	</xsl:variable><xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:if test="normalize-space(@citeas) = ''">
				<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
			</xsl:if>
			
				<fo:inline>
					
					
					
					
					
					
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-source'"/>
						</xsl:call-template>
						<xsl:text>: </xsl:text>
					
					
				</fo:inline>
			
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
			</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'quote']">		
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			
			<fo:block-container margin-left="0mm">
		
				<fo:block xsl:use-attribute-sets="quote-style">
					<!-- <xsl:apply-templates select=".//*[local-name() = 'p']"/> -->
					
					<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
				</fo:block>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'eref']">
	
		<xsl:variable name="bibitemid">
			<xsl:choose>
				<xsl:when test="//*[local-name() = 'bibitem'][@hidden='true' and @id = current()/@bibitemid]"/>
				<xsl:when test="//*[local-name() = 'references'][@hidden='true']/*[local-name() = 'bibitem'][@id = current()/@bibitemid]"/>
				<xsl:otherwise><xsl:value-of select="@bibitemid"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="normalize-space($bibitemid) != ''">
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						
							<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
							<xsl:attribute name="font-size">80%</xsl:attribute>
							<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
							<xsl:attribute name="vertical-align">super</xsl:attribute>
											
						
					</xsl:if>	
					
					
            
					<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@type = 'inline'">
							
								<xsl:attribute name="color">blue</xsl:attribute>
								<xsl:attribute name="text-decoration">underline</xsl:attribute>
							
							
							
							
						</xsl:if>

						<xsl:apply-templates/>
					</fo:basic-link>
							
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">
			
			
			
			
			
				<xsl:choose>
					<xsl:when test="$depth = 2">3</xsl:when>
					<xsl:when test="$depth = 3">3</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		
		<xsl:choose>
			<xsl:when test="$language = 'zh'">
				<fo:inline><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-deprecated'"/>
				</xsl:call-template>
			
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p']">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block> </fo:block>
	</xsl:template><xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			
			
			
						
			
						
			
			
			<xsl:apply-templates/>
		</fo:block>
		
		
		
	</xsl:template><xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/><xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3"/><xsl:template match="/*/*[local-name() = 'bibliography']/*[local-name() = 'references'][@normative='true']">
		
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'review']">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template><xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note'] or parent::*[local-name() = 'termnote']">
				<fo:block-container>
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					
					
					<fo:block-container margin-left="0mm">
						<fo:block>
							<xsl:apply-templates select="." mode="ul_ol"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="ul_ol"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="index" select="document($external_index)"/><xsl:variable name="dash" select="'–'"/><xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable><xsl:template match="@*|node()" mode="index_add_id">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_add_id"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId"/>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id"/>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'xref'">
				<xsl:variable name="id" select="@id"/>
				<xsl:variable name="page" select="$index//item[@id = $id]"/>
				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_next" select="$index//item[@id = $id_next]"/>
				
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_prev" select="$index//item[@id = $id_prev]"/>
				
				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->
						
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					
					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template><xsl:template name="generateIndexXrefId">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		
		<xsl:variable name="docid">
			<xsl:call-template name="getDocumentId"/>
		</xsl:variable>
		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates/>
		<fo:block>
		<xsl:if test="following-sibling::*[local-name() = 'clause']">
			<fo:block> </fo:block>
		</xsl:if>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<fo:inline id="{@id}" font-size="1pt"/>
	</xsl:template><xsl:template match="*[local-name() = 'errata']">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="processBibitem">
		
		
		
		 
		
		
		
			<!-- start IHO bibtem processing -->
			<xsl:choose>
				<xsl:when test="iho:formattedref">
					<xsl:apply-templates select="iho:formattedref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
				<!-- IHO documents -->
				<!-- {docID} edition {edition}: {title}, {author/organization} -->
						<xsl:when test="iho:docidentifier[1]/@type='IHO'">						
							<xsl:value-of select="iho:docidentifier[1]"/>							
							<xsl:apply-templates select="iho:edition"/>							
							<xsl:if test="iho:title or iho:contributor or iho:url">
								<xsl:text>: </xsl:text>
							</xsl:if>							
						</xsl:when>
						
						<!-- Non-IHO documents -->
						<!-- title and publisher -->
						<xsl:otherwise>						
							<xsl:variable name="docID">
								<xsl:call-template name="processBibitemDocId"/>
							</xsl:variable>							
							<xsl:value-of select="normalize-space($docID)"/>
							<xsl:if test="normalize-space($docID) != ''"><xsl:text>: </xsl:text></xsl:if>							
						</xsl:otherwise>						
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="iho:title[@type = 'main' and @language = 'en']">
							<xsl:apply-templates select="iho:title[@type = 'main' and @language = 'en']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="iho:title"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="iho:title and iho:contributor">
						<xsl:text>, </xsl:text>
					</xsl:if>
					
					<xsl:variable name="authors">
						<xsl:choose>
							<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='editor']">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='editor']">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>							
							<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='publisher'][*[local-name() = 'organization']]">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='publisher'][*[local-name() = 'organization']]">
									<xsl:copy>
										<xsl:choose>
											<xsl:when test="position() != 1 and position() != last()">, </xsl:when>
											<xsl:when test="position() != 1 and position() = last()"> and </xsl:when>
										</xsl:choose>
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									</xsl:copy>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>						
					</xsl:variable>
					
					<xsl:for-each select="xalan:nodeset($authors)/*">
						<xsl:choose>							
							<xsl:when test="not(*[local-name() = 'role'])"><!-- publisher organisation -->								
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise> <!-- author, editor -->
								<xsl:choose>
									<xsl:when test="*[local-name() = 'organization']/*[local-name() = 'name']">										
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									</xsl:when>
									<xsl:otherwise>										
										<xsl:for-each select="*[local-name() = 'person']">
											<xsl:variable name="author">
												<xsl:call-template name="processPersonalAuthor"/>
											</xsl:variable>
											<xsl:value-of select="xalan:nodeset($author)/author"/>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="*[local-name() = 'organization']/*[local-name() = 'name'] and position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>						
					</xsl:for-each>
					
					<xsl:apply-templates select="*[local-name() = 'uri'][1]"/>
					
				</xsl:otherwise>
			</xsl:choose>
			<!-- end IHO bibitem processing -->
		 
		
		
		
		
	</xsl:template><xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="processPersonalAuthor">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'completename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'completename']"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'initial']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'initial']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'forename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'forename']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="renderDate">		
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template><xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'label']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template><xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'select']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'textarea']">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template><xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="convertDateLocalized">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_january</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '02'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_february</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '03'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_march</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '04'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_april</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '05'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_may</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '06'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_june</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '07'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_july</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '08'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_august</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '09'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_september</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '10'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_october</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '11'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_november</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '12'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_december</xsl:with-param></xsl:call-template></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="addPDFUAmeta">
		<xsl:variable name="lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
				<pdf:dictionary type="normal" key="ViewerPreferences">
					<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
				</pdf:dictionary>
			</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
								
								
								
																
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang]"/>
								
								
																
							</xsl:for-each>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="normalize-space($title) != ''">
								<xsl:value-of select="$title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>							
					</dc:title>
					<dc:creator>
						<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
							
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							
							
							
						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">
							
								<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()"/>									
							
							
						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
					<pdf:Keywords>
						<xsl:call-template name="insertKeywords"/>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
	</xsl:template><xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="concat(local-name(..), '_', text())"/> -->
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*)"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface'] and not(ancestor::*[local-name() = 'foreword']) and not(ancestor::*[local-name() = 'introduction'])"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<!-- <xsl:when test="parent::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when> -->
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:if test="string-length($pText) &gt;0">
		<item>
			<xsl:choose>
				<xsl:when test="$normalize-space = 'true'">
					<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
				</xsl:otherwise>
			</xsl:choose>
		</item>
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
			<xsl:with-param name="normalize-space" select="$normalize-space"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template><xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			
			
			
			
			
			
			
			
			
			
			
			
				<xsl:value-of select="document('')//*/namespace::iho"/>
						
			
			
			
			
		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template><xsl:template name="getLanguage">
		<xsl:param name="lang"/>		
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="setId">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>					
		</xsl:attribute>
	</xsl:template><xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>				
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:param name="formatted">false</xsl:param>
		
		<xsl:variable name="curr_lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		
		<xsl:variable name="data_value">
			<xsl:choose>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="normalize-space($data_value) != ''">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'"><xsl:copy-of select="$data_value"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$data_value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
			
	</xsl:template><xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>
		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<!-- <xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute> -->
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="LRM" select="'‎'"/><xsl:variable name="RLM" select="'‏'"/><xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template><xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'td']/@align"><xsl:value-of select="ancestor::*[local-name() = 'td']/@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'th']/@align"><xsl:value-of select="ancestor::*[local-name() = 'th']/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template><xsl:template name="number-to-words">
		<xsl:param name="number"/>
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
								<words>
					<word cardinal="1">One-</word>
					<word ordinal="1">First </word>
					<word cardinal="2">Two-</word>
					<word ordinal="2">Second </word>
					<word cardinal="3">Three-</word>
					<word ordinal="3">Third </word>
					<word cardinal="4">Four-</word>
					<word ordinal="4">Fourth </word>
					<word cardinal="5">Five-</word>
					<word ordinal="5">Fifth </word>
					<word cardinal="6">Six-</word>
					<word ordinal="6">Sixth </word>
					<word cardinal="7">Seven-</word>
					<word ordinal="7">Seventh </word>
					<word cardinal="8">Eight-</word>
					<word ordinal="8">Eighth </word>
					<word cardinal="9">Nine-</word>
					<word ordinal="9">Ninth </word>
					<word ordinal="10">Tenth </word>
					<word ordinal="11">Eleventh </word>
					<word ordinal="12">Twelfth </word>
					<word ordinal="13">Thirteenth </word>
					<word ordinal="14">Fourteenth </word>
					<word ordinal="15">Fifteenth </word>
					<word ordinal="16">Sixteenth </word>
					<word ordinal="17">Seventeenth </word>
					<word ordinal="18">Eighteenth </word>
					<word ordinal="19">Nineteenth </word>
					<word cardinal="20">Twenty-</word>
					<word ordinal="20">Twentieth </word>
					<word cardinal="30">Thirty-</word>
					<word ordinal="30">Thirtieth </word>
					<word cardinal="40">Forty-</word>
					<word ordinal="40">Fortieth </word>
					<word cardinal="50">Fifty-</word>
					<word ordinal="50">Fiftieth </word>
					<word cardinal="60">Sixty-</word>
					<word ordinal="60">Sixtieth </word>
					<word cardinal="70">Seventy-</word>
					<word ordinal="70">Seventieth </word>
					<word cardinal="80">Eighty-</word>
					<word ordinal="80">Eightieth </word>
					<word cardinal="90">Ninety-</word>
					<word ordinal="90">Ninetieth </word>
					<word cardinal="100">Hundred-</word>
					<word ordinal="100">Hundredth </word>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>
			
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template></xsl:stylesheet>