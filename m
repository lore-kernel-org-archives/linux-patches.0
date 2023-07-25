Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B9714263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE36C433C8;
	Tue, 25 Jul 2023 10:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282567;
	bh=2TuJa6Oda2BbjD3RjMFH+PfujzJEBhUlBxnMPfnucaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RHyQAsOIErA5MYAQCEragJTnf3UoWDxZcjHxexOkZrndZnxqA0b6QeAnRpLjWDhs
	 OaH8oOuvDwyNhqxljAPJWjzB5aYFMcIbiyHg8Zn2Rotned4gFey0nPpphrZ7P2vbz6
	 3nft7Ao2A2DwJYWp4WGtWfneoijkpfzHR6v/ArhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 176/227] iavf: fix reset task race with iavf_remove()
Date: Tue, 25 Jul 2023 12:45:43 +0200
Message-ID: <20230725104522.143254273@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit c34743daca0eb1dc855831a5210f0800a850088e ]

The reset task is currently scheduled from the watchdog or adminq tasks.
First, all direct calls to schedule the reset task are replaced with the
iavf_schedule_reset(), which is modified to accept the flag showing the
type of reset.

To prevent the reset task from starting once iavf_remove() starts, we need
to check the __IAVF_IN_REMOVE_TASK bit before we schedule it. This is now
easily added to iavf_schedule_reset().

Finally, remove the check for IAVF_FLAG_RESET_NEEDED in the watchdog task.
It is redundant since all callers who set the flag immediately schedules
the reset task.

Fixes: 3ccd54ef44eb ("iavf: Fix init state closure on remove")
Fixes: 14756b2ae265 ("iavf: Fix __IAVF_RESETTING state usage")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  8 ++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 32 +++++++------------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  3 +-
 4 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index bf5e3c8e97e04..8cbdebc5b6989 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -520,7 +520,7 @@ int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
 int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter);
-void iavf_schedule_reset(struct iavf_adapter *adapter);
+void iavf_schedule_reset(struct iavf_adapter *adapter, u64 flags);
 void iavf_schedule_request_stats(struct iavf_adapter *adapter);
 void iavf_schedule_finish_config(struct iavf_adapter *adapter);
 void iavf_reset(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index b7141c2a941d1..2f47cfa7f06e2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -532,8 +532,7 @@ static int iavf_set_priv_flags(struct net_device *netdev, u32 flags)
 	/* issue a reset to force legacy-rx change to take effect */
 	if (changed_flags & IAVF_FLAG_LEGACY_RX) {
 		if (netif_running(netdev)) {
-			adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-			queue_work(adapter->wq, &adapter->reset_task);
+			iavf_schedule_reset(adapter, IAVF_FLAG_RESET_NEEDED);
 			ret = iavf_wait_for_reset(adapter);
 			if (ret)
 				netdev_warn(netdev, "Changing private flags timeout or interrupted waiting for reset");
@@ -676,8 +675,7 @@ static int iavf_set_ringparam(struct net_device *netdev,
 	}
 
 	if (netif_running(netdev)) {
-		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		queue_work(adapter->wq, &adapter->reset_task);
+		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_NEEDED);
 		ret = iavf_wait_for_reset(adapter);
 		if (ret)
 			netdev_warn(netdev, "Changing ring parameters timeout or interrupted waiting for reset");
@@ -1860,7 +1858,7 @@ static int iavf_set_channels(struct net_device *netdev,
 
 	adapter->num_req_queues = num_req;
 	adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
-	iavf_schedule_reset(adapter);
+	iavf_schedule_reset(adapter, IAVF_FLAG_RESET_NEEDED);
 
 	ret = iavf_wait_for_reset(adapter);
 	if (ret)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 161750c1598f8..ba96312feb505 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -309,12 +309,14 @@ static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
 /**
  * iavf_schedule_reset - Set the flags and schedule a reset event
  * @adapter: board private structure
+ * @flags: IAVF_FLAG_RESET_PENDING or IAVF_FLAG_RESET_NEEDED
  **/
-void iavf_schedule_reset(struct iavf_adapter *adapter)
+void iavf_schedule_reset(struct iavf_adapter *adapter, u64 flags)
 {
-	if (!(adapter->flags &
-	      (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED))) {
-		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
+	if (!test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section) &&
+	    !(adapter->flags &
+	    (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED))) {
+		adapter->flags |= flags;
 		queue_work(adapter->wq, &adapter->reset_task);
 	}
 }
@@ -342,7 +344,7 @@ static void iavf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	adapter->tx_timeout_count++;
-	iavf_schedule_reset(adapter);
+	iavf_schedule_reset(adapter, IAVF_FLAG_RESET_NEEDED);
 }
 
 /**
@@ -2490,7 +2492,7 @@ int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter)
 			adapter->vsi_res->num_queue_pairs);
 		adapter->flags |= IAVF_FLAG_REINIT_MSIX_NEEDED;
 		adapter->num_req_queues = adapter->vsi_res->num_queue_pairs;
-		iavf_schedule_reset(adapter);
+		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_NEEDED);
 
 		return -EAGAIN;
 	}
@@ -2787,14 +2789,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
-	if (adapter->flags & IAVF_FLAG_RESET_NEEDED) {
-		adapter->aq_required = 0;
-		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		mutex_unlock(&adapter->crit_lock);
-		queue_work(adapter->wq, &adapter->reset_task);
-		return;
-	}
-
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
 		iavf_startup(adapter);
@@ -2922,11 +2916,10 @@ static void iavf_watchdog_task(struct work_struct *work)
 	/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
-		queue_work(adapter->wq, &adapter->reset_task);
+		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
 		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task, HZ * 2);
@@ -3324,9 +3317,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
-	if ((adapter->flags &
-	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
-	    adapter->state == __IAVF_RESETTING)
+	if (iavf_is_reset_in_progress(adapter))
 		goto freedom;
 
 	/* check for error indications */
@@ -4423,8 +4414,7 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 	}
 
 	if (netif_running(netdev)) {
-		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		queue_work(adapter->wq, &adapter->reset_task);
+		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_NEEDED);
 		ret = iavf_wait_for_reset(adapter);
 		if (ret < 0)
 			netdev_warn(netdev, "MTU change interrupted waiting for reset");
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 073ac29ed84c7..be3c007ce90a9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1961,9 +1961,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		case VIRTCHNL_EVENT_RESET_IMPENDING:
 			dev_info(&adapter->pdev->dev, "Reset indication received from the PF\n");
 			if (!(adapter->flags & IAVF_FLAG_RESET_PENDING)) {
-				adapter->flags |= IAVF_FLAG_RESET_PENDING;
 				dev_info(&adapter->pdev->dev, "Scheduling reset task\n");
-				queue_work(adapter->wq, &adapter->reset_task);
+				iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
 			}
 			break;
 		default:
-- 
2.39.2



