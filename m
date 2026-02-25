Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0D251793;
	Wed, 25 Feb 2026 01:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982850; cv=none; b=R56n5w8PpjwNT/AHZw/rqkDPEIc2sgM5GvRnvzS/V+8+0bO2SnGCuWdp3agpHQxXoBcV2xflmnQhT3BtcsMX+o6ykPUzRJR7sjY2k3O6ayNL/S068AK2HJteye4SObZYkbqqtrlR58KXy4TtyWXVz4NOyEOAegYreRnWZgRwJ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982850; c=relaxed/simple;
	bh=fN2EVwtrXw4ugVrlDek8HRDTfa8bCghEQsavDHyUomE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmnvdjrtwprU8tzwRGIpswVNiGRbo9LCGZia/C2EhgdoFajT3rR1fSuQhkaaVu0i5ptkeL7ta6u1Ns0XIuEGNFgLt+M481vxZKwLpqJ6euLIQSz+O7trNvuki4j5YFC/ft4Gi+QOGY/ctnHMq4iDBX9+f2H7mtvDNtC7ii+KuXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeufP/Qg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeufP/Qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CA4C116D0;
	Wed, 25 Feb 2026 01:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982850;
	bh=fN2EVwtrXw4ugVrlDek8HRDTfa8bCghEQsavDHyUomE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeufP/QgPsUYteJoHbF8qMfle12BR1y79dWD92A+EiLpbyMFqgWG3Y834JwKhR244
	 m/wVTKwdXJQxw70m7kJSysazFx7iHTlm48w8RVxfwEGqum9dUoRwVSfNhP9WRI/3OO
	 TBjIsDKgIz15zggCz7tXXFDzqTJHmyOpPmaS0qJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 040/781] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Tue, 24 Feb 2026 17:12:29 -0800
Message-ID: <20260225012400.685313492@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index b7a077c11c21a..8aa671ba43474 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3256,7 +3256,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
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
index 7063ea7964e75..87b4d306cf1b6 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -125,7 +125,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
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
@@ -245,7 +249,11 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
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
index 3d3822ff3fd9e..12318c276068e 100644
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



