Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209722;
	b=qUsWGP81eO1by48cIZ+OmuNUbNDWu2PLu79FZrrss/SX4S2N66mEceuVPNiQFLdD41rP
	 CzUV2qPDQxTzh4EIJfjKtUD/wmJQi9EFYx40DXA7CH5hmNh6e3qTNtkAwbsDqpQP93vn4
	 dkGJAWum7Zv98tUfVNPupFN+oBysOCQy4grDT3hTkQu6soCK9vQWBKya/LvEDRbBMx882
	 gN+o8LnSRWsrq/yRqLvsPLsMUHFTHp1Cg4Mnl8NRQAfrInd9TqyjmUqZhwUSEKmZklaij
	 TqfzLt9Ng23xR8n7tuKfjyW5Lt4C+GzQLSROknAyeNoeBHgZZAms8JVMdhDKPm7PKOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=89+85ME+sliEpDYiZ+e1VTA3MUs5j1vGqFgaRrm6KPw=;
	b=DmFeM6zvxuOLdq/TPzCh7t76wAvn/81EzLC3cQtneMYA6zuICKErhqf6F537QmIwYBu3
	 QdC/ZughxSIbUp3GHR4EF2diAgkM8acqzBcysJBUaVsVnY5pC9yKl3akmXMTxXFkmecVo
	 0e9qWm5AnID6B5tDeUcRXHpCW6WVzDdCBiI4PaxrZ0KBKEwFhevs4KghO2Sv0pDu0/hJq
	 IM3W4eQQzYimS3kLtiSoeXPpoKM63LTpRleSLeAW75GekXOVA5Q9SCscqYUCehta10Fxm
	 3OAXisuneeIOV1YynV74E87V3xp4bhuVlGen3BaPG+wZTquRR1GvTf6DnVTwhs5BU7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXavFY2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971CC606A31A;
	Wed, 28 Oct 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXavFY2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43C41F01828;
	Wed, 28 Oct 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209722;
	bh=89+85ME+sliEpDYiZ+e1VTA3MUs5j1vGqFgaRrm6KPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXavFY2kyA0ZqSeg0R4hpCXi3EdjrTy6MSfMqUYsKJxf/dfTJdaKFg9R+ILfQQ0QK
	 FJS6BTiTg7tvUJhJkh26dRoctIABMuVMOPdZhZHvn0X3XrNDTrd4Z2NAJ9n4PCCfsI
	 OG138E13TqaRNEfKfY8gTk3mCeC4w+zWyc/9PQvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 055/109] io_uring: dont lose a cancel as io-wq parks a request
Date: Wed, 28 Oct 2026 18:00:39 +0100
Message-ID: <20261028165943.656868823@linuxfoundation.org>
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

Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Fixes: 8f350194d5cf ("io_uring: add support for vectored futex waits")
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-15-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c    |    4 ++++
 io_uring/io_uring.h |   17 +++++++++++++++++
 io_uring/waitid.c   |    2 ++
 3 files changed, 23 insertions(+)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -278,6 +278,8 @@ int io_futexv_wait(struct io_kiocb *req,
 		 */
 		__set_current_state(TASK_RUNNING);
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(req);
 	} else {
 		iof->futexv_unqueued = 1;
 		if (woken != -1)
@@ -318,6 +320,8 @@ int io_futex_wait(struct io_kiocb *req,
 			       &ifd->q, NULL, NULL);
 	if (!ret) {
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(req);
 		io_ring_submit_unlock(ctx, issue_flags);
 
 		return IOU_ISSUE_SKIP_COMPLETE;
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -396,6 +396,23 @@ static inline void io_ring_submit_lock(s
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
@@ -349,6 +349,8 @@ int io_waitid(struct io_kiocb *req, unsi
 		 * a waitqueue callback, or if someone cancels it.
 		 */
 		if (!io_waitid_drop_issue_ref(req)) {
+			if (io_wq_cancel_seen(req, issue_flags))
+				__io_waitid_cancel(req, true);
 			io_ring_submit_unlock(ctx, issue_flags);
 			return IOU_ISSUE_SKIP_COMPLETE;
 		}


