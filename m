Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619554;
	b=wgomvs+PPSW3TDGivIus/Qbh+SuC5dGYVRABVoEEEOk/fAAK6bx5oM7LHVrL68gS+Dgt
	 rP1VRqyPB80l7BM6K6RlekZKjjJPg7X9SCt4knPhcF4jCm60B+nVfphVi3m8hxnrgj6VI
	 OC6qwGG3yiDD0tk4S4mHuwnpjva60lTms1t/7+F1F/0HKju83KHlbt46sNr1DAptDs6IT
	 rqtRzMJ5xO2sAALCt1/tfLjdrmrss8eklFR8r1MDCyA850XAmhRqpm8nLTSVj7Lgb78h8
	 nUtV/Q/TsBwGmM0KeSBVnnXCO9lv371fieouomExYHkScqGAGVrkDCrtcZVlogOl/AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTpgIDmFS9zY4+VvctE1f8jflCxEVElC9QU1TSW/fEs=;
	b=a3SATXlfYv3YlpvS+EiI3HyeWLnXh4+yPlYWr9bA3cpg4pLxGt1VhEajFNdBNQYNDVfb
	 sjPXQXuC9x2cHPjb0XJ7t9t8aLcHG7s12IyZwZwqth9btg57SmZKKi9vbJ9gO+gDAT9PA
	 JNPYbRvLNkQvE8GzN8Y+Dpw8hOcaJMp3veERd5RNnAbc3V8ofY1s1wx5rA20B5XdnoQSz
	 sjCKAHFLexpY3C6yrQb1CLzRZxKowUq3gHINZOYqOlRGaFWwMazqGtmYxd9yfDe0wJl+D
	 VbtCsNR9QaMuy+fUoA85dJNThyoCLe12ZJdhB5yOvJPHK5weIG9XfMVMwD1wd+J2zwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+bgeXDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEB3606A31E;
	Wed, 25 Nov 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+bgeXDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68941F000C4;
	Wed, 25 Nov 2026 15:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619553;
	bh=bTpgIDmFS9zY4+VvctE1f8jflCxEVElC9QU1TSW/fEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+bgeXDND7AtoCPBRCLv17fgdDXflu9UcbGR6QFQGHTvWqTfoRr232LDBOrI6tFZA
	 NwF/29ve9gDytIeY7Yzw1p+UWfA4ZrVcrmd4LhHvQjfPlBW5O53ftZ8mGoqD5+5teC
	 +UjqDhpXN+4jmQZSp80PRyipSVyG6mGSlgtw5UrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Tim Menninger <tmenninger@everpuredata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 0633/1005] xprtrdma: serialize unmap_sync with xprt_disconnect
Date: Wed, 25 Nov 2026 15:32:51 +0100
Message-ID: <20261125143836.580131495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Menninger <tmenninger@everpuredata.com>

commit 1fa415883c37b02ff17acdd7977ed591d3d389ee upstream.

frwr_unmap_sync() posts LOCAL_INV Work Requests to the QP and waits
for the matching CQE. This can race with rpcrdma_xprt_disconnect():

    1. frwr_unmap_sync() samples r_xprt->rx_ep
    2. rpcrdma_xprt_disconnect() drains the QP
    3. frwr_unmap_sync() posts LOCAL_INV WRs after the drain
    4. No CQE arrives, so wait_for_completion() blocks indefinitely

The hung task appears in the rpciod workqueue:

Workqueue: rpciod rpc_async_schedule [sunrpc]
    wait_for_completion()
    frwr_unmap_sync()
    xprt_rdma_free()
    xprt_release()

Serialize synchronous MR invalidation against QP teardown with
rx_unmap_rwsem. frwr_unmap_sync() holds the read side while it builds
and submits the LOCAL_INV chain. Disconnect holds the write side across
QP drain and resource teardown. Drop the read side before waiting so
disconnect can drain the submitted Work Requests and deliver their CQEs.

Disconnect can reset a request while frwr_unmap_sync() waits for the
read side. Recheck rl_registered after acquiring the rwsem and return
without posting if the request has already been reset.

Move the synchronous invalidation completion from the final MR to the
request, whose lifetime covers xprt_rdma_free(). This allows disconnect
to destroy MRs after draining the QP while frwr_unmap_sync() is still
waiting. On a post failure, call rpcrdma_force_disconnect() before
dropping the read side so the endpoint is not dereferenced after
disconnect can run.

frwr_unmap_async() runs inline from Receive completion processing.
rpcrdma_xprt_drain() drains the Receive Queue before the Send Queue, so
asynchronous LOCAL_INV Work Requests are submitted before Send Queue
drain. frwr_unmap_sync(), however, runs from xprt_rdma_free() after the
transport send lock has been released, so it is not ordered against
disconnect.

Tested on v7.4-rc1 under pNFS load with repeated data server restarts
to provoke rapid QP disconnect/reconnect cycling. Without the fix, a
hung task in frwr_unmap_sync() reproduced twice in six attempts. With
the fix, no hang occurred across 200 cycles.

Also observed on v6.8 and v6.18.34.

Fixes: e28ce90083f0 ("xprtrdma: kmalloc rpcrdma_ep separate from rpcrdma_xprt")
Cc: stable@vger.kernel.org
Assisted-by: Claude:opus-4-7
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Tim Menninger <tmenninger@everpuredata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c  |   89 ++++++++++++++++++++++++----------------
 net/sunrpc/xprtrdma/transport.c |    2 
 net/sunrpc/xprtrdma/verbs.c     |   16 +++++--
 net/sunrpc/xprtrdma/xprt_rdma.h |   10 ++++
 4 files changed, 78 insertions(+), 39 deletions(-)

--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -27,13 +27,17 @@
 
 /* Transport recovery
  *
- * frwr_map and frwr_unmap_* cannot run at the same time the transport
- * connect worker is running. The connect worker holds the transport
- * send lock, just as ->send_request does. This prevents frwr_map and
- * the connect worker from running concurrently. When a connection is
- * closed, the Receive completion queue is drained before the allowing
- * the connect worker to get control. This prevents frwr_unmap and the
- * connect worker from running concurrently.
+ * frwr_map() is serialized with the connect worker by the transport
+ * send lock.
+ *
+ * frwr_unmap_async() runs from Receive completion processing.
+ * rpcrdma_xprt_drain() drains the Receive Queue before the Send Queue,
+ * so asynchronous LOCAL_INV Work Requests are submitted before Send
+ * Queue drain.
+ *
+ * frwr_unmap_sync() runs after the transport send lock is released.
+ * rx_unmap_rwsem orders its LOCAL_INV submission before disconnect
+ * drains the QP.
  *
  * When the underlying transport disconnects, MRs that are in flight
  * are flushed and are likely unusable. Thus all MRs are destroyed.
@@ -139,7 +143,6 @@ int frwr_mr_init(struct rpcrdma_xprt *r_
 	mr->mr_ibmr = frmr;
 	mr->mr_device = NULL;
 	INIT_LIST_HEAD(&mr->mr_list);
-	init_completion(&mr->mr_linv_done);
 	frwr_cid_init(ep, mr);
 
 	sg_init_table(sg, depth);
@@ -539,40 +542,60 @@ static void frwr_wc_localinv(struct ib_c
  * @cq: completion queue
  * @wc: WCE for a completed LocalInv WR
  *
- * Awaken anyone waiting for an MR to finish being fenced.
+ * Wake frwr_unmap_sync() after the final LOCAL_INV completion.
  */
 static void frwr_wc_localinv_wake(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct ib_cqe *cqe = wc->wr_cqe;
 	struct rpcrdma_mr *mr = container_of(cqe, struct rpcrdma_mr, mr_cqe);
+	struct rpcrdma_req *req = mr->mr_req;
 
 	/* WARNING: Only wr_cqe and status are reliable at this point */
 	trace_xprtrdma_wc_li_wake(wc, &mr->mr_cid);
 	frwr_mr_done(wc, mr);
-	complete(&mr->mr_linv_done);
+	complete(&req->rl_linv_done);
 
 	rpcrdma_flush_disconnect(cq->cq_context, wc);
 }
 
 /**
- * frwr_unmap_sync - invalidate memory regions that were registered for @req
+ * frwr_unmap_sync - synchronously invalidate MRs registered for @req
  * @r_xprt: controlling transport instance
- * @req: rpcrdma_req with a non-empty list of MRs to process
+ * @req: request whose registered MRs are to be invalidated
+ *
+ * If @req still owns registered MRs after synchronizing with transport
+ * disconnect, post a chain of LOCAL_INV Work Requests and wait for the
+ * final completion. On successful completion, this fences the mapped
+ * regions from remote access and preserves Send Queue flow control.
+ *
+ * A concurrent disconnect can reset @req while this function waits for
+ * the read side. In that case the MRs have already been released and no
+ * LOCAL_INV Work Requests are posted.
  *
- * Sleeps until it is safe for the host CPU to access the previously mapped
- * memory regions. This guarantees that registered MRs are properly fenced
- * from the server before the RPC consumer accesses the data in them. It
- * also ensures proper Send flow control: waking the next RPC waits until
- * this RPC has relinquished all its Send Queue entries.
+ * Context: Process context. Takes and releases
+ *	    @r_xprt->rx_unmap_rwsem for read. May sleep.
  */
 void frwr_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 {
 	struct ib_send_wr *first, **prev, *last;
-	struct rpcrdma_ep *ep = r_xprt->rx_ep;
 	const struct ib_send_wr *bad_wr;
+	struct rpcrdma_ep *ep;
 	struct rpcrdma_mr *mr;
 	int rc;
 
+	/* serialize against rpcrdma_xprt_disconnect() */
+	down_read(&r_xprt->rx_unmap_rwsem);
+
+	/*
+	 * Disconnect can reset this request while we wait for the read side.
+	 * Recheck rl_registered in case rx_ep now refers to a new connection.
+	 */
+	ep = r_xprt->rx_ep;
+	if (!ep || list_empty(&req->rl_registered)) {
+		up_read(&r_xprt->rx_unmap_rwsem);
+		return;
+	}
+
 	/* ORDER: Invalidate all of the MRs first
 	 *
 	 * Chain the LOCAL_INV Work Requests and post them with
@@ -599,37 +622,35 @@ void frwr_unmap_sync(struct rpcrdma_xprt
 		prev = &last->next;
 	} while ((mr = rpcrdma_mr_pop(&req->rl_registered)));
 
-	mr = container_of(last, struct rpcrdma_mr, mr_invwr);
-
 	/* Strong send queue ordering guarantees that when the
 	 * last WR in the chain completes, all WRs in the chain
 	 * are complete.
 	 */
 	last->wr_cqe->done = frwr_wc_localinv_wake;
-	reinit_completion(&mr->mr_linv_done);
+	reinit_completion(&req->rl_linv_done);
 
-	/* Transport disconnect drains the receive CQ before it
-	 * replaces the QP. The RPC reply handler won't call us
-	 * unless re_id->qp is a valid pointer.
+	/*
+	 * The read side prevents disconnect from draining this QP until the
+	 * LOCAL_INV chain has been submitted.
 	 */
 	bad_wr = NULL;
 	rc = ib_post_send(ep->re_id->qp, first, &bad_wr);
+	if (rc) {
+		/* On error, the MRs get destroyed once the QP has drained. */
+		trace_xprtrdma_post_linv_err(req, rc);
+
+		/* Force a connection loss to ensure complete recovery.
+		 */
+		rpcrdma_force_disconnect(ep);
+	}
+	up_read(&r_xprt->rx_unmap_rwsem);
 
 	/* The final LOCAL_INV WR in the chain is supposed to
 	 * do the wake. If it was never posted, the wake will
 	 * not happen, so don't wait in that case.
 	 */
 	if (bad_wr != first)
-		wait_for_completion(&mr->mr_linv_done);
-	if (!rc)
-		return;
-
-	/* On error, the MRs get destroyed once the QP has drained. */
-	trace_xprtrdma_post_linv_err(req, rc);
-
-	/* Force a connection loss to ensure complete recovery.
-	 */
-	rpcrdma_force_disconnect(ep);
+		wait_for_completion(&req->rl_linv_done);
 }
 
 /**
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -364,6 +364,8 @@ xprt_setup_rdma(struct xprt_create *args
 	INIT_DELAYED_WORK(&new_xprt->rx_connect_worker,
 			  xprt_rdma_connect_worker);
 
+	init_rwsem(&new_xprt->rx_unmap_rwsem);
+
 	xprt->max_payload = RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT;
 
 	return xprt;
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -572,20 +572,24 @@ out:
  * rpcrdma_xprt_disconnect - Disconnect underlying transport
  * @r_xprt: controlling transport instance
  *
- * Caller serializes. Either the transport send lock is held,
- * or we're being called to destroy the transport.
+ * Context: Caller serializes. Either the transport send lock is held,
+ *	    or the transport is being destroyed. Takes and releases
+ *	    @r_xprt->rx_unmap_rwsem for write. May sleep.
  *
  * On return, @r_xprt is completely divested of all hardware
  * resources and prepared for the next ->connect operation.
  */
 void rpcrdma_xprt_disconnect(struct rpcrdma_xprt *r_xprt)
 {
-	struct rpcrdma_ep *ep = r_xprt->rx_ep;
+	struct rpcrdma_ep *ep;
 	struct rdma_cm_id *id;
 	int rc;
 
+	down_write(&r_xprt->rx_unmap_rwsem);
+
+	ep = r_xprt->rx_ep;
 	if (!ep)
-		return;
+		goto out_unlock;
 
 	/* Prevent teardown-generated events from requesting another close. */
 	atomic_xchg(&ep->re_force_disconnect, 1);
@@ -604,6 +608,9 @@ void rpcrdma_xprt_disconnect(struct rpcr
 		rdma_destroy_id(id);
 
 	r_xprt->rx_ep = NULL;
+
+out_unlock:
+	up_write(&r_xprt->rx_unmap_rwsem);
 }
 
 /* Fixed-size circular FIFO queue. This implementation is wait-free and
@@ -927,6 +934,7 @@ struct rpcrdma_req *rpcrdma_req_create(s
 
 	INIT_LIST_HEAD(&req->rl_free_mrs);
 	INIT_LIST_HEAD(&req->rl_registered);
+	init_completion(&req->rl_linv_done);
 	spin_lock(&buffer->rb_lock);
 	list_add(&req->rl_all, &buffer->rb_allreqs);
 	spin_unlock(&buffer->rb_lock);
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -46,6 +46,7 @@
 #include <linux/spinlock.h> 		/* spinlock_t, etc */
 #include <linux/atomic.h>		/* atomic_t, etc */
 #include <linux/kref.h>			/* struct kref */
+#include <linux/rwsem.h>		/* struct rw_semaphore */
 #include <linux/workqueue.h>		/* struct work_struct */
 #include <linux/llist.h>
 
@@ -249,7 +250,6 @@ struct rpcrdma_mr {
 	int			mr_nents;
 	enum dma_data_direction	mr_dir;
 	struct ib_cqe		mr_cqe;
-	struct completion	mr_linv_done;
 	union {
 		struct ib_reg_wr	mr_regwr;
 		struct ib_send_wr	mr_invwr;
@@ -348,6 +348,7 @@ struct rpcrdma_req {
 
 	struct list_head	rl_free_mrs;
 	struct list_head	rl_registered;
+	struct completion	rl_linv_done;
 };
 
 static inline struct rpcrdma_req *
@@ -449,6 +450,13 @@ struct rpcrdma_xprt {
 	struct delayed_work	rx_connect_worker;
 	struct rpc_timeout	rx_timeout;
 	struct rpcrdma_stats	rx_stats;
+
+	/*
+	 * Orders frwr_unmap_sync()'s LOCAL_INV submission ahead of the
+	 * QP drain. Disconnect holds the write side across the drain
+	 * and resource teardown.
+	 */
+	struct rw_semaphore	rx_unmap_rwsem;
 };
 
 #define rpcx_to_rdmax(x) container_of(x, struct rpcrdma_xprt, rx_xprt)


