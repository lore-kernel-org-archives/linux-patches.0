Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209814;
	b=uYwWgm1/0v2cuWQ3Y6QxrevbPKTMZoIEcqPKoNCSTnmZQSo+CgVXZQIDIrTb9RZJGem2
	 OBY2/JuNI5Hwmb3NB/KI9ghNXHaPhGTwqQTRWfqEZ/AKcol31Ja2SpgGxltI9VPdfiB7M
	 sW9gAGI+Kaz3ulI2/07qTGfnOhXMu2QqBuD6pc7vWyqFFDiQkJqbJyP68blOeJjNQQBCO
	 vfJBD45cQ1mtShWfazlU98Sv5XbW5sAnsdSM0EQKpmFXAW+AEju7t3dCKSlwQvNoU9GBA
	 Ey1C2hi/Ey5NgEH1waTZwjeof6Hq7t2B2zIIb7Tb4gM3yhfTNTDjBR0eXT13HkgGzfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gdc84IxEXbpK44fEqFmXIIhVPGW8apVHczMtUEn5DiY=;
	b=GoUDUsGCc+3oO8Wvt96Sh5ecgPkFm3ZXuHE/aL/w2XJFba6FlyuNkAEkJjpK0viiJ+MK
	 ghLRK60wy60ax1jN9JDRCewcDLxg77c3yYJO9m+2ESrOK/LmVQkQj1TKopsOYDaRhbr3a
	 Zf5z09z9i+b/VRr+u7i3oRf5n7RiiLhStyjDrYpYJ2MDQHcUeDnHolVk+JG2Gd9M/J/NZ
	 G22UYO5NjmYI+mdD4nV8YXni16F6hjoMxS5VWLCQk0439jv2Cbge8eO6wctmam9O5Thm6
	 iVHuPounLD9WV45SH+bQeSDqrhb/HXFPlmf8cwmIpArxdd4qMvZQbqJ4CpQSwF91/hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKzkFT3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B85606A31A;
	Wed, 28 Oct 2026 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKzkFT3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FA91F01825;
	Wed, 28 Oct 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209813;
	bh=gdc84IxEXbpK44fEqFmXIIhVPGW8apVHczMtUEn5DiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKzkFT3M0l+rlmrWg9b1a+So5cHRJUE/IsrZ9EVxYG0lvTuWL0eOvIht5Fymn4OpC
	 zVRx3RrRt1N2mzOwN0kt8W6mOCJE0/c0GYiXC94T4buzaRuziNq7VoodICjqF4sR9T
	 8Z7oIZ64U1j4Yb0Q+C8gZtenSmrlc8lmKRSdS4QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 084/109] io_uring/timeout: dont lose a cancel as io-wq arms a timeout
Date: Wed, 28 Oct 2026 18:01:08 +0100
Message-ID: <20261028165944.334643781@linuxfoundation.org>
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
@@ -419,16 +419,22 @@ static inline void io_ring_submit_lock(s
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
@@ -634,6 +634,13 @@ int io_timeout(struct io_kiocb *req, uns
 
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


