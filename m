Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B3635E93B;
	Sat, 17 Oct 2026 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258287; cv=none; b=tI5tSAgPv+WoM8mqsVzxNO886ZiTZiwBsLlNh14L0kUzVAenOF6u8Qi8WVoux6DfRyZ8YGKBYLbHee1NN2VBIMJEvQs23sFYkoWRKcsYQcOdxt+KWg+Ol6Dv2lYznrAKI/GoQninEbYRub+gdx535kSwL5hfs+JUmuUKxbr+BXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258287; c=relaxed/simple;
	bh=9naDOFUKAXSrXg/ZmorUcxP5AlNFUViuKa+KEx07zdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZs+LNHZexmaPws/fdD3k+x/A/1J1y6HqEmdra2oXTk9+ceE091yVQKgpnZRDDAJj0kc0YVxd6ih1Fg+StLGftzxvpcMUDUvW0RwQJ4wvc3jVnZCPBnp+sZAm6Wj5B1KHf0dsgkBZuOyCLknWcKuq1osGOw7qEIQUV3K6sVxmjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOBb8mh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOBb8mh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0D31F000C4;
	Sat, 17 Oct 2026 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258286;
	bh=8CqXAdYN+7qakezaKqgP+NHxKqrYgRZVXeBKzvneBoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOBb8mh5Nyuj0RGMZMpviVBXkRbNqUgeVrbN0su4FbWjLiLUjipKIjxLmJlxUopwU
	 31EtFlJUEE+jjCRC7LbUGw3cQqfbLi8xI3IkawYCPGf29G//xl4nhB+tuCBkAHpq9T
	 7unux+UXywlqnu2vcXu+RwnN0R9FcqKsJrSMeLyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0833/1674] scsi: qla2xxx: Clear cmds after chip reset
Date: Sat, 17 Oct 2026 17:51:45 +0200
Message-ID: <20261017160452.511250768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 33395b471e8ba..cac01f733492b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1888,10 +1888,26 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
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
index d7551b1443e4a..ed9a60a292c3b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2487,7 +2487,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 	return -1;
 }
 
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -3817,9 +3817,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
-
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 354fca2e7feb2..3644ab140ff94 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1059,6 +1059,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
+extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.53.0



