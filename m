Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4EE359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302463; cv=none; b=bgpnJNLL+QNTQ4EE3TsOnU2vuQo/uOHxjxeJ7/O5Q5sZYKCcKvGlpxq/dYd/rHhZ8NOsoB1subFOPKIl9g/bXV8z6tXaG8nfmhAz+NXzVH6AUs5QoqCBBSHpIJj5R7EocNLehVajlZTThLGb52gbASP4Re5p3m5wWGSfIt8/WUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302463; c=relaxed/simple;
	bh=Xa/JTkF//SNWVXwY98SltLcHxRMGvoh4VCv/lLXLnPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/661yMvgjh8Uiv1vGJla2xNm5ZBQPn3iBPJAI9MyrSeQaBgsM4kKv5YNqzuuc+231NH3gIH1xjF+MymFPSaCojXG3drtlAbbCyUShZDmiqS94DLVK671ZTJLV2jgPtS97c3NLebtk7RalTBq9fqOR9MSXhzyC6WA7LVgdITNy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lD01WK5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lD01WK5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA97CC19423;
	Sat, 28 Feb 2026 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302463;
	bh=Xa/JTkF//SNWVXwY98SltLcHxRMGvoh4VCv/lLXLnPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD01WK5IGeuMVZJMwkuRP2LkU/Rgnvpk+HklIwZerzhNV6zpjlLwSW78XEP6jVy5Y
	 ZgvlnYOpcdASsfBMDYaNVQQnW2ZCuFb1PM12KGag9U6nDiupVS0Uj3BZOUG3jsleDb
	 waBJKKH2vZNT5ECCJ/1loJ9BCDB0cI1BkYztvPo/wSs4KXexRUiRdJA7JTfzbhSXBq
	 HpaDOdKUglFysuF3ew2Cv3G2xBZBBRnJxnF2Rm1DMbk5o21mVqUYX8V0gzptSxUpMj
	 YzRziaYiC6MWjPdRDGHiUMeBgerQkvd0IsAQkBQxoElmJkrfHeXiSAcPIZjb1iCgqr
	 qZ21nphZmci5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/232] io_uring/cancel: support opcode based lookup and cancelation
Date: Sat, 28 Feb 2026 13:10:59 -0500
Message-ID: <20260228181127.1592657-206-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit d7b8b079a8f6bc007d06d9ee468659dae6053e13 ]

Add IORING_ASYNC_CANCEL_OP flag for cancelation, which allows the
application to target cancelation based on the opcode of the original
request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22dbb0987bd1 ("io_uring/cancel: de-unionize file and user_data in struct io_cancel_data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/cancel.c             | 17 ++++++++++++++---
 io_uring/cancel.h             |  2 +-
 io_uring/poll.c               |  3 ++-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7adc7c4e9894b..aeed98cb5c1c8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -277,12 +277,14 @@ enum io_uring_op {
  * IORING_ASYNC_CANCEL_ANY	Match any request
  * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
  * IORING_ASYNC_CANCEL_USERDATA	Match on user_data, default for no other key
+ * IORING_ASYNC_CANCEL_OP	Match request based on opcode
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 #define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
 #define IORING_ASYNC_CANCEL_USERDATA	(1U << 4)
+#define IORING_ASYNC_CANCEL_OP	(1U << 5)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 577d2f85b3e5b..bfaf8f9f1defc 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -22,11 +22,12 @@ struct io_cancel {
 	u64				addr;
 	u32				flags;
 	s32				fd;
+	u8				opcode;
 };
 
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
 			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED | \
-			 IORING_ASYNC_CANCEL_USERDATA)
+			 IORING_ASYNC_CANCEL_USERDATA | IORING_ASYNC_CANCEL_OP)
 
 /*
  * Returns true if the request matches the criteria outlined by 'cd'.
@@ -38,7 +39,7 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (req->ctx != cd->ctx)
 		return false;
 
-	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD)))
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP)))
 		match_user_data = true;
 
 	if (cd->flags & IORING_ASYNC_CANCEL_ANY)
@@ -47,6 +48,10 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 		if (req->file != cd->file)
 			return false;
 	}
+	if (cd->flags & IORING_ASYNC_CANCEL_OP) {
+		if (req->opcode != cd->opcode)
+			return false;
+	}
 	if (match_user_data && req->cqe.user_data != cd->data)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
@@ -127,7 +132,7 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
-	if (sqe->off || sqe->len || sqe->splice_fd_in)
+	if (sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 
 	cancel->addr = READ_ONCE(sqe->addr);
@@ -139,6 +144,11 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 		cancel->fd = READ_ONCE(sqe->fd);
 	}
+	if (cancel->flags & IORING_ASYNC_CANCEL_OP) {
+		if (cancel->flags & IORING_ASYNC_CANCEL_ANY)
+			return -EINVAL;
+		cancel->opcode = READ_ONCE(sqe->len);
+	}
 
 	return 0;
 }
@@ -185,6 +195,7 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		.ctx	= req->ctx,
 		.data	= cancel->addr,
 		.flags	= cancel->flags,
+		.opcode	= cancel->opcode,
 		.seq	= atomic_inc_return(&req->ctx->cancel_seq),
 	};
 	struct io_uring_task *tctx = req->task->io_uring;
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 496ce4dac78ed..fc98622e6166e 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -8,11 +8,11 @@ struct io_cancel_data {
 		u64 data;
 		struct file *file;
 	};
+	u8 opcode;
 	u32 flags;
 	int seq;
 };
 
-
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index d4d107931f629..bac9e77d44b09 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -873,7 +873,8 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
+			 IORING_ASYNC_CANCEL_ANY))
 		req = io_poll_file_find(ctx, cd, table, &bucket);
 	else
 		req = io_poll_find(ctx, false, cd, table, &bucket);
-- 
2.51.0

