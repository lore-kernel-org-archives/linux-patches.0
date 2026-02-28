Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F4A37702D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301636; cv=none; b=afK7ocwhXQljupOhQybt+0Q3TYwpq7C4stv2OAr07gP8Y9EfsXY42p6l63J3jAlcSt+8SPGehim0+dP+QaL/zuEeDKhF1PGSrGjlcu+L6NSc2Qbsrd6mRPtzp1R1Vub0BuJWkHsA+4aiJu/XegrK1rNwJgAY21IRlYB5Q2Y44hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301636; c=relaxed/simple;
	bh=J3wOG7BdzRPS7rWl9OpunoxgqyF5H4YM1Nn8lQ+XdJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmbH5MkQpzLE/yfJFK2bOJ2pItJrSPnBnG1vJ+H/fKfKNb9ASvqOeCsr3GwKSFFX3H6Mc12JyM6qKzHvIFkMjRogQ2K5TPzY+ryIqYbvnyz4Uwe1RaYzTHcsKgIYlZX5MYs0I/1FCcqHdO4+paGRZ/7JqrOZw4g2PdvF0rE4/N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p55CaJhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p55CaJhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5CFC19425;
	Sat, 28 Feb 2026 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301635;
	bh=J3wOG7BdzRPS7rWl9OpunoxgqyF5H4YM1Nn8lQ+XdJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p55CaJhc8xMUSp+i1GbHjQlek/KNAAChkgZ4DqdcpcyIxPUeIGvIh2fqGLc1XHVDI
	 tGL1mW5ggo9azbcb9P9sC79ksdgW6kFK0XaE7L19/aW+zcnH/H8gjHayzogZPdvol5
	 H9g8lVRLa7eT2nJ1tedYiEz5IORL9zPe/bZKfGr5QCFkfbAKqYGwtzwK/pDeU95cai
	 eFvre5gf7co0F1CqYw+2j8S0Xbq5C2RXAF7DySrD6+2cyowYKC4tCmvLrwpjI/2gSu
	 2xqlFkd+c5aWiF3ctmzKGPH3Pqq2lNB/q71inIUc8jodNyFhxkaRuAgV5UrDnpwn7P
	 s52B3tus+Qqcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/385] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Sat, 28 Feb 2026 12:54:10 -0500
Message-ID: <20260228180011.1568201-28-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 7a8737e1132ff07ca225aa7a4008f87319b5b1ca ]

io_uring_enter(), __io_msg_ring_data(), and io_msg_send_fd() read
ctx->flags and ctx->submitter_task without holding the ctx's uring_lock.
This means they may race with the assignment to ctx->submitter_task and
the clearing of IORING_SETUP_R_DISABLED from ctx->flags in
io_register_enable_rings(). Ensure the correct ordering of the
ctx->flags and ctx->submitter_task memory accesses by storing to
ctx->flags using release ordering and loading it using acquire ordering.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 4add705e4eeb ("io_uring: remove io_register_submitter")
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c |  6 +++++-
 io_uring/msg_ring.c | 12 ++++++++++--
 io_uring/register.c |  3 ++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 99b0b1ba0fe22..5c60442e67028 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3312,7 +3312,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 	ctx = file->private_data;
 	ret = -EBADFD;
-	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
+	/*
+	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
+	 * in io_uring_add_tctx_node() -> __io_uring_add_tctx_node_from_submit()
+	 */
+	if (unlikely(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED))
 		goto out;
 
 	/*
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 97708e5132bc4..3cf59d8c58073 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -126,7 +126,11 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 		return -EINVAL;
 	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	/*
+	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
+	 * in io_msg_data_remote() -> io_msg_remote_post()
+	 */
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
@@ -237,7 +241,11 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	/*
+	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
+	 * in io_msg_fd_remote()
+	 */
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 	if (!src_file) {
 		src_file = io_msg_grab_file(req, issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index a325b493ae121..f700ddf1f1d1f 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -190,7 +190,8 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	/* Keep submitter_task store before clearing IORING_SETUP_R_DISABLED */
+	smp_store_release(&ctx->flags, ctx->flags & ~IORING_SETUP_R_DISABLED);
 	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	return 0;
-- 
2.51.0

