Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019258;
	b=QGVlb3uCJpO5ovL77Vu2MKcZui5OYI2eC6UrywxdGX7wWCffovXCeKoDEhARjS8wSSC9
	 lYLRTJQct+wefdrCd5s4YkLwW5lPKYMlP5eB+gwFF8k+q8xg3/xuXKjyrQ9b2JHJspAUn
	 eAeKQeKTFGomhvaBpJSYZ4fuhXJjDx+SrVWBZECLwl3KElovz+RzUuW2KlzdNGkOgJrwO
	 HLdx4tWCpOBRR0J2Mf7e2eRcO2i7g9Hz3BdPkFlWf0BqyybwGhVNKsZrV6hsgtht01Qe7
	 Jbzj9RkX0fbyZxEEojuE1IUCUhY35L+yc1baDoELjbUp7YofUlTBgNX989E8DJtUgoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F7br9HIDvYdm6iRg+dz405MqmmsZ5JHFn2JvgCWTLxQ=;
	b=1wUBtLKA2A2GSRxLttAnp8OipnHL1yoST0AVFQm3RIwx5/80TxOggaS6Q9LmOKhJEZ/h
	 yKd+IR48VuUl1gMJmu7TXTGqfMV3hTzMxNZdOHcFovbgmlfCl+gvhPq8/sZ86vgEvNTib
	 VPU6rHwOR8td5Yavb9b+NWzqsqLvZSdTQPEZCWId+/nCdAAnvFDEcxKfd0PyegBDmZ5TM
	 IsV9RsCxN2UUqihGZ2bIs67ayemo40+blbOgVLm+wqX4EABpuYVF0GZRruVLQz/o9+ea+
	 hfx7re+jOdiOUxOp4SshEysGWbt6ieQWGpzyTqx1Cy67J35ndATNVkEqSwTRY+laX7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gsdc5ZHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A9660A2615;
	Wed, 18 Nov 2026 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gsdc5ZHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207401F000C4;
	Wed, 18 Nov 2026 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019257;
	bh=F7br9HIDvYdm6iRg+dz405MqmmsZ5JHFn2JvgCWTLxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gsdc5ZHWkEos6QOJyZskDOUufap4RLpWoZ7X8d9pxy1bCLL9bLjgjPoqLopIeeJo1
	 exDeHsY+StKrC5d4NaqBngkApxYcuXBiVzmSErLaL9KCEeurroKradGm3MkBgwP6RD
	 Voc1siC2zrYwx8NKpd+pW2S+58wZBV/YSJeOjvyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1481/2651] wifi: mt76: mt7996: keep 4-address and decap state per station
Date: Wed, 18 Nov 2026 15:45:21 +0100
Message-ID: <20261118150341.342079811@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 72f050d4b04e40f450573ffb95cb4717c8bbfefb ]

mac80211 reports 4-address mode and decap offload once per station,
through sta_set_4addr and sta_set_decap_offload. mt7996_sta_set_4addr()
and mt7996_sta_set_decap_offload() set MT_WCID_FLAG_4ADDR and
MT_WCID_FLAG_HDR_TRANS only on the links that exist at that moment, but
the hardware keeps header translation per link. A link that is added
later starts without the flags, and a link that is removed at that time
keeps its old flags when it comes back, so the firmware gets the wrong
to_ds/from_ds pair for that link.

Keep both states in the station, and apply them to a link when the
callbacks run, when the link is set up and when it comes back.

Fixes: f520eceacd24 ("wifi: mt76: mt7996: Add mt7996_mac_sta_change_links callback")
Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Link: https://patch.msgid.link/20261006205936.669125-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 29 +++++++++++--------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  2 ++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 3e55f7b19895a..ab31fafd5c8d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1162,6 +1162,16 @@ mt7996_sta_deflink_set(struct ieee80211_sta *sta, unsigned int link_id,
 	mt7996_sta_init_txq_wcid(sta, idx);
 }
 
+static void
+mt7996_sta_link_hdr_trans_set(struct mt7996_sta *msta,
+			      struct mt7996_sta_link *msta_link)
+{
+	assign_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags,
+		   test_bit(MT_WCID_FLAG_4ADDR, &msta->wcid_flags));
+	assign_bit(MT_WCID_FLAG_HDR_TRANS, &msta_link->wcid.flags,
+		   test_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid_flags));
+}
+
 static bool
 mt7996_sta_deflink_busy(struct mt7996_dev *dev, struct mt7996_sta *msta)
 {
@@ -1268,6 +1278,8 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	if (link_sta->sta->tdls)
 		set_bit(MT_WCID_FLAG_TDLS_PEER, &msta_link->wcid.flags);
 
+	mt7996_sta_link_hdr_trans_set(msta, msta_link);
+
 	ewma_avg_signal_init(&msta_link->avg_ack_signal);
 	ewma_signal_init(&msta_link->wcid.rssi);
 
@@ -1388,6 +1400,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (msta_link) {
 			msta_link->wcid.link_valid = true;
+			mt7996_sta_link_hdr_trans_set(msta, msta_link);
 			if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
 				mt7996_sta_deflink_set(sta, link_id,
 						       msta_link->wcid.idx);
@@ -2174,6 +2187,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	assign_bit(MT_WCID_FLAG_4ADDR, &msta->wcid_flags, enabled);
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
@@ -2186,11 +2200,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 		if (!msta_link)
 			continue;
 
-		if (enabled)
-			set_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags);
-		else
-			clear_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags);
-
+		mt7996_sta_link_hdr_trans_set(msta, msta_link);
 		if (!msta_link->wcid.sta)
 			continue;
 
@@ -2220,6 +2230,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	assign_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid_flags, enabled);
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
@@ -2232,13 +2243,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 		if (!msta_link)
 			continue;
 
-		if (enabled)
-			set_bit(MT_WCID_FLAG_HDR_TRANS,
-				&msta_link->wcid.flags);
-		else
-			clear_bit(MT_WCID_FLAG_HDR_TRANS,
-				  &msta_link->wcid.flags);
-
+		mt7996_sta_link_hdr_trans_set(msta, msta_link);
 		if (!msta_link->wcid.sta)
 			continue;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 03fc0e7fd4f1c..949e659b8e2d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -269,6 +269,8 @@ struct mt7996_sta {
 	u8 deflink_id;
 	u8 seclink_id;
 
+	unsigned long wcid_flags;
+
 	struct mt7996_vif *vif;
 };
 
-- 
2.53.0



