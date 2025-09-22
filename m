Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6106E2820D1;
	Mon, 22 Sep 2025 19:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569988; cv=none; b=mCjA1S92Em/wREROv3mGigH0koNtJ97dsaD7EDJMtRygvyX6H5GeY3xTlKyAIOBTJ48nHLXL3tNjY6L7aQOwLQeMbI48tPXcSrILOfvo5Jy/4Lz5GidZv+3qCKq/PohVhp4PuzW+/I2PE3b6C4ZQzqxqNcaMvWg2vxltLosBzyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569988; c=relaxed/simple;
	bh=c3xejx3Z+ml017A9EZ5DcgBz/X7ms+ZNH739Y+1M4Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtg9rICe+wQ41DQhYRE+VE/D/p1fVNMKwnUPTXYT0qMmQgMu9h99oDyKUGcRXFncBRhmDQVH3hyWGW7sPQayWz7nNZj1p9HxuvQz4Iian3obltQF74tEwFNkhv4F1Y8S6XehUBoFJF3fFl1qqjBs/d2h7hNusZ8sNeO4usvhDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTxvxTQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTxvxTQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDD4C4CEF0;
	Mon, 22 Sep 2025 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569988;
	bh=c3xejx3Z+ml017A9EZ5DcgBz/X7ms+ZNH739Y+1M4Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTxvxTQVHIraeNRKVaF5RBZdwM5gsELXZ7+LmWgXSGYWU/Q3d+W34PwqjWLwHX/eC
	 Zj6jKZc6EAfBvji9eU1botARSHESz0XyNkYHgkvsFMLWWoE+l/0cRp5qZNKWIARqNQ
	 QJMfkuPVZTdmpTynJt4Tzy8/fOExlzGp2B0uJUNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 067/105] io_uring: backport io_should_terminate_tw()
Date: Mon, 22 Sep 2025 21:29:50 +0200
Message-ID: <20250922192410.663177022@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Parts of commit b6f58a3f4aa8dba424356c7a69388a81f4459300 upstream.

Backport io_should_terminate_tw() helper to judge whether task_work
should be run or terminated.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c  |    3 +--
 io_uring/io_uring.h  |   13 +++++++++++++
 io_uring/poll.c      |    3 +--
 io_uring/timeout.c   |    2 +-
 io_uring/uring_cmd.c |    2 +-
 5 files changed, 17 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1359,8 +1359,7 @@ static void io_req_task_cancel(struct io
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	io_tw_lock(req->ctx, ts);
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(io_should_terminate_tw()))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -421,6 +421,19 @@ static inline bool io_allowed_run_tw(str
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
@@ -265,8 +265,7 @@ static int io_poll_check_events(struct i
 {
 	int v;
 
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(io_should_terminate_tw()))
 		return -ECANCELED;
 
 	do {
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -303,7 +303,7 @@ static void io_req_task_link_timeout(str
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING)) {
+		if (!io_should_terminate_tw()) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -118,7 +118,7 @@ static void io_uring_cmd_work(struct io_
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
-	if (current->flags & (PF_EXITING | PF_KTHREAD))
+	if (io_should_terminate_tw())
 		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */


