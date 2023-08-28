Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7934469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375C5C433C7;
	Mon, 28 Aug 2023 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218714;
	bh=MDzATaLmlsIkIZmLEuRWsWapcq4CCTMS9h49S8LHGVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeumuYvYS+My37/DhpX8MGpeIvvFoJVRhwCXvf4EiNHdg0MRhpe6I50r8uiXLk7S0
	 JTL3zieem9yGwcdLLV+EekNe4fUhaNHjyw79g0dKW4xe9JRHtGDkuwzChjybiRNjfH
	 s2WOawBM3cZnv/j/SxQq7GFkVnsPX8x0cAqrpN1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 058/122] io_uring: extract a io_msg_install_complete helper
Date: Mon, 28 Aug 2023 12:12:53 +0200
Message-ID: <20230828101158.361876129@linuxfoundation.org>
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

Commit 172113101641cf1f9628c528ec790cb809f2b704 upstream.

Extract a helper called io_msg_install_complete() from io_msg_send_fd(),
will be used later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1500ca1054cc4286a3ee1c60aacead57fcdfa02a.1670384893.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -94,40 +94,25 @@ static struct file *io_msg_grab_file(str
 	return file;
 }
 
-static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
+static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct io_ring_ctx *ctx = req->ctx;
 	struct file *src_file = msg->src_file;
 	int ret;
 
-	if (msg->len)
-		return -EINVAL;
-	if (target_ctx == ctx)
-		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
-		return -EBADFD;
-	if (!src_file) {
-		src_file = io_msg_grab_file(req, issue_flags);
-		if (!src_file)
-			return -EBADF;
-		msg->src_file = src_file;
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-
 	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
 		return -EAGAIN;
 
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
 	if (ret < 0)
 		goto out_unlock;
+
 	msg->src_file = NULL;
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
 		goto out_unlock;
-
 	/*
 	 * If this fails, the target still received the file descriptor but
 	 * wasn't notified of the fact. This means that if this request
@@ -141,6 +126,25 @@ out_unlock:
 	return ret;
 }
 
+static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *src_file = msg->src_file;
+
+	if (target_ctx == ctx)
+		return -EINVAL;
+	if (!src_file) {
+		src_file = io_msg_grab_file(req, issue_flags);
+		if (!src_file)
+			return -EBADF;
+		msg->src_file = src_file;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	return io_msg_install_complete(req, issue_flags);
+}
+
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);


