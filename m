Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E741E5708;
	Thu, 30 Jan 2025 14:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245609; cv=none; b=MuQ3bdwpwp1Rf4cjNoGH/HX8vXuCz0h46ajrLX8wlZS5NpId+16JEzAWqj1mp9eI2UFKUKDIFWMe3YjKoj//yz3o50v2BBqz8zIirubUNdr71VTYu5hDJF+FMJJ75e03A6PH4V8tOpxCVKG/EvdZ6P4H77miFgtdF7yAcSKlPTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245609; c=relaxed/simple;
	bh=zMk9t49swngqualg7GAtqkcBnmJeKgdeCK5BbLn4v2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEnHeZIPG1XUWLrf5YMO/NvjWGykSEPION2j7g8XdW+g12FONNznN+2rDnKS8AiY/DRbIMq+gE20GLkYJ3f5k4pbRnZva5L8QFG+uYi9+Wq8XvtqFZn1LuiEC6izvCnRfSD5ORU2Hc0qcB8fxxvShl0KABZoZq/OWDBpS/3EENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivgWJE1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivgWJE1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A37DC4CED2;
	Thu, 30 Jan 2025 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245608;
	bh=zMk9t49swngqualg7GAtqkcBnmJeKgdeCK5BbLn4v2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivgWJE1gAuxjxnrUv1ldMetxs4vL5gqVG8sDayi4VLApb6lW2BUYMOHcAPe8PtlQt
	 OFpc17LX0sQ799ya07dsw2b4Blk2fx3T3ZClWrSmfc7KhEeHjbSdbBOhQOpF6MUQzD
	 2g4dHO1pW1YrJtrR7x9/eoqyjAduSXXsl6nnON+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 04/25] Revert "libfs: fix infinite directory reads for offset dir"
Date: Thu, 30 Jan 2025 14:58:50 +0100
Message-ID: <20250130133457.099773421@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit b662d858131da9a8a14e68661656989b14dbf113 upstream.

The current directory offset allocator (based on mtree_alloc_cyclic)
stores the next offset value to return in octx->next_offset. This
mechanism typically returns values that increase monotonically over
time. Eventually, though, the newly allocated offset value wraps
back to a low number (say, 2) which is smaller than other already-
allocated offset values.

Yu Kuai <yukuai3@huawei.com> reports that, after commit 64a7ce76fb90
("libfs: fix infinite directory reads for offset dir"), if a
directory's offset allocator wraps, existing entries are no longer
visible via readdir/getdents because offset_readdir() stops listing
entries once an entry's offset is larger than octx->next_offset.
These entries vanish persistently -- they can be looked up, but will
never again appear in readdir(3) output.

The reason for this is that the commit treats directory offsets as
monotonically increasing integer values rather than opaque cookies,
and introduces this comparison:

	if (dentry2offset(dentry) >= last_index) {

On 64-bit platforms, the directory offset value upper bound is
2^63 - 1. Directory offsets will monotonically increase for millions
of years without wrapping.

On 32-bit platforms, however, LONG_MAX is 2^31 - 1. The allocator
can wrap after only a few weeks (at worst).

Revert commit 64a7ce76fb90 ("libfs: fix infinite directory reads for
offset dir") to prepare for a fix that can work properly on 32-bit
systems and might apply to recent LTS kernels where shmem employs
the simple_offset mechanism.

Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20241228175522.1854234-4-cel@kernel.org
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -422,14 +422,6 @@ void simple_offset_destroy(struct offset
 	mtree_destroy(&octx->mt);
 }
 
-static int offset_dir_open(struct inode *inode, struct file *file)
-{
-	struct offset_ctx *ctx = inode->i_op->get_offset_ctx(inode);
-
-	file->private_data = (void *)ctx->next_offset;
-	return 0;
-}
-
 /**
  * offset_dir_llseek - Advance the read position of a directory descriptor
  * @file: an open directory whose position is to be updated
@@ -443,9 +435,6 @@ static int offset_dir_open(struct inode
  */
 static loff_t offset_dir_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *inode = file->f_inode;
-	struct offset_ctx *ctx = inode->i_op->get_offset_ctx(inode);
-
 	switch (whence) {
 	case SEEK_CUR:
 		offset += file->f_pos;
@@ -459,8 +448,7 @@ static loff_t offset_dir_llseek(struct f
 	}
 
 	/* In this case, ->private_data is protected by f_pos_lock */
-	if (!offset)
-		file->private_data = (void *)ctx->next_offset;
+	file->private_data = NULL;
 	return vfs_setpos(file, offset, LONG_MAX);
 }
 
@@ -491,7 +479,7 @@ static bool offset_dir_emit(struct dir_c
 			  inode->i_ino, fs_umode_to_dtype(inode->i_mode));
 }
 
-static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx, long last_index)
+static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 {
 	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
 	struct dentry *dentry;
@@ -499,21 +487,17 @@ static void offset_iterate_dir(struct in
 	while (true) {
 		dentry = offset_find_next(octx, ctx->pos);
 		if (!dentry)
-			return;
-
-		if (dentry2offset(dentry) >= last_index) {
-			dput(dentry);
-			return;
-		}
+			return ERR_PTR(-ENOENT);
 
 		if (!offset_dir_emit(ctx, dentry)) {
 			dput(dentry);
-			return;
+			break;
 		}
 
 		ctx->pos = dentry2offset(dentry) + 1;
 		dput(dentry);
 	}
+	return NULL;
 }
 
 /**
@@ -540,19 +524,22 @@ static void offset_iterate_dir(struct in
 static int offset_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry *dir = file->f_path.dentry;
-	long last_index = (long)file->private_data;
 
 	lockdep_assert_held(&d_inode(dir)->i_rwsem);
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	offset_iterate_dir(d_inode(dir), ctx, last_index);
+	/* In this case, ->private_data is protected by f_pos_lock */
+	if (ctx->pos == DIR_OFFSET_MIN)
+		file->private_data = NULL;
+	else if (file->private_data == ERR_PTR(-ENOENT))
+		return 0;
+	file->private_data = offset_iterate_dir(d_inode(dir), ctx);
 	return 0;
 }
 
 const struct file_operations simple_offset_dir_operations = {
-	.open		= offset_dir_open,
 	.llseek		= offset_dir_llseek,
 	.iterate_shared	= offset_readdir,
 	.read		= generic_read_dir,


