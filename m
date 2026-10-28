Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212178;
	b=vK8s9KGbKbNhHoT/8+7LDWT6/cirLjJ3pXbzWQiN+abe4iOTM3DCmNbTNd6QeIoiFBHo
	 CrTo/pu5fRx8Sh3RR0uMAZGEK3eRth+LYHlwh+TnHqVMBTW5SjfBXV/6Wda9lghz27byO
	 Gbje2m6sxl/AI7lcF5ZIBTLQ7Tqyg8cvzWt1s/S5qmjCQOyUSJAb23APRPZIqPbK9m/zx
	 dHBosuwlowZbxfwH2kBZsJlOEC3h37V5n9tnnRnIVETYMTLSXzMTBJkAgjbiA+7bg1P5s
	 hwN0p3KN/l4M4mrGHJGMt2rVcVXgqgi/MYkYfjTdivDVClzKggHLzDqq86oQzcOoG9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9GtQlp585uRehhtnYJd1+Ak9Iy1cwSJ+jJymyyWTY9w=;
	b=08vt6Xe+sbVblXsYSoKFIariNaeY1jLh5RpcR0M07/XhxAeHjKX1pABh3HrmHcTln/aM
	 LkVxTHjm5c2gZvUsTaddfccxj5pTOlF27JGqQXuSqQFMUhT5tTkX7lxzf3u+uN5Xa5q0S
	 9aAgT4rZVwc2uoXK/yOIrMCX5s3NrG8vaT8NtZhnotvJw5mcqOREDzXQlnOO6StSV/EL6
	 IAVlJTbtYIX0WzMX/b2IIp3b8amvZiSKnTrEi9P0gq1Tk0WgqNeesktjaFSdRk4xuDgPz
	 mYPNnO6VAA0ma98sf3TbWKKo7KotONqVJJQaBYo46DW2iiohMIrzpnuMku9kibmbXjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8Hf2b8U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F50606A31A;
	Wed, 28 Oct 2026 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8Hf2b8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2CF1F01828;
	Wed, 28 Oct 2026 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212177;
	bh=9GtQlp585uRehhtnYJd1+Ak9Iy1cwSJ+jJymyyWTY9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8Hf2b8U94wTQ+Nyyn+XdWJoD16+sVmKDTbOi4EVZLqtsKvtNCL4JIBdypopAl52k
	 pm2hjkrFE3DH9dmt2CWRaTEZM9YES8+nuDXtzFHvXo2Jip75/mIIAi5vDKBJd0xIgT
	 FzTupn0J6sIc0DO3myWd50Vm9f4UP7j2DR9WzHcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0021/1887] io_uring/timeout: dont lose a cancel as io-wq arms a timeout
Date: Wed, 28 Oct 2026 17:35:17 +0100
Message-ID: <20261028170459.704673303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.1: adds IO_URING_F_IOWQ, which io_wq_submit_work() didn't pass yet,
  and the __io_wq_cancel_seen()/io_wq_cancel_seen() helpers that the
  futex/waitid fix 5cb049d2203d brought upstream; work->flags is not
  atomic and ->timeout_lock isn't raw here ]
Fixes: ce35a47a3a02 ("io_uring: add IOSQE_ASYNC")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring.h |    2 ++
 io_uring/io_uring.c      |    2 +-
 io_uring/io_uring.h      |   23 +++++++++++++++++++++++
 io_uring/timeout.c       |    7 +++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -19,6 +19,8 @@ enum io_uring_cmd_flags {
 
 	/* the request is executed from poll, it should not be freed */
 	IO_URING_F_MULTISHOT		= 32,
+	/* executed by io-wq */
+	IO_URING_F_IOWQ			= 64,
 };
 
 struct io_uring_cmd {
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1816,7 +1816,7 @@ void io_wq_submit_work(struct io_wq_work
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	const struct io_op_def *def = &io_op_defs[req->opcode];
-	unsigned int issue_flags = IO_URING_F_UNLOCKED;
+	unsigned int issue_flags = IO_URING_F_UNLOCKED | IO_URING_F_IOWQ;
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -221,6 +221,29 @@ static inline void io_ring_submit_lock(s
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
@@ -548,6 +548,13 @@ int io_timeout(struct io_kiocb *req, uns
 
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


