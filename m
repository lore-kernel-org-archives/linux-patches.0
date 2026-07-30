Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14E443A89;
	Thu, 30 Jul 2026 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427173; cv=none; b=hmecNvvaU6xFFFHJhRYwOMPdWw/TaY9eV3btdYcc8N1VGrOXp41ydKjIZh190iwDrU5Mlw2ScjAZaRfPg07LdELPXrBrDTGLCiYFa+u6DQMUM1URw8bnxKqnHzt5A6YFYJUnKralXHlY/dEBit3+H5HDDPw5/fRbOpTHzMJmk1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427173; c=relaxed/simple;
	bh=Y5niF4u+PBx1yP0CO2jPgMg+mP1FCoqlTsGg9HBNc58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oj/Y9Kb6KxM3lWXI4jTIfydsyHDPmAxvW8QqKSyI73oU/WGWI4WGDWpdom93JjFzWrm5fjRPadG2w6SRlOf7L2jI/SeIS+OCqR5EDOwDoXoFKJr9fEDRe5JgP+sPNPO90LLfsVM2ycR4D0pG5RxorErt5tsLdw5dN1QQq5seniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2q1jj03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2q1jj03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A6A1F000E9;
	Thu, 30 Jul 2026 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427172;
	bh=buwpz/+cTZaNlpm1/CY7OendogORlTlE5imYSpQORAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2q1jj03vT8qyJ8zqTUHMWCR9I0S5FfhzORJmwRXB29mg3sEIg9H6KT87MP7+GPPQ
	 JIrzMQnuJX6khRqH1Ge6tYrXbOEHLhVHdrhhqm9AN9DV4mfj/Ibk1P6Be7WhP/6j/w
	 hFwBbqCz0g5JGjzFdx7uyWdKA2xbsoIqZiuPcppk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/484] ata: sata_dwc_460ex: use platform_get_irq()
Date: Thu, 30 Jul 2026 16:09:32 +0200
Message-ID: <20260730141425.066836203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a4af122106f73ea510bb35a9ea1dedd980fc0db7 ]

Replace irq_of_parse_and_map() with platform_get_irq() in both
sata_dwc_dma_init_old() and sata_dwc_probe(). This is the preferred
way to obtain IRQs for platform devices and provides better error
reporting.  Remove the now-unnecessary #include <linux/of_irq.h>.

irq_of_parse_and_map() requires irq_dispose_mapping(), which is missing.

Also fix unused variable when CONFIG_SATA_DWC_OLD_DMA is disabled.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 16c1deef389d10..97b934fa116e26 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -19,7 +19,6 @@
 #include <linux/device.h>
 #include <linux/dmaengine.h>
 #include <linux/of.h>
-#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
 #include <linux/libata.h>
@@ -226,7 +225,6 @@ static int sata_dwc_dma_init_old(struct platform_device *pdev,
 				 struct sata_dwc_device *hsdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 
 	hsdev->dma = devm_kzalloc(dev, sizeof(*hsdev->dma), GFP_KERNEL);
 	if (!hsdev->dma)
@@ -236,11 +234,9 @@ static int sata_dwc_dma_init_old(struct platform_device *pdev,
 	hsdev->dma->id = pdev->id;
 
 	/* Get SATA DMA interrupt number */
-	hsdev->dma->irq = irq_of_parse_and_map(np, 1);
-	if (!hsdev->dma->irq) {
-		dev_err(dev, "no SATA DMA irq\n");
-		return -ENODEV;
-	}
+	hsdev->dma->irq = platform_get_irq(pdev, 1);
+	if (hsdev->dma->irq < 0)
+		return hsdev->dma->irq;
 
 	/* Get physical SATA DMA register base address */
 	hsdev->dma->regs = devm_platform_ioremap_resource(pdev, 1);
@@ -1125,7 +1121,6 @@ static const struct ata_port_info sata_dwc_port_info[] = {
 static int sata_dwc_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
-	struct device_node *np = dev->of_node;
 	struct sata_dwc_device *hsdev;
 	u32 idr, versionr;
 	char *ver = (char *)&versionr;
@@ -1169,14 +1164,12 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	hsdev->dev = dev;
 
 	/* Get SATA interrupt number */
-	irq = irq_of_parse_and_map(np, 0);
-	if (!irq) {
-		dev_err(dev, "no SATA DMA irq\n");
-		return -ENODEV;
-	}
+	irq = platform_get_irq(ofdev, 0);
+	if (irq < 0)
+		return irq;
 
 #ifdef CONFIG_SATA_DWC_OLD_DMA
-	if (!of_property_present(np, "dmas")) {
+	if (!of_property_present(dev->of_node, "dmas")) {
 		err = sata_dwc_dma_init_old(ofdev, hsdev);
 		if (err)
 			return err;
-- 
2.53.0



