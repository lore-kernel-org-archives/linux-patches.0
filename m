Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8A62C21F7;
	Sat, 12 Sep 2026 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200856; cv=none; b=idQEo+8II031NqYqdHA5LOPzhg/faOssOtYC9KNZeCsqoJjdyoDFoOgBmLS3d57DaA4Bt3AI70xzEMgk5O/08vrfNKFxOF5gEdS8sBYXBplwGAa6yieeSDnIqlgfS4Jh0pPYMxc9r9LMSUhoopwPDd0QLV3cUlAO51asBuf+9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200856; c=relaxed/simple;
	bh=OaamtRxP11PsD3szlTj26wyQyg9h10T8CNpou5eBrCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQNUNpnloWqJcEMaJAYOFP1MyMkAFcG8gzEt4hM7UClYgalSGlddknZuIasOBEsQLfnGO56FNek6vxqSw2E6eZH3+wNCXyu45HWgYz0MiHgOE7WcA59sAZFkpbEw2FPbaunnQ7D0a/pO3fo2AJ1M6Ja8vvs3aKY/ZsJQfibbrv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwQ3yJ/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwQ3yJ/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDE31F000FF;
	Sat, 12 Sep 2026 08:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200855;
	bh=NWuZmhW9qC646QgIh6QZiN/rPclE2EODKyCdYPHIjsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwQ3yJ/HIiWK5XaKt6U+vmXOTSReoi1aqlASwOJ/z32UEUnydXsQ9VebzOvG1QS0O
	 WOj2CyLV9qV2nJ02ApNxZ8SVF4omOhUcYBB5T4HeYAAcM8Ht30099BZN6Ppe27uU3E
	 vVCY4hDfk7hc1NvWt/aUH2Eh5ceOzMLyefEJ73VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0877/1815] wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP
Date: Sat, 12 Sep 2026 08:43:47 +0200
Message-ID: <20260912065709.510662402@linuxfoundation.org>
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit ce35ecffc96e6d097d27b6fe30677a2cfe2e0461 ]

Problem:
MCU command timeout while the firmware state is normal, and the
firmware keeps showing the error log "ERROR!! NO PAUSE...".

Root cause:
If the MLD_ID field in the TXD is neither the primary link id nor the
secondary link id, it may lead to a firmware busy loop when the third
link is in power saving mode.

Remap frames directed to a third link to the primary link wcid. Since
TX status events and txfree completions carry the wcid the firmware
saw, use the remapped wcid for packet id tracking and non-AQL packet
accounting as well, while the frame keeps its original link context
for addressing, band and OMAC selection.

Fixes: 85cd5534a3f2 ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 29 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  2 +-
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 49d778d76e675..b7e46ecefd995 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -854,6 +854,33 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 		txwi[6] |= cpu_to_le32(MT_TXD6_DIS_MAT);
 }
 
+/* The WLAN_IDX in the TXD and TXP must belong to the primary or secondary
+ * link of an MLD station; any other link id can make the firmware spin when
+ * that link is in powersave. Completion events carry the same index, so the
+ * wcid used for status tracking and accounting must match it
+ */
+struct mt76_wcid *mt7996_get_tx_wcid(struct mt76_wcid *wcid)
+{
+	struct mt7996_sta_link *msta_link;
+	struct mt7996_sta *msta;
+
+	if (!wcid->sta)
+		return wcid;
+
+	msta_link = container_of(wcid, struct mt7996_sta_link, wcid);
+	msta = msta_link->sta;
+
+	if (!msta || wcid->link_id == msta->seclink_id ||
+	    wcid->link_id == msta->deflink_id)
+		return wcid;
+
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (msta_link)
+		return &msta_link->wcid;
+
+	return wcid;
+}
+
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
@@ -1091,6 +1118,8 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 					   tx_info->buf[1].len, DMA_TO_DEVICE);
 	}
 
+	wcid = mt7996_get_tx_wcid(wcid);
+
 	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
 	memset(txwi_ptr, 0, MT_TXD_SIZE);
 	/* Transmit non qos data by 802.11 header and need to fill txd by host*/
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 574aeac286ccb..f291560ae93cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1579,7 +1579,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 		if (msta_link)
 			wcid = &msta_link->wcid;
 	}
-	mt76_tx(mphy, control->sta, wcid, skb);
+	mt76_tx(mphy, control->sta, mt7996_get_tx_wcid(wcid), skb);
 unlock:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 0d6488522ba71..2e3edac2b5719 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -871,6 +871,7 @@ bool mt7996_mac_wtbl_update(struct mt7996_dev *dev, int idx, u32 mask);
 void mt7996_mac_reset_counters(struct mt7996_phy *phy);
 void mt7996_mac_cca_stats_reset(struct mt7996_phy *phy);
 void mt7996_mac_enable_nf(struct mt7996_dev *dev, u8 band);
+struct mt76_wcid *mt7996_get_tx_wcid(struct mt76_wcid *wcid);
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
-- 
2.53.0



