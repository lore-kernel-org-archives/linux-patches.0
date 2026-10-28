Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210372;
	b=mzf8VnLGQwPOlGw3LJvKUHAukkqbdn1Y0NDmg55oH/63iTmX0geD7eYuJYHSyfsw77pr
	 krnxpzqRIaLtxBKuKgwGGHQZrC1XCiTU22im4aKH3rHQvoWa18AYa69q4QWJjdq/4uHmF
	 fMlOUMsnSjN+aEO3rHrTWkaUwErCmp5EsX8/WCXZdytCBonc33ULVGGDOUvmjT/kqPFdn
	 Euz5WBcBta1dKz+xsQOCe1jwr1gdsFmEMn/V3EBO3eXBISI6C1Kj+60RLYAtYnsxe5aGJ
	 q6aEmDZ29gssrHkSxoQuxb8WwvwxBu4sz+p9bSfBk/bT44TWndmrra+C3DB6rUy9dQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=znm3mz72GCM3/d8wIFZuNMk31Z9c5u7THleDTYxpCi0=;
	b=sx+BbaFkZpSVM2pmtBLyWiGkFD09V0jCGQXVus4OdENaCwK/fcIOgO8+ck4nx5rau5az
	 7MC925stbktrKnYMoIBJKyi0EznCjxPGiEctYZKHIM7YBFSZE2wTlWu33vQvPwez7bm1V
	 9T/wVUsvQUTpoME4dMtz3szdzoWP7mSHUzbxWaED83UEfnFhQ/BHxSk2jmxRjT6J2oecN
	 8I7iv8wPMRiO9NpiFuQEWaZGGWTIsJon6RB4VRLZkBqy30i5jlMSGGrYCW1nuxms/Zo/y
	 uHercBPFkQOBPZxh8u4MMZFOLo0nxOaUXmQJimjMabrxi/+VzsST3Qu9Ww8WvXFjHyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmMJ9Pkr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9E0606A31A;
	Wed, 28 Oct 2026 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmMJ9Pkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805E11F01825;
	Wed, 28 Oct 2026 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210372;
	bh=znm3mz72GCM3/d8wIFZuNMk31Z9c5u7THleDTYxpCi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmMJ9Pkr35NHVIzTjMK8dwASUWbMcYHMn8zRUdDboaeJnyjT6MLI7pAbt1MrhWanb
	 uJtFwjZfqFw9JZxtGJPSm3gina3Fktd0GKYOTfHd9CSK0LA0YMghnwlzFuLj3HMl7c
	 wiMfqHjHz8Vgjz8n7x/QjDULArcQNZv6Tc7ijPPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 151/168] io_uring/timeout: dont lose a cancel as io-wq arms a timeout
Date: Wed, 28 Oct 2026 18:01:27 +0100
Message-ID: <20261028165946.660824888@linuxfoundation.org>
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

[ 6.6: carries the __io_wq_cancel_seen()/io_wq_cancel_seen() helpers that
  the futex/waitid fix 5cb049d2203d brought upstream; work->flags is not
  atomic and ->timeout_lock isn't raw here ]
Fixes: ce35a47a3a02 ("io_uring: add IOSQE_ASYNC")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |   23 +++++++++++++++++++++++
 io_uring/timeout.c  |    7 +++++++
 2 files changed, 30 insertions(+)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -259,6 +259,29 @@ static inline void io_ring_submit_lock(s
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
+/*
+ * For a handler that is run by io-wq and parks the request on a list where
+ * cancellations find it, rather than completing it. Whoever tried to cancel
+ * the request before that found it running. It has flagged the work item,
+ * has searched the list in vain, and won't come back. To be called with
+ * the lock the search takes held: if the search came first, the flag is
+ * visible. For most lists that is ->uring_lock, timeouts use ->timeout_lock.
+ */
+static inline bool __io_wq_cancel_seen(struct io_kiocb *req,
+				       unsigned int issue_flags)
+{
+	return (issue_flags & IO_URING_F_IOWQ) &&
+	       (req->work.flags & IO_WQ_WORK_CANCEL);
+}
+
+static inline bool io_wq_cancel_seen(struct io_kiocb *req,
+				     unsigned int issue_flags)
+{
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	return __io_wq_cancel_seen(req, issue_flags);
+}
+
 static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	/* order cqe stores with ring update */
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -609,6 +609,13 @@ int io_timeout(struct io_kiocb *req, uns
 
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


