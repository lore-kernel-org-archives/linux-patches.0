Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66031AB8FD;
	Thu,  6 Jun 2024 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683273; cv=none; b=iwRT8lbiygS5Ljlge73M9pOolfcs43oqCD5UgXjUhjOMBxyLsl6jivDFGJY98Sa8XeoByOCEC8cE/ALnvd1tExZDBGiMVEfE3yqfi2eqlDWNhRGfqbiujPkqlVWGmB8IvCe+PFzcSoX0brKzK4VO4jaJBXEy2c6hOHfNbsbqjxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683273; c=relaxed/simple;
	bh=+0oen7y3NSV9U0uvNKCzBdVHfvZmg0vhPLKb3oYuVNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgDMPC38e9ACUN6GKg8ImSQ1DpGUEay+POsHo+RlkeBG13YNjuV6a9wDfE7frd2gMxoUVs77n4dL6OWr9YMSvhooo1YwN7YeyWFFxiV6LvJ0hTuc5srGK2+vR08tuDYLTeORarhGurzSlrWa85vEE7ssEgQRwNNx3x648eiucJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOM5Qf66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOM5Qf66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4003C2BD10;
	Thu,  6 Jun 2024 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683273;
	bh=+0oen7y3NSV9U0uvNKCzBdVHfvZmg0vhPLKb3oYuVNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOM5Qf66Roldh5ZoJ5rr0foGP79Q0+vlqPyeEKg6u5ENJuWMpQfXt856YTg+Kg0T1
	 SyYjCB//pBbXJIKzirQrsfn5HOi36UGy2QpkOAWBO878lSsMM7YDMRfjdvZiBWLRE7
	 chFOysLqBk3hEI5pNPrcp+Ls4OGXU4dFcTUXlLNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/744] wifi: mt76: mt7603: fix tx queue of loopback packets
Date: Thu,  6 Jun 2024 15:58:08 +0200
Message-ID: <20240606131739.320064172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b473c0e47f04d3b4ee9d05d2e79234134aad14d5 ]

Use the correct WMM AC queue instead of the MGMT one to fix potential issues
with aggregation sequence number tracking. Drop non-bufferable packets.

Fixes: fca9615f1a43 ("mt76: mt7603: fix up hardware queue index for PS filtered packets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 46 +++++++++++++------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 03ba11a61c90c..b3a61b0ddd03d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -4,6 +4,13 @@
 #include "mac.h"
 #include "../dma.h"
 
+static const u8 wmm_queue_map[] = {
+	[IEEE80211_AC_BK] = 0,
+	[IEEE80211_AC_BE] = 1,
+	[IEEE80211_AC_VI] = 2,
+	[IEEE80211_AC_VO] = 3,
+};
+
 static void
 mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 {
@@ -22,10 +29,10 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	struct ieee80211_sta *sta;
 	struct mt7603_sta *msta;
 	struct mt76_wcid *wcid;
+	u8 tid = 0, hwq = 0;
 	void *priv;
 	int idx;
 	u32 val;
-	u8 tid = 0;
 
 	if (skb->len < MT_TXD_SIZE + sizeof(struct ieee80211_hdr))
 		goto free;
@@ -42,19 +49,36 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 		goto free;
 
 	priv = msta = container_of(wcid, struct mt7603_sta, wcid);
-	val = le32_to_cpu(txd[0]);
-	val &= ~(MT_TXD0_P_IDX | MT_TXD0_Q_IDX);
-	val |= FIELD_PREP(MT_TXD0_Q_IDX, MT_TX_HW_QUEUE_MGMT);
-	txd[0] = cpu_to_le32(val);
 
 	sta = container_of(priv, struct ieee80211_sta, drv_priv);
 	hdr = (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
-	if (ieee80211_is_data_qos(hdr->frame_control))
+
+	hwq = wmm_queue_map[IEEE80211_AC_BE];
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		tid = *ieee80211_get_qos_ctl(hdr) &
-		      IEEE80211_QOS_CTL_TAG1D_MASK;
-	skb_set_queue_mapping(skb, tid_to_ac[tid]);
+			 IEEE80211_QOS_CTL_TAG1D_MASK;
+		u8 qid = tid_to_ac[tid];
+		hwq = wmm_queue_map[qid];
+		skb_set_queue_mapping(skb, qid);
+	} else if (ieee80211_is_data(hdr->frame_control)) {
+		skb_set_queue_mapping(skb, IEEE80211_AC_BE);
+		hwq = wmm_queue_map[IEEE80211_AC_BE];
+	} else {
+		skb_pull(skb, MT_TXD_SIZE);
+		if (!ieee80211_is_bufferable_mmpdu(skb))
+			goto free;
+		skb_push(skb, MT_TXD_SIZE);
+		skb_set_queue_mapping(skb, MT_TXQ_PSD);
+		hwq = MT_TX_HW_QUEUE_MGMT;
+	}
+
 	ieee80211_sta_set_buffered(sta, tid, true);
 
+	val = le32_to_cpu(txd[0]);
+	val &= ~(MT_TXD0_P_IDX | MT_TXD0_Q_IDX);
+	val |= FIELD_PREP(MT_TXD0_Q_IDX, hwq);
+	txd[0] = cpu_to_le32(val);
+
 	spin_lock_bh(&dev->ps_lock);
 	__skb_queue_tail(&msta->psq, skb);
 	if (skb_queue_len(&msta->psq) >= 64) {
@@ -151,12 +175,6 @@ static int mt7603_poll_tx(struct napi_struct *napi, int budget)
 
 int mt7603_dma_init(struct mt7603_dev *dev)
 {
-	static const u8 wmm_queue_map[] = {
-		[IEEE80211_AC_BK] = 0,
-		[IEEE80211_AC_BE] = 1,
-		[IEEE80211_AC_VI] = 2,
-		[IEEE80211_AC_VO] = 3,
-	};
 	int ret;
 	int i;
 
-- 
2.43.0



