Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207983;
	b=QENJG+YXbgf8mvvaaAERopjCHOmVCgEvgEKHaes6xUgQDJF2qkYtegmypEvFnNBuJ+o1
	 Fp0cP+OpTgdA/WGuUO4OPVYY6QFgAh+qi3fBl/4yxCLoWenDK/v/4oucczlO6jgHL8/Gw
	 Tai/WVFjGbiX4KTt0jGhJsvMxNknXCe1bsgtTF6vUlsFiK96yPoFa9OoI095aUNf4eiB2
	 01RuTVBG6r9MXAXUnjqB9IeARYQxoRrPIultefQaetNXeM7j1TZ07EAUtkKuWwImPVbDB
	 xr1zwxBq9VyGPUlHuQgt9Z/JZk5LZxtCcxAYzHhrLECSw4WWxnfKayujMO2ayqQi75w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kq0onTFik4q4ytqK42NFkyy4SLnZ9MGxQRnFw1AznDg=;
	b=MT5XEQyFbHx3y+Qq7h76AFNAxgvxTgerCRgiUncUr356neKPrN1zMxaU6uJAshOgPSyp
	 p4TVpP3+BIzVmrzrnWE6ogezN35+DKHG0o92RhTGlZq35/Mv42lLnMzV/+BBzdWg7oKf5
	 kwXjZ+pDbkJUjiSHNxNNTAvRTWdyBXOqi5JJ8FwHq05XL6lTerhp41NFJaWNsuPPHGHvy
	 XB6x6TrJW21AqNKxLt4VPCpTzGkQNCcuH2Zq20gxJDinTVdlCpAfrXTXOjBXRASha4+7O
	 GgGoDCBSMKg1NVn6UwqGSMN5lb5nCdpAOZ84FhMkUxqIPU9nejK181yJYNTfyutNxeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulQDgbpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFB6606A326;
	Wed, 28 Oct 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulQDgbpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC0F1F031E0;
	Wed, 28 Oct 2026 17:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207983;
	bh=Kq0onTFik4q4ytqK42NFkyy4SLnZ9MGxQRnFw1AznDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulQDgbpp9SuVHs2nRTcmmn2FQDW7fCvGt2mHy27HFbPmZLEPXBEqjJ7J05RGy+uuF
	 fwzpAcvT6rdTgL/BbHg4v4TyTrZ5LVPzQwsqlCSRg5MPT1Av7fmxxelWkBrjsJHSvl
	 Mmw8Ag+E6XVVRN0B3si/m+MLdOa67PaW4Sa3UiDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 207/247] io_uring: wake ring pollers for local task_work
Date: Wed, 28 Oct 2026 18:00:10 +0100
Message-ID: <20261028165952.322894645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.12: the code is in io_uring.c, ->poll_activated is a bitfield, and
  there is no IOU_F_TWQ_IN_WAKE to tell a wake up handler apart, so the
  wake up always goes through the RCU callback ]
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
@@ -403,6 +403,9 @@ struct io_ring_ctx {
 	u32				iowq_limits[2];
 
 	struct callback_head		poll_wq_task_work;
+	/* deferred ->poll_wq wake up for local task_work */
+	struct rcu_head			poll_wq_rcu;
+	atomic_t			poll_wq_rcu_pending;
 	struct list_head		defer_list;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1143,6 +1143,31 @@ void tctx_task_work(struct callback_head
 	WARN_ON_ONCE(ret);
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
 static inline void io_req_local_work_add(struct io_kiocb *req,
 					 struct io_ring_ctx *ctx,
 					 unsigned flags)
@@ -1202,6 +1227,9 @@ static inline void io_req_local_work_add
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
 			io_eventfd_signal(ctx, flags & IOU_F_TWQ_IN_WAKE);
+		/* whoever sets the flag wakes ->poll_wq afterwards */
+		if (ctx->poll_activated)
+			io_local_work_wake_poll(ctx);
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);


