Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55D834889F;
	Tue,  6 Jan 2026 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721430; cv=none; b=fcNZd+ZmGC0mv0Ez018MnL/57S4dMdc3+YKUY5hs8vZIgjm1uVx8QbW1vrBFmex58cSP7SfIHL+Eas1NwDhN1KgaJek0S5wDrrDN6BgX8QDpw8U6nKWGCE8enCKEKYbPw8F5u1aIrRJwLCLJkjAoKPBUk19xE2pFXppbkWXGoHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721430; c=relaxed/simple;
	bh=h7uyfoS1z19c5xgZMNZnS6LSlms9cXgN1TclDqbvNNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH+KubqfAxdZU/OmgaiBb8hgrBdRbHD7ujDTZGN4qj1yWV8rtHvYH+IK9P8ImZylm3z788jgZ992vk/5/Sf3Ub1PmkvcomN/n3HXzyNX2ylOumg0Av3PN2NeWcKnI5ZvAsWpUNe7XGvwJO4NDfHTu2iOZscgjSmnStjbT4e7xDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktTgkeKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktTgkeKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F2DC116C6;
	Tue,  6 Jan 2026 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721430;
	bh=h7uyfoS1z19c5xgZMNZnS6LSlms9cXgN1TclDqbvNNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktTgkeKUJA9tnGbzeY5p8oCp41rJ83vh3yRwKoac88T8RaKDuyH5V2cjWpkbJPLDH
	 LbuvwpuprrdObcVVJ4gO/31Y+I+jUJ++6lxha/e6xluj2p7vTyI635JcDBPu2HjxuU
	 FZeiDOYzaZGJBLW6sbLkXUttcI1wobIZqKe2M55o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 6.12 535/567] wifi: mt76: mt7925: fix CLC command timeout when suspend/resume
Date: Tue,  6 Jan 2026 18:05:17 +0100
Message-ID: <20260106170511.190618560@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit a0f721b8d986b62b4de316444f2b2e356d17e3b5 ]

When enter suspend/resume while in a connected state, the upper layer
will trigger disconnection before entering suspend, and at the same time,
it will trigger regd_notifier() and update CLC, causing the CLC event to
not be received due to suspend, resulting in a command timeout.

Therefore, the update of CLC is postponed until resume, to ensure data
consistency and avoid the occurrence of command timeout.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/bab00a2805d0533fd8beaa059222659858a9dcb5.1735910455.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   20 +++++++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |    3 +++
 3 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -59,6 +59,18 @@ static int mt7925_thermal_init(struct mt
 						       mt7925_hwmon_groups);
 	return PTR_ERR_OR_ZERO(hwmon);
 }
+
+void mt7925_regd_update(struct mt792x_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct ieee80211_hw *hw = mdev->hw;
+
+	mt7925_mcu_set_clc(dev, mdev->alpha2, dev->country_ie_env);
+	mt7925_mcu_set_channel_domain(hw->priv);
+	mt7925_set_tx_sar_pwr(hw, NULL);
+}
+EXPORT_SYMBOL_GPL(mt7925_regd_update);
+
 static void
 mt7925_regd_notifier(struct wiphy *wiphy,
 		     struct regulatory_request *req)
@@ -66,6 +78,7 @@ mt7925_regd_notifier(struct wiphy *wiphy
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	struct mt76_dev *mdev = &dev->mt76;
+	struct mt76_connac_pm *pm = &dev->pm;
 
 	/* allow world regdom at the first boot only */
 	if (!memcmp(req->alpha2, "00", 2) &&
@@ -81,11 +94,12 @@ mt7925_regd_notifier(struct wiphy *wiphy
 	mdev->region = req->dfs_region;
 	dev->country_ie_env = req->country_ie_env;
 
+	if (pm->suspended)
+		return;
+
 	dev->regd_in_progress = true;
 	mt792x_mutex_acquire(dev);
-	mt7925_mcu_set_clc(dev, req->alpha2, req->country_ie_env);
-	mt7925_mcu_set_channel_domain(hw->priv);
-	mt7925_set_tx_sar_pwr(hw, NULL);
+	mt7925_regd_update(dev);
 	mt792x_mutex_release(dev);
 	dev->regd_in_progress = false;
 	wake_up(&dev->wait);
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -218,6 +218,7 @@ int mt7925_mcu_chip_config(struct mt792x
 int mt7925_mcu_set_rxfilter(struct mt792x_dev *dev, u32 fif,
 			    u8 bit_op, u32 bit_map);
 
+void mt7925_regd_update(struct mt792x_dev *dev);
 int mt7925_mac_init(struct mt792x_dev *dev);
 int mt7925_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -554,11 +554,14 @@ static int mt7925_pci_resume(struct devi
 	local_bh_enable();
 
 	err = mt76_connac_mcu_set_hif_suspend(mdev, false);
+	if (err < 0)
+		goto failed;
 
 	/* restore previous ds setting */
 	if (!pm->ds_enable)
 		mt7925_mcu_set_deep_sleep(dev, false);
 
+	mt7925_regd_update(dev);
 failed:
 	pm->suspended = false;
 


