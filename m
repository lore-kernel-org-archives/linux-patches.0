Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1F2164188;
	Tue, 23 Jan 2024 00:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970770; cv=none; b=HJSf8eR6PpuoDY7sieqmTZuvWZLmwq7+FhKmq+YGVCrFYf1Wq8eb6qMBR8eZBnf/QiHtlYgvCQtzwfAVrt8yb53DQef2omPt9s3a+ZhA5tT+wkNVYjgAJoDXd0kD8L72QhWbaU/3V8Gi5Kbf0RYQy4SJce+NlxH2eMbQ6rxpo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970770; c=relaxed/simple;
	bh=y3NcRCd/j7eYM6Kv6pF9CZSWzVTpb+TBG2BmAaPJoEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fucANiWAP1ohDB43G7tJq8wdz/SyX5eTx6dEO6BgIJaQBOkXYlZKA2VSH+i0N27pnlUh2po8u5+2znaEXeCcnqs9qEIzNHxUUKqrRiwwLqdiMvomeUQgj3wztP7mNG5QqYBvBtNf4mWjavrPnmB9r8QCaxV09+z+eWdQT2M7Yfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSpQd8ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSpQd8ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC829C43609;
	Tue, 23 Jan 2024 00:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970769;
	bh=y3NcRCd/j7eYM6Kv6pF9CZSWzVTpb+TBG2BmAaPJoEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSpQd8ear5KiF4x/7dqjTJYI6ty77JQYasBL2Gs5sOxu6ectA2nksTzC8ohgCrKMU
	 KCt/j4D+57PwfxNMNdmA9pYxALBxF94S4Dy6o99/ziSlxR7CUI4Mqv56LsWRlaxpJz
	 R0dOe4xfODenWRXq6e1oOsxFr4eJzoHmwiAx1ASY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhao <wang.zhao@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/417] wifi: mt76: mt7921s: fix workqueue problem causes STA association fail
Date: Mon, 22 Jan 2024 15:54:34 -0800
Message-ID: <20240122235755.385882515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhao <wang.zhao@mediatek.com>

[ Upstream commit 92184eae1d5ad804884e2c6e289d885b9e3194d1 ]

The ieee80211_queue_work function queues work into the mac80211
local->workqueue, which is widely used for mac80211 internal
work processes. In the mt76 driver, both the mt76-sido-status and
mt76-sdio-net threads enqueue workers to the workqueue with this
function. However, in some cases, when two workers are enqueued
to the workqueue almost simultaneously, the second worker may not
be scheduled immediately and may get stuck for a while.
This can cause timing issues. To avoid these timing
conflicts caused by worker scheduling, replace the worker
with an independent thread.

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Signed-off-by: Wang Zhao <wang.zhao@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h      |  3 +--
 .../net/wireless/mediatek/mt76/mt7615/sdio.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio.c   |  4 +++-
 .../wireless/mediatek/mt76/mt7921/sdio_mac.c   |  3 ++-
 drivers/net/wireless/mediatek/mt76/sdio.c      | 18 +++++++++++-------
 5 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9c753c6aabef..60c9f9c56a4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -564,8 +564,7 @@ struct mt76_sdio {
 	struct mt76_worker txrx_worker;
 	struct mt76_worker status_worker;
 	struct mt76_worker net_worker;
-
-	struct work_struct stat_work;
+	struct mt76_worker stat_worker;
 
 	u8 *xmit_buf;
 	u32 xmit_buf_sz;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
index 304212f5f8da..d742b22428f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
@@ -205,8 +205,8 @@ static int mt7663s_suspend(struct device *dev)
 	mt76_worker_disable(&mdev->mt76.sdio.txrx_worker);
 	mt76_worker_disable(&mdev->mt76.sdio.status_worker);
 	mt76_worker_disable(&mdev->mt76.sdio.net_worker);
+	mt76_worker_disable(&mdev->mt76.sdio.stat_worker);
 
-	cancel_work_sync(&mdev->mt76.sdio.stat_work);
 	clear_bit(MT76_READING_STATS, &mdev->mphy.state);
 
 	mt76_tx_status_check(&mdev->mt76, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index 3b25a06fd946..8898ba69b8e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -222,7 +222,7 @@ static int mt7921s_suspend(struct device *__dev)
 	mt76_txq_schedule_all(&dev->mphy);
 	mt76_worker_disable(&mdev->tx_worker);
 	mt76_worker_disable(&mdev->sdio.status_worker);
-	cancel_work_sync(&mdev->sdio.stat_work);
+	mt76_worker_disable(&mdev->sdio.stat_worker);
 	clear_bit(MT76_READING_STATS, &dev->mphy.state);
 	mt76_tx_status_check(mdev, true);
 
@@ -254,6 +254,7 @@ static int mt7921s_suspend(struct device *__dev)
 restore_worker:
 	mt76_worker_enable(&mdev->tx_worker);
 	mt76_worker_enable(&mdev->sdio.status_worker);
+	mt76_worker_enable(&mdev->sdio.stat_worker);
 
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(mdev, false);
@@ -286,6 +287,7 @@ static int mt7921s_resume(struct device *__dev)
 	mt76_worker_enable(&mdev->sdio.txrx_worker);
 	mt76_worker_enable(&mdev->sdio.status_worker);
 	mt76_worker_enable(&mdev->sdio.net_worker);
+	mt76_worker_enable(&mdev->sdio.stat_worker);
 
 	/* restore previous ds setting */
 	if (!pm->ds_enable)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
index 1b3adb3d91e8..fd07b6623392 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
@@ -107,7 +107,7 @@ int mt7921s_mac_reset(struct mt7921_dev *dev)
 	mt76_worker_disable(&dev->mt76.sdio.txrx_worker);
 	mt76_worker_disable(&dev->mt76.sdio.status_worker);
 	mt76_worker_disable(&dev->mt76.sdio.net_worker);
-	cancel_work_sync(&dev->mt76.sdio.stat_work);
+	mt76_worker_disable(&dev->mt76.sdio.stat_worker);
 
 	mt7921s_disable_irq(&dev->mt76);
 	mt7921s_wfsys_reset(dev);
@@ -115,6 +115,7 @@ int mt7921s_mac_reset(struct mt7921_dev *dev)
 	mt76_worker_enable(&dev->mt76.sdio.txrx_worker);
 	mt76_worker_enable(&dev->mt76.sdio.status_worker);
 	mt76_worker_enable(&dev->mt76.sdio.net_worker);
+	mt76_worker_enable(&dev->mt76.sdio.stat_worker);
 
 	dev->fw_assert = false;
 	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 176207f3177c..fc4fb9463564 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -481,21 +481,21 @@ static void mt76s_status_worker(struct mt76_worker *w)
 		if (dev->drv->tx_status_data && ndata_frames > 0 &&
 		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state) &&
 		    !test_bit(MT76_STATE_SUSPEND, &dev->phy.state))
-			ieee80211_queue_work(dev->hw, &dev->sdio.stat_work);
+			mt76_worker_schedule(&sdio->stat_worker);
 	} while (nframes > 0);
 
 	if (resched)
 		mt76_worker_schedule(&dev->tx_worker);
 }
 
-static void mt76s_tx_status_data(struct work_struct *work)
+static void mt76s_tx_status_data(struct mt76_worker *worker)
 {
 	struct mt76_sdio *sdio;
 	struct mt76_dev *dev;
 	u8 update = 1;
 	u16 count = 0;
 
-	sdio = container_of(work, struct mt76_sdio, stat_work);
+	sdio = container_of(worker, struct mt76_sdio, stat_worker);
 	dev = container_of(sdio, struct mt76_dev, sdio);
 
 	while (true) {
@@ -508,7 +508,7 @@ static void mt76s_tx_status_data(struct work_struct *work)
 	}
 
 	if (count && test_bit(MT76_STATE_RUNNING, &dev->phy.state))
-		ieee80211_queue_work(dev->hw, &sdio->stat_work);
+		mt76_worker_schedule(&sdio->status_worker);
 	else
 		clear_bit(MT76_READING_STATS, &dev->phy.state);
 }
@@ -600,8 +600,8 @@ void mt76s_deinit(struct mt76_dev *dev)
 	mt76_worker_teardown(&sdio->txrx_worker);
 	mt76_worker_teardown(&sdio->status_worker);
 	mt76_worker_teardown(&sdio->net_worker);
+	mt76_worker_teardown(&sdio->stat_worker);
 
-	cancel_work_sync(&sdio->stat_work);
 	clear_bit(MT76_READING_STATS, &dev->phy.state);
 
 	mt76_tx_status_check(dev, true);
@@ -644,10 +644,14 @@ int mt76s_init(struct mt76_dev *dev, struct sdio_func *func,
 	if (err)
 		return err;
 
+	err = mt76_worker_setup(dev->hw, &sdio->stat_worker, mt76s_tx_status_data,
+				"sdio-sta");
+	if (err)
+		return err;
+
 	sched_set_fifo_low(sdio->status_worker.task);
 	sched_set_fifo_low(sdio->net_worker.task);
-
-	INIT_WORK(&sdio->stat_work, mt76s_tx_status_data);
+	sched_set_fifo_low(sdio->stat_worker.task);
 
 	dev->queue_ops = &sdio_queue_ops;
 	dev->bus = bus_ops;
-- 
2.43.0



