Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747C626299;
	Sat, 12 Sep 2026 19:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241916; cv=none; b=qEeMJtKG/Y128e5tx82l4nRbotxIQmM+gr2RByLpJFcENxn3SgUfScFI6em5CwCtjEKcje7L23U8JvcolhqAUINZ4gC9YVQiCQw4geReO6m9lAdtNMHTe/Eg/rksHvbM9lSKY2pdU0J3QpdS0eGEr6aZg/nBXgPn4qPalTAEdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241916; c=relaxed/simple;
	bh=D43bDUkbjYtAKuDlo4gRX3zf5tGcim/1yZKKjoPh1N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKAvwMidtxvEdU3CKfJHfO7jQqGIhmsEaqeAS/4WjzjJNb+rKXFpINx8/c7ra3UkdM/E74vGcPM6iC6EOb5YdRkCRQ1rHnuxR55R5Ykr/zbKsmAjzaqmdCc3t526MN+Po9vQpB+4VwCF6sB0hn6bQlbgq8V3q5oDQ2OqnnF5stg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEDongIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEDongIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778B51F000FF;
	Sat, 12 Sep 2026 19:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241915;
	bh=7LB8sgKYK0wkyJYea03vlkfNFXPEFKvOFKRjGGJIEUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEDongIoeL2DNJNb0Q2w9aB1GyFKl7tKtdeC0cSF7BURe65xIQypysqsONrwcBpWE
	 O/ldQ1e7iI/qGlAL6HklzP5KtjOO1mMhypdC8xvwP882v7sHiVxj/A+ZnfQHVpeFPm
	 ggtqY0AhEDr/+pajF/8Tk13zjJ61cOp6FHuel0bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/798] RDMA/rxe: Fix over copying in get_srq_wqe
Date: Sat, 12 Sep 2026 08:57:05 +0200
Message-ID: <20260912065521.588059754@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit ec0fa2445c18ec49a0b7ee0aaa82d1ec00968fc9 ]

Currently get_srq_wqe() in rxe_resp.c copies the maximum possible number
of bytes from the wqe into the QPs copy of the SRQ wqe. This is usually
extra work and risks reading past the end of the SRQ circular buffer if
the SRQ is configured with less than the maximum possible number of SGEs.

Check the number of SGEs is not too large.
Compute the actual number of bytes in the WR and copy only those.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20210618045742.204195-5-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[doebel: context adjustment from upstream patch to 5.10. needed as a prerequisite
 for "RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe" ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 83c03212099a2..38e6535196849 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -292,6 +292,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_queue *q = srq->rq.queue;
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
+	size_t size;
 
 	if (srq->error)
 		return RESPST_ERR_RNR;
@@ -304,8 +305,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 		return RESPST_ERR_RNR;
 	}
 
-	/* note kernel and user space recv wqes have same size */
-	memcpy(&qp->resp.srq_wqe, wqe, sizeof(qp->resp.srq_wqe));
+	/* don't trust user space data */
+	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
+		return RESPST_ERR_MALFORMED_WQE;
+	}
+	size = sizeof(wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	advance_consumer(q);
-- 
2.53.0



