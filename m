Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9472D839A;
	Tue, 15 Jul 2025 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587039; cv=none; b=k16gKuE+8ffqqC8vhmUcndFOm6RqBF6nEEw8LIAceX/TjbPACtft2lcO9kIEg65jNx2GJdQDbWN9My14fc9s88PR9IFHLz7qP92Vg+qFQVCi5zPZlF694EApLiphObke5oAlFoynXl9Q5HuRalMHNezHs84Ciwo2TPa+c826Vw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587039; c=relaxed/simple;
	bh=PF9MFtWHT3LRBuMg+J/liMJBxwJJhBmxlM0jaf26lrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qajc0XT/ulH/m2HfqxXJTvzJbngQuHFCa15mgFokhi5LUDezB3je5EI3oaJpA1GjGeCfcTJGfuKNRP1C+VJaJ0/3Eis4hr9TBDbeBPMhpxve0sktO/V0E+YS41FEhK8l+KIqAu0mcoPVpzhd20YeKY81CGM+qWF5GdBJc6Mfovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxjztqYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxjztqYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00001C4CEE3;
	Tue, 15 Jul 2025 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587039;
	bh=PF9MFtWHT3LRBuMg+J/liMJBxwJJhBmxlM0jaf26lrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxjztqYkGVG5ySgQ81gGTonITbFkIX64pBB8/1OxUgD+1Y8YNzl7S9z58pxOYhpO0
	 03lUtctk70QOGMx5hYUQ5/d1EkDy5lSZuZJ2U5EtwXg/bAbgq7ZBBv4bBVftWOfXAX
	 hIUCPMXtrd78xf+cYm0oyFXszSPFqGKtLrk3/buE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 143/192] wifi: mt76: Remove RCU section in mt7996_mac_sta_rc_work()
Date: Tue, 15 Jul 2025 15:13:58 +0200
Message-ID: <20250715130820.644465893@linuxfoundation.org>
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

[ Upstream commit 71532576f41e5b0ec967a82ed49d5dfb1027ccdb ]

Since mt7996_mcu_add_rate_ctrl() and mt7996_mcu_set_fixed_field() can't
run in atomic context, move RCU critical section in
mt7996_mcu_add_rate_ctrl() and mt7996_mcu_set_fixed_field(). This patch
fixes a 'sleep while atomic' issue in mt7996_mac_sta_rc_work().

Fixes: 0762bdd30279 ("wifi: mt76: mt7996: rework mt7996_mac_sta_rc_work to support MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20250605-mt7996-sleep-while-atomic-v1-5-d46d15f9203c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 35 ++++---------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 20a201e336759..3646806088e9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2318,19 +2318,12 @@ void mt7996_mac_update_stats(struct mt7996_phy *phy)
 void mt7996_mac_sta_rc_work(struct work_struct *work)
 {
 	struct mt7996_dev *dev = container_of(work, struct mt7996_dev, rc_work);
-	struct ieee80211_bss_conf *link_conf;
-	struct ieee80211_link_sta *link_sta;
 	struct mt7996_sta_link *msta_link;
-	struct mt76_vif_link *mlink;
-	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
-	struct mt7996_sta *msta;
 	struct mt7996_vif *mvif;
 	LIST_HEAD(list);
 	u32 changed;
-	u8 link_id;
 
-	rcu_read_lock();
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
 	list_splice_init(&dev->sta_rc_list, &list);
 
@@ -2341,24 +2334,9 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 
 		changed = msta_link->changed;
 		msta_link->changed = 0;
-
-		sta = wcid_to_sta(&msta_link->wcid);
-		link_id = msta_link->wcid.link_id;
-		msta = msta_link->sta;
-		mvif = msta->vif;
-		vif = container_of((void *)mvif, struct ieee80211_vif, drv_priv);
-
-		mlink = rcu_dereference(mvif->mt76.link[link_id]);
-		if (!mlink)
-			continue;
-
-		link_sta = rcu_dereference(sta->link[link_id]);
-		if (!link_sta)
-			continue;
-
-		link_conf = rcu_dereference(vif->link_conf[link_id]);
-		if (!link_conf)
-			continue;
+		mvif = msta_link->sta->vif;
+		vif = container_of((void *)mvif, struct ieee80211_vif,
+				   drv_priv);
 
 		spin_unlock_bh(&dev->mt76.sta_poll_lock);
 
@@ -2366,17 +2344,18 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 			       IEEE80211_RC_NSS_CHANGED |
 			       IEEE80211_RC_BW_CHANGED))
 			mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
-						 link_id, true);
+						 msta_link->wcid.link_id,
+						 true);
 
 		if (changed & IEEE80211_RC_SMPS_CHANGED)
-			mt7996_mcu_set_fixed_field(dev, msta, NULL, link_id,
+			mt7996_mcu_set_fixed_field(dev, msta_link->sta, NULL,
+						   msta_link->wcid.link_id,
 						   RATE_PARAM_MMPS_UPDATE);
 
 		spin_lock_bh(&dev->mt76.sta_poll_lock);
 	}
 
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
-	rcu_read_unlock();
 }
 
 void mt7996_mac_work(struct work_struct *work)
-- 
2.39.5



