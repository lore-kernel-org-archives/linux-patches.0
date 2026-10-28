Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207323;
	b=ygEiCe5cOyTixMfhbGqCTVCEb5RvOO0nxuqBQ0uzcg84uU6t2QWk2RCjn0+6dEHY/KKZ
	 8zEo2r/neqnR+/3O3cydxRrxWkJu8QAoF2QL1UgbLyng71gyl39K6Ua0DhxnbzczZii+G
	 tcbgRTEUhgMO+dmW5EuEzgloGXkz+b6//bsRjUBepFP1McWwNA7uyeW60juXIBpapHj5D
	 1wOkCOiMgi8UxAzZT446GyKCSunErZTS5BbNiDbL4RtPueM0FwtQ4lR2poDt3DJk11pfo
	 IJN5Xok3/Jc7ZRQuhIq6eW7NX+j7J6AHWAgmYxWh3pe8tpDO/5lbRnX7sjXKWLaAUbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GmdlK4Bxf6optuOi/G5PTi7n9Rg/3OVJmEfBJY8Jz/E=;
	b=BuaU45d3C6jo1p7wkdGhuC3P53MQbpaBLQ2WYBpqHuWdByPxbel2UIPU5U1UGu5U5wxd
	 r/IAvQpHb9NFkSDTWhhoaK7sfMvxDWjsD88xU27Fp0cyx8kzg9gDJs/fwHmUxMyMOP2xx
	 RG9H9wLzHKjkWrjaxffZb2/nE8BFp4S9fRWygjK2/O+8sI4wU1xo3BL2vrtUOpXyWvRrz
	 RBny3ByMqgEjswmBs6rBJopDk1eOaN+cVuPveccnN/Ue5St5AKTjGyP+l27gGALDS14VK
	 zlvP5SVmSoR+Zo/kGz4JNAvJtx71tQV7aIaT076Ys2u6dp121PfptTaQaoT63w4oP9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0BUzeIL/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8ED606A31A;
	Wed, 28 Oct 2026 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BUzeIL/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD781F01828;
	Wed, 28 Oct 2026 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207323;
	bh=GmdlK4Bxf6optuOi/G5PTi7n9Rg/3OVJmEfBJY8Jz/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BUzeIL/gmJNLJTtR1cwDH/ry67uJ3LExPgakoiaXyFObQ2uqKrBTA8G288SYCNTn
	 2ynLE1DWwCp5Jf1hX82j9ctUPbrmHVFzVqgGGhd9FtHdjWgIunIw7M643iCbokpuun
	 BXRDkDPkmztF0oGc42ehSb2/eej+CZ1o3/fHGepU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 63/88] io_uring/timeout: dont lose a cancel as io-wq arms a timeout
Date: Wed, 28 Oct 2026 18:00:11 +0100
Message-ID: <20261028165943.597549849@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 89f193dc3ef462059387e9691bf6af4b1808379a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |   14 ++++++++++----
 io_uring/timeout.c  |    7 +++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -434,16 +434,22 @@ static inline void io_ring_submit_lock(s
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
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -687,6 +687,13 @@ int io_timeout(struct io_kiocb *req, uns
 
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


