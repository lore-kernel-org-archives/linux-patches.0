Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE650307482;
	Tue,  2 Sep 2025 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819568; cv=none; b=aVy0ym1MlAbuUvW1xYBEnSTMWzKJ03LyT78xwDy38PdBRjVf3HWYGl9TVRpW4mRmjaDychpQtDtwcSSOF+9+U0oRwdUqsLqe4eyCyFvqLZoqRAKeMJrzgeZ/I/BKigaNtKeIiDXcAng58KBoeGZGzFu0xq6TWCC3aoRXyq9xnpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819568; c=relaxed/simple;
	bh=97R8KmSEX10wFTRa9qw6liX85wIl2E9m3W+rYsEdQ04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgRy4j8ZySDOoC2RFOrfWlCxKDU0qSCK2sOSQ8l6Gf/bqPAa0qJ/POtzAB9peQ01/87oyTFgw66+aUFZ5CwhUph+8oNp5+gzVBXwZTistG2k7V5XsMvbp1Ge1BoMsFeIg6OveSxCQpQENKrA8REZHluePwKdvtMfif8zi60nhiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVQ59L71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVQ59L71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034ABC4CEF4;
	Tue,  2 Sep 2025 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819567;
	bh=97R8KmSEX10wFTRa9qw6liX85wIl2E9m3W+rYsEdQ04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVQ59L71dnZwCPsw0fOBDPKiHfkXfsaIQx3KeygmR+NJUADd7YRm/nDT9OZJMHGpB
	 X1Qi6C5XOYO+J4msE0BLxsvPmQjux6ONOehGHWr+cG/RiNdq2qXWRghIDSBJ4G8il8
	 wqaz0Tn12RYzyx1KM6P0aV7N/wciHrt5Ys9pCzok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 073/142] phy: mscc: Fix when PTP clock is register and unregister
Date: Tue,  2 Sep 2025 15:19:35 +0200
Message-ID: <20250902131951.065484783@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 58c6d47fbe046..2bfe314ef881c 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -481,6 +481,7 @@ static inline void vsc8584_config_macsec_intr(struct phy_device *phydev)
 void vsc85xx_link_change_notify(struct phy_device *phydev);
 void vsc8584_config_ts_intr(struct phy_device *phydev);
 int vsc8584_ptp_init(struct phy_device *phydev);
+void vsc8584_ptp_deinit(struct phy_device *phydev);
 int vsc8584_ptp_probe_once(struct phy_device *phydev);
 int vsc8584_ptp_probe(struct phy_device *phydev);
 irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev);
@@ -495,6 +496,9 @@ static inline int vsc8584_ptp_init(struct phy_device *phydev)
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
index c3209cf00e960..ac9b6130ef502 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2338,9 +2338,7 @@ static int vsc85xx_probe(struct phy_device *phydev)
 
 static void vsc85xx_remove(struct phy_device *phydev)
 {
-	struct vsc8531_private *priv = phydev->priv;
-
-	skb_queue_purge(&priv->rx_skbs_list);
+	vsc8584_ptp_deinit(phydev);
 }
 
 /* Microsemi VSC85xx PHYs */
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index de6c7312e8f29..72847320cb652 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1298,7 +1298,6 @@ static void vsc8584_set_input_clk_configured(struct phy_device *phydev)
 
 static int __vsc8584_init_ptp(struct phy_device *phydev)
 {
-	struct vsc8531_private *vsc8531 = phydev->priv;
 	static const u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
 	static const u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
 	u32 val;
@@ -1515,17 +1514,7 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 
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
@@ -1552,6 +1541,16 @@ int vsc8584_ptp_init(struct phy_device *phydev)
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
@@ -1612,7 +1611,16 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
 
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



