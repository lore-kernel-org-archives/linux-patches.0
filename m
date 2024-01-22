Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A113513398C;
	Tue, 23 Jan 2024 00:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969313; cv=none; b=W+XTUJjF8BZ6/lqdqo5j7aQEgIbNEByf8tIw3esmxtIXwhXqb02dhYn80Kj4SEM1v2E/E3tGVof8UTgI1bQNWcbTiI78fO2WJDXBPvwqk3Fu99pIM6kHHp8eCEwmeqzDBdZO+KtQAG4Jnz0G4h2xOObntnI3GnL76cbAlO67hmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969313; c=relaxed/simple;
	bh=LrwYmRej1oQhJqgII3r6HGrV4Y3NTsCzxRUKsFnz4w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IceM6pluhj/ZetdpUpK6VGZ7J5WnbXWDOelqsGn/+995kU4M6oGH4CDkCeMZGt4J8nRRgfktuNe3kV1rf6I7eS7a2MiuB7/s1KdbkLYKvyROPupy9XRI0GyQnzB9ZmXeg5+WUOASYtR+Jr92wssfULnuVxDxsdYAdQhAulvfsK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOmaw2pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOmaw2pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49261C43143;
	Tue, 23 Jan 2024 00:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969313;
	bh=LrwYmRej1oQhJqgII3r6HGrV4Y3NTsCzxRUKsFnz4w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOmaw2pGUOxPRcConFj3LbffbmdVIEu5N9qLv9YFcomPrqciuyVfuv36W4+Ncy5ge
	 ULb5cVNv4jvifTqAb+DGKGMVCVlX2eio9AtPNamtlWMCFTI+qKhkOii5eF0didihsW
	 G1UtrGq8wyhH/248svoChD73W9vLBWx+paWzw2TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 168/641] wifi: mt76: mt7921: fix wrong 6Ghz power type
Date: Mon, 22 Jan 2024 15:51:12 -0800
Message-ID: <20240122235823.267676873@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 10f2903147ed04784522ab841c20bb469bdd8681 ]

To avoid using incorrect 6g power settings after disconnection,
it should to update back to the default state when disconnected.

Fixes: 51ba0e3a15eb ("wifi: mt76: mt7921: add 6GHz power type support for clc")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 38 +++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 510a575a973b..0645417e0582 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -683,17 +683,45 @@ static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 }
 
 static void
-mt7921_regd_set_6ghz_power_type(struct ieee80211_vif *vif)
+mt7921_calc_vif_num(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	u32 *num = priv;
+
+	if (!priv)
+		return;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		*num += 1;
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+mt7921_regd_set_6ghz_power_type(struct ieee80211_vif *vif, bool is_add)
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct mt792x_phy *phy = mvif->phy;
 	struct mt792x_dev *dev = phy->dev;
+	u32 valid_vif_num = 0;
+
+	ieee80211_iterate_active_interfaces(mt76_hw(dev),
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7921_calc_vif_num, &valid_vif_num);
 
-	if (hweight64(dev->mt76.vif_mask) > 1) {
+	if (valid_vif_num > 1) {
 		phy->power_type = MT_AP_DEFAULT;
 		goto out;
 	}
 
+	if (!is_add)
+		vif->bss_conf.power_type = IEEE80211_REG_UNSET_AP;
+
 	switch (vif->bss_conf.power_type) {
 	case IEEE80211_REG_SP_AP:
 		phy->power_type = MT_AP_SP;
@@ -705,6 +733,8 @@ mt7921_regd_set_6ghz_power_type(struct ieee80211_vif *vif)
 		phy->power_type = MT_AP_LPI;
 		break;
 	case IEEE80211_REG_UNSET_AP:
+		phy->power_type = MT_AP_UNSET;
+		break;
 	default:
 		phy->power_type = MT_AP_DEFAULT;
 		break;
@@ -749,7 +779,7 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	mt7921_regd_set_6ghz_power_type(vif);
+	mt7921_regd_set_6ghz_power_type(vif, true);
 
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 
@@ -811,6 +841,8 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		list_del_init(&msta->wcid.poll_list);
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
 
+	mt7921_regd_set_6ghz_power_type(vif, false);
+
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 }
 EXPORT_SYMBOL_GPL(mt7921_mac_sta_remove);
-- 
2.43.0



