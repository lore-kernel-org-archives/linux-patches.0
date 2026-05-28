Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0342132ABC0;
	Thu, 28 May 2026 20:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999215; cv=none; b=b2BCgbXwkkHFRRzVOqnhqs/gC0ONtjTEHDsHnJrJXVRpnp+IkRIMngAd0+U0C3Hm4b1tC/F298Dhz0jqxh4DV8cQI35un19YEFyh2I3UVigbys9fyI9XpnjYEJNnr2h1sibuop0QtbM0W84EcEVF4dxDkO8sFphWTX7hzq5MEX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999215; c=relaxed/simple;
	bh=kiBwi/pZehvHzfCB5B00W5BIQsntLdhbj+oQuks8n6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFxeKagO6Gb43SJ6ZvSF+slxwR3IwLusv8H3iXQhfMC2tHHnzcKJ3z0BnWozita7KDmRY2uDfMfHIFjN7g0Q4JOCBv1emkEF3euCaJTYdwCMC+KlctLOjdM+tXcwb9fyPsusZmdjt8F/vGccQsi4pfPJo5MLNI9sjghGl6RBNvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq4+0Pel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq4+0Pel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606001F00A3D;
	Thu, 28 May 2026 20:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999213;
	bh=OxxKu9IpZ4NzhVbRgXJd+NJ8mI02jrfp5rCmOnBY82M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wq4+0Pelj9r/KEcVyj5WY2JpO00Pwh11lwXhYpUPCGuEr170mDUYpedA7vdpRnfnj
	 aHMxEp4ci2j/HjZ7OKOWIcrcmT35E4fZxnYH9knrY+1pZb17VzB8EXvNxqeG9JlSlT
	 vNVh51EcN9fonp9UbMsT+tlizLn94sSZSRrhPruc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <lizhi2@eswincomputing.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 432/461] net: stmmac: eswin: fix HSP CSR init ordering after clock enable
Date: Thu, 28 May 2026 21:49:21 +0200
Message-ID: <20260528194700.031889977@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Li <lizhi2@eswincomputing.com>

[ Upstream commit 23386defe949c0db4f746bed7098fc5e06746083 ]

Fix the initialization ordering of the HSP CSR configuration in the
EIC7700 DWMAC glue driver.

The HSP CSR registers control MAC-side RGMII delay behavior and must
only be accessed after the corresponding clocks are enabled. The
previous implementation could trigger register access before clock
enablement, leading to undefined behavior depending on boot state.

Move the HSP CSR configuration into the post-clock-enable initialization
path to ensure all register accesses occur under valid clock domains.

This change ensures deterministic initialization and prevents
clock-dependent register access failures during probe or resume.

Fixes: ea77dbbdbc4e ("net: stmmac: add Eswin EIC7700 glue driver")
Signed-off-by: Zhi Li <lizhi2@eswincomputing.com>
Link: https://patch.msgid.link/20260518022055.444-1-lizhi2@eswincomputing.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-eic7700.c   | 73 +++++++++++--------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
index bcb8e000e720b..63001c4acdb7a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
@@ -42,6 +42,11 @@ static const char * const eic7700_clk_names[] = {
 
 struct eic7700_qos_priv {
 	struct plat_stmmacenet_data *plat_dat;
+	struct regmap *eic7700_hsp_regmap;
+	u32 eth_axi_lp_ctrl_offset;
+	u32 eth_phy_ctrl_offset;
+	u32 eth_clk_offset;
+	u32 eth_clk_dly_param;
 };
 
 static int eic7700_clks_config(void *priv, bool enabled)
@@ -61,8 +66,28 @@ static int eic7700_clks_config(void *priv, bool enabled)
 static int eic7700_dwmac_init(struct device *dev, void *priv)
 {
 	struct eic7700_qos_priv *dwc = priv;
+	int ret;
+
+	ret = eic7700_clks_config(dwc, true);
+	if (ret)
+		return ret;
+
+	ret = regmap_set_bits(dwc->eic7700_hsp_regmap,
+			      dwc->eth_phy_ctrl_offset,
+			      EIC7700_ETH_TX_CLK_SEL |
+			      EIC7700_ETH_PHY_INTF_SELI);
+	if (ret) {
+		eic7700_clks_config(dwc, false);
+		return ret;
+	}
+
+	regmap_write(dwc->eic7700_hsp_regmap, dwc->eth_axi_lp_ctrl_offset,
+		     EIC7700_ETH_CSYSREQ_VAL);
 
-	return eic7700_clks_config(dwc, true);
+	regmap_write(dwc->eic7700_hsp_regmap, dwc->eth_clk_offset,
+		     dwc->eth_clk_dly_param);
+
+	return 0;
 }
 
 static void eic7700_dwmac_exit(struct device *dev, void *priv)
@@ -93,12 +118,6 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
 	struct eic7700_qos_priv *dwc_priv;
-	struct regmap *eic7700_hsp_regmap;
-	u32 eth_axi_lp_ctrl_offset;
-	u32 eth_phy_ctrl_offset;
-	u32 eth_phy_ctrl_regset;
-	u32 eth_rxd_dly_offset;
-	u32 eth_dly_param = 0;
 	u32 delay_ps;
 	int i, ret;
 
@@ -121,8 +140,9 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 				  "rx-internal-delay-ps", &delay_ps)) {
 		u32 val = min(delay_ps / 100, EIC7700_MAX_DELAY_UNIT);
 
-		eth_dly_param &= ~EIC7700_ETH_RX_ADJ_DELAY;
-		eth_dly_param |= FIELD_PREP(EIC7700_ETH_RX_ADJ_DELAY, val);
+		dwc_priv->eth_clk_dly_param &= ~EIC7700_ETH_RX_ADJ_DELAY;
+		dwc_priv->eth_clk_dly_param |=
+				 FIELD_PREP(EIC7700_ETH_RX_ADJ_DELAY, val);
 	} else {
 		return dev_err_probe(&pdev->dev, -EINVAL,
 			"missing required property rx-internal-delay-ps\n");
@@ -133,53 +153,42 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 				  "tx-internal-delay-ps", &delay_ps)) {
 		u32 val = min(delay_ps / 100, EIC7700_MAX_DELAY_UNIT);
 
-		eth_dly_param &= ~EIC7700_ETH_TX_ADJ_DELAY;
-		eth_dly_param |= FIELD_PREP(EIC7700_ETH_TX_ADJ_DELAY, val);
+		dwc_priv->eth_clk_dly_param &= ~EIC7700_ETH_TX_ADJ_DELAY;
+		dwc_priv->eth_clk_dly_param |=
+				 FIELD_PREP(EIC7700_ETH_TX_ADJ_DELAY, val);
 	} else {
 		return dev_err_probe(&pdev->dev, -EINVAL,
 			"missing required property tx-internal-delay-ps\n");
 	}
 
-	eic7700_hsp_regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
-							     "eswin,hsp-sp-csr");
-	if (IS_ERR(eic7700_hsp_regmap))
+	dwc_priv->eic7700_hsp_regmap =
+			syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+							"eswin,hsp-sp-csr");
+	if (IS_ERR(dwc_priv->eic7700_hsp_regmap))
 		return dev_err_probe(&pdev->dev,
-				PTR_ERR(eic7700_hsp_regmap),
+				PTR_ERR(dwc_priv->eic7700_hsp_regmap),
 				"Failed to get hsp-sp-csr regmap\n");
 
 	ret = of_property_read_u32_index(pdev->dev.of_node,
 					 "eswin,hsp-sp-csr",
-					 1, &eth_phy_ctrl_offset);
+					 1, &dwc_priv->eth_phy_ctrl_offset);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "can't get eth_phy_ctrl_offset\n");
 
-	regmap_read(eic7700_hsp_regmap, eth_phy_ctrl_offset,
-		    &eth_phy_ctrl_regset);
-	eth_phy_ctrl_regset |=
-		(EIC7700_ETH_TX_CLK_SEL | EIC7700_ETH_PHY_INTF_SELI);
-	regmap_write(eic7700_hsp_regmap, eth_phy_ctrl_offset,
-		     eth_phy_ctrl_regset);
-
 	ret = of_property_read_u32_index(pdev->dev.of_node,
 					 "eswin,hsp-sp-csr",
-					 2, &eth_axi_lp_ctrl_offset);
+					 2, &dwc_priv->eth_axi_lp_ctrl_offset);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "can't get eth_axi_lp_ctrl_offset\n");
 
-	regmap_write(eic7700_hsp_regmap, eth_axi_lp_ctrl_offset,
-		     EIC7700_ETH_CSYSREQ_VAL);
-
 	ret = of_property_read_u32_index(pdev->dev.of_node,
 					 "eswin,hsp-sp-csr",
-					 3, &eth_rxd_dly_offset);
+					 3, &dwc_priv->eth_clk_offset);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
-				     "can't get eth_rxd_dly_offset\n");
-
-	regmap_write(eic7700_hsp_regmap, eth_rxd_dly_offset,
-		     eth_dly_param);
+				     "can't get eth_clk_offset\n");
 
 	plat_dat->num_clks = ARRAY_SIZE(eic7700_clk_names);
 	plat_dat->clks = devm_kcalloc(&pdev->dev,
-- 
2.53.0



