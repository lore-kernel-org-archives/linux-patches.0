Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB64AEFA;
	Mon,  1 Apr 2024 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990514; cv=none; b=of2rA4GW7+oNZfy5+bbp74PxqcEAIICNQ3pUEqJjjowIKM4n5o+KEFUhk+212p3e7g4k88reKi0oq5/9I99a76BeXz2h6HbUHIT7xA+H2DuVuceWUQvLmWhEvevCgAF0V85Pgn68zlt8JYoyerPK3xx+4tWm7SJyhNOLMd8SNrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990514; c=relaxed/simple;
	bh=VcHzR4/H9ShUh/SFIz0RdQOXIUIHQ1ay/vYdP8RXXF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRik8Y9KUuSjTMZ1R+gKcfHfzGBQGeeCxkTUDVVFDK8IhOFvJQm4frzT/iIZecsCH+gaM6gWLY+GLb3PxsP9gZIoy12ZRPOuicdzSXnm20g9s7Rd2bwjGWefdkKnAce9nV4KAzRB+LmxE1ypA+pHetrzamNSnW4WtEDYT51VqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzKgAoib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzKgAoib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CFAC43390;
	Mon,  1 Apr 2024 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990514;
	bh=VcHzR4/H9ShUh/SFIz0RdQOXIUIHQ1ay/vYdP8RXXF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzKgAoibhhAoLwY7DVKzhKac5tZZCUWw9cprtfKTy1Qgh/bChLaTElQNMOIsfqHOV
	 hfrOpA1arKoA2d7FsWfK3s6J3Rl52MqQ0elOPQRjFW3N+jG5R/mWd1ENY0dtlk5vxr
	 fWGL8mj+hJa4Y4fKFYK9YeBoHTUehxVDhjGvzYKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 378/396] scsi: qla2xxx: Prevent command send on chip reset
Date: Mon,  1 Apr 2024 17:47:07 +0200
Message-ID: <20240401152559.184273878@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 4895009c4bb72f71f2e682f1e7d2c2d96e482087 upstream.

Currently IOCBs are allowed to push through while chip reset could be in
progress. During chip reset the outstanding_cmds array is cleared
twice. Once when any command on this array is returned as failed and
secondly when the array is initialize to zero. If a command is inserted on
to the array between these intervals, then the command will be lost.  Check
for chip reset before sending IOCB.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-2-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 ++++++--
 drivers/scsi/qla2xxx/qla_iocb.c |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1193,8 +1193,12 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	return rval;
 
 done_free_sp:
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	/*
+	 * use qla24xx_async_gnl_sp_done to purge all pending gnl request.
+	 * kref_put is call behind the scene.
+	 */
+	sp->u.iocb_cmd.u.mbx.in_mb[0] = MBS_COMMAND_ERROR;
+	qla24xx_async_gnl_sp_done(sp, QLA_COMMAND_ERROR);
 	fcport->flags &= ~(FCF_ASYNC_SENT);
 done:
 	fcport->flags &= ~(FCF_ASYNC_ACTIVE);
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2587,6 +2587,33 @@ void
 qla2x00_sp_release(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
+	struct scsi_qla_host *vha = sp->vha;
+
+	switch (sp->type) {
+	case SRB_CT_PTHRU_CMD:
+		/* GPSC & GFPNID use fcport->ct_desc.ct_sns for both req & rsp */
+		if (sp->u.iocb_cmd.u.ctarg.req &&
+			(!sp->fcport ||
+			 sp->u.iocb_cmd.u.ctarg.req != sp->fcport->ct_desc.ct_sns)) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.req,
+			    sp->u.iocb_cmd.u.ctarg.req_dma);
+			sp->u.iocb_cmd.u.ctarg.req = NULL;
+		}
+		if (sp->u.iocb_cmd.u.ctarg.rsp &&
+			(!sp->fcport ||
+			 sp->u.iocb_cmd.u.ctarg.rsp != sp->fcport->ct_desc.ct_sns)) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.rsp,
+			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
+			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+		}
+		break;
+	default:
+		break;
+	}
 
 	sp->free(sp);
 }
@@ -2692,7 +2719,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
 		return -ENOMEM;
@@ -2747,6 +2774,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2756,6 +2784,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
+	qla2x00_free_fcport(fcport);
 
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
@@ -3918,7 +3947,7 @@ qla2x00_start_sp(srb_t *sp)
 		return -EAGAIN;
 	}
 
-	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
+	pkt = qla2x00_alloc_iocbs_ready(sp->qpair, sp);
 	if (!pkt) {
 		rval = -EAGAIN;
 		ql_log(ql_log_warn, vha, 0x700c,


