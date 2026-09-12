Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755AB345EB5;
	Sat, 12 Sep 2026 19:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242678; cv=none; b=BANKCmUN2K1+35jqlwNXacFYRd6E5HhzT9WTwdBcoltR46QhH8ua6v4icJKWyu/ugh7l0HqUt6gyOy7i9yMTyoxlety0Sgt7lJTkKe649xkg/v1NGwGDkbfCTlk2lCMNYBibhLmmWqogU9Qr8G/Lye+i5oe+xMHdSXToS7opJCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242678; c=relaxed/simple;
	bh=jI+Z2qv5KCSrPauN4E3CJKj+bBaC0K/Rjw+InmKSdVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nwc3JizPvVF+l/3741Ph9JkLNOWPtNVdUvLZzZeh3ktR7LxkavRmOqsWt7IYvuoFaA5H0TWHkRRC07YRXRsvvqbvnCe9jJsS6tiiKgCkbOT1I8/pXTzkNxmdEHv8I44nsxFUPtf0/rwq42vNxWvO9C3FoQW0LgkCebHuQwYDAWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOTNlkNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOTNlkNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23111F000FF;
	Sat, 12 Sep 2026 19:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242677;
	bh=+OtaBSWx05iz9yJ8ximqlw43t4tJE18HQ+ZXEgmUODo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOTNlkNSIvDu9pFtUuJpJl/eYrAWobcQsv1+v5OVYVXKEF0zxqaQlAZJvNYSAn6RP
	 4fIJRL40/zlDQCtw2gM3nkCcnxq/AWW66EhxbgYdQ4FH3z0ldPzkhGHUNiXIni4N9K
	 2k7epHgTmqHyWEwl9WG75S2rt/f4qyw92Ox0Y0Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/798] scsi: qla2xxx: Move sess cmd list/lock to driver
Date: Sat, 12 Sep 2026 09:01:56 +0200
Message-ID: <20260912065528.326381429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 605e74025f953b995a3a241ead43bde71c1c99b5 ]

Except for debug output in the shutdown path, tcm_qla2xxx is the only
driver using the se_session sess_cmd_list. Move the list to that driver to
facilitate removing the sess_cmd_lock from the main I/O path for the rest
of the drivers.

Link: https://lore.kernel.org/r/1604257174-4524-6-git-send-email-michael.christie@oracle.com
Cc: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ef63cc441703 ("RDMA/srpt: Pass the mapped task attribute to target_init_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h     |  2 ++
 drivers/scsi/qla2xxx/qla_init.c    |  3 ++
 drivers/scsi/qla2xxx/qla_target.c  |  1 +
 drivers/scsi/qla2xxx/qla_target.h  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 57 ++++++++++++++++++------------
 5 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6af873de6dfbf..554872b9f58cb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2493,6 +2493,8 @@ typedef struct fc_port {
 	int generation;
 
 	struct se_session *se_sess;
+	struct list_head sess_cmd_list;
+	spinlock_t sess_cmd_lock;
 	struct kref sess_kref;
 	struct qla_tgt *tgt;
 	unsigned long expires;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d8c0398e945ce..51817a8da8442 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5164,6 +5164,9 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
 
+	INIT_LIST_HEAD(&fcport->sess_cmd_list);
+	spin_lock_init(&fcport->sess_cmd_lock);
+
 	return fcport;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a873bd5bb6e01..e89a907a07d4a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4301,6 +4301,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 
 	cmd->cmd_type = TYPE_TGT_CMD;
 	memcpy(&cmd->atio, atio, sizeof(*atio));
+	INIT_LIST_HEAD(&cmd->sess_cmd_list);
 	cmd->state = QLA_TGT_STATE_NEW;
 	cmd->tgt = vha->vha_tgt.qla_tgt;
 	qlt_incr_num_pend_cmds(vha);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 1e94586c7eb21..01620f3eab39f 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -856,6 +856,7 @@ struct qla_tgt_cmd {
 	uint8_t cmd_type;
 	uint8_t pad[7];
 	struct se_cmd se_cmd;
+	struct list_head sess_cmd_list;
 	struct fc_port *sess;
 	struct qla_qpair *qpair;
 	uint32_t reset_count;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6dd200df858f4..e0da984893d52 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -255,6 +255,7 @@ static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+	unsigned long flags;
 
 	cmd->cmd_in_wq = 0;
 
@@ -265,6 +266,10 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 	cmd->trc_flags |= TRC_CMD_FREE;
 	cmd->cmd_sent_to_fw = 0;
 
+	spin_lock_irqsave(&cmd->sess->sess_cmd_lock, flags);
+	list_del_init(&cmd->sess_cmd_list);
+	spin_unlock_irqrestore(&cmd->sess->sess_cmd_lock, flags);
+
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
@@ -451,13 +456,14 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
-	int flags = TARGET_SCF_ACK_KREF;
+	int target_flags = TARGET_SCF_ACK_KREF;
+	unsigned long flags;
 
 	if (bidi)
-		flags |= TARGET_SCF_BIDI_OP;
+		target_flags |= TARGET_SCF_BIDI_OP;
 
 	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
-		flags |= TARGET_SCF_USE_CPUID;
+		target_flags |= TARGET_SCF_USE_CPUID;
 
 	sess = cmd->sess;
 	if (!sess) {
@@ -479,11 +485,15 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		return 0;
 	}
 #endif
-
 	cmd->qpair->tgt_counters.qla_core_sbt_cmd++;
+
+	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
+	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
+	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
+
 	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
-				cmd->unpacked_lun, data_length, fcp_task_attr,
-				data_dir, flags);
+				 cmd->unpacked_lun, data_length, fcp_task_attr,
+				 data_dir, target_flags);
 }
 
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
@@ -617,25 +627,20 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
     uint64_t tag)
 {
-	struct qla_tgt_cmd *cmd = NULL;
-	struct se_cmd *secmd;
+	struct qla_tgt_cmd *cmd;
 	unsigned long flags;
 
 	if (!sess->se_sess)
 		return NULL;
 
-	spin_lock_irqsave(&sess->se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(secmd, &sess->se_sess->sess_cmd_list, se_cmd_list) {
-		/* skip task management functions, including tmr->task_cmd */
-		if (secmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		if (secmd->tag == tag) {
-			cmd = container_of(secmd, struct qla_tgt_cmd, se_cmd);
-			break;
-		}
+	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
+	list_for_each_entry(cmd, &sess->sess_cmd_list, sess_cmd_list) {
+		if (cmd->se_cmd.tag == tag)
+			goto done;
 	}
-	spin_unlock_irqrestore(&sess->se_sess->sess_cmd_lock, flags);
+	cmd = NULL;
+done:
+	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
 
 	return cmd;
 }
@@ -761,11 +766,19 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 
 static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd;
+	unsigned long flags;
 
-	if (qlt_abort_cmd(cmd))
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		return;
+
+	cmd  = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+
+	spin_lock_irqsave(&cmd->sess->sess_cmd_lock, flags);
+	list_del_init(&cmd->sess_cmd_list);
+	spin_unlock_irqrestore(&cmd->sess->sess_cmd_lock, flags);
+
+	qlt_abort_cmd(cmd);
 }
 
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
-- 
2.53.0



