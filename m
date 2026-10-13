Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8D5390CB7;
	Tue, 13 Oct 2026 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893880; cv=none; b=l0o9ldHsy3r0kGsN1OR1zO3RqCACmp5Ye+VolAw5leQyh/ZeITYekLB2o1zWZNbNLkWsVLDg90lOS35QU3pIAUmRxEn/MJLza1vN2Dn7AeiaKV1nE8mPle3GKaXnhYWDe0eSK4ht2hK/pytjc3nh+zxtsYjclABpSVkncTu/YNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893880; c=relaxed/simple;
	bh=khSM8rKF3Opky0kVidHoiIsIRTJEUYfrlz6y6QA77TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/XftwuDp9PGY13Ciqgn/g8uyp4wTMs8tWlT8umUHQ3fBKr3JhIv5qxQ9uxaucWbwBmQMuQ2NVfkpKdHfEsp2/IH51/gl+JxqO/kPG2C+SStAg1Qlqcsaa3rcH5OFrAt14IQMtM+q3vTsvcKtCVnpsEJ0kK0wGphE6Ox+OhksIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbcZBjlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbcZBjlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED521F000FF;
	Tue, 13 Oct 2026 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893878;
	bh=YDzouOISQxUi9YdRKvw1Qfo0c8Rs68u744zwE4yQkrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbcZBjlvv2ro4dRBHBB6FgOoPgmOa3SXzodjy1Mt992x4SS772sUWNXlHyTYwKBN2
	 pe96PWcKmD3XHOOXBSLKqwzz8FfaIC/nimTFtZET8+vDS8oAjXA1bycRF4uvN1fT9P
	 UB/JU6Rfb4S+BgJYrPIrTSm7/sWKqnimmwsSeT+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/621] svcrdma: wake sq waiters when the transport closes
Date: Tue, 13 Oct 2026 13:36:07 +0200
Message-ID: <20261013112929.677267206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit e5248a7426030db1e126363f72afdb3b71339a5c ]

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

[ Adapted for this tree: it has no ticket-based Send Queue waiting, so
  only sc_send_wait is woken; all svc_xprt_deferred_close() callers in
  svcrdma are converted to the new wrapper. ]

Stable-dep-of: 01500306e1d5 ("svcrdma: Clear sc_cm_id when ADDR_CHANGE replacement fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_rdma.h          |  1 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  4 ++--
 net/sunrpc/xprtrdma/svc_rdma_rw.c        |  8 +++----
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  6 ++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 28 ++++++++++++++++++++++--
 5 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index b447473ed0016..6e1cdc3335e0a 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -318,6 +318,7 @@ extern int svc_rdma_result_payload(struct svc_rqst *rqstp, unsigned int offset,
 				   unsigned int length);
 
 /* svc_rdma_transport.c */
+extern void svc_rdma_xprt_deferred_close(struct svcxprt_rdma *rdma);
 extern struct svc_xprt_class svc_rdma_class;
 #ifdef CONFIG_SUNRPC_BACKCHANNEL
 extern struct svc_xprt_class svc_rdma_bc_class;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 1075bfd9fed61..a7c09041cc9b9 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -376,7 +376,7 @@ static void svc_rdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
 		trace_svcrdma_wc_recv_err(wc, &ctxt->rc_cid);
 dropped:
 	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -1018,7 +1018,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		if (ret == -EINVAL)
 			svc_rdma_send_error(rdma_xprt, ctxt, ret);
 		svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
-		svc_xprt_deferred_close(xprt);
+		svc_rdma_xprt_deferred_close(rdma_xprt);
 		return ret;
 	}
 	return 0;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 5c2f848e9622f..371ec8278d518 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -292,7 +292,7 @@ static void svc_rdma_reply_done(struct ib_cq *cq, struct ib_wc *wc)
 		trace_svcrdma_wc_reply_err(wc, &cc->cc_cid);
 	}
 
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -324,7 +324,7 @@ static void svc_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 	 * some of the outgoing RPC message. Signal the loss
 	 * to the client by closing the connection.
 	 */
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -369,7 +369,7 @@ static void svc_rdma_wc_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	 */
 	svc_rdma_cc_release(rdma, cc, DMA_FROM_DEVICE);
 	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /*
@@ -422,7 +422,7 @@ static int svc_rdma_post_chunk_ctxt(struct svcxprt_rdma *rdma,
 	} while (1);
 
 	trace_svcrdma_sq_post_err(rdma, &cc->cc_cid, ret);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 
 	/* If even one was posted, there will be a completion. */
 	if (bad_wr != first_wr)
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index b48a57fbb1ccc..4c376b0b19313 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -326,7 +326,7 @@ static void svc_rdma_wc_send(struct ib_cq *cq, struct ib_wc *wc)
 	else
 		trace_svcrdma_wc_send_flush(wc, &ctxt->sc_cid);
 	svc_rdma_send_ctxt_put(rdma, ctxt);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 }
 
 /**
@@ -387,7 +387,7 @@ int svc_rdma_post_send(struct svcxprt_rdma *rdma,
 		ret = ib_post_send(rdma->sc_qp, first_wr, &bad_wr);
 		if (ret) {
 			trace_svcrdma_sq_post_err(rdma, &cid, ret);
-			svc_xprt_deferred_close(&rdma->sc_xprt);
+			svc_rdma_xprt_deferred_close(rdma);
 
 			/* If even one WR was posted, there will be a
 			 * Send completion that bumps sc_sq_avail.
@@ -1097,7 +1097,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	svc_rdma_send_ctxt_put(rdma, sctxt);
 drop_connection:
 	trace_svcrdma_send_err(rqstp, ret);
-	svc_xprt_deferred_close(&rdma->sc_xprt);
+	svc_rdma_xprt_deferred_close(rdma);
 	return -ENOTCONN;
 }
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 1f9d14e46c9df..e82c9ebf7426d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -99,10 +99,26 @@ struct svc_xprt_class svc_rdma_class = {
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
+	/* Release parked sc_send_wait waiters.
+	 * Once XPT_CLOSE is observed each returns -ENOTCONN.
+	 */
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
@@ -120,7 +136,7 @@ static void qp_event_handler(struct ib_event *event, void *context)
 	case IB_EVENT_QP_ACCESS_ERR:
 	case IB_EVENT_DEVICE_FATAL:
 	default:
-		svc_xprt_deferred_close(xprt);
+		svc_rdma_xprt_deferred_close(rdma);
 		break;
 	}
 }
@@ -344,7 +360,7 @@ static int svc_rdma_cma_handler(struct rdma_cm_id *cma_id,
 		svc_xprt_enqueue(xprt);
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
-		svc_xprt_deferred_close(xprt);
+		svc_rdma_xprt_deferred_close(rdma);
 		break;
 	default:
 		break;
@@ -617,6 +633,14 @@ static void svc_rdma_detach(struct svc_xprt *xprt)
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
 	rdma_disconnect(rdma->sc_cm_id);
+
+	/*
+	 * Most close paths go through svc_rdma_xprt_deferred_close(),
+	 * which wakes the SQ waitqueue. svc_xprt_close() reaches
+	 * detach without that helper, so wake any threads parked in
+	 * the Send Queue here as well.
+	 */
+	wake_up_all(&rdma->sc_send_wait);
 }
 
 /**
-- 
2.53.0



