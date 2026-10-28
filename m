Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207972;
	b=PPBTL18ii/IdhqcZ1Pso4bM95ewA7BGVktQi+y4mxP2dAcbl6kpUZ/kaOtVxTpkLvnG8
	 eHRWR0Kao33U8cEPV9h5h7nmcHDrHxavfydh1IQuWcgVjskeVTMeiipqXTGVlnmhWAkWG
	 q4sqWrwnFuumhb1EGt3vJnLN67xkbutnUAxK2COGaL+YSf06Y6aqL05bMwYoQ7MF6IAy6
	 lxS8LLbsGbfYNedJmHYcD/ChO45GgHc0mVSKdMJ5MTpcz86sKbY70+xjfo829qYzzYRks
	 mm5hJ4UnE0Duj891RAQOiNFtpUfzl02VS6ire52tFaMGJ9bpdfVyFaq/8oW4imjG8zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BmHYuWKOQfbZKrOhn2kFpTaThZ1lxQey9EiyI8u6PeU=;
	b=yRKeYDYqMQVlmU+pn7AREIKo6uuce05eYONJzJ7q8+KAdz9ds2UQzyG8I0h9kxK0JqSp
	 93+mjTxd25N3mqp2nY+7QxyeRpQdrMixBh79f2ziI4H1BlciS+nN9by6aytx+Bz/D3S3x
	 F5Ox+Agm0b8Bvqh2DmAZb9atYL/Rt9vPDWkWpGvJmr78sQbQx4ieKiQLNaDZgiFdlvkxP
	 picr2o4rKym9oz8t6NLtk6DcdAV/R3PGL7pjHubTJ4Hivnl1XtowqjRMqSWUPNqARJLsd
	 dae/bciDJ9QH3q/GSxwnV65J7SG2VL0gZAznXF7Qf10iEI52ZPRm1aIlO/zYDDwj3zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRyyRQtt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01577606A31D;
	Wed, 28 Oct 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRyyRQtt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524391F01825;
	Wed, 28 Oct 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207971;
	bh=BmHYuWKOQfbZKrOhn2kFpTaThZ1lxQey9EiyI8u6PeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRyyRQttf19QQTvKvTrXoR/Y3HSn0uMCb7iNXNuNHj6cRVrnsiyNt53t0g8v1VEFM
	 L7jUQ09SINXFgO1Fag05Q8HFvvnXk0FX5bSCUjPhBLbdMW0DbEL8k4As+Wl1ukOj9D
	 cOiadF+e3Z63BcnwrB3a+mh5JJ9nCcp99S99wYLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 203/247] io_uring: dont lose a cancel as io-wq parks a request
Date: Wed, 28 Oct 2026 18:00:06 +0100
Message-ID: <20261028165952.227895825@linuxfoundation.org>
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

Commit 5cb049d2203d7a81a1c1a737c8df4575e71078e3 upstream.

IORING_OP_FUTEX_WAIT, IORING_OP_FUTEX_WAITV and IORING_OP_WAITID don't
block. They put the request on a list of the ring, where a wake up or a
cancellation finds it, and return IOU_ISSUE_SKIP_COMPLETE. They do so as
well if they are run by io-wq, e.g. because of IOSQE_ASYNC.

io_wq_submit_work() looks at IO_WQ_WORK_CANCEL once, before it issues the
request. Somebody who wants to cancel the request after that, and before
it is on the list, finds it running:

  io-wq worker                          io_try_cancel()
  io_wq_submit_work()
    IO_WQ_WORK_CANCEL isn't set
                                        io_async_cancel_one()
                                          sets IO_WQ_WORK_CANCEL
                                          signals the worker
                                          = -EALREADY
                                        ...
                                        io_futex_cancel() = -ENOENT
                                        ...
    io_futex_wait()
      adds the request to ->futex_list
    = IOU_ISSUE_SKIP_COMPLETE

Nobody looks at the flag again. IORING_OP_ASYNC_CANCEL returns -EALREADY
and the request stays.

It is the problem that "io_uring/poll: don't lose a cancel as io-wq arms
poll" deals with for poll.

Look at the flag once the request is on the list, and cancel it if it is
set. The lists are searched and the requests are added with ->uring_lock
held, and the flag is set before the search. So either the search finds
the request, or it came first and the flag is seen.

What the canceller is told doesn't change, see the other patch, also for
IORING_ASYNC_CANCEL_ALL and _ANY.

[ 6.12: __io_futex_cancel() and __io_waitid_cancel() take the ctx as well.
  futex_wait_setup() returns with the hash bucket locked and the futex_q
  not queued yet, so io_futex_wait() queues it before the check, with
  ->uring_lock still held ]
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Fixes: 8f350194d5cf ("io_uring: add support for vectored futex waits")
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-15-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c    |    7 +++++--
 io_uring/io_uring.h |   17 +++++++++++++++++
 io_uring/waitid.c   |    2 ++
 3 files changed, 24 insertions(+), 2 deletions(-)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -307,6 +307,8 @@ int io_futexv_wait(struct io_kiocb *req,
 		 */
 		__set_current_state(TASK_RUNNING);
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(ctx, req);
 	} else {
 		iof->futexv_unqueued = 1;
 		if (woken != -1)
@@ -348,9 +350,10 @@ int io_futex_wait(struct io_kiocb *req,
 			       &ifd->q, &hb);
 	if (!ret) {
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
-		io_ring_submit_unlock(ctx, issue_flags);
-
 		futex_queue(&ifd->q, hb, NULL);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(ctx, req);
+		io_ring_submit_unlock(ctx, issue_flags);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -251,6 +251,23 @@ static inline void io_ring_submit_lock(s
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
+/*
+ * For a handler that is run by io-wq and parks the request on a list where
+ * cancellations find it, rather than completing it. Whoever tried to cancel
+ * the request before that found it running. It has flagged the work item,
+ * has searched the list in vain, and won't come back. To be called with
+ * ->uring_lock held, which the search needs as well, once the request is on
+ * the list: if the search came first, the flag is visible.
+ */
+static inline bool io_wq_cancel_seen(struct io_kiocb *req,
+				     unsigned int issue_flags)
+{
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	return (issue_flags & IO_URING_F_IOWQ) &&
+	       (atomic_read(&req->work.flags) & IO_WQ_WORK_CANCEL);
+}
+
 static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	/* order cqe stores with ring update */
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -375,6 +375,8 @@ int io_waitid(struct io_kiocb *req, unsi
 		 * a waitqueue callback, or if someone cancels it.
 		 */
 		if (!io_waitid_drop_issue_ref(req)) {
+			if (io_wq_cancel_seen(req, issue_flags))
+				__io_waitid_cancel(ctx, req, true);
 			io_ring_submit_unlock(ctx, issue_flags);
 			return IOU_ISSUE_SKIP_COMPLETE;
 		}


