Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019040;
	b=y2MpGCUTiRgUaz+8uQbF23XiMYw1ePogGuiFCyIZEkGLFkjpcKjBWAu6n43zR4xW7Lol
	 mfwwkTZ81A5BoJyXfH+9tn7AbQDM3M8WTiwFSQ00ziEaezTUvZ1+IHGAqYlv2KMVp6/hb
	 QT1IWIKiyxUhlLqPRxUoo/vKkDUCMNeus3wiz09UyKuqxB7LOIfkIFLRcPvoLE+yycO4m
	 VTcjKxeKMAreKrWK1Ol4pHg5Knu1AIMrEhpgN+t3Ye0lGbKhKP1S7dv0vmOY/GZOV5NtS
	 1ES2OAtJGNazFbDRKyncwgj/uz4XJVoGUNCcaVZ9jgKCjRm85ghFreKUK8A+DmHzlGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XKd40MKkjQ5zWQ4US9/W2KA25jjev9NIr2W7FQgxvDI=;
	b=U4eeQFjALFY0EexhfI70phgzDOhYcmm3766rU43CILB38rz/evL6us7Fxw4pdsAWBbES
	 muq63NOzPYoTvRjLYhLD1r+zW6mfY1XL9n3Ewp583A7x1z2YMZEQuvy3XD5+lylwspThh
	 0KEEgPWmMqv8s21GCJ+gOnkoyqCqE+u4tVeGQ3Mp+oUl+W+aL9Dfcm6EY19DDDYlckn9a
	 xghuZTNtrNNRf711g9588sa707Pr7aWknLo/co1amRnxzhzPhTvmexRhOwnuk/e6Ccaow
	 CMzGwCfairMjTlPejJRBYQ5ui40KHrF3FvB415nUnIiG2fDpUZPOFY44jGanIwv9PLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQYAPQRy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C15606A31C;
	Wed, 18 Nov 2026 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQYAPQRy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61CE1F000C4;
	Wed, 18 Nov 2026 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019040;
	bh=XKd40MKkjQ5zWQ4US9/W2KA25jjev9NIr2W7FQgxvDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQYAPQRyalKH4kCwBd2yD7dH7Y3EW6xujYxorJN4+NGlMB1ILXb6gPZ9KUzscChib
	 5YC8ttE31sPSDj7glCq8g8DOdRltmhG5js1LASa6Nq0J6l+6tRjH+0VKIqPknQmEK0
	 DhDc1M0asVcIv9a2Z4b4y7LbUOhm4Re3MDYYInkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Papa <pcristian292@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1455/2651] wifi: mt76: mt7603: dont drop short frames looped back on PS entry
Date: Wed, 18 Nov 2026 15:44:55 +0100
Message-ID: <20261118150340.422024369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 477a9b7a8cf7d..491c8c937031a 100644
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



