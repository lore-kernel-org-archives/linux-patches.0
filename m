Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA1313398C;
	Tue, 23 Jan 2024 00:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969298; cv=none; b=a9zviglmOQQVuFCn4Pc8QDun7lge5H/L2241RXAPiy0mTLzhQSQmAMUce+pthk0y61cIDczVoEXdFuBDzde+xs9qYsDVY8XpXlweAlItRduP3h9WlWADNDvD9+rmwPlENdg2B6tC9YaH/cdSORh7DJE7iqHT/5CTgQZf0xQLJ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969298; c=relaxed/simple;
	bh=yyCSOZ8aUqtxgZXR3bYiPRXhVhdCAUVzskKaI9+2I6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpyG6SO6j2fLWpR9jEHgsm74XmekYvUhuNFcfv+jqrusSEMzWwgZuOKX/NxSiZ2d0nrA5THW2LZ4AobzjY2PUgu9/ZcOJMMRJG0ELfjuUmMmn2GxYesicjTLbUBs/zFftC8Oi5DdA+NQAz5ABHwRaiK1ymWH229YPrWq8/4ooCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itDlHKCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itDlHKCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14956C43394;
	Tue, 23 Jan 2024 00:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969298;
	bh=yyCSOZ8aUqtxgZXR3bYiPRXhVhdCAUVzskKaI9+2I6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itDlHKCuUdBbNarhXenhEgiCMZoD7Yzw2AAnzr7jO+okq4I35OGifAopqp3BVHBRY
	 0bUU+di6qdvfptnsG9Y/v0W1VZGGPgr7SwiIjNmBx3rjhrRszDyb7DL2SI7RzzStqW
	 GAUNGxtvus7M270Uv2n4EIyaLlHTtIHM9ejUufu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhao <wang.zhao@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 155/641] wifi: mt76: mt7921s: fix workqueue problem causes STA association fail
Date: Mon, 22 Jan 2024 15:50:59 -0800
Message-ID: <20240122235822.883189680@linuxfoundation.org>
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
index ea828ba0b83a..a17b2fbd693b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -575,8 +575,7 @@ struct mt76_sdio {
 	struct mt76_worker txrx_worker;
 	struct mt76_worker status_worker;
 	struct mt76_worker net_worker;
-
-	struct work_struct stat_work;
+	struct mt76_worker stat_worker;
 
 	u8 *xmit_buf;
 	u32 xmit_buf_sz;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
index fc547a0031ea..67cedd2555f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
@@ -204,8 +204,8 @@ static int mt7663s_suspend(struct device *dev)
 	mt76_worker_disable(&mdev->mt76.sdio.txrx_worker);
 	mt76_worker_disable(&mdev->mt76.sdio.status_worker);
 	mt76_worker_disable(&mdev->mt76.sdio.net_worker);
+	mt76_worker_disable(&mdev->mt76.sdio.stat_worker);
 
-	cancel_work_sync(&mdev->mt76.sdio.stat_work);
 	clear_bit(MT76_READING_STATS, &mdev->mphy.state);
 
 	mt76_tx_status_check(&mdev->mt76, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index dc1beb76df3e..7591e54d2897 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -228,7 +228,7 @@ static int mt7921s_suspend(struct device *__dev)
 	mt76_txq_schedule_all(&dev->mphy);
 	mt76_worker_disable(&mdev->tx_worker);
 	mt76_worker_disable(&mdev->sdio.status_worker);
-	cancel_work_sync(&mdev->sdio.stat_work);
+	mt76_worker_disable(&mdev->sdio.stat_worker);
 	clear_bit(MT76_READING_STATS, &dev->mphy.state);
 	mt76_tx_status_check(mdev, true);
 
@@ -260,6 +260,7 @@ static int mt7921s_suspend(struct device *__dev)
 restore_worker:
 	mt76_worker_enable(&mdev->tx_worker);
 	mt76_worker_enable(&mdev->sdio.status_worker);
+	mt76_worker_enable(&mdev->sdio.stat_worker);
 
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(mdev, false);
@@ -292,6 +293,7 @@ static int mt7921s_resume(struct device *__dev)
 	mt76_worker_enable(&mdev->sdio.txrx_worker);
 	mt76_worker_enable(&mdev->sdio.status_worker);
 	mt76_worker_enable(&mdev->sdio.net_worker);
+	mt76_worker_enable(&mdev->sdio.stat_worker);
 
 	/* restore previous ds setting */
 	if (!pm->ds_enable)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
index 8edd0291c128..389eb0903807 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
@@ -107,7 +107,7 @@ int mt7921s_mac_reset(struct mt792x_dev *dev)
 	mt76_worker_disable(&dev->mt76.sdio.txrx_worker);
 	mt76_worker_disable(&dev->mt76.sdio.status_worker);
 	mt76_worker_disable(&dev->mt76.sdio.net_worker);
-	cancel_work_sync(&dev->mt76.sdio.stat_work);
+	mt76_worker_disable(&dev->mt76.sdio.stat_worker);
 
 	mt7921s_disable_irq(&dev->mt76);
 	mt7921s_wfsys_reset(dev);
@@ -115,6 +115,7 @@ int mt7921s_mac_reset(struct mt792x_dev *dev)
 	mt76_worker_enable(&dev->mt76.sdio.txrx_worker);
 	mt76_worker_enable(&dev->mt76.sdio.status_worker);
 	mt76_worker_enable(&dev->mt76.sdio.net_worker);
+	mt76_worker_enable(&dev->mt76.sdio.stat_worker);
 
 	dev->fw_assert = false;
 	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 419723118ded..c52d550f0c32 100644
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



