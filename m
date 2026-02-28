Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10035AC12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302738; cv=none; b=XsvW61ZGA9sM5NEGkJh6eOpCLIAEkk7m8PH4mtagXsM0kuUPhEalX/lxPBTrPQPc/ZQJSZReO8k8FVtMFmhKJ3ljK17j0hLrztpFTOFP24aiFh4vrfDfRqs6MxVbVbB/02LzFsX9Gw14/wYPx7bTSvR1tuyrqI4R7cni2ftg45Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302738; c=relaxed/simple;
	bh=pF4WzTXAS//lD/oYXX7k+lGgZQMJj+pRIE3it9DL96g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl1NFzHNzZ+KTowGMkBoCcN90+BMvSvZkqIYQaVND3CvtD4UYCFvKrBzllA1qnejVgr4kNqdeIyixaFM4rOQ3dEWWhouIxRvmb6tmHnk4wcNkdsSmt3s8fgSvaz3igA19R/ETTBjtKmdO4cy6BLJdfs0q+mur4xKWpfuZHP+ij4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qvfyfUBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qvfyfUBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31AEC19423;
	Sat, 28 Feb 2026 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302738;
	bh=pF4WzTXAS//lD/oYXX7k+lGgZQMJj+pRIE3it9DL96g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvfyfUBbJ86EfA0KQ0SFZJ3hN2OF9PohtpSN6ax84MSR/3i9sluUA8S6V3HLF92bI
	 wPavGTx8YW/1rppXx5Kg7V06yemYf19I1Ey+DLa3DCZ0GECsG4NLa1pDW7ecBH6CCE
	 mDv1G+2uEY1i07WeYvbUruZb5HRbY/ToNtXFhClceMr4H1L0gaHhdndQdIxliziEQ+
	 b7K84aBoSspWv8TJTxg80tFZkMGIP6+PJEeuiunM3WQp0riPwsV5x79DfuMC9pD9Av
	 YLeMIYwmk/78zMFIyvHiIS7jh0JIY2t4Zc6RdOnpyCE8AFV3xZp3aDceEZ3OeSYP28
	 kIULfjEysfKgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/147] svcrdma: Maintain a Receive water mark
Date: Sat, 28 Feb 2026 13:16:50 -0500
Message-ID: <20260228181736.1605592-102-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c558d47596867ff1082fd7475b63670f63f7f5cf ]

Post more Receives when the number of pending Receives drops below
a water mark. The batch mechanism is disabled if the underlying
device cannot support a reasonably-sized Receive Queue.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_rdma.h          |  2 ++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  | 10 ++++++++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 2b870a3f391b1..e2f316f52df66 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -96,6 +96,8 @@ struct svcxprt_rdma {
 	spinlock_t	     sc_rw_ctxt_lock;
 	struct list_head     sc_rw_ctxts;
 
+	u32		     sc_pending_recvs;
+	u32		     sc_recv_batch;
 	struct list_head     sc_rq_dto_q;
 	spinlock_t	     sc_rq_dto_lock;
 	struct ib_qp         *sc_qp;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index f2264179d9000..d5d15d1012302 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -273,6 +273,7 @@ static bool svc_rdma_refresh_recvs(struct svcxprt_rdma *rdma,
 		ctxt->rc_temp = temp;
 		ctxt->rc_recv_wr.next = recv_chain;
 		recv_chain = &ctxt->rc_recv_wr;
+		rdma->sc_pending_recvs++;
 	}
 	if (!recv_chain)
 		return false;
@@ -290,6 +291,8 @@ static bool svc_rdma_refresh_recvs(struct svcxprt_rdma *rdma,
 		bad_wr = bad_wr->next;
 		svc_rdma_recv_ctxt_put(rdma, ctxt);
 	}
+	/* Since we're destroying the xprt, no need to reset
+	 * sc_pending_recvs. */
 	return false;
 }
 
@@ -318,6 +321,8 @@ static void svc_rdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
 	struct ib_cqe *cqe = wc->wr_cqe;
 	struct svc_rdma_recv_ctxt *ctxt;
 
+	rdma->sc_pending_recvs--;
+
 	/* WARNING: Only wc->wr_cqe and wc->status are reliable */
 	ctxt = container_of(cqe, struct svc_rdma_recv_ctxt, rc_cqe);
 
@@ -334,8 +339,9 @@ static void svc_rdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
 	 * to reduce the likelihood of replayed requests once the
 	 * client reconnects.
 	 */
-	if (!svc_rdma_refresh_recvs(rdma, 1, false))
-		goto flushed;
+	if (rdma->sc_pending_recvs < rdma->sc_max_requests)
+		if (!svc_rdma_refresh_recvs(rdma, rdma->sc_recv_batch, false))
+			goto flushed;
 
 	/* All wc fields are now known to be valid */
 	ctxt->rc_byte_len = wc->byte_len;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index c895f80df659c..b00ea4dbe7d40 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -404,11 +404,14 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_req_size = svcrdma_max_req_size;
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
-	rq_depth = newxprt->sc_max_requests + newxprt->sc_max_bc_requests;
+	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
+	rq_depth = newxprt->sc_max_requests + newxprt->sc_max_bc_requests +
+		   newxprt->sc_recv_batch;
 	if (rq_depth > dev->attrs.max_qp_wr) {
 		pr_warn("svcrdma: reducing receive depth to %d\n",
 			dev->attrs.max_qp_wr);
 		rq_depth = dev->attrs.max_qp_wr;
+		newxprt->sc_recv_batch = 1;
 		newxprt->sc_max_requests = rq_depth - 2;
 		newxprt->sc_max_bc_requests = 2;
 	}
-- 
2.51.0

