Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86C6202F71;
	Sat, 12 Sep 2026 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216761; cv=none; b=oQz8VWqUjO9espCOQSlRVlHPFCj7qYdh/y8HQcq7BcC/pMA7kgPiv6l3wcbw9kV6ifeQiVelnjmjZU73RWWeKWY6kH1daIW9rOpQa4r75yt8D1DJUVutw3dKIHZtF4GGCIg0zopnBgUNVJMwq0PrxpUtQRuiNJKi0QnW2PXaGwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216761; c=relaxed/simple;
	bh=W3MdaDQKR4IazipolvFallFDPEJLT/vXENW8Pzi/M7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNI6uAqq+DA+gzbjnZwGaTJYd+XkqeBP5Q1eFKv7bb0uVoQ8F+KAuh8WFTL+k8BtTzhOBQ27akLnpcGhafkd6i5JX0H0GcuSe315Ms/OY4q8V7SHtxK3bFsVMIjwLTNLzzlGhoh3H4ds+l6X73Coo9JhQrT1fPHaZXPBFJFKElg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xumYAAZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xumYAAZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8371F000FF;
	Sat, 12 Sep 2026 12:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216759;
	bh=/tZW9oFHwfNB9pPK4RYtz6IDKWVYZADuucoxl4Mu6nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xumYAAZ05ZDF0Iucu+Dw2TJ2tgYnY/EHe2865scfdspXmlyJd3n6ii1dcwdAg0sQS
	 Hk/k5YA55RimaYtl0BGbjIWBGFmLCWOdotiKNn9pCL1TLWO/TsTMnXlE+dfqgN8r+U
	 gC8d3TU3x9czqjlu4A3qwFLKg928V6vG4u4/N7rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eason Lai <Eason.Lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0803/1376] wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete
Date: Sat, 12 Sep 2026 08:53:49 +0200
Message-ID: <20260912065625.430288790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Eason Lai <Eason.Lai@mediatek.com>

[ Upstream commit 217f9e7bb02558759be9d9ecfe532e9708741c50 ]

A use-after-free issue occurs in mt76_rx_poll_complete due to a race
condition. The STA has already been removed, but the rx_status still
had a pointer to the wcid in the STA.

Set the links' wcid pointers to be NULL for a MLD in
mt7925_sta_pre_rcu_remove()

BUG: KASAN: invalid-access in mt76_rx_poll_complete+0x280/0x470
Call trace:
dump_backtrace+0xec/0x128
show_stack+0x18/0x28
dump_stack_lvl+0x40/0xc8
print_report+0x1b8/0x710
kasan_report+0xe0/0x144
do_bad_area+0x120/0x260
do_tag_check_fault+0x20/0x34
do_mem_abort+0x54/0xa8
el1_abort+0x3c/0x5c
el1h_64_sync_handler+0x40/0xcc
el1h_64_sync+0x7c/0x80
mt76_rx_poll_complete+0x280/0x470
mt76_dma_rx_poll+0x114/0x51c
mt792x_poll_rx+0x60/0xf8
napi_threaded_poll_loop+0xe0/0x450
napi_threaded_poll+0x80/0x9c
kthread+0x11c/0x158
ret_from_fork+0x10/0x20

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Eason Lai <Eason.Lai@mediatek.com>
Link: https://patch.msgid.link/20260701010654.956863-1-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 1dbc6d22b0666..626e68905ffa0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2165,6 +2165,40 @@ static void mt7925_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+static void mt7925_sta_pre_rcu_remove(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta)
+{
+	struct mt76_phy *phy = hw->priv;
+	struct mt76_dev *dev = phy->dev;
+	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
+
+	mutex_lock(&dev->mutex);
+	spin_lock_bh(&dev->status_lock);
+
+	if (ieee80211_vif_is_mld(vif)) {
+		struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
+		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+		unsigned long valid = mvif->valid_links;
+		struct mt792x_link_sta *mlink;
+		unsigned int link_id;
+
+		for_each_set_bit(link_id, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
+			mlink = mt792x_sta_to_link(msta, link_id);
+			if (!mlink || !mlink->wcid.sta)
+				continue;
+			if (mlink->wcid.idx < ARRAY_SIZE(dev->wcid))
+				rcu_assign_pointer(dev->wcid[mlink->wcid.idx],
+						   NULL);
+		}
+	} else {
+		rcu_assign_pointer(dev->wcid[wcid->idx], NULL);
+	}
+
+	spin_unlock_bh(&dev->status_lock);
+	mutex_unlock(&dev->mutex);
+}
+
 const struct ieee80211_ops mt7925_ops = {
 	.tx = mt792x_tx,
 	.start = mt7925_start,
@@ -2177,7 +2211,7 @@ const struct ieee80211_ops mt7925_ops = {
 	.start_ap = mt7925_start_ap,
 	.stop_ap = mt7925_stop_ap,
 	.sta_state = mt76_sta_state,
-	.sta_pre_rcu_remove = mt76_sta_pre_rcu_remove,
+	.sta_pre_rcu_remove = mt7925_sta_pre_rcu_remove,
 	.set_key = mt7925_set_key,
 	.sta_set_decap_offload = mt7925_sta_set_decap_offload,
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.53.0



