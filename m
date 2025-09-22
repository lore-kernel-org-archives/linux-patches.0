Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08638C8E6;
	Mon, 22 Sep 2025 19:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569549; cv=none; b=ZUNSRR3tgXPQ/f0yFbLyThb470cdTyJwhwYJFUemS6UxpizJ86O5luvjp9gKUuTN97UmGnBhcnWMUGYnx3KN8fFOyMtsWqr3RQ7lcFLGT3IOeBPOuBQdJY/UjvMiome8BEq71RNq7rIaH4VuaqA1KN69MRrO9Q+MriYkcLAbSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569549; c=relaxed/simple;
	bh=DULn5ssjtZtJ0v+tHXcjypTSy8btLsmO6vD4Lt34yh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALK+tJa2SkMdIzMMaMfTJ5rXux0qXtdPs5tmBir0wwEPdgh+y5OPqL7Kn8iQFl8DR7XRwdEPobv8UuwN5mlw1myHpi38DGNodkwF5m9a+wisYjseICOu3U3aCI96MtoVU3XQoqGvLufHmGeLhH593H6dLGGNK/Ny3I99HyL0zdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnMxDBc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnMxDBc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963DFC4CEF0;
	Mon, 22 Sep 2025 19:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569548;
	bh=DULn5ssjtZtJ0v+tHXcjypTSy8btLsmO6vD4Lt34yh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnMxDBc/E8Z3oxVlcMspTdqsqxj+/9BXLh/yl4aueYScTiNvvSP57KtqospGgt+8B
	 jHCFXJwx7/w4qHnx4SUYxXyMrMErOeoKTRqnYV6Ve/N+xCv8qg4n/hSNYmfjX2WeND
	 XWBLwRf6sn+aFLJzq3XSvSpRGzY5SBjPOSFqq/Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 36/61] io_uring: backport io_should_terminate_tw()
Date: Mon, 22 Sep 2025 21:29:29 +0200
Message-ID: <20250922192404.557793883@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Parts of commit b6f58a3f4aa8dba424356c7a69388a81f4459300 upstream.

Backport io_should_terminate_tw() helper to judge whether task_work
should be run or terminated.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++---
 io_uring/io_uring.h |   13 +++++++++++++
 io_uring/poll.c     |    3 +--
 io_uring/timeout.c  |    2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1249,8 +1249,7 @@ static void io_req_task_cancel(struct io
 void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
 	io_tw_lock(req->ctx, locked);
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (likely(!(req->task->flags & PF_EXITING)))
+	if (likely(!io_should_terminate_tw()))
 		io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
@@ -1773,7 +1772,7 @@ static int io_issue_sqe(struct io_kiocb
 int io_poll_issue(struct io_kiocb *req, bool *locked)
 {
 	io_tw_lock(req->ctx, locked);
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(io_should_terminate_tw()))
 		return -EFAULT;
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
 }
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -395,6 +395,19 @@ static inline bool io_allowed_run_tw(str
 		      ctx->submitter_task == current);
 }
 
+/*
+ * Terminate the request if either of these conditions are true:
+ *
+ * 1) It's being executed by the original task, but that task is marked
+ *    with PF_EXITING as it's exiting.
+ * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
+ *    our fallback task_work.
+ */
+static inline bool io_should_terminate_tw(void)
+{
+	return current->flags & (PF_KTHREAD | PF_EXITING);
+}
+
 static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
 {
 	io_req_set_res(req, res, 0);
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -241,8 +241,7 @@ static int io_poll_check_events(struct i
 	struct io_ring_ctx *ctx = req->ctx;
 	int v;
 
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(io_should_terminate_tw()))
 		return -ECANCELED;
 
 	do {
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -275,7 +275,7 @@ static void io_req_task_link_timeout(str
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING)) {
+		if (!io_should_terminate_tw()) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,


