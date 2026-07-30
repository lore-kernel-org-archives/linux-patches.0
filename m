Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162A244998F;
	Thu, 30 Jul 2026 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425334; cv=none; b=FK7z28oKLxd+zx+6shsw8SYZVfFTJR6hBCmpNoDHyTnSy7b0bk8w3CdqmQweL0ARrOxtVl/P4BbzBXchgwLWzDMNDRjbD0z9juKMnH7eNys5Nqp6hp++187Z9eAaN5c/cMMF0YJf7ItSwhbp2YUvKgDeJTktqzaVkSnhpGVwoNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425334; c=relaxed/simple;
	bh=V0rscueQJU2sBtj/bbX8JgRNti1JZGost+4ITBCvh74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTD6f344nw9clcBVMo9dlqf/Qy+D3y99fTCiGLTIyzdJQOZGAS5w2p+x55Ggu+RPDFzNSI648tYs/py5rwQqVyIuEeJvOSxZBbiiT2rnlX+OQu3cSza2R44canTRhexI7NnLzq9l/lsVHrA3Jm3ATlvGOdsHFS/0GEBkll7WuvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7GYXw//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7GYXw//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EB51F000E9;
	Thu, 30 Jul 2026 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425333;
	bh=8hB8DXSaU3OwTxUezSABYT3G4bxS56DonoTinPv8yH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7GYXw//u/aISNNWyG7BKAxSliu3b7gXFK/8tzuoUC9heCp0+KN6JogAfIJdU5eTl
	 nOoPGV+++HpEU/wA8V18JdgAvtdxHj6KTVDawCoFuu92nY8hDO0ubgigaw0QbWqwU1
	 Ar9+0s1uRhcSaxevs8CucDpZOqBuwe2szbO6CwG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/602] xprtrdma: Clear receive-side ownership pointers on release
Date: Thu, 30 Jul 2026 16:07:04 +0200
Message-ID: <20260730141436.683459041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2ae8e7afbc63bf84243367f89eb43571f0345a74 ]

Three small ownership-state cleanups land the transport in a
state that lets future reviewers reason about each pointer
locally rather than tracing the whole reply path:

rpcrdma_rep_put() clears rep->rr_rqst before the rep enters
rb_free_reps so that no rep on the free list still carries a
stale rqst pointer.  rpcrdma_reply_handler() and
rpcrdma_unpin_rqst() are the only sites that set rr_rqst;
rpcrdma_reply_handler() hands the rep through
rpcrdma_rep_put(), and rpcrdma_unpin_rqst() NULLs rr_rqst
directly because its error path abandons the rep for
teardown cleanup rather than returning it to rb_free_reps.

rpcrdma_reply_put() NULLs req->rl_reply before calling
rpcrdma_rep_put().  The previous order placed the rep on
rb_free_reps while req->rl_reply still pointed at it; the
window was harmless because xprt_rdma_free_slot() holds the
req exclusively across the pair, but closing it makes the
invariant 'rep on rb_free_reps implies no req references it'
strictly checkable.

rpcrdma_sendctx_unmap() and rpcrdma_sendctx_cancel() clear
req->rl_sendctx after dropping the sendctx pointer in the
sendctx ring.  Without this, req->rl_sendctx survives across
Send completion and points at a sendctx that may already have
been reassigned by rpcrdma_sendctx_get_locked() to a different
req.  No caller dereferences the stale pointer today --
rpcrdma_prepare_send_sges() overwrites it before the next
Send -- but a NULL is a more honest representation of 'the
Send is no longer outstanding' and lets the assertion patch
that follows trip on any future regression.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |  4 ++++
 net/sunrpc/xprtrdma/verbs.c    | 12 ++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e201b37578a70e..aa57e057ff451f 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -542,6 +542,7 @@ void rpcrdma_sendctx_unmap(struct rpcrdma_sendctx *sc)
 
 	rpcrdma_sendctx_dma_unmap(sc);
 	sc->sc_req = NULL;
+	req->rl_sendctx = NULL;
 	rpcrdma_req_put(req);
 }
 
@@ -550,8 +551,11 @@ void rpcrdma_sendctx_unmap(struct rpcrdma_sendctx *sc)
  */
 static void rpcrdma_sendctx_cancel(struct rpcrdma_sendctx *sc)
 {
+	struct rpcrdma_req *req = sc->sc_req;
+
 	rpcrdma_sendctx_dma_unmap(sc);
 	sc->sc_req = NULL;
+	req->rl_sendctx = NULL;
 }
 
 /* Prepare an SGE for the RPC-over-RDMA transport header.
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index efd91ed249fabe..e2d3cee825cd7f 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1080,9 +1080,15 @@ static struct rpcrdma_rep *rpcrdma_rep_get_locked(struct rpcrdma_buffer *buf)
  * @buf: buffer pool
  * @rep: rep to release
  *
+ * The rep's transient association with an rpc_rqst, established
+ * by rpcrdma_reply_handler() and torn down here, must not survive
+ * onto rb_free_reps: rpcrdma_post_recvs() pulls reps from the free
+ * list to re-post them, and a non-NULL rr_rqst on a free-listed rep
+ * would imply the rep is still referenced by a req.
  */
 void rpcrdma_rep_put(struct rpcrdma_buffer *buf, struct rpcrdma_rep *rep)
 {
+	rep->rr_rqst = NULL;
 	llist_add(&rep->rr_node, &buf->rb_free_reps);
 }
 
@@ -1265,9 +1271,11 @@ rpcrdma_mr_get(struct rpcrdma_xprt *r_xprt)
  */
 void rpcrdma_reply_put(struct rpcrdma_buffer *buffers, struct rpcrdma_req *req)
 {
-	if (req->rl_reply) {
-		rpcrdma_rep_put(buffers, req->rl_reply);
+	struct rpcrdma_rep *rep = req->rl_reply;
+
+	if (rep) {
 		req->rl_reply = NULL;
+		rpcrdma_rep_put(buffers, rep);
 	}
 	/* I2: rl_reply NULL after the put closes the
 	 * 'rep on rb_free_reps still referenced by req' window.
-- 
2.53.0



