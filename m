Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F9C37C118;
	Sat, 12 Sep 2026 09:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204917; cv=none; b=d0RnDsAxMdAZDHwYt4Shf1WpSb31pfuCrxSHbQO2rFedZxeIyET/rUwNB8Q4fs2lFI2ZZbVzaDNg/K69r9H+QPOMWOY7DjcLUpvRwG1l3MGggqZo91y+YWPAjAvXecuOYt49kf/eomawCVZQC5pcMjY2Q7CSpr/0C/uaXXEOoyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204917; c=relaxed/simple;
	bh=ryQTHC9jMMnVvJnr9w1/sNtGHfgLH2RUcW/jEvimQj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni8bbbILlYWGotyHeXC2F4EUtm8br1JS/AnWoWKgxZgWdOd3AV/x9Pt8Lvg5+hOINEfff6/TR26Rgienb9WuzWK4rim34oIhatR3vO/B7cbH1aa0gTIQfWB4ydUeon+8IzxSeqeOlHxtVVTHoK6zINSqL9cKuMFDQ9GZNjhbaIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBahVVrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBahVVrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CF51F000FF;
	Sat, 12 Sep 2026 09:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204915;
	bh=LE+12iqqxNTBTW92Q393LxkdJrRzxezU4o8LhtboYeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBahVVrGobwmCxM59CGUusx8w9mhyEd2l0RqUWlrOJ1o75C6CVdTUgdAOVsnwjm1i
	 YLWZqkzJX3y4NvLIOGDKr+MYUCInYJhBmarM5FaT/NML54WaVwh92WLXXQIvB9eGfe
	 gIUXJ4kgVawKcppfrJqJ29h7KPqoFGUjGBHev8bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1711/1815] fuse: Fix the condition to enable over-io-uring
Date: Sat, 12 Sep 2026 08:57:41 +0200
Message-ID: <20260912065729.143663604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 fs/fuse/dev_uring.c | 31 ++++++++++++++++++-------------
 fs/fuse/inode.c     |  4 ----
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index bda2b2cda190e..8448fdbd90c9a 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1237,26 +1237,31 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	}
 	fch = fud->chan;
 
-	/* Once a connection has io-uring enabled on it, it can't be disabled */
-	if (!enable_uring && !fch->io_uring) {
-		pr_info_ratelimited("fuse-io-uring is disabled\n");
-		return -EOPNOTSUPP;
-	}
-
-	if (fch->abort_with_err)
-		return -ECONNABORTED;
-	if (!fch->connected)
-		return -ENOTCONN;
-
 	/*
-	 * fuse_uring_register() needs the ring to be initialized,
-	 * we need to know the max payload size
+	 * The ring is sized from values negotiated by FUSE_INIT
 	 *
 	 * Pairs with smp_store_release() in fuse_chan_set_initialized()
 	 */
 	if (!smp_load_acquire(&fch->initialized))
 		return -EAGAIN;
 
+	if (fch->abort_with_err)
+		return -ECONNABORTED;
+	if (!fch->connected)
+		return -ENOTCONN;
+
+	/* Once a connection has io-uring enabled on it, it can't be disabled */
+	if (!enable_uring && !fch->io_uring) {
+		pr_info_ratelimited("fuse-io-uring is disabled by module parameter\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!fch->io_uring) {
+		pr_info_ratelimited(
+			"fuse-io-uring not enabled on this connection\n");
+		return -EOPNOTSUPP;
+	}
+
 	switch (cmd_op) {
 	case FUSE_IO_URING_CMD_REGISTER:
 		err = fuse_uring_register(cmd, issue_flags, fch);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index c219622720fef..e89e2b0a57a6a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1479,10 +1479,6 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
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



