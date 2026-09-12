Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14EE38F620;
	Sat, 12 Sep 2026 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242670; cv=none; b=Q7yR3jV5+4fw7Zc8Jc1gFTd7iAgAA9CdBlU9G9dOZYSfV9CZ/Bhi5aYxsCKHtfsvfzkOQAOUOmE3NkNGMe49Xq8X2XxN3PkFCsRMQ+hdf1xUhA86EKqnXugWZivlhJiqhn01wXBeUWrHzm9DOw/KOzilpK8gjKpjZtDJ0DvDiLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242670; c=relaxed/simple;
	bh=Hy1rqV1M5ZiXh8EbIX0b4z94G0cLxPl867hv8IbIhuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orew2NtntGuib2FHYWcohHnrQelX4cdMjCMM5o95pl6ssZJOOsE3F4mAP3kA+zdCo2kyWOQ+CUbBF+OLLnky+/1WTvzKvA3FuV7s48WlnkBKoPwhdrFk01VmFKThu/Y6pClckeq6CXR2ndS72mnnnCVLEftOn+M/HROYK3tF4qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQM2Tx+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQM2Tx+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493BE1F000FF;
	Sat, 12 Sep 2026 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242668;
	bh=QzlDhbdP88Kre/RXM9dow6WWda9khbyqqvmHQtHEENE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQM2Tx+m8A3M3oEoQgLpKp5rNa2hZQr3ff6cGS8M/b+P/E7srXIecNb+a3YtMNShm
	 5u+JFNKWmkatGTw2iu6lzDedGSENG6cvPvlJ6BTiCCV2quZJnuAFsJaiQjWbFpnHDI
	 D5acLjhzG85JwnRVr1m+bCOqTc3naSvXyhEcfZiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 486/798] scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
Date: Sat, 12 Sep 2026 09:01:54 +0200
Message-ID: <20260912065528.282378460@linuxfoundation.org>
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

[ Upstream commit 8f394da36a361cbe0e1e8b1d4213e5598c8095ac ]

Only the __qlt_24xx_handle_abts() code path does not know the LUN for an
abort and it uses the TARGET_SCF_LOOKUP_LUN_FROM_TAG flag to have LIO core
look it up. LIO uses target_lookup_lun_from_tag to go from cmd tag to LUN
for the driver. However, qla2xxx has a tcm_qla2xxx_find_cmd_by_tag() which
does almost the same thing as the LIO helper (it finds the cmd but does not
return the LUN). This patch has qla2xxx use its internal helper.

Link: https://lore.kernel.org/r/1604257174-4524-4-git-send-email-michael.christie@oracle.com
Cc: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ef63cc441703 ("RDMA/srpt: Pass the mapped task attribute to target_init_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c  | 21 +++++++++++----------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 +---
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d2433f162815a..a873bd5bb6e01 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2095,6 +2095,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct qla_qpair_hint *h = &vha->vha_tgt.qla_tgt->qphints[0];
+	struct qla_tgt_cmd *abort_cmd;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
@@ -2122,17 +2123,17 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	 */
 	mcmd->se_cmd.cpuid = h->cpuid;
 
-	if (ha->tgt.tgt_ops->find_cmd_by_tag) {
-		struct qla_tgt_cmd *abort_cmd;
-
-		abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
+	abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
 				le32_to_cpu(abts->exchange_addr_to_abort));
-		if (abort_cmd && abort_cmd->qpair) {
-			mcmd->qpair = abort_cmd->qpair;
-			mcmd->se_cmd.cpuid = abort_cmd->se_cmd.cpuid;
-			mcmd->abort_io_attr = abort_cmd->atio.u.isp24.attr;
-			mcmd->flags = QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
-		}
+	if (!abort_cmd)
+		return -EIO;
+	mcmd->unpacked_lun = abort_cmd->se_cmd.orig_fe_lun;
+
+	if (abort_cmd->qpair) {
+		mcmd->qpair = abort_cmd->qpair;
+		mcmd->se_cmd.cpuid = abort_cmd->se_cmd.cpuid;
+		mcmd->abort_io_attr = abort_cmd->atio.u.isp24.attr;
+		mcmd->flags = QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
 	}
 
 	INIT_WORK(&mcmd->work, qlt_do_tmr_work);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7405fab324c82..6dd200df858f4 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -574,13 +574,11 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	struct fc_port *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 	int transl_tmr_func = 0;
-	int flags = TARGET_SCF_ACK_KREF;
 
 	switch (tmr_func) {
 	case QLA_TGT_ABTS:
 		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
 		transl_tmr_func = TMR_ABORT_TASK;
-		flags |= TARGET_SCF_LOOKUP_LUN_FROM_TAG;
 		break;
 	case QLA_TGT_2G_ABORT_TASK:
 		pr_debug("%ld: 2G Abort Task received\n", sess->vha->host_no);
@@ -613,7 +611,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-	    transl_tmr_func, GFP_ATOMIC, tag, flags);
+	    transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
 }
 
 static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
-- 
2.53.0



