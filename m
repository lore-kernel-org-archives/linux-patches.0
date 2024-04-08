Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83947E105;
	Mon,  8 Apr 2024 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584898; cv=none; b=E7oeoHoiPsmjDplpFQNPzAmfK+euLcRFurwQZPnWs8BSMhA2dE4bCVHwZuBnZkjZrev/tZK/uuzY/yvW7TJS7sMECGeeuA8gUQF9KH+lo1vpjdo86r0g7Z7/5SGpHwYDO2tlF3OTIrZ9hOANkl1xPs1SDHGc/JkkxdVv0qgNiGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584898; c=relaxed/simple;
	bh=gYJwPh+ut6vfFFO+JDteRvJheYZTojnahXDZvjRn6jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4yJotIbxdrDy+/xZcne5bvOxYwCK74qYS3+FuTVAJmTD62mkMR6vRnOjKncMlASGWHkg4k+QvUM3z2dMYJqGIyZxDZ0Rgfzx34GwFPrwBPol6cLDBTwEP/ETrn6GEoo2YUb7a0ai2Si2U98Ypjms7MlXBFuQ9c3MMw70JfFkpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbDFbS3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbDFbS3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18CDC433C7;
	Mon,  8 Apr 2024 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584898;
	bh=gYJwPh+ut6vfFFO+JDteRvJheYZTojnahXDZvjRn6jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbDFbS3P7czcZu2/0cNpxymWKeCrdWfjz3NuqQHadPvl2Uy002pp5fZeAebHcKHMj
	 JcQGpnDdcIoNRFyVyG6/sxUpprKNA52mT9q8jF/B2PPOprBkO8MU5LQLA4Oss4Ti9T
	 EYTM1PCeO4TBTqf/3MGdtp7P2VXS0kEvQ3XsBHR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 595/690] scsi: qla2xxx: Fix N2N stuck connection
Date: Mon,  8 Apr 2024 14:57:41 +0200
Message-ID: <20240408125421.143137861@linuxfoundation.org>
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

commit 881eb861ca3877300570db10abbf11494e48548d upstream.

Disk failed to rediscover after chip reset error injection. The chip reset
happens at the time when a PLOGI is being sent. This causes a flag to be
left on which blocks the retry. Clear the blocking flag.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c |   32 +++++++++++---------------------
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 3 files changed, 13 insertions(+), 23 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -44,7 +44,7 @@ extern int qla2x00_fabric_login(scsi_qla
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
 extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t);
-extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, bool);
+extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *);
 extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
 				   struct els_plogi *els_plogi);
 
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3042,7 +3042,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 
 int
 qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
-    fc_port_t *fcport, bool wait)
+			fc_port_t *fcport)
 {
 	srb_t *sp;
 	struct srb_iocb *elsio = NULL;
@@ -3057,8 +3057,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 	if (!sp) {
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
-		fcport->flags &= ~FCF_ASYNC_ACTIVE;
-		return -ENOMEM;
+		goto done;
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -3067,9 +3066,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	       "%s Enter: PLOGI portid=%06x\n", __func__, fcport->d_id.b24);
 
-	if (wait)
-		sp->flags = SRB_WAKEUP_ON_COMP;
-
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
@@ -3085,7 +3081,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 
 	if (!elsio->u.els_plogi.els_plogi_pyld) {
 		rval = QLA_FUNCTION_FAILED;
-		goto out;
+		goto done_free_sp;
 	}
 
 	resp_ptr = elsio->u.els_plogi.els_resp_pyld =
@@ -3094,7 +3090,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 
 	if (!elsio->u.els_plogi.els_resp_pyld) {
 		rval = QLA_FUNCTION_FAILED;
-		goto out;
+		goto done_free_sp;
 	}
 
 	ql_dbg(ql_dbg_io, vha, 0x3073, "PLOGI %p %p\n", ptr, resp_ptr);
@@ -3109,7 +3105,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 
 	if (els_opcode == ELS_DCMD_PLOGI && DBELL_ACTIVE(vha)) {
 		struct fc_els_flogi *p = ptr;
-
 		p->fl_csp.sp_features |= cpu_to_be16(FC_SP_FT_SEC);
 	}
 
@@ -3118,10 +3113,11 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
 	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
-	init_completion(&elsio->u.els_plogi.comp);
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
+		fcport->flags |= FCF_LOGIN_NEEDED;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		goto done_free_sp;
 	} else {
 		ql_dbg(ql_dbg_disc, vha, 0x3074,
 		    "%s PLOGI sent, hdl=%x, loopid=%x, to port_id %06x from port_id %06x\n",
@@ -3129,21 +3125,15 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 		    fcport->d_id.b24, vha->d_id.b24);
 	}
 
-	if (wait) {
-		wait_for_completion(&elsio->u.els_plogi.comp);
-
-		if (elsio->u.els_plogi.comp_status != CS_COMPLETE)
-			rval = QLA_FUNCTION_FAILED;
-	} else {
-		goto done;
-	}
+	return rval;
 
-out:
-	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+done_free_sp:
 	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+	qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
 	return rval;
 }
 
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5530,7 +5530,7 @@ qla2x00_do_work(struct scsi_qla_host *vh
 			break;
 		case QLA_EVT_ELS_PLOGI:
 			qla24xx_els_dcmd2_iocb(vha, ELS_DCMD_PLOGI,
-			    e->u.fcport.fcport, false);
+			    e->u.fcport.fcport);
 			break;
 		case QLA_EVT_SA_REPLACE:
 			rc = qla24xx_issue_sa_replace_iocb(vha, e);


