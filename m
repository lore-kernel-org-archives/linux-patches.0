Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605504FD29C;
	Thu, 17 Sep 2026 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667166; cv=none; b=EaqVi3jF35B7AnjW3tuhgP4W5FtzP3BmQvz2i9bDkiTAm0JTZTP/pbdIk/9+gu1MevXweus1mpaTC0O+yLYMPS9ZeGjtDCKIJAtnlEOiKSlq1sqwbvAXIJ7RbXrt1e9vqR3rI+FXn8hMBG8s85/EWY4JBxNKmSoiqsp+93sAZLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667166; c=relaxed/simple;
	bh=hR1lVJJmSGV1rjDyWaNAh8NQtUQW1YB8eXpkOe70CfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0j04hYBxC9IJpvpbsuTEyGH5G4SwOHsUelrctNpLefb8MGd66cXb2Lihn+/sJQdt2DwyzFfaRT/yvLQoB/37pPihXCNHpaHZv1ziq0VL5dTML7P8XEkOpMKDXeecPcWcLEmsyL4+vVXVo/Wx8fs4DVb4xsu943tXfQe25McRew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODTxpDrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODTxpDrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E7D1F000FF;
	Thu, 17 Sep 2026 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667164;
	bh=GEZs7JnONnCrxZSBdX5ddtBRdzVd2rE6p9AK9MYzRSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODTxpDrcfCe/bvEk5U/8ZiftL5pArAz5HdcBjblZZIXyI+315V67ZNgLMrdSUheCt
	 5ddYdPtk65Q54wKNk0HsBRYBuNRyJh+kubz9Sd7eb9UKZlNqSFA1ditcJ1XvQ8L8T8
	 RZuXU1LGYl7qWL536v5RxxaSmBinQV2sOTXWRQQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 1250/1250] x86/mm: Fix and document DEBUG_PAGEALLOC
Date: Thu, 17 Sep 2026 16:17:25 +0100
Message-ID: <20260917151626.182367892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 7da514d819a0afb148634aac92b3d190f34947c3 upstream.

It turns out that commit 5fce67641a3e ("x86/mm/pat: Don't gate
cpa_lock on debug_pagealloc_enabled()") was a little too quick to
remove the debug_pagealloc exception for cpa_lock.

Notably __kernel_map_pages() is used by the page-allocator from any
context the page-allocator itself is used, which violates the cpa_lock
rules.

Re-instate the exception, except make it specific to the
__kernel_map_pages() such that any other cpa() usage is still fully
serialized by cpa_lock. Also note that since cpa() should not be used
on memory that isn't allocated, the page-allocator locking and cpa are
infact mutually exclusive and all cpa usage in fully serialized.

Add a comment explaining this and other 'funnies' surrounding
DEBUG_PAGEALLOC, including how pgd_lock is not affected and the TLB
trickery.

Fixes: 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260729111119.604452135@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |   80 +++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 22 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -70,11 +70,12 @@ static const int cpa_warn_level = CPA_PR
  */
 static DEFINE_SPINLOCK(cpa_lock);
 
-#define CPA_FLUSHTLB 1
-#define CPA_ARRAY 2
-#define CPA_PAGES_ARRAY 4
-#define CPA_NO_CHECK_ALIAS 8 /* Do not search for aliases */
-#define CPA_COLLAPSE 16 /* try to collapse large pages */
+#define CPA_FLUSHTLB		0x01
+#define CPA_ARRAY		0x02
+#define CPA_PAGES_ARRAY		0x04
+#define CPA_NO_CHECK_ALIAS	0x08 /* Do not search for aliases */
+#define CPA_COLLAPSE		0x10 /* try to collapse large pages */
+#define CPA_DEBUG_PAGEALLOC	0x20
 
 static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 {
@@ -2014,6 +2015,7 @@ static int __change_page_attr_set_clr(st
 {
 	unsigned long numpages = cpa->numpages;
 	unsigned long rempages = numpages;
+	bool lock = true;
 	int ret = 0;
 
 	/*
@@ -2023,6 +2025,29 @@ static int __change_page_attr_set_clr(st
 	    !cpa->force_split)
 		return ret;
 
+	/*
+	 * DEBUG_PAGEALLOC is special; it is called from any context the
+	 * page-allocator is, which violates the normal cpa_lock locking
+	 * rules.
+	 *
+	 * However, since it is part of the page-allocator, things are still
+	 * properly serialized by the page-allocator locking and the fact that
+	 * when a page is owned by the page-allocator, it isn't owned by
+	 * anybody else. That is, you *SHOULD NOT* be calling cpa() on memory
+	 * that isn't allocated.
+	 *
+	 * Additionally, DEBUG_PAGEALLOC ensures (per probe_page_size_mask())
+	 * that the kernel mapping is 4k pages, therefore there are no large
+	 * pages to split/collapse.
+	 *
+	 * Furthermore, the page-allocator strictly manages pages that
+	 * *exist*, avoiding pgd_lock.
+	 *
+	 * Therefore, it is safe to not take cpa_lock.
+	 */
+	if (debug_pagealloc_enabled() && (cpa->flags & CPA_DEBUG_PAGEALLOC))
+		lock = false;
+
 	while (rempages) {
 		/*
 		 * Store the remaining nr of pages for the large page
@@ -2033,9 +2058,12 @@ static int __change_page_attr_set_clr(st
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		spin_lock(&cpa_lock);
-		ret = __change_page_attr(cpa, primary);
-		spin_unlock(&cpa_lock);
+		if (lock) {
+			guard(spinlock)(&cpa_lock);
+			ret = __change_page_attr(cpa, primary);
+		} else {
+			ret = __change_page_attr(cpa, primary);
+		}
 		if (ret)
 			goto out;
 
@@ -2631,7 +2659,7 @@ int set_pages_rw(struct page *page, int
 	return set_memory_rw(addr, numpages);
 }
 
-static int __set_pages_p(struct page *page, int numpages)
+static int __set_pages_p(struct page *page, int numpages, unsigned int cpa_flags)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
@@ -2639,7 +2667,7 @@ static int __set_pages_p(struct page *pa
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0),
-				.flags = CPA_NO_CHECK_ALIAS };
+				.flags = CPA_NO_CHECK_ALIAS | cpa_flags };
 
 	/*
 	 * No alias checking needed for setting present flag. otherwise,
@@ -2650,7 +2678,7 @@ static int __set_pages_p(struct page *pa
 	return __change_page_attr_set_clr(&cpa, 1);
 }
 
-static int __set_pages_np(struct page *page, int numpages)
+static int __set_pages_np(struct page *page, int numpages, unsigned int cpa_flags)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
@@ -2658,7 +2686,7 @@ static int __set_pages_np(struct page *p
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY),
-				.flags = CPA_NO_CHECK_ALIAS };
+				.flags = CPA_NO_CHECK_ALIAS | cpa_flags };
 
 	/*
 	 * No alias checking needed for setting not present flag. otherwise,
@@ -2671,20 +2699,20 @@ static int __set_pages_np(struct page *p
 
 int set_direct_map_invalid_noflush(struct page *page)
 {
-	return __set_pages_np(page, 1);
+	return __set_pages_np(page, 1, 0);
 }
 
 int set_direct_map_default_noflush(struct page *page)
 {
-	return __set_pages_p(page, 1);
+	return __set_pages_p(page, 1, 0);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 {
 	if (valid)
-		return __set_pages_p(page, nr);
+		return __set_pages_p(page, nr, 0);
 
-	return __set_pages_np(page, nr);
+	return __set_pages_np(page, nr, 0);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
@@ -2703,15 +2731,23 @@ void __kernel_map_pages(struct page *pag
 	 * and hence no memory allocations during large page split.
 	 */
 	if (enable)
-		__set_pages_p(page, numpages);
+		__set_pages_p(page, numpages, CPA_DEBUG_PAGEALLOC);
 	else
-		__set_pages_np(page, numpages);
+		__set_pages_np(page, numpages, CPA_DEBUG_PAGEALLOC);
 
 	/*
-	 * We should perform an IPI and flush all tlbs,
-	 * but that can deadlock->flush only current cpu.
-	 * Preemption needs to be disabled around __flush_tlb_all() due to
-	 * CR3 reload in __native_flush_tlb().
+	 * We should perform an IPI and flush all tlbs, but that can
+	 * deadlock, settle for a local flush.
+	 *
+	 * Not doing a global TLB flush means that remote CPUs will retain
+	 * stale TLB entries. In case of P->NP (on free) this means the remote
+	 * CPUs will not take the faults, making the debug scheme less
+	 * reliable. On the NP->P (on alloc) this means the remote CPUs can
+	 * take a spurious fault. However spurious_kernel_fault() will observe
+	 * *_present() and fix it up.
+	 *
+	 * Preemption needs to be disabled around __flush_tlb_all() due to CR3
+	 * reload in __native_flush_tlb().
 	 */
 	preempt_disable();
 	__flush_tlb_all();


