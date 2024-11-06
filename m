Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3651DF978;
	Wed,  6 Nov 2024 12:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895886; cv=none; b=NiAUOLT8jfZrU8NKAXOVVDrvdlR9bknsp/OMDkuUKyDY3HX9SMNhvD35lmXjT6XHlt8gVUJAc+nhqmYF7T1wKHMAva/JDGhVAxxB50u802AMsZVsOJ+fNqj3Ab2Y/iEImPyt9/t9dqr3mNHjwUwhqXHg9s8gCdg/J2gYHaQe0eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895886; c=relaxed/simple;
	bh=2Lci21Iu9UroG5hIh5QGbGUsEcswAvcx3ggoSj2vNH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6HA4jjrzGWNNJwpmjMXxesMETigW3HRtXNDTZtYv/FRr1O6MxoKpYEOZvGwBQ2QfcyAkiVDgp9oCHh3SZGolnS+tjpzrhdjXD89WjrLCBuh86nKdlOEVBUXdgVtqWsoimhs2Hx33ofdX/R4z2IbEbxcreKGKU3A7tFPP0vvXGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUkFxPxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUkFxPxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA8EC4CECD;
	Wed,  6 Nov 2024 12:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895885;
	bh=2Lci21Iu9UroG5hIh5QGbGUsEcswAvcx3ggoSj2vNH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUkFxPxYzPA99bvVm+BAq7FiPSPjZK/lbxG61INgzmz5lPlzPSoQFxqXjTHCn9HfJ
	 Z0du512ONHVYMMasEauhdm+LtPcFhMFi9Y2xeRAvZmVDvTmzetpgfd1cN4k8XIwHG4
	 iYVdZwTBclB34tTqYQhE93bzkv+2TOQhPi2vqWeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/245] RDMA/bnxt_re: synchronize the qp-handle table array
Date: Wed,  6 Nov 2024 13:01:11 +0100
Message-ID: <20241106120319.685539058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 76d3ddff7153cc0bcc14a63798d19f5d0693ea71 ]

There is a race between the CREQ tasklet and destroy qp when accessing the
qp-handle table. There is a chance of reading a valid qp-handle in the
CREQ tasklet handler while the QP is already moving ahead with the
destruction.

Fixing this race by implementing a table-lock to synchronize the access.

Fixes: f218d67ef004 ("RDMA/bnxt_re: Allow posting when QPs are in error")
Fixes: 84cf229f4001 ("RDMA/bnxt_re: Fix the qp table indexing")
Link: https://patch.msgid.link/r/1728912975-19346-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   |  4 ++++
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 13 +++++++++----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  2 ++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 03d517be9c52e..560a0f7bff85e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1532,9 +1532,11 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	u32 tbl_indx;
 	int rc;
 
+	spin_lock_bh(&rcfw->tbl_lock);
 	tbl_indx = map_qp_id_to_tbl_indx(qp->id, rcfw);
 	rcfw->qp_tbl[tbl_indx].qp_id = BNXT_QPLIB_QP_ID_INVALID;
 	rcfw->qp_tbl[tbl_indx].qp_handle = NULL;
+	spin_unlock_bh(&rcfw->tbl_lock);
 
 	bnxt_qplib_rcfw_cmd_prep((struct cmdq_base *)&req,
 				 CMDQ_BASE_OPCODE_DESTROY_QP,
@@ -1545,8 +1547,10 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 				sizeof(resp), 0);
 	rc = bnxt_qplib_rcfw_send_message(rcfw, &msg);
 	if (rc) {
+		spin_lock_bh(&rcfw->tbl_lock);
 		rcfw->qp_tbl[tbl_indx].qp_id = qp->id;
 		rcfw->qp_tbl[tbl_indx].qp_handle = qp;
+		spin_unlock_bh(&rcfw->tbl_lock);
 		return rc;
 	}
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index ca26b88a0a80f..e82bd37158ad6 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -634,17 +634,21 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 	case CREQ_QP_EVENT_EVENT_QP_ERROR_NOTIFICATION:
 		err_event = (struct creq_qp_error_notification *)qp_event;
 		qp_id = le32_to_cpu(err_event->xid);
+		spin_lock(&rcfw->tbl_lock);
 		tbl_indx = map_qp_id_to_tbl_indx(qp_id, rcfw);
 		qp = rcfw->qp_tbl[tbl_indx].qp_handle;
+		if (!qp) {
+			spin_unlock(&rcfw->tbl_lock);
+			break;
+		}
+		bnxt_qplib_mark_qp_error(qp);
+		rc = rcfw->creq.aeq_handler(rcfw, qp_event, qp);
+		spin_unlock(&rcfw->tbl_lock);
 		dev_dbg(&pdev->dev, "Received QP error notification\n");
 		dev_dbg(&pdev->dev,
 			"qpid 0x%x, req_err=0x%x, resp_err=0x%x\n",
 			qp_id, err_event->req_err_state_reason,
 			err_event->res_err_state_reason);
-		if (!qp)
-			break;
-		bnxt_qplib_mark_qp_error(qp);
-		rc = rcfw->creq.aeq_handler(rcfw, qp_event, qp);
 		break;
 	default:
 		/*
@@ -973,6 +977,7 @@ int bnxt_qplib_alloc_rcfw_channel(struct bnxt_qplib_res *res,
 			       GFP_KERNEL);
 	if (!rcfw->qp_tbl)
 		goto fail;
+	spin_lock_init(&rcfw->tbl_lock);
 
 	rcfw->max_timeout = res->cctx->hwrm_cmd_max_timeout;
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 45996e60a0d03..07779aeb75759 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -224,6 +224,8 @@ struct bnxt_qplib_rcfw {
 	struct bnxt_qplib_crsqe		*crsqe_tbl;
 	int qp_tbl_size;
 	struct bnxt_qplib_qp_node *qp_tbl;
+	/* To synchronize the qp-handle hash table */
+	spinlock_t			tbl_lock;
 	u64 oos_prev;
 	u32 init_oos_stats;
 	u32 cmdq_depth;
-- 
2.43.0



