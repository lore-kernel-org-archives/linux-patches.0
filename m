Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67B12D210;
	Tue, 30 Apr 2024 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475752; cv=none; b=m+gslXdK7jOt+Ey95tE2lS3IDtM8OQa+AlRY6O6Ui8cdk3JdT0G7MmLjWTDkMvhAPQs8+8d5nQ2Kc7vCPs1Vh6HCbT48b6yVutNw4BtEShB46KG7SoZSobPeeCyQotrDQzc9Idh65YOzVc2dp9fnNkG8aLaaG4tuQwvOMm/DEJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475752; c=relaxed/simple;
	bh=yp54RYhoryWo2nHsg/MPU7jS8VujuZRoIPa2NWMy/8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFbE+AR3b8TIQ6hwNZPq5JYa4pIkrsyepqcK+pu5TeUbqXPb5gwHKIGMxnf1EiwBsO3WaLMUDWTVxld0jfbeyCY/faaRj6ZIg5/fvZc9snEJ68V/dpKdMzq1cWH5siNYv8DiA4pfKGKDx8xIMTqylH57rOt99QfIC2yJ2qxCjF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVwIlud7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVwIlud7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C98C2BBFC;
	Tue, 30 Apr 2024 11:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475752;
	bh=yp54RYhoryWo2nHsg/MPU7jS8VujuZRoIPa2NWMy/8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVwIlud77FEFFB7Aw2gIYDx181EplrOgZTCNViw2MQLCpPLZxpYGUq87pdoJgVfdL
	 umZQoX2Vxgc5pRRN54LgoojU1LFTg0fGvEczSJWv+rvI5t2bCD7ewEbBgcwrFxmbeE
	 nogA4aBZZhnKyibIARGMpIB1CDJZ30UUlXmcRpnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Tomek <mtdev79b@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/186] phy: rockchip: naneng-combphy: Fix mux on rk3588
Date: Tue, 30 Apr 2024 12:40:19 +0200
Message-ID: <20240430103102.879764510@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit d16d4002fea69b6609b852dd8db1f5844c02fbe4 ]

The pcie1l0_sel and pcie1l1_sel bits in PCIESEL_CON configure the
mux for PCIe1L0 and PCIe1L1 to either the PIPE Combo PHYs or the
PCIe3 PHY. Thus this configuration interfers with the data-lanes
configuration done by the PCIe3 PHY.

RK3588 has three Combo PHYs. The first one has a dedicated PCIe
controller and is not affected by this. For the other two Combo
PHYs, there is one mux for each of them.

pcie1l0_sel selects if PCIe 1L0 is muxed to Combo PHY 1 when
bit is set to 0 or to the PCIe3 PHY when bit is set to 1.

pcie1l1_sel selects if PCIe 1L1 is muxed to Combo PHY 2 when
bit is set to 0 or to the PCIe3 PHY when bit is set to 1.

Currently the code always muxes 1L0 and 1L1 to the Combi PHYs
once one of them is being used in PCIe mode. This is obviously
wrong when at least one of the ports should be muxed to the
PCIe3 PHY.

Fix this by introducing Combo PHY identification and then only
setting up the required bit.

Fixes: a03c44277253 ("phy: rockchip: Add naneng combo phy support for RK3588")
Reported-by: Michal Tomek <mtdev79b@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20240404-rk3588-pcie-bifurcation-fixes-v1-3-9907136eeafd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../rockchip/phy-rockchip-naneng-combphy.c    | 36 +++++++++++++++++--
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index 5de5e2e97ffa0..26b157f53f3da 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -125,12 +125,15 @@ struct rockchip_combphy_grfcfg {
 };
 
 struct rockchip_combphy_cfg {
+	unsigned int num_phys;
+	unsigned int phy_ids[3];
 	const struct rockchip_combphy_grfcfg *grfcfg;
 	int (*combphy_cfg)(struct rockchip_combphy_priv *priv);
 };
 
 struct rockchip_combphy_priv {
 	u8 type;
+	int id;
 	void __iomem *mmio;
 	int num_clks;
 	struct clk_bulk_data *clks;
@@ -320,7 +323,7 @@ static int rockchip_combphy_probe(struct platform_device *pdev)
 	struct rockchip_combphy_priv *priv;
 	const struct rockchip_combphy_cfg *phy_cfg;
 	struct resource *res;
-	int ret;
+	int ret, id;
 
 	phy_cfg = of_device_get_match_data(dev);
 	if (!phy_cfg) {
@@ -338,6 +341,15 @@ static int rockchip_combphy_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* find the phy-id from the io address */
+	priv->id = -ENODEV;
+	for (id = 0; id < phy_cfg->num_phys; id++) {
+		if (res->start == phy_cfg->phy_ids[id]) {
+			priv->id = id;
+			break;
+		}
+	}
+
 	priv->dev = dev;
 	priv->type = PHY_NONE;
 	priv->cfg = phy_cfg;
@@ -562,6 +574,12 @@ static const struct rockchip_combphy_grfcfg rk3568_combphy_grfcfgs = {
 };
 
 static const struct rockchip_combphy_cfg rk3568_combphy_cfgs = {
+	.num_phys = 3,
+	.phy_ids = {
+		0xfe820000,
+		0xfe830000,
+		0xfe840000,
+	},
 	.grfcfg		= &rk3568_combphy_grfcfgs,
 	.combphy_cfg	= rk3568_combphy_cfg,
 };
@@ -578,8 +596,14 @@ static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_pcie, true);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_pcie, true);
-		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_pcie1l0_sel, true);
-		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_pcie1l1_sel, true);
+		switch (priv->id) {
+		case 1:
+			rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_pcie1l0_sel, true);
+			break;
+		case 2:
+			rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_pcie1l1_sel, true);
+			break;
+		}
 		break;
 	case PHY_TYPE_USB3:
 		/* Set SSC downward spread spectrum */
@@ -736,6 +760,12 @@ static const struct rockchip_combphy_grfcfg rk3588_combphy_grfcfgs = {
 };
 
 static const struct rockchip_combphy_cfg rk3588_combphy_cfgs = {
+	.num_phys = 3,
+	.phy_ids = {
+		0xfee00000,
+		0xfee10000,
+		0xfee20000,
+	},
 	.grfcfg		= &rk3588_combphy_grfcfgs,
 	.combphy_cfg	= rk3588_combphy_cfg,
 };
-- 
2.43.0



