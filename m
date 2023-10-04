Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C41DDEE
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghxZOjtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF66CC433CC;
	Wed,  4 Oct 2023 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444219;
	bh=o/GPvSMdGaHJ67WEt0Tpnx5vvLk03I9srcH0uQdl8q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghxZOjtbWYEsDeMgKGYfe1EPf113JX95v4xyFtDeQNzQHCUrN/WywWo2tu0F2O/B0
	 cdFhZoBU/8co8MJwU9mo1r9EaDcNTfIMdNWDzjIYwu1GrSP3JGp6339zLjbTEZVKHB
	 4X0J0YU/rFVDB5plZ8B4YPTVTRO8VGjX6nxMfDh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javed Hasan <jhasan@marvell.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 172/321] scsi: qedf: Add synchronization between I/O completions and abort
Date: Wed,  4 Oct 2023 19:55:17 +0200
Message-ID: <20231004175237.228046386@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 7df0b2605489bef3f4223ad66f1f9bb8d50d4cd2 ]

Avoid race condition between I/O completion and abort processing by
protecting the cmd_type with the rport lock.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Link: https://lore.kernel.org/r/20230901060646.27885-1-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_io.c   | 10 ++++++++--
 drivers/scsi/qedf/qedf_main.c |  7 ++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 4750ec5789a80..10fe3383855c0 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1904,6 +1904,7 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 		goto drop_rdata_kref;
 	}
 
+	spin_lock_irqsave(&fcport->rport_lock, flags);
 	if (!test_bit(QEDF_CMD_OUTSTANDING, &io_req->flags) ||
 	    test_bit(QEDF_CMD_IN_CLEANUP, &io_req->flags) ||
 	    test_bit(QEDF_CMD_IN_ABORT, &io_req->flags)) {
@@ -1911,17 +1912,20 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 			 "io_req xid=0x%x sc_cmd=%p already in cleanup or abort processing or already completed.\n",
 			 io_req->xid, io_req->sc_cmd);
 		rc = 1;
+		spin_unlock_irqrestore(&fcport->rport_lock, flags);
 		goto drop_rdata_kref;
 	}
 
+	/* Set the command type to abort */
+	io_req->cmd_type = QEDF_ABTS;
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+
 	kref_get(&io_req->refcount);
 
 	xid = io_req->xid;
 	qedf->control_requests++;
 	qedf->packet_aborts++;
 
-	/* Set the command type to abort */
-	io_req->cmd_type = QEDF_ABTS;
 	io_req->return_scsi_cmd_on_abts = return_scsi_cmd_on_abts;
 
 	set_bit(QEDF_CMD_IN_ABORT, &io_req->flags);
@@ -2210,7 +2214,9 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 		  refcount, fcport, fcport->rdata->ids.port_id);
 
 	/* Cleanup cmds re-use the same TID as the original I/O */
+	spin_lock_irqsave(&fcport->rport_lock, flags);
 	io_req->cmd_type = QEDF_CLEANUP;
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
 	io_req->return_scsi_cmd_on_abts = return_scsi_cmd_on_abts;
 
 	init_completion(&io_req->cleanup_done);
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7825765c936cd..91f3f1d7098eb 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2805,6 +2805,8 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 	struct qedf_ioreq *io_req;
 	struct qedf_rport *fcport;
 	u32 comp_type;
+	u8 io_comp_type;
+	unsigned long flags;
 
 	comp_type = (cqe->cqe_data >> FCOE_CQE_CQE_TYPE_SHIFT) &
 	    FCOE_CQE_CQE_TYPE_MASK;
@@ -2838,11 +2840,14 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 		return;
 	}
 
+	spin_lock_irqsave(&fcport->rport_lock, flags);
+	io_comp_type = io_req->cmd_type;
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
 
 	switch (comp_type) {
 	case FCOE_GOOD_COMPLETION_CQE_TYPE:
 		atomic_inc(&fcport->free_sqes);
-		switch (io_req->cmd_type) {
+		switch (io_comp_type) {
 		case QEDF_SCSI_CMD:
 			qedf_scsi_completion(qedf, cqe, io_req);
 			break;
-- 
2.40.1



