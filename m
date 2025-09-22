Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE162F2617;
	Mon, 22 Sep 2025 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569765; cv=none; b=tHFVkR/2tXPRno9S9mWjczGNuMGBZOQW/UnKKZFqN9cMq74FIQbCGSRVuXYUrm0i19wGE7mLMWFH5hm6SGt1//W9M1E/bfjvZ6C3EbDh07g29sRuIbdEp7tU/4acLrHeJXhM2RUneRkXV/BO43pEj346pvI54/kflpsORo4LfmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569765; c=relaxed/simple;
	bh=n2yZ5DQwrsW8CDwm2VjukjInu34dNBGLnKdypy1NgEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=no6calibV/elr5I3mc9s97nym+sQ4CAJHd1L4E2XPcdXfOggpfhYFQVlbkJC7WQbrOvYh+EUumQenwDnWhM/SO9nlVyqGodxpUS/2mN1d+a0r11MvQPoUqj05ZzSx3JZSG811jHe8ULxf4YOva1kxOnMDrpivAJ+F2owcSFF+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppAaZD2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppAaZD2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB473C4CEF0;
	Mon, 22 Sep 2025 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569765;
	bh=n2yZ5DQwrsW8CDwm2VjukjInu34dNBGLnKdypy1NgEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppAaZD2stuCyOtscVsHuI2+R07Olfr9ypUT4PdHxY59dbIVY9M8oJb8mKxJSXQnws
	 8fQy0IlsZwt/bu1SU168KYmFI5G8oT5ox9F6d//aOhq2Mbi8eyKOvACt3LOumZA+Pi
	 SOh1KbvP69Ioc6FdUAq6foT8PPUjTFcbxlRU46qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedek Thaler <thaler@thaler.hu>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 48/70] io_uring: include dying ring in task_work "should cancel" state
Date: Mon, 22 Sep 2025 21:29:48 +0200
Message-ID: <20250922192405.900266742@linuxfoundation.org>
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
 io_uring/io_uring.c |    6 ++++--
 io_uring/io_uring.h |    4 ++--
 io_uring/poll.c     |    2 +-
 io_uring/timeout.c  |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1459,8 +1459,10 @@ static void io_req_task_cancel(struct io
 
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	io_tw_lock(req->ctx, ts);
-	if (unlikely(io_should_terminate_tw()))
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_tw_lock(ctx, ts);
+	if (unlikely(io_should_terminate_tw(ctx)))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -402,9 +402,9 @@ static inline bool io_allowed_run_tw(str
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
@@ -258,7 +258,7 @@ static int io_poll_check_events(struct i
 {
 	int v;
 
-	if (unlikely(io_should_terminate_tw()))
+	if (unlikely(io_should_terminate_tw(req->ctx)))
 		return -ECANCELED;
 
 	do {
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -307,7 +307,7 @@ static void io_req_task_link_timeout(str
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!io_should_terminate_tw()) {
+		if (!io_should_terminate_tw(req->ctx)) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,


