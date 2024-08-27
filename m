Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06B1C57BF;
	Tue, 27 Aug 2024 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772436; cv=none; b=ZrysQnmjtFsOuxk5UFl/dd3bJVarkqD9SOOajio99XJfWMiFQXz3orCs70DuFP0fLtY8gyFxe86iYx2ye3R09OpcZ+KrUbP+qWqrx+OfgT2ImpYcj/GefpYR6NPNGrYCuzZSKV+x/akYKR+YW56CClQcS8fv71wjQ6WbYswKCuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772436; c=relaxed/simple;
	bh=AKbxR3iaAejQap75mIc862hOK7jHVwQb9ld5w8CjvN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tblzHOZfngdWQ9bi0EN2Kv6NoDDMvEjjcOR6yVxTHu1b8CBH/DK7Opob/yDJCMh7HCn0zlgISR80FhRcKnyvqlF/neqFGQ2XzuthVoT8V7OmIxMlSs/Bvv7++k+DJtCViVjmG7jAuyERb46A3pWUJjKZDhv0b0g3Ef00e4mdZxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmqhD7hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmqhD7hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F7CC4DE14;
	Tue, 27 Aug 2024 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772435;
	bh=AKbxR3iaAejQap75mIc862hOK7jHVwQb9ld5w8CjvN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmqhD7hmWCLrA5At3J2jj9+xu5SlGSKoRqxUc/vr6GZQPEmkT4ndn++7gbe1QFHpu
	 +YHlDuuGVyYegal14zpE8a+83TZiQ5+EaG1ZCFOfVINY1qX6e9GFsbt4mN3RsTl+mA
	 0NbByu3FSxgDcYAYuHe5n48PMdLexruYhELs4seA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/321] btrfs: replace sb::s_blocksize by fs_info::sectorsize
Date: Tue, 27 Aug 2024 16:38:43 +0200
Message-ID: <20240827143846.417463276@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 4e00422ee62663e31e611d7de4d2c4aa3f8555f2 ]

The block size stored in the super block is used by subsystems outside
of btrfs and it's a copy of fs_info::sectorsize. Unify that to always
use our sectorsize, with the exception of mount where we first need to
use fixed values (4K) until we read the super block and can set the
sectorsize.

Replace all uses, in most cases it's fewer pointer indirections.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 46a6e10a1ab1 ("btrfs: send: allow cloning non-aligned extent if it ends at i_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c   | 2 ++
 fs/btrfs/extent_io.c | 4 ++--
 fs/btrfs/inode.c     | 2 +-
 fs/btrfs/ioctl.c     | 2 +-
 fs/btrfs/reflink.c   | 6 +++---
 fs/btrfs/send.c      | 2 +-
 fs/btrfs/super.c     | 2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c17232659942d..9ebb7bb37a22e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3130,6 +3130,7 @@ static int init_mount_fs_info(struct btrfs_fs_info *fs_info, struct super_block
 	int ret;
 
 	fs_info->sb = sb;
+	/* Temporary fixed values for block size until we read the superblock. */
 	sb->s_blocksize = BTRFS_BDEV_BLOCKSIZE;
 	sb->s_blocksize_bits = blksize_bits(BTRFS_BDEV_BLOCKSIZE);
 
@@ -3628,6 +3629,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	sb->s_bdi->ra_pages *= btrfs_super_num_devices(disk_super);
 	sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
 
+	/* Update the values for the current filesystem. */
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 	memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5f923c9b773e0..72227c0b4b5a1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1748,7 +1748,7 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 	int ret = 0;
 	size_t pg_offset = 0;
 	size_t iosize;
-	size_t blocksize = inode->i_sb->s_blocksize;
+	size_t blocksize = fs_info->sectorsize;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 
 	ret = set_page_extent_mapped(page);
@@ -3348,7 +3348,7 @@ int extent_invalidate_folio(struct extent_io_tree *tree,
 	struct extent_state *cached_state = NULL;
 	u64 start = folio_pos(folio);
 	u64 end = start + folio_size(folio) - 1;
-	size_t blocksize = folio->mapping->host->i_sb->s_blocksize;
+	size_t blocksize = btrfs_sb(folio->mapping->host->i_sb)->sectorsize;
 
 	/* This function is only called for the btree inode */
 	ASSERT(tree->owner == IO_TREE_BTREE_INODE_IO);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bd3388e1b532e..934e360d1aefa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9111,7 +9111,7 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 	u64 delalloc_bytes;
 	u64 inode_bytes;
 	struct inode *inode = d_inode(path->dentry);
-	u32 blocksize = inode->i_sb->s_blocksize;
+	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
 	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 64b37afb7c87f..31f7fe31b607a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -517,7 +517,7 @@ static noinline int btrfs_ioctl_fitrim(struct btrfs_fs_info *fs_info,
 	 * block group is in the logical address space, which can be any
 	 * sectorsize aligned bytenr in  the range [0, U64_MAX].
 	 */
-	if (range.len < fs_info->sb->s_blocksize)
+	if (range.len < fs_info->sectorsize)
 		return -EINVAL;
 
 	range.minlen = max(range.minlen, minlen);
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index f50586ff85c84..fc6e428525781 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -659,7 +659,7 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 len,
 				   struct inode *dst, u64 dst_loff)
 {
 	struct btrfs_fs_info *fs_info = BTRFS_I(src)->root->fs_info;
-	const u64 bs = fs_info->sb->s_blocksize;
+	const u64 bs = fs_info->sectorsize;
 	int ret;
 
 	/*
@@ -726,7 +726,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	int ret;
 	int wb_ret;
 	u64 len = olen;
-	u64 bs = fs_info->sb->s_blocksize;
+	u64 bs = fs_info->sectorsize;
 
 	/*
 	 * VFS's generic_remap_file_range_prep() protects us from cloning the
@@ -792,7 +792,7 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
-	u64 bs = BTRFS_I(inode_out)->root->fs_info->sb->s_blocksize;
+	u64 bs = BTRFS_I(inode_out)->root->fs_info->sectorsize;
 	u64 wb_len;
 	int ret;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cc57a97860d8a..e311cc291fe45 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5910,7 +5910,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	int ret = 0;
 	u64 offset = key->offset;
 	u64 end;
-	u64 bs = sctx->send_root->fs_info->sb->s_blocksize;
+	u64 bs = sctx->send_root->fs_info->sectorsize;
 
 	end = min_t(u64, btrfs_file_extent_end(path), sctx->cur_inode_size);
 	if (offset >= end)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6fc5fa18d1ee6..d063379a031dc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2426,7 +2426,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		buf->f_bavail = 0;
 
 	buf->f_type = BTRFS_SUPER_MAGIC;
-	buf->f_bsize = dentry->d_sb->s_blocksize;
+	buf->f_bsize = fs_info->sectorsize;
 	buf->f_namelen = BTRFS_NAME_LEN;
 
 	/* We treat it as constant endianness (it doesn't matter _which_)
-- 
2.43.0



