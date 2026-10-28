Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210253;
	b=JO/BjevkpgE5OxqR8xG8qy6b3D1Nbbr8L9jPH3NShaIFY0O+HgDLVwr8tWECeFJLtAkl
	 n9/M2J/mFzCG4B5NHNgaKH0dJzasbwx+5Cz2q5LilohG0SXbNlysVzpAzRkNkPka0awdv
	 wnODX5NvQ6KVLd045RUe8zbk2SklXyML6QhoV4UWlCscUWVnm2zMb/3L7dv4C1k9QmHAy
	 GLHZLRkVMH/1/OgJ6y2QK8x2eaqtmd3wOGXgfIbfQ0VDmJ9ildxkuitIArlCCqKqd28vB
	 WPq332qXttrDRS4EQDUOc7ACpbDQ5oV7wJWlLE2t+bI5+UeYzHINHCLaSHxbinBl0kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pi1Xd2iTvyY0JHvJv6moxPatCBJ6VBx4QN3kv8zpdk=;
	b=CBCJwcL7ozrfguEZFhG1EF/wPZ76snylM+9Uw22UI3DoyWdQusTJXyYnLBQVwASQU7zu
	 p06fchvxICqDcuk+f0grufH9/97cteBKQTPKL3rHagYDemjNhKY23fa/e/MQv4evQ/Ixj
	 rv0LTBq2ZqsWnWIcJhDaGsJZ5EcbXm1IBF9dH1LvmaumW6bWsbgUbTPIC28g+66LQ/lpo
	 Owhu9/fMm1+VlQ4OIv13oADKHsAikPsbSKtHde9W2oXY/8bXVukCmCfHIEDi8i8eyXj+q
	 WtXJHTFVr1yNTGuZDRCGyJEodh4MuUZdVDYwLdHchHxCIuMggw1v200pT1WSlLOGJ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YDK1Vft/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40BB606A31C;
	Wed, 28 Oct 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDK1Vft/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC91F01825;
	Wed, 28 Oct 2026 17:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210252;
	bh=6pi1Xd2iTvyY0JHvJv6moxPatCBJ6VBx4QN3kv8zpdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDK1Vft/E1bVpIb3lXGqroloYF08Z1LIPTjlSeZ/IPq3P9l3TIKruriN4cVtVMIC/
	 j7JxB9ZSWMi4+jqgCZodYWLM86lrA4UFB9FR5wDau3L/sAOwZZHwWbqNwREn+IYsc1
	 fY3EtxgGVLt+AbZ2zmlOuY6nYmf/lf93IggjIghk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 129/168] io_uring/io-wq: dont hide a link from cancellations
Date: Wed, 28 Oct 2026 18:01:05 +0100
Message-ID: <20261028165946.139009196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.6: io-wq takes callbacks, split the free_work one into put_work and free_work, and keep io_wq_put_work() finding the next link the way io_wq_free_work() did here ]
Fixes: 768134d4f481 ("io_uring: don't do flush cancel under inflight_lock")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-5-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c    |   22 ++++++++++++++++++----
 io_uring/io-wq.h    |    4 +++-
 io_uring/io_uring.c |   28 ++++++++++++++++++++--------
 io_uring/io_uring.h |    3 ++-
 io_uring/tctx.c     |    1 +
 5 files changed, 44 insertions(+), 14 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -99,6 +99,7 @@ enum {
 struct io_wq {
 	unsigned long state;
 
+	put_work_fn *put_work;
 	free_work_fn *free_work;
 	io_wq_work_fn *do_work;
 
@@ -595,8 +596,9 @@ static void io_worker_handle_work(struct
 		/* handle a whole dependent link */
 		do {
 			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
-			struct io_wq_work *next_hashed, *linked;
+			struct io_wq_work *next_hashed, *linked, *done = work;
 			unsigned int hash = io_get_work_hash(work);
+			bool last;
 
 			next_hashed = wq_next_work(work);
 
@@ -612,7 +614,7 @@ static void io_worker_handle_work(struct
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
-			linked = wq->free_work(work);
+			last = wq->put_work(work, &linked);
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
@@ -621,6 +623,13 @@ static void io_worker_handle_work(struct
 			io_assign_current_work(worker, work);
 			if (linked)
 				io_wq_enqueue(wq, linked);
+			/*
+			 * Not before the link is current or pending work again.
+			 * This may be the last time that a task is woken up
+			 * which exits and looks for requests to cancel.
+			 */
+			if (last)
+				wq->free_work(done);
 
 			if (hash != -1U && !next_hashed) {
 				/* serialize hash clear with wake_up() */
@@ -921,9 +930,13 @@ static bool io_wq_worker_wake(struct io_
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
+		struct io_wq_work *linked;
+
 		work->flags |= IO_WQ_WORK_CANCEL;
 		wq->do_work(work);
-		work = wq->free_work(work);
+		if (wq->put_work(work, &linked))
+			wq->free_work(work);
+		work = linked;
 	} while (work);
 }
 
@@ -1176,7 +1189,7 @@ struct io_wq *io_wq_create(unsigned boun
 	int ret, i;
 	struct io_wq *wq;
 
-	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
+	if (WARN_ON_ONCE(!data->put_work || !data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON_ONCE(!bounded))
 		return ERR_PTR(-EINVAL);
@@ -1187,6 +1200,7 @@ struct io_wq *io_wq_create(unsigned boun
 
 	refcount_inc(&data->hash->refs);
 	wq->hash = data->hash;
+	wq->put_work = data->put_work;
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
 
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -21,7 +21,8 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
-typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+typedef bool (put_work_fn)(struct io_wq_work *, struct io_wq_work **);
+typedef void (free_work_fn)(struct io_wq_work *);
 typedef void (io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_hash {
@@ -40,6 +41,7 @@ struct io_wq_data {
 	struct io_wq_hash *hash;
 	struct task_struct *task;
 	io_wq_work_fn *do_work;
+	put_work_fn *put_work;
 	free_work_fn *free_work;
 };
 
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1904,17 +1904,29 @@ int io_poll_issue(struct io_kiocb *req,
 				 IO_URING_F_COMPLETE_DEFER);
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
@@ -1925,7 +1937,7 @@ void io_wq_submit_work(struct io_wq_work
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
-	/* one will be dropped by ->io_wq_free_work() after returning to io-wq */
+	/* one will be dropped by io_wq_put_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
 		__io_req_set_refcount(req, 2);
 	else
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -91,7 +91,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 int io_req_prep_async(struct io_kiocb *req);
 
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
+bool io_wq_put_work(struct io_wq_work *work, struct io_wq_work **linked);
+void io_wq_free_work(struct io_wq_work *work);
 void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -35,6 +35,7 @@ static struct io_wq *io_init_wq_offload(
 
 	data.hash = hash;
 	data.task = task;
+	data.put_work = io_wq_put_work;
 	data.free_work = io_wq_free_work;
 	data.do_work = io_wq_submit_work;
 


