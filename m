Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293C52F998D;
	Mon, 13 Oct 2025 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369771; cv=none; b=Ofs8Ik+gQ7XQEccdk7N/4hAW8wDuymxMYd+2KDPtgYnCCQwawVFW4M0fppwvQcX63NGpMQkHW060VpxN39X4+k19tktf90t/OsRgIlFn8OGgriGxNDAqZRBqjmX1ddcDn4AN9MygHMS4KLi83zXRVnGiwFiXuMj1JldxN9Kg6Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369771; c=relaxed/simple;
	bh=pvQ8KeFyNtkbbaB5v+nrPUku7mxp+qqWE1YGujxVzK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2+BAUNyZTQFi0AKmuUG1ycbQXRgktfv6QTi7gpkLewFphFFrGzA7iS7CbhdUmzHNT4RfLCk5P9ZbtgPaDWUfBIYsTnSfuzx/gkosWfJWEujCOug9ZF25o2LBPDiINRP+NXf0jPUa8vnM1iXe6PZ6dN/V1B6cB7S55vtf7mgMHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLTvX5hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLTvX5hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F17C4CEE7;
	Mon, 13 Oct 2025 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369771;
	bh=pvQ8KeFyNtkbbaB5v+nrPUku7mxp+qqWE1YGujxVzK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLTvX5hcAi36qnRGSAUsPDfW3opTXquW4dQ/WddEp8TRcNueg7Xm8t8CqyEYZa0NW
	 HiwsEq9QYao1nMzwsizhzXu5r+abahCtWNyefeNkQSaInJXXkudPsSha2VbWTPGoU6
	 e+X4c9/bUPB5OBQ5z/RrylPtpQKRhURxaPEGqdoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 362/563] wifi: mt76: mt7996: remove redundant per-phy mac80211 calls during restart
Date: Mon, 13 Oct 2025 16:43:43 +0200
Message-ID: <20251013144424.393525078@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0a5df0ec47f7edc04957925a9644101682041d27 ]

There is only one wiphy, so extra calls must be removed.
For calls that need to remain per-wiphy, use mt7996_for_each_phy

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20250915075910.47558-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 137 +++++-------------
 1 file changed, 35 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b3fcca9bbb958..28477702c18b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1766,13 +1766,10 @@ void mt7996_tx_token_put(struct mt7996_dev *dev)
 static int
 mt7996_mac_restart(struct mt7996_dev *dev)
 {
-	struct mt7996_phy *phy2, *phy3;
 	struct mt76_dev *mdev = &dev->mt76;
+	struct mt7996_phy *phy;
 	int i, ret;
 
-	phy2 = mt7996_phy2(dev);
-	phy3 = mt7996_phy3(dev);
-
 	if (dev->hif2) {
 		mt76_wr(dev, MT_INT1_MASK_CSR, 0x0);
 		mt76_wr(dev, MT_INT1_SOURCE_CSR, ~0);
@@ -1784,20 +1781,14 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 			mt76_wr(dev, MT_PCIE1_MAC_INT_ENABLE, 0x0);
 	}
 
-	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
+	mt7996_for_each_phy(dev, phy)
+		set_bit(MT76_RESET, &phy->mt76->state);
 	wake_up(&dev->mt76.mcu.wait);
-	if (phy2)
-		set_bit(MT76_RESET, &phy2->mt76->state);
-	if (phy3)
-		set_bit(MT76_RESET, &phy3->mt76->state);
 
 	/* lock/unlock all queues to ensure that no tx is pending */
-	mt76_txq_schedule_all(&dev->mphy);
-	if (phy2)
-		mt76_txq_schedule_all(phy2->mt76);
-	if (phy3)
-		mt76_txq_schedule_all(phy3->mt76);
+	mt7996_for_each_phy(dev, phy)
+		mt76_txq_schedule_all(phy->mt76);
 
 	/* disable all tx/rx napi */
 	mt76_worker_disable(&dev->mt76.tx_worker);
@@ -1855,36 +1846,25 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 		goto out;
 
 	mt7996_mac_init(dev);
-	mt7996_init_txpower(&dev->phy);
-	mt7996_init_txpower(phy2);
-	mt7996_init_txpower(phy3);
+	mt7996_for_each_phy(dev, phy)
+		mt7996_init_txpower(phy);
 	ret = mt7996_txbf_init(dev);
+	if (ret)
+		goto out;
 
-	if (test_bit(MT76_STATE_RUNNING, &dev->mphy.state)) {
-		ret = mt7996_run(&dev->phy);
-		if (ret)
-			goto out;
-	}
-
-	if (phy2 && test_bit(MT76_STATE_RUNNING, &phy2->mt76->state)) {
-		ret = mt7996_run(phy2);
-		if (ret)
-			goto out;
-	}
+	mt7996_for_each_phy(dev, phy) {
+		if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
+			continue;
 
-	if (phy3 && test_bit(MT76_STATE_RUNNING, &phy3->mt76->state)) {
-		ret = mt7996_run(phy3);
+		ret = mt7996_run(&dev->phy);
 		if (ret)
 			goto out;
 	}
 
 out:
 	/* reset done */
-	clear_bit(MT76_RESET, &dev->mphy.state);
-	if (phy2)
-		clear_bit(MT76_RESET, &phy2->mt76->state);
-	if (phy3)
-		clear_bit(MT76_RESET, &phy3->mt76->state);
+	mt7996_for_each_phy(dev, phy)
+		clear_bit(MT76_RESET, &phy->mt76->state);
 
 	napi_enable(&dev->mt76.tx_napi);
 	local_bh_disable();
@@ -1898,26 +1878,18 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 static void
 mt7996_mac_full_reset(struct mt7996_dev *dev)
 {
-	struct mt7996_phy *phy2, *phy3;
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct mt7996_phy *phy;
 	int i;
 
-	phy2 = mt7996_phy2(dev);
-	phy3 = mt7996_phy3(dev);
 	dev->recovery.hw_full_reset = true;
 
 	wake_up(&dev->mt76.mcu.wait);
-	ieee80211_stop_queues(mt76_hw(dev));
-	if (phy2)
-		ieee80211_stop_queues(phy2->mt76->hw);
-	if (phy3)
-		ieee80211_stop_queues(phy3->mt76->hw);
+	ieee80211_stop_queues(hw);
 
 	cancel_work_sync(&dev->wed_rro.work);
-	cancel_delayed_work_sync(&dev->mphy.mac_work);
-	if (phy2)
-		cancel_delayed_work_sync(&phy2->mt76->mac_work);
-	if (phy3)
-		cancel_delayed_work_sync(&phy3->mt76->mac_work);
+	mt7996_for_each_phy(dev, phy)
+		cancel_delayed_work_sync(&phy->mt76->mac_work);
 
 	mutex_lock(&dev->mt76.mutex);
 	for (i = 0; i < 10; i++) {
@@ -1930,40 +1902,23 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 		dev_err(dev->mt76.dev, "chip full reset failed\n");
 
 	ieee80211_restart_hw(mt76_hw(dev));
-	if (phy2)
-		ieee80211_restart_hw(phy2->mt76->hw);
-	if (phy3)
-		ieee80211_restart_hw(phy3->mt76->hw);
-
 	ieee80211_wake_queues(mt76_hw(dev));
-	if (phy2)
-		ieee80211_wake_queues(phy2->mt76->hw);
-	if (phy3)
-		ieee80211_wake_queues(phy3->mt76->hw);
 
 	dev->recovery.hw_full_reset = false;
-	ieee80211_queue_delayed_work(mt76_hw(dev),
-				     &dev->mphy.mac_work,
-				     MT7996_WATCHDOG_TIME);
-	if (phy2)
-		ieee80211_queue_delayed_work(phy2->mt76->hw,
-					     &phy2->mt76->mac_work,
-					     MT7996_WATCHDOG_TIME);
-	if (phy3)
-		ieee80211_queue_delayed_work(phy3->mt76->hw,
-					     &phy3->mt76->mac_work,
+	mt7996_for_each_phy(dev, phy)
+		ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 					     MT7996_WATCHDOG_TIME);
 }
 
 void mt7996_mac_reset_work(struct work_struct *work)
 {
-	struct mt7996_phy *phy2, *phy3;
+	struct ieee80211_hw *hw;
 	struct mt7996_dev *dev;
+	struct mt7996_phy *phy;
 	int i;
 
 	dev = container_of(work, struct mt7996_dev, reset_work);
-	phy2 = mt7996_phy2(dev);
-	phy3 = mt7996_phy3(dev);
+	hw = mt76_hw(dev);
 
 	/* chip full reset */
 	if (dev->recovery.restart) {
@@ -1994,7 +1949,7 @@ void mt7996_mac_reset_work(struct work_struct *work)
 		return;
 
 	dev_info(dev->mt76.dev,"\n%s L1 SER recovery start.",
-		 wiphy_name(dev->mt76.hw->wiphy));
+		 wiphy_name(hw->wiphy));
 
 	if (mtk_wed_device_active(&dev->mt76.mmio.wed_hif2))
 		mtk_wed_device_stop(&dev->mt76.mmio.wed_hif2);
@@ -2003,25 +1958,17 @@ void mt7996_mac_reset_work(struct work_struct *work)
 		mtk_wed_device_stop(&dev->mt76.mmio.wed);
 
 	ieee80211_stop_queues(mt76_hw(dev));
-	if (phy2)
-		ieee80211_stop_queues(phy2->mt76->hw);
-	if (phy3)
-		ieee80211_stop_queues(phy3->mt76->hw);
 
 	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 
 	cancel_work_sync(&dev->wed_rro.work);
-	cancel_delayed_work_sync(&dev->mphy.mac_work);
-	if (phy2) {
-		set_bit(MT76_RESET, &phy2->mt76->state);
-		cancel_delayed_work_sync(&phy2->mt76->mac_work);
-	}
-	if (phy3) {
-		set_bit(MT76_RESET, &phy3->mt76->state);
-		cancel_delayed_work_sync(&phy3->mt76->mac_work);
+	mt7996_for_each_phy(dev, phy) {
+		set_bit(MT76_RESET, &phy->mt76->state);
+		cancel_delayed_work_sync(&phy->mt76->mac_work);
 	}
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt76_for_each_q_rx(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
@@ -2074,11 +2021,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	}
 
 	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
-	clear_bit(MT76_RESET, &dev->mphy.state);
-	if (phy2)
-		clear_bit(MT76_RESET, &phy2->mt76->state);
-	if (phy3)
-		clear_bit(MT76_RESET, &phy3->mt76->state);
+	mt7996_for_each_phy(dev, phy)
+		clear_bit(MT76_RESET, &phy->mt76->state);
 
 	mt76_for_each_q_rx(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
@@ -2100,25 +2044,14 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	napi_schedule(&dev->mt76.tx_napi);
 	local_bh_enable();
 
-	ieee80211_wake_queues(mt76_hw(dev));
-	if (phy2)
-		ieee80211_wake_queues(phy2->mt76->hw);
-	if (phy3)
-		ieee80211_wake_queues(phy3->mt76->hw);
+	ieee80211_wake_queues(hw);
 
 	mutex_unlock(&dev->mt76.mutex);
 
 	mt7996_update_beacons(dev);
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
-				     MT7996_WATCHDOG_TIME);
-	if (phy2)
-		ieee80211_queue_delayed_work(phy2->mt76->hw,
-					     &phy2->mt76->mac_work,
-					     MT7996_WATCHDOG_TIME);
-	if (phy3)
-		ieee80211_queue_delayed_work(phy3->mt76->hw,
-					     &phy3->mt76->mac_work,
+	mt7996_for_each_phy(dev, phy)
+		ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 					     MT7996_WATCHDOG_TIME);
 	dev_info(dev->mt76.dev,"\n%s L1 SER recovery completed.",
 		 wiphy_name(dev->mt76.hw->wiphy));
-- 
2.51.0



