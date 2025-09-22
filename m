Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDCB191F66;
	Mon, 22 Sep 2025 19:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569551; cv=none; b=MN8i1f5X+GWEyjuLFJPeq/4rriJG/uWI++mGo/A03NzW1FC1QsaizFbEIUPqqKjXR9g2+mL6cOLkLJt4hRukla/ux9OPb5HhoO0Qm9c3EYHI+5dCGd4Y4xs54ZGzmCXLrm8P2t21CVhm3irPvhVFmb5tcn7pAtoesCUo8uAf48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569551; c=relaxed/simple;
	bh=r0nFz5QU6r8ocGJ9ZaIurnZdJodthIRQFHK3dqKjSYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz/TH78O8KFDu6IxS4kJDEHW1olEgu6sQXFhN8xHGeSsel+KVy+E3UIz2Un+pHaFCRrWgAEdWAUi06YlvdOV+FVo3/caYmzkQOuU970eDDYx3cTDb/FGIMG2e2ubnj6FZsivuMo2y/1lPj68YDHpIOc5HXPRpiDzIYrgAtFP5WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPEZHmQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPEZHmQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A58FC4CEF0;
	Mon, 22 Sep 2025 19:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569551;
	bh=r0nFz5QU6r8ocGJ9ZaIurnZdJodthIRQFHK3dqKjSYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPEZHmQyV4P9U7fvqL6wG3S8yUnwumhFrrINPhgyWc1+KZSFdPfU9BEgvne1Ta0Ok
	 GOd6YJsycdpvs0C3w70R6c/MJFhMHIPJZmkHdg4o3cgHkZDAEr5775WVlwj/+aT6Ih
	 ae9nJBN91MvRoqs/3+ojJ/Tbd9SFVMY9t6gfwABA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedek Thaler <thaler@thaler.hu>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 37/61] io_uring: include dying ring in task_work "should cancel" state
Date: Mon, 22 Sep 2025 21:29:30 +0200
Message-ID: <20250922192404.585006404@linuxfoundation.org>
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

Commit 3539b1467e94336d5854ebf976d9627bfb65d6c3 upstream.

When running task_work for an exiting task, rather than perform the
issue retry attempt, the task_work is canceled. However, this isn't
done for a ring that has been closed. This can lead to requests being
successfully completed post the ring being closed, which is somewhat
confusing and surprising to an application.

Rather than just check the task exit state, also include the ring
ref state in deciding whether or not to terminate a given request when
run from task_work.

Cc: stable@vger.kernel.org # 6.1+
Link: https://github.com/axboe/liburing/discussions/1459
Reported-by: Benedek Thaler <thaler@thaler.hu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   12 ++++++++----
 io_uring/io_uring.h |    4 ++--
 io_uring/poll.c     |    2 +-
 io_uring/timeout.c  |    2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1248,8 +1248,10 @@ static void io_req_task_cancel(struct io
 
 void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
-	io_tw_lock(req->ctx, locked);
-	if (likely(!io_should_terminate_tw()))
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_tw_lock(ctx, locked);
+	if (likely(!io_should_terminate_tw(ctx)))
 		io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
@@ -1771,8 +1773,10 @@ static int io_issue_sqe(struct io_kiocb
 
 int io_poll_issue(struct io_kiocb *req, bool *locked)
 {
-	io_tw_lock(req->ctx, locked);
-	if (unlikely(io_should_terminate_tw()))
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_tw_lock(ctx, locked);
+	if (unlikely(io_should_terminate_tw(ctx)))
 		return -EFAULT;
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
 }
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -403,9 +403,9 @@ static inline bool io_allowed_run_tw(str
  * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
  *    our fallback task_work.
  */
-static inline bool io_should_terminate_tw(void)
+static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
 {
-	return current->flags & (PF_KTHREAD | PF_EXITING);
+	return (current->flags & (PF_KTHREAD | PF_EXITING)) || percpu_ref_is_dying(&ctx->refs);
 }
 
 static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -241,7 +241,7 @@ static int io_poll_check_events(struct i
 	struct io_ring_ctx *ctx = req->ctx;
 	int v;
 
-	if (unlikely(io_should_terminate_tw()))
+	if (unlikely(io_should_terminate_tw(ctx)))
 		return -ECANCELED;
 
 	do {
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -275,7 +275,7 @@ static void io_req_task_link_timeout(str
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!io_should_terminate_tw()) {
+		if (!io_should_terminate_tw(req->ctx)) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,


