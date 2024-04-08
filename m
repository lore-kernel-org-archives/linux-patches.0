Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7D07EF14;
	Mon,  8 Apr 2024 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584895; cv=none; b=TMQCfvHYHgvxnOeG8A0xQTFJTT3/bWTfABDOtNlRlyxXhQGpSDM/0cGwdlIq4Srx8gb5DZywQP0//RTZKoatiOKsSqIbROb7+WB11cUfrv1Q+XSkptoRV4YXF9ldOUXgNMHDCV7nWOIIuq+/abmW9ioa7nmE96NxD4rMcYHG4as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584895; c=relaxed/simple;
	bh=7Xq9nfBIm5wvVZgEgavrXSnldBFS0Zj6iN9GpK3GDBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+xr3KpZ6Xkf6b9foFHOw+FLfYsnU9/EghZmpl6ggX7bykYKTmoQGmF/F0xtz2rBwK0m5pr1otp42ToRwXoHIhvn4toArNEBalkZCLnNNdT5MKEI0ELdOZaS5C/ntFKbaXjSDjtaV81ikz1QqBd5TZLi7ZpsSU+1jvF241p3/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwr1bp1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwr1bp1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA96C433C7;
	Mon,  8 Apr 2024 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584894;
	bh=7Xq9nfBIm5wvVZgEgavrXSnldBFS0Zj6iN9GpK3GDBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwr1bp1kPtf1QC9hdIxzqpw07z27aWLc4gEfuK730ZjBs5422UfWsUU/Wr+KGYWZx
	 TbQrreh8g2np+PoEw4s90zq2WXGo/P0uFJ7j77Di55r8zKiXd0tAlBFMvwBYolcdK7
	 l+8tGtnBD04av2mAOD/S8ACFPKONsZY7WC4d8zhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 594/690] scsi: qla2xxx: Prevent command send on chip reset
Date: Mon,  8 Apr 2024 14:57:40 +0200
Message-ID: <20240408125421.110670135@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1188,8 +1188,12 @@ int qla24xx_async_gnl(struct scsi_qla_ho
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
@@ -2588,6 +2588,33 @@ void
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
@@ -2693,7 +2720,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
 		return -ENOMEM;
@@ -2748,6 +2775,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2757,6 +2785,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
+	qla2x00_free_fcport(fcport);
 
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
@@ -3916,7 +3945,7 @@ qla2x00_start_sp(srb_t *sp)
 		return -EAGAIN;
 	}
 
-	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
+	pkt = qla2x00_alloc_iocbs_ready(sp->qpair, sp);
 	if (!pkt) {
 		rval = -EAGAIN;
 		ql_log(ql_log_warn, vha, 0x700c,


