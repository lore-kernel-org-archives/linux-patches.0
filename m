Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC90250E0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t41t+qNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5BBC433C7;
	Mon,  9 Oct 2023 13:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858163;
	bh=ibL43TwsuB3aQtr1bsMDR2tREucnso9PG+xfNSGL5qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t41t+qNlSlFmhaiNhAyOd8/QNlhWCZWmWBLakVJQ8xymcZgOLhibVgtCrJZVZqvb6
	 Df2LJOaWwRLwnK/NHB18PHpKWYm7d8mRfNBGkrpnHsKMpGbkqh7pCwoD9uA4ghLwPe
	 5fuCxHYSTJMUTFrG6hLBePcfmd+B2eaXrheQTIaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/131] scsi: qla2xxx: Fix deletion race condition
Date: Mon,  9 Oct 2023 15:01:15 +0200
Message-ID: <20231009130117.382985539@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 6dfe4344c168c6ca20fe7640649aacfcefcccb26 ]

System crash when using debug kernel due to link list corruption. The cause
of the link list corruption is due to session deletion was allowed to queue
up twice.  Here's the internal trace that show the same port was allowed to
double queue for deletion on different cpu.

20808683956 015 qla2xxx [0000:13:00.1]-e801:4: Scheduling sess ffff93ebf9306800 for deletion 50:06:0e:80:12:48:ff:50 fc4_type 1
20808683957 027 qla2xxx [0000:13:00.1]-e801:4: Scheduling sess ffff93ebf9306800 for deletion 50:06:0e:80:12:48:ff:50 fc4_type 1

Move the clearing/setting of deleted flag lock.

Cc: stable@vger.kernel.org
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230714070104.40052-2-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c   | 16 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c | 12 ++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 28ba87cd227a2..8a0ac87f70a9d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -485,6 +485,7 @@ static
 void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
 	struct fc_port *fcport = ea->fcport;
+	unsigned long flags;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d2,
 	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d lid %d\n",
@@ -499,9 +500,15 @@ void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x2066,
 		    "%s %8phC: adisc fail: post delete\n",
 		    __func__, ea->fcport->port_name);
+
+		spin_lock_irqsave(&vha->work_lock, flags);
 		/* deleted = 0 & logout_on_delete = force fw cleanup */
-		fcport->deleted = 0;
+		if (fcport->deleted == QLA_SESS_DELETED)
+			fcport->deleted = 0;
+
 		fcport->logout_on_delete = 1;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+
 		qlt_schedule_sess_for_deletion(ea->fcport);
 		return;
 	}
@@ -1402,7 +1409,6 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	ea->fcport->login_gen++;
-	ea->fcport->deleted = 0;
 	ea->fcport->logout_on_delete = 1;
 
 	if (!ea->fcport->login_succ && !IS_SW_RESV_ADDR(ea->fcport->d_id)) {
@@ -5475,6 +5481,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 void
 qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
+	unsigned long flags;
+
 	if (IS_SW_RESV_ADDR(fcport->d_id))
 		return;
 
@@ -5484,7 +5492,11 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+
+	spin_lock_irqsave(&vha->work_lock, flags);
 	fcport->deleted = 0;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
 	if (vha->hw->current_topology == ISP_CFG_NL)
 		fcport->logout_on_delete = 0;
 	else
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb97565b6a333..a95ea2f70f97f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1046,10 +1046,6 @@ void qlt_free_session_done(struct work_struct *work)
 			(struct imm_ntfy_from_isp *)sess->iocb, SRB_NACK_LOGO);
 	}
 
-	spin_lock_irqsave(&vha->work_lock, flags);
-	sess->flags &= ~FCF_ASYNC_SENT;
-	spin_unlock_irqrestore(&vha->work_lock, flags);
-
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	if (sess->se_sess) {
 		sess->se_sess = NULL;
@@ -1059,7 +1055,6 @@ void qlt_free_session_done(struct work_struct *work)
 
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETED);
 	sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
-	sess->deleted = QLA_SESS_DELETED;
 
 	if (sess->login_succ && !IS_SW_RESV_ADDR(sess->d_id)) {
 		vha->fcport_count--;
@@ -1111,7 +1106,12 @@ void qlt_free_session_done(struct work_struct *work)
 
 	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	spin_lock_irqsave(&vha->work_lock, flags);
+	sess->flags &= ~FCF_ASYNC_SENT;
+	sess->deleted = QLA_SESS_DELETED;
 	sess->free_pending = 0;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
 
 	ql_dbg(ql_dbg_disc, vha, 0xf001,
 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
@@ -1161,12 +1161,12 @@ void qlt_unreg_sess(struct fc_port *sess)
 	 * management from being sent.
 	 */
 	sess->flags |= FCF_ASYNC_SENT;
+	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
 	if (sess->se_sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
-- 
2.40.1



