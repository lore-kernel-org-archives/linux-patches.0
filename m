Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4146254AF7;
	Mon, 12 May 2025 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072225; cv=none; b=ntvi07LH+XRQtiwCRnbcrAu3exqyWwh/hzdMQQKQVFX/Q7GQbJX3/nLFXjq06GKTUd5rdrH68bgZ8aqn9/LZ8d3nGB4Nug7Ry1eGA9x1FHEWcYsdj1CuVoCrvYxSBASMFz822aKoyRn2thW74d1iVI0lD1LW7uxKlDTFUJ9E2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072225; c=relaxed/simple;
	bh=SIwW6FvvwEHasXbLAXXCeeN2a81qD4o0v0tJ5Eot6o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCtSSimXaLQb59vihWM9ly3Qs674KjkrzGu7oIjY6vqrzZh5y0nCLJlc0mn5QewkoQVLm1DtpSONdgisYquaMd+j+RO990lts3kwuWZL+pCZBvqE1z8aZCg70WHTYJN0RZZCfvPRXXQ533urFPFYZNSdsd1sZAZKfRCN1s4e2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy1H9kfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy1H9kfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C85C4CEE7;
	Mon, 12 May 2025 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072225;
	bh=SIwW6FvvwEHasXbLAXXCeeN2a81qD4o0v0tJ5Eot6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy1H9kfs/ywxy4KjZBk2j3nY0csYS8RoCYL1Cl+CodNnhX/938oTVai+J+YFEErDU
	 +TztYX1C2kEAwgGfI4J2HE5sug2opof3t0evnOreibhiHaBhRnPKD4642b/CxoqSHu
	 wywT183yzU6IVgRZDb/5xezHwu8Pb3DuWdAx/MAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chase Hiltz <chase@path.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 174/197] io_uring: always arm linked timeouts prior to issue
Date: Mon, 12 May 2025 19:40:24 +0200
Message-ID: <20250512172051.473641408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/io_uring.c |   50 +++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -443,24 +443,6 @@ static struct io_kiocb *__io_prep_linked
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
@@ -513,7 +495,6 @@ static void io_prep_async_link(struct io
 
 static void io_queue_iowq(struct io_kiocb *req)
 {
-	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->tctx;
 
 	BUG_ON(!tctx);
@@ -538,8 +519,6 @@ static void io_queue_iowq(struct io_kioc
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
-	if (link)
-		io_queue_linked_timeout(link);
 }
 
 static void io_req_queue_iowq_tw(struct io_kiocb *req, struct io_tw_state *ts)
@@ -1728,17 +1707,24 @@ static bool io_assign_file(struct io_kio
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
@@ -1748,8 +1734,12 @@ static int io_issue_sqe(struct io_kiocb
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
@@ -1762,7 +1752,6 @@ static int io_issue_sqe(struct io_kiocb
 
 	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
 		ret = 0;
-		io_arm_ltimeout(req);
 
 		/* If the op doesn't have a file, we're not polling for it */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
@@ -1805,8 +1794,6 @@ void io_wq_submit_work(struct io_wq_work
 	else
 		req_ref_get(req);
 
-	io_arm_ltimeout(req);
-
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL) {
 fail:
@@ -1922,15 +1909,11 @@ struct file *io_file_get_normal(struct i
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
@@ -1943,9 +1926,6 @@ static void io_queue_async(struct io_kio
 	case IO_APOLL_OK:
 		break;
 	}
-
-	if (linked_timeout)
-		io_queue_linked_timeout(linked_timeout);
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)


