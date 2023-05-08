Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FA3168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BB9C4339B;
	Mon,  8 May 2023 10:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542181;
	bh=9+jG0odN+8JQ5OxQ8hciMjlXik1mpvj1mlrXPouo5ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEJZKuynm9QdCR6T5GWYXM2XMxevADwYihG3pTd8l9ktQLogq0jdm0FkM56Vz4JeM
	 GRMTd4BpuiXkd6Hqg08IB25h7C6GO43ivANcBDUNS9pVMnSRtsMj1+Sn9j+GaMa3v7
	 MWF2200Ug5ak3ZXObl5WnEVP6miyKQPdi2izKsxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 311/663] scsi: target: Pass in cmd counter to use during cmd setup
Date: Mon,  8 May 2023 11:42:17 +0200
Message-Id: <20230508094438.284390633@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 8e288be8606ad87c1726618eacfb8fbd3ab4b806 ]

Allow target_get_sess_cmd() users to pass in the cmd counter they want to
use. Right now we pass in the session's cmd counter but in a subsequent
commit iSCSI will switch from per session to per conn.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20230319015620.96006-4-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 395cee83d02d ("scsi: target: iscsit: Stop/wait on cmds during conn close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c    | 10 +++++----
 drivers/target/target_core_transport.c | 28 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    |  4 ++--
 include/target/target_core_fabric.h    |  8 +++++---
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4e..87927a36f90df 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1190,9 +1190,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
-			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			 cmd->data_direction, sam_task_attr,
-			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			  cmd->data_direction, sam_task_attr,
+			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2055,7 +2056,8 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun));
+			  scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60647a49a1d31..c395606ab1a9c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1441,14 +1441,12 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void __target_init_cmd(
-	struct se_cmd *cmd,
-	const struct target_core_fabric_ops *tfo,
-	struct se_session *se_sess,
-	u32 data_length,
-	int data_direction,
-	int task_attr,
-	unsigned char *sense_buffer, u64 unpacked_lun)
+void __target_init_cmd(struct se_cmd *cmd,
+		       const struct target_core_fabric_ops *tfo,
+		       struct se_session *se_sess, u32 data_length,
+		       int data_direction, int task_attr,
+		       unsigned char *sense_buffer, u64 unpacked_lun,
+		       struct target_cmd_counter *cmd_cnt)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1468,6 +1466,7 @@ void __target_init_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cmd_cnt = cmd_cnt;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
 		cmd->cpuid = raw_smp_processor_id();
@@ -1687,7 +1686,8 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
-			  data_dir, task_attr, sense, unpacked_lun);
+			  data_dir, task_attr, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
@@ -1982,7 +1982,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -2986,7 +2987,6 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  */
 int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 {
-	struct se_session *se_sess = se_cmd->se_sess;
 	int ret = 0;
 
 	/*
@@ -3003,11 +3003,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * Users like xcopy do not use counters since they never do a stop
 	 * and wait.
 	 */
-	if (se_sess->cmd_cnt) {
-		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+	if (se_cmd->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
 			ret = -ESHUTDOWN;
-		else
-			se_cmd->cmd_cnt = se_sess->cmd_cnt;
 	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49a83500c8b75..91ed015b588c6 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -591,8 +591,8 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
-			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
@@ -636,8 +636,8 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
-			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0d..c21acebe8aae5 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1054,7 +1054,7 @@ static void usbg_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
@@ -1183,7 +1183,7 @@ static void bot_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 65527174b8bc6..d507e7885f17f 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,9 +151,11 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	__target_init_cmd(struct se_cmd *,
-		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *, u64);
+void	__target_init_cmd(struct se_cmd *cmd,
+		const struct target_core_fabric_ops *tfo,
+		struct se_session *sess, u32 data_length, int data_direction,
+		int task_attr, unsigned char *sense_buffer, u64 unpacked_lun,
+		struct target_cmd_counter *cmd_cnt);
 int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun, u32 data_length,
 		int task_attr, int data_dir, int flags);
-- 
2.39.2



