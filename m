Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC78C2D9484;
	Tue,  6 Jan 2026 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720801; cv=none; b=mckXZsQ/IWoiLDKIzEXc023v6J8C76vHvCwVZPjL3E+OUXJSTMKaVfjLe6b81Y++bFrud3AhbdUrrtndl4OETO8M1FxE8pMmSpZZjfsNGOIabtnCgu14CY9qE8MiG35WO15AFO4OHljbuUgHMZfDlxJucGIobL9I56mtSlwUG8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720801; c=relaxed/simple;
	bh=YHfFApiO7/eT7c+cZoJvISt9yyNyDOTxlt6Gk3w9TYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCC9SPilxFbQwnbuVUO8NjcliH2c8I/l5mlO1aiyZFsP+BmcVqaxFdMFzAwbJWAakK4gsmw2Hm+tRG7BjoSLbjKXotDeqnKxaza6Xy8Cn/DJf1+nsFYXbzwMw6T++VkIKCAhuCL7PHeYBHr3jBzTnJ1CyhouehPIa05liT2R/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aus4P7wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aus4P7wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9846CC116C6;
	Tue,  6 Jan 2026 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720801;
	bh=YHfFApiO7/eT7c+cZoJvISt9yyNyDOTxlt6Gk3w9TYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aus4P7wqsPmq9uyLvBeUoH3z5A3lcBK4Pletv+yimTbMbWXamfC4b/0uJbZkT8Vch
	 pugGzaLGnY2WjedARebTOodL9AHdKEsXAailOve6Vv0OZmPX7hI1IMDVM/9F8oyaPR
	 hv4gN3Xbw1aW1PiFoSjAtkMtSQDeaBzWCTpBivkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 344/567] ntfs: Do not overwrite uptodate pages
Date: Tue,  6 Jan 2026 18:02:06 +0100
Message-ID: <20260106170504.052226282@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -2077,6 +2077,29 @@ out:
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
@@ -2131,9 +2154,9 @@ int ni_readpage_cmpr(struct ntfs_inode *
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
@@ -2232,13 +2255,13 @@ int ni_decompress_file(struct ntfs_inode
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


