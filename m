Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53C512D743;
	Tue, 30 Apr 2024 10:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474612; cv=none; b=cWuF+A9B3bl9SA3l4zWQCFvBadPN5ocpmwjtciyHegq5T76qkZjOGD0nssL8mN4VlorCgA1b//Cp7TBWqVK7o4103DOeqmYPb/CV+LUdvkvZ6h8z+LooqzeDA5VUh/h6KV01wOnW3sszy/fKNjjWHPEcK4X1nVOHhJvhaqO8JM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474612; c=relaxed/simple;
	bh=AH6Nbcywd42InuOe7kF8CfCqyoMzA5xpSt2oF6Jxl28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek1aL0rwK7LGoZVLN9hVEkc9PEq4yWh7O2CPvQ/SfBAAt3T21p1CIMhBKxC5r/hoOuESc9ZWaI+SCd5Q0nHxMmdEsF8pugynQNf1uK3SCgEQvV+9SPSf20FrttM9ErZ6MkasvI1wJND4cUR6S9uFj+RXn/3fwc/nFUCuZwFTI0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3Cvt9+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3Cvt9+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45603C2BBFC;
	Tue, 30 Apr 2024 10:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474612;
	bh=AH6Nbcywd42InuOe7kF8CfCqyoMzA5xpSt2oF6Jxl28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3Cvt9+0qyG37ngVAKB8in8VIP+bbKXZ9832gQFelDYUEanwhgXvvWyXVi4Y7fYVy
	 0S0r4QZY6VH4lQqhiDAXxnxsfq0K+IcwGzmwn3zbBQpccSZfUF1iern0akY3cSv//t
	 5EHtZeSIj9ODCsCDq4cKWcrC3rvUYf2xbtpzMwVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Tomek <mtdev79b@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 209/228] phy: rockchip: naneng-combphy: Fix mux on rk3588
Date: Tue, 30 Apr 2024 12:39:47 +0200
Message-ID: <20240430103109.836361544@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



