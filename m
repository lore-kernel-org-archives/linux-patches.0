Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AC94F473D;
	Tue, 13 Oct 2026 11:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892610; cv=none; b=l9hOOPksPtpK1hI5DbM/sHtfLtUAZWsWh8bvtN5Cld8m+G6umM9bvANAR9U8tPAtiKLAqoXOAbrPokKMDfTaokIJo2ZoQx2vLbQFufziPFUVd4tyYgzp9HKomw04fof8s0/YDyz8yhROiJydJes67buPM/fa7hdgbqDUJge6xJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892610; c=relaxed/simple;
	bh=TpibDACyLEUiesezbwgP/5FTAOsoQQgLPUSz/+70z4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyzTTHnyXKDxNaigwM6vaOy9SmyVxTP3bIOYl+5gB5L9KRyAHyxy5rcM9c2q9ztl6TKtAbn2++HeQgG+YZonLQ5cSSNmmkK4Okxb89A4MaoF7qu6YR3MMDFxNCEL9YtGKgcZRgJgeHwpJRZPf/0T3QzPO9HIKcCNuN+9Luj7LCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efRgSPaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efRgSPaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F041F000FF;
	Tue, 13 Oct 2026 11:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892609;
	bh=hrx9pz+cRB02OAEbO6vnQTwt+V/VUrhWwmOLXec07hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efRgSPaC5nymJzFb8oRn0uY2W6lYS8UT4ydGe1JgAdjeWRJTt20e8UQjqfVl6PR9N
	 uJSjnJE7j45DPI7fXMJqHQmcezDuvD5eUlAc/N0DPBgjSXGSHhj+wkLhM9FOOt1ZtH
	 a9LFJAv0Fe27fi9hk8hqDOB+Xh+Dln6vpqAkA6Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 231/281] wifi: mt76: add PS buffering support for HW-managed TIM drivers
Date: Tue, 13 Oct 2026 13:39:07 +0200
Message-ID: <20261013112900.758511369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit a547b414bf7ea9877456b5630573293cc0e2cae7 ]

Add MT_DRV_HW_PS_BUFFERING flag for drivers where firmware controls
the TIM bit based on buffered frames. Instead of blocking all TX to
PS stations (which starves firmware and prevents TIM from being set),
allow limited frame delivery using AQL pending airtime as the
throttle. Replenish the firmware buffer on TX completion.

Add mt76_sta_ps_transition() helper for drivers to call from MCU
PS sync events.

Link: https://patch.msgid.link/20260801145334.1166751-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 752770d7a58c ("wifi: mt76: account non-AQL frames per peer rather than per link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  3 +
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 drivers/net/wireless/mediatek/mt76/tx.c       | 77 +++++++++++++++++--
 3 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 476578e2fbf0c..61ef1b80feb85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -539,6 +539,7 @@ struct mt76_hw_cap {
 #define MT_DRV_HW_MGMT_TXQ		BIT(4)
 #define MT_DRV_AMSDU_OFFLOAD		BIT(5)
 #define MT_DRV_IGNORE_TXS_FAILED	BIT(6)
+#define MT_DRV_HW_PS_BUFFERING		BIT(7)
 
 struct mt76_driver_ops {
 	u32 drv_flags;
@@ -1541,6 +1542,8 @@ void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 				  u16 tids, int nframes,
 				  enum ieee80211_frame_release_type reason,
 				  bool more_data);
+void mt76_sta_ps_transition(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			    bool ps);
 bool mt76_has_tx_pending(struct mt76_phy *phy);
 int mt76_update_channel(struct mt76_phy *phy);
 void mt76_update_survey(struct mt76_phy *phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index a9a4a87ae0a76..fe03bc70e63a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1068,6 +1068,7 @@ enum {
 	MCU_UNI_EVENT_IE_COUNTDOWN = 0x09,
 	MCU_UNI_EVENT_COREDUMP = 0x0a,
 	MCU_UNI_EVENT_BSS_BEACON_LOSS = 0x0c,
+	MCU_UNI_EVENT_PS_SYNC = 0x0d,
 	MCU_UNI_EVENT_SCAN_DONE = 0x0e,
 	MCU_UNI_EVENT_RDD_REPORT = 0x11,
 	MCU_UNI_EVENT_ROC = 0x27,
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b03be0eb47128..12c615b1294b4 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -267,6 +267,21 @@ void __mt76_tx_complete_skb(struct mt76_dev *dev, u16 wcid_idx, struct sk_buff *
 	wcid = __mt76_wcid_ptr(dev, wcid_idx);
 	mt76_tx_check_non_aql(dev, wcid, skb);
 
+	if (wcid && (dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING) &&
+	    test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+		struct ieee80211_sta *sta = wcid_to_sta(wcid);
+
+		if (sta) {
+			struct ieee80211_hw *hw = mt76_phy_hw(dev, wcid->phy_idx);
+			int i;
+
+			for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+				if (sta->txq[i])
+					ieee80211_schedule_txq(hw, sta->txq[i]);
+			mt76_worker_schedule(&dev->tx_worker);
+		}
+	}
+
 #ifdef CONFIG_NL80211_TESTMODE
 	if (mt76_is_testmode_skb(dev, skb, &hw)) {
 		struct mt76_phy *phy = hw->priv;
@@ -476,8 +491,12 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 	bool stop = false;
 	int idx;
 
-	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags))
-		return 0;
+	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+		if (!(dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING))
+			return 0;
+		if (ieee80211_txq_aql_pending(phy->hw, txq))
+			return 0;
+	}
 
 	if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
 		return 0;
@@ -497,6 +516,9 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 	if (idx < 0)
 		return idx;
 
+	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags))
+		goto out;
+
 	do {
 		if (test_bit(MT76_RESET, &phy->state) || phy->offchannel)
 			break;
@@ -522,6 +544,7 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 		n_frames++;
 	} while (1);
 
+out:
 	spin_lock(&q->lock);
 	dev->queue_ops->kick(dev, q);
 	spin_unlock(&q->lock);
@@ -548,10 +571,7 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 
 		mtxq = (struct mt76_txq *)txq->drv_priv;
 		wcid = __mt76_wcid_ptr(dev, mtxq->wcid);
-		if (!wcid || test_bit(MT_WCID_FLAG_PS, &wcid->flags))
-			continue;
-
-		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+		if (!wcid)
 			continue;
 
 		phy = mt76_dev_phy(dev, wcid->phy_idx);
@@ -559,6 +579,24 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 			continue;
 
 		q = phy->q_tx[qid];
+
+		if (test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+			if (!(dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING))
+				continue;
+
+			if (!mt76_txq_stopped(q))
+				n_frames = mt76_txq_send_burst(phy, q, mtxq, wcid);
+
+			ieee80211_return_txq(phy->hw, txq, false);
+
+			if (unlikely(n_frames < 0))
+				return n_frames;
+			ret += n_frames;
+			continue;
+		}
+
+		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+			continue;
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
 			dev->queue_ops->tx_cleanup(dev, q, false);
@@ -765,6 +803,33 @@ void mt76_stop_tx_queues(struct mt76_phy *phy, struct ieee80211_sta *sta,
 }
 EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 
+void mt76_sta_ps_transition(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			    bool ps)
+{
+	struct ieee80211_sta *sta;
+	struct ieee80211_hw *hw;
+	int i;
+
+	if (ps) {
+		set_bit(MT_WCID_FLAG_PS, &wcid->flags);
+		mt76_worker_schedule(&dev->tx_worker);
+		return;
+	}
+
+	clear_bit(MT_WCID_FLAG_PS, &wcid->flags);
+
+	sta = wcid_to_sta(wcid);
+	if (!sta)
+		return;
+
+	hw = mt76_phy_hw(dev, wcid->phy_idx);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		if (sta->txq[i])
+			ieee80211_schedule_txq(hw, sta->txq[i]);
+	mt76_worker_schedule(&dev->tx_worker);
+}
+EXPORT_SYMBOL_GPL(mt76_sta_ps_transition);
+
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
 	struct mt76_phy *phy = hw->priv;
-- 
2.53.0



