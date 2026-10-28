Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209702;
	b=xaKXOUls1HtsBLNtY8z49pX2SR3ws6bcNHILd29VfZ3/p7+Fi8oZ0chT+96dEtwzZUEe
	 I8NpBt3rcxMYQVh/LsZT8jd+bSTVrqzId3dGkUkWI+/1JflrFCOtkUQKWBUoe+dJpiLDK
	 q2OX34Pmj5Vpcs2o840+DElnskxLCZFPXbACvK+Qak3glu5labo53+tCKUOqKI630Qdlm
	 9o4ek7AxK5Ip1vvIRpI24t/0+tjGGH7uklZ9Y6yxmmu412jfhZto0aCkiqNQ7kIAQhAKR
	 XlkGp4ASfSHxzaKyql5nohL6kUNoPLzFY+/xSuJ6XRj5AwKN6LoW0kjlpjB67+PWjAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bOYMCQQU4/yxBrTgOKc+sk4CBqcwQprwOtCZdP/LmQ4=;
	b=0e1Ip9dt7e4rsTKO4k32T9VBOon4KmG5GVU3/fZGb7OhvzXPlZPkGSNaSDrtVdzzNgl+
	 W33Um92FGZwn06WW3J7RnysxRIb5LbYtzlBLe1DSa49V3eGP64TEIZBuW2rWuXqcGLSrT
	 LUgSZHz5VhZlj8626mk3KIXaYOpT0YxX7uVHNITrKJCnQuNYVqWD7t2Nn/V3XKbN2p5t0
	 svywIFlYmebdrpdV9jD6RZhtAtljKCnLv1drLFyEvQUc7NKpcVrB+dgwJSqzUfUC4CgOI
	 7Mws9uerirBzNrHaVRo9NgFZjlq36SUQh9/aIzEbkseiBoHle4+a8vIGLkDFWgyK18Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gL5So0Xk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EDE606A31E;
	Wed, 28 Oct 2026 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gL5So0Xk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D440A1F031E2;
	Wed, 28 Oct 2026 17:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209702;
	bh=bOYMCQQU4/yxBrTgOKc+sk4CBqcwQprwOtCZdP/LmQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gL5So0XkRltULjVQYO/FEa9yuJ+dlLYqAWhk9oKthRu130lMQIblV0BEiOUYcxLne
	 GEIBwqjvnQ27ACz6sL1p+CFOfhkXQ5OmHLb3b3Gb52WjpNjisfSvdYVXwcVnAD34Cx
	 IhRcB6Ja/iVs9fojKoWiAaAPsf/KAmqvDg8Hsghg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.18 048/109] io_uring/io-wq: dont hide a link from cancellations
Date: Wed, 28 Oct 2026 18:00:32 +0100
Message-ID: <20261028165943.492148229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 436d48a2ed13112d2d27085325838e5bce6b4507 upstream.

A task that exits cancels its tracked requests and waits until they are
gone. io_uring_cancel_generic() looks everywhere a request can be, and
goes to sleep if it found nothing to cancel. It is woken up each time
one of the requests of the task is completed by task work or freed.

When io-wq is done with a request that has a link, there is a time in which
the next request of the link can't be found:

  io_worker_handle_work()
    io_assign_current_work(worker, NULL)
    io_wq_free_work(work)
      io_req_find_next()           // takes the link off the request
      io_free_req()                // task work for the task
    io_assign_current_work(worker, linked)
      io_run_task_work()
      cond_resched()
      worker->cur_work = linked

It is not pending, it is not the current work of a worker, and it is not
yet on the list that it is about to be parked on. If the pass that the
exiting task makes because of io_free_req() falls into that time, it finds
nothing and the task goes to sleep. The worker then runs the link, which
IO_WQ_BIT_EXIT doesn't prevent for bounded work. If that parks the request
nothing is completed or freed, and nobody wakes up the task. If it is the
process that exits it can't be killed any more either.

  NOP, IOSQE_ASYNC | IOSQE_IO_LINK
  FUTEX_WAIT, FUTEX2_PRIVATE
  exit of the thread, or of the process, up to 63us later

With four of these per round 5 to 8 of 10,000 rounds hang (4 CPUs, KVM):

  io_uring_cancel_generic
  do_exit

Commit f8b632e89a10 ("io_uring: tighten task exit cancellations") is about
the same gap, and makes the task look again for whatever happens before
io_free_req().

Free the request once the link is the current work of the worker, or
pending. Whoever is woken up by that can find the link, until it is parked
where cancellations look as well. To do so split io_wq_free_work() in two.

[ 6.18: io_wq_free_work() has no REQ_F_CQE_SKIP link check yet (5530a5102e3c), kept its link logic in the split ]

Fixes: 768134d4f481 ("io_uring: don't do flush cancel under inflight_lock")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-5-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c    |   18 +++++++++++++++---
 io_uring/io_uring.c |   29 +++++++++++++++++++++--------
 io_uring/io_uring.h |    3 ++-
 3 files changed, 38 insertions(+), 12 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -640,11 +640,12 @@ static void io_worker_handle_work(struct
 		/* handle a whole dependent link */
 		do {
 			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
-			struct io_wq_work *next_hashed, *linked;
+			struct io_wq_work *next_hashed, *linked, *done = work;
 			unsigned int work_flags = atomic_read(&work->flags);
 			unsigned int hash = __io_wq_is_hashed(work_flags)
 				? __io_get_work_hash(work_flags)
 				: -1U;
+			bool last;
 
 			next_hashed = wq_next_work(work);
 
@@ -660,7 +661,7 @@ static void io_worker_handle_work(struct
 			io_wq_submit_work(work);
 			io_assign_current_work(worker, NULL);
 
-			linked = io_wq_free_work(work);
+			last = io_wq_put_work(work, &linked);
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
@@ -669,6 +670,13 @@ static void io_worker_handle_work(struct
 			io_assign_current_work(worker, work);
 			if (linked)
 				io_wq_enqueue(wq, linked);
+			/*
+			 * Not before the link is current or pending work again.
+			 * This may be the last time that a task is woken up
+			 * which exits and looks for requests to cancel.
+			 */
+			if (last)
+				io_wq_free_work(done);
 
 			if (hash != -1U && !next_hashed) {
 				/* serialize hash clear with wake_up() */
@@ -1000,9 +1008,13 @@ void io_wq_set_exit_on_idle(struct io_wq
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
+		struct io_wq_work *linked;
+
 		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		io_wq_submit_work(work);
-		work = io_wq_free_work(work);
+		if (io_wq_put_work(work, &linked))
+			io_wq_free_work(work);
+		work = linked;
 	} while (work);
 }
 
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1886,17 +1886,30 @@ int io_poll_issue(struct io_kiocb *req,
 	return ret;
 }
 
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
+/*
+ * io-wq is done with @work. Returns true if it held the last reference, and
+ * hands out the next request of the link then. The caller has to make sure
+ * that cancellations can find the latter before it calls io_wq_free_work().
+ */
+bool io_wq_put_work(struct io_wq_work *work, struct io_wq_work **linked)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	if (req_ref_put_and_test_atomic(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS)
-			nxt = io_req_find_next(req);
-		io_free_req(req);
-	}
-	return nxt ? &nxt->work : NULL;
+	*linked = NULL;
+	if (!req_ref_put_and_test_atomic(req))
+		return false;
+
+	if (req->flags & IO_REQ_LINK_FLAGS)
+		nxt = io_req_find_next(req);
+	if (nxt)
+		*linked = &nxt->work;
+	return true;
+}
+
+void io_wq_free_work(struct io_wq_work *work)
+{
+	io_free_req(container_of(work, struct io_kiocb, work));
 }
 
 void io_wq_submit_work(struct io_wq_work *work)
@@ -1907,7 +1920,7 @@ void io_wq_submit_work(struct io_wq_work
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
-	/* one will be dropped by io_wq_free_work() after returning to io-wq */
+	/* one will be dropped by io_wq_put_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
 		__io_req_set_refcount(req, 2);
 	else
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -185,7 +185,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
+bool io_wq_put_work(struct io_wq_work *work, struct io_wq_work **linked);
+void io_wq_free_work(struct io_wq_work *work);
 void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);


