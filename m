Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9802D3ACF11;
	Wed,  8 Apr 2026 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672814; cv=none; b=OmSLxKcPxNkwg76aTrAYKBlCGJEf6H3wAF7cVAN98XwlWhRQS0HITUcFRhnGJH4SgU1bWxacaq2MJfNQr9CE5z51ak87CBoDLWEQ5COqFYqMV3M+iJi+14jIIWmCVG+sg+Z1IvcW+cwzX1cR/LvYhwTPlm8Ffhy+4UDIEn0rjsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672814; c=relaxed/simple;
	bh=f9jGX6B7gR33fj3knA3HHMeBpTKtCgKJp92p2W67onM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beP/UuU3aQVYQQ6ZvkEnOEVFaJRkhtro1nYdoO1tDcM/sBOrD5UAprCev5efRhP2FxJ9tjNp3336RtcRK2KWLE/EwaXX2kCCFd6hyYkK0ERW7YN2DNIZl7FlsUM3DmHRN3PV73mGNLUW6FCbhlYNkyj+Q4pyAYJcnkSvYdSX/Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpO6o0RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpO6o0RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D710EC19421;
	Wed,  8 Apr 2026 18:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672814;
	bh=f9jGX6B7gR33fj3knA3HHMeBpTKtCgKJp92p2W67onM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpO6o0RXQCwyx8TTl61ijt7os9UBFNz53Db2oBQmhJEsdAKcT5yW1U8Pwp/sfPq8A
	 XWg9SKNhcDCyg+dAZaaC7FLsx8A+jD/kczor6kpxHRuxn1yFkE59O26BLsVrtDZXI4
	 7OSRmTCHEU4Vo5py5YeGtEmEXC3PgTzWvbE8c0vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/160] scsi: target: tcm_loop: Drain commands in target_reset handler
Date: Wed,  8 Apr 2026 20:03:59 +0200
Message-ID: <20260408175918.873188289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1333eee56cdf3f0cf67c6ab4114c2c9e0a952026 ]

tcm_loop_target_reset() violates the SCSI EH contract: it returns SUCCESS
without draining any in-flight commands.  The SCSI EH documentation
(scsi_eh.rst) requires that when a reset handler returns SUCCESS the driver
has made lower layers "forget about timed out scmds" and is ready for new
commands.  Every other SCSI LLD (virtio_scsi, mpt3sas, ipr, scsi_debug,
mpi3mr) enforces this by draining or completing outstanding commands before
returning SUCCESS.

Because tcm_loop_target_reset() doesn't drain, the SCSI EH reuses in-flight
scsi_cmnd structures for recovery commands (e.g. TUR) while the target core
still has async completion work queued for the old se_cmd.  The memset in
queuecommand zeroes se_lun and lun_ref_active, causing
transport_lun_remove_cmd() to skip its percpu_ref_put().  The leaked LUN
reference prevents transport_clear_lun_ref() from completing, hanging
configfs LUN unlink forever in D-state:

  INFO: task rm:264 blocked for more than 122 seconds.
  rm              D    0   264    258 0x00004000
  Call Trace:
   __schedule+0x3d0/0x8e0
   schedule+0x36/0xf0
   transport_clear_lun_ref+0x78/0x90 [target_core_mod]
   core_tpg_remove_lun+0x28/0xb0 [target_core_mod]
   target_fabric_port_unlink+0x50/0x60 [target_core_mod]
   configfs_unlink+0x156/0x1f0 [configfs]
   vfs_unlink+0x109/0x290
   do_unlinkat+0x1d5/0x2d0

Fix this by making tcm_loop_target_reset() actually drain commands:

 1. Issue TMR_LUN_RESET via tcm_loop_issue_tmr() to drain all commands that
    the target core knows about (those not yet CMD_T_COMPLETE).

 2. Use blk_mq_tagset_busy_iter() to iterate all started requests and
    flush_work() on each se_cmd — this drains any deferred completion work
    for commands that already had CMD_T_COMPLETE set before the TMR (which
    the TMR skips via __target_check_io_state()).  This is the same pattern
    used by mpi3mr, scsi_debug, and libsas to drain outstanding commands
    during reset.

Fixes: e0eb5d38b732 ("scsi: target: tcm_loop: Use block cmd allocator for se_cmds")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/27011aa34c8f6b1b94d2e3cf5655b6d037f53428.1773706803.git.josef@toxicpanda.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/loopback/tcm_loop.c |   52 ++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/configfs.h>
+#include <linux/blk-mq.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_host.h>
@@ -267,15 +268,27 @@ static int tcm_loop_device_reset(struct
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
+static bool tcm_loop_flush_work_iter(struct request *rq, void *data)
+{
+	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(rq);
+	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
+	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
+
+	flush_work(&se_cmd->work);
+	return true;
+}
+
 static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
+	struct Scsi_Host *sh = sc->device->host;
+	int ret;
 
 	/*
 	 * Locate the tcm_loop_hba_t pointer
 	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(sh);
 	if (!tl_hba) {
 		pr_err("Unable to perform device reset without active I_T Nexus\n");
 		return FAILED;
@@ -284,11 +297,38 @@ static int tcm_loop_target_reset(struct
 	 * Locate the tl_tpg pointer from TargetID in sc->device->id
 	 */
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	if (tl_tpg) {
-		tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
-		return SUCCESS;
-	}
-	return FAILED;
+	if (!tl_tpg)
+		return FAILED;
+
+	/*
+	 * Issue a LUN_RESET to drain all commands that the target core
+	 * knows about.  This handles commands not yet marked CMD_T_COMPLETE.
+	 */
+	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun, 0, TMR_LUN_RESET);
+	if (ret != TMR_FUNCTION_COMPLETE)
+		return FAILED;
+
+	/*
+	 * Flush any deferred target core completion work that may still be
+	 * queued.  Commands that already had CMD_T_COMPLETE set before the TMR
+	 * are skipped by the TMR drain, but their async completion work
+	 * (transport_lun_remove_cmd → percpu_ref_put, release_cmd → scsi_done)
+	 * may still be pending in target_completion_wq.
+	 *
+	 * The SCSI EH will reuse in-flight scsi_cmnd structures for recovery
+	 * commands (e.g. TUR) immediately after this handler returns SUCCESS —
+	 * if deferred work is still pending, the memset in queuecommand would
+	 * zero the se_cmd while the work accesses it, leaking the LUN
+	 * percpu_ref and hanging configfs unlink forever.
+	 *
+	 * Use blk_mq_tagset_busy_iter() to find all started requests and
+	 * flush_work() on each — the same pattern used by mpi3mr, scsi_debug,
+	 * and other SCSI drivers to drain outstanding commands during reset.
+	 */
+	blk_mq_tagset_busy_iter(&sh->tag_set, tcm_loop_flush_work_iter, NULL);
+
+	tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
+	return SUCCESS;
 }
 
 static const struct scsi_host_template tcm_loop_driver_template = {


