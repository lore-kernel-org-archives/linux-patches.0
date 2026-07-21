Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BE9471260;
	Tue, 21 Jul 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657392; cv=none; b=icfDasp3ph6xl/i86vicMfitzK/jcFSeOf+sbIEpLNlTftveiYF/ZsDsd0pgq9sxB/IkP2yFt2Omuirl2IxISoZJOIHpRDJzkeYdBCW38zGBwN67aDu5tk6foSqJBhjJ7Vnll7K9iuXv7wPuewZd0k6R+1iL1XtV2VEMBeK65KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657392; c=relaxed/simple;
	bh=UF9XIXasiFmqqKt83g2p/7Jl9iwVeMw/acQ7eHlG8Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFU4UktPdvazBJtcscL19BMThfzsWeMlC1Cxd3a7COLP3enl4IAd+EODiV8xx/lJvsw1bKtSljfDHuLRcfVSOwNOrj5RaLe5AypNTv9vEkHoWmUVy4kWrZvV/n+p/BO+VL1CJqt+v3SyCZ9WHYQBZjkhXafYGsjr6i9bRLPk4Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfJ6s/Ex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfJ6s/Ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785501F000E9;
	Tue, 21 Jul 2026 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657391;
	bh=op6EsjLrotPKOC6c24FKgSr1UNpjy/c4Glw1dy+AVvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfJ6s/Exnx5UG3bOOUGCFwfJiuvzouhD4O5/9/+v81cFYkj5ORTJw4eUPZ+qKRg0s
	 YNzA2RSX1WBnHRc+95tIpSZzFd7Y5eNJUGFvAprW9RLbjnVrKDZNzIn7pvTQjhodBQ
	 PYT/FX70ae5n8lUyn9OT0r7folaMqrC8L9iqC3Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0704/1611] xprtrdma: Return sendctx slot after Send preparation failure
Date: Tue, 21 Jul 2026 17:13:40 +0200
Message-ID: <20260721152531.215674144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 60e7870052f417d83965db144f70ae21fcfcf37f ]

rpcrdma_prepare_send_sges() gets a sendctx before it maps the SGEs
for the Send WR. If one of the mapping helpers fails, no Send WR
is posted, so no Send completion is guaranteed to advance rb_sc_tail.

Current cleanup clears sc_req so a later completion can sweep over
that slot, but a consecutive run of preparation failures can still
advance rb_sc_head until the ring appears full. At that point
rpcrdma_sendctx_get_locked() returns NULL and no Send can be posted to
produce the completion needed to recover the ring.

The trigger requires CONFIG_SUNRPC_XPRT_RDMA and an NFS/RDMA mount.
Mount setup and reliable DMA-map fault injection require local admin
authority. Unprivileged I/O on an existing mount can exercise the send
path, but a remote peer alone cannot force this local DMA-map failure.

Add rpcrdma_sendctx_unget_locked() for the single-consumer send path
to rewind rb_sc_head when the just-acquired sendctx is canceled before
ib_post_send(). Wake waiters after making the slot available again.
After the rewind, every slot the completion sweep visits belongs to a
posted Send, so rpcrdma_sendctx_put_locked() no longer needs to test
sc_req before unmapping.

Fixes: ae72950abf99 ("xprtrdma: Add data structure to manage RDMA Send arguments")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |  5 ++++-
 net/sunrpc/xprtrdma/verbs.c     | 40 +++++++++++++++++++++++++++++----
 net/sunrpc/xprtrdma/xprt_rdma.h |  2 ++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 425dbaec66fdfb..5d1f96bffd7491 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -792,6 +792,7 @@ inline int rpcrdma_prepare_send_sges(struct rpcrdma_xprt *r_xprt,
 				     struct xdr_buf *xdr,
 				     enum rpcrdma_chunktype rtype)
 {
+	struct rpcrdma_sendctx *sc;
 	int ret;
 
 	ret = -EAGAIN;
@@ -834,7 +835,9 @@ inline int rpcrdma_prepare_send_sges(struct rpcrdma_xprt *r_xprt,
 	return 0;
 
 out_unmap:
-	rpcrdma_sendctx_cancel(req->rl_sendctx);
+	sc = req->rl_sendctx;
+	rpcrdma_sendctx_cancel(sc);
+	rpcrdma_sendctx_unget_locked(r_xprt, sc);
 out_nosc:
 	trace_xprtrdma_prepsend_failed(&req->rl_slot, ret);
 	return ret;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 24bf170720fc8a..efd91ed249fabe 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -631,6 +631,11 @@ static void rpcrdma_sendctxs_destroy(struct rpcrdma_xprt *r_xprt)
 	/* The QP is drained, but the final unsignaled Sends might not
 	 * have been walked by a signaled Send completion. Release those
 	 * Send owners before request buffers are reset.
+	 *
+	 * Unlike the completion sweep, this walk can visit slots with
+	 * no Send posted: after a partial rpcrdma_sendctxs_create()
+	 * failure on reconnect, rb_sc_head and rb_sc_tail are stale,
+	 * and slots between them can be NULL or have sc_req clear.
 	 */
 	for (i = rpcrdma_sendctx_next(buf, buf->rb_sc_tail);
 	     i != rpcrdma_sendctx_next(buf, buf->rb_sc_head);
@@ -703,6 +708,12 @@ static unsigned long rpcrdma_sendctx_next(struct rpcrdma_buffer *buf,
 	return likely(item < buf->rb_sc_last) ? item + 1 : 0;
 }
 
+static unsigned long rpcrdma_sendctx_prev(struct rpcrdma_buffer *buf,
+					  unsigned long item)
+{
+	return item > 0 ? item - 1 : buf->rb_sc_last;
+}
+
 /**
  * rpcrdma_sendctx_get_locked - Acquire a send context
  * @r_xprt: controlling transport instance
@@ -747,6 +758,29 @@ struct rpcrdma_sendctx *rpcrdma_sendctx_get_locked(struct rpcrdma_xprt *r_xprt)
 	return NULL;
 }
 
+/**
+ * rpcrdma_sendctx_unget_locked - Release an unposted send context
+ * @r_xprt: controlling transport instance
+ * @sc: send context to release
+ *
+ * Usage: Called when no Send is posted for the sendctx most
+ * recently returned by rpcrdma_sendctx_get_locked().
+ *
+ * The caller serializes calls to this function and to
+ * rpcrdma_sendctx_get_locked() (per transport).
+ */
+void rpcrdma_sendctx_unget_locked(struct rpcrdma_xprt *r_xprt,
+				  struct rpcrdma_sendctx *sc)
+{
+	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
+
+	if (WARN_ON_ONCE(buf->rb_sc_ctxs[buf->rb_sc_head] != sc))
+		return;
+
+	buf->rb_sc_head = rpcrdma_sendctx_prev(buf, buf->rb_sc_head);
+	xprt_write_space(&r_xprt->rx_xprt);
+}
+
 /**
  * rpcrdma_sendctx_put_locked - Release a send context
  * @r_xprt: controlling transport instance
@@ -764,8 +798,7 @@ static void rpcrdma_sendctx_put_locked(struct rpcrdma_xprt *r_xprt,
 	unsigned long next_tail;
 
 	/* Release previously completed but unsignaled Sends by walking
-	 * up the queue until @sc is found. Entries left behind by a
-	 * failed rpcrdma_prepare_send_sges() have sc_req cleared.
+	 * up the queue until @sc is found.
 	 */
 	next_tail = buf->rb_sc_tail;
 	do {
@@ -775,8 +808,7 @@ static void rpcrdma_sendctx_put_locked(struct rpcrdma_xprt *r_xprt,
 
 		/* ORDER: item must be accessed _before_ tail is updated */
 		cur = buf->rb_sc_ctxs[next_tail];
-		if (cur->sc_req)
-			rpcrdma_sendctx_unmap(cur);
+		rpcrdma_sendctx_unmap(cur);
 
 	} while (buf->rb_sc_ctxs[next_tail] != sc);
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 40a9aa0cda67fc..ae14f6a526e6e6 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -478,6 +478,8 @@ void rpcrdma_req_destroy(struct rpcrdma_req *req);
 int rpcrdma_buffer_create(struct rpcrdma_xprt *);
 void rpcrdma_buffer_destroy(struct rpcrdma_buffer *);
 struct rpcrdma_sendctx *rpcrdma_sendctx_get_locked(struct rpcrdma_xprt *r_xprt);
+void rpcrdma_sendctx_unget_locked(struct rpcrdma_xprt *r_xprt,
+				  struct rpcrdma_sendctx *sc);
 
 struct rpcrdma_mr *rpcrdma_mr_get(struct rpcrdma_xprt *r_xprt);
 void rpcrdma_mrs_refresh(struct rpcrdma_xprt *r_xprt);
-- 
2.53.0



