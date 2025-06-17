Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37292ECE99;
	Tue, 17 Jun 2025 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176131; cv=none; b=S6Zf4t39ZqoYibDxAyhDh3YGzoigMSQOZ2DkFDyEaosqrvutROZV1Fc1l2A2R1VEu7lGxgOWEB9QiSL/CQ7IzLEMIbzlhQl9UYwBYHt1XWk2eTOXAQg8J0H9UFliOa86JwWzQI72o4H9QvTRjttgR8nVnh8gN/Ra/arGebmANME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176131; c=relaxed/simple;
	bh=w41V/a9PDHNCZz5/x68i+dQ2y35+6q6th9jUv9b4rzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB4d7hBmgJ+Q35e+wMo+uXqOuiAiq7K8thEeNg2Pmg5hzHLeCow8xIPcylgyeLTIHUA7MJwTv1wJM3cpRoSjZsZsATMJcnN4zkgi6PSQynsRPjFi9/qX0VYK6sbW9kJNGnHaDBHVM9vmP58zEo++wH64k2C8gT83gja7BqojdtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqVnyz72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqVnyz72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633F2C4CEE3;
	Tue, 17 Jun 2025 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176130;
	bh=w41V/a9PDHNCZz5/x68i+dQ2y35+6q6th9jUv9b4rzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqVnyz723lYq23IE2i1roMOel49IAEFtE2os9DACwAwJyVapg1WXpByq+PBbeOxx4
	 xSRPyQpyIbTlysYMfaJvWMg3i9qKBi4E/3WlEqct8WV/XJpk3PcOjHX1nfa3E/QpXa
	 AdcegU7ohbtW/vGIZleAjw6/eXxXrLgEmJHo2TxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 154/780] svcrdma: Reduce the number of rdma_rw contexts per-QP
Date: Tue, 17 Jun 2025 17:17:42 +0200
Message-ID: <20250617152457.769401628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index aca8bdf65d729..ca6172822b68a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -406,12 +406,12 @@ static void svc_rdma_xprt_done(struct rpcrdma_notification *rn)
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
@@ -462,12 +462,14 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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
2.39.5



