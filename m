Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD0C3750D6;
	Sat, 12 Sep 2026 09:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205044; cv=none; b=KPOKzXWzGLXLylbMkt/FncSFJ2yULBJBnkPPNAmKzKrooy22uiSG4an75NwmZVuAEizK1d/b1jolIDgWGiT5pOsjJlqvjNeR2o6pUwBxewlXtY9uWj/cXCT//q3Jjaq4fT45B7jgL8Uj0C2U7hGcE2qcH3vr96aNS3PkLCzApE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205044; c=relaxed/simple;
	bh=RJ+VuBd2y6vZZVqpBaCNPv8pAXu+34wKC3VrFQOJv9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH8LfhTOHkSoBv93xX98tYnkX0lmKbuGzYqzNu3mp2FKgeD7B5GwthEefjkP5NHKBrTNit3ArdxwZov6C/5O3oyROhg5qpAu/gQgKFOLn0U3kOMiL2cAAZ5GMZ853/eR5JBCDTQFTR4O7TZL/LtE+G+7phYzD3rTXi+J/kcRKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyag735i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyag735i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D791F000FF;
	Sat, 12 Sep 2026 09:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205042;
	bh=szmjyl56iqj1OaPqjtirS+g4VnKoaANxGm/Sg9X3Dwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyag735iNinefCyGpqIkk13TMR6vpcNqnxtT44sVpVCSHTSO3KO7U8zGh+sRNTUz7
	 2W33xTwh/4YAg0eHjDOEWpuL9z7nhY42GhCphkOXaYgeGlMeqM0tM0fIJ4O0ucJcqQ
	 ZCs71v1fMYpytDm3kcBjMKsvGYcJh8sV3TO1wHJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1735/1815] net: enetc: restore RX ring congestion mode after ring reconfiguration
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065729.711472817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 9e94d8e14ae45e3fda8c0919f745db3ed3715433 ]

The RX ring congestion mode (CM) is only configured in the phylink
.mac_link_up() callback enetc_pl_mac_link_up(), which sets the
ENETC_RBMR_CM bit when tx_pause is enabled. This callback runs only when
the link status changes.

However, enetc_reconfigure() tears down and re-creates the RX BD rings at
runtime without any link status change, for example when attaching or
detaching an XDP program, or when enabling/disabling PTP RX hardware
timestamping. The rings are rebuilt from a cleared RBMR, so the CM bit is
lost. Since the link status does not change, enetc_pl_mac_link_up() is
not called again and the CM bit is never restored.

As a result, the ENETC MAC can no longer generate PAUSE frames on ingress
congestion, and flow control stops working after such a reconfiguration.

Track the desired CM state in a software flag ENETC_RXBDR_CM. Set or clear
this flag in enetc_pl_mac_link_up() according to tx_pause. When the RX BD
rings are (re)enabled, enetc_enable_rxbdr() consults this flag and restores
the ENETC_RBMR_CM bit accordingly, so flow control survives ring
reconfiguration even when the link status does not change.

RBMR is now written as a whole word from enetc_enable_rxbdr() rather than
by read-modify-write from several call sites. Serialize the remaining RBMR
read-modify-write paths, the congestion mode update and the RX VLAN offload
update, with the new si->gen_lock so they cannot race each other.

Fixes: 5093406c784f ("net: enetc: implement ring reconfiguration procedure for PTP RX timestamping")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260821064140.1315611-2-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 72 +++++++++++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 14 +---
 3 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8e3f345dd9aac..80f0082f6c633 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -81,6 +81,33 @@ void enetc_reset_mac_addr_filter(struct enetc_mac_filter *filter)
 }
 EXPORT_SYMBOL_GPL(enetc_reset_mac_addr_filter);
 
+void enetc_set_congestion_mode(struct enetc_ndev_priv *priv, bool enable)
+{
+	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &si->hw;
+
+	spin_lock(&si->gen_lock);
+
+	if (enable)
+		set_bit(ENETC_RXBDR_CM, &priv->flags);
+	else
+		clear_bit(ENETC_RXBDR_CM, &priv->flags);
+
+	for (int i = 0; i < priv->num_rx_rings; i++) {
+		u32 old_rbmr = enetc_rxbdr_rd(hw, i, ENETC_RBMR);
+		u32 rbmr;
+
+		rbmr = u32_replace_bits(old_rbmr, enable, ENETC_RBMR_CM);
+		if (rbmr == old_rbmr)
+			continue;
+
+		enetc_rxbdr_wr(hw, i, ENETC_RBMR, rbmr);
+	}
+
+	spin_unlock(&si->gen_lock);
+}
+EXPORT_SYMBOL_GPL(enetc_set_congestion_mode);
+
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
@@ -2632,7 +2659,6 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 			      bool extended)
 {
 	int idx = rx_ring->index;
-	u32 rbmr = 0;
 
 	enetc_rxbdr_wr(hw, idx, ENETC_RBBAR0,
 		       lower_32_bits(rx_ring->bd_dma_base));
@@ -2660,12 +2686,6 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
 
 	rx_ring->ext_en = extended;
-	if (rx_ring->ext_en)
-		rbmr |= ENETC_RBMR_BDS;
-
-	if (rx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
-		rbmr |= ENETC_RBMR_VTE;
-
 	rx_ring->rcir = hw->reg + ENETC_BDR(RX, idx, ENETC_RBCIR);
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
@@ -2676,8 +2696,6 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 	enetc_lock_mdio();
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
 	enetc_unlock_mdio();
-
-	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
 }
 
 static void enetc_setup_bdrs(struct enetc_ndev_priv *priv, bool extended)
@@ -2704,21 +2722,34 @@ static void enetc_enable_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 
 static void enetc_enable_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 {
+	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
 	int idx = rx_ring->index;
-	u32 rbmr;
+	u32 rbmr = ENETC_RBMR_EN;
+
+	if (rx_ring->ext_en)
+		rbmr |= ENETC_RBMR_BDS;
+
+	if (rx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		rbmr |= ENETC_RBMR_VTE;
+
+	if (test_bit(ENETC_RXBDR_CM, &priv->flags))
+		rbmr |= ENETC_RBMR_CM;
 
-	rbmr = enetc_rxbdr_rd(hw, idx, ENETC_RBMR);
-	rbmr |= ENETC_RBMR_EN;
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
 }
 
 static void enetc_enable_rx_bdrs(struct enetc_ndev_priv *priv)
 {
-	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &si->hw;
 	int i;
 
+	spin_lock(&si->gen_lock);
+
 	for (i = 0; i < priv->num_rx_rings; i++)
 		enetc_enable_rxbdr(hw, priv->rx_ring[i]);
+
+	spin_unlock(&si->gen_lock);
 }
 
 static void enetc_enable_tx_bdrs(struct enetc_ndev_priv *priv)
@@ -2748,11 +2779,16 @@ static void enetc_disable_txbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 static void enetc_disable_rx_bdrs(struct enetc_ndev_priv *priv)
 {
-	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &si->hw;
 	int i;
 
+	spin_lock(&si->gen_lock);
+
 	for (i = 0; i < priv->num_rx_rings; i++)
 		enetc_disable_rxbdr(hw, priv->rx_ring[i]);
+
+	spin_unlock(&si->gen_lock);
 }
 
 static void enetc_disable_tx_bdrs(struct enetc_ndev_priv *priv)
@@ -3344,11 +3380,16 @@ EXPORT_SYMBOL_GPL(enetc_get_stats);
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &si->hw;
 	int i;
 
+	spin_lock(&si->gen_lock);
+
 	for (i = 0; i < priv->num_rx_rings; i++)
 		enetc_bdr_enable_rxvlan(hw, i, en);
+
+	spin_unlock(&si->gen_lock);
 }
 
 static void enetc_enable_txvlan(struct net_device *ndev, bool en)
@@ -3679,6 +3720,7 @@ int enetc_pci_probe(struct pci_dev *pdev, const char *name, int sizeof_priv)
 
 	si = PTR_ALIGN(p, ENETC_SI_ALIGN);
 	si->pad = (char *)si - (char *)p;
+	spin_lock_init(&si->gen_lock);
 
 	pci_set_drvdata(pdev, si);
 	si->pdev = pdev;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 04a5dd5ea6c74..41357c5611084 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -309,6 +309,13 @@ struct enetc_si {
 
 	struct net_device *ndev; /* back ref. */
 
+	/* General-purpose lock serializing updates that must not race,
+	 * e.g. read-modify-write of shared hardware registers and of
+	 * selected priv->flags bits between the phylink link callbacks
+	 * and the ring (re)configuration path.
+	 */
+	spinlock_t gen_lock;
+
 	union {
 		struct enetc_cbdr cbd_ring; /* Only ENETC 1.0 */
 		struct ntmp_user ntmp_user; /* ENETC 4.1 and later */
@@ -419,6 +426,7 @@ enum enetc_active_offloads {
 enum enetc_flags_bit {
 	ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS = 0,
 	ENETC_TX_DOWN,
+	ENETC_RXBDR_CM,
 };
 
 /* interrupt coalescing modes */
@@ -507,6 +515,7 @@ int enetc_get_driver_data(struct enetc_si *si);
 void enetc_add_mac_addr_ht_filter(struct enetc_mac_filter *filter,
 				  const unsigned char *addr);
 void enetc_reset_mac_addr_filter(struct enetc_mac_filter *filter);
+void enetc_set_congestion_mode(struct enetc_ndev_priv *priv, bool enable);
 
 int enetc_open(struct net_device *ndev);
 int enetc_close(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 2d687bb8c3a06..83e47eef1acd0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -608,8 +608,7 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	struct enetc_hw *hw = &pf->si->hw;
 	struct enetc_si *si = pf->si;
 	struct enetc_ndev_priv *priv;
-	u32 rbmr, cmd_cfg;
-	int idx;
+	u32 cmd_cfg;
 
 	priv = netdev_priv(pf->si->ndev);
 
@@ -621,16 +620,7 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 		enetc_force_rgmii_mac(si, speed, duplex);
 
 	/* Flow control */
-	for (idx = 0; idx < priv->num_rx_rings; idx++) {
-		rbmr = enetc_rxbdr_rd(hw, idx, ENETC_RBMR);
-
-		if (tx_pause)
-			rbmr |= ENETC_RBMR_CM;
-		else
-			rbmr &= ~ENETC_RBMR_CM;
-
-		enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
-	}
+	enetc_set_congestion_mode(priv, tx_pause);
 
 	if (tx_pause) {
 		/* When the port first enters congestion, send a PAUSE request
-- 
2.53.0



