Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E9535AC18;
	Wed, 20 May 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297628; cv=none; b=aWhHczJJ95sGfWzNuGOdZMmeoEI624Omu18fYdpusaMVc5CrQcIEWFgIfp8eaevmSBbtpFa50xskGB0HNAgmmYi6LW59YvRhjSHEuydUmGLlek2gMTE0um4Z85dAy98YUs7HFo6qIUn+tnLlXm/eCSJX0kDRaNN5bAz0RP1ya+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297628; c=relaxed/simple;
	bh=cN3hi2evkfiYGh/oPMl3YPft416HvR9PyzD9rkjhgCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ytdx0n9WtOrfIWxW1gJCDZgXiwBpd1Q4RS1pflQLC8oTLFXoJ9R+x/AhbxiXyr/PLAM+vqAIGEsC5BpqqgroUryWAHMWAI0uBo8NWc0JNyNrywDRrVyQZ5Y6nF/B47YIcM/nk/89yLDmuuNf5JCp8ouZiQvsAopVBuC/gdlD6Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jU7mQZf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jU7mQZf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CFA1F000E9;
	Wed, 20 May 2026 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297627;
	bh=TQ1H3fllQYBpO58OYUdBH5nAyC9FT3IaC/4w/SSM+fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jU7mQZf5jx2TsNB4H86NTvmopcKP5ROBIDi0uXr0OwLBlo7wwDnOj6Oro1Vgzabwl
	 DZxiNpERFkh7yAaC97eRwL53uFEEPwbcmFWpkdUp5rDZ/vnTqW8XYrEmzqQwd1zULU
	 xti6NeHEm0ym2ywUtGdefaZx+ROsdyoxVOEtosYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/957] wifi: mt76: mt7996: Switch to the secondary link if the default one is removed
Date: Wed, 20 May 2026 18:09:46 +0200
Message-ID: <20260520162136.795121031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5ef44c200618430b004233cbfc1b0929a13d5ac8 ]

Switch to the secondary link if available in mt7996_mac_sta_remove_links
routine if the primary one is removed.
Moreover reset secondary link index for single link scenario.

Fixes: 85cd5534a3f2e ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251205-mt76-txq-wicd-fix-v2-3-f19ba48af7c1@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: e648051d52af ("wifi: mt76: mt7996: Decrement sta counter removing the link in mt7996_mac_reset_sta_iter()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 12 ++---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 51 +++++++++++++------
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 13a3b521437be..3280446f7caa8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2406,14 +2406,12 @@ mt7996_mac_reset_sta_iter(void *data, struct ieee80211_sta *sta)
 			continue;
 
 		mt7996_mac_sta_deinit_link(dev, msta_link);
-
-		if (msta->deflink_id == i) {
-			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-			continue;
-		}
-
-		kfree_rcu(msta_link, rcu_head);
+		if (msta_link != &msta->deflink)
+			kfree_rcu(msta_link, rcu_head);
 	}
+
+	msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
+	msta->seclink_id = msta->deflink_id;
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index af322f505f8ab..d714b7f3efe56 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -961,6 +961,22 @@ mt7996_post_channel_switch(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return ret;
 }
 
+static void
+mt7996_sta_init_txq_wcid(struct ieee80211_sta *sta, int idx)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct mt76_txq *mtxq;
+
+		if (!sta->txq[i])
+			continue;
+
+		mtxq = (struct mt76_txq *)sta->txq[i]->drv_priv;
+		mtxq->wcid = idx;
+	}
+}
+
 static int
 mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 			 struct ieee80211_bss_conf *link_conf,
@@ -978,21 +994,10 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 		return -ENOSPC;
 
 	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
-		int i;
-
 		msta_link = &msta->deflink;
 		msta->deflink_id = link_id;
 		msta->seclink_id = msta->deflink_id;
-
-		for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
-			struct mt76_txq *mtxq;
-
-			if (!sta->txq[i])
-				continue;
-
-			mtxq = (struct mt76_txq *)sta->txq[i]->drv_priv;
-			mtxq->wcid = idx;
-		}
+		mt7996_sta_init_txq_wcid(sta, idx);
 	} else {
 		msta_link = kzalloc(sizeof(*msta_link), GFP_KERNEL);
 		if (!msta_link)
@@ -1070,12 +1075,28 @@ mt7996_mac_sta_remove_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 		if (msta->deflink_id == link_id) {
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-			continue;
+			if (msta->seclink_id == link_id) {
+				/* no secondary link available */
+				msta->seclink_id = msta->deflink_id;
+			} else {
+				struct mt7996_sta_link *msta_seclink;
+
+				/* switch to the secondary link */
+				msta_seclink = mt76_dereference(
+						msta->link[msta->seclink_id],
+						mdev);
+				if (msta_seclink) {
+					msta->deflink_id = msta->seclink_id;
+					mt7996_sta_init_txq_wcid(sta,
+						msta_seclink->wcid.idx);
+				}
+			}
 		} else if (msta->seclink_id == link_id) {
-			msta->seclink_id = IEEE80211_LINK_UNSPECIFIED;
+			msta->seclink_id = msta->deflink_id;
 		}
 
-		kfree_rcu(msta_link, rcu_head);
+		if (msta_link != &msta->deflink)
+			kfree_rcu(msta_link, rcu_head);
 	}
 }
 
-- 
2.53.0



