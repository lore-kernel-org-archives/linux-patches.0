Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207275;
	b=DRTxg7yPaIIpbMXe5+dhvtHVA4sFBch6bFfbpDG1WqSmd9jLc26sgxqXt2EukgZJC1/V
	 ewNtK0bzJeyk+XAWWyyoNK/QTWTafS5OuEIKSYJF5a0A1S3K0osIWX+aCPbhlbW2nmdQG
	 bNjgnPZJruOgLlYVvnYJ35EehhHrLSKVVJOiRBjM0xI1XFPz3CpxL19cjzU49FrdBZDLt
	 kfeGlpxdC/uWYH1XkRFpGo/6241o84pYyTL+4FnyEhzv2Ed17BnREuilyOUEutM4zQuNr
	 zl5lAak+9uA2HLnAbhSW6H/1NZ6OHTWQrkrQlLwhVe76uDidiw9glqbeXq9e5WyfXWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lP+TuUNYGfQlUnxBDThH+qZgbioVE+NcckHq1n44J6I=;
	b=eOkni+I4FXHluWChGL48r8861UBWaCSy98hnZyzUOK+DpaE2kw1xELGuc2t7XyDU9wZ3
	 lHDmzk0gYqwy2eQnJd0bmfjrkMERg07lCUEqXP6qbkSj+usP41zGXAFvEGeCoc70GRLfO
	 7HAGUnr4jrFi3ftqq/qn8s71sm8j7CpYhxZqnU+JMyDOCZXWwoM+JNBoKP7puzOQbKA9k
	 bNly1qxU8hCNqluFCx5x2T6TrjCLxk/kV2FJlBHnHt3evP0hwkIN61uR3JBqDPDTiZMYw
	 qwlmVtIMv90zWwQqXCGmFwjTvwqGvyRemESyHOt4jY37IhQUOOpB9i3A9oeWcsZ5Glw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P0/hVcYX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E354606A31C;
	Wed, 28 Oct 2026 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0/hVcYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C87A1F01825;
	Wed, 28 Oct 2026 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207274;
	bh=lP+TuUNYGfQlUnxBDThH+qZgbioVE+NcckHq1n44J6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0/hVcYX9fEBaJtPmhKAYuVQZ9TyecD1/WFMsNxMAFTbdk4BW4xo18tvc8HI+txiU
	 KpbMqH6HrGOnNBQh6n3J34SZ5/U2ZtR/IxngadZvkVi9FU3sKoJh/TmVRqGFwPGjsQ
	 P/b/GmI1eHR77VZuBL1rOUdwrQk70bLthr57Nrug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 7.2 21/88] io_uring/io-wq: dont hide a link from cancellations
Date: Wed, 28 Oct 2026 17:59:29 +0100
Message-ID: <20261028165942.615546032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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

[ 7.2: io_wq_put_work() keeps the link check of 7.2, without the REQ_F_CQE_SKIP
  condition that commit 5530a5102e3c adds in 7.3 ]
Fixes: 768134d4f481 ("io_uring: don't do flush cancel under inflight_lock")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-5-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c    |   18 +++++++++++++++---
 io_uring/io_uring.c |   37 +++++++++++++++++++++++++------------
 io_uring/io_uring.h |    3 ++-
 3 files changed, 42 insertions(+), 16 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -641,11 +641,12 @@ static void io_worker_handle_work(struct
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
 
@@ -661,7 +662,7 @@ static void io_worker_handle_work(struct
 			io_wq_submit_work(work);
 			io_assign_current_work(worker, NULL);
 
-			linked = io_wq_free_work(work);
+			last = io_wq_put_work(work, &linked);
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
@@ -670,6 +671,13 @@ static void io_worker_handle_work(struct
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
@@ -999,9 +1007,13 @@ void io_wq_set_exit_on_idle(struct io_wq
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
@@ -1454,22 +1454,35 @@ int io_poll_issue(struct io_kiocb *req,
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
-		if (req->flags & IO_REQ_LINK_FLAGS) {
-			struct io_ring_ctx *ctx = req->ctx;
-
-			mutex_lock(&ctx->uring_lock);
-			nxt = io_req_find_next(req);
-			mutex_unlock(&ctx->uring_lock);
-		}
-		io_free_req(req);
+	*linked = NULL;
+	if (!req_ref_put_and_test_atomic(req))
+		return false;
+
+	if (req->flags & IO_REQ_LINK_FLAGS) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		mutex_lock(&ctx->uring_lock);
+		nxt = io_req_find_next(req);
+		mutex_unlock(&ctx->uring_lock);
 	}
-	return nxt ? &nxt->work : NULL;
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
@@ -1480,7 +1493,7 @@ void io_wq_submit_work(struct io_wq_work
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
-	/* one will be dropped by io_wq_free_work() after returning to io-wq */
+	/* one will be dropped by io_wq_put_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
 		__io_req_set_refcount(req, 2);
 	else
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -203,7 +203,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
+bool io_wq_put_work(struct io_wq_work *work, struct io_wq_work **linked);
+void io_wq_free_work(struct io_wq_work *work);
 void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);


