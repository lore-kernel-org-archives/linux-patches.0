Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B681E89C;
	Tue, 27 May 2025 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366674; cv=none; b=lWADGcbvEIj1Q9oND602h0iSk4vnv90FOZ8DQ2AXHWMoM+6A1EhKyDNAX63+maKWjB/8+K9hb1N2ZkP9REWBJrIUFRz94xt6jELnPtyImMB84TQwzS8aSgr7gvSH8w9H++VvAlaeZktPsxlI5czqnfmDmWqVLz7heJE4aO2r2Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366674; c=relaxed/simple;
	bh=/JeT/8e0Imz6O7qt/Rvyrb+3tYXpCH9rYO8QS3Z0+QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovOg325Pobe+Y6TkqzsjYsCNikUsKggealx7Z/new7CTwrVOPdmQKxYUSxa1wVD2jUTyl7/p3bQedaTcvyG4f5i5a3Wyjhuvj8cweXeVzNziIuFtADqf2d8MotXvXiBd1teVxKdBzS5TWe5JYUo2KWQYwVw+vBS2bgf5rNYu1Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDiymfLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDiymfLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF79BC4CEE9;
	Tue, 27 May 2025 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366674;
	bh=/JeT/8e0Imz6O7qt/Rvyrb+3tYXpCH9rYO8QS3Z0+QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDiymfLC25BNzGRQoyMJXh8YDpiLaP4DvlES7H5A1O5ImxrHiZFx9YRVTiZYblSZE
	 rbaPb2MUcke9bX3hLDpd4m/BlX9Qch3KHWGmdkCGEZrsNCyw7k36Horj/6ZwDxx8Ei
	 1IEkZ/Jz9GJ5NxgpB8EzInldDfGTcC5edQdqjnm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 117/783] wifi: mt76: mt7996: use the correct vif link for scanning/roc
Date: Tue, 27 May 2025 18:18:34 +0200
Message-ID: <20250527162517.913482213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 13b4c81083cc4b59fb639a511c0a9a7c38efde7e ]

Use the newly added offchannel_link pointer in vif data

Link: https://patch.msgid.link/20250311103646.43346-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 40 +++++++++++++------
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  1 +
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 019c925ae600e..88f9d9059d5f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -832,7 +832,8 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	u8 band_idx = (info->hw_queue & MT_TX_HW_QUEUE_PHY) >> 2;
 	u8 p_fmt, q_idx, omac_idx = 0, wmm_idx = 0;
 	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
-	struct mt76_vif_link *mvif;
+	struct mt76_vif_link *mlink = NULL;
+	struct mt7996_vif *mvif;
 	u16 tx_count = 15;
 	u32 val;
 	bool inband_disc = !!(changed & (BSS_CHANGED_UNSOL_BCAST_PROBE_RESP |
@@ -840,11 +841,18 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	bool beacon = !!(changed & (BSS_CHANGED_BEACON |
 				    BSS_CHANGED_BEACON_ENABLED)) && (!inband_disc);
 
-	mvif = vif ? (struct mt76_vif_link *)vif->drv_priv : NULL;
-	if (mvif) {
-		omac_idx = mvif->omac_idx;
-		wmm_idx = mvif->wmm_idx;
-		band_idx = mvif->band_idx;
+	if (vif) {
+		mvif = (struct mt7996_vif *)vif->drv_priv;
+		if (wcid->offchannel)
+			mlink = rcu_dereference(mvif->mt76.offchannel_link);
+		if (!mlink)
+			mlink = &mvif->deflink.mt76;
+	}
+
+	if (mlink) {
+		omac_idx = mlink->omac_idx;
+		wmm_idx = mlink->wmm_idx;
+		band_idx = mlink->band_idx;
 	}
 
 	if (inband_disc) {
@@ -910,13 +918,13 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			     is_multicast_ether_addr(hdr->addr1);
 		u8 idx = MT7996_BASIC_RATES_TBL;
 
-		if (mvif) {
-			if (mcast && mvif->mcast_rates_idx)
-				idx = mvif->mcast_rates_idx;
-			else if (beacon && mvif->beacon_rates_idx)
-				idx = mvif->beacon_rates_idx;
+		if (mlink) {
+			if (mcast && mlink->mcast_rates_idx)
+				idx = mlink->mcast_rates_idx;
+			else if (beacon && mlink->beacon_rates_idx)
+				idx = mlink->beacon_rates_idx;
 			else
-				idx = mvif->basic_rates_idx;
+				idx = mlink->basic_rates_idx;
 		}
 
 		val = FIELD_PREP(MT_TXD6_TX_RATE, idx) | MT_TXD6_FIXED_BW;
@@ -984,8 +992,14 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 
 	if (vif) {
 		struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+		struct mt76_vif_link *mlink = NULL;
+
+		if (wcid->offchannel)
+			mlink = rcu_dereference(mvif->mt76.offchannel_link);
+		if (!mlink)
+			mlink = &mvif->deflink.mt76;
 
-		txp->fw.bss_idx = mvif->deflink.mt76.idx;
+		txp->fw.bss_idx = mlink->idx;
 	}
 
 	txp->fw.token = cpu_to_le16(id);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 980a059b3b38f..b01cc7ef47999 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -249,6 +249,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	mlink->band_idx = band_idx;
 	mlink->wmm_idx = vif->type == NL80211_IFTYPE_AP ? 0 : 3;
 	mlink->wcid = &link->sta.wcid;
+	mlink->wcid->offchannel = mlink->offchannel;
 
 	ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
 	if (ret)
-- 
2.39.5



