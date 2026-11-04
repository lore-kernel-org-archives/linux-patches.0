Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826826;
	b=GC840Jbtsz6BIoisqkvnH1IYs/aqVk6jAOURG71rMttQ+cBT025vtpB+inYMula/Ez5j
	 nvvFVdCdAu2NScAY5kTiJqFRzHM7hAO8ejc9OhxmWZZaceYntIU/TaBHk+hB/3rLSGTa5
	 igRD37Lyf+jY4NmJkwaS5PfNfzXX6K14wptzEoH/DG4FNFh3ho1jb2Hm2+pAJnUuKFqdD
	 mWyXynF+C9oBiQ8jHPGeT/xPJw7LfelOPG7yLHkasK0pBoMwthGeyOBT7ucospxQbptv6
	 BMyW0qvfmuQjjpU9TmIJB90kmC+EtuoOYxw8kp1jIHdzcXdD8CMA2J/xill6Mis6m8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Ejgrx0RXAZF8JcADreCTAx7oLYqz8/rtQJH5Pzw5gw=;
	b=RNierItW9L/ky8VOWLBQKFPMOdTrLDSXkQPoKUI6BAV7x6vqDeBLBDwd50gRx/lWmXNs
	 vGc7r72Bigj7FlVPTViQU4rLtdM9vgLjyW/ZAJ45A+N7peaez4CNtc1CzluYWpQNf+QT6
	 nwGPeZsZLCdgRG4+70y/lLoLfjNy8P70QLjhAsBY2F15nDW6VEzxG9xMWrkHi+Pn3ncz4
	 XvNTSbPz+bguaNgBvc5ixPajv0YmxXqBuD245/ObcuRTlIag/dmU2WLnkSdq4oF1apouh
	 PAnqJMGB1eMMk6RvJLueoqkD6DXS7x5Pj71DqEWegwAz+uun/6fZx9DuA1leBff7zAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bnay3vJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7960A3AB7;
	Wed,  4 Nov 2026 21:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bnay3vJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986E71F00A02;
	Wed,  4 Nov 2026 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826825;
	bh=5Ejgrx0RXAZF8JcADreCTAx7oLYqz8/rtQJH5Pzw5gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bnay3vJxhjFB7duv4oqWj6+1qmMzdzStpazur7LQTj3ORP192jGUy+ADomE46gRxa
	 YFpcBCtwJQVJ4rI5b2mnqGBeT8/izaOgVE44N6urN1Ro6zxCOJpvOAuTYkOqhsx6FK
	 nVsnwZzkx1EIKu+5c3t4kjZhrNAGldtgyY//57bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 031/547] io_uring: dont lose a cancel as io-wq parks a request
Date: Wed,  4 Nov 2026 16:03:35 -0500
Message-ID: <20261104211039.230511445@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5cb049d2203d7a81a1c1a737c8df4575e71078e3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c    |  4 ++++
 io_uring/io_uring.h | 17 +++++++++++++++++
 io_uring/waitid.c   |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index eaee14242a3a3..64909a2a8c886 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -283,6 +283,8 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		__set_current_state(TASK_RUNNING);
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(req);
 	} else {
 		iof->futexv_unqueued = 1;
 		if (woken != -1)
@@ -323,6 +325,8 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 			       &ifd->q, NULL, NULL);
 	if (!ret) {
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		if (io_wq_cancel_seen(req, issue_flags))
+			__io_futex_cancel(req);
 		io_ring_submit_unlock(ctx, issue_flags);
 
 		return IOU_ISSUE_SKIP_COMPLETE;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 71aa30186a667..659deb13c6680 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -412,6 +412,23 @@ static inline void io_ring_submit_lock(struct io_ring_ctx *ctx,
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
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index f9211446efd44..172cf770b29b2 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -352,6 +352,8 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 		 * a waitqueue callback, or if someone cancels it.
 		 */
 		if (!io_waitid_drop_issue_ref(req)) {
+			if (io_wq_cancel_seen(req, issue_flags))
+				__io_waitid_cancel(req, true);
 			io_ring_submit_unlock(ctx, issue_flags);
 			return IOU_ISSUE_SKIP_COMPLETE;
 		}
-- 
2.53.0



