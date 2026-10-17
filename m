Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1213B387373;
	Sat, 17 Oct 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258143; cv=none; b=ctWt6gBOoAGAa6xsuMEm0FkqH+R76jdAERBGyVX/gQqmUq41c8yzv9xZkcVCFv15zWWLWkqRZBE2ZQ626WvDcos1tJ65iFzxF+qxEpMhsowwUsz4cEBGD+QvusvPJr+lBVbjqpzkPT+89YhNkKcJaUmBF5n9RKWT27lSQOQ5GGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258143; c=relaxed/simple;
	bh=zVegvnIEupoaSU0qitjKy6N/N3iLJ1gV+g6nJsHzSJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEDju7DVYznaYrnooGQZByoanUFMUc7XrNFvgb6jwj2PBFdccuiMsDECPdLccIbmTOF6o5ZY+fAGgIeD4Qcz1hriggPcrc5IedbDMcXYY7QcC37Z7l6c2iV851eUp2M2J3MWPeSVOq4J1JRk++vYnNbqE0F8oF0BV6wDY4xKPQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVElX98b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVElX98b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD161F000C4;
	Sat, 17 Oct 2026 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258141;
	bh=6eBQJdwTUSfta6EUchww8beBJblLdU4Z54TVqMG/9Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVElX98b1YRby5Mqjkvvs2GQYlx0YHnGKK3LkqJQ7jENLC1zNBL9kYaIZNeoH5nhI
	 Dt9UDkwbdfwX9snhq+JbsHSrRg0fcXD+koWzfxE/pSuUkEyw0kFAoWdkmay3gJTxYP
	 9H+kRiF6vNRw+RkLjqxLkVXHniE9faLkkBdCvx68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0785/1674] wifi: mt76: mt7915: fix list corruption after hardware restart
Date: Sat, 17 Oct 2026 17:50:57 +0200
Message-ID: <20261017160451.253285439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 065c79df595af21d6d1b27d642860faa1d938774 ]

Since stations are recreated from scratch, all lists that wcids are added
to must be cleared before calling ieee80211_restart_hw.
Set wcid->sta = 0 for each wcid entry in order to ensure that they are
not added again before they are ready.

Fixes: 8a55712d124f ("wifi: mt76: mt7915: enable full system reset support")
Link: https://patch.msgid.link/20250827085352.51636-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 37 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 12 +++---
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 61543ab7c2560..3f09bf58130d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -763,6 +763,43 @@ void mt76_free_device(struct mt76_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76_free_device);
 
+static void mt76_reset_phy(struct mt76_phy *phy)
+{
+	if (!phy)
+		return;
+
+	INIT_LIST_HEAD(&phy->tx_list);
+}
+
+void mt76_reset_device(struct mt76_dev *dev)
+{
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < ARRAY_SIZE(dev->wcid); i++) {
+		struct mt76_wcid *wcid;
+
+		wcid = rcu_dereference(dev->wcid[i]);
+		if (!wcid)
+			continue;
+
+		wcid->sta = 0;
+		mt76_wcid_cleanup(dev, wcid);
+		rcu_assign_pointer(dev->wcid[i], NULL);
+	}
+	rcu_read_unlock();
+
+	INIT_LIST_HEAD(&dev->wcid_list);
+	INIT_LIST_HEAD(&dev->sta_poll_list);
+	dev->vif_mask = 0;
+	memset(dev->wcid_mask, 0, sizeof(dev->wcid_mask));
+
+	mt76_reset_phy(&dev->phy);
+	for (i = 0; i < ARRAY_SIZE(dev->phys); i++)
+		mt76_reset_phy(dev->phys[i]);
+}
+EXPORT_SYMBOL_GPL(mt76_reset_device);
+
 static void mt76_rx_release_amsdu(struct mt76_phy *phy, enum mt76_rxq_id q)
 {
 	struct sk_buff *skb = phy->rx_amsdu[q].head;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index df0ea638370b5..5050f640530f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1080,6 +1080,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates);
 void mt76_unregister_device(struct mt76_dev *dev);
 void mt76_free_device(struct mt76_dev *dev);
+void mt76_reset_device(struct mt76_dev *dev);
 void mt76_unregister_phy(struct mt76_phy *phy);
 
 struct mt76_phy *mt76_alloc_phy(struct mt76_dev *dev, unsigned int size,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index a594a88f20546..fd743ef86e7ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1452,17 +1452,15 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
 	if (i == 10)
 		dev_err(dev->mt76.dev, "chip full reset failed\n");
 
-	spin_lock_bh(&dev->mt76.sta_poll_lock);
-	while (!list_empty(&dev->mt76.sta_poll_list))
-		list_del_init(dev->mt76.sta_poll_list.next);
-	spin_unlock_bh(&dev->mt76.sta_poll_lock);
-
-	memset(dev->mt76.wcid_mask, 0, sizeof(dev->mt76.wcid_mask));
-	dev->mt76.vif_mask = 0;
 	dev->phy.omac_mask = 0;
 	if (phy2)
 		phy2->omac_mask = 0;
 
+	mt76_reset_device(&dev->mt76);
+
+	INIT_LIST_HEAD(&dev->sta_rc_list);
+	INIT_LIST_HEAD(&dev->twt_list);
+
 	i = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7915_WTBL_STA);
 	dev->mt76.global_wcid.idx = i;
 	dev->recovery.hw_full_reset = false;
-- 
2.53.0



