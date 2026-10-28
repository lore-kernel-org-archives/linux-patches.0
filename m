Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207224;
	b=Ra/9M/qpYSfQSNhRlccQwkYso/n0lFb9zN8iGHHBN/srhqJss9HSn4/qZMqWsRFUFuA4
	 53KM+J0tMarBx/lTWv9NCOS/UGK7cxHNswZ3+9+MjqL9KteqPGV25GdKF/TOx5FknRGO/
	 GTgCtjTtzYZgoDtgvxUyPulKalSsfTNY4OFLRZLgCcjNsQC27w0Qf8BORQTkOAGqxZc8C
	 ULd0+4RUAWlQynf151camazJRyuGsaDR33t1Br+Kk3ZrCTj5zw4pDGyxIQCbXdwZ4FTyo
	 7aHUwIHfYmbmCDZV1jJgqopr3Fbdu67LHVpFFyo7mDorrHNidFhIwneQBeAttCElzDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNpGQijm6OL9C9yK2zf6JQmBDh1w3e7CkPFac6z+Sdc=;
	b=4YjwKnhn/NEkGzRCCJgd9VkLJBLKkcwE4cNyUEAem4VlkojmIO0tXR2/HiCNtyiDh0x5
	 MYCSi8W5sl5YPt7esN1k92+tZsTtqgx/zZT0Q+ySNNXajnqQUCNLiACt8N5LtGkajkHxx
	 VDuDOWXqKfF2/mhKHJ6/yylDKwp31ni08P2kpMdBnpFqeKJoPvxKrJPhQRJObYc2nZULP
	 FNuLy4BsEPI0pS1jBQksjY5JL5xagfFI23hc6vHmAm+DAwyMBXEc9a0dpVqcBdSa1cT/w
	 sRMdWhBPANRxeLi22TDTXlYXMX7dZnGqLBu/Isy4xsBlXnGUML2Yd26vD9QErmUgDWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OO1NUSYB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DD606A31C;
	Wed, 28 Oct 2026 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OO1NUSYB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F971F01828;
	Wed, 28 Oct 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207223;
	bh=lNpGQijm6OL9C9yK2zf6JQmBDh1w3e7CkPFac6z+Sdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OO1NUSYBjyUYB3HfyQvjHLBeebSWCPvGOcSWw6L2YTj4UUXO/+rEhJi+97x3DONU8
	 +4WQlZP65u+MxIlcPY/OWTDsVqbZDl2ZQUbOMBmWoGKKwf5BugD2qRQZTiiEYgcfh1
	 yVdbQjrdw6iuZoQ3EdlcxZMrtQfyQt3ufc+NAlI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 31/88] io_uring: dont lose a cancel as io-wq parks a request
Date: Wed, 28 Oct 2026 17:59:39 +0100
Message-ID: <20261028165942.848583814@linuxfoundation.org>
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
@@ -283,6 +283,8 @@ int io_futexv_wait(struct io_kiocb *req,
 		 */
 		__set_current_state(TASK_RUNNING);
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(req);
 	} else {
 		iof->futexv_unqueued = 1;
 		if (woken != -1)
@@ -323,6 +325,8 @@ int io_futex_wait(struct io_kiocb *req,
 			       &ifd->q, NULL, NULL);
 	if (!ret) {
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(req);
 		io_ring_submit_unlock(ctx, issue_flags);
 
 		return IOU_ISSUE_SKIP_COMPLETE;
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -411,6 +411,23 @@ static inline void io_ring_submit_lock(s
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


