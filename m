Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9119938D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302193; cv=none; b=FvhNcFDi7kiMgCUJUNCXRkVJYDP7zhQshhwmsxoeula9t8ZxVrxZAe7myDbSnQLTZBH3ez7FGsfHWFi8UKlfycfQdv/Rs0MdiYIure4IyJyxwhMgAA2Zs4GNkWWNopLWx/Zt+u+FiZe0LvvEP5FflQlHPTQGXG4qJF7xrNHNDrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302193; c=relaxed/simple;
	bh=UIgduh9bNBvxqWGXUcmLRrdw2Pq7RyL38WxjrV/Y9O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAZHEwOb+Dc7+YtKKjURweIpDklxj5H8Mywoz8lLu/ZbfX5Fv4EylpQ2QAWXS+ZrSle1O7K+iulupkqBDYvGC9gI84LiECbRZyGYsuSD6NxIYY/jgvYIDNKuKWqn0yyRq+noFb8y5Rl27XDQeHmgbpIDEB1eris81zGhkStmaQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P9MnJYe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P9MnJYe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16A4C116D0;
	Sat, 28 Feb 2026 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302193;
	bh=UIgduh9bNBvxqWGXUcmLRrdw2Pq7RyL38WxjrV/Y9O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9MnJYe2NaCmyBegKCmINo4vZI3Ra7jvue4qzAbmTH13xa5MAod7gldG7J+pDcS2V
	 Djm7DeyYb9SPzrhpRsD4zlrOgIdwiLyu99SB0zbFoO9XxjJAMFmAEmrZB9BV9H3BKt
	 Krfp6RQLxQT0XPa+FGpEYZwKZOavINuJShjTXQ2zbKM3W80sza8278FI0X2gp7AIZE
	 LH4VYGZEvJLh3Fu5XC70GY4Dz6BwfPO/ziOOD0BwVCEq9dUwRGvIebQoWFKoak8Phr
	 p03nZbd2MyW6xE43imkMbqPWuVviI64UFiKzXPjhbi7+DkzrclaIBB9BbnvnBXSL+D
	 3QdCeqBrtJQUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/283] svcrdma: Reduce the number of rdma_rw contexts per-QP
Date: Sat, 28 Feb 2026 13:05:38 -0500
Message-ID: <20260228180709.1583486-196-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

[ Upstream commit 59243315890578a040a2d50ae9e001a2ef2fcb62 ]

There is an upper bound on the number of rdma_rw contexts that can
be created per QP.

This invisible upper bound is because rdma_create_qp() adds one or
more additional SQEs for each ctxt that the ULP requests via
qp_attr.cap.max_rdma_ctxs. The QP's actual Send Queue length is on
the order of the sum of qp_attr.cap.max_send_wr and a factor times
qp_attr.cap.max_rdma_ctxs. The factor can be up to three, depending
on whether MR operations are required before RDMA Reads.

This limit is not visible to RDMA consumers via dev->attrs. When the
limit is surpassed, QP creation fails with -ENOMEM. For example:

svcrdma's estimate of the number of rdma_rw contexts it needs is
three times the number of pages in RPCSVC_MAXPAGES. When MAXPAGES
is about 260, the internally-computed SQ length should be:

64 credits + 10 backlog + 3 * (3 * 260) = 2414

Which is well below the advertised qp_max_wr of 32768.

If RPCSVC_MAXPAGES is increased to 4MB, that's 1040 pages:

64 credits + 10 backlog + 3 * (3 * 1040) = 9434

However, QP creation fails. Dynamic printk for mlx5 shows:

calc_sq_size:618:(pid 1514): send queue size (9326 * 256 / 64 -> 65536) exceeds limits(32768)

Although 9326 is still far below qp_max_wr, QP creation still
fails.

Because the total SQ length calculation is opaque to RDMA consumers,
there doesn't seem to be much that can be done about this except for
consumers to try to keep the requested rdma_rw ctxt count low.

Fixes: 2da0f610e733 ("svcrdma: Increase the per-transport rw_ctx count")
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 41db2b1ee0d13..7bf4787678f8f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -363,12 +363,12 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
  */
 static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 {
+	unsigned int ctxts, rq_depth, maxpayload;
 	struct svcxprt_rdma *listen_rdma;
 	struct svcxprt_rdma *newxprt = NULL;
 	struct rdma_conn_param conn_param;
 	struct rpcrdma_connect_private pmsg;
 	struct ib_qp_init_attr qp_attr;
-	unsigned int ctxts, rq_depth;
 	struct ib_device *dev;
 	int ret = 0;
 	RPC_IFDEBUG(struct sockaddr *sap);
@@ -416,12 +416,14 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
-	/* Arbitrarily estimate the number of rw_ctxs needed for
-	 * this transport. This is enough rw_ctxs to make forward
-	 * progress even if the client is using one rkey per page
-	 * in each Read chunk.
+	/* Arbitrary estimate of the needed number of rdma_rw contexts.
 	 */
-	ctxts = 3 * RPCSVC_MAXPAGES;
+	maxpayload = min(xprt->xpt_server->sv_max_payload,
+			 RPCSVC_MAXPAYLOAD_RDMA);
+	ctxts = newxprt->sc_max_requests * 3 *
+		rdma_rw_mr_factor(dev, newxprt->sc_port_num,
+				  maxpayload >> PAGE_SHIFT);
+
 	newxprt->sc_sq_depth = rq_depth + ctxts;
 	if (newxprt->sc_sq_depth > dev->attrs.max_qp_wr)
 		newxprt->sc_sq_depth = dev->attrs.max_qp_wr;
-- 
2.51.0

