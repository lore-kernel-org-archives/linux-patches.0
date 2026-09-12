Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9035619E7F7;
	Sat, 12 Sep 2026 08:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201231; cv=none; b=jV8wfAkSg2NupT/fKorsCyQfxoqGNEex6lWCMsaLwNobP5A62vyvxhryQ03J9mT6jIIMBgyUycB0YUO56ITL4LfxdxVjWEIKSdA9clqHTP/G8q2Klt3B8urX2a1gyVGErV6iErqw+TkSRjrJiIkjTSqnX0BO4F2O/gzZcPnBKCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201231; c=relaxed/simple;
	bh=dszA5I2dSq9f3x5K8AAnsjQXcJSEA4MadCvMIgosjwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjSQln1tk3BLbCvYLwfAzx2YW+XgJW9SnyOqxNrm3HREjTA37pHhqk5o1T2QbGbDYDLuENeIBNq5vjKyIdStvvCY6AEF8qeVMpllpXH9eBHDRCnyVat82Gzxsw48kYA8sgU4MSr6/N2MHamNDjOpFs5Y/6Q6lABWZcg6DJSxY/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A23yzt+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A23yzt+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929B1F000FF;
	Sat, 12 Sep 2026 08:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201230;
	bh=0z5D3TTqk+pyVS3KjLvS+ukWNjHuEUgYPKB+yoJ3MLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A23yzt+iqIs/pC/rOj1SR8P1n0YIapRER8I45flOwkWDqd9ZU/twMQ5tB5s75K+8P
	 0z/Er4Sz3BKg5EzA41eXx2l9hM5bmRqvq0RuCZ4PIG5v2qGyKqLF3/p8LUwIUWhVrI
	 qToO5k2VdAJyneSYOwuOsqmASoMb62eLS/yiafWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0952/1815] wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()
Date: Sat, 12 Sep 2026 08:45:02 +0200
Message-ID: <20260912065711.315744119@linuxfoundation.org>
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
index c49c6f92efe2d..c6140412ed322 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1511,20 +1511,26 @@ static void mt7996_tx(struct ieee80211_hw *hw,
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
@@ -1534,7 +1540,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 
 			link_sta = rcu_dereference(sta->link[link_id]);
 			if (!link_sta)
-				link_sta = rcu_dereference(sta->link[msta->deflink_id]);
+				link_sta = rcu_dereference(sta->link[deflink_id]);
 
 			if (link_sta) {
 				memcpy(hdr->addr1, link_sta->addr, ETH_ALEN);
-- 
2.53.0



