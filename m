Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9753A272E7C;
	Tue,  2 Sep 2025 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820630; cv=none; b=p+RnJtq8ho7c8XW45D9WzdTiatmQqGKfRaqFTiFl+vNbf/ZMPhHy+m+UKhZ282YQsUYukE87noQMsi8tnXusSoLpR+ZAOTnd1GVh7QITKur4XJDvZ2749h6HzY9fcjguavqSWSk8CQgwS9iHHIcBi1O+6ITvMb3qRmVIIOSwmxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820630; c=relaxed/simple;
	bh=j1X6MgmJLSUiHPveFbmMcVxSr6y4zN5I//AVKQTMbgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L919rXQR16RkyvpP+bjn9StJZLEmtzz4FtQYX8RSbGJvpmCf2zw4Hbou8A1J1SDkbU9UHPn2PGNt+hJWb19Mg3PGWuZ1uSEHfd5DSSwEjqpI70tvlO2rkrVXn64nNh68e6iOSdSHdu57cQ/UeXdelZRENM3EbhtFxUovYSUWmdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUEoDZ+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUEoDZ+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB37C4CEED;
	Tue,  2 Sep 2025 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820630;
	bh=j1X6MgmJLSUiHPveFbmMcVxSr6y4zN5I//AVKQTMbgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUEoDZ+VKW6l5WmQag8+EymmRiA9F8qo+7z9LQKh12lcuClbXJiHm6bOcGQshUpxa
	 KymBk7ErRFlAk0+lmLKqOPDOGe77zPQssFcIGKh4LH5RduPI/vfGY2fKmz2no52cFJ
	 jwyTLg3lqH4c2SmbEekaBgkEySnbMGrmymVvpWBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/33] phy: mscc: Fix when PTP clock is register and unregister
Date: Tue,  2 Sep 2025 15:21:32 +0200
Message-ID: <20250902131927.612278481@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 03aa85ec60dfc..982e73adf2bcf 100644
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
index f77bfbee5f20b..e30e6ba9da2f4 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1294,7 +1294,6 @@ static void vsc8584_set_input_clk_configured(struct phy_device *phydev)
 
 static int __vsc8584_init_ptp(struct phy_device *phydev)
 {
-	struct vsc8531_private *vsc8531 = phydev->priv;
 	static const u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
 	static const u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
 	u32 val;
@@ -1511,17 +1510,7 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 
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
@@ -1548,6 +1537,16 @@ int vsc8584_ptp_init(struct phy_device *phydev)
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
@@ -1605,7 +1604,16 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
 
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



