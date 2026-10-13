Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBA84F68C1;
	Tue, 13 Oct 2026 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894450; cv=none; b=BZi3jORvNK3UTgqCUWkKkdWxwAHYT05AQthp8mNwu8EYMyXSxlKygPDFZT4mNv/XgdKfyCTQPk4GrKBzHaJLEMa5FDkEKXuZLekWvqodJX8+R6qOZKG5SdNqfnfNleh+5+pV7mlorVjgdSpahIn+vRGa++yA0cG/2J3M0Put6uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894450; c=relaxed/simple;
	bh=HDOyEjvGuwprw65XqFY/hY7Ob3RywMYfQLomWYjilOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf0VyZ+c/zo62gJrWw4VQWBFbafMzJWfGI5oAVNI1TzzkQltVoap4tEvOAToTZWCVkCrwlfcwN3MMsXC6xnEhbqH+uVixbcZwenv4vxFMagdePVDPKpWDiVXgZQzsI3eaLuGiCUqEU2T3oHyr4qwBRyQ047wbwEF2Mf890AG9nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZYZ1SQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZYZ1SQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181851F000FF;
	Tue, 13 Oct 2026 12:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894448;
	bh=+xJlRS0dtg3/XZp03Pc3qzA4TKnY3P0Qdtr6gbP3FQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZYZ1SQjyyqtbumust/Wnbu17S/Jn05d3SYlHQRbwrgVDNfuod9syILCFLMlt+rm/
	 CDvo268M0R6CJYz6Z1X6xWd3mKJH3RYF9mnay8b7QhH70GFflwP8nibDWyHKx29l02
	 i9Vn84kjVUeKobvT4NfCjhZNy9behEaQYumPu8Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/621] wifi: mt76: add PS buffering support for HW-managed TIM drivers
Date: Tue, 13 Oct 2026 13:39:18 +0200
Message-ID: <20261013112934.168546201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2a186b47659b6..93d35aa2158a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -533,6 +533,7 @@ struct mt76_hw_cap {
 #define MT_DRV_HW_MGMT_TXQ		BIT(4)
 #define MT_DRV_AMSDU_OFFLOAD		BIT(5)
 #define MT_DRV_IGNORE_TXS_FAILED	BIT(6)
+#define MT_DRV_HW_PS_BUFFERING		BIT(7)
 
 struct mt76_driver_ops {
 	u32 drv_flags;
@@ -1518,6 +1519,8 @@ void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 				  u16 tids, int nframes,
 				  enum ieee80211_frame_release_type reason,
 				  bool more_data);
+void mt76_sta_ps_transition(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			    bool ps);
 bool mt76_has_tx_pending(struct mt76_phy *phy);
 int mt76_update_channel(struct mt76_phy *phy);
 void mt76_update_survey(struct mt76_phy *phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 0b02f34c40a40..5ed2fffbe1074 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1057,6 +1057,7 @@ enum {
 	MCU_UNI_EVENT_IE_COUNTDOWN = 0x09,
 	MCU_UNI_EVENT_COREDUMP = 0x0a,
 	MCU_UNI_EVENT_BSS_BEACON_LOSS = 0x0c,
+	MCU_UNI_EVENT_PS_SYNC = 0x0d,
 	MCU_UNI_EVENT_SCAN_DONE = 0x0e,
 	MCU_UNI_EVENT_RDD_REPORT = 0x11,
 	MCU_UNI_EVENT_ROC = 0x27,
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 5278289a17580..7745ddd255192 100644
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



