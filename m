Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01AD28EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B87C433EF;
	Mon,  2 Jan 2023 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658729;
	bh=leZMwv4UwnGNirV/iXK0BUw2HY8AoV6hCzKZ6ViRgPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQ9Ut1yt7TLOpmdvSZDbzjGPEjZhSV8I6z2Kqj3UD7QRvz0SeUtsymiUZW/yEbFjo
	 umIo4l5Ts9S6c+dMXXa419mzehcBCaNMyXWiVMwf82hSpVuw8EYiexb5eeKUDAH+mj
	 JarQIXD9jN8bwbpC5KoPqYxgf7KDj6RKNvPwb9FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/71] io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups
Date: Mon,  2 Jan 2023 12:21:28 +0100
Message-Id: <20230102110551.650271448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4464853277d0ccdb9914608dd1332f0fa2f9846f ]

Pass in EPOLL_URING_WAKE when signaling eventfd or doing poll related
wakups, so that we can check for a circular event dependency between
eventfd and epoll. If this flag is set when our wakeup handlers are
called, then we know we have a dependency that needs to terminate
multishot requests.

eventfd and epoll are the only such possible dependencies.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/io_uring.h | 15 +++++++++++----
 io_uring/poll.c     |  8 ++++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 17771cb3c333..71f1cabb9f3d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -495,7 +495,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 	int ops = atomic_xchg(&ev_fd->ops, 0);
 
 	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal(ev_fd->cq_ev_fd, 1);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
 
 	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
 	 * ordering in a race but if references are 0 we know we have to free
@@ -531,7 +531,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal(ev_fd->cq_ev_fd, 1);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 50bc3af44953..4334cd30c423 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/lockdep.h>
 #include <linux/io_uring_types.h>
+#include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
@@ -207,12 +208,18 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
 	/*
-	 * wake_up_all() may seem excessive, but io_wake_function() and
-	 * io_should_wake() handle the termination of the loop and only
-	 * wake as many waiters as we need to.
+	 * Trigger waitqueue handler on all waiters on our waitqueue. This
+	 * won't necessarily wake up all the tasks, io_should_wake() will make
+	 * that decision.
+	 *
+	 * Pass in EPOLLIN|EPOLL_URING_WAKE as the poll wakeup key. The latter
+	 * set in the mask so that if we recurse back into our own poll
+	 * waitqueue handlers, we know we have a dependency between eventfd or
+	 * epoll and should terminate multishot poll at that point.
 	 */
 	if (waitqueue_active(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
+		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
 static inline void io_cqring_wake(struct io_ring_ctx *ctx)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index d9bf1767867e..fded1445a803 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -429,6 +429,14 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		return 0;
 
 	if (io_poll_get_ownership(req)) {
+		/*
+		 * If we trigger a multishot poll off our own wakeup path,
+		 * disable multishot as there is a circular dependency between
+		 * CQ posting and triggering the event.
+		 */
+		if (mask & EPOLL_URING_WAKE)
+			poll->events |= EPOLLONESHOT;
+
 		/* optional, saves extra locking for removal in tw handler */
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);
-- 
2.35.1



