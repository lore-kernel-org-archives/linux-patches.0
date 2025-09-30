Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6974A1F03C5;
	Tue, 30 Sep 2025 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244260; cv=none; b=YbUf8O4FLxuDb1pTonhxAZl36wV/GAdYjVaRzIwgAMj1D50Aq6iQESKECDVJ31Khm9BahrbTFaVn0dkh5lky8a3DxUDHmgZ/i32kvIR2PPl+jblpz4QQeBPEkB1/9xOGhVvJImQXTl3lac282LoHl3GiHEYzLvKG9+HSo0zhjXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244260; c=relaxed/simple;
	bh=8VPs7gO7k0r3zHC9QYTcwKcX5MY8IqiCE4f7oKEST9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaJRXL/eHQCnMMOaduryFYYw7Q5wg1GWWmOpxN0GrislWyykciiE5Iye/ii2RAvd05Bke96J8SfAwCUL4O9OvQBc2ID4oEQ+pkIDZ5KhD/yHkZkil9P1htS2NqxgDc+VfrTaw84us6aO3wpnF+TBqVjB9deHo6nkAF9E4pQ3FIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10GqVYfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10GqVYfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3FFC4CEF0;
	Tue, 30 Sep 2025 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244260;
	bh=8VPs7gO7k0r3zHC9QYTcwKcX5MY8IqiCE4f7oKEST9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10GqVYfmStTD2YC1lZqIPTWPmaLQ5h7E817DYkS+lg9gQnM7E78rdoqVyT73YvzEq
	 GkNBQKoAwJSyhIQ5Nv3g8rGfhtvwAnj95q4m9lowqD+NCr8r7zQkRds2XJ0GF+bDqx
	 8GK2X+YSaCg5BoYjP0+vGDcq4cwk9ZkdEv3M+ha8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/122] phy: ti: convert to devm_platform_ioremap_resource(_byname)
Date: Tue, 30 Sep 2025 16:46:46 +0200
Message-ID: <20250930143826.071090590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 79caf207d6699419e83ac150accc5c80c5719b47 ]

Use devm_platform_ioremap_resource(_byname) to simplify code

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1604642930-29019-17-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 64961557efa1 ("phy: ti: omap-usb2: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-omap-control.c |   17 ++++++-----------
 drivers/phy/ti/phy-omap-usb2.c    |    4 +---
 drivers/phy/ti/phy-ti-pipe3.c     |   15 ++++-----------
 3 files changed, 11 insertions(+), 25 deletions(-)

--- a/drivers/phy/ti/phy-omap-control.c
+++ b/drivers/phy/ti/phy-omap-control.c
@@ -268,7 +268,6 @@ MODULE_DEVICE_TABLE(of, omap_control_phy
 
 static int omap_control_phy_probe(struct platform_device *pdev)
 {
-	struct resource	*res;
 	const struct of_device_id *of_id;
 	struct omap_control_phy *control_phy;
 
@@ -285,16 +284,13 @@ static int omap_control_phy_probe(struct
 	control_phy->type = *(enum omap_control_phy_type *)of_id->data;
 
 	if (control_phy->type == OMAP_CTRL_TYPE_OTGHS) {
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-			"otghs_control");
-		control_phy->otghs_control = devm_ioremap_resource(
-			&pdev->dev, res);
+		control_phy->otghs_control =
+			devm_platform_ioremap_resource_byname(pdev, "otghs_control");
 		if (IS_ERR(control_phy->otghs_control))
 			return PTR_ERR(control_phy->otghs_control);
 	} else {
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-				"power");
-		control_phy->power = devm_ioremap_resource(&pdev->dev, res);
+		control_phy->power =
+			devm_platform_ioremap_resource_byname(pdev, "power");
 		if (IS_ERR(control_phy->power)) {
 			dev_err(&pdev->dev, "Couldn't get power register\n");
 			return PTR_ERR(control_phy->power);
@@ -312,9 +308,8 @@ static int omap_control_phy_probe(struct
 	}
 
 	if (control_phy->type == OMAP_CTRL_TYPE_PCIE) {
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						   "pcie_pcs");
-		control_phy->pcie_pcs = devm_ioremap_resource(&pdev->dev, res);
+		control_phy->pcie_pcs =
+			devm_platform_ioremap_resource_byname(pdev, "pcie_pcs");
 		if (IS_ERR(control_phy->pcie_pcs))
 			return PTR_ERR(control_phy->pcie_pcs);
 	}
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -366,7 +366,6 @@ static int omap_usb2_probe(struct platfo
 {
 	struct omap_usb	*phy;
 	struct phy *generic_phy;
-	struct resource *res;
 	struct phy_provider *phy_provider;
 	struct usb_otg *otg;
 	struct device_node *node = pdev->dev.of_node;
@@ -403,8 +402,7 @@ static int omap_usb2_probe(struct platfo
 
 	omap_usb2_init_errata(phy);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	phy->phy_base = devm_ioremap_resource(&pdev->dev, res);
+	phy->phy_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(phy->phy_base))
 		return PTR_ERR(phy->phy_base);
 
--- a/drivers/phy/ti/phy-ti-pipe3.c
+++ b/drivers/phy/ti/phy-ti-pipe3.c
@@ -758,35 +758,28 @@ static int ti_pipe3_get_sysctrl(struct t
 
 static int ti_pipe3_get_tx_rx_base(struct ti_pipe3 *phy)
 {
-	struct resource *res;
 	struct device *dev = phy->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-					   "phy_rx");
-	phy->phy_rx = devm_ioremap_resource(dev, res);
+	phy->phy_rx = devm_platform_ioremap_resource_byname(pdev, "phy_rx");
 	if (IS_ERR(phy->phy_rx))
 		return PTR_ERR(phy->phy_rx);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-					   "phy_tx");
-	phy->phy_tx = devm_ioremap_resource(dev, res);
+	phy->phy_tx = devm_platform_ioremap_resource_byname(pdev, "phy_tx");
 
 	return PTR_ERR_OR_ZERO(phy->phy_tx);
 }
 
 static int ti_pipe3_get_pll_base(struct ti_pipe3 *phy)
 {
-	struct resource *res;
 	struct device *dev = phy->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 
 	if (phy->mode == PIPE3_MODE_PCIE)
 		return 0;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-					   "pll_ctrl");
-	phy->pll_ctrl_base = devm_ioremap_resource(dev, res);
+	phy->pll_ctrl_base =
+		devm_platform_ioremap_resource_byname(pdev, "pll_ctrl");
 	return PTR_ERR_OR_ZERO(phy->pll_ctrl_base);
 }
 


