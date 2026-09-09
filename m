Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847155C312;
	Wed,  9 Sep 2026 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964276; cv=none; b=l5Vo6RYuvtx6Q0w+1yjSCNbJKAhL7KZBcqMoaSdHff4gfENvnx+/G/LZ0kE3exMPeEQQZAT1N27Q8qumFyUP7S7oD4aG6zMb0iMEvyGkH4s+oOf/+aOb4oFATu4epxKHlqkx4SP87+W+7DAyPAqIeWVJ4u6B8wOMF0HELtRbMI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964276; c=relaxed/simple;
	bh=pmWEgu7irrDtICo1b7AVweASjjAn4mdgpZapKLNmgkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZSFl8DkxLfqXB5J6fLdp3pNXyLmPN6j0nTNXXg3uNGBh67lzI3IqMPTaDhO5FhJwpCJ5GyiF/NpyZ8PYfNUslhyjyF+iEGzdXXgb1sjuH5Dx1P3Da6k/8Bczzeu4IyuKf0907yRIjWXgxaMe5EL5ehmiAlCM/h2sNlCwR3dFcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTtOIkky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTtOIkky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5C81F00A3D;
	Wed,  9 Sep 2026 14:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964275;
	bh=51sC5+7nC9vdVZDsYw3RTf9kcYfZ9qrOTgvc+JJSeVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTtOIkkypuUZqC66S8dV0OPHX0vWLuriSlmoz7S9lAAI0RGxy5jj58Vb5jQsHERvn
	 zXEvjb4Hyp6T/o6pWG6ujLdasDznMh0R9LtwYEACduc++AcfK1AfUip22yuvKA5Bb5
	 Lru3XadlxfZ4eli+oU4VhJKOmAMeunw2zow+5LYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 368/583] f2fs: fix to zero post-EOF data when extending file size
Date: Wed,  9 Sep 2026 15:40:53 +0200
Message-ID: <20260909134250.785823526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 5eced87b7d19dbc76ebdddaf322046f9ac582fcb upstream.

generic/794  4s ... - output mismatch (see /share/git/fstests/results//generic/794.out.bad)
#    --- tests/generic/794.out   2026-06-12 08:46:32.766426241 +0800
#    +++ /share/git/fstests/results//generic/794.out.bad 2026-07-05 18:32:55.000000000 +0800
#    @@ -1,4 +1,16 @@
#     QA output created by 794
#     append_write
#    +FAIL: non-zero data in gap [4080,4096) after shutdown+remount
#    +000000 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  >ZZZZZZZZZZZZZZZZ<
#    +*
#    +001000
#     truncate_up
#    ...
#    (Run 'diff -u /share/git/fstests/tests/generic/794.out /share/git/fstests/results//generic/794.out.bad'  to see the entire diff)
Ran: generic/794
Failures: generic/794
Failed 1 of 1 tests

Steps of generic/794:
1. write 4096 bytes to file w/ 0x5a
2. use fiemap to get PBA of first block in file
3. truncate file to 4080
4. umount; write 4096 bytes to file w/ 0x5a directly via PBA; mount
5. extend filesize via
   a) append 4096 from offset 4096, or
   b) truncate 8192, or
   c) fallocate 4096 from offset 4096
6. verify the gap is zeroed in memory [4080,4096)
7. sync range 4096 from offset 4096; shutdown -f (flush meta before shutdown)
8. umount; mount; verify [4080,4096) is zeroed or not.

When extending file size (e.g. via truncate, fallocate, or write) across an
unaligned EOF boundary, we need to ensure that post-EOF data in the partial
page is zeroed out in pagecache and marked dirty, then writeback the cache to
persist zeroed data before committing inode w/ updated i_size.

This help to prevent stale disk data beyond the previous EOF from being exposed
after remounting or crash recovery.

Since f2fs is a LFS filesystem, we only support direct write via PBA in pinfile,
and pinfile has section-aligned filesize, so in Android, there should no problem,
but for other usage in different environment, let's fix this w/ fsync_mode=strict
mount option.

Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 84 insertions(+), 16 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -35,16 +35,52 @@
 #include <trace/events/f2fs.h>
 #include <uapi/linux/f2fs.h>
 
-static void f2fs_zero_post_eof_page(struct inode *inode,
-					loff_t new_size, bool lock)
+static int fill_zero(struct inode *inode, pgoff_t index,
+					loff_t start, loff_t len);
+
+static int do_zero_post_eof_page(struct inode *inode, loff_t new_size)
+{
+	loff_t old_size = i_size_read(inode);
+	unsigned int offset, len;
+	pgoff_t index;
+	int err;
+
+	offset = old_size & (PAGE_SIZE - 1);
+
+	if (!offset)
+		return 0;
+
+	len = min_t(loff_t, PAGE_SIZE - offset, new_size - old_size);
+	index = old_size >> PAGE_SHIFT;
+
+	if (f2fs_has_inline_data(inode)) {
+		/* data post eof should be always zero */
+		if (new_size <= MAX_INLINE_DATA(inode))
+			return 0;
+		err = f2fs_convert_inline_inode(inode);
+		if (err)
+			return err;
+	}
+
+	err = fill_zero(inode, index, offset, len);
+	if (err)
+		return err;
+	return filemap_write_and_wait_range(inode->i_mapping,
+				old_size, old_size + len - 1);
+}
+
+static int f2fs_zero_post_eof_page(struct inode *inode,
+					loff_t new_size, bool lock, bool writeback)
 {
 	loff_t old_size = i_size_read(inode);
+	bool strict =
+		F2FS_OPTION(F2FS_I_SB(inode)).fsync_mode == FSYNC_MODE_STRICT;
 
 	if (old_size >= new_size)
-		return;
+		return 0;
 
-	if (mapping_empty(inode->i_mapping))
-		return;
+	if (!strict && mapping_empty(inode->i_mapping))
+		return 0;
 
 	if (lock)
 		filemap_invalidate_lock(inode->i_mapping);
@@ -52,6 +88,16 @@ static void f2fs_zero_post_eof_page(stru
 	truncate_inode_pages_range(inode->i_mapping, old_size, new_size - 1);
 	if (lock)
 		filemap_invalidate_unlock(inode->i_mapping);
+
+	if (!writeback || !strict)
+		return 0;
+	/*
+	 * In fsync_mode=strict, when we expand an unaligned EOF size, we
+	 * should zero post EOF data and writeback the data immediately,
+	 * so that it can avoid exposing stale data after metadata flush
+	 * and POR.
+	 */
+	return do_zero_post_eof_page(inode, new_size);
 }
 
 static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
@@ -122,7 +168,10 @@ static vm_fault_t f2fs_vm_page_mkwrite(s
 
 	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
 
-	f2fs_zero_post_eof_page(inode, (folio->index + 1) << PAGE_SHIFT, true);
+	err = f2fs_zero_post_eof_page(inode,
+		(folio->index + 1) << PAGE_SHIFT, true, false);
+	if (err)
+		goto out_pagefault;
 
 	file_update_time(vmf->vma->vm_file);
 	filemap_invalidate_lock_shared(inode->i_mapping);
@@ -179,7 +228,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(s
 
 out_sem:
 	filemap_invalidate_unlock_shared(inode->i_mapping);
-
+out_pagefault:
 	sb_end_pagefault(inode->i_sb);
 out:
 	ret = vmf_fs_error(err);
@@ -1160,8 +1209,12 @@ int f2fs_setattr(struct mnt_idmap *idmap
 		f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
-		if (attr->ia_size > old_size)
-			f2fs_zero_post_eof_page(inode, attr->ia_size, false);
+		if (attr->ia_size > old_size) {
+			err = f2fs_zero_post_eof_page(inode,
+				attr->ia_size, false, true);
+			if (err)
+				goto err_out;
+		}
 		truncate_setsize(inode, attr->ia_size);
 
 		if (attr->ia_size <= old_size)
@@ -1170,6 +1223,7 @@ int f2fs_setattr(struct mnt_idmap *idmap
 		 * do not trim all blocks after i_size if target size is
 		 * larger than i_size.
 		 */
+err_out:
 		filemap_invalidate_unlock(inode->i_mapping);
 		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 		if (err)
@@ -1280,7 +1334,9 @@ static int f2fs_punch_hole(struct inode
 	if (ret)
 		return ret;
 
-	f2fs_zero_post_eof_page(inode, offset + len, true);
+	ret = f2fs_zero_post_eof_page(inode, offset + len, true, false);
+	if (ret)
+		return ret;
 
 	pg_start = ((unsigned long long) offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_SHIFT;
@@ -1565,7 +1621,9 @@ static int f2fs_do_collapse(struct inode
 	f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	filemap_invalidate_lock(inode->i_mapping);
 
-	f2fs_zero_post_eof_page(inode, offset + len, false);
+	ret = f2fs_zero_post_eof_page(inode, offset + len, false, false);
+	if (ret)
+		goto out_unlock;
 
 	f2fs_lock_op(sbi);
 	f2fs_drop_extent_tree(inode);
@@ -1573,6 +1631,7 @@ static int f2fs_do_collapse(struct inode
 	ret = __exchange_data_block(inode, inode, end, start, nrpages - end, true);
 	f2fs_unlock_op(sbi);
 
+out_unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 	f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	return ret;
@@ -1694,7 +1753,9 @@ static int f2fs_zero_range(struct inode
 	if (ret)
 		return ret;
 
-	f2fs_zero_post_eof_page(inode, offset + len, true);
+	ret = f2fs_zero_post_eof_page(inode, offset + len, true, false);
+	if (ret)
+		return ret;
 
 	pg_start = ((unsigned long long) offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_SHIFT;
@@ -1828,7 +1889,9 @@ static int f2fs_insert_range(struct inod
 	f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	filemap_invalidate_lock(mapping);
 
-	f2fs_zero_post_eof_page(inode, offset + len, false);
+	ret = f2fs_zero_post_eof_page(inode, offset + len, false, false);
+	if (ret)
+		goto out_unlock;
 	truncate_pagecache(inode, offset);
 
 	while (!ret && idx > pg_start) {
@@ -1844,6 +1907,7 @@ static int f2fs_insert_range(struct inod
 					idx + delta, nr, false);
 		f2fs_unlock_op(sbi);
 	}
+out_unlock:
 	filemap_invalidate_unlock(mapping);
 	f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	if (ret)
@@ -1886,7 +1950,9 @@ static int f2fs_expand_inode_data(struct
 	if (err)
 		return err;
 
-	f2fs_zero_post_eof_page(inode, offset + len, true);
+	err = f2fs_zero_post_eof_page(inode, offset + len, true, true);
+	if (err)
+		return err;
 
 	f2fs_balance_fs(sbi, true);
 
@@ -4947,8 +5013,10 @@ static ssize_t f2fs_write_checks(struct
 	if (err)
 		return err;
 
-	f2fs_zero_post_eof_page(inode,
-		iocb->ki_pos + iov_iter_count(from), true);
+	err = f2fs_zero_post_eof_page(inode,
+		iocb->ki_pos + iov_iter_count(from), true, true);
+	if (err)
+		return err;
 	return count;
 }
 


