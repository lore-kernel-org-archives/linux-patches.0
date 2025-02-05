Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807B9282EE;
	Wed,  5 Feb 2025 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765157; cv=none; b=bIRP+xW1+es5zbgL4Ht1/OX6GyF8Il4ABFJs7Gno+qSNMGWLe2JTL5d5qJt0qGRwPTQS/266IV66J27nfjlCCYzKu58ehsICLEW4LkpHapsYGQZ6fZQiVEceufd5Gn/C8i4S62w0OJ3Dr/J86N5XWdZv1Xq0fQSEM1RAyP6lksI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765157; c=relaxed/simple;
	bh=2v1YcY2NPulDzTPwmy4TN1f4sAAnuah9v7hc8Zi6VM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYBxV9jUNIAZZKDYO0/ejlMOCw8U7rVy7nk+Bji2PxfQzIkwoycTx/fgZvqYa34G0b8V/zjiXN26ZvPar/3+EQXZXOz4HHa1xbhmLRm3eUC5xyuL0D0zHyP95byfcIebqlOAWnRkFmRqUk67G91CYQL0ntCps/zgu7mQ6Z4J/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBpPOCHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBpPOCHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AC8C4CED6;
	Wed,  5 Feb 2025 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765156;
	bh=2v1YcY2NPulDzTPwmy4TN1f4sAAnuah9v7hc8Zi6VM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBpPOCHOObMcowxCAR30aJTYQUzvuGRat7ZQv67V9DHv4kkFjj55hIQ1CZwsOh7nW
	 S9lMJvHF2WjJOP8BRvU3JNUOVBviszrbR1gC/iYpmO7b9wfTkjljyfUsisLzIsJZZz
	 ehJaoDIdaJhF/ktzyD/8nGaBParzMwG+WOMgAEls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/590] wifi: mt76: mt7925: Cleanup MLO settings post-disconnection
Date: Wed,  5 Feb 2025 14:39:10 +0100
Message-ID: <20250205134502.738593544@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 816161051a039eeb1226fc85e2b38389f508906c ]

Clean up MLO settings after disconnection.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-16-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 37 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  4 +-
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  2 +-
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a4ffa34d58a41..116b6980c7335 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1149,8 +1149,7 @@ static void mt7925_mac_link_sta_remove(struct mt76_dev *mdev,
 		struct mt792x_bss_conf *mconf;
 
 		mconf = mt792x_link_conf_to_mconf(link_conf);
-		mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx, link_conf,
-					link_sta, false);
+		mt792x_mac_link_bss_remove(dev, mconf, mlink);
 	}
 
 	spin_lock_bh(&mdev->sta_poll_lock);
@@ -1208,12 +1207,46 @@ void mt7925_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 {
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
+	struct {
+		struct {
+			u8 omac_idx;
+			u8 band_idx;
+			__le16 pad;
+		} __packed hdr;
+		struct req_tlv {
+			__le16 tag;
+			__le16 len;
+			u8 active;
+			u8 link_idx; /* hw link idx */
+			u8 omac_addr[ETH_ALEN];
+		} __packed tlv;
+	} dev_req = {
+		.hdr = {
+			.omac_idx = 0,
+			.band_idx = 0,
+		},
+		.tlv = {
+			.tag = cpu_to_le16(DEV_INFO_ACTIVE),
+			.len = cpu_to_le16(sizeof(struct req_tlv)),
+			.active = true,
+		},
+	};
 	unsigned long rem;
 
 	rem = ieee80211_vif_is_mld(vif) ? msta->valid_links : BIT(0);
 
 	mt7925_mac_sta_remove_links(dev, vif, sta, rem);
 
+	if (ieee80211_vif_is_mld(vif)) {
+		mt7925_mcu_set_dbdc(&dev->mphy, false);
+
+		/* recovery omac address for the legacy interface */
+		memcpy(dev_req.tlv.omac_addr, vif->addr, ETH_ALEN);
+		mt76_mcu_send_msg(mdev, MCU_UNI_CMD(DEV_INFO_UPDATE),
+				  &dev_req, sizeof(dev_req), true);
+
+	}
+
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e4c0f234aeed2..c7dd263446c9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2660,7 +2660,7 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 				     MCU_UNI_CMD(BSS_INFO_UPDATE), true);
 }
 
-int mt7925_mcu_set_dbdc(struct mt76_phy *phy)
+int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable)
 {
 	struct mt76_dev *mdev = phy->dev;
 
@@ -2680,7 +2680,7 @@ int mt7925_mcu_set_dbdc(struct mt76_phy *phy)
 	tlv = mt76_connac_mcu_add_tlv(skb, UNI_MBMC_SETTING, sizeof(*conf));
 	conf = (struct mbmc_conf_tlv *)tlv;
 
-	conf->mbmc_en = 1;
+	conf->mbmc_en = enable;
 	conf->band = 0; /* unused */
 
 	err = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SET_DBDC_PARMS),
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 31bb8ed2ec513..fe6a613ba0088 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -616,7 +616,7 @@ mt7925_mcu_get_cipher(int cipher)
 	}
 }
 
-int mt7925_mcu_set_dbdc(struct mt76_phy *phy);
+int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable);
 int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		       struct ieee80211_scan_request *scan_req);
 int mt7925_mcu_cancel_hw_scan(struct mt76_phy *phy,
-- 
2.39.5



