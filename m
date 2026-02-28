Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1210D373141;
	Sat, 28 Feb 2026 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301516; cv=none; b=fgRVURTUtT3J3FNrrOVHJ+bWGYrKmFLDw3Skxa38Ov6q9IYQRDrX1rQ74Kk5MSi8CyKVo8cDDJ/4ZKwfSOpb0NVeMx7033Y8e7khKTy7oOJTGsfkyizW75gNNj773j6MTLBOvCmpP48rdjI2GbnD8ijjGNQPrzZ87Cq3o5JurxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301516; c=relaxed/simple;
	bh=b42WEZw7ILAb0uLleni0IDk7v/nd9K5I8bG6AzqTbbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRtiZcM1ASdi0Oj5DpBS5EJ5dHmyjVqjr++iriZPwCQwu8slTQncvQ8sB75NSUGqYPMuuUgrf8ngnPRM2xNYWBNIch6+767n/DB4e8AF8WLS5dVzDjEn1rtr8CAkI2Sa4+CZRTc0gXOb96KX56B0d//O3Ggb6BdfWgWNELyR1GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgWPb+tY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgWPb+tY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708CFC19423;
	Sat, 28 Feb 2026 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301516;
	bh=b42WEZw7ILAb0uLleni0IDk7v/nd9K5I8bG6AzqTbbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgWPb+tYTVWKume/gokxsWf9WMfsZnOWJneDXgGaBU6HFjsE5mcpOCGyDkkjlqto2
	 osXe7wRfFh1iXBRvI2i6UMXdo/0FQvv46NX0f3ReADunRtSI7UOvbARGSDnzr8Rx/o
	 5Hu9pFy0NimNNIeLY9nZcOIqTCQD4XKDHp/IUhbr7VPWMR4vAqGDw288scmEENU8ie
	 tTL4dnym/VS0iwo3bBZ9bEg28MlUsSIRRL5iewhyflcGzWozEYc57VmGs0asdKXHWg
	 nTnHOxYOvaahlDVHgyFJOACMJS86/wCuPyWRPH2K7gziInMABgm8rUwd7l1PVuLw9v
	 45bM42dLlZp+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 702/752] io_uring/openclose: fix io_pipe_fixed() slot tracking for specific slots
Date: Sat, 28 Feb 2026 12:46:53 -0500
Message-ID: <20260228174750.1542406-702-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
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

[ Upstream commit f4d0668b38d8784f33a9a36c72ed5d0078247538 ]

__io_fixed_fd_install() returns 0 on success for non-alloc mode
(specific slot), not the slot index. io_pipe_fixed() used this return
value directly as the slot index in fds[], which can cause the reported
values returned via copy_to_user() to be incorrect, or the error path
operating on the incorrect direct descriptor.

Fix by computing the actual 0-based slot index (slot - 1) for specific
slot mode, while preserving the existing behavior for auto-alloc mode
where __io_fixed_fd_install() already returns the allocated index.

Cc: stable@vger.kernel.org
Fixes: 53db8a71ecb4 ("io_uring: add support for IORING_OP_PIPE")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/openclose.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 15dde9bd6ff67..606ce0664e6a4 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -336,31 +336,34 @@ static int io_pipe_fixed(struct io_kiocb *req, struct file **files,
 {
 	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
 	struct io_ring_ctx *ctx = req->ctx;
+	bool alloc_slot;
 	int ret, fds[2] = { -1, -1 };
 	int slot = p->file_slot;
 
 	if (p->flags & O_CLOEXEC)
 		return -EINVAL;
 
+	alloc_slot = slot == IORING_FILE_INDEX_ALLOC;
+
 	io_ring_submit_lock(ctx, issue_flags);
 
 	ret = __io_fixed_fd_install(ctx, files[0], slot);
 	if (ret < 0)
 		goto err;
-	fds[0] = ret;
+	fds[0] = alloc_slot ? ret : slot - 1;
 	files[0] = NULL;
 
 	/*
 	 * If a specific slot is given, next one will be used for
 	 * the write side.
 	 */
-	if (slot != IORING_FILE_INDEX_ALLOC)
+	if (!alloc_slot)
 		slot++;
 
 	ret = __io_fixed_fd_install(ctx, files[1], slot);
 	if (ret < 0)
 		goto err;
-	fds[1] = ret;
+	fds[1] = alloc_slot ? ret : slot - 1;
 	files[1] = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
-- 
2.51.0

