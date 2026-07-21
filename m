Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00C846A60E;
	Tue, 21 Jul 2026 19:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661787; cv=none; b=LBFR8jUBOUc8WRu2alZolOOQWT6nixm5ASYUwYThzaIJOhbdoBUKYgeuFRnN2RcZlrtxQj4nkPetD9WX9WxymjllL4vG220I8J1tw708gpekMA69oPNIAz1zBWhrKeLsFul7qcJgPMP5UNQOvLh6sYLxSHM2XwUD3BhFuB7fBIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661787; c=relaxed/simple;
	bh=7jfmrXBUkg2tDDbMLp1I7YGx59gX+f8QJJjG7zsOOEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1WFgdAzjVXcCMOGKs3NLHowdo6e9L4sHKGRCz1JxPxEJONxHaLU98AQLo1Df9aZoLaGg//wW0SJd/BCEIIo3sgBG8UyGr0vRWuLX2i2S8k7P37NSJJaG/uOvnQOJC6NaeHk/IIrBGNLUAiJq4/PXA+qYdqKwqMKXIvlOB1vEoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9B2Za6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9B2Za6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA61F000E9;
	Tue, 21 Jul 2026 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661786;
	bh=pQTnIuCDEBZ+toN5Pio8aE6Y92KRM0SelcsR6ALoTSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9B2Za6Zn0pHh05ARnmZHYIf/5AvilZQd+jI2PPbMZiVMF9u5mQAF1daYl6TL1T/G
	 nZt2zA85/g/HCKoyM8LcII6iUiVR3aIgMKQEMuLDt6bo9+mPO8qsp1inQYAGHG5VO/
	 +oRT1vyfJgG0vVA3oV63+EyymI609g/1roBLBwi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0199/1276] RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path
Date: Tue, 21 Jul 2026 17:10:42 +0200
Message-ID: <20260721152450.540325549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristmd@gmail.com>

[ Upstream commit d6ab440240a04b8737ee4c7bb21af9182e451733 ]

For non-SRQ QPs, the responder reads WQE fields directly from the
shared queue buffer mapped into userspace. This allows a malicious
user to modify fields like num_sge or sge entries while the kernel
is processing the WQE, leading to out-of-bounds reads in
rxe_resp_check_length() and copy_data().

Introduce get_recv_wqe() that validates num_sge and copies the WQE
to a kernel-local buffer before processing, matching the approach
already used for SRQ WQEs in get_srq_wqe(). The srq_wqe buffer is
reused since SRQ and non-SRQ paths are mutually exclusive per QP.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260518215040.1598586-3-tristan@talencesecurity.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 55619eedd4b5cd..5611f63a1115cc 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -309,6 +309,29 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	return RESPST_CHK_LENGTH;
 }
 
+static enum resp_states rxe_get_recv_wqe(struct rxe_qp *qp)
+{
+	struct rxe_queue *q = qp->rq.queue;
+	struct rxe_recv_wqe *wqe;
+	unsigned int num_sge;
+	size_t size;
+
+	wqe = queue_head(q, QUEUE_TYPE_FROM_CLIENT);
+	if (!wqe)
+		return RESPST_ERR_RNR;
+
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > qp->rq.max_sge)) {
+		rxe_dbg_qp(qp, "invalid num_sge in recv WQE\n");
+		return RESPST_ERR_MALFORMED_WQE;
+	}
+	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
+	memcpy(&qp->resp.srq_wqe, wqe, size);
+
+	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
+	return RESPST_CHK_LENGTH;
+}
+
 static enum resp_states check_resource(struct rxe_qp *qp,
 				       struct rxe_pkt_info *pkt)
 {
@@ -329,9 +352,7 @@ static enum resp_states check_resource(struct rxe_qp *qp,
 		if (srq)
 			return get_srq_wqe(qp);
 
-		qp->resp.wqe = queue_head(qp->rq.queue,
-				QUEUE_TYPE_FROM_CLIENT);
-		return (qp->resp.wqe) ? RESPST_CHK_LENGTH : RESPST_ERR_RNR;
+		return rxe_get_recv_wqe(qp);
 	}
 
 	return RESPST_CHK_LENGTH;
-- 
2.53.0



