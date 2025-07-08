Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EDE22259B;
	Tue,  8 Jul 2025 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992395; cv=none; b=jtRp20MfPEUb8GSmYnhB5HqJchXb+7wiYFV5vt/aKrN4XKg27/zld+x7sX2jgSYOVNR56VRGvc5ZMTRrsvtjJlCrx/uBzfEWimLsjp5qHqGKj72YxuuNCY3y1W6m0LGmVaY6CugTL3h8uCii8OkUkI1waQ6e6Y7rGMd3yZEBiZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992395; c=relaxed/simple;
	bh=LGMvfiR0nIAKXeA6NUlth+jJylH3eciaBzrqjyjrNSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab2SnQybp/sMtjjI8L9LbyB/82119BZxcrB4grqsL4Yaa+wA9QAqEW4wX9BHqzpw4CDG2eOd3i9mS4HnPj41HTXGXMWVWYWKXsvu9sRNvH5XBAk+qP+EYAFd1yk/n/w42tjcvbyxKo8eLAQ88irfveFWTQ0fPzzv2F7xPBzD7p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcPeT3A0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcPeT3A0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC5C4CEED;
	Tue,  8 Jul 2025 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992394;
	bh=LGMvfiR0nIAKXeA6NUlth+jJylH3eciaBzrqjyjrNSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcPeT3A0VZGCKExqeG9eeZPpVOL/dbaJRlL8Vo8Mphc7NhIQ+ASoNW61BeU+EenPw
	 fxdyq7FX1mAa43u9nBDibuEhf+UW2vYYS7cIBolmCwsmU06SxufQkxDd0PFrDk2A+F
	 nNs9t8aUTou+gOp42w+6YgZeb+E7bPk/E+RLyE38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/132] f2fs: convert f2fs_vm_page_mkwrite() to use folio
Date: Tue,  8 Jul 2025 18:23:06 +0200
Message-ID: <20250708162232.832240977@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit aec5755951b74e3bbb5ddee39ac142a788547854 ]

Convert to use folio, so that we can get rid of 'page->index' to
prepare for removal of 'index' field in structure page [1].

[1] https://lore.kernel.org/all/Zp8fgUSIBGQ1TN0D@casper.infradead.org/

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2eff37cc37601..121849a4dcfda 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -53,7 +53,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 
 static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 {
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
@@ -85,7 +85,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	if (f2fs_compressed_file(inode)) {
-		int ret = f2fs_is_compressed_cluster(inode, page->index);
+		int ret = f2fs_is_compressed_cluster(inode, folio->index);
 
 		if (ret < 0) {
 			err = ret;
@@ -105,11 +105,11 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 	file_update_time(vmf->vma->vm_file);
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	lock_page(page);
-	if (unlikely(page->mapping != inode->i_mapping ||
-			page_offset(page) > i_size_read(inode) ||
-			!PageUptodate(page))) {
-		unlock_page(page);
+	folio_lock(folio);
+	if (unlikely(folio->mapping != inode->i_mapping ||
+			folio_pos(folio) > i_size_read(inode) ||
+			!folio_test_uptodate(folio))) {
+		folio_unlock(folio);
 		err = -EFAULT;
 		goto out_sem;
 	}
@@ -117,9 +117,9 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	if (need_alloc) {
 		/* block allocation */
-		err = f2fs_get_block_locked(&dn, page->index);
+		err = f2fs_get_block_locked(&dn, folio->index);
 	} else {
-		err = f2fs_get_dnode_of_data(&dn, page->index, LOOKUP_NODE);
+		err = f2fs_get_dnode_of_data(&dn, folio->index, LOOKUP_NODE);
 		f2fs_put_dnode(&dn);
 		if (f2fs_is_pinned_file(inode) &&
 		    !__is_valid_data_blkaddr(dn.data_blkaddr))
@@ -127,11 +127,11 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	}
 
 	if (err) {
-		unlock_page(page);
+		folio_unlock(folio);
 		goto out_sem;
 	}
 
-	f2fs_wait_on_page_writeback(page, DATA, false, true);
+	f2fs_wait_on_page_writeback(folio_page(folio, 0), DATA, false, true);
 
 	/* wait for GCed page writeback via META_MAPPING */
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
@@ -139,18 +139,18 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	/*
 	 * check to see if the page is mapped already (no holes)
 	 */
-	if (PageMappedToDisk(page))
+	if (folio_test_mappedtodisk(folio))
 		goto out_sem;
 
 	/* page is wholly or partially inside EOF */
-	if (((loff_t)(page->index + 1) << PAGE_SHIFT) >
+	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) >
 						i_size_read(inode)) {
 		loff_t offset;
 
 		offset = i_size_read(inode) & ~PAGE_MASK;
-		zero_user_segment(page, offset, PAGE_SIZE);
+		folio_zero_segment(folio, offset, folio_size(folio));
 	}
-	set_page_dirty(page);
+	folio_mark_dirty(folio);
 
 	f2fs_update_iostat(sbi, inode, APP_MAPPED_IO, F2FS_BLKSIZE);
 	f2fs_update_time(sbi, REQ_TIME);
@@ -162,7 +162,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 out:
 	ret = vmf_fs_error(err);
 
-	trace_f2fs_vm_page_mkwrite(inode, page->index, vmf->vma->vm_flags, ret);
+	trace_f2fs_vm_page_mkwrite(inode, folio->index, vmf->vma->vm_flags, ret);
 	return ret;
 }
 
-- 
2.39.5



