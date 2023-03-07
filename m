Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E21EBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9EAC433D2;
	Tue,  7 Mar 2023 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211754;
	bh=C6Jb8GuZ6EnaP69aGvMRAWY44ofFFPCDNwL7OKR1eu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNvcjxCfNIiPVmdAzmOCOkYjnEwWd88cQMHXzz6lYWm20/8/cFa69w8GfqfnpXKGJ
	 QYEILSPEKKv0ggbFX0pEBwKOh8M6S9akiHsxKea9o6KSTD5FJCIwNblCkVz0V+6HMK
	 Ha6qOduDsMAr1mhel2RUlWqrFXwcW4sm2WQeEg14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Minchan Kim <minchan@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 0934/1001] mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON
Date: Tue,  7 Mar 2023 18:01:46 +0100
Message-Id: <20230307170102.636092855@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 6da6b1d4a7df8c35770186b53ef65d388398e139 upstream.

After a memory error happens on a clean folio, a process unexpectedly
receives SIGBUS when it accesses the error page.  This SIGBUS killing is
pointless and simply degrades the level of RAS of the system, because the
clean folio can be dropped without any data lost on memory error handling
as we do for a clean pagecache.

When memory_failure() is called on a clean folio, try_to_unmap() is called
twice (one from split_huge_page() and one from hwpoison_user_mappings()).
The root cause of the issue is that pte conversion to hwpoisoned entry is
now done in the first call of try_to_unmap() because PageHWPoison is
already set at this point, while it's actually expected to be done in the
second call.  This behavior disturbs the error handling operation like
removing pagecache, which results in the malfunction described above.

So convert TTU_IGNORE_HWPOISON into TTU_HWPOISON and set TTU_HWPOISON only
when we really intend to convert pte to hwpoison entry.  This can prevent
other callers of try_to_unmap() from accidentally converting to hwpoison
entries.

Link: https://lkml.kernel.org/r/20230221085905.1465385-1-naoya.horiguchi@linux.dev
Fixes: a42634a6c07d ("readahead: Use a folio in read_pages()")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |    2 +-
 mm/memory-failure.c  |    8 ++++----
 mm/rmap.c            |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -94,7 +94,7 @@ enum ttu_flags {
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
 	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
-	TTU_IGNORE_HWPOISON	= 0x20,	/* corrupted page is recoverable */
+	TTU_HWPOISON		= 0x20,	/* do convert pte to hwpoison entry */
 	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
 					 * do a final flush if necessary */
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1034,7 +1034,7 @@ static int me_pagecache_dirty(struct pag
  * cache and swap cache(ie. page is freshly swapped in). So it could be
  * referenced concurrently by 2 types of PTEs:
  * normal PTEs and swap PTEs. We try to handle them consistently by calling
- * try_to_unmap(TTU_IGNORE_HWPOISON) to convert the normal PTEs to swap PTEs,
+ * try_to_unmap(!TTU_HWPOISON) to convert the normal PTEs to swap PTEs,
  * and then
  *      - clear dirty bit to prevent IO
  *      - remove from LRU
@@ -1415,7 +1415,7 @@ static bool hwpoison_user_mappings(struc
 				  int flags, struct page *hpage)
 {
 	struct folio *folio = page_folio(hpage);
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
@@ -1445,7 +1445,7 @@ static bool hwpoison_user_mappings(struc
 
 	if (PageSwapCache(p)) {
 		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
-		ttu |= TTU_IGNORE_HWPOISON;
+		ttu &= ~TTU_HWPOISON;
 	}
 
 	/*
@@ -1460,7 +1460,7 @@ static bool hwpoison_user_mappings(struc
 		if (page_mkclean(hpage)) {
 			SetPageDirty(hpage);
 		} else {
-			ttu |= TTU_IGNORE_HWPOISON;
+			ttu &= ~TTU_HWPOISON;
 			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
 				pfn);
 		}
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1615,7 +1615,7 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && !(flags & TTU_IGNORE_HWPOISON)) {
+		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);


