Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9363D1AF0C0;
	Wed, 19 Feb 2025 08:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954527; cv=none; b=SJS6T9XUAjvEkFPboBE5G2ZpCOqhJNZa0mBMynKfae65PJQgcjCjvCgNh+jZxCxfzvOhGuGc2ZGzozGYyXQPOfZB0C1s4b50/6Vqo2rfxrNAjALMFdH+pDMzeKYedZuFPd+YNxz769Ms8X9Br4BzPs1u12pAd3Fn5nbZkaLD/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954527; c=relaxed/simple;
	bh=QJ9My7egk231al2v9YWzOanQ6YKf7D/MWXJKbYd5ZtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeZWs4V067+8khscPmeyanVCKsoElt2njrWce5VoI5QRjLVCgZ+fsJ4Ir6PpCN9tWSZl9k16iW6JFON197yPlp3tjErPZz/IB3TE2b/WAOS8WyFJPfBHN81zMlKiac2F5hZDRHrn01lXe3EPInS7UTvzuTfAySw0rFGguPd6+Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi9Bp9re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi9Bp9re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1748DC4CED1;
	Wed, 19 Feb 2025 08:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954527;
	bh=QJ9My7egk231al2v9YWzOanQ6YKf7D/MWXJKbYd5ZtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xi9Bp9re21HjYa5A6vF1DKtaTEsOHlq75jqn+jqjjZn42xmZGWNPxccmm5QN/tZSy
	 1EfcotXf4nW/MvV1gPoroJP11NPqUNL/i390l6ytNS0zlXTZw21vg28Q3N0FaN2Atp
	 TKt4aXWAPfa7DOFzdm2dH7uKxnpnu+g2E2E3vMVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 230/274] eth: iavf: extend the netdev_lock usage
Date: Wed, 19 Feb 2025 09:28:04 +0100
Message-ID: <20250219082618.582615972@linuxfoundation.org>
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

[ Upstream commit afc664987ab318c227ebc0f639f5afc921aaf674 ]

iavf uses the netdev->lock already to protect shapers.
In an upcoming series we'll try to protect NAPI instances
with netdev->lock.

We need to modify the protection a bit. All NAPI related
calls in the driver need to be consistently under the lock.
This will allow us to easily switch to a "we already hold
the lock" NAPI API later.

register_netdevice(), OTOH, must not be called under
the netdev_lock() as we do not intend to have an
"already locked" version of this call.

Link: https://patch.msgid.link/20250111071339.3709071-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 53 +++++++++++++++++----
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2b8700abe56bb..7c427003184d5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1983,6 +1983,7 @@ static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter, bool runni
 static void iavf_finish_config(struct work_struct *work)
 {
 	struct iavf_adapter *adapter;
+	bool netdev_released = false;
 	int pairs, err;
 
 	adapter = container_of(work, struct iavf_adapter, finish_config);
@@ -2003,7 +2004,16 @@ static void iavf_finish_config(struct work_struct *work)
 
 	switch (adapter->state) {
 	case __IAVF_DOWN:
+		/* Set the real number of queues when reset occurs while
+		 * state == __IAVF_DOWN
+		 */
+		pairs = adapter->num_active_queues;
+		netif_set_real_num_rx_queues(adapter->netdev, pairs);
+		netif_set_real_num_tx_queues(adapter->netdev, pairs);
+
 		if (adapter->netdev->reg_state != NETREG_REGISTERED) {
+			mutex_unlock(&adapter->netdev->lock);
+			netdev_released = true;
 			err = register_netdevice(adapter->netdev);
 			if (err) {
 				dev_err(&adapter->pdev->dev, "Unable to register netdev (%d)\n",
@@ -2018,11 +2028,7 @@ static void iavf_finish_config(struct work_struct *work)
 				goto out;
 			}
 		}
-
-		/* Set the real number of queues when reset occurs while
-		 * state == __IAVF_DOWN
-		 */
-		fallthrough;
+		break;
 	case __IAVF_RUNNING:
 		pairs = adapter->num_active_queues;
 		netif_set_real_num_rx_queues(adapter->netdev, pairs);
@@ -2035,7 +2041,8 @@ static void iavf_finish_config(struct work_struct *work)
 
 out:
 	mutex_unlock(&adapter->crit_lock);
-	mutex_unlock(&adapter->netdev->lock);
+	if (!netdev_released)
+		mutex_unlock(&adapter->netdev->lock);
 	rtnl_unlock();
 }
 
@@ -2728,12 +2735,16 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_adapter *adapter = container_of(work,
 						    struct iavf_adapter,
 						    watchdog_task.work);
+	struct net_device *netdev = adapter->netdev;
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
+	mutex_lock(&netdev->lock);
 	if (!mutex_trylock(&adapter->crit_lock)) {
-		if (adapter->state == __IAVF_REMOVE)
+		if (adapter->state == __IAVF_REMOVE) {
+			mutex_unlock(&netdev->lock);
 			return;
+		}
 
 		goto restart_watchdog;
 	}
@@ -2745,30 +2756,35 @@ static void iavf_watchdog_task(struct work_struct *work)
 	case __IAVF_STARTUP:
 		iavf_startup(adapter);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(30));
 		return;
 	case __IAVF_INIT_VERSION_CHECK:
 		iavf_init_version_check(adapter);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(30));
 		return;
 	case __IAVF_INIT_GET_RESOURCES:
 		iavf_init_get_resources(adapter);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_EXTENDED_CAPS:
 		iavf_init_process_extended_caps(adapter);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_CONFIG_ADAPTER:
 		iavf_init_config_adapter(adapter);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
@@ -2780,6 +2796,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			 * as it can loop forever
 			 */
 			mutex_unlock(&adapter->crit_lock);
+			mutex_unlock(&netdev->lock);
 			return;
 		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
@@ -2788,6 +2805,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 			iavf_shutdown_adminq(hw);
 			mutex_unlock(&adapter->crit_lock);
+			mutex_unlock(&netdev->lock);
 			queue_delayed_work(adapter->wq,
 					   &adapter->watchdog_task, (5 * HZ));
 			return;
@@ -2795,6 +2813,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		/* Try again from failed step*/
 		iavf_change_state(adapter, adapter->last_state);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task, HZ);
 		return;
 	case __IAVF_COMM_FAILED:
@@ -2807,6 +2826,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			iavf_change_state(adapter, __IAVF_INIT_FAILED);
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 			mutex_unlock(&adapter->crit_lock);
+			mutex_unlock(&netdev->lock);
 			return;
 		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
@@ -2826,12 +2846,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
 		return;
 	case __IAVF_RESETTING:
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   HZ * 2);
 		return;
@@ -2862,6 +2884,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 	case __IAVF_REMOVE:
 	default:
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		return;
 	}
 
@@ -2873,12 +2896,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task, HZ * 2);
 		return;
 	}
 
 	mutex_unlock(&adapter->crit_lock);
+	mutex_unlock(&netdev->lock);
 restart_watchdog:
 	if (adapter->state >= __IAVF_DOWN)
 		queue_work(adapter->wq, &adapter->adminq_task);
@@ -4355,14 +4380,17 @@ static int iavf_open(struct net_device *netdev)
 		return -EIO;
 	}
 
+	mutex_lock(&netdev->lock);
 	while (!mutex_trylock(&adapter->crit_lock)) {
 		/* If we are in __IAVF_INIT_CONFIG_ADAPTER state the crit_lock
 		 * is already taken and iavf_open is called from an upper
 		 * device's notifier reacting on NETDEV_REGISTER event.
 		 * We have to leave here to avoid dead lock.
 		 */
-		if (adapter->state == __IAVF_INIT_CONFIG_ADAPTER)
+		if (adapter->state == __IAVF_INIT_CONFIG_ADAPTER) {
+			mutex_unlock(&netdev->lock);
 			return -EBUSY;
+		}
 
 		usleep_range(500, 1000);
 	}
@@ -4411,6 +4439,7 @@ static int iavf_open(struct net_device *netdev)
 	iavf_irq_enable(adapter, true);
 
 	mutex_unlock(&adapter->crit_lock);
+	mutex_unlock(&netdev->lock);
 
 	return 0;
 
@@ -4423,6 +4452,7 @@ static int iavf_open(struct net_device *netdev)
 	iavf_free_all_tx_resources(adapter);
 err_unlock:
 	mutex_unlock(&adapter->crit_lock);
+	mutex_unlock(&netdev->lock);
 
 	return err;
 }
@@ -4444,10 +4474,12 @@ static int iavf_close(struct net_device *netdev)
 	u64 aq_to_restore;
 	int status;
 
+	mutex_lock(&netdev->lock);
 	mutex_lock(&adapter->crit_lock);
 
 	if (adapter->state <= __IAVF_DOWN_PENDING) {
 		mutex_unlock(&adapter->crit_lock);
+		mutex_unlock(&netdev->lock);
 		return 0;
 	}
 
@@ -4481,6 +4513,7 @@ static int iavf_close(struct net_device *netdev)
 	iavf_free_traffic_irqs(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
+	mutex_unlock(&netdev->lock);
 
 	/* We explicitly don't free resources here because the hardware is
 	 * still active and can DMA into memory. Resources are cleared in
@@ -5357,6 +5390,7 @@ static int iavf_suspend(struct device *dev_d)
 
 	netif_device_detach(netdev);
 
+	mutex_lock(&netdev->lock);
 	mutex_lock(&adapter->crit_lock);
 
 	if (netif_running(netdev)) {
@@ -5368,6 +5402,7 @@ static int iavf_suspend(struct device *dev_d)
 	iavf_reset_interrupt_capability(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
+	mutex_unlock(&netdev->lock);
 
 	return 0;
 }
@@ -5466,6 +5501,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(netdev);
 
+	mutex_lock(&netdev->lock);
 	mutex_lock(&adapter->crit_lock);
 	dev_info(&adapter->pdev->dev, "Removing device\n");
 	iavf_change_state(adapter, __IAVF_REMOVE);
@@ -5502,6 +5538,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	mutex_destroy(&hw->aq.asq_mutex);
 	mutex_unlock(&adapter->crit_lock);
 	mutex_destroy(&adapter->crit_lock);
+	mutex_unlock(&netdev->lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-- 
2.39.5



