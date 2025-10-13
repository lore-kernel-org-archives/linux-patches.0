Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094793101BA;
	Mon, 13 Oct 2025 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369750; cv=none; b=oohhjTj/JE5yN1HZm/XM0NubQis4Iy2YufvVVdcG/OJkjlm+xnJKhbUdXNSn27tcJ2eFcRO1Ectv3qukl3cz5MX/5bhB5cq0FGaJJK8xAOs+bd0g1hK3Pwssm8Uorh/dZ/onzYD9UCQ5Rom8ILn6zItMvhehnNRmJqWkyN7gLlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369750; c=relaxed/simple;
	bh=tMEa8L59a6xRsmo+aaZs3x9EVtpzsv1vzoAPqcFnF0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qffF1HmNU4LGTAGylAciUVlOUedbpqF8Iz5Iv2/X4LNjPPsy7+Iw1RcQ6+fQnOB26GlhpDNulfwyqYj2BTsWfwlnTeGfbG8e12me5aosLtRQZJ6PIzunLRzagbeQLdBQrsIfKdR7KbLtCu/4gsLg9Kw3ykB1p75vCFcbpV3ip0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSd5welr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSd5welr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1B6C4AF09;
	Mon, 13 Oct 2025 15:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369749;
	bh=tMEa8L59a6xRsmo+aaZs3x9EVtpzsv1vzoAPqcFnF0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSd5welr9pCDNALEsQ4QpQPcueP8f9pdyEXR5QHkJfQ+DIOP73I8tVeTQsjSEg2kA
	 r+9nC6GM9kWYQ4Rbo02dIoTjD8XLgpuaa4IQ9YVvWeF/h9C5GPJfjEdWZ2RWLggvTh
	 0A8teAwI6F0izAjzlD2WCWBOqdL2qAvhTHtvwNU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 356/563] wifi: mt76: mt7996: Use proper link_id in link_sta_rc_update callback
Date: Mon, 13 Oct 2025 16:43:37 +0200
Message-ID: <20251013144424.165509852@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit afff4325548f0cf872e404df2856bf8bd9581c7e ]

Do not always use deflink_id in link_sta_rc_update mac80211
callback but use the proper link_id provided by mac80211.

Fixes: 0762bdd30279f ("wifi: mt76: mt7996: rework mt7996_mac_sta_rc_work to support MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250901-mt7996-fix-link_sta_rc_update-callback-v1-1-e24caf196222@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 43 ++++++++++++-------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 3c34a4980afa0..81391db535866 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1663,19 +1663,13 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 	}
 }
 
-static void mt7996_link_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
+static void mt7996_link_rate_ctrl_update(void *data,
+					 struct mt7996_sta_link *msta_link)
 {
-	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_sta *msta = msta_link->sta;
 	struct mt7996_dev *dev = msta->vif->deflink.phy->dev;
-	struct mt7996_sta_link *msta_link;
 	u32 *changed = data;
 
-	rcu_read_lock();
-
-	msta_link = rcu_dereference(msta->link[msta->deflink_id]);
-	if (!msta_link)
-		goto out;
-
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
 
 	msta_link->changed |= *changed;
@@ -1683,8 +1677,6 @@ static void mt7996_link_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
 		list_add_tail(&msta_link->rc_list, &dev->sta_rc_list);
 
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
-out:
-	rcu_read_unlock();
 }
 
 static void mt7996_link_sta_rc_update(struct ieee80211_hw *hw,
@@ -1692,11 +1684,32 @@ static void mt7996_link_sta_rc_update(struct ieee80211_hw *hw,
 				      struct ieee80211_link_sta *link_sta,
 				      u32 changed)
 {
-	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct ieee80211_sta *sta = link_sta->sta;
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_sta_link *msta_link;
 
-	mt7996_link_rate_ctrl_update(&changed, sta);
-	ieee80211_queue_work(hw, &dev->rc_work);
+	rcu_read_lock();
+
+	msta_link = rcu_dereference(msta->link[link_sta->link_id]);
+	if (msta_link) {
+		struct mt7996_dev *dev = mt7996_hw_dev(hw);
+
+		mt7996_link_rate_ctrl_update(&changed, msta_link);
+		ieee80211_queue_work(hw, &dev->rc_work);
+	}
+
+	rcu_read_unlock();
+}
+
+static void mt7996_sta_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_sta_link *msta_link;
+	u32 *changed = data;
+
+	msta_link = rcu_dereference(msta->link[msta->deflink_id]);
+	if (msta_link)
+		mt7996_link_rate_ctrl_update(&changed, msta_link);
 }
 
 static int
@@ -1717,7 +1730,7 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 * - multiple rates: if it's not in range format i.e 0-{7,8,9} for VHT
 	 * then multiple MCS setting (MCS 4,5,6) is not supported.
 	 */
-	ieee80211_iterate_stations_atomic(hw, mt7996_link_rate_ctrl_update,
+	ieee80211_iterate_stations_atomic(hw, mt7996_sta_rate_ctrl_update,
 					  &changed);
 	ieee80211_queue_work(hw, &dev->rc_work);
 
-- 
2.51.0



