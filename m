Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150512D210;
	Tue, 30 Apr 2024 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475535; cv=none; b=Qg7cyZxlQkEgpP6sj/8WDzLbGXq/SVLzu9Tp53SBK7eixojnQBUFwFdNNJQm48rD/iTVIPDUkbDkH8HI9tr0bIpAkSVFRtKFh8LBe6n05oyJcf0EIR1MGVPiOHdV1dh2INkeLNoBInalLRKMfLaBUfCFkzfE4YWLJp+fPEHwH5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475535; c=relaxed/simple;
	bh=dl7s23/KDJ3BIOMtr0icjKSu8Hx/oJ7Fg9yyPIrK4jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrQsEMv+ra7gEqS8uKXUgwb/MyVBcbW+WIOFEr5chGNNCaCHtlE5rKpJRqbVKwvTQ+5E9SywHBvQlVY2kEsxN8AQVBcE5j0cihVvZUBQ42dt1yQeHrCuA+kBWeT2y7XhEcrr43XcVV/kUQ9Nzfm/Fenxi04ZZQ9yE/Gy1eY4HhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5gbd999; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5gbd999"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FE2C2BBFC;
	Tue, 30 Apr 2024 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475535;
	bh=dl7s23/KDJ3BIOMtr0icjKSu8Hx/oJ7Fg9yyPIrK4jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5gbd999B1waHIus7e/gSqWGx+FTKgfCz6PCYy0m6ChCHW3vxrurydhce5NC3h8ix
	 YQrVhvNJQBuRg5WV1W7uUiRCGOIpX3vRhYWoD1gj/Ycsj03big+M87+90XfKsMVk6N
	 q9jNSH7lwy0oCdzZHSzUpVZ48jpURzQdBFBrWh8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 126/186] mm: support page_mapcount() on page_has_type() pages
Date: Tue, 30 Apr 2024 12:39:38 +0200
Message-ID: <20240430103101.689989242@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

commit fd1a745ce03e37945674c14833870a9af0882e2d upstream.

Return 0 for pages which can't be mapped.  This matches how page_mapped()
works.  It is more convenient for users to not have to filter out these
pages.

Link: https://lkml.kernel.org/r/20240321142448.1645400-5-willy@infradead.org
Fixes: 9c5ccf2db04b ("mm: remove HUGETLB_PAGE_DTOR")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/page.c             |    7 ++-----
 include/linux/mm.h         |    8 +++++---
 include/linux/page-flags.h |    4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -67,7 +67,7 @@ static ssize_t kpagecount_read(struct fi
 		 */
 		ppage = pfn_to_online_page(pfn);
 
-		if (!ppage || PageSlab(ppage) || page_has_type(ppage))
+		if (!ppage)
 			pcount = 0;
 		else
 			pcount = page_mapcount(ppage);
@@ -124,11 +124,8 @@ u64 stable_page_flags(struct page *page)
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
-	 *
-	 * Note that page->_mapcount is overloaded in SLAB, so the
-	 * simple test in page_mapped() is not enough.
 	 */
-	if (!PageSlab(page) && page_mapped(page))
+	if (page_mapped(page))
 		u |= 1 << KPF_MMAP;
 	if (PageAnon(page))
 		u |= 1 << KPF_ANON;
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1184,14 +1184,16 @@ static inline void page_mapcount_reset(s
  * a large folio, it includes the number of times this page is mapped
  * as part of that folio.
  *
- * The result is undefined for pages which cannot be mapped into userspace.
- * For example SLAB or special types of pages. See function page_has_type().
- * They use this field in struct page differently.
+ * Will report 0 for pages which cannot be mapped into userspace, eg
+ * slab, page tables and similar.
  */
 static inline int page_mapcount(struct page *page)
 {
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
+	/* Handle page_has_type() pages */
+	if (mapcount < 0)
+		mapcount = 0;
 	if (unlikely(PageCompound(page)))
 		mapcount += folio_entire_mapcount(page_folio(page));
 
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -931,12 +931,12 @@ static inline bool is_page_hwpoison(stru
  * page_type may be used.  Because it is initialised to -1, we invert the
  * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
  * __ClearPageFoo *sets* the bit used for PageFoo.  We reserve a few high and
- * low bits so that an underflow or overflow of page_mapcount() won't be
+ * low bits so that an underflow or overflow of _mapcount won't be
  * mistaken for a page type value.
  */
 
 #define PAGE_TYPE_BASE	0xf0000000
-/* Reserve		0x0000007f to catch underflows of page_mapcount */
+/* Reserve		0x0000007f to catch underflows of _mapcount */
 #define PAGE_MAPCOUNT_RESERVE	-128
 #define PG_buddy	0x00000080
 #define PG_offline	0x00000100


