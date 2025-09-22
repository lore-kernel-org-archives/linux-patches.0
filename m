Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9013B2F0C6C;
	Mon, 22 Sep 2025 19:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569762; cv=none; b=HRilrb9+kN+PiOBHl8YexQV0p1kHo70BYlkQimECgjp6SQJJdEDySMoq1ioPvtrDt+JbTFIKimsBZmpuDZX5kfqQDLKzBDhogx9Do5SabnLcW5xW6NrbHXIovECVUf9KTfJZKEkltOnEvuRGw+1m2s4TdX3fhIxeiGF62LXE36M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569762; c=relaxed/simple;
	bh=93FOMFpooQKOVxf+kAUR88MyuiZyHHIf/XqMHXv87YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtW+DWWSHUF62E8+XYnx0xRxdJz7G8TJ/Xv4G9NOc5+pCvNVLXJL85FVdxZAVpib6lXURuWcke1ra3L024AFhAZM2Lcy0CeNysI3wywn5+v2uhRBgmMxJ5LNvnR4b0KgtAO7x+r/GMWWnBpl2QDIGk2QYHnNzcnhhBXiITVS9xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzCf5ZJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzCf5ZJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2F6C4CEF5;
	Mon, 22 Sep 2025 19:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569762;
	bh=93FOMFpooQKOVxf+kAUR88MyuiZyHHIf/XqMHXv87YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzCf5ZJBBO8Qx3Liy1NQY1ZLpuQ64r7wqwhn0QtucRyZkegT265sfBU5fS8ZnOfJr
	 PZHV3sJZJmUdx2Ggcr1IEO0gRCz0lIldvOPnDifR42nTgoyuQ6a2vu+H3owg7Or057
	 nxlWrbzKEeRZigeYWUVxlykGL3Igf237ljuyRJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 47/70] io_uring: backport io_should_terminate_tw()
Date: Mon, 22 Sep 2025 21:29:47 +0200
Message-ID: <20250922192405.874781794@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Parts of commit b6f58a3f4aa8dba424356c7a69388a81f4459300 upstream.

Backport io_should_terminate_tw() helper to judge whether task_work
should be run or terminated.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 +--
 io_uring/io_uring.h |   13 +++++++++++++
 io_uring/poll.c     |    3 +--
 io_uring/timeout.c  |    2 +-
 4 files changed, 16 insertions(+), 5 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1460,8 +1460,7 @@ static void io_req_task_cancel(struct io
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
@@ -394,6 +394,19 @@ static inline bool io_allowed_run_tw(str
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
@@ -258,8 +258,7 @@ static int io_poll_check_events(struct i
 {
 	int v;
 
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(io_should_terminate_tw()))
 		return -ECANCELED;
 
 	do {
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -307,7 +307,7 @@ static void io_req_task_link_timeout(str
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING)) {
+		if (!io_should_terminate_tw()) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,


