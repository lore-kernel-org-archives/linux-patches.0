Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAB248F57;
	Tue, 21 Jul 2026 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649396; cv=none; b=ZC1zNslFhZlvOLlr3AxtrAAh9RlBnjQk8SDIUhZOZfcT2yqot2vw2LXvQ0b2qTzVYBWM+Hbbz1dypTar97qYIeEp/+A+gXKxo3bOzuGPunkyg93vodxpeItj7e/JI39AHIB+QSy7okIWWSmz6M412cC5yVEw5XuFg5iQuoWxFL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649396; c=relaxed/simple;
	bh=q9cOfI2nkbQ4PB6pDVHLtaBgCGJCsFW45sAaOSyXHrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAmQarL/DwZ+ULJ/JLhpU+yp55S3vowC0b3I283f58u9h923mpJFiinxmRVw/OnVlEtijg7oWMpcPay5KPH/0doklJtfJTEsmM9Jcij7YkKnZiyzMCvoqfg9tj1xBW8SHtDYAdLeAmIiFoqtfUIuzXU4hEuc/xN3szLs/rqnLNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDDH7Ar/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDDH7Ar/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADEE1F000E9;
	Tue, 21 Jul 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649395;
	bh=3GdQoXCK2jh+nCfeXHjgkOT4hl6QcA+LkO82VHf6ALk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDDH7Ar/Ac5TxJVS3T9lSfJ325BWvqOYcM13Jj9nffDZvE0z0zLTal+kLUeojDLXb
	 e0wrjuCCXSPdc6AaQmgHFEUiueqhR089/a2f7qcVqTvam7lzC6FBsGUcXTaMIQcZBn
	 rD9YKQkjOMh840Jg3IQSInzGZtZ1EpOfUtmMwhjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjie Fang <hongjiefang@asrmicro.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0563/2077] scsi: ufs: core: Handle PM commands timeout before SCSI EH
Date: Tue, 21 Jul 2026 17:03:56 +0200
Message-ID: <20260721152606.090221806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongjie Fang <hongjiefang@asrmicro.com>

[ Upstream commit 01d5e237b33931b970dd190dd6a19c5ef32c105d ]

A PM START STOP sent from the UFS well-known LU resume path can race
with SCSI EH:

The "wl resume" task flow is:
  __ufshcd_wl_resume()
    ufshcd_set_dev_pwr_mode(UFS_ACTIVE_PWR_MODE)
      ufshcd_execute_start_stop()
        scsi_execute_cmd()
          blk_execute_rq           <-- wait
          scsi_check_passthrough() <-- may retry START STOP

If the first START STOP time out, SCSI EH may already recover the link and
reset the device before scsi_execute_cmd() returns:

  scsi_timeout()
    scsi_eh_scmd_add()
      scsi_error_handler()
        scsi_unjam_host()
          scsi_eh_ready_devs()
            scsi_eh_host_reset()
              ufshcd_eh_host_reset_handler()
                if (hba->pm_op_in_progress)
                  ufshcd_link_recovery()
                    ufshcd_device_reset()
                    ufshcd_host_reset_and_restore()
          ...
          scsi_eh_flush_done_q()   <-- wakeup "wl resume" task
        ...                        <-- host still in SHOST_RECOVERY
        scsi_restart_operations()

A later passthrough retry can then run while the host is still in
SHOST_RECOVERY and hit the SCMD_FAIL_IF_RECOVERING path:

  scsi_queue_rq()
    if (scsi_host_in_recovery(shost) &&
        cmd->flags & SCMD_FAIL_IF_RECOVERING)
      return BLK_STS_OFFLINE

That retry completes with DID_ERROR or DID_NO_CONNECT even though EH may
already have restored the device to an operational ACTIVE state.

Handle these PM timeouts directly from ufshcd_eh_timed_out() instead.
After ufshcd_link_recovery(), complete the timed-out command immediately
if it has not been completed already.

For regular SCSI commands, complete them with DID_REQUEUE to match the
existing MCQ force-completion semantics and allow scsi_execute_cmd() to
retry if needed. For reserved internal device-management commands,
finish the request with DID_TIME_OUT without calling
ufshcd_release_scsi_cmd() since those commands use different resource
lifetime rules.

The system_suspending flag is no longer needed because PM command
timeout handling now uses pm_op_in_progress.

Fixes: b8c3a7bac9b6 ("scsi: ufs: Have midlayer retry start stop errors")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260605112034.3802540-1-hongjiefang@asrmicro.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 34 +++++++++++++++++++++++++++-------
 include/ufs/ufshcd.h      |  3 ---
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 385e1a8eec1620..84e32957c332d1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9466,22 +9466,44 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct ufs_hba *hba = shost_priv(scmd->device->host);
 
-	if (!hba->system_suspending) {
+	if (!hba->pm_op_in_progress) {
 		/* Activate the error handler in the SCSI core. */
 		return SCSI_EH_NOT_HANDLED;
 	}
 
 	/*
-	 * If we get here we know that no TMFs are outstanding and also that
-	 * the only pending command is a START STOP UNIT command. Handle the
-	 * timeout of that command directly to prevent a deadlock between
+	 * Handle the timeout directly to prevent a deadlock between
 	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
 	 */
 	ufshcd_link_recovery(hba);
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	/*
+	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
+	 * the existing MCQ force-completion path.
+	 */
+	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
+		if (!hba->mcq_enabled) {
+			unsigned long flags;
+			struct request *rq = scsi_cmd_to_rq(scmd);
+
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			__clear_bit(rq->tag, &hba->outstanding_reqs);
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+		}
+
+		if (ufshcd_is_scsi_cmd(scmd)) {
+			set_host_byte(scmd, DID_REQUEUE);
+			ufshcd_release_scsi_cmd(hba, scmd);
+		} else {
+			set_host_byte(scmd, DID_TIME_OUT);
+		}
+
+		scsi_done(scmd);
+	}
+
+	return SCSI_EH_DONE;
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
@@ -10518,7 +10540,6 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 	down(&hba->host_sem);
-	hba->system_suspending = true;
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -10560,7 +10581,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = false;
-	hba->system_suspending = false;
 	up(&hba->host_sem);
 	return ret;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df8364..8280a95c00c74d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1020,8 +1020,6 @@ enum ufshcd_mcq_opr {
  * @caps: bitmask with information about UFS controller capabilities
  * @devfreq: frequency scaling information owned by the devfreq core
  * @clk_scaling: frequency scaling information owned by the UFS driver
- * @system_suspending: system suspend has been started and system resume has
- *	not yet finished.
  * @is_sys_suspended: UFS device has been suspended because of system suspend
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
@@ -1197,7 +1195,6 @@ struct ufs_hba {
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
-	bool system_suspending;
 	bool is_sys_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
-- 
2.53.0



