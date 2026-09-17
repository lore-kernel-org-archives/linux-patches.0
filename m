Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131344ED18A;
	Thu, 17 Sep 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667118; cv=none; b=EgvZbrwqnBWHg+putXTxoBuslbKNNusM8ALcGubc3bfbBi1Jj+E8kc196QrznqOgXWCT1M7xOrp3pooO+QEsr/wCWsDJxP/7sx+sW6UtnPtZ6yOVsNafwRREZ4gMvct0zomKqo4cj5DQhAz/Pz50duFdYKY0jYCMlcqJmU26jrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667118; c=relaxed/simple;
	bh=I4Ul0wiRzSuyOqoKVW1K9qJxwSqR4gbK8Nv0gZaj7ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkPGNbjMkucrASunm+pQCy8o5G3B6g4NDsBss8xdGUYBZMnO2bPvC2rkvyWIGmiEpIawhZ8b/pkKh3UPdyK5D9mfAv16s6/p+hdBOIJp2CKtSOYMsmXfC4LL3WvXAXdn9wbJnDw0d8QckJZrBdb384puwZ59T1/0rR5mxkGWpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq/tacJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq/tacJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CA51F000FF;
	Thu, 17 Sep 2026 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667116;
	bh=abF+R5hOdCal9aF56aCrL1/INsCHWw0d5tsN0/R2jtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vq/tacJEMIYBVNNtI+GXOtoH3I2Q2Z2uj/mjO6tksEz0Xmm9YsUYd9+2HQ7Ouvbjt
	 D4G9k6BKqCLdfXvN2t3HQjGZ19/rf8AB+ndQwBjetmixJ5J6g3yrbaPLBNfDoE9DLu
	 AnLRQ1gw5YFJPv/SdfwtI+te8HH4gd7xOg04+zj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1235/1250] Reapply "bnxt_en: bring back rtnl_lock() in the bnxt_open() path"
Date: Thu, 17 Sep 2026 16:17:10 +0100
Message-ID: <20260917151625.768237005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b6197b386677ae5268d4702e23849d9ad53051ad ]

This reverts commit 850d9248d2eac662f869c766a598c877690c74e5.
This reapplies commit 325eb217e41f ("bnxt_en: bring back rtnl_lock()
in the bnxt_open() path").

Breno reports a lockdep warning in bnxt. During FW reset the driver
may end up calling netif_set_real_num_tx_queues() (if queue count
changes), so calls to bnxt_open() still require rtnl_lock.

  net/sched/sch_generic.c:1416 suspicious rcu_dereference_protected() usage!

   dev_qdisc_change_real_num_tx+0x54/0xe0
   netif_set_real_num_tx_queues+0x4ed/0xa80
   __bnxt_open_nic+0x9cb/0x3490
   bnxt_open+0x1cb/0x370
   bnxt_fw_reset_task+0x80d/0x1e80
   process_scheduled_works+0x9c1/0x13b0

The reverted commit was just an optimization / experiment
so let's go back to taking the lock.

Reported-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/ah726OtFX-Qw3U-R@gmail.com
Fixes: 850d9248d2ea ("Revert "bnxt_en: bring back rtnl_lock() in the bnxt_open() path"")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260603195845.2574426-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Stable adaptation for dependency of 961e2a17c5e3559b3f8654d2daabdd25a42e770a:
Keep this branch's two-argument bnxt_ulp_start() calls, including error
notifications, and release RTNL before invoking them.

Reuse and rename the existing service-task lock/unlock helpers to add
RTNL coverage without adding functions. Inline their original netdev-only
operations in bnxt_fw_exception() and bnxt_fw_reset() so those paths keep
their existing locking and BNXT_STATE_IN_SP_TASK ordering. The RX reset
path then provides the bnxt_rtnl_unlock_sp() required by the target's
buffer-allocation failure handling.

Stable-dep-of: 961e2a17c5e3 ("bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   44 +++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -14283,31 +14283,32 @@ bnxt_restart_timer:
 	mod_timer(&bp->timer, jiffies + bp->current_interval);
 }
 
-static void bnxt_lock_sp(struct bnxt *bp)
+static void bnxt_rtnl_lock_sp(struct bnxt *bp)
 {
 	/* We are called from bnxt_sp_task which has BNXT_STATE_IN_SP_TASK
 	 * set.  If the device is being closed, bnxt_close() may be holding
-	 * netdev instance lock and waiting for BNXT_STATE_IN_SP_TASK to clear.
-	 * So we must clear BNXT_STATE_IN_SP_TASK before holding netdev
-	 * instance lock.
+	 * RTNL and the netdev instance lock while waiting for
+	 * BNXT_STATE_IN_SP_TASK to clear.  Clear it before taking either lock.
 	 */
 	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	rtnl_lock();
 	netdev_lock(bp->dev);
 }
 
-static void bnxt_unlock_sp(struct bnxt *bp)
+static void bnxt_rtnl_unlock_sp(struct bnxt *bp)
 {
 	set_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
 	netdev_unlock(bp->dev);
+	rtnl_unlock();
 }
 
 /* Only called from bnxt_sp_task() */
 static void bnxt_reset(struct bnxt *bp, bool silent)
 {
-	bnxt_lock_sp(bp);
+	bnxt_rtnl_lock_sp(bp);
 	if (test_bit(BNXT_STATE_OPEN, &bp->state))
 		bnxt_reset_task(bp, silent);
-	bnxt_unlock_sp(bp);
+	bnxt_rtnl_unlock_sp(bp);
 }
 
 /* Only called from bnxt_sp_task() */
@@ -14315,9 +14316,9 @@ static void bnxt_rx_ring_reset(struct bn
 {
 	int i;
 
-	bnxt_lock_sp(bp);
+	bnxt_rtnl_lock_sp(bp);
 	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
-		bnxt_unlock_sp(bp);
+		bnxt_rtnl_unlock_sp(bp);
 		return;
 	}
 	/* Disable and flush TPA before resetting the RX ring */
@@ -14356,7 +14357,7 @@ static void bnxt_rx_ring_reset(struct bn
 	}
 	if (bp->flags & BNXT_FLAG_TPA)
 		bnxt_set_tpa(bp, true);
-	bnxt_unlock_sp(bp);
+	bnxt_rtnl_unlock_sp(bp);
 }
 
 static void bnxt_fw_fatal_close(struct bnxt *bp)
@@ -14455,9 +14456,11 @@ void bnxt_fw_exception(struct bnxt *bp)
 	netdev_warn(bp->dev, "Detected firmware fatal condition, initiating reset\n");
 	set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 	bnxt_ulp_stop(bp);
-	bnxt_lock_sp(bp);
+	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	netdev_lock(bp->dev);
 	bnxt_force_fw_reset(bp);
-	bnxt_unlock_sp(bp);
+	set_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	netdev_unlock(bp->dev);
 }
 
 /* Returns the number of registered VFs, or 1 if VF configuration is pending, or
@@ -14487,7 +14490,8 @@ static int bnxt_get_registered_vfs(struc
 void bnxt_fw_reset(struct bnxt *bp)
 {
 	bnxt_ulp_stop(bp);
-	bnxt_lock_sp(bp);
+	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	netdev_lock(bp->dev);
 	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
 	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 		struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -14533,7 +14537,8 @@ void bnxt_fw_reset(struct bnxt *bp)
 		bnxt_queue_fw_reset_work(bp, tmo);
 	}
 fw_reset_exit:
-	bnxt_unlock_sp(bp);
+	set_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	netdev_unlock(bp->dev);
 }
 
 static void bnxt_chk_missed_irq(struct bnxt *bp)
@@ -15269,15 +15274,17 @@ static void bnxt_fw_reset_task(struct wo
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_OPENING;
 		fallthrough;
 	case BNXT_FW_RESET_STATE_OPENING:
-		while (!netdev_trylock(bp->dev)) {
+		while (!rtnl_trylock()) {
 			bnxt_queue_fw_reset_work(bp, HZ / 10);
 			return;
 		}
+		netdev_lock(bp->dev);
 		rc = bnxt_open(bp->dev);
 		if (rc) {
 			netdev_err(bp->dev, "bnxt_open() failed during FW reset\n");
 			bnxt_fw_reset_abort(bp, rc);
 			netdev_unlock(bp->dev);
+			rtnl_unlock();
 			goto ulp_start;
 		}
 
@@ -15297,6 +15304,7 @@ static void bnxt_fw_reset_task(struct wo
 			bnxt_dl_health_fw_status_update(bp, true);
 		}
 		netdev_unlock(bp->dev);
+		rtnl_unlock();
 		bnxt_ulp_start(bp, 0);
 		bnxt_reenable_sriov(bp);
 		netdev_lock(bp->dev);
@@ -16292,7 +16300,7 @@ err_reset:
 		   rc);
 	napi_enable_locked(&bnapi->napi);
 	bnxt_db_nq_arm(bp, &cpr->cp_db, cpr->cp_raw_cons);
-	bnxt_reset_task(bp, true);
+	netif_close(dev);
 	return rc;
 }
 
@@ -17120,6 +17128,7 @@ static int bnxt_resume(struct device *de
 	struct bnxt *bp = netdev_priv(dev);
 	int rc = 0;
 
+	rtnl_lock();
 	netdev_lock(dev);
 	rc = pci_enable_device(bp->pdev);
 	if (rc) {
@@ -17164,6 +17173,7 @@ static int bnxt_resume(struct device *de
 
 resume_exit:
 	netdev_unlock(bp->dev);
+	rtnl_unlock();
 	bnxt_ulp_start(bp, rc);
 	if (!rc)
 		bnxt_reenable_sriov(bp);
@@ -17329,6 +17339,7 @@ static void bnxt_io_resume(struct pci_de
 	int err;
 
 	netdev_info(bp->dev, "PCI Slot Resume\n");
+	rtnl_lock();
 	netdev_lock(netdev);
 
 	err = bnxt_hwrm_func_qcaps(bp);
@@ -17346,6 +17357,7 @@ static void bnxt_io_resume(struct pci_de
 		netif_device_attach(netdev);
 
 	netdev_unlock(netdev);
+	rtnl_unlock();
 	bnxt_ulp_start(bp, err);
 	if (!err)
 		bnxt_reenable_sriov(bp);


