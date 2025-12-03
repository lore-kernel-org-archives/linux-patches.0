Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A634A3BF;
	Wed,  3 Dec 2025 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780646; cv=none; b=di9biY6caUqf5MQh+isSGyJF/O95yyXsg/dsj9WHZecfkawf8Xdo+cZT3uaBNIjghoXrKjjZ1D5TGtfZLAHHpbt6i5qBAHyVou19/Fq126L4jjbCsZIXVhrJlGLsYw8nmkBULe/HzEcOWTS/Pg8UPXmSJCVgpySYGJy4dxKKlSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780646; c=relaxed/simple;
	bh=ASwtOBF/fQu2SQ1DLCoCzPs7qHCk4hpmz07Mls0Svt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnM7HAYXd5RGR3rXnpZDD+Q+ZPQYTaAnTb/UzdJr8EvDZcXbLtGXWZlaPaKbuQslon6bbx5LaM9h7wXILm+DI2Q7+Axdlv60fodiMCy0a3yDMbjYwrBISEsSCg7pUFVuyHI3lwaZ4WnysEr3oHGMkzPNutXFyIwZdU8btD25GiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFamBm90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFamBm90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95019C116C6;
	Wed,  3 Dec 2025 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780646;
	bh=ASwtOBF/fQu2SQ1DLCoCzPs7qHCk4hpmz07Mls0Svt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFamBm90gdHvvurt/al0Ihjl6WWX6Xo4/lXgfEQnP1wG3xfB/DFPHTkE/zcFKF82O
	 INwkWQKDb0pX0065z09sEALmbAuR/uRvurHgayHr7MBxTt3x6m4FlI9BQsfwZjapAr
	 3ycJzx8hyAym/F/iw/oX2SrRjjas7gPb5ogg+NpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/132] spi: nxp-fspi: Propagate fwnode in ACPI case as well
Date: Wed,  3 Dec 2025 16:28:46 +0100
Message-ID: <20251203152345.037790579@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 40ad64ac25bb736740f895d99a4aebbda9b80991 ]

Propagate fwnode of the ACPI device to the SPI controller Linux device.
Currently only OF case propagates fwnode to the controller.

While at it, replace several calls to dev_fwnode() with a single one
cached in a local variable, and unify checks for fwnode type by using
is_*_node() APIs.

Fixes: 55ab8487e01d ("spi: spi-nxp-fspi: Add ACPI support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20251126202501.2319679-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 6cdeee9c581bd..5100b189c9050 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1173,7 +1173,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct resource *res;
 	struct nxp_fspi *f;
 	int ret, irq;
@@ -1195,7 +1195,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, f);
 
 	/* find the resources - configuration register address space */
-	if (is_acpi_node(dev_fwnode(f->dev)))
+	if (is_acpi_node(fwnode))
 		f->iobase = devm_platform_ioremap_resource(pdev, 0);
 	else
 		f->iobase = devm_platform_ioremap_resource_byname(pdev, "fspi_base");
@@ -1203,7 +1203,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		return PTR_ERR(f->iobase);
 
 	/* find the resources - controller memory mapped space */
-	if (is_acpi_node(dev_fwnode(f->dev)))
+	if (is_acpi_node(fwnode))
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	else
 		res = platform_get_resource_byname(pdev,
@@ -1216,7 +1216,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	f->memmap_phy_size = resource_size(res);
 
 	/* find the clocks */
-	if (dev_of_node(&pdev->dev)) {
+	if (is_of_node(fwnode)) {
 		f->clk_en = devm_clk_get(dev, "fspi_en");
 		if (IS_ERR(f->clk_en))
 			return PTR_ERR(f->clk_en);
@@ -1260,7 +1260,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	else
 		ctlr->mem_caps = &nxp_fspi_mem_caps;
 
-	ctlr->dev.of_node = np;
+	device_set_node(&ctlr->dev, fwnode);
 
 	return devm_spi_register_controller(&pdev->dev, ctlr);
 }
-- 
2.51.0



