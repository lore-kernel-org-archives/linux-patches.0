Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E174646EC8E;
	Tue, 21 Jul 2026 19:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662007; cv=none; b=WkHXyxP2ENGuU+P9y9HRV7g9XiU4jZdG2KBZX3X5HhdTIe1gDDZ1p0rw+t/OtFv3ifFWFbgx2fPfj5NLmN9WXjiqH1ZDXR+yF/QCmlwLuUktgPfsJgb2JUhzQGzMscM1Z11nZGD2nzMK3zHPiSYxiyLG8AH9vzjFH82CfW7bvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662007; c=relaxed/simple;
	bh=GNmj+9SSQX23UXpn67Ex0gzJji06d0EMG7qzRYEhPlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkM42CbbtaXmjDuxS2wXAG06lt+P8lgFYBnr7qYqY9zEFHBtVbHtDg1Dp6WM7ZNnkxO+btayZXaHiBtoGtpkWQSES5Xnj2L+PcPDH7pRu66vhw+WWqq0/N6cu0VjJhiVy8LpZfP7Piopg58Rv7l1jKQ3NQ0Sdm8HWWYqNhYfNmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOq5J2aD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOq5J2aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C721F000E9;
	Tue, 21 Jul 2026 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662005;
	bh=OLYX+dS4S8RTb0FPVvO+WKYfb4K+uC7f1bLjhCICXPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOq5J2aDnGI93xAhkTFcL1xmiBO8gQBKBtYGd2JeDlZL6OkW4WzRDNro6eVgPXenw
	 VNorf7ITvz4wJ400BcsnZcpu/dPbjqmUJGusbzD4fExg8QVv8citVSfcjhJQ2XmUFA
	 uedFXsZp/dA1NFgvu53H3uzeHaCTMXa4HWfPi4P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0274/1276] scsi: target: Remove tcm_loop target reset handling
Date: Tue, 21 Jul 2026 17:11:57 +0200
Message-ID: <20260721152452.211193569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 7c08d430835a90414cd962e3a9602e5b002dee3b ]

tcm_loop_target_reset is supposed to handle all the LUNs on a target but
it's only doing a TMR_LUN_RESET so only that one LUN is handled.  This
will cause us to return early while IOs to other LUNs are still hung in
lower layers. This just removes the target reset handler for the driver
because LIO doesn't support target resets and for the common case where
this is run from the scsi-ml error hamdler we have already tried an
abort and lun reset so waiting again is most likely useless.

Fixes: 1333eee56cdf ("scsi: target: tcm_loop: Drain commands in target_reset handler")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260530052349.5134-1-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/loopback/tcm_loop.c | 64 ------------------------------
 1 file changed, 64 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 1d1043cc649cdd..31b2563fee5e00 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -268,69 +268,6 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-static bool tcm_loop_flush_work_iter(struct request *rq, void *data)
-{
-	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(rq);
-	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
-	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
-
-	flush_work(&se_cmd->work);
-	return true;
-}
-
-static int tcm_loop_target_reset(struct scsi_cmnd *sc)
-{
-	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_tpg *tl_tpg;
-	struct Scsi_Host *sh = sc->device->host;
-	int ret;
-
-	/*
-	 * Locate the tcm_loop_hba_t pointer
-	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sh);
-	if (!tl_hba) {
-		pr_err("Unable to perform device reset without active I_T Nexus\n");
-		return FAILED;
-	}
-	/*
-	 * Locate the tl_tpg pointer from TargetID in sc->device->id
-	 */
-	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	if (!tl_tpg)
-		return FAILED;
-
-	/*
-	 * Issue a LUN_RESET to drain all commands that the target core
-	 * knows about.  This handles commands not yet marked CMD_T_COMPLETE.
-	 */
-	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun, 0, TMR_LUN_RESET);
-	if (ret != TMR_FUNCTION_COMPLETE)
-		return FAILED;
-
-	/*
-	 * Flush any deferred target core completion work that may still be
-	 * queued.  Commands that already had CMD_T_COMPLETE set before the TMR
-	 * are skipped by the TMR drain, but their async completion work
-	 * (transport_lun_remove_cmd → percpu_ref_put, release_cmd → scsi_done)
-	 * may still be pending in target_completion_wq.
-	 *
-	 * The SCSI EH will reuse in-flight scsi_cmnd structures for recovery
-	 * commands (e.g. TUR) immediately after this handler returns SUCCESS —
-	 * if deferred work is still pending, the memset in queuecommand would
-	 * zero the se_cmd while the work accesses it, leaking the LUN
-	 * percpu_ref and hanging configfs unlink forever.
-	 *
-	 * Use blk_mq_tagset_busy_iter() to find all started requests and
-	 * flush_work() on each — the same pattern used by mpi3mr, scsi_debug,
-	 * and other SCSI drivers to drain outstanding commands during reset.
-	 */
-	blk_mq_tagset_busy_iter(&sh->tag_set, tcm_loop_flush_work_iter, NULL);
-
-	tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
-	return SUCCESS;
-}
-
 static const struct scsi_host_template tcm_loop_driver_template = {
 	.show_info		= tcm_loop_show_info,
 	.proc_name		= "tcm_loopback",
@@ -339,7 +276,6 @@ static const struct scsi_host_template tcm_loop_driver_template = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
-	.eh_target_reset_handler = tcm_loop_target_reset,
 	.this_id		= -1,
 	.sg_tablesize		= 256,
 	.max_sectors		= 0xFFFF,
-- 
2.53.0



