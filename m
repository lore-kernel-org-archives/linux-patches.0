Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208106;
	b=il931AtY9c1aQh06b4bBQv04nmnT4OJT5ZTklVLhn1Q62pmo0yCYhJo6B34kQ/gRFvdQ
	 NJekvLHY6J24q8lNA/R7rGrk+zY8VEaTVuFe6SbYRmPfiKfMNwzdoI/XcBUA8bcUrmCQf
	 gWD9dcapkMk9dcptGutWXoz172LSzakX3GojmU8a5+W/ai/E9N1cVVVUhacZjhomGIC/q
	 70U6rk3dL+vC0rPTz2vrG3nUrO1Uvj+hpCJ4Wm3XSYz1zoNmXzY1GdA/f7SUhq803/U06
	 WeZs90mI9KEXkgHFt8X+hGGF1HaHRqtY6/YeFGRnFJyjwkjgcfjpQi25irbT1ZfLOUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rBJz6q9nT+IT7uSmv3KxZsDbvm5XZIyH+BVYc5eebYw=;
	b=ce6ED6Ob9CNju6oCD3DRC58Dopm/lrqu4gOoglV38fdRZ/hRnmIG7BSA+BiBJK0uXRXQ
	 yRW2Dt48mSYiHMyC09PXfbJTqVdAzjtYnKf0nmzxgQZ89gNK6xt0VHecM3KKY6CG84BMP
	 taiVlsUVg2Mac6pI/JdAWBMK46SoBX+7BTZ3m1ip0529qfvtn2+Zc0N1K/43N87r+xPhr
	 nH4l/T/7PZIv3J3fL6UHczEjtEvZDY7xNJs7nskKPSla7TITcBraig58TQzfLOPMAEjU4
	 cz6UkhfaCHhPBSxpFPu7c69Vy+koCs+ISvKuwwUpZcd+ndXSt0OMgEUr0wqjYIWQqsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dtk0LdDK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E58606A31C;
	Wed, 28 Oct 2026 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dtk0LdDK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82F81F01825;
	Wed, 28 Oct 2026 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208106;
	bh=rBJz6q9nT+IT7uSmv3KxZsDbvm5XZIyH+BVYc5eebYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dtk0LdDKZQXH8tiuWNZv4wxFYpak4KsGeGMF3DKi6nNtfEjI4SgbAy0WzYHTYBdzo
	 JndwYU4cRoygk20/M6r/V+lRX6p6hm29okjTItWCZJilJn3jME7HfeBFC99aYeRi3c
	 Y1c4JXPxIIqifC2kFOlXolWka4NYXiC0yhLeLM8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 225/247] io_uring/timeout: dont lose a cancel as io-wq arms a timeout
Date: Wed, 28 Oct 2026 18:00:28 +0100
Message-ID: <20261028165952.748420341@linuxfoundation.org>
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

[ 6.12: ->timeout_lock is a spinlock here ]
Fixes: ce35a47a3a02 ("io_uring: add IOSQE_ASYNC")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |   14 ++++++++++----
 io_uring/timeout.c  |    7 +++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -274,16 +274,22 @@ static inline void io_ring_submit_lock(s
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
@@ -607,6 +607,13 @@ int io_timeout(struct io_kiocb *req, uns
 
 	spin_lock_irq(&ctx->timeout_lock);
 
+	/* the list is searched under ->timeout_lock, see io_wq_cancel_seen() */
+	if (__io_wq_cancel_seen(req, issue_flags)) {
+		spin_unlock_irq(&ctx->timeout_lock);
+		io_req_task_queue_fail(req, -ECANCELED);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
 	/*
 	 * sqe->off holds how many events that need to occur for this
 	 * timeout event to be satisfied. If it isn't set, then this is


