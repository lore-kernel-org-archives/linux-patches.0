Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17509206F18;
	Tue,  8 Apr 2025 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114714; cv=none; b=Q/WQOD8zoZsYLMnoc83lTH2YVpljzgO7bcMRQzeu8rTK65SAzYIBRT3iOW2xkSCQiBr4sto73HL/hGr1YOwFrqdpQ8YqobRvPN92jCQo65EdKEwuAtYpwRifuCD46nrX8rWdvqj7o3KIjD7utrEpFcilYu+A5mVunki7wHkwKVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114714; c=relaxed/simple;
	bh=mFBrPfngwpdLZRHaSeoPGFsa1JuzIApm9OQe+N936rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfZYYCFJkicaFIUhZvSqRbhX/4sJnLjt0N/AJeRDRvpt/CvSygHCXvcQbFMlhBq5LZyqdNE3QiExX65NJ354aQSWMUsTP+nSX4eBUZ6iBKwXB2VcgIJ48anC0adC5M+uNkcCKlnyOlFZaz8417SncOoHsQQIyWd2jo88E/4r7FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeLqBR9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeLqBR9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A1FC4CEE5;
	Tue,  8 Apr 2025 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114713;
	bh=mFBrPfngwpdLZRHaSeoPGFsa1JuzIApm9OQe+N936rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeLqBR9eIOfQVIn+EzdSfgL/jZ8gQc1XJ3ifKBcA8ZYCSmx7iP9Dw9QXBehj9tMOl
	 f/EO6KWhgVCizlCP0oL3dVW17RIexsdaYXzsIvp8YeLAiZwZxkxAvzyM12A1qur/eq
	 WOOVMZzpnu/AAduff9vjTJi/xdVqTXTKke6Okq28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 206/499] phy: phy-rockchip-samsung-hdptx: Dont use dt aliases to determine phy-id
Date: Tue,  8 Apr 2025 12:46:58 +0200
Message-ID: <20250408104856.341767691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit f08d1c08563846f9be79a4859e912c8795d690fd ]

The phy needs to know its identity in the system (phy0 or phy1 on rk3588)
for some actions and the driver currently contains code abusing of_alias
for that.

Devicetree aliases are always optional and should not be used for core
device functionality, so instead keep a list of phys on a soc in the
of_device_data and find the phy-id by comparing against the mapped
register-base.

Fixes: c4b09c562086 ("phy: phy-rockchip-samsung-hdptx: Add clock provider support")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20241206103401.1780416-3-heiko@sntech.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/rockchip/phy-rockchip-samsung-hdptx.c | 50 ++++++++++++++++---
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 0965b9d4f9cf1..2fb4f297fda3d 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -263,11 +263,22 @@ enum rk_hdptx_reset {
 	RST_MAX
 };
 
+#define MAX_HDPTX_PHY_NUM	2
+
+struct rk_hdptx_phy_cfg {
+	unsigned int num_phys;
+	unsigned int phy_ids[MAX_HDPTX_PHY_NUM];
+};
+
 struct rk_hdptx_phy {
 	struct device *dev;
 	struct regmap *regmap;
 	struct regmap *grf;
 
+	/* PHY const config */
+	const struct rk_hdptx_phy_cfg *cfgs;
+	int phy_id;
+
 	struct phy *phy;
 	struct phy_config *phy_cfg;
 	struct clk_bulk_data *clks;
@@ -1007,15 +1018,14 @@ static int rk_hdptx_phy_clk_register(struct rk_hdptx_phy *hdptx)
 	struct device *dev = hdptx->dev;
 	const char *name, *pname;
 	struct clk *refclk;
-	int ret, id;
+	int ret;
 
 	refclk = devm_clk_get(dev, "ref");
 	if (IS_ERR(refclk))
 		return dev_err_probe(dev, PTR_ERR(refclk),
 				     "Failed to get ref clock\n");
 
-	id = of_alias_get_id(dev->of_node, "hdptxphy");
-	name = id > 0 ? "clk_hdmiphy_pixel1" : "clk_hdmiphy_pixel0";
+	name = hdptx->phy_id > 0 ? "clk_hdmiphy_pixel1" : "clk_hdmiphy_pixel0";
 	pname = __clk_get_name(refclk);
 
 	hdptx->hw.init = CLK_HW_INIT(name, pname, &hdptx_phy_clk_ops,
@@ -1058,8 +1068,9 @@ static int rk_hdptx_phy_probe(struct platform_device *pdev)
 	struct phy_provider *phy_provider;
 	struct device *dev = &pdev->dev;
 	struct rk_hdptx_phy *hdptx;
+	struct resource *res;
 	void __iomem *regs;
-	int ret;
+	int ret, id;
 
 	hdptx = devm_kzalloc(dev, sizeof(*hdptx), GFP_KERNEL);
 	if (!hdptx)
@@ -1067,11 +1078,27 @@ static int rk_hdptx_phy_probe(struct platform_device *pdev)
 
 	hdptx->dev = dev;
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
+	regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(regs))
 		return dev_err_probe(dev, PTR_ERR(regs),
 				     "Failed to ioremap resource\n");
 
+	hdptx->cfgs = device_get_match_data(dev);
+	if (!hdptx->cfgs)
+		return dev_err_probe(dev, -EINVAL, "missing match data\n");
+
+	/* find the phy-id from the io address */
+	hdptx->phy_id = -ENODEV;
+	for (id = 0; id < hdptx->cfgs->num_phys; id++) {
+		if (res->start == hdptx->cfgs->phy_ids[id]) {
+			hdptx->phy_id = id;
+			break;
+		}
+	}
+
+	if (hdptx->phy_id < 0)
+		return dev_err_probe(dev, -ENODEV, "no matching device found\n");
+
 	ret = devm_clk_bulk_get_all(dev, &hdptx->clks);
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Failed to get clocks\n");
@@ -1132,8 +1159,19 @@ static const struct dev_pm_ops rk_hdptx_phy_pm_ops = {
 		       rk_hdptx_phy_runtime_resume, NULL)
 };
 
+static const struct rk_hdptx_phy_cfg rk3588_hdptx_phy_cfgs = {
+	.num_phys = 2,
+	.phy_ids = {
+		0xfed60000,
+		0xfed70000,
+	},
+};
+
 static const struct of_device_id rk_hdptx_phy_of_match[] = {
-	{ .compatible = "rockchip,rk3588-hdptx-phy", },
+	{
+		.compatible = "rockchip,rk3588-hdptx-phy",
+		.data = &rk3588_hdptx_phy_cfgs
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, rk_hdptx_phy_of_match);
-- 
2.39.5



