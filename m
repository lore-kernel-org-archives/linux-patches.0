Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7EF2EC09B;
	Sat, 12 Sep 2026 11:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212148; cv=none; b=lC2imBy1IHR/K4s8grTNu+jARfDqvWXbWcx6KNAbiV0Yq4LHCR/dz3crwGjyePAfLuSlPr89OD5x08IGsW1toFsoOfdHsReO7iPJjMepHzqaxrwM8DR7GiXDdeTFr7afJaFMsgBwJCnwrBsMUZ1RkEX1HuGwUuWBJujy6wpJTJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212148; c=relaxed/simple;
	bh=6p7Oah65BpdC/3YXTQ3LI2Na4gZ782hJzcNeX5fZHWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTt1AyvrCPFcV5wh683Ep6IE1NZRTlRyvoeZ9SbBeS7/9oRNc/qbD86RdSByjE7mUq0LcRDAlWgbygN8Sr/goyUZUYeBwLhCMmgKBqYwfqnjfq2klVOa2llDH/FJUFHoYjOTjbjO+41hOfbt5PgMA1dgMqEcIvnNnuhRXq6vyMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfhUqA/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfhUqA/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EEB1F000FF;
	Sat, 12 Sep 2026 11:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212146;
	bh=9TUMA2LTXltJL5h89e89MhSbBmjQovc540acqXFJkK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfhUqA/OLFfvu/mVgvHvqzgPbYFx2q7wQdIJrcuAFgwacs85CtaMNdzJUlOCENttG
	 /VTC3jBUxKBztxmsYrYH4uvIUK+zhXC+RKz/nbVq2YBJ1NM/TfV59KMtDv+AfX+ng8
	 68fwJWydAfPDBpFBhQ46uiBCXWvWCUWVR76gCRQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1375/1518] net: wangxun: schedule hardware stats update in watchdog
Date: Sat, 12 Sep 2026 08:59:04 +0200
Message-ID: <20260912065654.647607490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit dc33e52b8ce6f2d42dce18da12dc47d6c21f2e8b ]

Hardware statistics should be updated periodically in the watchdog to
prevent 32-bit registers from overflowing. This is also required for the
upcoming pause frame accounting logic, which relies on regular statistics
sampling.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260407025616.33652-8-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7bf29145d7a9 ("net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  9 +++++
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 36 ++++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  1 +
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index a696d30673346..e28bf4b6737ed 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -2508,6 +2508,7 @@ int wx_sw_init(struct wx *wx)
 		return -ENOMEM;
 	}
 
+	spin_lock_init(&wx->hw_stats_lock);
 	mutex_init(&wx->reset_lock);
 	bitmap_zero(wx->state, WX_STATE_NBITS);
 	bitmap_zero(wx->flags, WX_PF_FLAGS_NBITS);
@@ -2840,6 +2841,12 @@ void wx_update_stats(struct wx *wx)
 	u64 restart_queue = 0, tx_busy = 0;
 	u32 i;
 
+	if (!netif_running(wx->netdev) ||
+	    test_bit(WX_STATE_RESETTING, wx->state))
+		return;
+
+	spin_lock(&wx->hw_stats_lock);
+
 	/* gather some stats to the wx struct that are per queue */
 	for (i = 0; i < wx->num_rx_queues; i++) {
 		struct wx_ring *rx_ring = wx->rx_ring[i];
@@ -2908,6 +2915,8 @@ void wx_update_stats(struct wx *wx)
 	for (i = wx->num_vfs * wx->num_rx_queues_per_pool;
 	     i < wx->mac.max_rx_queues; i++)
 		hwstats->qmprc += rd32(wx, WX_PX_MPRC(i));
+
+	spin_unlock(&wx->hw_stats_lock);
 }
 EXPORT_SYMBOL(wx_update_stats);
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 0e46f29a0a75d..158a20b96960e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1348,6 +1348,7 @@ struct wx {
 	bool default_up;
 
 	struct wx_hw_stats stats;
+	spinlock_t hw_stats_lock; /* spinlock for accessing to hw stats */
 	u64 tx_busy;
 	u64 non_eop_descs;
 	u64 restart_queue;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index e80962d40f7ed..55f52a0483554 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -138,6 +138,26 @@ static int ngbe_sw_init(struct wx *wx)
 	return 0;
 }
 
+/**
+ * ngbe_service_task - manages and runs subtasks
+ * @work: pointer to work_struct containing our data
+ **/
+static void ngbe_service_task(struct work_struct *work)
+{
+	struct wx *wx = container_of(work, struct wx, service_task);
+
+	wx_update_stats(wx);
+
+	wx_service_event_complete(wx);
+}
+
+static void ngbe_init_service(struct wx *wx)
+{
+	timer_setup(&wx->service_timer, wx_service_timer, 0);
+	INIT_WORK(&wx->service_task, ngbe_service_task);
+	clear_bit(WX_STATE_SERVICE_SCHED, wx->state);
+}
+
 /**
  * ngbe_irq_enable - Enable default interrupt generation settings
  * @wx: board private structure
@@ -370,6 +390,10 @@ static void ngbe_disable_device(struct wx *wx)
 	wx_napi_disable_all(wx);
 	netif_tx_stop_all_queues(netdev);
 	netif_tx_disable(netdev);
+
+	timer_delete_sync(&wx->service_timer);
+	cancel_work_sync(&wx->service_task);
+
 	if (wx->gpio_ctrl)
 		ngbe_sfp_modules_txrx_powerctl(wx, false);
 	wx_irq_disable(wx);
@@ -409,6 +433,7 @@ void ngbe_up(struct wx *wx)
 	wx_napi_enable_all(wx);
 	/* enable transmits */
 	netif_tx_start_all_queues(wx->netdev);
+	mod_timer(&wx->service_timer, jiffies);
 
 	/* clear any pending interrupts, may auto mask */
 	rd32(wx, WX_PX_IC(0));
@@ -772,9 +797,11 @@ static int ngbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wx->mac.perm_addr);
 	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
 
+	ngbe_init_service(wx);
+
 	err = wx_init_interrupt_scheme(wx);
 	if (err)
-		goto err_free_mac_table;
+		goto err_cancel_service;
 
 	/* phy Interface Configuration */
 	err = ngbe_mdio_init(wx);
@@ -794,6 +821,9 @@ static int ngbe_probe(struct pci_dev *pdev,
 	wx_control_hw(wx, false);
 err_clear_interrupt_scheme:
 	wx_clear_interrupt_scheme(wx);
+err_cancel_service:
+	timer_delete_sync(&wx->service_timer);
+	cancel_work_sync(&wx->service_task);
 err_free_mac_table:
 	kfree(wx->rss_key);
 	kfree(wx->mac_table);
@@ -822,6 +852,10 @@ static void ngbe_remove(struct pci_dev *pdev)
 	netdev = wx->netdev;
 	wx_disable_sriov(wx);
 	unregister_netdev(netdev);
+
+	timer_shutdown_sync(&wx->service_timer);
+	cancel_work_sync(&wx->service_task);
+
 	phylink_destroy(wx->phylink);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 55c2b53e92b68..8362878e4b058 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -130,6 +130,7 @@ static void txgbe_service_task(struct work_struct *work)
 
 	txgbe_module_detection_subtask(wx);
 	txgbe_link_config_subtask(wx);
+	wx_update_stats(wx);
 
 	wx_service_event_complete(wx);
 }
-- 
2.53.0



