Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729619FA93;
	Wed, 25 Feb 2026 01:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983744; cv=none; b=ECY6ZbFuuj+O/lbEg7wUMJU2sQSgKrwx9iNDfWGNAsgbp3VLfxEt8o5pLB/B/i5B5XWMzZrksfajx0m5qa1f4Nu+80267UkkHDbgalXd/Z+IdZQQt3CXGtaXjTNQw9FK9EtyIl4aAFrX5QgCdD6mbymp49DBrZXKYDkfHJ6GhVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983744; c=relaxed/simple;
	bh=PtZbwm77/yUuVOgdgM2mJwVC7pcmgKbOwsgM+SL2X/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWcJAFpAckTKW/QNGUOUrmFMjFnVoW11CgYHSI4cZd8PfURd758vs1h9yzyNJLLjhF/uwfqYWnMXBvQRP1iQYVg7+1jg1TtKQDiaOMaSmlj5rlCRlDGUAjA8fYF7/+NmzEtleevPGgQwTm4nPzFTIQTlDlbIQzj3UP/UJUu2j18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl3bAjo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl3bAjo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D876C116D0;
	Wed, 25 Feb 2026 01:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983744;
	bh=PtZbwm77/yUuVOgdgM2mJwVC7pcmgKbOwsgM+SL2X/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vl3bAjo+fah5wz5V5tqq8OdWp2AqhN83V16l1AfPtQeZrT0ntWK2EOAO+nVHNuILc
	 zS0UICBff9oKAHSBphmo3RYIJ3Q6XJ1caJS5a02pC4TRJerccPmQtzSJvPc78096JC
	 Ry3cVZ3zG7dS/IVink+nGBNTjpGKMl91VJ1S3UKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/641] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Tue, 24 Feb 2026 17:16:03 -0800
Message-ID: <20260225012349.901111466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 104192bcc8e4b..d8a35a49dd1ac 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3490,7 +3490,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
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
index 5e5b94236d720..bce74a8b64c6e 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -124,7 +124,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
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
@@ -244,7 +248,11 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
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
 	if (!msg->src_file) {
 		int ret = io_msg_grab_file(req, issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index d189b266b8cce..db53e664348d7 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -193,7 +193,8 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
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



