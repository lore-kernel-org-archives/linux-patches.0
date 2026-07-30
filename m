Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC32372ECB;
	Thu, 30 Jul 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423605; cv=none; b=bSknhH0K2M4+r17nfVknWEHs4S+9/ghcRo8L4MGVZZohqNI4XQpfP5yjYftS6ma/MfSGyDxAQG9s0T7gXavEmDgpWLWumGLZsp9lvowP9MZCdLGKWYqVsBz8uFJOuuEtcudazX79NWuclK8SMtGJo8+YzBgrBdnkN6FRBZiZ/LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423605; c=relaxed/simple;
	bh=sY+ceQdgbhPhGtFkwsNf42CjI31/kC+qPI6At8PRe4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSVyBAkNi2UAMFw+3p8rDdgcpiPtJTFWgLGTi9nDd+fZskWVefvsjXa9O3EakLdFe7X6d+x6sRXy6k/GXDuGY8sAkDbTMPKTLfGDk/+ttrAtPzPLhBWMtbnddQa1VCLM0iEVaj4COsVmwM6Qgnnnb2hDrShtp+/ROJMsk8TH19I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gKFNLZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gKFNLZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828D11F000E9;
	Thu, 30 Jul 2026 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423603;
	bh=b32EKuB+rANI48XJBQJhZokIg795gAqtmrgwk+ZjW/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gKFNLZUawTC6SAcP22zwzSrYxc84fF/kYT+057ALuj6ajImbeh+tFc/+cgCS1GbT
	 KZedzWpmbXAOK6D5rECfsJJI6U1G5USHdwjVQi0E+lgt2B7X8N5nXbTQ+Ey0j4xQqP
	 5RRRrUq2AF3r/hU/P1s/FPALfx+UstX/hqrxczH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/675] ata: sata_dwc_460ex: use platform_get_irq()
Date: Thu, 30 Jul 2026 16:07:12 +0200
Message-ID: <20260730141447.304503857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4029e082577fe1..639eab75210f29 100644
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



