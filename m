Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7EB15442C;
	Thu,  3 Jul 2025 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555260; cv=none; b=njWXH4z8kwbLgFlCavnC9a8AugxBmAOyap8wPwE2w3zAkqgFL8T5UKVPDN6qC6nEvzXidBydswNO7zKkkN8f4mTYs+/1TuVRulg6CVL9MM3zdzO1s/IhKsxkNYrFBn1U6jN4jxowKaRNKq++PAiMknzkPRsoHJF5CT6zVHGO6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555260; c=relaxed/simple;
	bh=n5x/h1Q5C0PU5vPKXJkBa+p3nTOc5pmUShyzv3Z0BE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aiwhdMmDcNgdND0ChSqWo7hsiUAaFvaW62X2Xvvy/NkFHDnB/SZYxHFz5Qykfvxm8XTQVLmfWrCpVJcl/2TOfpRVm9V8c/YumOTiGrVFN8NtzFv4ZQKHTUWPg8No9ALiu+Q6/TuXB65dOEvtaxbbe1ZPNScyk/Rclao1dqiK1Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGgWedmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGgWedmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B76C4CEE3;
	Thu,  3 Jul 2025 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555259;
	bh=n5x/h1Q5C0PU5vPKXJkBa+p3nTOc5pmUShyzv3Z0BE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGgWedmBdu59/2tZA15eys2SFIOf2ZKj+oHX1k1TiJ7RFl8XHLu6ivGAps52dRdjB
	 sXzhWy/xNGQFNa+7EZ/RQcpS9lpK/BurRKO7z/1h3gLxAgPGp2MXlkCz7Wpou9BPaK
	 c6YC2/51AhJtIm7e11OCjzFUBUWhE4Yl3+Vyh3ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.15 192/263] f2fs: fix to zero post-eof page
Date: Thu,  3 Jul 2025 16:41:52 +0200
Message-ID: <20250703144012.055395164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit ba8dac350faf16afc129ce6303ca4feaf083ccb1 upstream.

fstest reports a f2fs bug:

#generic/363 42s ... [failed, exit status 1]- output mismatch (see /share/git/fstests/results//generic/363.out.bad)
#    --- tests/generic/363.out   2025-01-12 21:57:40.271440542 +0800
#    +++ /share/git/fstests/results//generic/363.out.bad 2025-05-19 19:55:58.000000000 +0800
#    @@ -1,2 +1,78 @@
#     QA output created by 363
#     fsx -q -S 0 -e 1 -N 100000
#    +READ BAD DATA: offset = 0xd6fb, size = 0xf044, fname = /mnt/f2fs/junk
#    +OFFSET      GOOD    BAD     RANGE
#    +0x1540d     0x0000  0x2a25  0x0
#    +operation# (mod 256) for the bad data may be 37
#    +0x1540e     0x0000  0x2527  0x1
#    ...
#    (Run 'diff -u /share/git/fstests/tests/generic/363.out /share/git/fstests/results//generic/363.out.bad'  to see the entire diff)
Ran: generic/363
Failures: generic/363
Failed 1 of 1 tests

The root cause is user can update post-eof page via mmap [1], however, f2fs
missed to zero post-eof page in below operations, so, once it expands i_size,
then it will include dummy data locates previous post-eof page, so during
below operations, we need to zero post-eof page.

Operations which can include dummy data after previous i_size after expanding
i_size:
- write
- mapwrite [1]
- truncate
- fallocate
 * preallocate
 * zero_range
 * insert_range
 * collapse_range
- clone_range (doesn’t support in f2fs)
- copy_range (doesn’t support in f2fs)

[1] https://man7.org/linux/man-pages/man2/mmap.2.html 'BUG section'

Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -35,6 +35,17 @@
 #include <trace/events/f2fs.h>
 #include <uapi/linux/f2fs.h>
 
+static void f2fs_zero_post_eof_page(struct inode *inode, loff_t new_size)
+{
+	loff_t old_size = i_size_read(inode);
+
+	if (old_size >= new_size)
+		return;
+
+	/* zero or drop pages only in range of [old_size, new_size] */
+	truncate_pagecache(inode, old_size);
+}
+
 static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -103,8 +114,13 @@ static vm_fault_t f2fs_vm_page_mkwrite(s
 
 	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
 
+	filemap_invalidate_lock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, (folio->index + 1) << PAGE_SHIFT);
+	filemap_invalidate_unlock(inode->i_mapping);
+
 	file_update_time(vmf->vma->vm_file);
 	filemap_invalidate_lock_shared(inode->i_mapping);
+
 	folio_lock(folio);
 	if (unlikely(folio->mapping != inode->i_mapping ||
 			folio_pos(folio) > i_size_read(inode) ||
@@ -1106,6 +1122,8 @@ int f2fs_setattr(struct mnt_idmap *idmap
 		f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
+		if (attr->ia_size > old_size)
+			f2fs_zero_post_eof_page(inode, attr->ia_size);
 		truncate_setsize(inode, attr->ia_size);
 
 		if (attr->ia_size <= old_size)
@@ -1224,6 +1242,10 @@ static int f2fs_punch_hole(struct inode
 	if (ret)
 		return ret;
 
+	filemap_invalidate_lock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, offset + len);
+	filemap_invalidate_unlock(inode->i_mapping);
+
 	pg_start = ((unsigned long long) offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_SHIFT;
 
@@ -1507,6 +1529,8 @@ static int f2fs_do_collapse(struct inode
 	f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	filemap_invalidate_lock(inode->i_mapping);
 
+	f2fs_zero_post_eof_page(inode, offset + len);
+
 	f2fs_lock_op(sbi);
 	f2fs_drop_extent_tree(inode);
 	truncate_pagecache(inode, offset);
@@ -1628,6 +1652,10 @@ static int f2fs_zero_range(struct inode
 	if (ret)
 		return ret;
 
+	filemap_invalidate_lock(mapping);
+	f2fs_zero_post_eof_page(inode, offset + len);
+	filemap_invalidate_unlock(mapping);
+
 	pg_start = ((unsigned long long) offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_SHIFT;
 
@@ -1759,6 +1787,8 @@ static int f2fs_insert_range(struct inod
 	/* avoid gc operation during block exchange */
 	f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	filemap_invalidate_lock(mapping);
+
+	f2fs_zero_post_eof_page(inode, offset + len);
 	truncate_pagecache(inode, offset);
 
 	while (!ret && idx > pg_start) {
@@ -1816,6 +1846,10 @@ static int f2fs_expand_inode_data(struct
 	if (err)
 		return err;
 
+	filemap_invalidate_lock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, offset + len);
+	filemap_invalidate_unlock(inode->i_mapping);
+
 	f2fs_balance_fs(sbi, true);
 
 	pg_start = ((unsigned long long)offset) >> PAGE_SHIFT;
@@ -4846,6 +4880,10 @@ static ssize_t f2fs_write_checks(struct
 	err = file_modified(file);
 	if (err)
 		return err;
+
+	filemap_invalidate_lock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, iocb->ki_pos + iov_iter_count(from));
+	filemap_invalidate_unlock(inode->i_mapping);
 	return count;
 }
 


