Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9AA2AF07;
	Mon, 28 Oct 2024 06:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098348; cv=none; b=ZojPdO5fXaG5saP9tXdQdIsqvYZVA2GbemK2lXNrfBIwcHlNjbt3e9TGHwvdpxMYbz63xIB6AluJFu6fe1Y1tTLzDIlyz5Tf/hX2lz4uHrBpqLPEpZCl8u0aBmKU5MUXYx0YOrI0b67CMQHa/r8oyGum98mGLtmJjLNQkmPHf4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098348; c=relaxed/simple;
	bh=vYYhgohS3KTUPab/DKnjeAHclsO4upWkz3y64J/6HzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBBxmF434THCRkjibs9GhG/fbkabGnVv/t07CC12osH5dkzQY2A2E7vWLqcwmK6dGhNfv83pT+BUNYPhhCYdv5ubF/rdjxacu/vzWBT6srKaiFAuPmicJJda+qzELMZ143lc5foDjfrFZFkVe1QMtQ9iQz/8CefOLopx8vRU+Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeVVXRmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeVVXRmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE89C4CEC3;
	Mon, 28 Oct 2024 06:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098347;
	bh=vYYhgohS3KTUPab/DKnjeAHclsO4upWkz3y64J/6HzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeVVXRmvd6fTFlx6NCvzjHXkyYF+5jIn/K67LQgtkQ/MwmXIBOSm77EMkG/zr3fNF
	 wC2kqH9bDYW0f+d7QRb1kyx5YdEhc36sFdyVHi61H30tw3BnnjQ1GQNNkBoabwTIK/
	 rO/Oclt/oAkQj9TElo/ZVwCiYrjDmM7m/9zCGPpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 188/261] fs: pass offset and result to backing_file end_write() callback
Date: Mon, 28 Oct 2024 07:25:30 +0100
Message-ID: <20241028062316.730363244@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit f03b296e8b516dbd63f57fc9056c1b0da1b9a0ff ]

This is needed for extending fuse inode size after fuse passthrough write.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-fsdevel/CAJfpegs=cvZ_NYy6Q_D42XhYS=Sjj5poM1b5TzXzOVvX=R36aA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 20121d3f58f0 ("fuse: update inode size after extending passthrough write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/backing-file.c            | 8 ++++----
 fs/fuse/passthrough.c        | 6 +++---
 fs/overlayfs/file.c          | 9 +++++++--
 include/linux/backing-file.h | 2 +-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 8860dac58c37e..09a9be945d45e 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -80,7 +80,7 @@ struct backing_aio {
 	refcount_t ref;
 	struct kiocb *orig_iocb;
 	/* used for aio completion */
-	void (*end_write)(struct file *);
+	void (*end_write)(struct file *, loff_t, ssize_t);
 	struct work_struct work;
 	long res;
 };
@@ -109,7 +109,7 @@ static void backing_aio_cleanup(struct backing_aio *aio, long res)
 	struct kiocb *orig_iocb = aio->orig_iocb;
 
 	if (aio->end_write)
-		aio->end_write(orig_iocb->ki_filp);
+		aio->end_write(orig_iocb->ki_filp, iocb->ki_pos, res);
 
 	orig_iocb->ki_pos = iocb->ki_pos;
 	backing_aio_put(aio);
@@ -239,7 +239,7 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 
 		ret = vfs_iter_write(file, iter, &iocb->ki_pos, rwf);
 		if (ctx->end_write)
-			ctx->end_write(ctx->user_file);
+			ctx->end_write(ctx->user_file, iocb->ki_pos, ret);
 	} else {
 		struct backing_aio *aio;
 
@@ -317,7 +317,7 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	revert_creds(old_cred);
 
 	if (ctx->end_write)
-		ctx->end_write(ctx->user_file);
+		ctx->end_write(ctx->user_file, ppos ? *ppos : 0, ret);
 
 	return ret;
 }
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 9666d13884ce5..f0f87d1c9a945 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -18,7 +18,7 @@ static void fuse_file_accessed(struct file *file)
 	fuse_invalidate_atime(inode);
 }
 
-static void fuse_file_modified(struct file *file)
+static void fuse_passthrough_end_write(struct file *file, loff_t pos, ssize_t ret)
 {
 	struct inode *inode = file_inode(file);
 
@@ -63,7 +63,7 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *iocb,
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
 		.user_file = file,
-		.end_write = fuse_file_modified,
+		.end_write = fuse_passthrough_end_write,
 	};
 
 	pr_debug("%s: backing_file=0x%p, pos=%lld, len=%zu\n", __func__,
@@ -110,7 +110,7 @@ ssize_t fuse_passthrough_splice_write(struct pipe_inode_info *pipe,
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
 		.user_file = out,
-		.end_write = fuse_file_modified,
+		.end_write = fuse_passthrough_end_write,
 	};
 
 	pr_debug("%s: backing_file=0x%p, pos=%lld, len=%zu, flags=0x%x\n", __func__,
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 1a411cae57ed9..7b085f89e5a15 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -229,6 +229,11 @@ static void ovl_file_modified(struct file *file)
 	ovl_copyattr(file_inode(file));
 }
 
+static void ovl_file_end_write(struct file *file, loff_t pos, ssize_t ret)
+{
+	ovl_file_modified(file);
+}
+
 static void ovl_file_accessed(struct file *file)
 {
 	struct inode *inode, *upperinode;
@@ -292,7 +297,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(inode->i_sb),
 		.user_file = file,
-		.end_write = ovl_file_modified,
+		.end_write = ovl_file_end_write,
 	};
 
 	if (!iov_iter_count(iter))
@@ -362,7 +367,7 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(inode->i_sb),
 		.user_file = out,
-		.end_write = ovl_file_modified,
+		.end_write = ovl_file_end_write,
 	};
 
 	inode_lock(inode);
diff --git a/include/linux/backing-file.h b/include/linux/backing-file.h
index 4b61b0e577209..2eed0ffb5e8f8 100644
--- a/include/linux/backing-file.h
+++ b/include/linux/backing-file.h
@@ -16,7 +16,7 @@ struct backing_file_ctx {
 	const struct cred *cred;
 	struct file *user_file;
 	void (*accessed)(struct file *);
-	void (*end_write)(struct file *);
+	void (*end_write)(struct file *, loff_t, ssize_t);
 };
 
 struct file *backing_file_open(const struct path *user_path, int flags,
-- 
2.43.0



