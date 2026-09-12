Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6F93B71DA;
	Sat, 12 Sep 2026 10:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209356; cv=none; b=CWVJeSgMYPTsNuskjcUY51DDfCAKzRfQWtqPhFbz7WU7a2wWwhq03YhmM4gPuUuq/45XQHscjuM1dt8isLPrmiHPQckzogE1X7kSrv59hxodZncZrw/1mBlus8Xf7xvgmYGLiit1tg0gWTFaHCyWJICeY7NmOtNlR8QMiNUuuIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209356; c=relaxed/simple;
	bh=ijGMy5Ng5YG5qSfkF7y8//7s+dOVQHMYe+KHBVdlLN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4fvkwwmWnYoe8AZ3uAhbAFyx4cYQTF9HxXWiqLob0wpQYsZ6O8znlQl76RTmTweEwZErs7DtrK2xsLiR6y8KJkMiG47oqRg92ms2NuKQX8AipD5Y1nlJTHvEOLtqgPgxXcCdKbP7fg56gvfrfrJKY0lz4Q0MlUou6S53vb/RF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOpc3T4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOpc3T4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C276E1F000FF;
	Sat, 12 Sep 2026 10:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209355;
	bh=0sJ0r5np1QZuBynlbJOMcomrFdqIjScAWCevVmGj+Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOpc3T4W+M9F8TS/gGQNqyYGzO8Jp3FPi6b9aiN2vXqTypEG7F8sPj4kVJ/TZHCaL
	 i4Gmi5otIFS2c3Z9zg17GHZ9lHFJ6khXXe5VHWh/kGIslWH9t+7C6Rs2RIxIFl04Hl
	 1RWwB03cPZqTZqbXjQHjhdJfF2C/bl5AS0lmWkWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0804/1518] wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()
Date: Sat, 12 Sep 2026 08:49:33 +0200
Message-ID: <20260912065641.621127080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 4330a0ef9f75a54fde3548432a9a698f06bab635 ]

When mac80211 leaves the link unspecified, mt7996_tx() substitutes the
primary link id of the station or vif. That value is
IEEE80211_LINK_UNSPECIFIED (0xf) until the first link has been added,
and it is then used unchecked to index vif->link_conf[],
mvif->mt76.link[] and sta->link[], all of which hold
IEEE80211_MLD_MAX_NUM_LINKS (15) entries.

Clamp the primary link id to the default link before using it, and use
the clamped value for the link_sta fallback as well.

Fixes: 1609b014aa29 ("wifi: mt76: mt7996: Overwrite unspecified link_id in mt7996_tx()")
Link: https://patch.msgid.link/20260801145334.1166751-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index a319a99b5056e..c6d7088b15cab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1361,20 +1361,26 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct mt7996_vif *mvif = vif ? (void *)vif->drv_priv : NULL;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
+	u8 deflink_id = IEEE80211_LINK_UNSPECIFIED;
 	u8 link_id = u32_get_bits(info->control.flags,
 				  IEEE80211_TX_CTRL_MLO_LINK);
 
 	rcu_read_lock();
 
+	if (msta)
+		deflink_id = msta->deflink_id;
+	else if (mvif)
+		deflink_id = mvif->mt76.deflink_id;
+
+	/* the primary link is unset until the first link has been added */
+	if (deflink_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		deflink_id = 0;
+
 	/* Use primary link_id if the value from mac80211 is set to
 	 * IEEE80211_LINK_UNSPECIFIED.
 	 */
-	if (link_id == IEEE80211_LINK_UNSPECIFIED) {
-		if (msta)
-			link_id = msta->deflink_id;
-		else if (mvif)
-			link_id = mvif->mt76.deflink_id;
-	}
+	if (link_id == IEEE80211_LINK_UNSPECIFIED)
+		link_id = deflink_id;
 
 	if (vif && ieee80211_vif_is_mld(vif)) {
 		struct ieee80211_bss_conf *link_conf;
@@ -1384,7 +1390,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 
 			link_sta = rcu_dereference(sta->link[link_id]);
 			if (!link_sta)
-				link_sta = rcu_dereference(sta->link[msta->deflink_id]);
+				link_sta = rcu_dereference(sta->link[deflink_id]);
 
 			if (link_sta) {
 				memcpy(hdr->addr1, link_sta->addr, ETH_ALEN);
-- 
2.53.0



