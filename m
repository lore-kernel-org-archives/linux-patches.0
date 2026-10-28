Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207329;
	b=Z4L9ClrT8ew2bm7sgunhIooDA6r4YyvBIz1/1fP4FCP762JBG4LammID2U0gFSxWnqpB
	 AfuEjzFXs07Yz/nKNa12EhFM/sQej8UNMtJPjtJ8XABKEyfBX0FVNcNQfe74iX+y1/xyW
	 KihG7a66dlzy7kwHpIi3dQWnfS87HLeUr/CKtkO9GW4aWs5DFya+gJF+C8/Ok/5CzF+GQ
	 5BPruyCpOm4pr/7VpzFfsSnMjFphmdIMy4hzOhwWEPwJUJ6YUdfm9IgdCd7RF+5+T+Kbh
	 57QfMRa8NOZK+cnEX3Ycu8rPW4tol+OMB5q7+4OV7pj8jkDPZXsK/k2nd1lJbkDE2KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkaKsAMouid2dmyVOg2tkYvFlCXfYuJzOqzb2J4FBeI=;
	b=kdZWFtWY1dH10scA06KwObW9xUdqAFrT8RxeoqxFYlFRoHrfhN/YP5vQP00YHSz7yo9c
	 byI8sWdGLx7rUdaCMaZs/4NYKHL16d/Aaqsp7/qsVwTC44r8Gi/6rw8Gy+RcDar4LRZ2B
	 n8gRiQb7AnD3GsYu56QA416eWhxbNDwbNkiWIf1+WfrWXsFf30AL672e4Xt5imKL3fFCt
	 92BGFNOft7k8EzeJ8a+K8NCwRoIDZO13+bweFgrd8BcI09JDBpmdsRccx4an/+eciMY7I
	 YKZqzZ7RntMs77AhmQjy7Q9pFHO0RUZtpCbujPX3g4fRp/r3VUyfvUM3yHni6XMSFow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8skl8DY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B213606A320;
	Wed, 28 Oct 2026 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8skl8DY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4C91F01825;
	Wed, 28 Oct 2026 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207329;
	bh=OkaKsAMouid2dmyVOg2tkYvFlCXfYuJzOqzb2J4FBeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8skl8DYfOacYc06WNw9hzF1odOeIPdOWh3e24bjsfJylQADML4CMeWtuhJsi7jxG
	 bGdNbpbrMhpasY8cWXMyC90qytD7cBirhqiBjn//mWLw5nYrmwX0J29V0H+Ox22fqa
	 APDcBR/AHUehIjyHtprFskLBJsuafK7SEJHQ42zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 23/88] io_uring: dont lose the DEFER_TASKRUN wake up
Date: Wed, 28 Oct 2026 17:59:31 +0100
Message-ID: <20261028165942.663552842@linuxfoundation.org>
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

Commit 8257f6ec45ee07c6ed933c59d8982b03cc7bc1ca upstream.

Since local task_work moved to the mpscq, ->cq_wait_nr is a credit: the
add that counts it down to zero, or exchanges it for IO_CQ_WAKE_INIT,
issues the only wake up of the wait cycle, and every later add returns
early as the count is <= 0.

An add looks at the count after it has queued its entry, so an add that
gets delayed in between can take the credit of a later cycle. That was
assumed to cause an early wake up at worst, but the waiter publishes the
count before it changes its task state:

CPU0 (submitter, io_cqring_wait)      CPU1 (io_req_local_work_add)
                                      mpscq_push(req A)
io_run_local_work()  // runs req A
atomic_set(&ctx->cq_wait_nr, 1)
                                      atomic_read(&ctx->cq_wait_nr) == 1
                                      atomic_xchg(.., IO_CQ_WAKE_INIT)
                                      wake_up_state(.., TASK_INTERRUPTIBLE)
                                        // still TASK_RUNNING, no-op
set_current_state(TASK_INTERRUPTIBLE)
io_local_work_pending() == false
schedule()
                                      mpscq_push(req B)
                                      cq_wait_nr <= 0, return

The task now sleeps with req B queued, until a signal or a timeout ends
the wait.

Set the task state first and only then make the count visible, so that
whoever takes the credit finds a task it can wake. The full barrier that
orders the count against the check of the work list is kept. Do the same
for the wait of the BPF driven loop, which copied the sequence.

Fixes: d46ab2c98aba ("io_uring: switch local task_work to a mpscq")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-7-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/loop.c |    8 +-------
 io_uring/tw.c   |    2 +-
 io_uring/wait.c |    3 +--
 io_uring/wait.h |   15 +++++++++++++++
 4 files changed, 18 insertions(+), 10 deletions(-)

--- a/io_uring/loop.c
+++ b/io_uring/loop.c
@@ -9,12 +9,6 @@ static inline int io_loop_nr_cqes(const
 	return lp->cq_wait_idx - READ_ONCE(ctx->rings->cq.tail);
 }
 
-static inline void io_loop_wait_start(struct io_ring_ctx *ctx, unsigned nr_wait)
-{
-	atomic_set(&ctx->cq_wait_nr, nr_wait);
-	set_current_state(TASK_INTERRUPTIBLE);
-}
-
 static inline void io_loop_wait_finish(struct io_ring_ctx *ctx)
 {
 	__set_current_state(TASK_RUNNING);
@@ -24,7 +18,7 @@ static inline void io_loop_wait_finish(s
 static void io_loop_wait(struct io_ring_ctx *ctx, struct iou_loop_params *lp,
 			 unsigned nr_wait)
 {
-	io_loop_wait_start(ctx, nr_wait);
+	io_cq_wait_arm(ctx, nr_wait);
 
 	if (unlikely(io_local_work_pending(ctx) ||
 		     io_loop_nr_cqes(ctx, lp) <= 0) ||
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -165,7 +165,7 @@ void io_req_local_work_add(struct io_kio
 
 	/*
 	 * The xchg() in mpscq_push() implies a full barrier, which pairs with
-	 * the barrier in set_current_state() on the io_cqring_wait() side. This
+	 * the barrier in io_cq_wait_arm() on the io_cqring_wait() side. This
 	 * ensures that either we see the updated ->cq_wait_nr, or waiters going
 	 * to sleep will observe the work added to the list, which is similar to
 	 * the wait/wake task state sync.
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -257,8 +257,7 @@ int io_cqring_wait(struct io_ring_ctx *c
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			atomic_set(&ctx->cq_wait_nr, nr_wait);
-			set_current_state(TASK_INTERRUPTIBLE);
+			io_cq_wait_arm(ctx, nr_wait);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 							TASK_INTERRUPTIBLE);
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -14,6 +14,21 @@
  */
 #define IO_CQ_WAKE_INIT		(-1)
 
+/*
+ * Start a wait cycle of the current task. The add that uses up ->cq_wait_nr
+ * may be one that queued its entry long ago and only now gets to look at the
+ * count. As nobody else wakes us after that, it has to find us sleeping, hence
+ * the task state must be visible before the count is. The barrier pairs with
+ * the xchg() in mpscq_push(), see io_req_local_work_add().
+ */
+static inline void io_cq_wait_arm(struct io_ring_ctx *ctx, int nr_wait)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	atomic_set_release(&ctx->cq_wait_nr, nr_wait);
+	/* order the above against looking at the work list */
+	smp_mb();
+}
+
 struct ext_arg {
 	size_t argsz;
 	struct timespec64 ts;


