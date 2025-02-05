Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624513C9C4;
	Wed,  5 Feb 2025 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763952; cv=none; b=WzwWxItQMumrYneDz7LZ/Y71IiwO7sJ6tWY22Tan7KDBTlXSw3UayVL1Ph5X+9BDT3S1aX+fCUoPRqFshdiTSE2uMF3rF6xYQQez/CMJIcGsczJmiFWSHHW276CSnmHwLEjHukMUCNBaJT81vGYAI+KC0K8wks7oinboIouwRLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763952; c=relaxed/simple;
	bh=6kLiai8002sLc00HtPwNyufPBn4f0OEYnDBkTJcakso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOrNjMfzJkPYGbeoSYA03uJUd79ZU11oxhNzwwdL6eapni1Zdh5ZqoRTmUeCAdXflQS3Hr7d4FWRDyU3s+gjQCbeWFR0rZd8xG+ViQUfW3bqQotl2akTFiA5RZJp7e49Z4nij5Qse26sb5TLCW+/YhUnt+KPuW4sIx0qeL6TlZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFGDc5XW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFGDc5XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DDDC4CED1;
	Wed,  5 Feb 2025 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763952;
	bh=6kLiai8002sLc00HtPwNyufPBn4f0OEYnDBkTJcakso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFGDc5XW/unN1cIB6n84IH2JahQV0IEOaRgCidqmDrjTPxDISEPqUppLKsetlEB73
	 s6GnC4UjEq/Lto5komBxJ4yoZfghlkwne1p2F5+iGJbjaZSIfoCZL7k5mdQhOyvf1e
	 WvbjO0E8HFo3/G+Q6Ie+l/hhgwJtLopyyE/gsLps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/393] wifi: mt76: mt7915: improve hardware restart reliability
Date: Wed,  5 Feb 2025 14:40:41 +0100
Message-ID: <20250205134424.962896104@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 328e35c7bfc673cde5a3a453318d044f8f83b505 ]

- use reconfig_complete to restart mac_work / queues
- reset full wtbl after firmware init
- clear wcid and vif mask to avoid leak
- fix sta poll list corruption

Link: https://patch.msgid.link/20240827093011.18621-19-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: cd043bbba6f9 ("wifi: mt76: mt7915: fix omac index assignment after hardware reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 25 ++++++++++---------
 .../net/wireless/mediatek/mt76/mt7915/main.c  | 12 +++++++++
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |  2 ++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 675fbf40ecf75..55c52c2d97b09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1459,26 +1459,27 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
 		if (!mt7915_mac_restart(dev))
 			break;
 	}
-	mutex_unlock(&dev->mt76.mutex);
 
 	if (i == 10)
 		dev_err(dev->mt76.dev, "chip full reset failed\n");
 
-	ieee80211_restart_hw(mt76_hw(dev));
-	if (ext_phy)
-		ieee80211_restart_hw(ext_phy->hw);
+	spin_lock_bh(&dev->mt76.sta_poll_lock);
+	while (!list_empty(&dev->mt76.sta_poll_list))
+		list_del_init(dev->mt76.sta_poll_list.next);
+	spin_unlock_bh(&dev->mt76.sta_poll_lock);
 
-	ieee80211_wake_queues(mt76_hw(dev));
-	if (ext_phy)
-		ieee80211_wake_queues(ext_phy->hw);
+	memset(dev->mt76.wcid_mask, 0, sizeof(dev->mt76.wcid_mask));
+	dev->mt76.vif_mask = 0;
 
+	i = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7915_WTBL_STA);
+	dev->mt76.global_wcid.idx = i;
 	dev->recovery.hw_full_reset = false;
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
-				     MT7915_WATCHDOG_TIME);
+
+	mutex_unlock(&dev->mt76.mutex);
+
+	ieee80211_restart_hw(mt76_hw(dev));
 	if (ext_phy)
-		ieee80211_queue_delayed_work(ext_phy->hw,
-					     &ext_phy->mac_work,
-					     MT7915_WATCHDOG_TIME);
+		ieee80211_restart_hw(ext_phy->hw);
 }
 
 /* system error recovery */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d2429247c3b66..c312a0fa199ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1650,6 +1650,17 @@ mt7915_net_fill_forward_path(struct ieee80211_hw *hw,
 }
 #endif
 
+static void
+mt7915_reconfig_complete(struct ieee80211_hw *hw,
+			 enum ieee80211_reconfig_type reconfig_type)
+{
+	struct mt7915_phy *phy = mt7915_hw_phy(hw);
+
+	ieee80211_wake_queues(hw);
+	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
+				     MT7915_WATCHDOG_TIME);
+}
+
 const struct ieee80211_ops mt7915_ops = {
 	.tx = mt7915_tx,
 	.start = mt7915_start,
@@ -1704,4 +1715,5 @@ const struct ieee80211_ops mt7915_ops = {
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
 	.net_fill_forward_path = mt7915_net_fill_forward_path,
 #endif
+	.reconfig_complete = mt7915_reconfig_complete,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 5fba103bfd65d..f0226db2e57c7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2351,6 +2351,8 @@ int mt7915_mcu_init_firmware(struct mt7915_dev *dev)
 	if (ret)
 		return ret;
 
+	mt76_connac_mcu_del_wtbl_all(&dev->mt76);
+
 	if ((mtk_wed_device_active(&dev->mt76.mmio.wed) &&
 	     is_mt7915(&dev->mt76)) ||
 	    !mtk_wed_get_rx_capa(&dev->mt76.mmio.wed))
-- 
2.39.5



