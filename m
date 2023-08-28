Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E981D469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2D6C433C8;
	Mon, 28 Aug 2023 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218711;
	bh=hd6HN3+3jH1gS5f6JYVeehtMt1rC4aDp03uw62iC/50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHt9YMaSZTFWH+MR0rV7EiSh3fHC2ED4AuSiOvz71s6DrBojsoD81LXp7UFiBrH2Z
	 PVAoEuy2zqLg2mC8Wo1aRAExrljA9UnyRlt74lruF/uO1PxR6rWdOjHYqPJ65AsSfx
	 5RvB1PX2xTZrfQm9OYgpV/kJ7jt1z7ruEmA22UFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 057/122] io_uring: get rid of double locking
Date: Mon, 28 Aug 2023 12:12:52 +0200
Message-ID: <20230828101158.322755368@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 11373026f2960390d5e330df4e92735c4265c440 upstream.

We don't need to take both uring_locks at once, msg_ring can be split in
two parts, first getting a file from the filetable of the first ring and
then installing it into the second one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a80ecc2bc99c3b3f2cf20015d618b7c51419a797.1670384893.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |   85 +++++++++++++++++++++++++++++-----------------------
 io_uring/msg_ring.h |    1 
 io_uring/opdef.c    |    1 
 3 files changed, 51 insertions(+), 36 deletions(-)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -15,6 +15,7 @@
 
 struct io_msg {
 	struct file			*file;
+	struct file			*src_file;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
@@ -23,6 +24,17 @@ struct io_msg {
 	u32 flags;
 };
 
+void io_msg_ring_cleanup(struct io_kiocb *req)
+{
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	if (WARN_ON_ONCE(!msg->src_file))
+		return;
+
+	fput(msg->src_file);
+	msg->src_file = NULL;
+}
+
 static int io_msg_ring_data(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -39,17 +51,13 @@ static int io_msg_ring_data(struct io_ki
 	return -EOVERFLOW;
 }
 
-static void io_double_unlock_ctx(struct io_ring_ctx *ctx,
-				 struct io_ring_ctx *octx,
+static void io_double_unlock_ctx(struct io_ring_ctx *octx,
 				 unsigned int issue_flags)
 {
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_unlock(&ctx->uring_lock);
 	mutex_unlock(&octx->uring_lock);
 }
 
-static int io_double_lock_ctx(struct io_ring_ctx *ctx,
-			      struct io_ring_ctx *octx,
+static int io_double_lock_ctx(struct io_ring_ctx *octx,
 			      unsigned int issue_flags)
 {
 	/*
@@ -62,17 +70,28 @@ static int io_double_lock_ctx(struct io_
 			return -EAGAIN;
 		return 0;
 	}
+	mutex_lock(&octx->uring_lock);
+	return 0;
+}
 
-	/* Always grab smallest value ctx first. We know ctx != octx. */
-	if (ctx < octx) {
-		mutex_lock(&ctx->uring_lock);
-		mutex_lock(&octx->uring_lock);
-	} else {
-		mutex_lock(&octx->uring_lock);
-		mutex_lock(&ctx->uring_lock);
-	}
+static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = NULL;
+	unsigned long file_ptr;
+	int idx = msg->src_fd;
 
-	return 0;
+	io_ring_submit_lock(ctx, issue_flags);
+	if (likely(idx < ctx->nr_user_files)) {
+		idx = array_index_nospec(idx, ctx->nr_user_files);
+		file_ptr = io_fixed_file_slot(&ctx->file_table, idx)->file_ptr;
+		file = (struct file *) (file_ptr & FFS_MASK);
+		if (file)
+			get_file(file);
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+	return file;
 }
 
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
@@ -80,8 +99,7 @@ static int io_msg_send_fd(struct io_kioc
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long file_ptr;
-	struct file *src_file;
+	struct file *src_file = msg->src_file;
 	int ret;
 
 	if (msg->len)
@@ -90,28 +108,22 @@ static int io_msg_send_fd(struct io_kioc
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
+	if (!src_file) {
+		src_file = io_msg_grab_file(req, issue_flags);
+		if (!src_file)
+			return -EBADF;
+		msg->src_file = src_file;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
 
-	ret = io_double_lock_ctx(ctx, target_ctx, issue_flags);
-	if (unlikely(ret))
-		return ret;
-
-	ret = -EBADF;
-	if (unlikely(msg->src_fd >= ctx->nr_user_files))
-		goto out_unlock;
-
-	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
-	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
-	if (!file_ptr)
-		goto out_unlock;
-
-	src_file = (struct file *) (file_ptr & FFS_MASK);
-	get_file(src_file);
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
 
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
-	if (ret < 0) {
-		fput(src_file);
+	if (ret < 0)
 		goto out_unlock;
-	}
+	msg->src_file = NULL;
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
 		goto out_unlock;
@@ -125,7 +137,7 @@ static int io_msg_send_fd(struct io_kioc
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0, true))
 		ret = -EOVERFLOW;
 out_unlock:
-	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
+	io_double_unlock_ctx(target_ctx, issue_flags);
 	return ret;
 }
 
@@ -136,6 +148,7 @@ int io_msg_ring_prep(struct io_kiocb *re
 	if (unlikely(sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
+	msg->src_file = NULL;
 	msg->user_data = READ_ONCE(sqe->off);
 	msg->len = READ_ONCE(sqe->len);
 	msg->cmd = READ_ONCE(sqe->addr);
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -2,3 +2,4 @@
 
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
+void io_msg_ring_cleanup(struct io_kiocb *req);
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -445,6 +445,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "MSG_RING",
 		.prep			= io_msg_ring_prep,
 		.issue			= io_msg_ring,
+		.cleanup		= io_msg_ring_cleanup,
 	},
 	[IORING_OP_FSETXATTR] = {
 		.needs_file = 1,


