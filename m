Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B14F7980;
	Tue, 13 Oct 2026 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893957; cv=none; b=lwIQqEe4ozTVexMnLBQTw6jnknFaNC5xFPYCigp4SBZu6+c4BkHAhKEKsFKx76VQj5lTdszhmypGKt74FxFkK01dzMvQEiYEK/Nt9THkGXqZ1e25TN6lGUtdPMmQKN8oBFgfxqs5B4xmLYxWqK+YZTKbnRtyVyPs2zISgxDBxn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893957; c=relaxed/simple;
	bh=cATCH/NFjsMAHxiirpkvRL/jtnu4dDNKl46p+EhLOl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZtFmcjxpvLM9r6aedqV7IYHwmAr2cGbsGyBq8QwuwnB2h7yrCJO4Vyy1DTVVksgfIYco8lVSUYjyJrzn8bT/HserN05iwO+p2vpUJALOc/OmTlAshFoTfKzsxMk88Q+aPzyJ8WsBdvtlE79KEjhKhGHNdrUnjuoCtc0HnQvEWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZnXt9v8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZnXt9v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3531F000FF;
	Tue, 13 Oct 2026 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893956;
	bh=hD7xiyeu258JFKT6aEDU7TxElUU72yHTBJ6/B2Z4NKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZnXt9v8Gj6uQ1VgCb6cf0T6VBHE7+JW29enkcLtRtXFMI7PgmYF/DLcrdt7w4Pmj
	 2NMDByf8rtEZ7C5tc46TTVZ5Xsz6u7fdFjjMrPuP87E9TsModr75viMl0xMM+1xjop
	 A//COGcnJTOA3YwSBrdqfnEPX0KSyEr4/VQFUCew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 400/621] fuse: Fix the condition to enable over-io-uring
Date: Tue, 13 Oct 2026 13:36:35 +0200
Message-ID: <20261013112930.334158166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Bernd Schubert <bernd@bsbernd.com>

[ Upstream commit 1f59015e958174e89be58cc8db16d70a60d17255 ]

The existing condition in fuse_uring_cmd() is there only to avoid
disabling io-uring for connections that already run with it, missing
was a condition to refuse any IORING_OP_URING_CMD if the
connection/channel didn't get enabled because of missing FUSE_INIT
reply flag FUSE_OVER_IO_URING. Without the reply flag the barrier in
fuse_uring_ready() doesn't work and IO could already be going on and
cause deadlock states (at a minimum one between fch->bg_lock and
queue->lock).

The change itself is trivial, but brings behavior change,
FUSE_OVER_IO_URING has to be set in the FUSE_INIT_REPLY by fuse servers
to accept any IORING_OP_URING_CMD. Libfuse does that and the only
non-libfuse implementation I found (fractal-fuse) also does it.
Qemu patches for fuse-io-uring are not merged yet, as far as I know.

Moved up is the smp_load_acquire(&fch->initialized) check, as a
fuse-server implementation might try to setup io-uring before FUSE_INIT
is processed and might have gotten -EOPNOTSUPP instead of -EAGAIN.

Also fixed is a stale comment that explains the handling of the
FUSE_OVER_IO_URING flag in early RFC versions.

If there should be a report from any library or application we
probably need to revert this commit.

Fixes: 3393ff964e0f ("fuse: block request allocation until io-uring init is complete")
Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev_uring.c | 30 +++++++++++++++++++-----------
 fs/fuse/inode.c     |  4 ----
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 9b57544935b50..b52d5c2bd4e42 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1253,23 +1253,31 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	}
 	fc = fud->fc;
 
-	/* Once a connection has io-uring enabled on it, it can't be disabled */
-	if (!enable_uring && !fc->io_uring) {
-		pr_info_ratelimited("fuse-io-uring is disabled\n");
-		return -EOPNOTSUPP;
-	}
+	/*
+	 * The ring is sized from values negotiated by FUSE_INIT
+	 */
+	if (!fc->initialized)
+		return -EAGAIN;
+
+	/* Pairs with smp_wmb() in fuse_set_initialized() */
+	smp_rmb();
 
 	if (fc->aborted)
 		return -ECONNABORTED;
 	if (!fc->connected)
 		return -ENOTCONN;
 
-	/*
-	 * fuse_uring_register() needs the ring to be initialized,
-	 * we need to know the max payload size
-	 */
-	if (!fc->initialized)
-		return -EAGAIN;
+	/* Once a connection has io-uring enabled on it, it can't be disabled */
+	if (!enable_uring && !fc->io_uring) {
+		pr_info_ratelimited("fuse-io-uring is disabled by module parameter\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (cmd_op == FUSE_IO_URING_CMD_REGISTER && !fc->io_uring) {
+		pr_info_ratelimited(
+			"fuse-io-uring not enabled on this connection\n");
+		return -EOPNOTSUPP;
+	}
 
 	switch (cmd_op) {
 	case FUSE_IO_URING_CMD_REGISTER:
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index a0a64dfffb759..091a375c32a8d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1517,10 +1517,6 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
 
-	/*
-	 * This is just an information flag for fuse server. No need to check
-	 * the reply - server is either sending IORING_OP_URING_CMD or not.
-	 */
 	if (fuse_uring_enabled())
 		flags |= FUSE_OVER_IO_URING;
 
-- 
2.53.0



