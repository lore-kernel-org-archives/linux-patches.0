Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978A2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B6C433D2;
	Mon, 24 Apr 2023 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343135;
	bh=tKFA7zVSbWCgqVyFcMZtMC5mlMAMW5m/di7ZuoPuMXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=it9yRr1+pOjmWBa5aXM00eXImNPn/5eN94Xfs6ChXsVkoZqBn54VlMHG8LoF0akH/
	 sESiWIHoemZCq1m6hK6QX+QJxkSnqcYg76zGSTcx6xXS2m6Ab0NdY7dwgZv7Uvj634
	 9ZV5+q/8RSbhzH0Qb8AlR+8bQFsuV9muUoMYBjSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dipanjan Das <mail.dipanjan.das@gmail.com>,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 090/110] mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()
Date: Mon, 24 Apr 2023 15:17:52 +0200
Message-Id: <20230424131139.899406466@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Potapenko <glider@google.com>

commit 47ebd0310e89c087f56e58c103c44b72a2f6b216 upstream.

As reported by Dipanjan Das, when KMSAN is used together with kernel fault
injection (or, generally, even without the latter), calls to kcalloc() or
__vmap_pages_range_noflush() may fail, leaving the metadata mappings for
the virtual mapping in an inconsistent state.  When these metadata
mappings are accessed later, the kernel crashes.

To address the problem, we return a non-zero error code from
kmsan_vmap_pages_range_noflush() in the case of any allocation/mapping
failure inside it, and make vmap_pages_range_noflush() return an error if
KMSAN fails to allocate the metadata.

This patch also removes KMSAN_WARN_ON() from vmap_pages_range_noflush(),
as these allocation failures are not fatal anymore.

Link: https://lkml.kernel.org/r/20230413131223.4135168-1-glider@google.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
  Link: https://lore.kernel.org/linux-mm/CANX2M5ZRrRA64k0hOif02TjmY9kbbO2aCBPyq79es34RXZ=cAw@mail.gmail.com/
Reviewed-by: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kmsan.h |   20 +++++++++++---------
 mm/kmsan/shadow.c     |   27 ++++++++++++++++++---------
 mm/vmalloc.c          |    6 +++++-
 3 files changed, 34 insertions(+), 19 deletions(-)

--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -134,11 +134,12 @@ void kmsan_kfree_large(const void *ptr);
  * @page_shift:	page_shift passed to vmap_range_noflush().
  *
  * KMSAN maps shadow and origin pages of @pages into contiguous ranges in
- * vmalloc metadata address range.
+ * vmalloc metadata address range. Returns 0 on success, callers must check
+ * for non-zero return value.
  */
-void kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
-				    pgprot_t prot, struct page **pages,
-				    unsigned int page_shift);
+int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
+				   pgprot_t prot, struct page **pages,
+				   unsigned int page_shift);
 
 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -282,12 +283,13 @@ static inline void kmsan_kfree_large(con
 {
 }
 
-static inline void kmsan_vmap_pages_range_noflush(unsigned long start,
-						  unsigned long end,
-						  pgprot_t prot,
-						  struct page **pages,
-						  unsigned int page_shift)
+static inline int kmsan_vmap_pages_range_noflush(unsigned long start,
+						 unsigned long end,
+						 pgprot_t prot,
+						 struct page **pages,
+						 unsigned int page_shift)
 {
+	return 0;
 }
 
 static inline void kmsan_vunmap_range_noflush(unsigned long start,
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -216,27 +216,29 @@ void kmsan_free_page(struct page *page,
 	kmsan_leave_runtime();
 }
 
-void kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
-				    pgprot_t prot, struct page **pages,
-				    unsigned int page_shift)
+int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
+				   pgprot_t prot, struct page **pages,
+				   unsigned int page_shift)
 {
 	unsigned long shadow_start, origin_start, shadow_end, origin_end;
 	struct page **s_pages, **o_pages;
-	int nr, mapped;
+	int nr, mapped, err = 0;
 
 	if (!kmsan_enabled)
-		return;
+		return 0;
 
 	shadow_start = vmalloc_meta((void *)start, KMSAN_META_SHADOW);
 	shadow_end = vmalloc_meta((void *)end, KMSAN_META_SHADOW);
 	if (!shadow_start)
-		return;
+		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
 	s_pages = kcalloc(nr, sizeof(*s_pages), GFP_KERNEL);
 	o_pages = kcalloc(nr, sizeof(*o_pages), GFP_KERNEL);
-	if (!s_pages || !o_pages)
+	if (!s_pages || !o_pages) {
+		err = -ENOMEM;
 		goto ret;
+	}
 	for (int i = 0; i < nr; i++) {
 		s_pages[i] = shadow_page_for(pages[i]);
 		o_pages[i] = origin_page_for(pages[i]);
@@ -249,10 +251,16 @@ void kmsan_vmap_pages_range_noflush(unsi
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
 					    s_pages, page_shift);
-	KMSAN_WARN_ON(mapped);
+	if (mapped) {
+		err = mapped;
+		goto ret;
+	}
 	mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
 					    o_pages, page_shift);
-	KMSAN_WARN_ON(mapped);
+	if (mapped) {
+		err = mapped;
+		goto ret;
+	}
 	kmsan_leave_runtime();
 	flush_tlb_kernel_range(shadow_start, shadow_end);
 	flush_tlb_kernel_range(origin_start, origin_end);
@@ -262,6 +270,7 @@ void kmsan_vmap_pages_range_noflush(unsi
 ret:
 	kfree(s_pages);
 	kfree(o_pages);
+	return err;
 }
 
 /* Allocate metadata for pages allocated at boot time. */
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -616,7 +616,11 @@ int __vmap_pages_range_noflush(unsigned
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	kmsan_vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						 page_shift);
+
+	if (ret)
+		return ret;
 	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
 }
 


