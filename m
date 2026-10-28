Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207235;
	b=DoTz0+Qxw1msRBQQxk9oZnZHWzRLJYbwPHGZqCQmx8D+PFKQrcKPInvLDxLD4fdRZJUl
	 H9Q+ReGrTfh/N/Ql5oBoSDTgkf+zkhIKDpCJVPwW7mMpUCndZGwLgeAoqYLKDeo5IuZS1
	 /LTgzhW5ryKjsd9cE3kCCHAVboSfBxr/68H3giq8b9gi7ospFAXIftSWduszp5nk6/EY2
	 uXflo2uUwLsvvBBKEyhSXa8Jo89JiFTrXvYc1oOPk3CFyTbol+xQkkmP9KNNRYARwG5iP
	 PW4cWgTGqAmLMdCbboNVwCfVj7Q/eiXRKvoECm2Zh6iy2+ZKHo+vhM7zp98Mj+YhvhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jk6yk6AAwiZ9uVF5oG2OG5RXRarPRuwVqOVh/2WI9Fw=;
	b=qNLwG6Y4zcrEW2pm5CDJqIy4YAYAw0N7UHTBBGhOuf5tKuOuiRfMqDpndlvftnhwtOEB
	 cCMBZW3h3Due69+6Jyn/kr7+8LaNBqU3h5grkxLyPlV1SFL73oY/tIu/WNL+AEpac3GdG
	 RedS+cMfUyDEIqCaoXvkoKdeLxygTmGsQSm0p98767kNxBWRBU58fhcLM8kWddDl3VkbJ
	 FizPSMdtBhutdZW//7KFHh3LsDA8yhioic4xYC4JwXIQHL/Y9PsqsswA3GLqeHn6APvST
	 pUfPgMQEpCqbwlQINZVtIFvzBoGqgHgtcifoC6ajhDllU3OufwJO3V0ZaIPpldtxA0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2WvCKzC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54891606A31C;
	Wed, 28 Oct 2026 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2WvCKzC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DE51F01825;
	Wed, 28 Oct 2026 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207235;
	bh=Jk6yk6AAwiZ9uVF5oG2OG5RXRarPRuwVqOVh/2WI9Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2WvCKzCR0B33UjSbjbfFYopb4BKtoXNhNg3cndaEQ3VhcqXo6IfmzQgGevcQ0TYN
	 leITgnzmazZLFBjcIpS3l00uoMBCrplVlbg77OCmyip99MsGsU7tW/5GdkvkpYDmAy
	 Abcy8V9CfGJ7JVJtKwLMOYEyEzwOLULVTU5jRC5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 35/88] io_uring: wake ring pollers for local task_work
Date: Wed, 28 Oct 2026 17:59:43 +0100
Message-ID: <20261028165942.939568314@linuxfoundation.org>
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

Fixes: 130bd686d9be ("io_uring: waitqueue-less cq waiting")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-19-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 +++
 io_uring/tw.c                  |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -513,6 +513,9 @@ struct io_ring_ctx {
 	u32				iowq_limits[2];
 
 	struct callback_head		poll_wq_task_work;
+	/* deferred ->poll_wq wake up for local task_work */
+	struct rcu_head			poll_wq_rcu;
+	atomic_t			poll_wq_rcu_pending;
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -148,6 +148,37 @@ static void io_ctx_mark_taskrun(struct i
 	}
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
+ */
+static void io_local_work_wake_poll(struct io_ring_ctx *ctx, unsigned int flags)
+{
+	if (!(flags & IOU_F_TWQ_IN_WAKE)) {
+		io_poll_wq_wake(ctx);
+		return;
+	}
+	/*
+	 * Called from a wake up handler with some wait queue lock held, this
+	 * one could lead back to it. Do it from a clean context.
+	 */
+	if (!wq_has_sleeper(&ctx->poll_wq) ||
+	    atomic_xchg(&ctx->poll_wq_rcu_pending, 1))
+		return;
+	percpu_ref_get(&ctx->refs);
+	call_rcu_hurry(&ctx->poll_wq_rcu, io_poll_wq_wake_rcu);
+}
+
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -174,6 +205,9 @@ void io_req_local_work_add(struct io_kio
 		io_ctx_mark_taskrun(ctx);
 		if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
 			io_eventfd_signal(ctx, false, flags & IOU_F_TWQ_IN_WAKE);
+		/* whoever sets the flag wakes ->poll_wq afterwards */
+		if (data_race(ctx->int_flags) & IO_RING_F_POLL_ACTIVATED)
+			io_local_work_wake_poll(ctx, flags);
 	}
 
 	/*


