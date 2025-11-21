Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954BC34C9AB;
	Fri, 21 Nov 2025 13:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732074; cv=none; b=N4wedD8qO4ElQ1F7yWdrEblVJPiroy5UyGifet2LkdI9OF/c4FcaGQJfTIdy4/HuyR1phymrKV03C0t6JHBvN5HESq15AOYeRcXNSaP7TCfg9xHyQ2CfAyU4/j8wrJinD3zCmHCKRckjKjlaFYarM6DMaD9o8vHBwWSmpJxuQaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732074; c=relaxed/simple;
	bh=WU+GSraDYtSElWWX7qe1ddCCzJQePD/HGPWZSSr9Fc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMXaPRBaXOJARFhZ4yXsdlw/f+nQCn8vtPr0a1sCclpGWhTud9R/MRmM0f6vUvaBn8jdawBJ45JsysOQ/jZFRvSsWIOx2gvTqy16zMqucMNq8UbdadcODVxhz2PIGqTwO0S40HZnuTQws2uSWJ9VIhHMcvXxSEEX7GklnDTkyd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on/mnCWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on/mnCWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B68C4CEF1;
	Fri, 21 Nov 2025 13:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732074;
	bh=WU+GSraDYtSElWWX7qe1ddCCzJQePD/HGPWZSSr9Fc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on/mnCWslQ9P5J8Ps/itn4yhE5firFQ5opQBjaa2r32AcGdR7h4JpxrE2LM14xwEa
	 lTDLaw//ieSxputMM7KLjG/kSLZI24naP0DJKZRgteYD1MRonPKBRRKPMLIDqhYQy7
	 0/spler8rinRgBnjDwLgtHy7jJdiBY/QzP4tAdKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Pankaj Raghav <kernel@pankajraghav.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jane Chu <jane.chu@oracle.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 180/185] mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
Date: Fri, 21 Nov 2025 14:13:27 +0100
Message-ID: <20251121130150.388048495@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit fa5a061700364bc28ee1cb1095372f8033645dcb upstream.

folio split clears PG_has_hwpoisoned, but the flag should be preserved in
after-split folios containing pages with PG_hwpoisoned flag if the folio
is split to >0 order folios.  Scan all pages in a to-be-split folio to
determine which after-split folios need the flag.

An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
avoid the scan and set it on all after-split folios, but resulting false
positive has undesirable negative impact.  To remove false positive,
caller of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page()
needs to do the scan.  That might be causing a hassle for current and
future callers and more costly than doing the scan in the split code.
More details are discussed in [1].

This issue can be exposed via:
1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
2. truncating part of a has_hwpoisoned folio in
   truncate_inode_partial_folio().

And later accesses to a hwpoisoned page could be possible due to the
missing has_hwpoisoned folio flag.  This will lead to MCE errors.

Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20251023030521.473097-1-ziy@nvidia.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3091,9 +3091,17 @@ static void lru_add_page_tail(struct fol
 	}
 }
 
+static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
+{
+	for (; nr_pages; page++, nr_pages--)
+		if (PageHWPoison(page))
+			return true;
+	return false;
+}
+
 static void __split_huge_page_tail(struct folio *folio, int tail,
 		struct lruvec *lruvec, struct list_head *list,
-		unsigned int new_order)
+		unsigned int new_order, const bool handle_hwpoison)
 {
 	struct page *head = &folio->page;
 	struct page *page_tail = head + tail;
@@ -3170,6 +3178,11 @@ static void __split_huge_page_tail(struc
 		folio_set_large_rmappable(new_folio);
 	}
 
+	/* Set has_hwpoisoned flag on new_folio if any of its pages is HWPoison */
+	if (handle_hwpoison &&
+	    page_range_has_hwpoisoned(page_tail, 1 << new_order))
+		folio_set_has_hwpoisoned(new_folio);
+
 	/* Finally unfreeze refcount. Additional reference from page cache. */
 	page_ref_unfreeze(page_tail,
 		1 + ((!folio_test_anon(folio) || folio_test_swapcache(folio)) ?
@@ -3194,6 +3207,8 @@ static void __split_huge_page(struct pag
 		pgoff_t end, unsigned int new_order)
 {
 	struct folio *folio = page_folio(page);
+	/* Scan poisoned pages when split a poisoned folio to large folios */
+	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
 	struct page *head = &folio->page;
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
@@ -3217,8 +3232,14 @@ static void __split_huge_page(struct pag
 
 	ClearPageHasHWPoisoned(head);
 
+	/* Check first new_nr pages since the loop below skips them */
+	if (handle_hwpoison &&
+	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr))
+		folio_set_has_hwpoisoned(folio);
+
 	for (i = nr - new_nr; i >= new_nr; i -= new_nr) {
-		__split_huge_page_tail(folio, i, lruvec, list, new_order);
+		__split_huge_page_tail(folio, i, lruvec, list, new_order,
+				       handle_hwpoison);
 		/* Some pages can be beyond EOF: drop them from page cache */
 		if (head[i].index >= end) {
 			struct folio *tail = page_folio(head + i);


