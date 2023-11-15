Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177C03BB33
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ2QRZJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4F8C433C8;
	Wed, 15 Nov 2023 19:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077993;
	bh=4ecyrHuk5Vh596YSNIYzuzYq3P01zE4UBbM0RzFyCvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ2QRZJv1Y9qrc2TjNlerQbs7acW7aY9g4R9IE1aFo+BoxcOVE+Gu4lAYlEDzhrVz
	 dGwVFjLnLBPWA0wcIyRCWOVzI09wdLpl3jW3BB/IoyV6vtO1vCJXhcWLJcqrTjiyOn
	 UxD48RztSMC+zBXuYnjGXjxx+loTELzFqRCG8meQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/379] wifi: mt76: mt7603: improve stuck beacon handling
Date: Wed, 15 Nov 2023 14:21:59 -0500
Message-ID: <20231115192647.760012747@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3176205933494bd184c6acd70e796c382bc729b5 ]

Before preparing the new beacon, check the queue status, flush out all
previous beacons and buffered multicast packets, then (if necessary)
try to recover more gracefully from a stuck beacon condition by making a
less invasive attempt at getting the MAC un-stuck.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7603/beacon.c    | 76 ++++++++++++++-----
 .../net/wireless/mediatek/mt76/mt7603/regs.h  |  5 ++
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index b65b0a88c1ded..808466b7de472 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -9,6 +9,23 @@ struct beacon_bc_data {
 	int count[MT7603_MAX_INTERFACES];
 };
 
+static void
+mt7603_mac_stuck_beacon_recovery(struct mt7603_dev *dev)
+{
+	if (dev->beacon_check % 5 != 4)
+		return;
+
+	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_EN);
+	mt76_set(dev, MT_SCH_4, MT_SCH_4_RESET);
+	mt76_clear(dev, MT_SCH_4, MT_SCH_4_RESET);
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_EN);
+
+	mt76_set(dev, MT_WF_CFG_OFF_WOCCR, MT_WF_CFG_OFF_WOCCR_TMAC_GC_DIS);
+	mt76_set(dev, MT_ARB_SCR, MT_ARB_SCR_TX_DISABLE);
+	mt76_clear(dev, MT_ARB_SCR, MT_ARB_SCR_TX_DISABLE);
+	mt76_clear(dev, MT_WF_CFG_OFF_WOCCR, MT_WF_CFG_OFF_WOCCR_TMAC_GC_DIS);
+}
+
 static void
 mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
@@ -16,6 +33,8 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
 	struct sk_buff *skb = NULL;
+	u32 om_idx = mvif->idx;
+	u32 val;
 
 	if (!(mdev->beacon_mask & BIT(mvif->idx)))
 		return;
@@ -24,20 +43,33 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	if (!skb)
 		return;
 
-	mt76_tx_queue_skb(dev, dev->mphy.q_tx[MT_TXQ_BEACON],
-			  MT_TXQ_BEACON, skb, &mvif->sta.wcid, NULL);
+	if (om_idx)
+		om_idx |= 0x10;
+	val = MT_DMA_FQCR0_BUSY | MT_DMA_FQCR0_MODE |
+		FIELD_PREP(MT_DMA_FQCR0_TARGET_BSS, om_idx) |
+		FIELD_PREP(MT_DMA_FQCR0_DEST_PORT_ID, 3) |
+		FIELD_PREP(MT_DMA_FQCR0_DEST_QUEUE_ID, 8);
 
 	spin_lock_bh(&dev->ps_lock);
-	mt76_wr(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY |
-		FIELD_PREP(MT_DMA_FQCR0_TARGET_WCID, mvif->sta.wcid.idx) |
-		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID,
-			   dev->mphy.q_tx[MT_TXQ_CAB]->hw_idx) |
-		FIELD_PREP(MT_DMA_FQCR0_DEST_PORT_ID, 3) |
-		FIELD_PREP(MT_DMA_FQCR0_DEST_QUEUE_ID, 8));
 
-	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000))
+	mt76_wr(dev, MT_DMA_FQCR0, val |
+		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BCN));
+	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		goto out;
+	}
+
+	mt76_wr(dev, MT_DMA_FQCR0, val |
+		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BMC));
+	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
+		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		goto out;
+	}
 
+	mt76_tx_queue_skb(dev, dev->mphy.q_tx[MT_TXQ_BEACON],
+			  MT_TXQ_BEACON, skb, &mvif->sta.wcid, NULL);
+
+out:
 	spin_unlock_bh(&dev->ps_lock);
 }
 
@@ -81,6 +113,18 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 	data.dev = dev;
 	__skb_queue_head_init(&data.q);
 
+	/* Flush all previous CAB queue packets and beacons */
+	mt76_wr(dev, MT_WF_ARB_CAB_FLUSH, GENMASK(30, 16) | BIT(0));
+
+	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_CAB], false);
+	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_BEACON], false);
+
+	if (dev->mphy.q_tx[MT_TXQ_BEACON]->queued > 0)
+		dev->beacon_check++;
+	else
+		dev->beacon_check = 0;
+	mt7603_mac_stuck_beacon_recovery(dev);
+
 	q = dev->mphy.q_tx[MT_TXQ_BEACON];
 	spin_lock(&q->lock);
 	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
@@ -89,14 +133,9 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 	mt76_queue_kick(dev, q);
 	spin_unlock(&q->lock);
 
-	/* Flush all previous CAB queue packets */
-	mt76_wr(dev, MT_WF_ARB_CAB_FLUSH, GENMASK(30, 16) | BIT(0));
-
-	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_CAB], false);
-
 	mt76_csa_check(mdev);
 	if (mdev->csa_complete)
-		goto out;
+		return;
 
 	q = dev->mphy.q_tx[MT_TXQ_CAB];
 	do {
@@ -108,7 +147,7 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 		 skb_queue_len(&data.q) < 8);
 
 	if (skb_queue_empty(&data.q))
-		goto out;
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(data.tail); i++) {
 		if (!data.tail[i])
@@ -136,11 +175,6 @@ void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 		MT_WF_ARB_CAB_START_BSSn(0) |
 		(MT_WF_ARB_CAB_START_BSS0n(1) *
 		 ((1 << (MT7603_MAX_INTERFACES - 1)) - 1)));
-
-out:
-	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_BEACON], false);
-	if (dev->mphy.q_tx[MT_TXQ_BEACON]->queued > hweight8(mdev->beacon_mask))
-		dev->beacon_check++;
 }
 
 void mt7603_beacon_set_timer(struct mt7603_dev *dev, int idx, int intval)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
index 3b901090b29c6..9b84db233aceb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
@@ -462,6 +462,11 @@ enum {
 #define MT_WF_SEC_BASE			0x21a00
 #define MT_WF_SEC(ofs)			(MT_WF_SEC_BASE + (ofs))
 
+#define MT_WF_CFG_OFF_BASE		0x21e00
+#define MT_WF_CFG_OFF(ofs)		(MT_WF_CFG_OFF_BASE + (ofs))
+#define MT_WF_CFG_OFF_WOCCR		MT_WF_CFG_OFF(0x004)
+#define MT_WF_CFG_OFF_WOCCR_TMAC_GC_DIS	BIT(4)
+
 #define MT_SEC_SCR			MT_WF_SEC(0x004)
 #define MT_SEC_SCR_MASK_ORDER		GENMASK(1, 0)
 
-- 
2.42.0



