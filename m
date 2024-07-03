Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1110017556B;
	Wed,  3 Jul 2024 11:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004441; cv=none; b=QdPcQ/6YhqYfW6FT9sSTIwKTmgif2MRmFm0FClKkg+1XEwJxiyu6/YKskOcDsjg6qgMBI5C0R31VxCAIK6uxAeJewHn8GCUir4CwmpjnLq77o1BHlFifXO0zU3XxnxeHfdC3MUbJIHSYzFzR1oTdUZUOfB40r7Y5o1KoaFdcHzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004441; c=relaxed/simple;
	bh=9ObhN3MXgFXR0kHKPpRzqo9+R5mllAWX1qzRf4iL98k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVDyYXTo5Zv/SzwDlb3es7VGXNlz3s4lqDaUm5alByR/YKldHFWCK5ye2xVfiHxrKIkDoAeFnxlGy2CD+eMxthvmo+9wdP0gossNGNeBJYZhTGwFPshiB15SFU+ZRQ6izo+B06v+BJGsT46duLeIun7HXiJDMxmva5qIEQlNFFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8uNIz+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8uNIz+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42513C4AF0C;
	Wed,  3 Jul 2024 11:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004440;
	bh=9ObhN3MXgFXR0kHKPpRzqo9+R5mllAWX1qzRf4iL98k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8uNIz+9PA6DaG9c5AI8PoksrMTuQ2sh4J1LP2SSJxijjptKMiSP/P+7wKoFATNsq
	 7+muAGQznC159lmfu+9foOYA1sp3pFecWsyJHEzrrrX8yVcVcTeOyl5cBIZKwGQGTI
	 R9bhG7XDl1/Be7lTbq1v97ZzsOslpy26wZqy3S1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/290] nilfs2: return the mapped address from nilfs_get_page()
Date: Wed,  3 Jul 2024 12:37:03 +0200
Message-ID: <20240703102905.788636614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 24cfe9db66e02..22f1f75a90c1a 100644
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



