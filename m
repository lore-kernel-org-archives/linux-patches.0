Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A881DB92E;
	Wed, 19 Feb 2025 08:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954530; cv=none; b=BfPY3uVfMGskplG7vQgM7RuaiE0DpTF0oxpaVxIywYeDpASxbPBYyoynin/3Ujtn1Oiw4bo2GFvf41LW+6fO+l64EIcmN7xP34rQWpBCJVRSl7gtuiZjxKKHeYcIRhTflxg/ROnEZsL+fr0bU+rZYBVvlswJlARX0C+pZtK5ytc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954530; c=relaxed/simple;
	bh=Zs4Y70jWQ2CwPIxazsM90OMp20xuvaUILiZTD4GL+Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdksWvgIM072VjvfMaNCECpRO2L6MYsbqrmyQ+e5qCo5XW79DJpZh9c8HmpCI028eMrkF5UkKiWpLEEZAxxMcTnKVhKkQcaS5efmeGuj8gzAGcLbwA9PRWXDBDljN7W8xxE+CxgPsYpYC2IHcQnK8liFCPHTyze9ekz8wqliW/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjAftzXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjAftzXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4BFC4CED1;
	Wed, 19 Feb 2025 08:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954530;
	bh=Zs4Y70jWQ2CwPIxazsM90OMp20xuvaUILiZTD4GL+Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjAftzXLqsKb46+kz02E53RvjJmiEk+OuQJ/V2SWbMyfXnXSAbYJe9/9tqGhKXw5j
	 yp3WKwL1TTPHid0QgqetYHat3kh8Yab7ZzOpok40mTASZ5b6o0NgmqkR9dsRcNYWDk
	 2eVpfMkvwOZLBsKFi292qF9X5k397nqY6EhqkKjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 231/274] net: add netdev_lock() / netdev_unlock() helpers
Date: Wed, 19 Feb 2025 09:28:05 +0100
Message-ID: <20250219082618.621038202@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ebda2f0bbde540ff7da168d2837f8cfb14581e2e ]

Add helpers for locking the netdev instance, use it in drivers
and the shaper code. This will make grepping for the lock usage
much easier, as we extend the lock to cover more fields.

Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20250115035319.559603-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 74 ++++++++++-----------
 drivers/net/netdevsim/ethtool.c             |  4 +-
 include/linux/netdevice.h                   | 23 ++++++-
 net/shaper/shaper.c                         |  6 +-
 4 files changed, 63 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7c427003184d5..72314b0a1b25b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1992,7 +1992,7 @@ static void iavf_finish_config(struct work_struct *work)
 	 * The dev->lock is needed to update the queue number
 	 */
 	rtnl_lock();
-	mutex_lock(&adapter->netdev->lock);
+	netdev_lock(adapter->netdev);
 	mutex_lock(&adapter->crit_lock);
 
 	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES) &&
@@ -2012,7 +2012,7 @@ static void iavf_finish_config(struct work_struct *work)
 		netif_set_real_num_tx_queues(adapter->netdev, pairs);
 
 		if (adapter->netdev->reg_state != NETREG_REGISTERED) {
-			mutex_unlock(&adapter->netdev->lock);
+			netdev_unlock(adapter->netdev);
 			netdev_released = true;
 			err = register_netdevice(adapter->netdev);
 			if (err) {
@@ -2042,7 +2042,7 @@ static void iavf_finish_config(struct work_struct *work)
 out:
 	mutex_unlock(&adapter->crit_lock);
 	if (!netdev_released)
-		mutex_unlock(&adapter->netdev->lock);
+		netdev_unlock(adapter->netdev);
 	rtnl_unlock();
 }
 
@@ -2739,10 +2739,10 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	if (!mutex_trylock(&adapter->crit_lock)) {
 		if (adapter->state == __IAVF_REMOVE) {
-			mutex_unlock(&netdev->lock);
+			netdev_unlock(netdev);
 			return;
 		}
 
@@ -2756,35 +2756,35 @@ static void iavf_watchdog_task(struct work_struct *work)
 	case __IAVF_STARTUP:
 		iavf_startup(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(30));
 		return;
 	case __IAVF_INIT_VERSION_CHECK:
 		iavf_init_version_check(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(30));
 		return;
 	case __IAVF_INIT_GET_RESOURCES:
 		iavf_init_get_resources(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_EXTENDED_CAPS:
 		iavf_init_process_extended_caps(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_CONFIG_ADAPTER:
 		iavf_init_config_adapter(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
@@ -2796,7 +2796,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			 * as it can loop forever
 			 */
 			mutex_unlock(&adapter->crit_lock);
-			mutex_unlock(&netdev->lock);
+			netdev_unlock(netdev);
 			return;
 		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
@@ -2805,7 +2805,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 			iavf_shutdown_adminq(hw);
 			mutex_unlock(&adapter->crit_lock);
-			mutex_unlock(&netdev->lock);
+			netdev_unlock(netdev);
 			queue_delayed_work(adapter->wq,
 					   &adapter->watchdog_task, (5 * HZ));
 			return;
@@ -2813,7 +2813,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		/* Try again from failed step*/
 		iavf_change_state(adapter, adapter->last_state);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task, HZ);
 		return;
 	case __IAVF_COMM_FAILED:
@@ -2826,7 +2826,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			iavf_change_state(adapter, __IAVF_INIT_FAILED);
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 			mutex_unlock(&adapter->crit_lock);
-			mutex_unlock(&netdev->lock);
+			netdev_unlock(netdev);
 			return;
 		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
@@ -2846,14 +2846,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
 		return;
 	case __IAVF_RESETTING:
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   HZ * 2);
 		return;
@@ -2884,7 +2884,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 	case __IAVF_REMOVE:
 	default:
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		return;
 	}
 
@@ -2896,14 +2896,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task, HZ * 2);
 		return;
 	}
 
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 restart_watchdog:
 	if (adapter->state >= __IAVF_DOWN)
 		queue_work(adapter->wq, &adapter->adminq_task);
@@ -3030,12 +3030,12 @@ static void iavf_reset_task(struct work_struct *work)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	if (!mutex_trylock(&adapter->crit_lock)) {
 		if (adapter->state != __IAVF_REMOVE)
 			queue_work(adapter->wq, &adapter->reset_task);
 
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		return;
 	}
 
@@ -3083,7 +3083,7 @@ static void iavf_reset_task(struct work_struct *work)
 			reg_val);
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -3224,7 +3224,7 @@ static void iavf_reset_task(struct work_struct *work)
 
 	wake_up(&adapter->reset_waitqueue);
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	return;
 reset_err:
@@ -3235,7 +3235,7 @@ static void iavf_reset_task(struct work_struct *work)
 	iavf_disable_vf(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 }
 
@@ -3707,10 +3707,10 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
 		return 0;
 
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	netif_set_real_num_rx_queues(netdev, total_qps);
 	netif_set_real_num_tx_queues(netdev, total_qps);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	return ret;
 }
@@ -4380,7 +4380,7 @@ static int iavf_open(struct net_device *netdev)
 		return -EIO;
 	}
 
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	while (!mutex_trylock(&adapter->crit_lock)) {
 		/* If we are in __IAVF_INIT_CONFIG_ADAPTER state the crit_lock
 		 * is already taken and iavf_open is called from an upper
@@ -4388,7 +4388,7 @@ static int iavf_open(struct net_device *netdev)
 		 * We have to leave here to avoid dead lock.
 		 */
 		if (adapter->state == __IAVF_INIT_CONFIG_ADAPTER) {
-			mutex_unlock(&netdev->lock);
+			netdev_unlock(netdev);
 			return -EBUSY;
 		}
 
@@ -4439,7 +4439,7 @@ static int iavf_open(struct net_device *netdev)
 	iavf_irq_enable(adapter, true);
 
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	return 0;
 
@@ -4452,7 +4452,7 @@ static int iavf_open(struct net_device *netdev)
 	iavf_free_all_tx_resources(adapter);
 err_unlock:
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	return err;
 }
@@ -4474,12 +4474,12 @@ static int iavf_close(struct net_device *netdev)
 	u64 aq_to_restore;
 	int status;
 
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	mutex_lock(&adapter->crit_lock);
 
 	if (adapter->state <= __IAVF_DOWN_PENDING) {
 		mutex_unlock(&adapter->crit_lock);
-		mutex_unlock(&netdev->lock);
+		netdev_unlock(netdev);
 		return 0;
 	}
 
@@ -4513,7 +4513,7 @@ static int iavf_close(struct net_device *netdev)
 	iavf_free_traffic_irqs(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	/* We explicitly don't free resources here because the hardware is
 	 * still active and can DMA into memory. Resources are cleared in
@@ -5390,7 +5390,7 @@ static int iavf_suspend(struct device *dev_d)
 
 	netif_device_detach(netdev);
 
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	mutex_lock(&adapter->crit_lock);
 
 	if (netif_running(netdev)) {
@@ -5402,7 +5402,7 @@ static int iavf_suspend(struct device *dev_d)
 	iavf_reset_interrupt_capability(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	return 0;
 }
@@ -5501,7 +5501,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(netdev);
 
-	mutex_lock(&netdev->lock);
+	netdev_lock(netdev);
 	mutex_lock(&adapter->crit_lock);
 	dev_info(&adapter->pdev->dev, "Removing device\n");
 	iavf_change_state(adapter, __IAVF_REMOVE);
@@ -5538,7 +5538,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	mutex_destroy(&hw->aq.asq_mutex);
 	mutex_unlock(&adapter->crit_lock);
 	mutex_destroy(&adapter->crit_lock);
-	mutex_unlock(&netdev->lock);
+	netdev_unlock(netdev);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 5fe1eaef99b5b..3f44a11aec83e 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -103,10 +103,10 @@ nsim_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 	struct netdevsim *ns = netdev_priv(dev);
 	int err;
 
-	mutex_lock(&dev->lock);
+	netdev_lock(dev);
 	err = netif_set_real_num_queues(dev, ch->combined_count,
 					ch->combined_count);
-	mutex_unlock(&dev->lock);
+	netdev_unlock(dev);
 	if (err)
 		return err;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8268be0723eee..035cc881dd756 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2442,8 +2442,12 @@ struct net_device {
 	u32			napi_defer_hard_irqs;
 
 	/**
-	 * @lock: protects @net_shaper_hierarchy, feel free to use for other
-	 * netdev-scope protection. Ordering: take after rtnl_lock.
+	 * @lock: netdev-scope lock, protects a small selection of fields.
+	 * Should always be taken using netdev_lock() / netdev_unlock() helpers.
+	 * Drivers are free to use it for other protection.
+	 *
+	 * Protects: @net_shaper_hierarchy.
+	 * Ordering: take after rtnl_lock.
 	 */
 	struct mutex		lock;
 
@@ -2673,6 +2677,21 @@ void netif_queue_set_napi(struct net_device *dev, unsigned int queue_index,
 			  enum netdev_queue_type type,
 			  struct napi_struct *napi);
 
+static inline void netdev_lock(struct net_device *dev)
+{
+	mutex_lock(&dev->lock);
+}
+
+static inline void netdev_unlock(struct net_device *dev)
+{
+	mutex_unlock(&dev->lock);
+}
+
+static inline void netdev_assert_locked(struct net_device *dev)
+{
+	lockdep_assert_held(&dev->lock);
+}
+
 static inline void netif_napi_set_irq(struct napi_struct *napi, int irq)
 {
 	napi->irq = irq;
diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 15463062fe7b6..7101a48bce545 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -40,7 +40,7 @@ static void net_shaper_lock(struct net_shaper_binding *binding)
 {
 	switch (binding->type) {
 	case NET_SHAPER_BINDING_TYPE_NETDEV:
-		mutex_lock(&binding->netdev->lock);
+		netdev_lock(binding->netdev);
 		break;
 	}
 }
@@ -49,7 +49,7 @@ static void net_shaper_unlock(struct net_shaper_binding *binding)
 {
 	switch (binding->type) {
 	case NET_SHAPER_BINDING_TYPE_NETDEV:
-		mutex_unlock(&binding->netdev->lock);
+		netdev_unlock(binding->netdev);
 		break;
 	}
 }
@@ -1398,7 +1398,7 @@ void net_shaper_set_real_num_tx_queues(struct net_device *dev,
 	/* Only drivers implementing shapers support ensure
 	 * the lock is acquired in advance.
 	 */
-	lockdep_assert_held(&dev->lock);
+	netdev_assert_locked(dev);
 
 	/* Take action only when decreasing the tx queue number. */
 	for (i = txq; i < dev->real_num_tx_queues; ++i) {
-- 
2.39.5



