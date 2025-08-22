Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620161B4141;
	Fri, 22 Aug 2025 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866249; cv=none; b=B/vfEjEfAm0acGZ2B0aS7j6xLmVYeJ16a5a4r5P1uVKRdtbaDS95VloZRI0lT7Byfi5hTsJ5HA9qC3DhwPYrHnIKr0iTSDBirvaqXerFxVlFAHCL2s8yqeTxnaAMzTPogobC1M4sKmc/EN44C+iAFzviCBDQFl1NLlt0qfEE2z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866249; c=relaxed/simple;
	bh=JCYw4chPzkfykbd5Lk+Pgt08lV8YUpKESk+pjw44gd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLX1sDj6Dcu5kUZCjhSufWPwqDAE4lRiC3FERA1eNzPD6rsHHoDfLS8uX4q1P+MiU7c7WELHTBcZTmSlkzsEwYkL6ll8OI28qVUqOi0jv5iZvRlF0GwgSAuLry6QspbO9WJ8GO0fUzhhLXzU0v4qmjPGUZVznqI3qTg6der+WHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zueI/eQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zueI/eQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7636EC4CEED;
	Fri, 22 Aug 2025 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866248;
	bh=JCYw4chPzkfykbd5Lk+Pgt08lV8YUpKESk+pjw44gd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zueI/eQNci48ZzLNLJMFA40tP+RMNVNSpXt+UYE42Rr1zIvwAeQMxta4WS8ZXS6El
	 DHpYe6s/2l1KTQbZw0hpqVq5o7mMVdUVIvNBrff2bA3MKxuLslWVUcrMajzJZga2ds
	 zj179iNwQhrSVqJIfHWWBbP5teKrxVbbJGmNTtGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 4/9] ext4: refactor the block allocation process of ext4_page_mkwrite()
Date: Fri, 22 Aug 2025 14:37:04 +0200
Message-ID: <20250822123516.946374675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
References: <20250822123516.780248736@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 2bddafea3d0d85ee9ac3cf5ba9a4b2f2d2f50257 upstream.

The block allocation process and error handling in ext4_page_mkwrite()
is complex now. Refactor it by introducing a new helper function,
ext4_block_page_mkwrite(). It will call ext4_block_write_begin() to
allocate blocks instead of directly calling block_page_mkwrite().
Preparing to implement retry logic in a subsequent patch to address
situations where the reserved journal credits are insufficient.
Additionally, this modification will help prevent potential deadlocks
that may occur when waiting for folio writeback while holding the
transaction handle.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250707140814.542883-5-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   95 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 45 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6622,6 +6622,53 @@ static int ext4_bh_unmapped(handle_t *ha
 	return !buffer_mapped(bh);
 }
 
+static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
+				   get_block_t get_block)
+{
+	handle_t *handle;
+	loff_t size;
+	unsigned long len;
+	int ret;
+
+	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
+				    ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	folio_lock(folio);
+	size = i_size_read(inode);
+	/* Page got truncated from under us? */
+	if (folio->mapping != inode->i_mapping || folio_pos(folio) > size) {
+		ret = -EFAULT;
+		goto out_error;
+	}
+
+	len = folio_size(folio);
+	if (folio_pos(folio) + len > size)
+		len = size - folio_pos(folio);
+
+	ret = ext4_block_write_begin(handle, folio, 0, len, get_block);
+	if (ret)
+		goto out_error;
+
+	if (!ext4_should_journal_data(inode)) {
+		block_commit_write(folio, 0, len);
+		folio_mark_dirty(folio);
+	} else {
+		ret = ext4_journal_folio_buffers(handle, folio, len);
+		if (ret)
+			goto out_error;
+	}
+	ext4_journal_stop(handle);
+	folio_wait_stable(folio);
+	return ret;
+
+out_error:
+	folio_unlock(folio);
+	ext4_journal_stop(handle);
+	return ret;
+}
+
 vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -6633,8 +6680,7 @@ vm_fault_t ext4_page_mkwrite(struct vm_f
 	struct file *file = vma->vm_file;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
-	handle_t *handle;
-	get_block_t *get_block;
+	get_block_t *get_block = ext4_get_block;
 	int retries = 0;
 
 	if (unlikely(IS_IMMUTABLE(inode)))
@@ -6702,46 +6748,9 @@ vm_fault_t ext4_page_mkwrite(struct vm_f
 	/* OK, we need to fill the hole... */
 	if (ext4_should_dioread_nolock(inode))
 		get_block = ext4_get_block_unwritten;
-	else
-		get_block = ext4_get_block;
 retry_alloc:
-	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
-				    ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = VM_FAULT_SIGBUS;
-		goto out;
-	}
-	/*
-	 * Data journalling can't use block_page_mkwrite() because it
-	 * will set_buffer_dirty() before do_journal_get_write_access()
-	 * thus might hit warning messages for dirty metadata buffers.
-	 */
-	if (!ext4_should_journal_data(inode)) {
-		err = block_page_mkwrite(vma, vmf, get_block);
-	} else {
-		folio_lock(folio);
-		size = i_size_read(inode);
-		/* Page got truncated from under us? */
-		if (folio->mapping != mapping || folio_pos(folio) > size) {
-			ret = VM_FAULT_NOPAGE;
-			goto out_error;
-		}
-
-		len = folio_size(folio);
-		if (folio_pos(folio) + len > size)
-			len = size - folio_pos(folio);
-
-		err = ext4_block_write_begin(handle, folio, 0, len,
-					     ext4_get_block);
-		if (!err) {
-			ret = VM_FAULT_SIGBUS;
-			if (ext4_journal_folio_buffers(handle, folio, len))
-				goto out_error;
-		} else {
-			folio_unlock(folio);
-		}
-	}
-	ext4_journal_stop(handle);
+	/* Start journal and allocate blocks */
+	err = ext4_block_page_mkwrite(inode, folio, get_block);
 	if (err == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry_alloc;
 out_ret:
@@ -6750,8 +6759,4 @@ out:
 	filemap_invalidate_unlock_shared(mapping);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
-out_error:
-	folio_unlock(folio);
-	ext4_journal_stop(handle);
-	goto out;
 }


