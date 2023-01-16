Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3333EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30C7C433EF;
	Mon, 16 Jan 2023 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884712;
	bh=f+B3hQ8bQlLsA4dwkMueRXp6yg389tA+Vx2uaELslVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrTgf8a9ouprcjUubNvC+tM2mrDnvdsxNGqWIaZ8ut+kS1W7yM7g8Zr/SQ64KIIM9
	 69FSs2j4uOwVSNUEclkj2mriWjuI+vDvnrpyxymEpkXpfTAJ4+FPZ7feiD7Z7/97yS
	 RIMYeoYQK/jWuPsHTiITsh40NinqbSBdUcapynHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Biao Huang <biao.huang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/183] stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed
Date: Mon, 16 Jan 2023 16:50:34 +0100
Message-Id: <20230116154808.056490493@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit c26de7507d1f5ffa5daf6a4980ef7896889691a9 ]

In current driver, MAC will always enable 2ns delay in RGMII mode,
but that's not the correct usage.

Remove the dwmac_fix_mac_speed() in driver, and recommend "rgmii-id"
for phy-mode in device tree.

Fixes: f2d356a6ab71 ("stmmac: dwmac-mediatek: add support for mt8195")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 26 -------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index d42e1afb6521..2f7d8e4561d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -90,7 +90,6 @@ struct mediatek_dwmac_plat_data {
 struct mediatek_dwmac_variant {
 	int (*dwmac_set_phy_interface)(struct mediatek_dwmac_plat_data *plat);
 	int (*dwmac_set_delay)(struct mediatek_dwmac_plat_data *plat);
-	void (*dwmac_fix_mac_speed)(void *priv, unsigned int speed);
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -443,32 +442,9 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 	return 0;
 }
 
-static void mt8195_fix_mac_speed(void *priv, unsigned int speed)
-{
-	struct mediatek_dwmac_plat_data *priv_plat = priv;
-
-	if ((phy_interface_mode_is_rgmii(priv_plat->phy_mode))) {
-		/* prefer 2ns fixed delay which is controlled by TXC_PHASE_CTRL,
-		 * when link speed is 1Gbps with RGMII interface,
-		 * Fall back to delay macro circuit for 10/100Mbps link speed.
-		 */
-		if (speed == SPEED_1000)
-			regmap_update_bits(priv_plat->peri_regmap,
-					   MT8195_PERI_ETH_CTRL0,
-					   MT8195_RGMII_TXC_PHASE_CTRL |
-					   MT8195_DLY_GTXC_ENABLE |
-					   MT8195_DLY_GTXC_INV |
-					   MT8195_DLY_GTXC_STAGES,
-					   MT8195_RGMII_TXC_PHASE_CTRL);
-		else
-			mt8195_set_delay(priv_plat);
-	}
-}
-
 static const struct mediatek_dwmac_variant mt8195_gmac_variant = {
 	.dwmac_set_phy_interface = mt8195_set_interface,
 	.dwmac_set_delay = mt8195_set_delay,
-	.dwmac_fix_mac_speed = mt8195_fix_mac_speed,
 	.clk_list = mt8195_dwmac_clk_l,
 	.num_clks = ARRAY_SIZE(mt8195_dwmac_clk_l),
 	.dma_bit_mask = 35,
@@ -619,8 +595,6 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
 	plat->bsp_priv = priv_plat;
 	plat->init = mediatek_dwmac_init;
 	plat->clks_config = mediatek_dwmac_clks_config;
-	if (priv_plat->variant->dwmac_fix_mac_speed)
-		plat->fix_mac_speed = priv_plat->variant->dwmac_fix_mac_speed;
 
 	plat->safety_feat_cfg = devm_kzalloc(&pdev->dev,
 					     sizeof(*plat->safety_feat_cfg),
-- 
2.35.1



