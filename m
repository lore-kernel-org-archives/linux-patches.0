Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C3A1C688E;
	Tue, 27 Aug 2024 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771076; cv=none; b=MVYx3GTg5OuYUtQG4MgRSSh597iBn63Cjqe7Wma4GjfJwHUNMKq/WyMsgxzkjSr/pf6kUfJi0atearZ71pUTrSNwqbhNWRYDX0SxxueyStB7XbprMk04nQb6xXZHZfqr22kNmybGXiiP3nW7elLyC0AdMZC9nZ5nnfHmiG3DH2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771076; c=relaxed/simple;
	bh=NqXyeQ9POUobtCZdcUHhTsaVwdVEUZbKD1wn+Shy0Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QG9gtpzQ7OKoC3VGP6KfKD5B493BdWi5uQssmQaJaOAGEgr54bNhjwA/ApXkuo3QEK9A0UBAAmaWy1mvEQlkoyqiP5MzoRy4+mf8G3BJzMLKYmAE1Jz/fF10N6vppamriBmwqPG2SwNsD6j6zc7IyFgBPBGtLipUbSPB/9uwX+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9SyqMGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9SyqMGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F269C6105F;
	Tue, 27 Aug 2024 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771075;
	bh=NqXyeQ9POUobtCZdcUHhTsaVwdVEUZbKD1wn+Shy0Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9SyqMGntcKhI9rkLNed4B3Uh4dTIAWISglX6C/uLxxdofzS8B42c4CpVq5IVE/9e
	 DsPyVGxSN3s5m8KpIUmSJ2aKrHKWnWPP/Uc4T4K4Ee4EXDxYpjn9A+3jyrMytJCvFN
	 0jsNyI89uPa7XYTOAwGnvw4CmWggihjxDB+ZWMhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 080/273] libfs: fix infinite directory reads for offset dir
Date: Tue, 27 Aug 2024 16:36:44 +0200
Message-ID: <20240827143836.456933571@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit 64a7ce76fb901bf9f9c36cf5d681328fc0fd4b5a ]

After we switch tmpfs dir operations from simple_dir_operations to
simple_offset_dir_operations, every rename happened will fill new dentry
to dest dir's maple tree(&SHMEM_I(inode)->dir_offsets->mt) with a free
key starting with octx->newx_offset, and then set newx_offset equals to
free key + 1. This will lead to infinite readdir combine with rename
happened at the same time, which fail generic/736 in xfstests(detail show
as below).

1. create 5000 files(1 2 3...) under one dir
2. call readdir(man 3 readdir) once, and get one entry
3. rename(entry, "TEMPFILE"), then rename("TEMPFILE", entry)
4. loop 2~3, until readdir return nothing or we loop too many
   times(tmpfs break test with the second condition)

We choose the same logic what commit 9b378f6ad48cf ("btrfs: fix infinite
directory reads") to fix it, record the last_index when we open dir, and
do not emit the entry which index >= last_index. The file->private_data
now used in offset dir can use directly to do this, and we also update
the last_index when we llseek the dir file.

Fixes: a2e459555c5f ("shmem: stable directory offsets")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/r/20240731043835.1828697-1-yangerkun@huawei.com
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
[brauner: only update last_index after seek when offset is zero like Jan suggested]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index b635ee5adbcce..65279e53fbf27 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -450,6 +450,14 @@ void simple_offset_destroy(struct offset_ctx *octx)
 	mtree_destroy(&octx->mt);
 }
 
+static int offset_dir_open(struct inode *inode, struct file *file)
+{
+	struct offset_ctx *ctx = inode->i_op->get_offset_ctx(inode);
+
+	file->private_data = (void *)ctx->next_offset;
+	return 0;
+}
+
 /**
  * offset_dir_llseek - Advance the read position of a directory descriptor
  * @file: an open directory whose position is to be updated
@@ -463,6 +471,9 @@ void simple_offset_destroy(struct offset_ctx *octx)
  */
 static loff_t offset_dir_llseek(struct file *file, loff_t offset, int whence)
 {
+	struct inode *inode = file->f_inode;
+	struct offset_ctx *ctx = inode->i_op->get_offset_ctx(inode);
+
 	switch (whence) {
 	case SEEK_CUR:
 		offset += file->f_pos;
@@ -476,7 +487,8 @@ static loff_t offset_dir_llseek(struct file *file, loff_t offset, int whence)
 	}
 
 	/* In this case, ->private_data is protected by f_pos_lock */
-	file->private_data = NULL;
+	if (!offset)
+		file->private_data = (void *)ctx->next_offset;
 	return vfs_setpos(file, offset, LONG_MAX);
 }
 
@@ -507,7 +519,7 @@ static bool offset_dir_emit(struct dir_context *ctx, struct dentry *dentry)
 			  inode->i_ino, fs_umode_to_dtype(inode->i_mode));
 }
 
-static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
+static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx, long last_index)
 {
 	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
 	struct dentry *dentry;
@@ -515,17 +527,21 @@ static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 	while (true) {
 		dentry = offset_find_next(octx, ctx->pos);
 		if (!dentry)
-			return ERR_PTR(-ENOENT);
+			return;
+
+		if (dentry2offset(dentry) >= last_index) {
+			dput(dentry);
+			return;
+		}
 
 		if (!offset_dir_emit(ctx, dentry)) {
 			dput(dentry);
-			break;
+			return;
 		}
 
 		ctx->pos = dentry2offset(dentry) + 1;
 		dput(dentry);
 	}
-	return NULL;
 }
 
 /**
@@ -552,22 +568,19 @@ static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 static int offset_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry *dir = file->f_path.dentry;
+	long last_index = (long)file->private_data;
 
 	lockdep_assert_held(&d_inode(dir)->i_rwsem);
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	/* In this case, ->private_data is protected by f_pos_lock */
-	if (ctx->pos == DIR_OFFSET_MIN)
-		file->private_data = NULL;
-	else if (file->private_data == ERR_PTR(-ENOENT))
-		return 0;
-	file->private_data = offset_iterate_dir(d_inode(dir), ctx);
+	offset_iterate_dir(d_inode(dir), ctx, last_index);
 	return 0;
 }
 
 const struct file_operations simple_offset_dir_operations = {
+	.open		= offset_dir_open,
 	.llseek		= offset_dir_llseek,
 	.iterate_shared	= offset_readdir,
 	.read		= generic_read_dir,
-- 
2.43.0



