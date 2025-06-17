Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29042FA628;
	Tue, 17 Jun 2025 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178922; cv=none; b=ksUn5KKR/JJytibnFjwCerbcpHlfhMf0i/a+msPFUrBQqnjM1UzCjju4T+i96YB2weIuajpisKMKI6CFm7yVRRWsX2nddUFNrmAI6cJb0auNbCwdvNCgkMFcbcBSltgsHST32S1gnhiUmlhd8JIirQ5CM0NpmdjRUkC/W6CMJlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178922; c=relaxed/simple;
	bh=lwikhhTkQr3I3esT/nfh2MjyeKb0f1x+2hwX91mmwZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5yh6vxKBB6aXha1M+OKxgTyLOUQS8eA7XXq3tDqbMlCU+MPzpXAwMCbYo1QtbFevJZGiSl7MMfjOh5GA2Y3l8uFBS4vqNpGnGCC7bcr9kvCNrBM/n3FA8mpEMEVdSY3ytSLu67P5hpkJBrxULPPNhxL71S+QNwGOsRp2HvGep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZtvhI7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZtvhI7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48B8C4CEE3;
	Tue, 17 Jun 2025 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178922;
	bh=lwikhhTkQr3I3esT/nfh2MjyeKb0f1x+2hwX91mmwZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZtvhI7ACHCZXVqxzVCfPVlRCO+xn4HIVjZhBub1XN9JuRJ+zPXeUHHAvYxPMEXwX
	 nPsvZrtD2TI4Z/6bE3596wf6U0HZmYYoJ8ODhxZHb43MwCn5EzfF3Bwf37GKQf87IW
	 6JZtK4ik3i6l9fVX55fPmv4fr93LpY4U/t6d0CSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 593/780] iavf: centralize watchdog requeueing itself
Date: Tue, 17 Jun 2025 17:25:01 +0200
Message-ID: <20250617152515.638757748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 099418da91b7d3d46ddcccbb03075cc4f1ba2d44 ]

Centralize the unlock(critlock); unlock(netdev); queue_delayed_work(watchog_task);
pattern to one place.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 120f28a6f314 ("iavf: get rid of the crit lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 103 ++++++++------------
 1 file changed, 41 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a77c726435281..2c6e033c73419 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2911,6 +2911,8 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
+static const int IAVF_NO_RESCHED = -1;
+
 /**
  * iavf_watchdog_task - Periodic call-back task
  * @work: pointer to work_struct
@@ -2922,6 +2924,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 						    watchdog_task.work);
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_hw *hw = &adapter->hw;
+	int msec_delay;
 	u32 reg_val;
 
 	netdev_lock(netdev);
@@ -2940,39 +2943,24 @@ static void iavf_watchdog_task(struct work_struct *work)
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
 		iavf_startup(adapter);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   msecs_to_jiffies(30));
-		return;
+		msec_delay = 30;
+		goto watchdog_done;
 	case __IAVF_INIT_VERSION_CHECK:
 		iavf_init_version_check(adapter);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   msecs_to_jiffies(30));
-		return;
+		msec_delay = 30;
+		goto watchdog_done;
 	case __IAVF_INIT_GET_RESOURCES:
 		iavf_init_get_resources(adapter);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   msecs_to_jiffies(1));
-		return;
+		msec_delay = 1;
+		goto watchdog_done;
 	case __IAVF_INIT_EXTENDED_CAPS:
 		iavf_init_process_extended_caps(adapter);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   msecs_to_jiffies(1));
-		return;
+		msec_delay = 1;
+		goto watchdog_done;
 	case __IAVF_INIT_CONFIG_ADAPTER:
 		iavf_init_config_adapter(adapter);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   msecs_to_jiffies(1));
-		return;
+		msec_delay = 1;
+		goto watchdog_done;
 	case __IAVF_INIT_FAILED:
 		if (test_bit(__IAVF_IN_REMOVE_TASK,
 			     &adapter->crit_section)) {
@@ -2980,27 +2968,21 @@ static void iavf_watchdog_task(struct work_struct *work)
 			 * watchdog task, iavf_remove should handle this state
 			 * as it can loop forever
 			 */
-			mutex_unlock(&adapter->crit_lock);
-			netdev_unlock(netdev);
-			return;
+			msec_delay = IAVF_NO_RESCHED;
+			goto watchdog_done;
 		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 			dev_err(&adapter->pdev->dev,
 				"Failed to communicate with PF; waiting before retry\n");
 			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 			iavf_shutdown_adminq(hw);
-			mutex_unlock(&adapter->crit_lock);
-			netdev_unlock(netdev);
-			queue_delayed_work(adapter->wq,
-					   &adapter->watchdog_task, (5 * HZ));
-			return;
+			msec_delay = 5000;
+			goto watchdog_done;
 		}
 		/* Try again from failed step*/
 		iavf_change_state(adapter, adapter->last_state);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task, HZ);
-		return;
+		msec_delay = 1000;
+		goto watchdog_done;
 	case __IAVF_COMM_FAILED:
 		if (test_bit(__IAVF_IN_REMOVE_TASK,
 			     &adapter->crit_section)) {
@@ -3010,9 +2992,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 			 */
 			iavf_change_state(adapter, __IAVF_INIT_FAILED);
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
-			mutex_unlock(&adapter->crit_lock);
-			netdev_unlock(netdev);
-			return;
+			msec_delay = IAVF_NO_RESCHED;
+			goto watchdog_done;
 		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
@@ -3030,18 +3011,11 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq,
-				   &adapter->watchdog_task,
-				   msecs_to_jiffies(10));
-		return;
+		msec_delay = 10;
+		goto watchdog_done;
 	case __IAVF_RESETTING:
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   HZ * 2);
-		return;
+		msec_delay = 2000;
+		goto watchdog_done;
 	case __IAVF_DOWN:
 	case __IAVF_DOWN_PENDING:
 	case __IAVF_TESTING:
@@ -3068,9 +3042,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 		break;
 	case __IAVF_REMOVE:
 	default:
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		return;
+		msec_delay = IAVF_NO_RESCHED;
+		goto watchdog_done;
 	}
 
 	/* check for hw reset */
@@ -3080,24 +3053,30 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
-		mutex_unlock(&adapter->crit_lock);
-		netdev_unlock(netdev);
-		queue_delayed_work(adapter->wq,
-				   &adapter->watchdog_task, HZ * 2);
-		return;
+		msec_delay = 2000;
+		goto watchdog_done;
 	}
 
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	netdev_unlock(netdev);
+
+	/* note that we schedule a different task */
 	if (adapter->state >= __IAVF_DOWN)
 		queue_work(adapter->wq, &adapter->adminq_task);
 	if (adapter->aq_required)
-		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   msecs_to_jiffies(20));
+		msec_delay = 20;
 	else
+		msec_delay = 2000;
+	goto skip_unlock;
+watchdog_done:
+	mutex_unlock(&adapter->crit_lock);
+	netdev_unlock(netdev);
+skip_unlock:
+
+	if (msec_delay != IAVF_NO_RESCHED)
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-				   HZ * 2);
+				   msecs_to_jiffies(msec_delay));
 }
 
 /**
-- 
2.39.5



