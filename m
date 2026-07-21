Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA094C8FFA;
	Tue, 21 Jul 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649478; cv=none; b=a3Y9bPnjQchhMO7SGazZgYN35uMT5yIEm8BHnxT/58UqHWK+KBkVnrKenVADwrsUglc3oauVdOpOiGglc0LHbXBTVavNHeQohhgoUFWMeiJiDkP9kCP2BVC07H3Kzap4BNI+Giyos95aMbjaKf+nkyZNL7z9gSSbGysNSUExBTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649478; c=relaxed/simple;
	bh=EA+SADJaPTZDIiNUy3FLxxBcKny2K7CqK7TqNLcMeVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQGWlFvj/IBAvzv2NjH18/aNNHq/o7F6KoztwbU57Z2yqN7z54weGfKZNKZukwR0WRJdNiL/R14VOMekcqjyl2AQdqrQZzORTVG1CfnDnn7pg/aTuFmtKzxHBrhbFPsKckGe+l3L0ALqXz57zkPk6FYjBFZcOOChNmNFKcVBxm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0R+LP+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0R+LP+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8688C1F000E9;
	Tue, 21 Jul 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649477;
	bh=mQA2bVY+SXR16izZD9x3hQI4/TDHbqNuamjb1iBGDCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0R+LP+413lEOI+B3Pb38uKjXHwaAHVST5N+oMdeejYqzhspci84pF3+H2e0x6DZj
	 qEryxxKeHhC4Qdg4c3hmg/CbfJtbwMRPIU/lE9pl6JfD+DlS/VP34vpagXwdekwAHE
	 YIIxXnvUa9sRMxGtg8qelWexAF008LXRVXviXPDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Eskew <dylan.eskew@candelatech.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0591/2077] wifi: mt76: mt7996: limit work in set_bitrate_mask
Date: Tue, 21 Jul 2026 17:04:24 +0200
Message-ID: <20260721152606.750256371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Eskew <dylan.eskew@candelatech.com>

[ Upstream commit 5fd3385505600934f5faa9635e5b30fa38e548b9 ]

Calls to mt7996_set_bitrate_mask() would propagate work for all stations
on the ieee80211_hw regardless of the vif specified in the call. To
prevent unnecessary work in FW, limit setting the sta_rate to only the
specified vif in mt7996_sta_rate_ctrl_update().

Fixes: afff4325548f0 ("wifi: mt76: mt7996: Use proper link_id in link_sta_rc_update callback")
Signed-off-by: Dylan Eskew <dylan.eskew@candelatech.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260408145057.2356878-2-dylan.eskew@candelatech.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index a8a6552d49f69a..26b8c91db0a81e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1959,7 +1959,11 @@ static void mt7996_sta_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	struct mt7996_sta_link *msta_link;
-	u32 *changed = data;
+	struct mt7996_vif *mvif = data;
+	u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
+
+	if (msta->vif != mvif)
+		return;
 
 	msta_link = rcu_dereference(msta->link[msta->deflink_id]);
 	if (msta_link)
@@ -1972,7 +1976,6 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-	u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
 
 	mvif->deflink.bitrate_mask = *mask;
 
@@ -1985,7 +1988,7 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 * then multiple MCS setting (MCS 4,5,6) is not supported.
 	 */
 	ieee80211_iterate_stations_atomic(hw, mt7996_sta_rate_ctrl_update,
-					  &changed);
+					  mvif);
 	ieee80211_queue_work(hw, &dev->rc_work);
 
 	return 0;
-- 
2.53.0



