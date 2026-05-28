Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18C2580D7;
	Thu, 28 May 2026 20:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999387; cv=none; b=c/qCwY0SlKtLyoYKAkviZtyz7Th34GO9UrVlIBkJ9modBKkwKdNUc9gleZGMIbkPh6zIPFIJariaxfLP8tGC4hWu9yNOcNP8IG14lcmqb5Y3v/tvcVaSMI78gKOMV9jCBxAb7Hmszmm4NQeQSNRic1PH4mFvUIo3D/j26bKrhVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999387; c=relaxed/simple;
	bh=hq9OecwMA4QQvS2BmPfXHGVHAviqb2W38mvLyQQ8Ex4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbp5KdF4rUlbggl/Kvt+7IeKVoheICjrkIx7of7DbpFXOpXGVYU+6tqnLl2HCZ/Q+p21k3imQXMRpSl3iQ0GMu0TgQ1gZqbW0QgjwaaYjaIj73rkOOm2XRAkILGyaEuKub4PQH4WVX4sQxN246EB5UxKNjRC2cVF1rBq/OeoMvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmTsTt2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmTsTt2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433CD1F000E9;
	Thu, 28 May 2026 20:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999385;
	bh=ZLJXyv5ilPSBL7Cn4sTe3CDN2RLXGl+/Tk6zZeSyY84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmTsTt2k+vvmVqkIX+5RYCgUN9PQ/A8DQJ4l1uGN1XC+dMAl79saIKGzfKNzzVqfx
	 pdPZQ6OWpbO7OiuVEE5Y3ebEnL7FAQnDUiPt4x6JaBe4A79X9C3VF2kPLEUtbJHHo9
	 DyidMYtLbfvRfRVhWn0iKiLbWjw44W1BYEvPFcGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Brendan Jackman <jackmanb@google.com>,
	Dev Jain <dev.jain@arm.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Liam Howlett <liam@infradead.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 049/377] mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
Date: Thu, 28 May 2026 21:44:47 +0200
Message-ID: <20260528194639.794101868@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

commit 6a288a4ddb4a994490505ab5f41c445f8e6b6467 upstream.

__GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.

If we run with init_on_free, we will zero out pages during
__free_pages_prepare(), to skip zeroing on the allocation path.

However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
consequently not only skip clearing page content, but also skip clearing
tag memory.

Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
will get mapped to user space through set_pte_at() later: set_pte_at() and
friends will detect that the tags have not been initialized yet
(PG_mte_tagged not set), and initialize them.

However, for the huge zero folio, which will be mapped through a PMD
marked as special, this initialization will not be performed, ending up
exposing whatever tags were still set for the pages.

The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
that allocation tags are set to 0 when a page is first mapped to user
space.  That no longer holds with the huge zero folio when init_on_free is
enabled.

Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
tag_clear_highpages() whether we want to also clear page content.

Invert the meaning of the tag_clear_highpages() return value to have
clearer semantics.

Reproduced with the huge zero folio by modifying the check_buffer_fill
arm64/mte selftest to use a 2 MiB area, after making sure that pages have
a non-0 tag set when freeing (note that, during boot, we will not actually
initialize tags, but only set KASAN_TAG_KERNEL in the page flags).

	$ ./check_buffer_fill
	1..20
	...
	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
	...

This code needs more cleanups; we'll tackle that next, like
decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN.

[akpm@linux-foundation.org: s/__GPF_ZERO/__GFP_ZERO/, per David]
Link: https://lore.kernel.org/20260421-zerotags-v2-1-05cb1035482e@kernel.org
Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/page.h |    2 +-
 arch/arm64/mm/fault.c         |   11 +++++++----
 include/linux/gfp_types.h     |   10 +++++-----
 include/linux/highmem.h       |    7 ++++---
 mm/page_alloc.c               |    8 ++++----
 5 files changed, 21 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -33,7 +33,7 @@ struct folio *vma_alloc_zeroed_movable_f
 						unsigned long vaddr);
 #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
 
-bool tag_clear_highpages(struct page *to, int numpages);
+bool tag_clear_highpages(struct page *to, int numpages, bool clear_pages);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -967,7 +967,7 @@ struct folio *vma_alloc_zeroed_movable_f
 	return vma_alloc_folio(flags, 0, vma, vaddr);
 }
 
-bool tag_clear_highpages(struct page *page, int numpages)
+bool tag_clear_highpages(struct page *page, int numpages, bool clear_pages)
 {
 	/*
 	 * Check if MTE is supported and fall back to clear_highpage().
@@ -975,13 +975,16 @@ bool tag_clear_highpages(struct page *pa
 	 * post_alloc_hook() will invoke tag_clear_highpages().
 	 */
 	if (!system_supports_mte())
-		return false;
+		return clear_pages;
 
 	/* Newly allocated pages, shouldn't have been tagged yet */
 	for (int i = 0; i < numpages; i++, page++) {
 		WARN_ON_ONCE(!try_page_mte_tagging(page));
-		mte_zero_clear_page_tags(page_address(page));
+		if (clear_pages)
+			mte_zero_clear_page_tags(page_address(page));
+		else
+			mte_clear_page_tags(page_address(page));
 		set_page_mte_tagged(page);
 	}
-	return true;
+	return false;
 }
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -277,11 +277,11 @@ enum {
  *
  * %__GFP_ZERO returns a zeroed page on success.
  *
- * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
- * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
- * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
- * memory tags at the same time as zeroing memory has minimal additional
- * performance impact.
+ * %__GFP_ZEROTAGS zeroes memory tags at allocation time. Setting memory tags at
+ * the same time as zeroing memory (e.g., with __GFP_ZERO) has minimal
+ * additional performance impact. However, __GFP_ZEROTAGS also zeroes the tags
+ * even if memory is not getting zeroed at allocation time (e.g.,
+ * with init_on_free).
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -251,10 +251,11 @@ static inline void clear_highpage_kasan_
 
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
-/* Return false to let people know we did not initialize the pages */
-static inline bool tag_clear_highpages(struct page *page, int numpages)
+/* Returns true if the caller has to initialize the pages */
+static inline bool tag_clear_highpages(struct page *page, int numpages,
+		bool clear_pages)
 {
-	return false;
+	return clear_pages;
 }
 
 #endif
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1847,9 +1847,9 @@ static inline bool should_skip_init(gfp_
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
+	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
 	set_page_private(page, 0);
@@ -1871,11 +1871,11 @@ inline void post_alloc_hook(struct page
 	 */
 
 	/*
-	 * If memory tags should be zeroed
-	 * (which happens only when memory should be initialized as well).
+	 * Clearing tags can efficiently clear the memory for us as well, if
+	 * required.
 	 */
 	if (zero_tags)
-		init = !tag_clear_highpages(page, 1 << order);
+		init = tag_clear_highpages(page, 1 << order, /* clear_pages= */init);
 
 	if (!should_skip_kasan_unpoison(gfp_flags) &&
 	    kasan_unpoison_pages(page, order, init)) {


