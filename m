Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3B2E6D2B;
	Tue, 15 Jul 2025 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587034; cv=none; b=EK7qBtywE+Hjh6WVjSCq/gtDayS4vQFQs/EQXIvTOzu2dpRqFH3EfOhKAI4NquMpRWvvUQFwk8a+VDn08T2bcT8rRuFCes+y78i6L+Jos5CjY4DdfyVBNP2p6qcwgtdch7ewoGUqYLM42n6RoAUq4IvVXV4XWvAo/qLWW1XKRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587034; c=relaxed/simple;
	bh=4mRYAG9kAEuYWG/S1xE6/Z4LDwoM4ZVg4NmdRs6PClA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7F2Npt+WCOJ8AZUfe5gaJCzstgxdpb5UtNz65YtwAn3VXkRQwzZevNQ/oSSWubTG1ojSfItJbpcIwGeVcb3ZCBdupvOdnJVhmL92Hjy1lbCHf33dJA4a7jQFaZh0aRKhECVVSJIdYckEdHp/05VvbzZOI4ZSNytCywN4A0hhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdV+0cXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdV+0cXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0ECC4CEE3;
	Tue, 15 Jul 2025 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587034;
	bh=4mRYAG9kAEuYWG/S1xE6/Z4LDwoM4ZVg4NmdRs6PClA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdV+0cXu3DP9Zc/MHKWeeeZzKJhIufC+FXtq7oJh9Fwtt6DiG/6gEIaY2ZlszbUj7
	 J0bAmscV1K4wbYiQlgJLK1wnWJUcEXKAIX8m1J6PTMQXh9c77vXqif29NJshHo7qqq
	 pg1PjpCdLKYFKr75PK3V6hnray9lk64ofN3nxkwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 141/192] wifi: mt76: Move RCU section in mt7996_mcu_add_rate_ctrl_fixed()
Date: Tue, 15 Jul 2025 15:13:56 +0200
Message-ID: <20250715130820.560358826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 28d519d0d493a8cf3f8ca01f10d962c56cec1825 ]

Since mt7996_mcu_set_fixed_field() can't be executed in a RCU critical
section, move RCU section in mt7996_mcu_add_rate_ctrl_fixed() and run
mt7996_mcu_set_fixed_field() in non-atomic context. This is a
preliminary patch to fix a 'sleep while atomic' issue in
mt7996_mac_sta_rc_work().

Fixes: 0762bdd30279 ("wifi: mt76: mt7996: rework mt7996_mac_sta_rc_work to support MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250605-mt7996-sleep-while-atomic-v1-3-d46d15f9203c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 86 ++++++++++++-------
 1 file changed, 57 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index d67ed58d7126d..6c2b258ce4ff6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1955,51 +1955,74 @@ int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev, struct mt7996_sta *msta,
 }
 
 static int
-mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
-			       struct ieee80211_link_sta *link_sta,
-			       struct mt7996_vif_link *link,
-			       struct mt7996_sta_link *msta_link,
-			       u8 link_id)
+mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			       struct ieee80211_vif *vif, u8 link_id)
 {
-	struct cfg80211_chan_def *chandef = &link->phy->mt76->chandef;
-	struct cfg80211_bitrate_mask *mask = &link->bitrate_mask;
-	enum nl80211_band band = chandef->chan->band;
-	struct mt7996_sta *msta = msta_link->sta;
+	struct ieee80211_link_sta *link_sta;
+	struct cfg80211_bitrate_mask mask;
+	struct mt7996_sta_link *msta_link;
+	struct mt7996_vif_link *link;
 	struct sta_phy_uni phy = {};
-	int ret, nrates = 0;
+	struct ieee80211_sta *sta;
+	int ret, nrates = 0, idx;
+	enum nl80211_band band;
+	bool has_he;
 
 #define __sta_phy_bitrate_mask_check(_mcs, _gi, _ht, _he)			\
 	do {									\
-		u8 i, gi = mask->control[band]._gi;				\
+		u8 i, gi = mask.control[band]._gi;				\
 		gi = (_he) ? gi : gi == NL80211_TXRATE_FORCE_SGI;		\
 		phy.sgi = gi;							\
-		phy.he_ltf = mask->control[band].he_ltf;			\
-		for (i = 0; i < ARRAY_SIZE(mask->control[band]._mcs); i++) {	\
-			if (!mask->control[band]._mcs[i])			\
+		phy.he_ltf = mask.control[band].he_ltf;				\
+		for (i = 0; i < ARRAY_SIZE(mask.control[band]._mcs); i++) {	\
+			if (!mask.control[band]._mcs[i])			\
 				continue;					\
-			nrates += hweight16(mask->control[band]._mcs[i]);	\
-			phy.mcs = ffs(mask->control[band]._mcs[i]) - 1;		\
+			nrates += hweight16(mask.control[band]._mcs[i]);	\
+			phy.mcs = ffs(mask.control[band]._mcs[i]) - 1;		\
 			if (_ht)						\
 				phy.mcs += 8 * i;				\
 		}								\
 	} while (0)
 
-	if (link_sta->he_cap.has_he) {
+	rcu_read_lock();
+
+	link = mt7996_vif_link(dev, vif, link_id);
+	if (!link)
+		goto error_unlock;
+
+	msta_link = rcu_dereference(msta->link[link_id]);
+	if (!msta_link)
+		goto error_unlock;
+
+	sta = wcid_to_sta(&msta_link->wcid);
+	link_sta = rcu_dereference(sta->link[link_id]);
+	if (!link_sta)
+		goto error_unlock;
+
+	band = link->phy->mt76->chandef.chan->band;
+	has_he = link_sta->he_cap.has_he;
+	mask = link->bitrate_mask;
+	idx = msta_link->wcid.idx;
+
+	if (has_he) {
 		__sta_phy_bitrate_mask_check(he_mcs, he_gi, 0, 1);
 	} else if (link_sta->vht_cap.vht_supported) {
 		__sta_phy_bitrate_mask_check(vht_mcs, gi, 0, 0);
 	} else if (link_sta->ht_cap.ht_supported) {
 		__sta_phy_bitrate_mask_check(ht_mcs, gi, 1, 0);
 	} else {
-		nrates = hweight32(mask->control[band].legacy);
-		phy.mcs = ffs(mask->control[band].legacy) - 1;
+		nrates = hweight32(mask.control[band].legacy);
+		phy.mcs = ffs(mask.control[band].legacy) - 1;
 	}
+
+	rcu_read_unlock();
+
 #undef __sta_phy_bitrate_mask_check
 
 	/* fall back to auto rate control */
-	if (mask->control[band].gi == NL80211_TXRATE_DEFAULT_GI &&
-	    mask->control[band].he_gi == GENMASK(7, 0) &&
-	    mask->control[band].he_ltf == GENMASK(7, 0) &&
+	if (mask.control[band].gi == NL80211_TXRATE_DEFAULT_GI &&
+	    mask.control[band].he_gi == GENMASK(7, 0) &&
+	    mask.control[band].he_ltf == GENMASK(7, 0) &&
 	    nrates != 1)
 		return 0;
 
@@ -2012,16 +2035,16 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 	}
 
 	/* fixed GI */
-	if (mask->control[band].gi != NL80211_TXRATE_DEFAULT_GI ||
-	    mask->control[band].he_gi != GENMASK(7, 0)) {
+	if (mask.control[band].gi != NL80211_TXRATE_DEFAULT_GI ||
+	    mask.control[band].he_gi != GENMASK(7, 0)) {
 		u32 addr;
 
 		/* firmware updates only TXCMD but doesn't take WTBL into
 		 * account, so driver should update here to reflect the
 		 * actual txrate hardware sends out.
 		 */
-		addr = mt7996_mac_wtbl_lmac_addr(dev, msta_link->wcid.idx, 7);
-		if (link_sta->he_cap.has_he)
+		addr = mt7996_mac_wtbl_lmac_addr(dev, idx, 7);
+		if (has_he)
 			mt76_rmw_field(dev, addr, GENMASK(31, 24), phy.sgi);
 		else
 			mt76_rmw_field(dev, addr, GENMASK(15, 12), phy.sgi);
@@ -2033,7 +2056,7 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 	}
 
 	/* fixed HE_LTF */
-	if (mask->control[band].he_ltf != GENMASK(7, 0)) {
+	if (mask.control[band].he_ltf != GENMASK(7, 0)) {
 		ret = mt7996_mcu_set_fixed_field(dev, msta, &phy, link_id,
 						 RATE_PARAM_FIXED_HE_LTF);
 		if (ret)
@@ -2041,6 +2064,11 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt7996_dev *dev,
 	}
 
 	return 0;
+
+error_unlock:
+	rcu_read_unlock();
+
+	return -ENODEV;
 }
 
 static void
@@ -2159,6 +2187,7 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
 			     struct mt7996_sta_link *msta_link,
 			     u8 link_id, bool changed)
 {
+	struct mt7996_sta *msta = msta_link->sta;
 	struct sk_buff *skb;
 	int ret;
 
@@ -2185,8 +2214,7 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev,
 	if (ret)
 		return ret;
 
-	return mt7996_mcu_add_rate_ctrl_fixed(dev, link_sta, link, msta_link,
-					      link_id);
+	return mt7996_mcu_add_rate_ctrl_fixed(dev, msta, vif, link_id);
 }
 
 static int
-- 
2.39.5



