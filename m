Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417341DF246;
	Sun,  7 Sep 2025 20:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277510; cv=none; b=B80/b4rk7QmjqUPKvtmQHvmZO84SqG1RtvKdIdgFAzmLBXUjLxURaLwqN6iSlQr5bevhFAsZzeHm510zgp3CQqJrdmX3bz4trYjc+wEhVKa7lOk5fKH8rFBTb18I3O7mt1vwXGFoWQ/3PtECeImj43cXlxX4gKLmj/61W/oppO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277510; c=relaxed/simple;
	bh=Xi2jyFGyuRmpmrKaqmfnEwLnroJlSz6AXVI2aNgaHEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kgvxf4K0cmDzQDkVUACtrq+UyplSw8guJcL97k/E+g/FdKjPPi3VHWZoh/GfllGaA8MFZCH5dWiLpnfDxXcJOhDNCL8/ENoYkXf+0Bni9SyYIuoAVY63exEWrIl7ghxmEjJUFQfwAmK66z/B1w0rEVVllw2erH/IVUhRZUo1VAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PudQW5GM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PudQW5GM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CE0C4CEF0;
	Sun,  7 Sep 2025 20:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277510;
	bh=Xi2jyFGyuRmpmrKaqmfnEwLnroJlSz6AXVI2aNgaHEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PudQW5GM+O3OEIvYAJt5szvm8jzy63hTmCHeTEMyX+bS57KIowa57ztuqqr6keSkf
	 1kJhReRAR7eTMzZY8l84i4m9GfMcnI5T1zgI8NumlLlz/Ifir4T6rBlmMF/UKJTYrK
	 o1kAwy8+Jg/HyPKy3W2CcHTiYoGhccPy6GkYSqQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 038/183] wifi: mt76: mt7915: fix list corruption after hardware restart
Date: Sun,  7 Sep 2025 21:57:45 +0200
Message-ID: <20250907195616.682019816@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 45c8db939d554..4e435bec828b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -818,6 +818,43 @@ void mt76_free_device(struct mt76_dev *dev)
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
 struct mt76_phy *mt76_vif_phy(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0ecf77fcbe3d0..0290ddbb2424e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1241,6 +1241,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates);
 void mt76_unregister_device(struct mt76_dev *dev);
 void mt76_free_device(struct mt76_dev *dev);
+void mt76_reset_device(struct mt76_dev *dev);
 void mt76_unregister_phy(struct mt76_phy *phy);
 
 struct mt76_phy *mt76_alloc_radio_phy(struct mt76_dev *dev, unsigned int size,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 6639976afcee6..1c0d310146d63 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1460,17 +1460,15 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
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
2.50.1



