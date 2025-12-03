Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C59D364EB3;
	Wed,  3 Dec 2025 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781044; cv=none; b=C+QoOc1n1S1eUU9bQFO0aTfAQVVOkAsezVjs4x6WvYclMSuWDrzR6+NlYrDhFEd60foIg80s5WG01HzVH3ld+F8H6Kmv81JjudY7IMfqnxULQm2qtFT+/LTA28KLs/ylcH31POVNxy2Kdwwfm0VjtHDEVNVQuPPtLIjztaAGFdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781044; c=relaxed/simple;
	bh=+WiJGoxvMRbwY0SF7aW+1LULRhL3tsWgtbcOQBwJE0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPQiEKqk2XHoBrykVtmxTjhOH1YvGTorLqj/xYvyDS/4BhPfwI3YrsTFizXZU6QCfr/+IsAMDZQNhvGBVYEzHtCkHzFeoDYwwKiT87Z1OdORD+EUTObobVy8E48lAY05AFChWZ/MfIqzk2BAIyEWzDVxOel0fGbxQ4iQklDRHWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxF5phT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxF5phT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92EFC4CEF5;
	Wed,  3 Dec 2025 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781043;
	bh=+WiJGoxvMRbwY0SF7aW+1LULRhL3tsWgtbcOQBwJE0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxF5phT8Up0FH4hkZp47qM3GDwzK0/XnpmWPMCpwOYNBWrO6ghEPQ1eCxRdpkPEvO
	 jpsk/uj8Aq9DfXOCPY7JwYufnB9LT0SlquGwIKz9ZsAc7afyLS8QhF77X4HNYwG+cB
	 FtbakPWXze5aznwqWl/qES92r358yxfJZEaR67y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/93] spi: nxp-fspi: Propagate fwnode in ACPI case as well
Date: Wed,  3 Dec 2025 16:29:25 +0100
Message-ID: <20251203152337.704193662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
index 5d631f8c593e3..ce110035a3597 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1165,7 +1165,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct resource *res;
 	struct nxp_fspi *f;
 	int ret;
@@ -1189,7 +1189,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, f);
 
 	/* find the resources - configuration register address space */
-	if (is_acpi_node(dev_fwnode(f->dev)))
+	if (is_acpi_node(fwnode))
 		f->iobase = devm_platform_ioremap_resource(pdev, 0);
 	else
 		f->iobase = devm_platform_ioremap_resource_byname(pdev, "fspi_base");
@@ -1200,7 +1200,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	}
 
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
 		if (IS_ERR(f->clk_en)) {
 			ret = PTR_ERR(f->clk_en);
@@ -1262,7 +1262,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 
 	nxp_fspi_default_setup(f);
 
-	ctlr->dev.of_node = np;
+	device_set_node(&ctlr->dev, fwnode);
 
 	ret = devm_spi_register_controller(&pdev->dev, ctlr);
 	if (ret)
-- 
2.51.0



