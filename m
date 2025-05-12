Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A2429ACC8;
	Mon, 12 May 2025 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073482; cv=none; b=LauDF8J2B8VvQdV5ro5G2/y/KeVvhj4cdye3DHTBBr+eFTUDXo6rd1y36Cns2By3HIIl4Z5Rhs5748EfS+i93gN6C5p1++4c7j0m44+0PRMOFgcXOurSinqRRp3EuVJhVIdZgCN6wUeWAoq/1B4cWrxBBIZEap49WlsMW/BCxjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073482; c=relaxed/simple;
	bh=7X4j6xXsegBWVevh+Epy+j6nuihd5KCB43xxXuEQq5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDEJVhntJNvo2zal5uIupdX3IZKyVtiHihc5CAnbO5htj0UOaPsDh61GP4alXKzXTAHITaL4uraaUk2IfkyClqmstvaxwpDE0WMNzF7NdrcIsESLG5ecZ2mMdgPSvjQZWN5y1twbFjGwn7n2GyrJNCZSDqaH8ceMpSDIDgPTVpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZOQg+IL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZOQg+IL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04278C4CEE7;
	Mon, 12 May 2025 18:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073482;
	bh=7X4j6xXsegBWVevh+Epy+j6nuihd5KCB43xxXuEQq5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZOQg+ILnqOLO43rxMXGhO0dNCnEzdsVOsdzqHnmYc3GVKqypHuDyGpX2XdguR4Ie
	 YNn8aKD3VPqMB5JmKHCJP7I2J7iDISTfTbEd9zT7Dlc2EFzRleVCeTxmuoI8WXTXmu
	 oBjBUYu/t4dxf8YLYjhUO+EByNJ0Mev7usp0W2Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chase Hiltz <chase@path.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 090/113] io_uring: always arm linked timeouts prior to issue
Date: Mon, 12 May 2025 19:46:19 +0200
Message-ID: <20250512172031.346485812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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
@@ -422,24 +422,6 @@ static struct io_kiocb *__io_prep_linked
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
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
@@ -493,7 +475,6 @@ static void io_prep_async_link(struct io
 
 static void io_queue_iowq(struct io_kiocb *req)
 {
-	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
 
 	BUG_ON(!tctx);
@@ -518,8 +499,6 @@ static void io_queue_iowq(struct io_kioc
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
-	if (link)
-		io_queue_linked_timeout(link);
 }
 
 static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
@@ -1863,17 +1842,24 @@ static bool io_assign_file(struct io_kio
 	return !!req->file;
 }
 
+#define REQ_ISSUE_SLOW_FLAGS	(REQ_F_CREDS | REQ_F_ARM_LTIMEOUT)
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
+	struct io_kiocb *link = NULL;
 	int ret;
 
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
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
@@ -1883,8 +1869,12 @@ static int io_issue_sqe(struct io_kiocb
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
@@ -1939,8 +1929,6 @@ void io_wq_submit_work(struct io_wq_work
 	else
 		req_ref_get(req);
 
-	io_arm_ltimeout(req);
-
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
 fail:
@@ -2036,15 +2024,11 @@ struct file *io_file_get_normal(struct i
 static void io_queue_async(struct io_kiocb *req, int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_kiocb *linked_timeout;
-
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
 		io_req_defer_failed(req, ret);
 		return;
 	}
 
-	linked_timeout = io_prep_linked_timeout(req);
-
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_kbuf_recycle(req, 0);
@@ -2057,9 +2041,6 @@ static void io_queue_async(struct io_kio
 	case IO_APOLL_OK:
 		break;
 	}
-
-	if (linked_timeout)
-		io_queue_linked_timeout(linked_timeout);
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)
@@ -2073,9 +2054,7 @@ static inline void io_queue_sqe(struct i
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (likely(!ret))
-		io_arm_ltimeout(req);
-	else
+	if (unlikely(ret))
 		io_queue_async(req, ret);
 }
 


