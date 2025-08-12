Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6042FDC59;
	Tue, 12 Aug 2025 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024836; cv=none; b=RqIGNC85UJeepHImmBwO3F1KXHAWzJ8yYEZa0xpi0oF4/ecyz32/I96zxKUJ6zsy/tiQtvkjQzg+TuTqEh2eK59ZGG4mshLULuN4DnJHIVc/4yPoQmlx7Tp4sl7jCkSkUFppgJnI4IE27ptqnqr6rCRaYrdrTniY9L3+JUBfgFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024836; c=relaxed/simple;
	bh=Fnxe8e7cvN5nSzY8mkCXBdteuM+1i3GogdbvA+QuMMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8T/PBxGPtJ04IU9A2Msi3+ffx0fhYsNaNEmVXUpqH3hkBG9rqHFuGAaNgbNu8PYVBH8R0X3djEUTyYbYaSyweXcYmvIXNVbrkHyAa/W9RkG/2NO6miaBfPXS3I/yh/5h7iw2jaOERwUDMfAEgkj71Xxn3BtdkXxRxlqNSjJjec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwFoyRYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwFoyRYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA015C4CEF0;
	Tue, 12 Aug 2025 18:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024836;
	bh=Fnxe8e7cvN5nSzY8mkCXBdteuM+1i3GogdbvA+QuMMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwFoyRYviD91wDQ8e1CMVSbKxTBEc7CSsvJWVPD2fSlqw2mmgR8WK0FsD13HnfL3Q
	 F1hpf4mCf57oPd4tZxDKNJxG5SuEZ4aq+3NUW1hQORA8yVLxhUmuru5XiXR4H3CxZ7
	 GK/rXwsggOGi2qZcx0UZwqJWKZIXR0R7HxQLHy3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 458/627] squashfs: use folios in squashfs_bio_read_cached()
Date: Tue, 12 Aug 2025 19:32:33 +0200
Message-ID: <20250812173438.640193240@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit c9e3fb050e9cb0d3a833b2c62b35ea42cdd81e89 ]

Remove an access to page->mapping and a few calls to the old page-based
APIs.  This doesn't support large folios, but it's still a nice
improvement.

Link: https://lkml.kernel.org/r/20250612143903.2849289-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 97103dcec292 ("squashfs: fix incorrect argument to sizeof in kmalloc_array call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/block.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 3061043e915c..296c5a0fcc40 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -80,23 +80,22 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 		struct address_space *cache_mapping, u64 index, int length,
 		u64 read_start, u64 read_end, int page_count)
 {
-	struct page *head_to_cache = NULL, *tail_to_cache = NULL;
+	struct folio *head_to_cache = NULL, *tail_to_cache = NULL;
 	struct block_device *bdev = fullbio->bi_bdev;
 	int start_idx = 0, end_idx = 0;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;;
 	struct bio *bio = NULL;
-	struct bio_vec *bv;
 	int idx = 0;
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
-	struct page **cache_pages = kmalloc_array(page_count,
+	struct folio **cache_folios = kmalloc_array(page_count,
 			sizeof(void *), GFP_KERNEL | __GFP_ZERO);
 #endif
 
-	bio_for_each_segment_all(bv, fullbio, iter_all) {
-		struct page *page = bv->bv_page;
+	bio_for_each_folio_all(fi, fullbio) {
+		struct folio *folio = fi.folio;
 
-		if (page->mapping == cache_mapping) {
+		if (folio->mapping == cache_mapping) {
 			idx++;
 			continue;
 		}
@@ -111,13 +110,13 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 		 * adjacent blocks.
 		 */
 		if (idx == 0 && index != read_start)
-			head_to_cache = page;
+			head_to_cache = folio;
 		else if (idx == page_count - 1 && index + length != read_end)
-			tail_to_cache = page;
+			tail_to_cache = folio;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 		/* Cache all pages in the BIO for repeated reads */
-		else if (cache_pages)
-			cache_pages[idx] = page;
+		else if (cache_folios)
+			cache_folios[idx] = folio;
 #endif
 
 		if (!bio || idx != end_idx) {
@@ -150,45 +149,45 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 		return err;
 
 	if (head_to_cache) {
-		int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
+		int ret = filemap_add_folio(cache_mapping, head_to_cache,
 						read_start >> PAGE_SHIFT,
 						GFP_NOIO);
 
 		if (!ret) {
-			SetPageUptodate(head_to_cache);
-			unlock_page(head_to_cache);
+			folio_mark_uptodate(head_to_cache);
+			folio_unlock(head_to_cache);
 		}
 
 	}
 
 	if (tail_to_cache) {
-		int ret = add_to_page_cache_lru(tail_to_cache, cache_mapping,
+		int ret = filemap_add_folio(cache_mapping, tail_to_cache,
 						(read_end >> PAGE_SHIFT) - 1,
 						GFP_NOIO);
 
 		if (!ret) {
-			SetPageUptodate(tail_to_cache);
-			unlock_page(tail_to_cache);
+			folio_mark_uptodate(tail_to_cache);
+			folio_unlock(tail_to_cache);
 		}
 	}
 
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
-	if (!cache_pages)
+	if (!cache_folios)
 		goto out;
 
 	for (idx = 0; idx < page_count; idx++) {
-		if (!cache_pages[idx])
+		if (!cache_folios[idx])
 			continue;
-		int ret = add_to_page_cache_lru(cache_pages[idx], cache_mapping,
+		int ret = filemap_add_folio(cache_mapping, cache_folios[idx],
 						(read_start >> PAGE_SHIFT) + idx,
 						GFP_NOIO);
 
 		if (!ret) {
-			SetPageUptodate(cache_pages[idx]);
-			unlock_page(cache_pages[idx]);
+			folio_mark_uptodate(cache_folios[idx]);
+			folio_unlock(cache_folios[idx]);
 		}
 	}
-	kfree(cache_pages);
+	kfree(cache_folios);
 out:
 #endif
 	return 0;
-- 
2.39.5



