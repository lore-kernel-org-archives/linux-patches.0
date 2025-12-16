Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99247126C02;
	Tue, 16 Dec 2025 11:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886078; cv=none; b=fuYID1cL3C9/OT2CtW6vd7iTvxj76u0RHun8VAxUqenFQmj/egYl7hwsoxUUCKyRdCGtKDWp7wahXuoWElLuxnL2N3VSRsuFxcs2/wZaaB+NdgnmsiXM+OfwziUO3sGPxPOXdjjAwUH94i3+E7+6oKq92zFSf52jYijksfOWxsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886078; c=relaxed/simple;
	bh=Wvk6gydHNzcd9yWyZulc6+PBFhpWvSt75y6xzDR/Gtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t198mq4mJa0NaX1mwQQhN+YI3cmypW9F4HPYBAdsSDIdvHSujQLjKJFpZcsASpvB0ItozcPg6LH0atMqV5kMZOfNnn0hNJwEgQ+hnjEETIQLDPVs/vQDn1t4yYlyfBH1dupDEy7KtlDVHSfrRXH+UMNCsR2yY67C2JhqCWNDyFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSsk4e3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSsk4e3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05835C4CEF1;
	Tue, 16 Dec 2025 11:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886078;
	bh=Wvk6gydHNzcd9yWyZulc6+PBFhpWvSt75y6xzDR/Gtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSsk4e3slCc2hxDLuVNg6NTW2bmSGGHdF9XtNULUVbLnjj1Eo7C+Lo4Ce+nPMiJEi
	 vK/kPULz+D9AR5fzFy4Bg4wQucEJA9m+Q8GXDgTYSASuQ0ncWm4rokU5DLxMilSphy
	 L5qFiYq6ZghJw0MKZzmCN5F6eRcz7R78NrRfnYT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 332/507] wifi: mt76: mt7996: fix MLD group index assignment
Date: Tue, 16 Dec 2025 12:12:53 +0100
Message-ID: <20251216111357.493386457@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 4fb3b4e7d1ca5453c6167816230370afc15f26bf ]

Fix extender mode and MBSS issues caused by incorrect assignment of the
MLD group and remap indices.

Fixes: ed01c310eca9 ("wifi: mt76: mt7996: Fix mt7996_mcu_bss_mld_tlv routine")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-9-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 58 +++++++++++++------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index b8bd2bda5172f..14e90ecf925e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -90,9 +90,11 @@ static void mt7996_stop(struct ieee80211_hw *hw, bool suspend)
 {
 }
 
-static inline int get_free_idx(u32 mask, u8 start, u8 end)
+static inline int get_free_idx(u64 mask, u8 start, u8 end)
 {
-	return ffs(~mask & GENMASK(end, start));
+	if (~mask & GENMASK_ULL(end, start))
+		return __ffs64(~mask & GENMASK_ULL(end, start)) + 1;
+	return 0;
 }
 
 static int get_omac_idx(enum nl80211_iftype type, u64 mask)
@@ -311,12 +313,6 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	if (idx < 0)
 		return -ENOSPC;
 
-	if (!dev->mld_idx_mask) { /* first link in the group */
-		mvif->mld_group_idx = get_own_mld_idx(dev->mld_idx_mask, true);
-		mvif->mld_remap_idx = get_free_idx(dev->mld_remap_idx_mask,
-						   0, 15);
-	}
-
 	mld_idx = get_own_mld_idx(dev->mld_idx_mask, false);
 	if (mld_idx < 0)
 		return -ENOSPC;
@@ -334,10 +330,6 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		return ret;
 
 	dev->mt76.vif_mask |= BIT_ULL(mlink->idx);
-	if (!dev->mld_idx_mask) {
-		dev->mld_idx_mask |= BIT_ULL(mvif->mld_group_idx);
-		dev->mld_remap_idx_mask |= BIT_ULL(mvif->mld_remap_idx);
-	}
 	dev->mld_idx_mask |= BIT_ULL(link->mld_idx);
 	phy->omac_mask |= BIT_ULL(mlink->omac_idx);
 
@@ -421,11 +413,6 @@ void mt7996_vif_link_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	dev->mt76.vif_mask &= ~BIT_ULL(mlink->idx);
 	dev->mld_idx_mask &= ~BIT_ULL(link->mld_idx);
 	phy->omac_mask &= ~BIT_ULL(mlink->omac_idx);
-	if (!(dev->mld_idx_mask & ~BIT_ULL(mvif->mld_group_idx))) {
-		/* last link */
-		dev->mld_idx_mask &= ~BIT_ULL(mvif->mld_group_idx);
-		dev->mld_remap_idx_mask &= ~BIT_ULL(mvif->mld_remap_idx);
-	}
 
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
 	if (!list_empty(&msta_link->wcid.poll_list))
@@ -2181,7 +2168,42 @@ mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u16 old_links, u16 new_links,
 			struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS])
 {
-	return 0;
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	int ret = 0;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	if (!old_links) {
+		int idx;
+
+		idx = get_own_mld_idx(dev->mld_idx_mask, true);
+		if (idx < 0) {
+			ret = -ENOSPC;
+			goto out;
+		}
+		mvif->mld_group_idx = idx;
+		dev->mld_idx_mask |= BIT_ULL(mvif->mld_group_idx);
+
+		idx = get_free_idx(dev->mld_remap_idx_mask, 0, 15) - 1;
+		if (idx < 0) {
+			ret = -ENOSPC;
+			goto out;
+		}
+		mvif->mld_remap_idx = idx;
+		dev->mld_remap_idx_mask |= BIT_ULL(mvif->mld_remap_idx);
+	}
+
+	if (new_links)
+		goto out;
+
+	dev->mld_idx_mask &= ~BIT_ULL(mvif->mld_group_idx);
+	dev->mld_remap_idx_mask &= ~BIT_ULL(mvif->mld_remap_idx);
+
+out:
+	mutex_unlock(&dev->mt76.mutex);
+
+	return ret;
 }
 
 const struct ieee80211_ops mt7996_ops = {
-- 
2.51.0



