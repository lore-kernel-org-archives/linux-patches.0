Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034920FAA
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90201C433C8;
	Fri, 21 Jul 2023 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967628;
	bh=Y3S6WyzqTzPesBg/3ltR2yv8nScl1SBvSrrWzIRkkvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4AYdYBnwYZf5jhE8ypL9qi4Y2D0ZD90OPNcUHmsWGp4Sy0WQOaKQdP2mEDDmh6z9
	 fQbSLXmMwtyJUO2FAn8LGrd4jiU55Ay8K6QfMR+pXa42DVghJ5k7q/P78jmWQ8rxG9
	 CMyWHIGdYW5WGZ7DS7e3I8uMMAw+PJF/Ym5Wuk3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 208/223] scsi: qla2xxx: Fix hang in task management
Date: Fri, 21 Jul 2023 18:07:41 +0200
Message-ID: <20230721160529.741090747@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quinn Tran <qutran@marvell.com>

commit 9ae615c5bfd37bd091772969b1153de5335ea986 upstream.

Task management command hangs where a side
band chip reset failed to nudge the TMF
from it's current send path.

Add additional error check to block TMF
from entering during chip reset and along
the TMF path to cause it to bail out, skip
over abort of marker.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230428075339.32551-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |    4 ++
 drivers/scsi/qla2xxx/qla_init.c |   60 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5499,4 +5499,8 @@ struct ql_vnd_tgt_stats_resp {
 	_fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
 	_fp->flags
 
+#define TMF_NOT_READY(_fcport) \
+	(!_fcport || IS_SESSION_DELETED(_fcport) || atomic_read(&_fcport->state) != FCS_ONLINE || \
+	!_fcport->vha->hw->flags.fw_started)
+
 #endif
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1997,6 +1997,11 @@ qla2x00_tmf_iocb_timeout(void *data)
 	int rc, h;
 	unsigned long flags;
 
+	if (sp->type == SRB_MARKER) {
+		complete(&tmf->u.tmf.comp);
+		return;
+	}
+
 	rc = qla24xx_async_abort_cmd(sp, false);
 	if (rc) {
 		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
@@ -2024,6 +2029,7 @@ static void qla_marker_sp_done(srb_t *sp
 		    sp->handle, sp->fcport->d_id.b24, sp->u.iocb_cmd.u.tmf.flags,
 		    sp->u.iocb_cmd.u.tmf.lun, sp->qpair->id);
 
+	sp->u.iocb_cmd.u.tmf.data = res;
 	complete(&tmf->u.tmf.comp);
 }
 
@@ -2040,6 +2046,11 @@ static void qla_marker_sp_done(srb_t *sp
 	} while (cnt); \
 }
 
+/**
+ * qla26xx_marker: send marker IOCB and wait for the completion of it.
+ * @arg: pointer to argument list.
+ *    It is assume caller will provide an fcport pointer and modifier
+ */
 static int
 qla26xx_marker(struct tmf_arg *arg)
 {
@@ -2049,6 +2060,14 @@ qla26xx_marker(struct tmf_arg *arg)
 	int rval = QLA_FUNCTION_FAILED;
 	fc_port_t *fcport = arg->fcport;
 
+	if (TMF_NOT_READY(arg->fcport)) {
+		ql_dbg(ql_dbg_taskm, vha, 0x8039,
+		    "FC port not ready for marker loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d.\n",
+		    fcport->loop_id, fcport->d_id.b24,
+		    arg->modifier, arg->lun, arg->qpair->id);
+		return QLA_SUSPENDED;
+	}
+
 	/* ref: INIT */
 	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
@@ -2075,11 +2094,19 @@ qla26xx_marker(struct tmf_arg *arg)
 
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x8031,
-		    "Marker IOCB failed (%x).\n", rval);
+		    "Marker IOCB send failure (%x).\n", rval);
 		goto done_free_sp;
 	}
 
 	wait_for_completion(&tm_iocb->u.tmf.comp);
+	rval = tm_iocb->u.tmf.data;
+
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x8019,
+		    "Marker failed hdl=%x loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d rval %d.\n",
+		    sp->handle, fcport->loop_id, fcport->d_id.b24,
+		    arg->modifier, arg->lun, sp->qpair->id, rval);
+	}
 
 done_free_sp:
 	/* ref: INIT */
@@ -2092,6 +2119,8 @@ static void qla2x00_tmf_sp_done(srb_t *s
 {
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
 
+	if (res)
+		tmf->u.tmf.data = res;
 	complete(&tmf->u.tmf.comp);
 }
 
@@ -2105,6 +2134,14 @@ __qla2x00_async_tm_cmd(struct tmf_arg *a
 
 	fc_port_t *fcport = arg->fcport;
 
+	if (TMF_NOT_READY(arg->fcport)) {
+		ql_dbg(ql_dbg_taskm, vha, 0x8032,
+		    "FC port not ready for TM command loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d.\n",
+		    fcport->loop_id, fcport->d_id.b24,
+		    arg->modifier, arg->lun, arg->qpair->id);
+		return QLA_SUSPENDED;
+	}
+
 	/* ref: INIT */
 	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
@@ -2179,7 +2216,9 @@ int qla_get_tmf(fc_port_t *fcport)
 		msleep(1);
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-		if (fcport->deleted) {
+		if (TMF_NOT_READY(fcport)) {
+			ql_log(ql_log_warn, vha, 0x802c,
+			    "Unable to acquire TM resource due to disruption.\n");
 			rc = EIO;
 			break;
 		}
@@ -2205,7 +2244,10 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_qpair *qpair;
 	struct tmf_arg a;
-	int i, rval;
+	int i, rval = QLA_SUCCESS;
+
+	if (TMF_NOT_READY(fcport))
+		return QLA_SUSPENDED;
 
 	a.vha = fcport->vha;
 	a.fcport = fcport;
@@ -2224,6 +2266,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 			qpair = vha->hw->queue_pair_map[i];
 			if (!qpair)
 				continue;
+
+			if (TMF_NOT_READY(fcport)) {
+				ql_log(ql_log_warn, vha, 0x8026,
+				    "Unable to send TM due to disruption.\n");
+				rval = QLA_SUSPENDED;
+				break;
+			}
+
 			a.qpair = qpair;
 			a.flags = flags|TCF_NOTMCMD_TO_TARGET;
 			rval = __qla2x00_async_tm_cmd(&a);
@@ -2232,10 +2282,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 		}
 	}
 
+	if (rval)
+		goto bailout;
+
 	a.qpair = vha->hw->base_qpair;
 	a.flags = flags;
 	rval = __qla2x00_async_tm_cmd(&a);
 
+bailout:
 	if (a.modifier == MK_SYNC_ID_LUN)
 		qla_put_tmf(fcport);
 


