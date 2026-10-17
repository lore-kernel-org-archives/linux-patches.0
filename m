Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC303976BA;
	Sat, 17 Oct 2026 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253417; cv=none; b=IwCsia1XQP5IoeCeHXCsEdqk6O7otp433HlaMd0nFfY1pSHmxVFckeu+jVFCGlTvgxDa2Zjeqy1aa7tAgZOsobZvFQOxmGvT7SepYXLF72zW7UvZtyuaw/Us6/n9NQZ+t9aGgYDugzmQKJEIWZ94yzHNq1bJQRFyM1BPDAt/PCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253417; c=relaxed/simple;
	bh=S4HZhubuQ9r0t51QcSMwl8HqSWHCcJJN9kh9FExM7m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4b08v/11jUmwOGP87ebVaeo0Q7JCdGHsoo7bFqMh8vh01GFgfM7R5sVGLgN0cxC+4KZHIwRDJii1+fZxfUfZqNpWrE8h19jN890dfACrBsRMiUzDePDrXPpgFoUVpyWMjp764pHebEeRHbupfAYWaNtDTESA2/jrmA30PJZGsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNTBJvo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNTBJvo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9001F000C5;
	Sat, 17 Oct 2026 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253415;
	bh=/SrPvKA/8psn6Lx15cOeqKzp4LxDMwy3x09cNDooUlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNTBJvo3hAtynomrPlNWaS5Hi3s2pCOjHl7MWxQIbv6SDjBDPJX+L4ethWBR80Udj
	 QahPAANetXEyZkyh7uTlhPihR6SIp9U0yrD+dy/zxceytpY8gld5mjaKObe2fRUVB4
	 AdhDQMJJ4KGl/5erqrsE0ruWqL2yFXOC6dQtohF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Daniel Axtens <dja@axtens.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/869] kasan: avoid sleepable page allocation from atomic context
Date: Sat, 17 Oct 2026 17:48:30 +0200
Message-ID: <20261017160038.793538426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit b6ea95a34cbd014ab6ade4248107b86b0aaf2d6c ]

apply_to_pte_range() enters the lazy MMU mode and then invokes
kasan_populate_vmalloc_pte() callback on each page table walk iteration.
However, the callback can go into sleep when trying to allocate a single
page, e.g.  if an architecutre disables preemption on lazy MMU mode enter.

On s390 if make arch_enter_lazy_mmu_mode() -> preempt_enable() and
arch_leave_lazy_mmu_mode() -> preempt_disable(), such crash occurs:

[    0.663336] BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
[    0.663348] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2, name: kthreadd
[    0.663358] preempt_count: 1, expected: 0
[    0.663366] RCU nest depth: 0, expected: 0
[    0.663375] no locks held by kthreadd/2.
[    0.663383] Preemption disabled at:
[    0.663386] [<0002f3284cbb4eda>] apply_to_pte_range+0xfa/0x4a0
[    0.663405] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.15.0-rc5-gcc-kasan-00043-gd76bb1ebb558-dirty #162 PREEMPT
[    0.663408] Hardware name: IBM 3931 A01 701 (KVM/Linux)
[    0.663409] Call Trace:
[    0.663410]  [<0002f3284c385f58>] dump_stack_lvl+0xe8/0x140
[    0.663413]  [<0002f3284c507b9e>] __might_resched+0x66e/0x700
[    0.663415]  [<0002f3284cc4f6c0>] __alloc_frozen_pages_noprof+0x370/0x4b0
[    0.663419]  [<0002f3284ccc73c0>] alloc_pages_mpol+0x1a0/0x4a0
[    0.663421]  [<0002f3284ccc8518>] alloc_frozen_pages_noprof+0x88/0xc0
[    0.663424]  [<0002f3284ccc8572>] alloc_pages_noprof+0x22/0x120
[    0.663427]  [<0002f3284cc341ac>] get_free_pages_noprof+0x2c/0xc0
[    0.663429]  [<0002f3284cceba70>] kasan_populate_vmalloc_pte+0x50/0x120
[    0.663433]  [<0002f3284cbb4ef8>] apply_to_pte_range+0x118/0x4a0
[    0.663435]  [<0002f3284cbc7c14>] apply_to_pmd_range+0x194/0x3e0
[    0.663437]  [<0002f3284cbc99be>] __apply_to_page_range+0x2fe/0x7a0
[    0.663440]  [<0002f3284cbc9e88>] apply_to_page_range+0x28/0x40
[    0.663442]  [<0002f3284ccebf12>] kasan_populate_vmalloc+0x82/0xa0
[    0.663445]  [<0002f3284cc1578c>] alloc_vmap_area+0x34c/0xc10
[    0.663448]  [<0002f3284cc1c2a6>] __get_vm_area_node+0x186/0x2a0
[    0.663451]  [<0002f3284cc1e696>] __vmalloc_node_range_noprof+0x116/0x310
[    0.663454]  [<0002f3284cc1d950>] __vmalloc_node_noprof+0xd0/0x110
[    0.663457]  [<0002f3284c454b88>] alloc_thread_stack_node+0xf8/0x330
[    0.663460]  [<0002f3284c458d56>] dup_task_struct+0x66/0x4d0
[    0.663463]  [<0002f3284c45be90>] copy_process+0x280/0x4b90
[    0.663465]  [<0002f3284c460940>] kernel_clone+0xd0/0x4b0
[    0.663467]  [<0002f3284c46115e>] kernel_thread+0xbe/0xe0
[    0.663469]  [<0002f3284c4e440e>] kthreadd+0x50e/0x7f0
[    0.663472]  [<0002f3284c38c04a>] __ret_from_fork+0x8a/0xf0
[    0.663475]  [<0002f3284ed57ff2>] ret_from_fork+0xa/0x38

Instead of allocating single pages per-PTE, bulk-allocate the shadow
memory prior to applying kasan_populate_vmalloc_pte() callback on a page
range.

Link: https://lkml.kernel.org/r/c61d3560297c93ed044f0b1af085610353a06a58.1747316918.git.agordeev@linux.ibm.com
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/shadow.c | 92 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 14 deletions(-)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index b18cfa5e2cb79..1cf08821af9d6 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -292,33 +292,99 @@ void __init __weak kasan_populate_early_vm_area_shadow(void *start,
 {
 }
 
+struct vmalloc_populate_data {
+	unsigned long start;
+	struct page **pages;
+};
+
 static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
-				      void *unused)
+				      void *_data)
 {
-	unsigned long page;
+	struct vmalloc_populate_data *data = _data;
+	struct page *page;
 	pte_t pte;
+	int index;
 
 	if (likely(!pte_none(ptep_get(ptep))))
 		return 0;
 
-	page = __get_free_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
-
-	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
-	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
+	index = PFN_DOWN(addr - data->start);
+	page = data->pages[index];
+	__memset(page_to_virt(page), KASAN_VMALLOC_INVALID, PAGE_SIZE);
+	pte = pfn_pte(page_to_pfn(page), PAGE_KERNEL);
 
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pte_none(ptep_get(ptep)))) {
 		set_pte_at(&init_mm, addr, ptep, pte);
-		page = 0;
+		data->pages[index] = NULL;
 	}
 	spin_unlock(&init_mm.page_table_lock);
-	if (page)
-		free_page(page);
+
+	return 0;
+}
+
+static void ___free_pages_bulk(struct page **pages, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (pages[i]) {
+			__free_pages(pages[i], 0);
+			pages[i] = NULL;
+		}
+	}
+}
+
+static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
+{
+	unsigned long nr_populated, nr_total = nr_pages;
+	struct page **page_array = pages;
+
+	while (nr_pages) {
+		nr_populated = alloc_pages_bulk_array(GFP_KERNEL, nr_pages, pages);
+		if (!nr_populated) {
+			___free_pages_bulk(page_array, nr_total - nr_pages);
+			return -ENOMEM;
+		}
+		pages += nr_populated;
+		nr_pages -= nr_populated;
+	}
+
 	return 0;
 }
 
+static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
+{
+	unsigned long nr_pages, nr_total = PFN_UP(end - start);
+	struct vmalloc_populate_data data;
+	int ret = 0;
+
+	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!data.pages)
+		return -ENOMEM;
+
+	while (nr_total) {
+		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
+		ret = ___alloc_pages_bulk(data.pages, nr_pages);
+		if (ret)
+			break;
+
+		data.start = start;
+		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
+					  kasan_populate_vmalloc_pte, &data);
+		___free_pages_bulk(data.pages, nr_pages);
+		if (ret)
+			break;
+
+		start += nr_pages * PAGE_SIZE;
+		nr_total -= nr_pages;
+	}
+
+	free_page((unsigned long)data.pages);
+
+	return ret;
+}
+
 int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 {
 	unsigned long shadow_start, shadow_end;
@@ -348,9 +414,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = apply_to_page_range(&init_mm, shadow_start,
-				  shadow_end - shadow_start,
-				  kasan_populate_vmalloc_pte, NULL);
+	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
 	if (ret)
 		return ret;
 
-- 
2.53.0



