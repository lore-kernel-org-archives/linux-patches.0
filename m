Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3322D1917E1;
	Tue, 30 Jul 2024 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359355; cv=none; b=XU7ziX/V6Q2eOqg0cFLYmOSTvYa71nfNdKrYTRaxgD38+/7jlzbiJP3tdiuMz5vHHl/UFG9zQOaB8tU8PSCwL/lD6WcJuebCorxE1mIXJ7q94JW2GWM/M+oyPwXXhaO/tyIKsaHHBIO8TmiVQfdgQHzhJ8vkq2uFxUeDqxtLZfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359355; c=relaxed/simple;
	bh=yzFcYEaAIvdgWD2JdQgbITumAzDfBWbRbvCnbNb7mUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0rsj6rlxVjuUu8tYHTsQfhOFF1r2Wk5XIEhHSm1xVu+/bDswR8O5OJWwstyOmxq4mBJE+5P189Q98ZBvFtfYNPMeWjPVZlXwBpWhyV4euFrH5zEqXoZ8ZS+UJxU+k1DdXcUnHBqYhNdYK0HAOCyh2Yz1l9C8696pF6W/O/k9Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZ5Y/VR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZ5Y/VR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97217C32782;
	Tue, 30 Jul 2024 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359355;
	bh=yzFcYEaAIvdgWD2JdQgbITumAzDfBWbRbvCnbNb7mUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ5Y/VR908bVoM2LC2OCpx5L8aETj2Z4h/Li5ZYxPiBtwH7bX4/OPpk+r0w1ou/Bo
	 frGKxdu1vi1KJoei8voBQjwWTCsXpC9e+56lWQZZhNooMSwukkAKOZMj6PVS5fxBG2
	 1v9aVerQ3YsxLn96Gr44qw3YgjQXTysioIsvkXo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 462/568] scsi: qla2xxx: Use QP lock to search for bsg
Date: Tue, 30 Jul 2024 17:49:29 +0200
Message-ID: <20240730151658.077729898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

commit c449b4198701d828e40d60a2abd30970b74a1d75 upstream.

On bsg timeout, hardware_lock is used as part of search for the srb.
Instead, qpair lock should be used to iterate through different qpair.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-11-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   96 ++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 39 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3059,17 +3059,61 @@ skip_chip_chk:
 	return ret;
 }
 
-int
-qla24xx_bsg_timeout(struct bsg_job *bsg_job)
+static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 {
+	bool found = false;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_hw_data *ha = vha->hw;
-	srb_t *sp;
-	int cnt, que;
+	srb_t *sp = NULL;
+	int cnt;
 	unsigned long flags;
 	struct req_que *req;
 
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+	req = qpair->req;
+
+	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (sp &&
+		    (sp->type == SRB_CT_CMD ||
+		     sp->type == SRB_ELS_CMD_HST ||
+		     sp->type == SRB_ELS_CMD_HST_NOLOGIN) &&
+		    sp->u.bsg_job == bsg_job) {
+			req->outstanding_cmds[cnt] = NULL;
+			spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+			if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
+				ql_log(ql_log_warn, vha, 0x7089,
+						"mbx abort_command failed.\n");
+				bsg_reply->result = -EIO;
+			} else {
+				ql_dbg(ql_dbg_user, vha, 0x708a,
+						"mbx abort_command success.\n");
+				bsg_reply->result = 0;
+			}
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
+
+			found = true;
+			goto done;
+		}
+	}
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+done:
+	return found;
+}
+
+int
+qla24xx_bsg_timeout(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
+	struct qla_hw_data *ha = vha->hw;
+	int i;
+	struct qla_qpair *qpair;
+
 	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
 	    __func__, bsg_job);
 
@@ -3079,48 +3123,22 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_
 		qla_pci_set_eeh_busy(vha);
 	}
 
+	if (qla_bsg_found(ha->base_qpair, bsg_job))
+		goto done;
+
 	/* find the bsg job from the active list of commands */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < ha->max_req_queues; que++) {
-		req = ha->req_q_map[que];
-		if (!req)
+	for (i = 0; i < ha->max_qpairs; i++) {
+		qpair = vha->hw->queue_pair_map[i];
+		if (!qpair)
 			continue;
-
-		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (sp &&
-			    (sp->type == SRB_CT_CMD ||
-			     sp->type == SRB_ELS_CMD_HST ||
-			     sp->type == SRB_ELS_CMD_HST_NOLOGIN ||
-			     sp->type == SRB_FXIOCB_BCMD) &&
-			    sp->u.bsg_job == bsg_job) {
-				req->outstanding_cmds[cnt] = NULL;
-				spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-				if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
-					ql_log(ql_log_warn, vha, 0x7089,
-					    "mbx abort_command failed.\n");
-					bsg_reply->result = -EIO;
-				} else {
-					ql_dbg(ql_dbg_user, vha, 0x708a,
-					    "mbx abort_command success.\n");
-					bsg_reply->result = 0;
-				}
-				spin_lock_irqsave(&ha->hardware_lock, flags);
-				goto done;
-
-			}
-		}
+		if (qla_bsg_found(qpair, bsg_job))
+			goto done;
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
 	bsg_reply->result = -ENXIO;
-	return 0;
 
 done:
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return 0;
 }
 


