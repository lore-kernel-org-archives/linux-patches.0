Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59153189B84;
	Wed, 17 Sep 2025 12:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112792; cv=none; b=qhmkGXBEZfX6vn6Q4RcBFdoXsl77tZNFoF8Cgp6XgC/HTZZGtDvEoSg/ezsqvuACNw3ZrSQBldeOn/3fFD1A1vQIdEsZDxTrz97gR0HdYr++W6vKrK+8CZhc5dqOhz2vpIOz+uV88kGTnRQUCChjS44A8AzvC0gBDkFnJYkDhq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112792; c=relaxed/simple;
	bh=71trf2QGg2VevWv6NOWlyOFa1dl3z4lVD/8BUoZlSz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD0plfUukIG2pSPJGeA/+l7zvuUu8d0oorjPuFdvpuSngb/bcNsWgusd386wWuDhln7WHSBgL8im4TQu+6fNTWymaRvQO49HA/rzY35/OpIPitMviwaA5W+R+dukuaXezRHfg0oMvy3WYIBpRSJofFwInXTQhqEYqLurI7mb9vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUQRq3qF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUQRq3qF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734E8C4CEF0;
	Wed, 17 Sep 2025 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112792;
	bh=71trf2QGg2VevWv6NOWlyOFa1dl3z4lVD/8BUoZlSz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUQRq3qFphlYwcd8iA/fv8a5oHCL+WDNEapB6ZblwVWWTLFSDZXvFGCkib84POyEm
	 he7tW9lkT94bCE8fZDWd5DCp3tk+E/1XQ/80YGzDxhLyaNMB1uiappeyaShHgrUeFy
	 Xgwpmr3vhDqHBT4IJRlG5B6t3X69xbvz/0avQXr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 078/189] mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()
Date: Wed, 17 Sep 2025 14:33:08 +0200
Message-ID: <20250917123353.774735811@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

commit 79357cd06d41d0f5a11b17d7c86176e395d10ef2 upstream.

kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask and
always allocate memory using the hardcoded GFP_KERNEL flag.  This makes
them inconsistent with vmalloc(), which was recently extended to support
GFP_NOFS and GFP_NOIO allocations.

Page table allocations performed during shadow population also ignore the
external gfp_mask.  To preserve the intended semantics of GFP_NOFS and
GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
memalloc scope.

xfs calls vmalloc with GFP_NOFS, so this bug could lead to deadlock.

There was a report here
https://lkml.kernel.org/r/686ea951.050a0220.385921.0016.GAE@google.com

This patch:
 - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
 - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
 - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
   around apply_to_page_range();
 - Updates vmalloc.c and percpu allocator call sites accordingly.

Link: https://lkml.kernel.org/r/20250831121058.92971-1-urezki@gmail.com
Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kasan.h |    6 +++---
 mm/kasan/shadow.c     |   31 ++++++++++++++++++++++++-------
 mm/vmalloc.c          |    8 ++++----
 3 files changed, 31 insertions(+), 14 deletions(-)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -562,7 +562,7 @@ static inline void kasan_init_hw_tags(vo
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
 void kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
@@ -574,7 +574,7 @@ static inline void kasan_populate_early_
 						       unsigned long size)
 { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
@@ -610,7 +610,7 @@ static __always_inline void kasan_poison
 static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size) { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -335,13 +335,13 @@ static void ___free_pages_bulk(struct pa
 	}
 }
 
-static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
+static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
 {
 	unsigned long nr_populated, nr_total = nr_pages;
 	struct page **page_array = pages;
 
 	while (nr_pages) {
-		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
+		nr_populated = alloc_pages_bulk(gfp_mask, nr_pages, pages);
 		if (!nr_populated) {
 			___free_pages_bulk(page_array, nr_total - nr_pages);
 			return -ENOMEM;
@@ -353,25 +353,42 @@ static int ___alloc_pages_bulk(struct pa
 	return 0;
 }
 
-static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
+static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
 {
 	unsigned long nr_pages, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
+	unsigned int flags;
 	int ret = 0;
 
-	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
 	if (!data.pages)
 		return -ENOMEM;
 
 	while (nr_total) {
 		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
-		ret = ___alloc_pages_bulk(data.pages, nr_pages);
+		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
 		if (ret)
 			break;
 
 		data.start = start;
+
+		/*
+		 * page tables allocations ignore external gfp mask, enforce it
+		 * by the scope API
+		 */
+		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+			flags = memalloc_nofs_save();
+		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+			flags = memalloc_noio_save();
+
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
+
+		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+			memalloc_nofs_restore(flags);
+		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+			memalloc_noio_restore(flags);
+
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
 			break;
@@ -385,7 +402,7 @@ static int __kasan_populate_vmalloc(unsi
 	return ret;
 }
 
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, shadow_end;
 	int ret;
@@ -414,7 +431,7 @@ int kasan_populate_vmalloc(unsigned long
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
+	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
 	if (ret)
 		return ret;
 
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2026,6 +2026,8 @@ static struct vmap_area *alloc_vmap_area
 	if (unlikely(!vmap_initialized))
 		return ERR_PTR(-EBUSY);
 
+	/* Only reclaim behaviour flags are relevant. */
+	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
 	might_sleep();
 
 	/*
@@ -2038,8 +2040,6 @@ static struct vmap_area *alloc_vmap_area
 	 */
 	va = node_alloc(size, align, vstart, vend, &addr, &vn_id);
 	if (!va) {
-		gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
-
 		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
 		if (unlikely(!va))
 			return ERR_PTR(-ENOMEM);
@@ -2089,7 +2089,7 @@ retry:
 	BUG_ON(va->va_start < vstart);
 	BUG_ON(va->va_end > vend);
 
-	ret = kasan_populate_vmalloc(addr, size);
+	ret = kasan_populate_vmalloc(addr, size, gfp_mask);
 	if (ret) {
 		free_vmap_area(va);
 		return ERR_PTR(ret);
@@ -4826,7 +4826,7 @@ retry:
 
 	/* populate the kasan shadow space */
 	for (area = 0; area < nr_vms; area++) {
-		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area]))
+		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
 			goto err_free_shadow;
 	}
 


