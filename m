Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BD33A702;
	Thu, 28 May 2026 20:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999247; cv=none; b=jcu3t4+Fk/zMLw3JulPxar5udgb0aWNNXWhle/1BHj9iovsGoLdKfueUWdr0DoS+Luqw3xL/7JpAvBLvzErawIh7Wyt+X15JQuF5F/eCeyPBGe7UTbs2ABXqdfaEgwVWnCxWk32Lh821YBGhPM3ZnBgMeZvrpxzQZBjgi/e30vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999247; c=relaxed/simple;
	bh=VowR2scbdusePTs0U4CDg+eJrs8JcBFCg6s3dZD897s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQzq3MiYA8J8Kxkq8oce2KyBJsG89WGyYWNOi7Dur+yPM3zZdIZdlMaBX3j2CeyCHX4Y1C904SCwTh4NEdF2O5S8pscXf3FQ24zYga6IpuhBuQUL1Mqnc5SeSBFeUwD5KyfUWZ7WrTEnQ8W1o8gHq0pd4RZANCnJvNp4BXTHuh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MV61kyb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MV61kyb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CE61F000E9;
	Thu, 28 May 2026 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999246;
	bh=XytJLuhJxN2saDJOQmUokp2foqLjnGScQkVj7PVCvPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MV61kyb+dX0l00DZapGsZbSo7MdxdePh3uzXmDHhmGfdV5zceuH0GLOEizPup/BT7
	 PnW6xMW+XhIw7lR1EKHrpwaP+IzzIRPOKfj6Z2F54GjtY9pynnQAvqT+ZZWeY5pZru
	 Tf7KMpQNsts9sWDQtO1KL1hhYRD2I6NQpkurcAq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <lizhi2@eswincomputing.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 433/461] net: stmmac: eswin: clear TXD and RXD delay registers during initialization
Date: Thu, 28 May 2026 21:49:22 +0200
Message-ID: <20260528194700.060188130@linuxfoundation.org>
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

[ Upstream commit 6872fb088edc1a3c36792b301f8e4a1c35dd7c35 ]

Clear the TXD and RXD delay control registers during EIC7700 DWMAC
initialization.

These registers may retain values programmed by the bootloader. If left
unchanged, residual delays can alter the effective RGMII timing seen by
the MAC and override the configuration described by the device tree.

This may violate the expected RGMII timing model and can cause link
instability or prevent the Ethernet controller from operating correctly.

Explicitly clearing these registers ensures that the MAC delay settings
are determined solely by the kernel configuration.

The corresponding register offsets are optional, and the registers are
only cleared when the offsets are provided in the device tree.

Fixes: ea77dbbdbc4e ("net: stmmac: add Eswin EIC7700 glue driver")
Signed-off-by: Zhi Li <lizhi2@eswincomputing.com>
Link: https://patch.msgid.link/20260518022137.464-1-lizhi2@eswincomputing.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-eic7700.c   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
index 63001c4acdb7a..541b279f08a17 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
@@ -46,7 +46,11 @@ struct eic7700_qos_priv {
 	u32 eth_axi_lp_ctrl_offset;
 	u32 eth_phy_ctrl_offset;
 	u32 eth_clk_offset;
+	u32 eth_txd_offset;
+	u32 eth_rxd_offset;
 	u32 eth_clk_dly_param;
+	bool has_txd_offset;
+	bool has_rxd_offset;
 };
 
 static int eic7700_clks_config(void *priv, bool enabled)
@@ -84,6 +88,12 @@ static int eic7700_dwmac_init(struct device *dev, void *priv)
 	regmap_write(dwc->eic7700_hsp_regmap, dwc->eth_axi_lp_ctrl_offset,
 		     EIC7700_ETH_CSYSREQ_VAL);
 
+	if (dwc->has_txd_offset)
+		regmap_write(dwc->eic7700_hsp_regmap, dwc->eth_txd_offset, 0);
+
+	if (dwc->has_rxd_offset)
+		regmap_write(dwc->eic7700_hsp_regmap, dwc->eth_rxd_offset, 0);
+
 	regmap_write(dwc->eic7700_hsp_regmap, dwc->eth_clk_offset,
 		     dwc->eth_clk_dly_param);
 
@@ -190,6 +200,18 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret,
 				     "can't get eth_clk_offset\n");
 
+	ret = of_property_read_u32_index(pdev->dev.of_node,
+					 "eswin,hsp-sp-csr",
+					 4, &dwc_priv->eth_txd_offset);
+	if (!ret)
+		dwc_priv->has_txd_offset = true;
+
+	ret = of_property_read_u32_index(pdev->dev.of_node,
+					 "eswin,hsp-sp-csr",
+					 5, &dwc_priv->eth_rxd_offset);
+	if (!ret)
+		dwc_priv->has_rxd_offset = true;
+
 	plat_dat->num_clks = ARRAY_SIZE(eic7700_clk_names);
 	plat_dat->clks = devm_kcalloc(&pdev->dev,
 				      plat_dat->num_clks,
-- 
2.53.0



