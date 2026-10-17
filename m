Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C011380FCA;
	Sat, 17 Oct 2026 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253448; cv=none; b=KicZQOvcfiPRsTjmdffyBOWq+H0wgmAw7qc0wKTeC9hNpK/4tfgRFpPQeu3Xi9tqU/VslMIamU90EJ3pr7dkb8oQ0flAu2yu1ZYMlTrEGoC8pmL59qiWZN+P8Jj8bk6/iKhh68o93aQP0Hh9ZVRVzIwhoeEZyiTQLm3pkJOTIiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253448; c=relaxed/simple;
	bh=mqUKgyxGYk6e2zPykHiFBCc/UgkftIK6DJ4HRAorFuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnfOVQWLszdHDJF4myewSoEXj05zpG4DO/XfSvfNsjOCO98a9iEuvFSlKvzoYtZDstSjYuGkQ0+Ql5nEMEIdbbBhbg8gVyblXC5xiPvHK+PKBDQSGadG4OEkDuD2A1tY/gUxfss9QasKR6o5WuBnBc8b9vHezlLbYhSg2RZyyOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrhPloEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrhPloEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958801F000C4;
	Sat, 17 Oct 2026 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253447;
	bh=TqZs6rw8f20lR3/ilonSq2f26TfmvxrZqhNKEx7tcqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrhPloEBGJbP6B+S2aCdD0pLISACNB1sgW8j9Ugp+fm2WKcUJORod+m/H/fJhO5jt
	 A3Qs7CgS817T5cfqEkRLw6o4ldlnrM0QuDLPn/5l4FdQQNFovtp7gceRM0PpARj/AV
	 aXrucUHeF9oZK9eoAGiiuqGEhfSTvBlgs72mOVww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/869] wifi: mt76: mt7915: fix list corruption after hardware restart
Date: Sat, 17 Oct 2026 17:49:23 +0200
Message-ID: <20261017160040.169021793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e1856664ca5d1..ca1f7b2991c51 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -791,6 +791,43 @@ void mt76_free_device(struct mt76_dev *dev)
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
index daa78f52c15ea..ffcd4509dfcae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1168,6 +1168,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates);
 void mt76_unregister_device(struct mt76_dev *dev);
 void mt76_free_device(struct mt76_dev *dev);
+void mt76_reset_device(struct mt76_dev *dev);
 void mt76_unregister_phy(struct mt76_phy *phy);
 
 struct mt76_phy *mt76_alloc_phy(struct mt76_dev *dev, unsigned int size,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index f165e61ed28f7..147c0fbfbeb84 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1458,17 +1458,15 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
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



