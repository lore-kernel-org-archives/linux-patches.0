Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273CC35C68D;
	Tue, 21 Jul 2026 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669337; cv=none; b=eo6qcXRd5C7B2qNzsOHX1RteC4QmFExy8LfSZnxpqCHcK1T8+yBQMbFBpuzdoExY4MJcKz37Z4Vl/3xtpd/KpgmTXJvBAzuQDAi+jyKxRZqQTreOaJYngnY+aT4oWFwdQAL7ynltfyn8BvpEYJXJe+qip6x79VrVyI+IvvNDYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669337; c=relaxed/simple;
	bh=Uotn2J8i8Ld2DQdBw3ZfVOJwHA8vqE/IXqlmW0GPQN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE/fb4dZFQvfoRALto4hpnb9MmClw1QXfT6qHk4WbULDrRjkfBPG/laRbnb1UzylwSGHxtLRNperyFjYCewUqVZGdbUdR1RlQuCWGvfZe6DYpq8SIlv2eEOggw2XCSE7d3OsIB9kxr/MxTASvDxWf9adHO4XNFbLkmcTJxkGR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdiqW0Vv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdiqW0Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9386C1F00A3D;
	Tue, 21 Jul 2026 21:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669332;
	bh=VMUKwNCS5e2z/bKE3Ln/C/3YivKAPnrdMatZi51fKJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdiqW0VvyqysH27peC8QFatfLv9bck9Mm3VD9s43BxayzGAvB/I3h3hjYvgF8TJT1
	 ebJz7ICRjwBAcrUb6BSr4g6YfQ/AZQTHdpsvJJOZ3QnJuxl4sasck2sBq2uihcsY3B
	 HCNCZvBIwD5BdyjleOpQuEaLMwbxsPylGBZAqnj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0513/1067] xprtrdma: Remove temp allocation of rpcrdma_rep objects
Date: Tue, 21 Jul 2026 17:18:34 +0200
Message-ID: <20260721152436.088072569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0e13dd9ea8be46f980a46c3ffd8cb786f3e2fb5b ]

The original code was designed so that most calls to
rpcrdma_rep_create() would occur on the NUMA node that the device
preferred. There are a few cases where that's not possible, so
those reps are marked as temporary.

However, we have the device (and its preferred node) already in
rpcrdma_rep_create(), so let's use that to guarantee the memory
is allocated from the correct node.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: e786233d2e0b ("xprtrdma: Decouple req recycling from RPC completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |  3 +-
 net/sunrpc/xprtrdma/verbs.c     | 57 ++++++++++++++-------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |  3 +-
 3 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 190a4de239c85a..1478c41c7e9da7 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1471,8 +1471,7 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 		credits = 1;	/* don't deadlock */
 	else if (credits > r_xprt->rx_ep->re_max_requests)
 		credits = r_xprt->rx_ep->re_max_requests;
-	rpcrdma_post_recvs(r_xprt, credits + (buf->rb_bc_srv_max_requests << 1),
-			   false);
+	rpcrdma_post_recvs(r_xprt, credits + (buf->rb_bc_srv_max_requests << 1));
 	if (buf->rb_credits != credits)
 		rpcrdma_update_cwnd(r_xprt, credits);
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 4132a505d742ad..d468ebf6de8062 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -69,13 +69,15 @@ static void rpcrdma_sendctx_put_locked(struct rpcrdma_xprt *r_xprt,
 				       struct rpcrdma_sendctx *sc);
 static int rpcrdma_reqs_setup(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_reqs_reset(struct rpcrdma_xprt *r_xprt);
-static void rpcrdma_rep_destroy(struct rpcrdma_rep *rep);
 static void rpcrdma_reps_unmap(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_mrs_create(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_mrs_destroy(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_ep_get(struct rpcrdma_ep *ep);
 static int rpcrdma_ep_put(struct rpcrdma_ep *ep);
 static struct rpcrdma_regbuf *
+rpcrdma_regbuf_alloc_node(size_t size, enum dma_data_direction direction,
+			  int node);
+static struct rpcrdma_regbuf *
 rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction);
 static void rpcrdma_regbuf_dma_unmap(struct rpcrdma_regbuf *rb);
 static void rpcrdma_regbuf_free(struct rpcrdma_regbuf *rb);
@@ -505,7 +507,7 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 	 * outstanding Receives.
 	 */
 	rpcrdma_ep_get(ep);
-	rpcrdma_post_recvs(r_xprt, 1, true);
+	rpcrdma_post_recvs(r_xprt, 1);
 
 	rc = rdma_connect(ep->re_id, &ep->re_remote_cma);
 	if (rc)
@@ -938,18 +940,20 @@ static void rpcrdma_reqs_reset(struct rpcrdma_xprt *r_xprt)
 }
 
 static noinline
-struct rpcrdma_rep *rpcrdma_rep_create(struct rpcrdma_xprt *r_xprt,
-				       bool temp)
+struct rpcrdma_rep *rpcrdma_rep_create(struct rpcrdma_xprt *r_xprt)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
+	struct rpcrdma_ep *ep = r_xprt->rx_ep;
+	struct ib_device *device = ep->re_id->device;
 	struct rpcrdma_rep *rep;
 
 	rep = kzalloc(sizeof(*rep), XPRTRDMA_GFP_FLAGS);
 	if (rep == NULL)
 		goto out;
 
-	rep->rr_rdmabuf = rpcrdma_regbuf_alloc(r_xprt->rx_ep->re_inline_recv,
-					       DMA_FROM_DEVICE);
+	rep->rr_rdmabuf = rpcrdma_regbuf_alloc_node(ep->re_inline_recv,
+						    DMA_FROM_DEVICE,
+						    ibdev_to_node(device));
 	if (!rep->rr_rdmabuf)
 		goto out_free;
 
@@ -964,7 +968,6 @@ struct rpcrdma_rep *rpcrdma_rep_create(struct rpcrdma_xprt *r_xprt,
 	rep->rr_recv_wr.wr_cqe = &rep->rr_cqe;
 	rep->rr_recv_wr.sg_list = &rep->rr_rdmabuf->rg_iov;
 	rep->rr_recv_wr.num_sge = 1;
-	rep->rr_temp = temp;
 
 	spin_lock(&buf->rb_lock);
 	list_add(&rep->rr_all, &buf->rb_all_reps);
@@ -983,17 +986,6 @@ static void rpcrdma_rep_free(struct rpcrdma_rep *rep)
 	kfree(rep);
 }
 
-static void rpcrdma_rep_destroy(struct rpcrdma_rep *rep)
-{
-	struct rpcrdma_buffer *buf = &rep->rr_rxprt->rx_buf;
-
-	spin_lock(&buf->rb_lock);
-	list_del(&rep->rr_all);
-	spin_unlock(&buf->rb_lock);
-
-	rpcrdma_rep_free(rep);
-}
-
 static struct rpcrdma_rep *rpcrdma_rep_get_locked(struct rpcrdma_buffer *buf)
 {
 	struct llist_node *node;
@@ -1025,10 +1017,8 @@ static void rpcrdma_reps_unmap(struct rpcrdma_xprt *r_xprt)
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
 	struct rpcrdma_rep *rep;
 
-	list_for_each_entry(rep, &buf->rb_all_reps, rr_all) {
+	list_for_each_entry(rep, &buf->rb_all_reps, rr_all)
 		rpcrdma_regbuf_dma_unmap(rep->rr_rdmabuf);
-		rep->rr_temp = true;	/* Mark this rep for destruction */
-	}
 }
 
 static void rpcrdma_reps_destroy(struct rpcrdma_buffer *buf)
@@ -1245,14 +1235,15 @@ void rpcrdma_buffer_put(struct rpcrdma_buffer *buffers, struct rpcrdma_req *req)
  * or Replies they may be registered externally via frwr_map.
  */
 static struct rpcrdma_regbuf *
-rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction)
+rpcrdma_regbuf_alloc_node(size_t size, enum dma_data_direction direction,
+			  int node)
 {
 	struct rpcrdma_regbuf *rb;
 
-	rb = kmalloc(sizeof(*rb), XPRTRDMA_GFP_FLAGS);
+	rb = kmalloc_node(sizeof(*rb), XPRTRDMA_GFP_FLAGS, node);
 	if (!rb)
 		return NULL;
-	rb->rg_data = kmalloc(size, XPRTRDMA_GFP_FLAGS);
+	rb->rg_data = kmalloc_node(size, XPRTRDMA_GFP_FLAGS, node);
 	if (!rb->rg_data) {
 		kfree(rb);
 		return NULL;
@@ -1264,6 +1255,12 @@ rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction)
 	return rb;
 }
 
+static struct rpcrdma_regbuf *
+rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction)
+{
+	return rpcrdma_regbuf_alloc_node(size, direction, NUMA_NO_NODE);
+}
+
 /**
  * rpcrdma_regbuf_realloc - re-allocate a SEND/RECV buffer
  * @rb: regbuf to reallocate
@@ -1341,10 +1338,9 @@ static void rpcrdma_regbuf_free(struct rpcrdma_regbuf *rb)
  * rpcrdma_post_recvs - Refill the Receive Queue
  * @r_xprt: controlling transport instance
  * @needed: current credit grant
- * @temp: mark Receive buffers to be deleted after one use
  *
  */
-void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
 	struct rpcrdma_ep *ep = r_xprt->rx_ep;
@@ -1358,8 +1354,7 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 	if (likely(ep->re_receive_count > needed))
 		goto out;
 	needed -= ep->re_receive_count;
-	if (!temp)
-		needed += RPCRDMA_MAX_RECV_BATCH;
+	needed += RPCRDMA_MAX_RECV_BATCH;
 
 	if (atomic_inc_return(&ep->re_receiving) > 1)
 		goto out_dec;
@@ -1368,12 +1363,8 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 	wr = NULL;
 	while (needed) {
 		rep = rpcrdma_rep_get_locked(buf);
-		if (rep && rep->rr_temp) {
-			rpcrdma_rep_destroy(rep);
-			continue;
-		}
 		if (!rep)
-			rep = rpcrdma_rep_create(r_xprt, temp);
+			rep = rpcrdma_rep_create(r_xprt);
 		if (!rep)
 			break;
 		if (!rpcrdma_regbuf_dma_map(r_xprt, rep->rr_rdmabuf)) {
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 5e5ff6784ef5ff..4b810c0b63081b 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -198,7 +198,6 @@ struct rpcrdma_rep {
 	__be32			rr_proc;
 	int			rr_wc_flags;
 	u32			rr_inv_rkey;
-	bool			rr_temp;
 	struct rpcrdma_regbuf	*rr_rdmabuf;
 	struct rpcrdma_xprt	*rr_rxprt;
 	struct rpc_rqst		*rr_rqst;
@@ -466,7 +465,7 @@ void rpcrdma_flush_disconnect(struct rpcrdma_xprt *r_xprt, struct ib_wc *wc);
 int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt);
 void rpcrdma_xprt_disconnect(struct rpcrdma_xprt *r_xprt);
 
-void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp);
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed);
 
 /*
  * Buffer calls - xprtrdma/verbs.c
-- 
2.53.0



