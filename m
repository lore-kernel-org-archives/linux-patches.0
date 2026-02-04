Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473D41B359;
	Wed,  4 Feb 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218875; cv=none; b=HcUEihASn9gomqgHLw7l3+x9OkBLz/jfxKGDVgFbdBpVk2BVO2DugjtGEQt1x4bOGgMyfTOlETVi8fXTPHPdGLJddIyv/a2F4+tlXF3YSpZzmWob5/oRr0jqKh/dbhQHqFe8nIXCj/8r8RBOds0LErwyf/9cHsIi88c/cvkLeDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218875; c=relaxed/simple;
	bh=pi9r363L69W1AmsUYJTlQkA3iU+g1dQ6lys/ckmOajY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/xhkZIDZSXqS6DvevFKYfXYqzbZ65M47yUGgMrT/O6cT/ZyahASqodWCMLu+K9KcI4g3kJY4usyPmgo63O8LbLn5rHOHBzO3wEvzvDrvkHDc0FAD3psYz5+dv+0McOakct91f8GknDN6ecrwjeovXSa5p7mfF+Oud4/Mffcf8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiOgs2ZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiOgs2ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25DBC4CEF7;
	Wed,  4 Feb 2026 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218875;
	bh=pi9r363L69W1AmsUYJTlQkA3iU+g1dQ6lys/ckmOajY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiOgs2ZFU1QrWBYpJNtrgoyhIPE3nEOOmnaBKf8ZB3Mr9CPTFsSox5dCMRk6n3jag
	 dY+fyCRIu7Y4TLWYKo4zDyhLA5amRUOXilTqVTjEM8MgXwjuraEB+XAOAmTFYxRlMc
	 kJOev/ZgnpYVAa3e/X0IqxRavYpOqhk7h46uV7Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 54/87] mm/shmem, swap: fix race of truncate and swap entry split
Date: Wed,  4 Feb 2026 15:40:52 +0100
Message-ID: <20260204143848.861408330@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Kairui Song <kasong@tencent.com>

commit 8a1968bd997f45a9b11aefeabdd1232e1b6c7184 upstream.

The helper for shmem swap freeing is not handling the order of swap
entries correctly.  It uses xa_cmpxchg_irq to erase the swap entry, but it
gets the entry order before that using xa_get_order without lock
protection, and it may get an outdated order value if the entry is split
or changed in other ways after the xa_get_order and before the
xa_cmpxchg_irq.

And besides, the order could grow and be larger than expected, and cause
truncation to erase data beyond the end border.  For example, if the
target entry and following entries are swapped in or freed, then a large
folio was added in place and swapped out, using the same entry, the
xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.

To fix that, open code the Xarray cmpxchg and put the order retrieval and
value checking in the same critical section.  Also, ensure the order won't
exceed the end border, skip it if the entry goes across the border.

Skipping large swap entries crosses the end border is safe here.  Shmem
truncate iterates the range twice, in the first iteration,
find_lock_entries already filtered such entries, and shmem will swapin the
entries that cross the end border and partially truncate the folio (split
the folio or at least zero part of it).  So in the second loop here, if we
see a swap entry that crosses the end order, it must at least have its
content erased already.

I observed random swapoff hangs and kernel panics when stress testing
ZSWAP with shmem.  After applying this patch, all problems are gone.

Link: https://lkml.kernel.org/r/20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -860,17 +860,29 @@ static void shmem_delete_from_page_cache
  * being freed).
  */
 static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, void *radswap)
+			    pgoff_t index, pgoff_t end, void *radswap)
 {
-	int order = xa_get_order(&mapping->i_pages, index);
-	void *old;
+	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned int nr_pages = 0;
+	pgoff_t base;
+	void *entry;
+
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (entry == radswap) {
+		nr_pages = 1 << xas_get_order(&xas);
+		base = round_down(xas.xa_index, nr_pages);
+		if (base < index || base + nr_pages - 1 > end)
+			nr_pages = 0;
+		else
+			xas_store(&xas, NULL);
+	}
+	xas_unlock_irq(&xas);
 
-	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
-	if (old != radswap)
-		return 0;
-	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+	if (nr_pages)
+		free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pages);
 
-	return 1 << order;
+	return nr_pages;
 }
 
 /*
@@ -1022,8 +1034,8 @@ static void shmem_undo_range(struct inod
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping,
-							indices[i], folio);
+				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
+								  end - 1, folio);
 				continue;
 			}
 
@@ -1089,12 +1101,23 @@ whole_folios:
 			folio = fbatch.folios[i];
 
 			if (xa_is_value(folio)) {
+				int order;
 				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				swaps_freed = shmem_free_swap(mapping, indices[i],
+							      end - 1, folio);
 				if (!swaps_freed) {
+					/*
+					 * If found a large swap entry cross the end border,
+					 * skip it as the truncate_inode_partial_folio above
+					 * should have at least zerod its content once.
+					 */
+					order = shmem_confirm_swap(mapping, indices[i],
+								   radix_to_swp_entry(folio));
+					if (order > 0 && indices[i] + (1 << order) > end)
+						continue;
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;


