Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8CB2FA647;
	Tue, 17 Jun 2025 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178929; cv=none; b=grRdSdhxKoi28XAr5p3fZMgehDGeVdVSU761AYV5sim4qqDABuI9VGs+pyluHg733P1DXNDuwscTr6XeawwBJfoC2vgMpGd1rf7apIB6zYztuh9zZPEQSCGdCbt0Y8Bi1cJXgkUEBPYlao5154QJDiX+beH5bT7k9bObG7JHJoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178929; c=relaxed/simple;
	bh=94VeyV42tieT1UXpXWaYllR2Lr2nqkZo50JoftFINmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6pIZwgTuGn5RdwWVlKpw+JJuA+SIzOG11Q/4esoDalQMnrsRrL4C4otdSGjt2jZuJE0sH3K/dsf2jFj+s6Dv5mjLzfIZ14g227VyfteIndKFiYWyxT6ZRDE7fGQbJNnz0rB2O7qwuglZ30TVlN7MUU1GzUYYgf+CeNUFLjm1eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tshTbSmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tshTbSmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE51C4CEE3;
	Tue, 17 Jun 2025 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178929;
	bh=94VeyV42tieT1UXpXWaYllR2Lr2nqkZo50JoftFINmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tshTbSmOWcKlHqW8Q5oSDDoMYRpGnxJBpeXkDZaa0RSTQr6MWD5y5YzdOoDyn/QiY
	 +5KJLto/Aj1teoisZRZ4icXx9euS5558RiuG09c2thXTRkmp7CAHc9jhPNnETMzFmC
	 xBv58rYvN4en7nR9RLLd9NHHVMRrsPiOMmfrPvLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 595/780] iavf: extract iavf_watchdog_step() out of iavf_watchdog_task()
Date: Tue, 17 Jun 2025 17:25:03 +0200
Message-ID: <20250617152515.719072484@linuxfoundation.org>
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

[ Upstream commit 257a8241ad7f4dc312494f69e3bc79a5598b4514 ]

Finish up easy refactor of watchdog_task, total for this + prev two
commits is:
 1 file changed, 47 insertions(+), 82 deletions(-)

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 120f28a6f314 ("iavf: get rid of the crit lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 87 +++++++++------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5efe44724d112..4b6963ffaba5f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2913,30 +2913,14 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 
 static const int IAVF_NO_RESCHED = -1;
 
-/**
- * iavf_watchdog_task - Periodic call-back task
- * @work: pointer to work_struct
- **/
-static void iavf_watchdog_task(struct work_struct *work)
+/* return: msec delay for requeueing itself */
+static int iavf_watchdog_step(struct iavf_adapter *adapter)
 {
-	struct iavf_adapter *adapter = container_of(work,
-						    struct iavf_adapter,
-						    watchdog_task.work);
-	struct net_device *netdev = adapter->netdev;
 	struct iavf_hw *hw = &adapter->hw;
-	int msec_delay;
 	u32 reg_val;
 
-	netdev_lock(netdev);
-	if (!mutex_trylock(&adapter->crit_lock)) {
-		if (adapter->state == __IAVF_REMOVE) {
-			netdev_unlock(netdev);
-			return;
-		}
-
-		msec_delay = 20;
-		goto restart_watchdog;
-	}
+	netdev_assert_locked(adapter->netdev);
+	lockdep_assert_held(&adapter->crit_lock);
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
@@ -2944,24 +2928,19 @@ static void iavf_watchdog_task(struct work_struct *work)
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
 		iavf_startup(adapter);
-		msec_delay = 30;
-		goto watchdog_done;
+		return 30;
 	case __IAVF_INIT_VERSION_CHECK:
 		iavf_init_version_check(adapter);
-		msec_delay = 30;
-		goto watchdog_done;
+		return 30;
 	case __IAVF_INIT_GET_RESOURCES:
 		iavf_init_get_resources(adapter);
-		msec_delay = 1;
-		goto watchdog_done;
+		return 1;
 	case __IAVF_INIT_EXTENDED_CAPS:
 		iavf_init_process_extended_caps(adapter);
-		msec_delay = 1;
-		goto watchdog_done;
+		return 1;
 	case __IAVF_INIT_CONFIG_ADAPTER:
 		iavf_init_config_adapter(adapter);
-		msec_delay = 1;
-		goto watchdog_done;
+		return 1;
 	case __IAVF_INIT_FAILED:
 		if (test_bit(__IAVF_IN_REMOVE_TASK,
 			     &adapter->crit_section)) {
@@ -2969,21 +2948,18 @@ static void iavf_watchdog_task(struct work_struct *work)
 			 * watchdog task, iavf_remove should handle this state
 			 * as it can loop forever
 			 */
-			msec_delay = IAVF_NO_RESCHED;
-			goto watchdog_done;
+			return IAVF_NO_RESCHED;
 		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 			dev_err(&adapter->pdev->dev,
 				"Failed to communicate with PF; waiting before retry\n");
 			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 			iavf_shutdown_adminq(hw);
-			msec_delay = 5000;
-			goto watchdog_done;
+			return 5000;
 		}
 		/* Try again from failed step*/
 		iavf_change_state(adapter, adapter->last_state);
-		msec_delay = 1000;
-		goto watchdog_done;
+		return 1000;
 	case __IAVF_COMM_FAILED:
 		if (test_bit(__IAVF_IN_REMOVE_TASK,
 			     &adapter->crit_section)) {
@@ -2993,8 +2969,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			 */
 			iavf_change_state(adapter, __IAVF_INIT_FAILED);
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
-			msec_delay = IAVF_NO_RESCHED;
-			goto watchdog_done;
+			return IAVF_NO_RESCHED;
 		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
@@ -3012,11 +2987,9 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		msec_delay = 10;
-		goto watchdog_done;
+		return 10;
 	case __IAVF_RESETTING:
-		msec_delay = 2000;
-		goto watchdog_done;
+		return 2000;
 	case __IAVF_DOWN:
 	case __IAVF_DOWN_PENDING:
 	case __IAVF_TESTING:
@@ -3043,8 +3016,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		break;
 	case __IAVF_REMOVE:
 	default:
-		msec_delay = IAVF_NO_RESCHED;
-		goto watchdog_done;
+		return IAVF_NO_RESCHED;
 	}
 
 	/* check for hw reset */
@@ -3055,12 +3027,31 @@ static void iavf_watchdog_task(struct work_struct *work)
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
 	}
-	if (adapter->aq_required)
+
+	return adapter->aq_required ? 20 : 2000;
+}
+
+static void iavf_watchdog_task(struct work_struct *work)
+{
+	struct iavf_adapter *adapter = container_of(work,
+						    struct iavf_adapter,
+						    watchdog_task.work);
+	struct net_device *netdev = adapter->netdev;
+	int msec_delay;
+
+	netdev_lock(netdev);
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE) {
+			netdev_unlock(netdev);
+			return;
+		}
+
 		msec_delay = 20;
-	else
-		msec_delay = 2000;
+		goto restart_watchdog;
+	}
+
+	msec_delay = iavf_watchdog_step(adapter);
 
-watchdog_done:
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	netdev_unlock(netdev);
-- 
2.39.5



