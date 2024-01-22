Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3C713398C;
	Tue, 23 Jan 2024 00:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969312; cv=none; b=OHcNkJTaGuQVgqRdHI+nlGpUmVzK0kgsOOEtS3FkgdHbuFoSOuWoPlvAy4Ac3GQRJgIdQw/+LUDbgwmcImEBWsG9Y0Qh8jqPaLtZmVMuFuy2PrDeMYX6gKvaffgIgxRT599Q0SsTslHBWqtpHnc+JAynSuTLcQCU6GEDa5USXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969312; c=relaxed/simple;
	bh=qXulEY4tVRSDodRZ1JiZipsNhEEeuxUVOGinBXyu/6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE1xqyIlOZ7+u7KQqPqL+qUCfxgVy6pVIvUCxs+YimM1bIa/+Ksa/Qxrr0hRLhWksTrz2fDDL5KgA9+28iuywduj65kGBG8M3FqYZuhP6MsH44jLbMR9hVZwRTJu2J0k7xqe546rtr6lG1GqVC/dzaOzgZlqS1MmddRHWvdeoPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N58LNmGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N58LNmGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0445C43399;
	Tue, 23 Jan 2024 00:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969312;
	bh=qXulEY4tVRSDodRZ1JiZipsNhEEeuxUVOGinBXyu/6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N58LNmGoES3JzJ1t4++0T0UcYhk5/tVzibNB9fMg9PR/fV4r1lW8aNLeooo16sJKf
	 qb/Z+/zQh0cn/jM/1IrZI8BwJMVOdvM3HkQpwNEs0LkgTxN0j1n4JdcbI9eg6/dsVo
	 bKQ+l1u2pmJfAETy4bQdw+ccnuaE36VmxQUpVdPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 167/641] wifi: mt76: mt7921: fix CLC command timeout when suspend/resume
Date: Mon, 22 Jan 2024 15:51:11 -0800
Message-ID: <20240122235823.240393314@linuxfoundation.org>
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

[ Upstream commit d0a2bc5fe712217d2c73822ae75fd4e69a15cb2c ]

When enter suspend/resume while in a connected state, the upper layer
will trigger disconnection before entering suspend, and at the same time,
it will trigger regd_notifier() and update CLC, causing the CLC event to
not be received due to suspend, resulting in a command timeout.

Therefore, the update of CLC is postponed until resume, to ensure data
consistency and avoid the occurrence of command timeout.

Fixes: 4fc8df50fd41 ("wifi: mt76: mt7921: get regulatory information from the clc event")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/init.c  | 23 +++++++++++++++----
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  1 +
 .../net/wireless/mediatek/mt76/mt7921/pci.c   |  3 +++
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 7d6a9d746011..48433c6d5e7d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -110,24 +110,37 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 	}
 }
 
+void mt7921_regd_update(struct mt792x_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct ieee80211_hw *hw = mdev->hw;
+	struct wiphy *wiphy = hw->wiphy;
+
+	mt7921_mcu_set_clc(dev, mdev->alpha2, dev->country_ie_env);
+	mt7921_regd_channel_update(wiphy, dev);
+	mt76_connac_mcu_set_channel_domain(hw->priv);
+	mt7921_set_tx_sar_pwr(hw, NULL);
+}
+EXPORT_SYMBOL_GPL(mt7921_regd_update);
+
 static void
 mt7921_regd_notifier(struct wiphy *wiphy,
 		     struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+	struct mt76_connac_pm *pm = &dev->pm;
 
 	memcpy(dev->mt76.alpha2, request->alpha2, sizeof(dev->mt76.alpha2));
 	dev->mt76.region = request->dfs_region;
 	dev->country_ie_env = request->country_ie_env;
 
+	if (pm->suspended)
+		return;
+
 	mt792x_mutex_acquire(dev);
-	mt7921_mcu_set_clc(dev, request->alpha2, request->country_ie_env);
-	mt76_connac_mcu_set_channel_domain(hw->priv);
-	mt7921_set_tx_sar_pwr(hw, NULL);
+	mt7921_regd_update(dev);
 	mt792x_mutex_release(dev);
-
-	mt7921_regd_channel_update(wiphy, dev);
 }
 
 int mt7921_mac_init(struct mt792x_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index f28621121927..5c4cc370e6ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -233,6 +233,7 @@ mt7921_l1_rmw(struct mt792x_dev *dev, u32 addr, u32 mask, u32 val)
 #define mt7921_l1_set(dev, addr, val)	mt7921_l1_rmw(dev, addr, 0, val)
 #define mt7921_l1_clear(dev, addr, val)	mt7921_l1_rmw(dev, addr, val, 0)
 
+void mt7921_regd_update(struct mt792x_dev *dev);
 int mt7921_mac_init(struct mt792x_dev *dev);
 bool mt7921_mac_wtbl_update(struct mt792x_dev *dev, int idx, u32 mask);
 int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index f04e7095e181..42fd456eb6fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -507,6 +507,9 @@ static int mt7921_pci_resume(struct device *device)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
 
 	err = mt76_connac_mcu_set_hif_suspend(mdev, false);
+
+	mt7921_regd_update(dev);
+
 failed:
 	pm->suspended = false;
 
-- 
2.43.0



