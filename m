Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A652F255222;
	Mon, 12 May 2025 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072526; cv=none; b=kJcycP9onjXJl1BYzXFLmccLuju3M0R4QyFimKI3/12d89Qxak32/qUzFSwf3ytajb1X2d0Q/z/fUOk1xTjhLwNdoIFD6d/w//PzhNclqku9ie2R39YfPU8lf7XP0Ui4EZEAyl9+KaftskFZl9w356eA/mnJhfR1mYY5XjlaWjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072526; c=relaxed/simple;
	bh=ZSbKmDL/ppzqrFniEv8hIYE1beD0WHPiaV5Fy14Kc/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2M+rmd5Q6l5t4BSVUmruSCSQehA21N83MEAaUfLvkH4tcUesbWKlm0UKnXOqIvlWSuEdC7mehLjPhUr+fzOWioVjFtg1Bp9I3+JEXx47i9F0PMNtrlDSuPWnPmwM8+FOCQSgwtapure1C/e/njXQKdhi2Hu6yycaFnRbZvZMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xt7lbq+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xt7lbq+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E2DC4CEE9;
	Mon, 12 May 2025 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072526;
	bh=ZSbKmDL/ppzqrFniEv8hIYE1beD0WHPiaV5Fy14Kc/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xt7lbq+mQBF6dmiVdY7kPbm9eQ2nddNGApDV9kSFa7HaDx8jQyAE82qTm4pTZRKTK
	 PKejnM54lsk41AFOVJweXnJTPjoJ2M9mgFRB85L+DBLAPOMysvhAaEGph5iOVV8f5i
	 EXzDMsBSXh5t8rCsQF09VXDofri5P6EgrG7K+XkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chase Hiltz <chase@path.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 69/92] io_uring: always arm linked timeouts prior to issue
Date: Mon, 12 May 2025 19:45:44 +0200
Message-ID: <20250512172025.936349590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

Commit b53e523261bf058ea4a518b482222e7a277b186b upstream.

There are a few spots where linked timeouts are armed, and not all of
them adhere to the pre-arm, attempt issue, post-arm pattern. This can
be problematic if the linked request returns that it will trigger a
callback later, and does so before the linked timeout is fully armed.

Consolidate all the linked timeout handling into __io_issue_sqe(),
rather than have it spread throughout the various issue entry points.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/1390
Reported-by: Chase Hiltz <chase@path.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   53 +++++++++++++++-------------------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -372,24 +372,6 @@ static struct io_kiocb *__io_prep_linked
 	return req->link;
 }
 
-static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & REQ_F_ARM_LTIMEOUT)))
-		return NULL;
-	return __io_prep_linked_timeout(req);
-}
-
-static noinline void __io_arm_ltimeout(struct io_kiocb *req)
-{
-	io_queue_linked_timeout(__io_prep_linked_timeout(req));
-}
-
-static inline void io_arm_ltimeout(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_ARM_LTIMEOUT))
-		__io_arm_ltimeout(req);
-}
-
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -437,7 +419,6 @@ static void io_prep_async_link(struct io
 
 static void io_queue_iowq(struct io_kiocb *req)
 {
-	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
 
 	BUG_ON(!tctx);
@@ -462,8 +443,6 @@ static void io_queue_iowq(struct io_kioc
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
-	if (link)
-		io_queue_linked_timeout(link);
 }
 
 static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
@@ -1741,17 +1720,24 @@ static bool io_assign_file(struct io_kio
 	return !!req->file;
 }
 
+#define REQ_ISSUE_SLOW_FLAGS	(REQ_F_CREDS | REQ_F_ARM_LTIMEOUT)
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	const struct cred *creds = NULL;
+	struct io_kiocb *link = NULL;
 	int ret;
 
 	if (unlikely(!io_assign_file(req, issue_flags)))
 		return -EBADF;
 
-	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
-		creds = override_creds(req->creds);
+	if (unlikely(req->flags & REQ_ISSUE_SLOW_FLAGS)) {
+		if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
+			creds = override_creds(req->creds);
+		if (req->flags & REQ_F_ARM_LTIMEOUT)
+			link = __io_prep_linked_timeout(req);
+	}
 
 	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
@@ -1761,8 +1747,12 @@ static int io_issue_sqe(struct io_kiocb
 	if (!def->audit_skip)
 		audit_uring_exit(!ret, ret);
 
-	if (creds)
-		revert_creds(creds);
+	if (unlikely(creds || link)) {
+		if (creds)
+			revert_creds(creds);
+		if (link)
+			io_queue_linked_timeout(link);
+	}
 
 	if (ret == IOU_OK) {
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
@@ -1809,8 +1799,6 @@ void io_wq_submit_work(struct io_wq_work
 	else
 		req_ref_get(req);
 
-	io_arm_ltimeout(req);
-
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
 fail:
@@ -1908,15 +1896,11 @@ struct file *io_file_get_normal(struct i
 static void io_queue_async(struct io_kiocb *req, int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_kiocb *linked_timeout;
-
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
 		io_req_complete_failed(req, ret);
 		return;
 	}
 
-	linked_timeout = io_prep_linked_timeout(req);
-
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_kbuf_recycle(req, 0);
@@ -1929,9 +1913,6 @@ static void io_queue_async(struct io_kio
 	case IO_APOLL_OK:
 		break;
 	}
-
-	if (linked_timeout)
-		io_queue_linked_timeout(linked_timeout);
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)
@@ -1945,9 +1926,7 @@ static inline void io_queue_sqe(struct i
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (likely(!ret))
-		io_arm_ltimeout(req);
-	else
+	if (unlikely(ret))
 		io_queue_async(req, ret);
 }
 


