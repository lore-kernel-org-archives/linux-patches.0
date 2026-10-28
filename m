Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210284;
	b=1IDjYrXTiYhZRLjAmOXCy1aYAJIFuYL0gIr+tWazBWOtQ13NTyEaGwg0fux0HWVnc5J0
	 0XM9fkx+oRRLtxDJeksH/QRKlLNWzcWQ9pAKiTTwwOyJGc8jZ0IKlyMXKPD6WEm0zp0fl
	 BsjLxyA2rekj7TReYH0w1FAqU9DTkCOdCNLSY7gaiMLgR4vpavAJ3iyJLrMMLjpWhoY+n
	 8QDMLS9YPenwnZfMeDZbMZC7BtwopqPW5qOedLkG3/atE/GhprZCMbaybbRjF3O1Y3INn
	 MnXmtAtjlHsGasfXg8B50wiNuHziaqtiP9qOvWLOc2t76ASaw5bpI0nR/2zh1dSh/+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6dHiO9ueHfePCCqZ1iuPRT2m7OI7x0R2udRtoqQ9crU=;
	b=iafHTw9s1+YHUrjhQAYsHU+H5f+WddqSzr/lbyaHK719l1H0QZSBgJWEXyb8BS8WfXhR
	 TVChbmR8Fqxpt+cKNBT86I6Wf+NK6QO7xZuL4FvkShP3JbkAOhUJcwWoq0EwVeBZ/ajI2
	 Ipl7qRwYa84c9a/ICQol1hWS+RaO+uOxY//E7l6/gYVnG1GqKiEwyzncfdfYYoN5/QSi0
	 lkkC0WRhZTBXtakb9cjXDg1fT1a+xKZMtL9iLK6/HQkvaxf6/FT3W0CFgaAq1PcbWAcku
	 5ITv9r/LBSpefO1izEUHjpCbrJr2iAtUVY87NZlCutYYvbcCUyv874H3+ZQD5vVVuiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnXPuiJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2680606A31A;
	Wed, 28 Oct 2026 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnXPuiJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D13F1F01825;
	Wed, 28 Oct 2026 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210283;
	bh=6dHiO9ueHfePCCqZ1iuPRT2m7OI7x0R2udRtoqQ9crU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnXPuiJOwCX2zBM58McYEumRXZ7iVj0n5Gc7ghi9evBVv4I2MFI7epDci1J3iOH3Z
	 AI6z0xv628OcmOXDYhtCss6cz1geTyhMkGYX80yUZIKcckwK0PbyRnF0wt+JX9BiDf
	 OcrqbE9VYYDKrn8yYs+W1ThEpDCwBDI0usUI36ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 139/168] io_uring: wake ring pollers for local task_work
Date: Wed, 28 Oct 2026 18:01:15 +0100
Message-ID: <20261028165946.374832776@linuxfoundation.org>
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

Commit b88902d8745a701d24275d012f0830e3628e2a22 upstream.

With IORING_SETUP_DEFER_TASKRUN completions are queued as local work, and
only become CQEs when the submitter enters the kernel to wait for events.
For an application that finds out via poll() or epoll on the ring fd when
it is time to do that, io_uring_poll() reports EPOLLIN if local work is
pending.

That only helps if the work is there at the time of the call. When
DEFER_TASKRUN was added, io_req_local_work_add() did io_cqring_wake(),
which took care of tasks sleeping in poll() as well. Then polling got a
wait queue of its own, ->poll_wq, and the wake up in
io_req_local_work_add() was replaced by waking the submitter directly.
Since then ->poll_wq is only woken when CQEs are committed, which for
such a ring is done by the very task that is waiting to be told to:

  submitter                           completion
  poll(ring_fd)
    io_uring_poll()  // nothing yet
    schedule()
                                      io_req_local_work_add()
                                        // ->cq_wait_nr: nobody waits
  // sleeps on

Wake ->poll_wq when the first entry is put on the work list. Like for the
eventfd, that must not be done right away if the work is queued from a
wake up handler, as the chain of wake ups could get back to the wait
queue whose lock is held. Use an RCU callback in that case, with a
reference to the ring.

[ 6.6: io_req_local_work_add() lives in io_uring/io_uring.c, and with no IOU_F_TWQ_IN_WAKE to tell a wake up handler context apart, the ->poll_wq wake up is always deferred to an RCU callback ]
Fixes: 130bd686d9be ("io_uring: waitqueue-less cq waiting")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-19-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 +++
 io_uring/io_uring.c            |   28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -362,6 +362,9 @@ struct io_ring_ctx {
 	bool				iowq_limits_set;
 
 	struct callback_head		poll_wq_task_work;
+	/* deferred ->poll_wq wake up for local task_work */
+	struct rcu_head			poll_wq_rcu;
+	atomic_t			poll_wq_rcu_pending;
 	struct list_head		defer_list;
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1273,6 +1273,31 @@ void tctx_task_work(struct callback_head
 	trace_io_uring_task_work_run(tctx, count, 1);
 }
 
+static void io_poll_wq_wake_rcu(struct rcu_head *rcu)
+{
+	struct io_ring_ctx *ctx = container_of(rcu, struct io_ring_ctx,
+					       poll_wq_rcu);
+
+	atomic_set(&ctx->poll_wq_rcu_pending, 0);
+	io_poll_wq_wake(ctx);
+	percpu_ref_put(&ctx->refs);
+}
+
+/*
+ * io_uring_poll() reports pending local work as EPOLLIN, as it takes a trip to
+ * the kernel to turn it into CQEs. Let those know who are asleep already.
+ * This may be called from a wake up handler with some wait queue lock held,
+ * and this wake up could lead back to it. Do it from a clean context.
+ */
+static void io_local_work_wake_poll(struct io_ring_ctx *ctx)
+{
+	if (!wq_has_sleeper(&ctx->poll_wq) ||
+	    atomic_xchg(&ctx->poll_wq_rcu_pending, 1))
+		return;
+	percpu_ref_get(&ctx->refs);
+	call_rcu_hurry(&ctx->poll_wq_rcu, io_poll_wq_wake_rcu);
+}
+
 static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1310,6 +1335,9 @@ static inline void io_req_local_work_add
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
 			io_eventfd_signal(ctx, flags & IOU_F_TWQ_IN_WAKE);
+		/* whoever sets the flag wakes ->poll_wq afterwards */
+		if (ctx->poll_activated)
+			io_local_work_wake_poll(ctx);
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);


