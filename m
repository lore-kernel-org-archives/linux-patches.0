Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44281A6192;
	Tue, 30 Jul 2024 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359156; cv=none; b=KwPrUf3e0TgP8R0QrV/2WGL4M6KgnLMAd9wCd7aswKvKk+Oan/wRSgep9Agdzz+LUDUn9flfe7ySz5juqFy91reu4SBErRj5Oik7qYVsNoi6qO77MS+WQh/efOHpV1+uQ83jvKZhlkrRcXSeQMwpfXVPn0TadSeER4DcIW58XKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359156; c=relaxed/simple;
	bh=a18cAp/FbjO/VDk6wP42GP/svuytv0OVG/r/bYGyIHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGF27Y2ZbvqH/z7iUrVoA/e8ROiaLfsOo7Eu/IkduadCS+InSN2wZNrEVIH4cmMtFteCT3fyBhF4t6zfuHDfASoskZpCuHV5XgeJ3EddkbNoBwCtxhzo94BLVeLIZwjUAzNpq1QEalev5LAb8xN796YKmIP2bY1Wcsr+dLiw418=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0J4r5jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0J4r5jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5368BC32782;
	Tue, 30 Jul 2024 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359155;
	bh=a18cAp/FbjO/VDk6wP42GP/svuytv0OVG/r/bYGyIHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0J4r5jE0fxP324yEu2I8U3bE87YmUP62I4NS8ypXvljvgumL4n0j6QwWO92Tv7zs
	 KmcnsBZPdyIkxoXFFmXtB/n0Ny52U60Qw21tM7VExWr7xjEIoCkjZ1qcbXTV6ok8D8
	 JJjC9M5yk38mE97wzLk+ZLzkIFQJb1ytXsb8NCK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 440/568] f2fs: use meta inode for GC of COW file
Date: Tue, 30 Jul 2024 17:49:07 +0200
Message-ID: <20240730151657.068435933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunmin Jeong <s_min.jeong@samsung.com>

commit f18d0076933689775fe7faeeb10ee93ff01be6ab upstream.

In case of the COW file, new updates and GC writes are already
separated to page caches of the atomic file and COW file. As some cases
that use the meta inode for GC, there are some race issues between a
foreground thread and GC thread.

To handle them, we need to take care when to invalidate and wait
writeback of GC pages in COW files as the case of using the meta inode.
Also, a pointer from the COW inode to the original inode is required to
check the state of original pages.

For the former, we can solve the problem by using the meta inode for GC
of COW files. Then let's get a page from the original inode in
move_data_block when GCing the COW file to avoid race condition.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Cc: stable@vger.kernel.org #v5.19+
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yeongjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c   |    2 +-
 fs/f2fs/f2fs.h   |   13 +++++++++++--
 fs/f2fs/file.c   |    3 +++
 fs/f2fs/gc.c     |    7 +++++--
 fs/f2fs/inline.c |    2 +-
 fs/f2fs/inode.c  |    3 ++-
 6 files changed, 23 insertions(+), 7 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2586,7 +2586,7 @@ bool f2fs_should_update_outplace(struct
 		return true;
 	if (IS_NOQUOTA(inode))
 		return true;
-	if (f2fs_is_atomic_file(inode))
+	if (f2fs_used_in_atomic_write(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -836,7 +836,11 @@ struct f2fs_inode_info {
 	struct task_struct *atomic_write_task;	/* store atomic write task */
 	struct extent_tree *extent_tree[NR_EXTENT_CACHES];
 					/* cached extent_tree entry */
-	struct inode *cow_inode;	/* copy-on-write inode for atomic write */
+	union {
+		struct inode *cow_inode;	/* copy-on-write inode for atomic write */
+		struct inode *atomic_inode;
+					/* point to atomic_inode, available only for cow_inode */
+	};
 
 	/* avoid racing between foreground op and gc */
 	struct f2fs_rwsem i_gc_rwsem[2];
@@ -4255,9 +4259,14 @@ static inline bool f2fs_post_read_requir
 		f2fs_compressed_file(inode);
 }
 
+static inline bool f2fs_used_in_atomic_write(struct inode *inode)
+{
+	return f2fs_is_atomic_file(inode) || f2fs_is_cow_file(inode);
+}
+
 static inline bool f2fs_meta_inode_gc_required(struct inode *inode)
 {
-	return f2fs_post_read_required(inode) || f2fs_is_atomic_file(inode);
+	return f2fs_post_read_required(inode) || f2fs_used_in_atomic_write(inode);
 }
 
 /*
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2119,6 +2119,9 @@ static int f2fs_ioc_start_atomic_write(s
 
 		set_inode_flag(fi->cow_inode, FI_COW_FILE);
 		clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
+
+		/* Set the COW inode's atomic_inode to the atomic inode */
+		F2FS_I(fi->cow_inode)->atomic_inode = inode;
 	} else {
 		/* Reuse the already created COW inode */
 		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1171,7 +1171,8 @@ static bool is_alive(struct f2fs_sb_info
 static int ra_data_block(struct inode *inode, pgoff_t index)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct address_space *mapping = inode->i_mapping;
+	struct address_space *mapping = f2fs_is_cow_file(inode) ?
+				F2FS_I(inode)->atomic_inode->i_mapping : inode->i_mapping;
 	struct dnode_of_data dn;
 	struct page *page;
 	struct f2fs_io_info fio = {
@@ -1262,6 +1263,8 @@ put_page:
 static int move_data_block(struct inode *inode, block_t bidx,
 				int gc_type, unsigned int segno, int off)
 {
+	struct address_space *mapping = f2fs_is_cow_file(inode) ?
+				F2FS_I(inode)->atomic_inode->i_mapping : inode->i_mapping;
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.ino = inode->i_ino,
@@ -1284,7 +1287,7 @@ static int move_data_block(struct inode
 				CURSEG_ALL_DATA_ATGC : CURSEG_COLD_DATA;
 
 	/* do not read out */
-	page = f2fs_grab_cache_page(inode->i_mapping, bidx, false);
+	page = f2fs_grab_cache_page(mapping, bidx, false);
 	if (!page)
 		return -ENOMEM;
 
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -16,7 +16,7 @@
 
 static bool support_inline_data(struct inode *inode)
 {
-	if (f2fs_is_atomic_file(inode))
+	if (f2fs_used_in_atomic_write(inode))
 		return false;
 	if (!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))
 		return false;
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -816,8 +816,9 @@ void f2fs_evict_inode(struct inode *inod
 
 	f2fs_abort_atomic_write(inode, true);
 
-	if (fi->cow_inode) {
+	if (fi->cow_inode && f2fs_is_cow_file(fi->cow_inode)) {
 		clear_inode_flag(fi->cow_inode, FI_COW_FILE);
+		F2FS_I(fi->cow_inode)->atomic_inode = NULL;
 		iput(fi->cow_inode);
 		fi->cow_inode = NULL;
 	}


