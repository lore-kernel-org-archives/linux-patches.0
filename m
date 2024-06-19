Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097AC143C58;
	Wed, 19 Jun 2024 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802084; cv=none; b=Mf6GHKWdnkcwkPaeEzHtQIor/C5iTbFN7b/+5Ekot5rjvvQL/gu7oOF2EkUuqh+fpPbk2zD4K+49iEo+H+OYtPoTLhj7+enxS+UpL+RazywtUTj9++4cjXSv9klvJIpSCNzuudzv1psFYVYrnQqNuBETuez4uVgo4cfMZQ8RpAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802084; c=relaxed/simple;
	bh=LVg08ReBNXHbs9R8JcStNBx84PJ2D/PdFUdeKvQUacs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH8HYpvMWSOhxfaxriv2+mAAwgEzczb8GGxIMSP8AWru7sffZ7Un/JxuIOyCSbSSsen3BfkrgFn5mrziJYTDiGmgTMx6rdabdLB+BXZG25BN4CSP2+UlmRyYwJwMBc+Upt+utE6J5K9LZEi2iLmXHP8GbfcT66A99AX3Fo0Zkr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHL/pIME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHL/pIME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8095FC2BBFC;
	Wed, 19 Jun 2024 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802083;
	bh=LVg08ReBNXHbs9R8JcStNBx84PJ2D/PdFUdeKvQUacs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHL/pIMEQPYHS9S50ZWeet+tVtbJSmcFqEKBwEul+VLZ/g6l0EJZ8R3ENNx0Bt6ew
	 Im15+Rbt/3qQlcyupBiKLu2B0oE3+gIa/lxwkr84YUb0bHyVC9gswTaNx/LMwz/DnR
	 7VqAg81XPzhlAV7HJy+o0474f8/BOJDohgyh+FOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/267] nilfs2: return the mapped address from nilfs_get_page()
Date: Wed, 19 Jun 2024 14:53:47 +0200
Message-ID: <20240619125609.271605990@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 09a46acb3697e50548bb265afa1d79163659dd85 ]

In prepartion for switching from kmap() to kmap_local(), return the kmap
address from nilfs_get_page() instead of having the caller look up
page_address().

[konishi.ryusuke: fixed a missing blank line after declaration]
Link: https://lkml.kernel.org/r/20231127143036.2425-7-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7373a51e7998 ("nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 57 +++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 929edc0b101a0..c6b88be8a9d73 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -186,19 +186,24 @@ static bool nilfs_check_page(struct page *page)
 	return false;
 }
 
-static struct page *nilfs_get_page(struct inode *dir, unsigned long n)
+static void *nilfs_get_page(struct inode *dir, unsigned long n,
+		struct page **pagep)
 {
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page = read_mapping_page(mapping, n, NULL);
+	void *kaddr;
 
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (unlikely(!PageChecked(page))) {
-			if (!nilfs_check_page(page))
-				goto fail;
-		}
+	if (IS_ERR(page))
+		return page;
+
+	kaddr = kmap(page);
+	if (unlikely(!PageChecked(page))) {
+		if (!nilfs_check_page(page))
+			goto fail;
 	}
-	return page;
+
+	*pagep = page;
+	return kaddr;
 
 fail:
 	nilfs_put_page(page);
@@ -275,14 +280,14 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
 		struct nilfs_dir_entry *de;
-		struct page *page = nilfs_get_page(inode, n);
+		struct page *page;
 
-		if (IS_ERR(page)) {
+		kaddr = nilfs_get_page(inode, n, &page);
+		if (IS_ERR(kaddr)) {
 			nilfs_error(sb, "bad page in #%lu", inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return -EIO;
 		}
-		kaddr = page_address(page);
 		de = (struct nilfs_dir_entry *)(kaddr + offset);
 		limit = kaddr + nilfs_last_byte(inode, n) -
 			NILFS_DIR_REC_LEN(1);
@@ -345,11 +350,9 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 		start = 0;
 	n = start;
 	do {
-		char *kaddr;
+		char *kaddr = nilfs_get_page(dir, n, &page);
 
-		page = nilfs_get_page(dir, n);
-		if (!IS_ERR(page)) {
-			kaddr = page_address(page);
+		if (!IS_ERR(kaddr)) {
 			de = (struct nilfs_dir_entry *)kaddr;
 			kaddr += nilfs_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
@@ -387,15 +390,11 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct page **p)
 {
-	struct page *page = nilfs_get_page(dir, 0);
-	struct nilfs_dir_entry *de = NULL;
+	struct nilfs_dir_entry *de = nilfs_get_page(dir, 0, p);
 
-	if (!IS_ERR(page)) {
-		de = nilfs_next_entry(
-			(struct nilfs_dir_entry *)page_address(page));
-		*p = page;
-	}
-	return de;
+	if (IS_ERR(de))
+		return NULL;
+	return nilfs_next_entry(de);
 }
 
 ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
@@ -459,12 +458,11 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	for (n = 0; n <= npages; n++) {
 		char *dir_end;
 
-		page = nilfs_get_page(dir, n);
-		err = PTR_ERR(page);
-		if (IS_ERR(page))
+		kaddr = nilfs_get_page(dir, n, &page);
+		err = PTR_ERR(kaddr);
+		if (IS_ERR(kaddr))
 			goto out;
 		lock_page(page);
-		kaddr = page_address(page);
 		dir_end = kaddr + nilfs_last_byte(dir, n);
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += PAGE_SIZE - reclen;
@@ -627,11 +625,10 @@ int nilfs_empty_dir(struct inode *inode)
 		char *kaddr;
 		struct nilfs_dir_entry *de;
 
-		page = nilfs_get_page(inode, i);
-		if (IS_ERR(page))
+		kaddr = nilfs_get_page(inode, i, &page);
+		if (IS_ERR(kaddr))
 			continue;
 
-		kaddr = page_address(page);
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);
 
-- 
2.43.0



