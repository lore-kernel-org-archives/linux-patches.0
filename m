Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D40646A60E;
	Tue, 21 Jul 2026 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661785; cv=none; b=qyhvNPZW/5oVPg3aIF78MSQeVyeHLgjlTnkODtrbameAWMkmRSyuIQfcaKEOivaHjO5myn5HheExJTV0YG5gK/30w7QgKS6cArfUEhJqido3nO3o85LMBa2DsuHZxL6lhQh+VcKK5MndgCAWEENmjax9KaE5k0nlIV/D4sUJpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661785; c=relaxed/simple;
	bh=6E088KB+7LeOE05PaVDrPIAro6U7N6OmxmVHA49XuYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pzfa/9O1+/8VWiRfHuGfJhzV8jhabia/Bqtvuii60DxAB/4Af1hvfIraoQwDuOZ9pGwMih+iyRL8ozvbN8vbsMwLhtoGYDAbrXp8J0UvnzenhKL6U0mICAQ++DBSezxU7gDGd2So+sI+8ldwAtX1hPSXsbmhsqop+V/Nktr/+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/zEdC0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/zEdC0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832D41F000E9;
	Tue, 21 Jul 2026 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661784;
	bh=cpCIp2YeKdWRBan6qj2WiPhpUFLCksUDbTz2UcQlZxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/zEdC0dbW3uGUP8mjCdInm9LXNzq9NAROaUEAhmSBeZYHvkwwhVQTODGjrzLT9Q5
	 6a19avw16zi5WKIjMGFFHs1AQKM9lpfz+GK2pl3BetEAlEDLr8BUuUib90FIAmlrLU
	 4WbDRCWL4Jr4J4oZ1JNmYNhXrUEt59oberxsYu+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0198/1276] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Tue, 21 Jul 2026 17:10:41 +0200
Message-ID: <20260721152450.515430798@linuxfoundation.org>
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

[ Upstream commit 22b8fbded65b8c441b634a185f8da67657df6c50 ]

get_srq_wqe() reads wqe->dma.num_sge from the shared receive queue
buffer, which is mapped into userspace. It validates num_sge against
max_sge, but then re-reads the same field to calculate the memcpy
size. A concurrent userspace thread can modify num_sge between
validation and use, causing a heap buffer overflow when copying the
WQE into qp->resp.srq_wqe.

Read num_sge into a local variable and use it for both the bounds
check and the size calculation.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260518215040.1598586-2-tristan@talencesecurity.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 29e32b91d74b88..55619eedd4b5cd 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -263,6 +263,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
 	unsigned int count;
+	unsigned int num_sge;
 	size_t size;
 	unsigned long flags;
 
@@ -278,12 +279,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 
 	/* don't trust user space data */
-	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > srq->rq.max_sge)) {
 		spin_unlock_irqrestore(&srq->rq.consumer_lock, flags);
 		rxe_dbg_qp(qp, "invalid num_sge in SRQ entry\n");
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-	size = sizeof(*wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
-- 
2.53.0



