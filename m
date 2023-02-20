Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4E263B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224C6C433D2;
	Mon, 20 Feb 2023 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901291;
	bh=Oo2/GMbAnH4vVzlZfi6s07yWdE7kvaXlDm1kDBtnz78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeJOnjx8D9ooT5vXK47njN0MRwTasF/ucdzIokf+iafYDqX8vybnVQVS7Q/IcaALX
	 qCUCn85CY4ae7CPta5e3yA0Ns+xjxP1U7RFB98fNpcSeY6iTfECbOI7w6cKI5Ox08k
	 cDmmVamWZ4BKwoF2xUj9zxYRB+/XvLN+dgY9X8fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andrey.konovalov@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/57] net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC
Date: Mon, 20 Feb 2023 14:36:15 +0100
Message-Id: <20230220133549.617002264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrey Konovalov <andrey.konovalov@linaro.org>

[ Upstream commit 54aa39a513dbf2164ca462a19f04519b2407a224 ]

Currently in phy_init_eee() the driver unconditionally configures the PHY
to stop RX_CLK after entering Rx LPI state. This causes an LPI interrupt
storm on my qcs404-base board.

Change the PHY initialization so that for "qcom,qcs404-ethqos" compatible
device RX_CLK continues to run even in Rx LPI state.

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 ++-
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index bfc4a92f1d92b..78be62ecc9a9a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -505,6 +505,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
+	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
+		plat_dat->rx_clk_runs_in_lpi = 1;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b52ca2fe04d87..1ec000d4c7705 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1058,7 +1058,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-		priv->eee_active = phy_init_eee(phy, 1) >= 0;
+		priv->eee_active =
+			phy_init_eee(phy, !priv->plat->rx_clk_runs_in_lpi) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 40df88728a6f4..abf7b8ec1fb64 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -199,6 +199,7 @@ struct plat_stmmacenet_data {
 	int rss_en;
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
+	bool rx_clk_runs_in_lpi;
 	int has_xgmac;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
-- 
2.39.0



