Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041056;
	b=qr+kIqzrwuWkIjK102s9PXM/I6MRD4VB03TLiYWVUPO7NQkdRKopCUK2kqtHDg2aiTpq
	 xrxlnUJRbt9nhPuaW9zAseH/Swes6kVfVilVPvcNqwMIJlffgEYl/fbLV21eOFAN1XepW
	 tEufpDm3NoaK5/4l6Dbk6ZqOK/C/arZRURdOA5GKbctF52eYAuLMziHnBxxxuyQ368LIj
	 3ZKA1gXWdyPknTHJaporCDGz4w4cyZmgxKrI1HYzSfbHELkYwvltXHXqtDyzBikE6XFPA
	 6yOkHSNYXXU1d2Zd4pDSnhVe3K4aNpldX54KdNhch6JMqwJeyzBklHnU4ZlgZ2ns1kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T54xOhVLeAFpwe2ArSqAwhLuQRcV2Bfxa/RX3Qo2O+Y=;
	b=crWPQKekwPYbFgkP3HrTVx3G/yoNT1GJOKIH4P/9YOgzKZ5a69Ey2wUUr9xdx7Nzunmu
	 JcZZbYJN5ZvqGUMfkmtUGs6oogVLA71rtlghXqal8TrGPbqkqzLSOsl2gP0xV/3axfMr+
	 RT/5NKitfpF7RWKqxuWDshlWkfxWWteCQpVOOkUkq1Yfd89jUPb3Cqhs2Q5zpqbkSJbcO
	 hLPP8xZGCdP38ErAHx1pgwBQTMy2KCbFUGoKOfZ6Ci2d/YIAdnjmirs1wjlA8ryEI5mVu
	 gZN8R421juUyMvJkVKsduUysXrp6mvvlJGMpKBwR67dOO26zFurs/WbZnlqCImTmdiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwNs84hc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88905606A31C;
	Wed, 18 Nov 2026 22:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwNs84hc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49EC1F000C5;
	Wed, 18 Nov 2026 22:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041056;
	bh=T54xOhVLeAFpwe2ArSqAwhLuQRcV2Bfxa/RX3Qo2O+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwNs84hcL1mRBZ+XsMHJq4tOtojZ2w3lQIgZVjbbl6K9uZSlCGa3XBZpHsdrNOhWv
	 hwLW3dctWzH/z9xSn1X0TNoOGqgtDsh/8ATcL/6wK+UFH6/LHRseSeMDGtxJPPSYL7
	 bz9ob7J/DeBlcAwrvao8AMvld/fmLkO2MGLceavk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Papa <pcristian292@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2670/3318] wifi: mt76: mt7603: dont drop short frames looped back on PS entry
Date: Wed, 18 Nov 2026 15:54:52 +0100
Message-ID: <20261118150441.108747890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Papa <pcristian292@gmail.com>

[ Upstream commit 9956c4cac9d3f479817d6fe6a057aef3e86defcf ]

When a station enters power save, mt7603 has the PSE redirect the frames
still queued for it back to the host, and mt7603_rx_loopback_skb() parks
them until the station wakes up.

The handler rejects every frame shorter than a four-address header
(sizeof(struct ieee80211_hdr), 30 bytes) before looking at it. A
BlockAck request is 20 bytes and a QoS-Null 26, so both are freed
without a trace. Since commit b473c0e47f04 ("wifi: mt76: mt7603: fix tx
queue of loopback packets"), a BAR would also be freed later as a frame
that is not a bufferable MMPDU, although mac80211 buffers BARs for a
sleeping station like any other unicast frame.

mac80211 queues the BAR with IEEE80211_TX_CTL_REQ_TX_STATUS, so it only
learns about the loss when the tx status times out, and the recipient
keeps waiting on its reorder window until then.

Check the length against the header length of the actual frame, and
park a BlockAck request on the queue of its TID, behind the data frames
it refers to.

Found on a TP-Link Archer XR500v (MT7603E) with a client whose Bluetooth
coexistence toggles PM every ~15 ms under load. To test the change on
its own, a temporary debugfs switch flipped between the old and the new
checks every 30 seconds during a bidirectional TCP test, with counters
on the loop-back path and on the tx status of BARs. With the old check,
all 92 BARs that came back were freed, and 91 of the 544 BARs queued in
those phases never got a tx status from the hardware. With this change,
all 129 BARs that came back were parked and sent again, and 11 of 411
got no tx status. Throughput was the same with both checks.

Fixes: e004b7006600 ("mt76: mt7603: notify mac80211 about buffered frames in ps queue")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
Link: https://patch.msgid.link/20260922220814.15070-1-pcristian292@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/dma.c    | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 19e78882aedd1..25a43f2e54648 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -34,7 +34,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	int idx;
 	u32 val;
 
-	if (skb->len < MT_TXD_SIZE + sizeof(struct ieee80211_hdr))
+	if (skb->len < MT_TXD_SIZE + 2)
 		goto free;
 
 	val = le32_to_cpu(txd[1]);
@@ -52,6 +52,9 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	sta = container_of(priv, struct ieee80211_sta, drv_priv);
 	hdr = (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
 
+	if (skb->len < MT_TXD_SIZE + ieee80211_hdrlen(hdr->frame_control))
+		goto free;
+
 	hwq = wmm_queue_map[IEEE80211_AC_BE];
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		tid = *ieee80211_get_qos_ctl(hdr) &
@@ -62,6 +65,19 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	} else if (ieee80211_is_data(hdr->frame_control)) {
 		skb_set_queue_mapping(skb, IEEE80211_AC_BE);
 		hwq = wmm_queue_map[IEEE80211_AC_BE];
+	} else if (ieee80211_is_back_req(hdr->frame_control)) {
+		struct ieee80211_bar *bar = (struct ieee80211_bar *)hdr;
+
+		if (skb->len < MT_TXD_SIZE + sizeof(*bar))
+			goto free;
+
+		tid = (le16_to_cpu(bar->control) &
+		       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
+		      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
+		tid &= IEEE80211_QOS_CTL_TAG1D_MASK;
+		qid = tid_to_ac[tid];
+		hwq = wmm_queue_map[qid];
+		skb_set_queue_mapping(skb, qid);
 	} else {
 		skb_pull(skb, MT_TXD_SIZE);
 		if (!ieee80211_is_bufferable_mmpdu(skb))
-- 
2.53.0



