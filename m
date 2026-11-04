Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826880;
	b=DzC+7Yn4b/ZcdAXqbRCIFi22kT1PEqhMSmCEAM7nMLLV50r/GVNB3YufSYAfSBeKqLGp
	 SR2JQrDB0QmC7YacX7L05jcGRmLRKqmLtCvOgfeKR602nuL7fDbe8bYLmGi92Qf9ehVRz
	 Z+SkXxjyWIu+YhWCV2usc+qKTh0EzqDu7qUs4Q3FGIbCz7b/BF0YQYQegqf2ppmCzcpwR
	 lzG2h+CE0RAxNjK9Pz7H+yTbdjC+gxPrdGUkfQ8HEHUUARbsQxkQzSxtXLI+N7Yd//dg/
	 Rf5PUdwyrflfhgF6wkuNax9hM4HY7QKgMoQzc1uMTd5KYJ8FJCsBiySWr+s97E5Sb9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3m6wH8JkptmAhSbIg1gI8PEGHEhV4wlcDl8CpPDgEmY=;
	b=1RK4Y5XyCtFUqRfMfNFQ5B8zD9VQ+79GeT4quL17k1yqnIrEIRbLhzxnpWRKK7pvRo7s
	 dDAN5a2bFUUpOJ3c7hBwh8UpfP6/aWf6lcX1JmG3PWpmPpEuhND08B3xLUMbslsFXwZtR
	 11TsowgjmQTNaskgCEUd8W9gc/7beRwd1FEHeJrr5/QX/nU4/fGmU0IkTnYw+a1Vncfka
	 nyWyWDRlleUoo2PFJVH/to7xMo/JtOdlPv4sW9YkgJUYEWYXAlMIr9Qs1RQF3wZ8OJCKi
	 XrgNTo7lKt5mlDEMRdXfdvd35jOVH58g2eN9ZjgLL5VBzf6Kw7vBk4eMKyRqDWbAyUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoEueaXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AE26070755;
	Wed,  4 Nov 2026 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoEueaXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DFB1F00919;
	Wed,  4 Nov 2026 21:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826879;
	bh=3m6wH8JkptmAhSbIg1gI8PEGHEhV4wlcDl8CpPDgEmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoEueaXNeFNf1+m23Y7nY5nLRLja5hxt4Rgz00fK89kKHm+LZ/OF97d4d3j+QCMd2
	 mFLCFH77AgnPSKdAPtcY4UjHzs/sMJSU9Fe2RFkwtxY6ufUDaIlWmPsARYmpvwBkSi
	 DfFmnAa8pyRxhm6w4U+Gi0pPJWKMOz0sr4LdJfus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 062/547] io_uring/timeout: dont lose a cancel as io-wq arms a timeout
Date: Wed,  4 Nov 2026 16:04:06 -0500
Message-ID: <20261104211040.038789117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 89f193dc3ef462059387e9691bf6af4b1808379a ]

An IORING_OP_TIMEOUT run by io-wq, because of IOSQE_ASYNC, has the same
problem as poll, futex and waitid. io_wq_submit_work() looks at
IO_WQ_WORK_CANCEL once, before it issues the request. A cancel in between
flags the work, gets -EALREADY, and searches ->timeout_list in vain,
while the worker then adds the request and starts the timer:

  io-wq worker                          io_try_cancel()
  io_wq_submit_work()
    IO_WQ_WORK_CANCEL isn't set
                                        io_async_cancel_one()
                                          sets IO_WQ_WORK_CANCEL
                                          = -EALREADY
                                        io_timeout_cancel() = -ENOENT
    io_timeout()
      adds the request to ->timeout_list
      hrtimer_start()
    = IOU_ISSUE_SKIP_COMPLETE

Nobody looks at the flag again, and the timeout runs its course. At ring
exit, io_uring_try_cancel_requests() cancels io-wq work and then kills
the timeouts the same way, so an exiting task can get stuck for the full
duration of such a timeout.

Look at the flag under ->timeout_lock, which the search takes as well,
and fail the request if it is set. If the search came first, the flag is
visible. If it comes later, it finds the request on the list.

Fixes: ce35a47a3a02 ("io_uring: add IOSQE_ASYNC")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h | 14 ++++++++++----
 io_uring/timeout.c  |  7 +++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 22374bf536a04..2d6b2158605ad 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -435,16 +435,22 @@ static inline void io_ring_submit_lock(struct io_ring_ctx *ctx,
  * cancellations find it, rather than completing it. Whoever tried to cancel
  * the request before that found it running. It has flagged the work item,
  * has searched the list in vain, and won't come back. To be called with
- * ->uring_lock held, which the search needs as well, once the request is on
- * the list: if the search came first, the flag is visible.
+ * the lock the search takes held: if the search came first, the flag is
+ * visible. For most lists that is ->uring_lock, timeouts use ->timeout_lock.
  */
+static inline bool __io_wq_cancel_seen(struct io_kiocb *req,
+				       unsigned int issue_flags)
+{
+	return (issue_flags & IO_URING_F_IOWQ) &&
+	       (atomic_read(&req->work.flags) & IO_WQ_WORK_CANCEL);
+}
+
 static inline bool io_wq_cancel_seen(struct io_kiocb *req,
 				     unsigned int issue_flags)
 {
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	return (issue_flags & IO_URING_F_IOWQ) &&
-	       (atomic_read(&req->work.flags) & IO_WQ_WORK_CANCEL);
+	return __io_wq_cancel_seen(req, issue_flags);
 }
 
 static inline void io_commit_cqring(struct io_ring_ctx *ctx)
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 0eb0e64e3081b..ca03cb95ad8dd 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -687,6 +687,13 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 
+	/* the list is searched under ->timeout_lock, see io_wq_cancel_seen() */
+	if (__io_wq_cancel_seen(req, issue_flags)) {
+		raw_spin_unlock_irq(&ctx->timeout_lock);
+		io_req_task_queue_fail(req, -ECANCELED);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
 	/*
 	 * sqe->off holds how many events that need to occur for this
 	 * timeout event to be satisfied. If it isn't set, then this is
-- 
2.53.0



