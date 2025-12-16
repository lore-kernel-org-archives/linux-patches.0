Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2DC2E9EB5;
	Tue, 16 Dec 2025 12:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887560; cv=none; b=a3T/l/82UX8FT66c/jeqmhNRrF2hOgT7dZwNgniGiHLFtpopM+YajJtV0aj+tKE6zoJhg9zQwFpDyw1fsKkza6RFbX8a9chJki9Bu7mAo1+Xfmy7peICGzDaDPgtYfBk2HvgNXEg4sZV0r9H/uiMiIPI2iK46xctvwEgufnRAck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887560; c=relaxed/simple;
	bh=W4A+zh7DdNBqXZoFOYj/3jbv3m/rAVLXVmI+ZwHuHlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8YBq6Q9/JCnnhk9MGQvfed49cv4w4ieAx/Y0BlEHYtqufx0QNuCI0slrAr5gExeqBK7lrjw2VkGQxAyGoT5SwM0Ad0BIzcmbYuQBpukFxURlWYyZUE331QG+0tm7d4OQ5yTfzm+77+DuH0mRjefpgFmiP3MdWJkOv8Y1W4NWIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4AgDzCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4AgDzCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6316C4CEF1;
	Tue, 16 Dec 2025 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887560;
	bh=W4A+zh7DdNBqXZoFOYj/3jbv3m/rAVLXVmI+ZwHuHlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4AgDzCmmUQlxVrR5m9MiZ/7KG9oIGIG2AwhOcsWjkrsfE309PziSwSPY2en4nsgf
	 420Eky8FOm/o5SfzlDN24MJybqi6qhui+jr0c4Eq/mBpr3tSr0lGbDfHxvTpku1Aso
	 sNjpiXpfLbuWm4zgnIF/+YFEK2wv5lgpeABpOlu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/614] scsi: qla2xxx: Clear cmds after chip reset
Date: Tue, 16 Dec 2025 12:10:34 +0100
Message-ID: <20251216111411.048361737@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit d46c69a087aa3d1513f7a78f871b80251ea0c1ae ]

Commit aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling
and host reset handling") caused two problems:

1. Commands sent to FW, after chip reset got stuck and never freed as FW
   is not going to respond to them anymore.

2. BUG_ON(cmd->sg_mapped) in qlt_free_cmd().  Commit 26f9ce53817a
   ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
   attempted to fix this, but introduced another bug under different
   circumstances when two different CPUs were racing to call
   qlt_unmap_sg() at the same time: BUG_ON(!valid_dma_direction(dir)) in
   dma_unmap_sg_attrs().

So revert "scsi: qla2xxx: Fix missed DMA unmap for aborted commands" and
partially revert "scsi: qla2xxx: target: Fix offline port handling and
host reset handling" at __qla2x00_abort_all_cmds.

Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling and host reset handling")
Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
Co-developed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://patch.msgid.link/0e7e5d26-e7a0-42d1-8235-40eeb27f3e98@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c     | 20 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  5 +----
 drivers/scsi/qla2xxx/qla_target.h |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5ffd945866527..70a579cf9c3fd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1881,10 +1881,26 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 					continue;
 				}
 				cmd = (struct qla_tgt_cmd *)sp;
-				cmd->aborted = 1;
+
+				if (cmd->sg_mapped)
+					qlt_unmap_sg(vha, cmd);
+
+				if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
+					cmd->aborted = 1;
+					cmd->write_data_transferred = 0;
+					cmd->state = QLA_TGT_STATE_DATA_IN;
+					ha->tgt.tgt_ops->handle_data(cmd);
+				} else {
+					ha->tgt.tgt_ops->free_cmd(cmd);
+				}
 				break;
 			case TYPE_TGT_TMCMD:
-				/* Skip task management functions. */
+				/*
+				 * Currently, only ABTS response gets on the
+				 * outstanding_cmds[]
+				 */
+				ha->tgt.tgt_ops->free_mcmd(
+					(struct qla_tgt_mgmt_cmd *) sp);
 				break;
 			default:
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1e81582085e38..4c6aff59fe3fb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2443,7 +2443,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 	return -1;
 }
 
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -3773,9 +3773,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
-
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 15a59c125c532..c483966d0a847 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1058,6 +1058,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
+extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.51.0



