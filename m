Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF06373BF3;
	Sat, 12 Sep 2026 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200894; cv=none; b=r/mutPbk9So2cKkLX/oZkdA9NDUboxKaNt2xjZjj+ktX5I4DPzC9Ne1yAX3buqk4tzk4WwCPYBpeR6DdSuOqLm23PPz1D+RN/0TDr8IqWRP5pdnyS3YZ2JXKxGJfPVwrfQCvG0QmqBYsoXezxSXNW6qTFdBgQVW77KgVhmn2LeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200894; c=relaxed/simple;
	bh=xViZXJX5d7HYvrf2vl5VKE0zDfd5sAt1/eXfKa5CsDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jou7COyslrUQchgi7dpYkl8EMbd7EuD9QZTj+VI8fS43Oua/eYwJwQ03U9dOholYqV3a+l2+3yxlaLPPikTXveHEV0wxF6yGBbloOqechNLJmMwWNnEk5nBL2xCEuEq4JuAWs2/M7BEQyXgLIC3VwNyUkroUCF/N3ZG2Eg55CUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REjAI6TC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REjAI6TC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29831F00893;
	Sat, 12 Sep 2026 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200893;
	bh=g0JUrgTZHrXgxxt5e7WEPRs/40R3Z/5yXg4rH5l8UN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REjAI6TCic9c6dPW4QE/eM9cGiA+VsvLF1x90etWeAI7bIORgircilO0az8TGENhp
	 gqbPg7ntD9eS/mzE8sbicS5vBwNwxGhcsAv0B0TgQHzaDKHSdXA50iVlJjlST7DyKe
	 eKSFdjsd39w9apirQqsR26dIp2uOmjLuvlerIwE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eason Lai <Eason.Lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0867/1815] wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete
Date: Sat, 12 Sep 2026 08:43:37 +0200
Message-ID: <20260912065709.275952179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3beb2c1fbec9c..fd3dea043cbe7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2494,6 +2494,40 @@ static void mt7925_stop(struct ieee80211_hw *hw, bool suspend)
 	mt792x_stop(hw, suspend);
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
@@ -2506,7 +2540,7 @@ const struct ieee80211_ops mt7925_ops = {
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



