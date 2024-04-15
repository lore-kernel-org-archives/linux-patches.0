Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB48278C67;
	Mon, 15 Apr 2024 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191322; cv=none; b=QBJRqJ7C0m959qVzs8iERVUPMuH8DFJbnVbgoTBvOARKF5ozt4SgI8cg4rRK3A7zbDT1mmr1YuKPJM7Q76Ia/JUdk3k+7GQS0ElXjcWmx/VYnxTSCJGG5sR2nurUqsokdUJuSIdgurRaGfKTxls1APR9hsbbWQ/xqpLLsdbbX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191322; c=relaxed/simple;
	bh=O8CtBAbhdoavKLJ9NWUT6GT2ysazKQLqu6VrwRFfHXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hzo3lAumSZ5kvvxD5QxR3aQ2DTCb0PerQTi+uDK7jDvRzFTXBUuJwwifAQ008pLpcravwA+UPl2UcUettHqMWfLzAZkpxnx8CZlNa4FxP1QWwTYHZP0CQSIHpjY4ri+EiBtc6117HmNTTfcG1BD/+x2if3idGyCcdRkFbQjsWOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUKDaWYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUKDaWYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D59C2BD10;
	Mon, 15 Apr 2024 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191321;
	bh=O8CtBAbhdoavKLJ9NWUT6GT2ysazKQLqu6VrwRFfHXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUKDaWYa2bCrelpeAsTgtSPEDjwKamyctgtyi6bhrs9kdhz738SuKdDDrs80ho2L6
	 1Q4di+GAEKqrTiDmIekOsZe5kYfp7dFLH0GJvp8ftK3mQOHPL3wbfobQ/uAEbe8u26
	 HrRSUjf8GrcmaZdcp4RICoTiUafaz/Soub0ZFfyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.8 106/172] io_uring: refactor DEFER_TASKRUN multishot checks
Date: Mon, 15 Apr 2024 16:20:05 +0200
Message-ID: <20240415142003.612376810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit e0e4ab52d17096d96c21a6805ccd424b283c3c6d upstream.

We disallow DEFER_TASKRUN multishots from running by io-wq, which is
checked by individual opcodes in the issue path. We can consolidate all
it in io_wq_submit_work() at the same time moving the checks out of the
hot path.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e492f0f11588bb5aa11d7d24e6f53b7c7628afdb.1709905727.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   20 ++++++++++++++++++++
 io_uring/net.c      |   21 ---------------------
 io_uring/rw.c       |    2 --
 3 files changed, 20 insertions(+), 23 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -949,6 +949,8 @@ bool io_fill_cqe_req_aux(struct io_kiocb
 	u64 user_data = req->cqe.user_data;
 	struct io_uring_cqe *cqe;
 
+	lockdep_assert(!io_wq_current_is_worker());
+
 	if (!defer)
 		return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
 
@@ -1950,6 +1952,24 @@ fail:
 		goto fail;
 	}
 
+	/*
+	 * If DEFER_TASKRUN is set, it's only allowed to post CQEs from the
+	 * submitter task context. Final request completions are handed to the
+	 * right context, however this is not the case of auxiliary CQEs,
+	 * which is the main mean of operation for multishot requests.
+	 * Don't allow any multishot execution from io-wq. It's more restrictive
+	 * than necessary and also cleaner.
+	 */
+	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+		err = -EBADFD;
+		if (!file_can_poll(req->file))
+			goto fail;
+		err = -ECANCELED;
+		if (io_arm_poll_handler(req, issue_flags) != IO_APOLL_OK)
+			goto fail;
+		return;
+	}
+
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
 
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -78,19 +78,6 @@ struct io_sr_msg {
  */
 #define MULTISHOT_MAX_RETRY	32
 
-static inline bool io_check_multishot(struct io_kiocb *req,
-				      unsigned int issue_flags)
-{
-	/*
-	 * When ->locked_cq is set we only allow to post CQEs from the original
-	 * task context. Usual request completions will be handled in other
-	 * generic paths but multipoll may decide to post extra cqes.
-	 */
-	return !(issue_flags & IO_URING_F_IOWQ) ||
-		!(req->flags & REQ_F_APOLL_MULTISHOT) ||
-		!req->ctx->task_complete;
-}
-
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -837,9 +824,6 @@ int io_recvmsg(struct io_kiocb *req, uns
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
-	if (!io_check_multishot(req, issue_flags))
-		return io_setup_async_msg(req, kmsg, issue_flags);
-
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -935,9 +919,6 @@ int io_recv(struct io_kiocb *req, unsign
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
-	if (!io_check_multishot(req, issue_flags))
-		return -EAGAIN;
-
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1386,8 +1367,6 @@ int io_accept(struct io_kiocb *req, unsi
 	struct file *file;
 	int ret, fd;
 
-	if (!io_check_multishot(req, issue_flags))
-		return -EAGAIN;
 retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -932,8 +932,6 @@ int io_read_mshot(struct io_kiocb *req,
 	 */
 	if (!file_can_poll(req->file))
 		return -EBADFD;
-	if (issue_flags & IO_URING_F_IOWQ)
-		return -EAGAIN;
 
 	ret = __io_read(req, issue_flags);
 


