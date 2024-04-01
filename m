Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04D01CA8F;
	Mon,  1 Apr 2024 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987740; cv=none; b=I5AlXa/6jFC45HoX3tqRpJiFsXtieZjGA2l1wt5bUdxaLIXm4kxUUs3LaQd3UUYW2UCe6sUZbxN5/teBWsE3roT68gSrORKdb7UYtuJyaJyfXZtaJ6eNlAYG3UaebdUo2Hif5U6bOX/jjra6k4J4Cx2heN7Ya+iKmOe086ZwC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987740; c=relaxed/simple;
	bh=Sz0Kend4wYD2kKjq7dBH/CW7GGxtZMrbW9Gylyp8DoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbRzkhA1p1cvh7mtCOnspkqFtElafk0JlTXay7ZUFhjNOnQ9G4yicT3ezFlQCcPA7FJLwiY3f95el7diby8Ojd5aNHXD01gLhtGvKbUP4AYio6xY5ig0EnPvonGmSJ/CelLo93u2Y+mr1xs3asv5f+HxDts6w4sGlAHjQAQ58Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1mdZ2ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1mdZ2ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6571FC433C7;
	Mon,  1 Apr 2024 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987739;
	bh=Sz0Kend4wYD2kKjq7dBH/CW7GGxtZMrbW9Gylyp8DoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1mdZ2qlilw+AB1N3OE9oLilwHUdze0ZUJfK0x6e2DEXffQt/ocSHZpn6LPJQP/wv
	 dkV0V/qr4rjCKS0gXDB0kKI2zY7Cpuz5c7/yIIW68xq0eqXJUIlfli/OnsAi0BErA8
	 gXCetMXhdu5EJyWiRN4m5byK4uqqICjf/cQWgBqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 377/399] scsi: qla2xxx: Prevent command send on chip reset
Date: Mon,  1 Apr 2024 17:45:43 +0200
Message-ID: <20240401152600.433957893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


