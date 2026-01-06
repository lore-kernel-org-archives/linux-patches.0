Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E58A27FD76;
	Tue,  6 Jan 2026 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721908; cv=none; b=RghE08mEthg/I8fOI3GhI08Y2+XLbSJcMnjfHWUtZ00fr1roux4CjrU9FGZK6Pv1ZhRonYb6giCdKht0ZyF2dCmGaVVp7FDG5FEnsnQLiiFUXtXVK/sqdrn/3sc3vynMD3QDneXcA+3wbO61KpO9GUb8pgSQk+LGKLrYONJWfrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721908; c=relaxed/simple;
	bh=/ODFcD4JNktW031ZihyfpJDvwvMOGnulM1FlMi6I6xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0QPVcxCjLvdaN7e6+at+nQ1nEain6e/1YX2mG1ERCQFQZO6ywU+EKJQSv26PcSx7hVgbK5I+G6dyO43JlkGF+fmMBx5OjZKDA/0oljdKt0aEPH4qM/phWBa611229Gp+PIcUp1r7zN0BAfGjbOcA/6dirsSeVrYVIkjIpRsjRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbz0uI1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbz0uI1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5351BC116C6;
	Tue,  6 Jan 2026 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721907;
	bh=/ODFcD4JNktW031ZihyfpJDvwvMOGnulM1FlMi6I6xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dbz0uI1ackOBngf2thMqTf9XVDmS8jUdaYueZfSZ7QG/QWZow00xCpKvz7owLKUBn
	 ESZMWmwmzfLb3QxrsP12exVKHehPRSl1oFyrk3tO6bZye3iU3cahti2MKuQzcnHdUE
	 Jruyautnm1bdW4teEg8KsEgNWhtFV3gzckCOSpSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 090/312] ntfs: Do not overwrite uptodate pages
Date: Tue,  6 Jan 2026 18:02:44 +0100
Message-ID: <20260106170551.091061055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 68f6bd128e75a032432eda9d16676ed2969a1096 upstream.

When reading a compressed file, we may read several pages in addition to
the one requested.  The current code will overwrite pages in the page
cache with the data from disc which can definitely result in changes
that have been made being lost.

For example if we have four consecutie pages ABCD in the file compressed
into a single extent, on first access, we'll bring in ABCD.  Then we
write to page B.  Memory pressure results in the eviction of ACD.
When we attempt to write to page C, we will overwrite the data in page
B with the data currently on disk.

I haven't investigated the decompression code to check whether it's
OK to overwrite a clean page or whether it might be possible to see
corrupt data.  Out of an abundance of caution, decline to overwrite
uptodate pages, not just dirty pages.

Fixes: 4342306f0f0d (fs/ntfs3: Add file operations and implementation)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/frecord.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2022,6 +2022,29 @@ out:
 	return err;
 }
 
+static struct page *ntfs_lock_new_page(struct address_space *mapping,
+		pgoff_t index, gfp_t gfp)
+{
+	struct folio *folio = __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
+	struct page *page;
+
+	if (IS_ERR(folio))
+		return ERR_CAST(folio);
+
+	if (!folio_test_uptodate(folio))
+		return folio_file_page(folio, index);
+
+	/* Use a temporary page to avoid data corruption */
+	folio_unlock(folio);
+	folio_put(folio);
+	page = alloc_page(gfp);
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+	__SetPageLocked(page);
+	return page;
+}
+
 /*
  * ni_readpage_cmpr
  *
@@ -2076,9 +2099,9 @@ int ni_readpage_cmpr(struct ntfs_inode *
 		if (i == idx)
 			continue;
 
-		pg = find_or_create_page(mapping, index, gfp_mask);
-		if (!pg) {
-			err = -ENOMEM;
+		pg = ntfs_lock_new_page(mapping, index, gfp_mask);
+		if (IS_ERR(pg)) {
+			err = PTR_ERR(pg);
 			goto out1;
 		}
 		pages[i] = pg;
@@ -2177,13 +2200,13 @@ int ni_decompress_file(struct ntfs_inode
 		for (i = 0; i < pages_per_frame; i++, index++) {
 			struct page *pg;
 
-			pg = find_or_create_page(mapping, index, gfp_mask);
-			if (!pg) {
+			pg = ntfs_lock_new_page(mapping, index, gfp_mask);
+			if (IS_ERR(pg)) {
 				while (i--) {
 					unlock_page(pages[i]);
 					put_page(pages[i]);
 				}
-				err = -ENOMEM;
+				err = PTR_ERR(pg);
 				goto out;
 			}
 			pages[i] = pg;


