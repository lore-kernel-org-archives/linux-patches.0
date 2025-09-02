Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBF30E0F6;
	Tue,  2 Sep 2025 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820424; cv=none; b=qrn1JzsGgWJnH2GIh/znX79U4zCnjkwv30re44Lb3q9SE5XQY/Mm27v0kBQEeFwH3+GommTiuFIN3o3VTFQ5q7jYnF9C8QC2Fl/PXSWkd6UdOmdLzmQBmG+x2M246p17PM+YJF2wL0Bvqk6BHz6wDV9vsYc0r8rLBNJ9ltAsZOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820424; c=relaxed/simple;
	bh=2hozR82bl5QJ5j0qSagjpHm2yO3vAxBj1oxh1tSmNos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O48rQIphT26ykdVuO0EVUwXhPLNVW9MGWDqUjQZRJqeQVBp1Qi0K+Q2oO9LZrrOvZ//J4O5vDvsc+VOV+DN8Gqx3YblVKwLmF45DrA+BQZ4QA4xsqRbUR/sdyXaLjY/tEgv3PEGAdZSfLWUHIDxuiqBTQTyqYx0JTXIiW296Fvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg1wTK0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg1wTK0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F18C4CEF4;
	Tue,  2 Sep 2025 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820424;
	bh=2hozR82bl5QJ5j0qSagjpHm2yO3vAxBj1oxh1tSmNos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg1wTK0jm3D3K1oWcxrjt6Gtt4iHe/UCp8yYR4ODM+69ih14F5AJdvCPI2d5/0JJH
	 syE3dS2dwf5HFspOoX3FM+7TZWeH3JZ217ImzNCkN0H3nhTomKAxRxVrn7GukDSpez
	 /B0l7aZ6IXaBy3fOg3HdK6E+yoagkVSMSO/v+eaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/50] phy: mscc: Fix when PTP clock is register and unregister
Date: Tue,  2 Sep 2025 15:21:15 +0200
Message-ID: <20250902131931.486776620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 882e57cbc7204662f6c5672d5b04336c1d790b03 ]

It looks like that every time when the interface was set down and up the
driver was creating a new ptp clock. On top of this the function
ptp_clock_unregister was never called.
Therefore fix this by calling ptp_clock_register and initialize the
mii_ts struct inside the probe function and call ptp_clock_unregister when
driver is removed.

Fixes: 7d272e63e0979d ("net: phy: mscc: timestamping and PHC support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250825065543.2916334-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      |  4 ++++
 drivers/net/phy/mscc/mscc_main.c |  4 +---
 drivers/net/phy/mscc/mscc_ptp.c  | 34 ++++++++++++++++++++------------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 878298304430c..fcfbff691b3c6 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -474,6 +474,7 @@ static inline void vsc8584_config_macsec_intr(struct phy_device *phydev)
 void vsc85xx_link_change_notify(struct phy_device *phydev);
 void vsc8584_config_ts_intr(struct phy_device *phydev);
 int vsc8584_ptp_init(struct phy_device *phydev);
+void vsc8584_ptp_deinit(struct phy_device *phydev);
 int vsc8584_ptp_probe_once(struct phy_device *phydev);
 int vsc8584_ptp_probe(struct phy_device *phydev);
 irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev);
@@ -488,6 +489,9 @@ static inline int vsc8584_ptp_init(struct phy_device *phydev)
 {
 	return 0;
 }
+static inline void vsc8584_ptp_deinit(struct phy_device *phydev)
+{
+}
 static inline int vsc8584_ptp_probe_once(struct phy_device *phydev)
 {
 	return 0;
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 36734bb217e42..2fabb6a7d2415 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2326,9 +2326,7 @@ static int vsc85xx_probe(struct phy_device *phydev)
 
 static void vsc85xx_remove(struct phy_device *phydev)
 {
-	struct vsc8531_private *priv = phydev->priv;
-
-	skb_queue_purge(&priv->rx_skbs_list);
+	vsc8584_ptp_deinit(phydev);
 }
 
 /* Microsemi VSC85xx PHYs */
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index add1a9ee721af..1f6237705b44b 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1297,7 +1297,6 @@ static void vsc8584_set_input_clk_configured(struct phy_device *phydev)
 
 static int __vsc8584_init_ptp(struct phy_device *phydev)
 {
-	struct vsc8531_private *vsc8531 = phydev->priv;
 	static const u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
 	static const u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
 	u32 val;
@@ -1514,17 +1513,7 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 
 	vsc85xx_ts_eth_cmp1_sig(phydev);
 
-	vsc8531->mii_ts.rxtstamp = vsc85xx_rxtstamp;
-	vsc8531->mii_ts.txtstamp = vsc85xx_txtstamp;
-	vsc8531->mii_ts.hwtstamp = vsc85xx_hwtstamp;
-	vsc8531->mii_ts.ts_info  = vsc85xx_ts_info;
-	phydev->mii_ts = &vsc8531->mii_ts;
-
-	memcpy(&vsc8531->ptp->caps, &vsc85xx_clk_caps, sizeof(vsc85xx_clk_caps));
-
-	vsc8531->ptp->ptp_clock = ptp_clock_register(&vsc8531->ptp->caps,
-						     &phydev->mdio.dev);
-	return PTR_ERR_OR_ZERO(vsc8531->ptp->ptp_clock);
+	return 0;
 }
 
 void vsc8584_config_ts_intr(struct phy_device *phydev)
@@ -1551,6 +1540,16 @@ int vsc8584_ptp_init(struct phy_device *phydev)
 	return 0;
 }
 
+void vsc8584_ptp_deinit(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+
+	if (vsc8531->ptp->ptp_clock) {
+		ptp_clock_unregister(vsc8531->ptp->ptp_clock);
+		skb_queue_purge(&vsc8531->rx_skbs_list);
+	}
+}
+
 irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev)
 {
 	struct vsc8531_private *priv = phydev->priv;
@@ -1608,7 +1607,16 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
 
 	vsc8531->ptp->phydev = phydev;
 
-	return 0;
+	vsc8531->mii_ts.rxtstamp = vsc85xx_rxtstamp;
+	vsc8531->mii_ts.txtstamp = vsc85xx_txtstamp;
+	vsc8531->mii_ts.hwtstamp = vsc85xx_hwtstamp;
+	vsc8531->mii_ts.ts_info  = vsc85xx_ts_info;
+	phydev->mii_ts = &vsc8531->mii_ts;
+
+	memcpy(&vsc8531->ptp->caps, &vsc85xx_clk_caps, sizeof(vsc85xx_clk_caps));
+	vsc8531->ptp->ptp_clock = ptp_clock_register(&vsc8531->ptp->caps,
+						     &phydev->mdio.dev);
+	return PTR_ERR_OR_ZERO(vsc8531->ptp->ptp_clock);
 }
 
 int vsc8584_ptp_probe_once(struct phy_device *phydev)
-- 
2.50.1



