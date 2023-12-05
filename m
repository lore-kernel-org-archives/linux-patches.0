Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8B16FB0;
	Tue,  5 Dec 2023 03:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4AHGdR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46B5C433C7;
	Tue,  5 Dec 2023 03:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748022;
	bh=nBzscRRM5IxL/b/N6DGgLAoHeV0wn8s3XwYsd12xg9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4AHGdR+65PdbaGrCyCkEPQfK1XfTsctscecTj4DU5J2yn3PIZBopIxJdq8A7FBYZ
	 0sizgDk8seGGvWeNAXAjOFgTIIFqrgPVMXWHq9ca2WB5A0Q+wye3KBDhBhh6kXAED+
	 pSHB+zl2+gLNArcNMxJWnCpb1sdU0PhS6z4kKhFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Quinn Tran <qutran@marvell.com>,
	Daniel Wagner <dwagner@suse.de>,
	Roman Bolshakov <r.bolshakov@yadro.com>,
	Himanshu Madhani <hmadhani@marvell.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 84/94] scsi: qla2xxx: Simplify the code for aborting SCSI commands
Date: Tue,  5 Dec 2023 12:17:52 +0900
Message-ID: <20231205031527.488366282@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c81ef0ed4477c637d1f1dd96ecd8e8fbe18b7283 ]

Since the SCSI core does not reuse the tag of the SCSI command that is
being aborted by .eh_abort() before .eh_abort() has finished it is not
necessary to check from inside that callback whether or not the SCSI
command has already completed. Instead, rely on the firmware to return an
error code when attempting to abort a command that has already
completed. Additionally, rely on the firmware to return an error code when
attempting to abort an already aborted command.

In qla2x00_abort_srb(), use blk_mq_request_started() instead of
sp->completed and sp->aborted.

Link: https://lore.kernel.org/r/20200220043441.20504-2-bvanassche@acm.org
Cc: Martin Wilck <mwilck@suse.com>
Cc: Quinn Tran <qutran@marvell.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 19597cad64d6 ("scsi: qla2xxx: Fix system crash due to bad pointer access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  3 ---
 drivers/scsi/qla2xxx/qla_isr.c |  5 -----
 drivers/scsi/qla2xxx/qla_os.c  | 27 ++++++++++++++-------------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2ef6277244f57..bfddae586995a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -596,9 +596,6 @@ typedef struct srb {
 	struct fc_port *fcport;
 	struct scsi_qla_host *vha;
 	unsigned int start_timer:1;
-	unsigned int abort:1;
-	unsigned int aborted:1;
-	unsigned int completed:1;
 
 	uint32_t handle;
 	uint16_t flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index aca8ec3ff9391..c5021bd1ad5e5 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2479,11 +2479,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
-	if (sp->abort)
-		sp->aborted = 1;
-	else
-		sp->completed = 1;
-
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
 		ql_dbg(ql_dbg_io, vha, 0x3015,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 57f8d2378f778..8329b80c41eb7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1243,17 +1243,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return fast_fail_status != SUCCESS ? fast_fail_status : FAILED;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	if (sp->completed) {
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return SUCCESS;
-	}
-
-	if (sp->abort || sp->aborted) {
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return FAILED;
-	}
-
-	sp->abort = 1;
 	sp->comp = &comp;
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
@@ -1661,6 +1650,10 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	return QLA_SUCCESS;
 }
 
+/*
+ * The caller must ensure that no completion interrupts will happen
+ * while this function is in progress.
+ */
 static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 			      unsigned long *flags)
 	__releases(qp->qp_lock_ptr)
@@ -1669,6 +1662,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	DECLARE_COMPLETION_ONSTACK(comp);
 	scsi_qla_host_t *vha = qp->vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	int rval;
 	bool ret_cmd;
 	uint32_t ratov_j;
@@ -1688,7 +1682,6 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		sp->comp = &comp;
-		sp->abort =  1;
 		spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
 
 		rval = ha->isp_ops->abort_command(sp);
@@ -1712,13 +1705,17 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && (!sp->completed || !sp->aborted))
+		if (ret_cmd && blk_mq_request_started(cmd->request))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
 	}
 }
 
+/*
+ * The caller must ensure that no completion interrupts will happen
+ * while this function is in progress.
+ */
 static void
 __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 {
@@ -1776,6 +1773,10 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
 }
 
+/*
+ * The caller must ensure that no completion interrupts will happen
+ * while this function is in progress.
+ */
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
-- 
2.42.0



