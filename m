Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8710307AF5;
	Mon, 13 Oct 2025 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368412; cv=none; b=FmZPkmPbadjssvnmgQJwmLH64huDFrjeiqsuAuWawuUFfBdOWWK454JCt37swTktxa+IQVU5uK0DTkdxKQfJBWVy5vBlvAJHy3OQhaMG03Ky6nc6coRW0TIGH7tEOq0AWnyDDspRXA9+aiXtBZ83TKjBrIEFJoBkVm7e9/0Zhfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368412; c=relaxed/simple;
	bh=v2F4xZkY3lqBbA80izFl/4GxvQ11w6/qYZcfLPMUnWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gP7NhyW1z9yvPQuk+ePZySm3V1BusH7dENQwxAana2jZ6Shuu+M51rLc2cTjXHdIVAUJAXOdGyuYeLf4CWKAgTD+Z9Blj0kwrxiMt8mCDaKoNmVnduvO1ftj5YFravrUBbroLPZ+VwGxjuusSiN+VeRVDu30HdBTdr+C29VHa3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3FsMxxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3FsMxxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD55C4CEE7;
	Mon, 13 Oct 2025 15:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368411;
	bh=v2F4xZkY3lqBbA80izFl/4GxvQ11w6/qYZcfLPMUnWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3FsMxxux4/9YHmSBu2CYmErxE6ayeecIsuynA0TCBHjHYbH0gqBgprtMknuVYRiI
	 UpkNptX/0oyM4o5k4q4a4ZbGciSKAuXvgT5CprVUUbh2hf906zrWlPJLOtsI1IXoMY
	 J7Bg9PYFF6uO1KLtaRxt7imGd0QOsfrAZLDIpk2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/262] f2fs: fix to mitigate overhead of f2fs_zero_post_eof_page()
Date: Mon, 13 Oct 2025 16:44:55 +0200
Message-ID: <20251013144331.630209138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit c2f7c32b254006ad48f8e4efb2e7e7bf71739f17 ]

f2fs_zero_post_eof_page() may cuase more overhead due to invalidate_lock
and page lookup, change as below to mitigate its overhead:
- check new_size before grabbing invalidate_lock
- lookup and invalidate pages only in range of [old_size, new_size]

Fixes: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index eb58d05284173..2a108c561e8bc 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -35,15 +35,23 @@
 #include <trace/events/f2fs.h>
 #include <uapi/linux/f2fs.h>
 
-static void f2fs_zero_post_eof_page(struct inode *inode, loff_t new_size)
+static void f2fs_zero_post_eof_page(struct inode *inode,
+					loff_t new_size, bool lock)
 {
 	loff_t old_size = i_size_read(inode);
 
 	if (old_size >= new_size)
 		return;
 
+	if (mapping_empty(inode->i_mapping))
+		return;
+
+	if (lock)
+		filemap_invalidate_lock(inode->i_mapping);
 	/* zero or drop pages only in range of [old_size, new_size] */
-	truncate_pagecache(inode, old_size);
+	truncate_inode_pages_range(inode->i_mapping, old_size, new_size);
+	if (lock)
+		filemap_invalidate_unlock(inode->i_mapping);
 }
 
 static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
@@ -114,9 +122,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
 
-	filemap_invalidate_lock(inode->i_mapping);
-	f2fs_zero_post_eof_page(inode, (folio->index + 1) << PAGE_SHIFT);
-	filemap_invalidate_unlock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, (folio->index + 1) << PAGE_SHIFT, true);
 
 	file_update_time(vmf->vma->vm_file);
 	filemap_invalidate_lock_shared(inode->i_mapping);
@@ -1089,7 +1095,7 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		filemap_invalidate_lock(inode->i_mapping);
 
 		if (attr->ia_size > old_size)
-			f2fs_zero_post_eof_page(inode, attr->ia_size);
+			f2fs_zero_post_eof_page(inode, attr->ia_size, false);
 		truncate_setsize(inode, attr->ia_size);
 
 		if (attr->ia_size <= old_size)
@@ -1208,9 +1214,7 @@ static int f2fs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
-	filemap_invalidate_lock(inode->i_mapping);
-	f2fs_zero_post_eof_page(inode, offset + len);
-	filemap_invalidate_unlock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, offset + len, true);
 
 	pg_start = ((unsigned long long) offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_SHIFT;
@@ -1495,7 +1499,7 @@ static int f2fs_do_collapse(struct inode *inode, loff_t offset, loff_t len)
 	f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	filemap_invalidate_lock(inode->i_mapping);
 
-	f2fs_zero_post_eof_page(inode, offset + len);
+	f2fs_zero_post_eof_page(inode, offset + len, false);
 
 	f2fs_lock_op(sbi);
 	f2fs_drop_extent_tree(inode);
@@ -1618,9 +1622,7 @@ static int f2fs_zero_range(struct inode *inode, loff_t offset, loff_t len,
 	if (ret)
 		return ret;
 
-	filemap_invalidate_lock(mapping);
-	f2fs_zero_post_eof_page(inode, offset + len);
-	filemap_invalidate_unlock(mapping);
+	f2fs_zero_post_eof_page(inode, offset + len, true);
 
 	pg_start = ((unsigned long long) offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_SHIFT;
@@ -1754,7 +1756,7 @@ static int f2fs_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 	filemap_invalidate_lock(mapping);
 
-	f2fs_zero_post_eof_page(inode, offset + len);
+	f2fs_zero_post_eof_page(inode, offset + len, false);
 	truncate_pagecache(inode, offset);
 
 	while (!ret && idx > pg_start) {
@@ -1812,9 +1814,7 @@ static int f2fs_expand_inode_data(struct inode *inode, loff_t offset,
 	if (err)
 		return err;
 
-	filemap_invalidate_lock(inode->i_mapping);
-	f2fs_zero_post_eof_page(inode, offset + len);
-	filemap_invalidate_unlock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode, offset + len, true);
 
 	f2fs_balance_fs(sbi, true);
 
@@ -4759,9 +4759,8 @@ static ssize_t f2fs_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (err)
 		return err;
 
-	filemap_invalidate_lock(inode->i_mapping);
-	f2fs_zero_post_eof_page(inode, iocb->ki_pos + iov_iter_count(from));
-	filemap_invalidate_unlock(inode->i_mapping);
+	f2fs_zero_post_eof_page(inode,
+		iocb->ki_pos + iov_iter_count(from), true);
 	return count;
 }
 
-- 
2.51.0



