Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E93C108F;
	Wed, 30 Sep 2026 19:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794928; cv=none; b=lS6gzN4KOXwlzo+//Zlqdd3Uo1q3t2FhWpD4aO6WMq9eeN4uz3opnPjMjmfy8WBOSngXmoAmVtJgk791GfNWpC7hJB0B9gygb48iblkOqQAevVlBWRjNnAobzuz5uKQ+gJqmmxq/bmBDVUgsRmSaEACjbrE3ZMZ7LVb5yuNiw6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794928; c=relaxed/simple;
	bh=cKQNofxO6VjpnQdPYA4RpgNW3kzBKLI1UGjoPlBH59o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT4UrgF7jjS6pbobE6gqkxVqTpAol2TxQSwtHBVMYD6wpjrxuKuIufPW8fNQPbKAgKai416We5qxmwJkLDKZhrB5gdVGOX09BOjpKyDFYvb20NfLmyoAl+jiNpjzhe2mXe3/o/I8AWnsgUIEpQK8GdiPmLPaaxiq+DAc9An4FeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhzMjngH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhzMjngH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B151F000FF;
	Wed, 30 Sep 2026 19:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794926;
	bh=ddpWZ6Yi+vz1x93rI8kfsjeXUQqqOf0BLIw17yUIsLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhzMjngH+Af744LUf3rdoTKH1IGR+Q27i4eCyD7NLwhJFlIYMkAzYjB4O34yRUJR5
	 kXJgXk0UGC7yjYQYMOTk6dh/HGfkF39+zIakJdhVP7K1dHFl8niE+Rx6GSAKZJvwWK
	 edhViBRMNjvwW++jX6338/WPE5Q1mR6EIBjkFDws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0383/1193] ufs: Convert ufs_get_page() to ufs_get_folio()
Date: Wed, 30 Sep 2026 17:17:47 +0200
Message-ID: <20260930152442.694728510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 5fe08b1d7e315cb4238ae1afa4a3ec951ae4908e ]

Use the same calling convention as ext2 (see commit 46022375abe8)
so that we can transition to kmap_local in a future patch.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 08edfb34ee9c ("ufs: do not treat unreadable directory blocks as empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/dir.c | 101 ++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 53 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 3f9ffc0c73739..8c7f7ee6d0f83 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -192,19 +192,22 @@ static bool ufs_check_page(struct page *page)
 	return false;
 }
 
-static struct page *ufs_get_page(struct inode *dir, unsigned long n)
+static void *ufs_get_folio(struct inode *dir, unsigned long n,
+		struct folio **foliop)
 {
 	struct address_space *mapping = dir->i_mapping;
 	struct folio *folio = read_mapping_folio(mapping, n, NULL);
+	void *kaddr;
 
 	if (IS_ERR(folio))
-		return &folio->page;
-	kmap(&folio->page);
+		return ERR_CAST(folio);
+	kaddr = kmap(&folio->page);
 	if (unlikely(!folio_test_checked(folio))) {
 		if (!ufs_check_page(&folio->page))
 			goto fail;
 	}
-	return &folio->page;
+	*foliop = folio;
+	return kaddr;
 
 fail:
 	ufs_put_page(&folio->page);
@@ -235,14 +238,14 @@ ufs_next_entry(struct super_block *sb, struct ufs_dir_entry *p)
 
 struct ufs_dir_entry *ufs_dotdot(struct inode *dir, struct page **p)
 {
-	struct page *page = ufs_get_page(dir, 0);
-	struct ufs_dir_entry *de = NULL;
+	struct folio *folio;
+	struct ufs_dir_entry *de = ufs_get_folio(dir, 0, &folio);
+
+	if (IS_ERR(de))
+		return NULL;
+	de = ufs_next_entry(dir->i_sb, de);
+	*p = &folio->page;
 
-	if (!IS_ERR(page)) {
-		de = ufs_next_entry(dir->i_sb,
-				    (struct ufs_dir_entry *)page_address(page));
-		*p = page;
-	}
 	return de;
 }
 
@@ -263,7 +266,7 @@ struct ufs_dir_entry *ufs_find_entry(struct inode *dir, const struct qstr *qstr,
 	unsigned reclen = UFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = dir_pages(dir);
-	struct page *page = NULL;
+	struct folio *folio;
 	struct ufs_inode_info *ui = UFS_I(dir);
 	struct ufs_dir_entry *de;
 
@@ -281,18 +284,17 @@ struct ufs_dir_entry *ufs_find_entry(struct inode *dir, const struct qstr *qstr,
 		start = 0;
 	n = start;
 	do {
-		char *kaddr;
-		page = ufs_get_page(dir, n);
-		if (!IS_ERR(page)) {
-			kaddr = page_address(page);
-			de = (struct ufs_dir_entry *) kaddr;
+		char *kaddr = ufs_get_folio(dir, n, &folio);
+
+		if (!IS_ERR(kaddr)) {
+			de = (struct ufs_dir_entry *)kaddr;
 			kaddr += ufs_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
 				if (ufs_match(sb, namelen, name, de))
 					goto found;
 				de = ufs_next_entry(sb, de);
 			}
-			ufs_put_page(page);
+			ufs_put_page(&folio->page);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -301,7 +303,7 @@ struct ufs_dir_entry *ufs_find_entry(struct inode *dir, const struct qstr *qstr,
 	return NULL;
 
 found:
-	*res_page = page;
+	*res_page = &folio->page;
 	ui->i_dir_start_lookup = n;
 	return de;
 }
@@ -318,11 +320,10 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
 	unsigned reclen = UFS_DIR_REC_LEN(namelen);
 	const unsigned int chunk_size = UFS_SB(sb)->s_uspi->s_dirblksize;
 	unsigned short rec_len, name_len;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct ufs_dir_entry *de;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
-	char *kaddr;
 	loff_t pos;
 	int err;
 
@@ -330,21 +331,19 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
 
 	/*
 	 * We take care of directory expansion in the same loop.
-	 * This code plays outside i_size, so it locks the page
+	 * This code plays outside i_size, so it locks the folio
 	 * to protect that region.
 	 */
 	for (n = 0; n <= npages; n++) {
+		char *kaddr = ufs_get_folio(dir, n, &folio);
 		char *dir_end;
 
-		page = ufs_get_page(dir, n);
-		err = PTR_ERR(page);
-		if (IS_ERR(page))
-			goto out;
-		lock_page(page);
-		kaddr = page_address(page);
+		if (IS_ERR(kaddr))
+			return PTR_ERR(kaddr);
+		folio_lock(folio);
 		dir_end = kaddr + ufs_last_byte(dir, n);
 		de = (struct ufs_dir_entry *)kaddr;
-		kaddr += PAGE_SIZE - reclen;
+		kaddr += folio_size(folio) - reclen;
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
@@ -371,16 +370,15 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
 				goto got_it;
 			de = (struct ufs_dir_entry *) ((char *) de + rec_len);
 		}
-		unlock_page(page);
-		ufs_put_page(page);
+		folio_unlock(folio);
+		ufs_put_page(&folio->page);
 	}
 	BUG();
 	return -EINVAL;
 
 got_it:
-	pos = page_offset(page) +
-			(char*)de - (char*)page_address(page);
-	err = ufs_prepare_chunk(page, pos, rec_len);
+	pos = folio_pos(folio) + offset_in_folio(folio, de);
+	err = ufs_prepare_chunk(&folio->page, pos, rec_len);
 	if (err)
 		goto out_unlock;
 	if (de->d_ino) {
@@ -397,18 +395,17 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
 	de->d_ino = cpu_to_fs32(sb, inode->i_ino);
 	ufs_set_de_type(sb, de, inode->i_mode);
 
-	ufs_commit_chunk(page, pos, rec_len);
+	ufs_commit_chunk(&folio->page, pos, rec_len);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 
 	mark_inode_dirty(dir);
 	err = ufs_handle_dirsync(dir);
 	/* OFFSET_CACHE */
 out_put:
-	ufs_put_page(page);
-out:
+	ufs_put_page(&folio->page);
 	return err;
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 	goto out_put;
 }
 
@@ -446,19 +443,18 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 
 	for ( ; n < npages; n++, offset = 0) {
-		char *kaddr, *limit;
 		struct ufs_dir_entry *de;
+		struct folio *folio;
+		char *kaddr = ufs_get_folio(inode, n, &folio);
+		char *limit;
 
-		struct page *page = ufs_get_page(inode, n);
-
-		if (IS_ERR(page)) {
+		if (IS_ERR(kaddr)) {
 			ufs_error(sb, __func__,
 				  "bad page in #%lu",
 				  inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
-			return -EIO;
+			return PTR_ERR(kaddr);
 		}
-		kaddr = page_address(page);
 		if (unlikely(need_revalidate)) {
 			if (offset) {
 				offset = ufs_validate_entry(sb, kaddr, offset, chunk_mask);
@@ -484,13 +480,13 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 					       ufs_get_de_namlen(sb, de),
 					       fs32_to_cpu(sb, de->d_ino),
 					       d_type)) {
-					ufs_put_page(page);
+					ufs_put_page(&folio->page);
 					return 0;
 				}
 			}
 			ctx->pos += fs16_to_cpu(sb, de->d_reclen);
 		}
-		ufs_put_page(page);
+		ufs_put_page(&folio->page);
 	}
 	return 0;
 }
@@ -601,18 +597,17 @@ int ufs_make_empty(struct inode * inode, struct inode *dir)
 int ufs_empty_dir(struct inode * inode)
 {
 	struct super_block *sb = inode->i_sb;
-	struct page *page = NULL;
+	struct folio *folio;
+	char *kaddr;
 	unsigned long i, npages = dir_pages(inode);
 
 	for (i = 0; i < npages; i++) {
-		char *kaddr;
 		struct ufs_dir_entry *de;
-		page = ufs_get_page(inode, i);
 
-		if (IS_ERR(page))
+		kaddr = ufs_get_folio(inode, i, &folio);
+		if (IS_ERR(kaddr))
 			continue;
 
-		kaddr = page_address(page);
 		de = (struct ufs_dir_entry *)kaddr;
 		kaddr += ufs_last_byte(inode, i) - UFS_DIR_REC_LEN(1);
 
@@ -639,12 +634,12 @@ int ufs_empty_dir(struct inode * inode)
 			}
 			de = ufs_next_entry(sb, de);
 		}
-		ufs_put_page(page);
+		ufs_put_page(&folio->page);
 	}
 	return 1;
 
 not_empty:
-	ufs_put_page(page);
+	ufs_put_page(&folio->page);
 	return 0;
 }
 
-- 
2.53.0



