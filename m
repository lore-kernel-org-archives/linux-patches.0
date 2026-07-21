Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E78A47126F;
	Tue, 21 Jul 2026 17:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656501; cv=none; b=auUgCepYpj96p/rqUnzRzCuc3H0CnCF+bjc855nQHFzMdRGz7DzhQ2XdUxtOlk3C6UpzMczzOY75QQ/VtVi7jjXutrUhtK7dCQ9oNoNPNY0MvSD+mKCV3n7NLxHDxu99SPpTWOnLB2wC2O7c1wQdPwb1RIFbI+X/9Cg4ZACqD8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656501; c=relaxed/simple;
	bh=yHZyoKvLwLwnnFRDVK/+qg+CzISESKe+QOGxyXbex2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKEDgFT006qQTJB8C4JbAFYWEVulx90rilJw9LAqN+cPQ2O4YVPhvuDljtajbbOgEv8oNpijtQPBzxd8enmZxaXqQqVI1VpWYXbXNgJb/ZeDuX0WoPtgAohm1kpDMj5vdZiGS39ZGg4J8pjoHyxIenYhDczRgwIj9Bdfg731lTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs9OOYND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs9OOYND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF8E1F000E9;
	Tue, 21 Jul 2026 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656500;
	bh=fQeYB586rT2Zna5dJ9w0X2DqynbAnmBRL8BDDVJAs4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zs9OOYND5hp+RGwSWyezszJ/RIUUWYfx2FR0E+8h/MkoMM34Qv5m5vJ6f+W8vZL7e
	 kUjfwFNF8L93/sg41p2GKEtU1aUKqQL3ZbmQeSlFkkioXoaXWepXrBDGiW1OoKnCak
	 uFapFZHk1nD8Tv7ubbpiKd8goWqwJ+LldTYE2qi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Eskew <dylan.eskew@candelatech.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0410/1611] wifi: mt76: mt7996: limit work in set_bitrate_mask
Date: Tue, 21 Jul 2026 17:08:46 +0200
Message-ID: <20260721152524.472706395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index d714b7f3efe565..20da0c10669a9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1795,7 +1795,11 @@ static void mt7996_sta_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
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
@@ -1808,7 +1812,6 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-	u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
 
 	mvif->deflink.bitrate_mask = *mask;
 
@@ -1821,7 +1824,7 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 * then multiple MCS setting (MCS 4,5,6) is not supported.
 	 */
 	ieee80211_iterate_stations_atomic(hw, mt7996_sta_rate_ctrl_update,
-					  &changed);
+					  mvif);
 	ieee80211_queue_work(hw, &dev->rc_work);
 
 	return 0;
-- 
2.53.0



