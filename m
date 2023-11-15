Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8851F3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJRZ8Y4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351A3C433CB;
	Wed, 15 Nov 2023 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076130;
	bh=oz/wJiHbBHiOmgN23B6frB4IwoSHpCXC5FEHgtjM9pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJRZ8Y4HyIukyAteMW5gQdCeckZG4CAmtjChECopJa7gYjl096Jj0i0cN63TZJE1S
	 UNUVI5RNsc28spQP+BsX9semJVa2LwqO7c5dDMYkKW8skwA1MiVXHCA6wjFlE8HmpM
	 Yc4DDqI2mbWXps9ASLJp9mqz7lkgwwTGYKqvmeWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 093/550] wifi: mt76: fix potential memory leak of beacon commands
Date: Wed, 15 Nov 2023 14:11:17 -0500
Message-ID: <20231115191607.169669986@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Jiao <Bo.Jiao@mediatek.com>

[ Upstream commit d6a2f91741d9f43b31cb16c82da37f35117a6d1c ]

Fix potential memory leak when setting beacon and inband discovery
commands.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 10 ++++++++--
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 4278eacf43845..411157e93865b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1922,8 +1922,10 @@ mt7915_mcu_add_inband_discov(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 		skb = ieee80211_get_unsol_bcast_probe_resp_tmpl(hw, vif);
 	}
 
-	if (!skb)
+	if (!skb) {
+		dev_kfree_skb(rskb);
 		return -EINVAL;
+	}
 
 	info = IEEE80211_SKB_CB(skb);
 	info->control.vif = vif;
@@ -1935,6 +1937,7 @@ mt7915_mcu_add_inband_discov(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
 	if (skb->len > MT7915_MAX_BEACON_SIZE) {
 		dev_err(dev->mt76.dev, "inband discovery size limit exceed\n");
+		dev_kfree_skb(rskb);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1991,11 +1994,14 @@ int mt7915_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 
 	skb = ieee80211_beacon_get_template(hw, vif, &offs, 0);
-	if (!skb)
+	if (!skb) {
+		dev_kfree_skb(rskb);
 		return -EINVAL;
+	}
 
 	if (skb->len > MT7915_MAX_BEACON_SIZE) {
 		dev_err(dev->mt76.dev, "Bcn size limit exceed\n");
+		dev_kfree_skb(rskb);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index ac06450a79512..60cc3fdca9463 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1942,11 +1942,14 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw,
 		return PTR_ERR(rskb);
 
 	skb = ieee80211_beacon_get_template(hw, vif, &offs, 0);
-	if (!skb)
+	if (!skb) {
+		dev_kfree_skb(rskb);
 		return -EINVAL;
+	}
 
 	if (skb->len > MT7996_MAX_BEACON_SIZE) {
 		dev_err(dev->mt76.dev, "Bcn size limit exceed\n");
+		dev_kfree_skb(rskb);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2006,11 +2009,14 @@ int mt7996_mcu_beacon_inband_discov(struct mt7996_dev *dev,
 		skb = ieee80211_get_unsol_bcast_probe_resp_tmpl(hw, vif);
 	}
 
-	if (!skb)
+	if (!skb) {
+		dev_kfree_skb(rskb);
 		return -EINVAL;
+	}
 
 	if (skb->len > MT7996_MAX_BEACON_SIZE) {
 		dev_err(dev->mt76.dev, "inband discovery size limit exceed\n");
+		dev_kfree_skb(rskb);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
-- 
2.42.0



