Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F5C31E85C;
	Thu, 16 Jul 2026 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210178; cv=none; b=A6Zp0EHNgSDcrMQhOTiVxSLRADNRdYJ/+fhEfnnP9h9XOqusj4FFeKiAYX8lUBOlCGS444NzRDIz/aPsdf10YwTO0AN+eNltR9hhNcS9CbiqfBvkx9LbrjJlA60/CHpQhBn1rmex7n8BR4Egvs4popylsbDPZlBCIrOHADJ/jck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210178; c=relaxed/simple;
	bh=iEBbpSWj0uXnMRamaaLfu9bkwPeM4LGxD9c5s1IqTUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM5Kxg2LY0vB0brU0lRRfyL+X2OA7MvwJRkFV/rHmBq6Mom8v8esO186AO+wxS+umRtgdKZsmxY7ZjURbj8wkL+9mlbOA8zASytkaz36NuL4EH4pKI+MS+GDfoWZ38h71hJ0YXOIY3lNd1rU0MgD0bhietrSTz4EruS67tHg5nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwhpFgdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwhpFgdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6451F000E9;
	Thu, 16 Jul 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210177;
	bh=ltE2g6kBtbETMdQPsF9Ra0qUG/RuthKzdBdn582PMBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwhpFgdTxaiGotkRbg7vcjKZVvm88odolVpdx2cZ4vljEPKQQUCrFAzMOZZcAibE2
	 jsySVyfodH773UyA+VV+KmeWS6EQOZnS7IVMv4jxyx12u8qmSlQJi4SplDk7Xen4P1
	 rIr/AtQnrzxV30GhqK6z4V/N43Ky6wgNVqkhtSjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 467/518] svcrdma: wake sq waiters when the transport closes
Date: Thu, 16 Jul 2026 15:32:15 +0200
Message-ID: <20260716133058.062490481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit e5248a7426030db1e126363f72afdb3b71339a5c upstream.

Threads parked in svc_rdma_sq_wait() on sc_sq_ticket_wait or
sc_send_wait can hang indefinitely in TASK_UNINTERRUPTIBLE state
across transport teardown, pinning svc_xprt references and
blocking svc_rdma_free().

The close path sets XPT_CLOSE before invoking xpo_detach and both
wait_event predicates include an XPT_CLOSE term, but the
predicates are re-evaluated only on wakeup. sc_sq_ticket_wait has
no completion-driven wake path; it is advanced solely by the
chained ticket handoff inside svc_rdma_sq_wait() itself. Without
an explicit wake at close, parked threads never observe
XPT_CLOSE, hold their svc_xprt_get reference forever, and
svc_rdma_free() blocks on xpt_ref dropping to zero.

Two close entry points reach this transport. Local teardown runs
svc_rdma_detach() from svc_handle_xprt() -> svc_delete_xprt() ->
xpo_detach() on a worker thread. A remote disconnect arrives at
svc_rdma_cma_handler(), which calls svc_xprt_deferred_close():
that sets XPT_CLOSE and enqueues the transport but does not
access either RDMA waitqueue, so a worker already parked in
svc_rdma_sq_wait() never re-evaluates its predicate. With every
worker parked on this transport, no thread is available to run
the local teardown either, and the wake site there is
unreachable.

Introduce svc_rdma_xprt_deferred_close(), a thin svcrdma wrapper
that calls svc_xprt_deferred_close() and then wakes both
sc_sq_ticket_wait and sc_send_wait. Convert the svcrdma producers
that called svc_xprt_deferred_close() directly:
svc_rdma_cma_handler(), qp_event_handler(),
svc_rdma_post_send_err(), svc_rdma_wc_send(), the sendto drop
path, the rw completion error paths, and the recvfrom flush and
read-list error paths.

Wake both waitqueues from svc_rdma_detach() as well. The
synchronous svc_xprt_close() path (backchannel ENOTCONN, device
removal via svc_rdma_xprt_done) reaches detach without flowing
through svc_xprt_deferred_close() and therefore does not invoke
the new helper.

Fixes: ccc89b9d1ed2 ("svcrdma: Add fair queuing for Send Queue access")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
[ cel: add svc_rdma_xprt_deferred_close() to complete the fix ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc_rdma.h          |    1 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |    4 ++--
 net/sunrpc/xprtrdma/svc_rdma_rw.c        |    6 +++---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |    6 +++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   30 ++++++++++++++++++++++++++++--
 5 files changed, 37 insertions(+), 10 deletions(-)

--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -328,6 +328,7 @@ extern int svc_rdma_result_payload(struc
 				   unsigned int length);
 
 /* svc_rdma_transport.c */
+extern void svc_rdma_xprt_deferred_close(struct svcxprt_rdma *rdma);
 extern struct svc_xprt_class svc_rdma_class;
 #ifdef CONFIG_SUNRPC_BACKCHANNEL
 extern struct svc_xprt_class svc_rdma_bc_class;
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -377,7 +377,7 @@ flushed:
 		trace_svcrdma_wc_recv_err(wc, &ctxt->rc_cid);
 dropped:
 	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -1001,7 +1001,7 @@ out_readlist:
 		if (ret == -EINVAL)
 			svc_rdma_send_error(rdma_xprt, ctxt, ret);
 		svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
-		svc_xprt_deferred_close(xprt);
+		svc_rdma_xprt_deferred_close(rdma_xprt);
 		return ret;
 	}
 	return 0;
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -313,7 +313,7 @@ static void svc_rdma_reply_done(struct i
 		trace_svcrdma_wc_reply_err(wc, &cc->cc_cid);
 	}
 
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -345,7 +345,7 @@ static void svc_rdma_write_done(struct i
 	 * some of the outgoing RPC message. Signal the loss
 	 * to the client by closing the connection.
 	 */
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -390,7 +390,7 @@ static void svc_rdma_wc_read_done(struct
 	 */
 	svc_rdma_cc_release(rdma, cc, DMA_FROM_DEVICE);
 	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /*
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -395,7 +395,7 @@ int svc_rdma_post_send_err(struct svcxpr
 			   int sqecount, int ret)
 {
 	trace_svcrdma_sq_post_err(rdma, cid, ret);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 
 	/* If even one WR was posted, a Send completion will
 	 * return the reserved SQ slots.
@@ -437,7 +437,7 @@ flushed:
 	else
 		trace_svcrdma_wc_send_flush(wc, &ctxt->sc_cid);
 	svc_rdma_send_ctxt_put(rdma, ctxt);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -1158,7 +1158,7 @@ put_ctxt:
 	svc_rdma_send_ctxt_put(rdma, sctxt);
 drop_connection:
 	trace_svcrdma_send_err(rqstp, ret);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 	return -ENOTCONN;
 }
 
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -98,10 +98,27 @@ struct svc_xprt_class svc_rdma_class = {
 	.xcl_ident = XPRT_TRANSPORT_RDMA,
 };
 
+/**
+ * svc_rdma_xprt_deferred_close - Close an RDMA transport (deferred)
+ * @rdma: transport to close
+ */
+void svc_rdma_xprt_deferred_close(struct svcxprt_rdma *rdma)
+{
+	svc_xprt_deferred_close(&rdma->sc_xprt);
+
+	/* Release parked sc_sq_ticket_wait and sc_send_wait waiters.
+	 * Once XPT_CLOSE is observed each returns -ENOTCONN.
+	 */
+	wake_up_all(&rdma->sc_sq_ticket_wait);
+	wake_up_all(&rdma->sc_send_wait);
+}
+
 /* QP event handler */
 static void qp_event_handler(struct ib_event *event, void *context)
 {
 	struct svc_xprt *xprt = context;
+	struct svcxprt_rdma *rdma =
+		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
 	trace_svcrdma_qp_error(event, (struct sockaddr *)&xprt->xpt_remote);
 	switch (event->event) {
@@ -119,7 +136,7 @@ static void qp_event_handler(struct ib_e
 	case IB_EVENT_QP_ACCESS_ERR:
 	case IB_EVENT_DEVICE_FATAL:
 	default:
-		svc_xprt_deferred_close(xprt);
+		svc_rdma_xprt_deferred_close(rdma);
 		break;
 	}
 }
@@ -340,7 +357,7 @@ static int svc_rdma_cma_handler(struct r
 		svc_xprt_enqueue(xprt);
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
-		svc_xprt_deferred_close(xprt);
+		svc_rdma_xprt_deferred_close(rdma);
 		break;
 	default:
 		break;
@@ -597,6 +614,15 @@ static void svc_rdma_detach(struct svc_x
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
 	rdma_disconnect(rdma->sc_cm_id);
+
+	/*
+	 * Most close paths go through svc_rdma_xprt_deferred_close(),
+	 * which wakes the SQ waitqueues. svc_xprt_close() reaches
+	 * detach without that helper, so wake any threads parked in
+	 * svc_rdma_sq_wait() here as well.
+	 */
+	wake_up_all(&rdma->sc_sq_ticket_wait);
+	wake_up_all(&rdma->sc_send_wait);
 }
 
 /**


