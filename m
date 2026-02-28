Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC055359A83
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302420; cv=none; b=N9DdrQcfdk4J3xwtqLTGLRJAuYliTpynQWsGhHKOEKangf0cxc1fLGEYUMS+RekITHVD4tcufCuUvLRb3tZBHlrPJkrTOtxLZvQ2vMUGSgcc1Znf9xXApaa+zvg2OvrzCPpt5YwG6MGeFBM4wKQnnarUs1a/Ecyao4UmOpoRSwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302420; c=relaxed/simple;
	bh=UcbijL9Vbf2D4SMdOlUoDCMR0ontZCLZB3Rg9PFRO44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW3tJFotRRXON8hAWzCf9BrIO3ExDutpidWAgstkioxavj9zLheRRuRCH4ZzM+bvRbN65be9vs0LRoHccZfreUULYGJXAofVbXWpeUIC3ccnlbUJy7/beEKjvHp7eGK4AwZ9F/rqRUQV+KFhe3mSC20KMT84Xtjk1uXv34NKRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKFC5u/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKFC5u/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33119C19423;
	Sat, 28 Feb 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302420;
	bh=UcbijL9Vbf2D4SMdOlUoDCMR0ontZCLZB3Rg9PFRO44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKFC5u/y88IJkaurCL/1U2silWIzv7R3eXMF6J3m5peFqEahsehNmL6pbxnv69xPi
	 WIVkVTCv243mFIyU0nuXB8kXZ2dIRMKfS1FTTNMrquOVOlCRI99tUYdJiPkHTaXjgY
	 1H2Jxubdl5yI80zXUMleTPFeSG2ycdSWoHb2AEhi3brSee7tCjCB55ZkSV56so5aYf
	 u7DHeHKtXYfs0VIm2/cZgt5gNkm6w+qpQ1PhWVrWAbSrYhpB54JVJDwUa4XoOFEcl7
	 nDrzDv9KIMYjzGjd9LfetVpoBBOkH7ErKs+K3N5Q+nGzfTuCA5peruE/ffTktMjic9
	 afduIeHlOYUsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/232] svcrdma: Reduce the number of rdma_rw contexts per-QP
Date: Sat, 28 Feb 2026 13:10:09 -0500
Message-ID: <20260228181127.1592657-156-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 3d3b15f9d6d51..c5721b75d32a7 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -365,12 +365,12 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
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
@@ -418,12 +418,14 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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

