Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591531;
	b=CVO4upPA/45OExU0uSpAseRM242zYfmB9MbUVDe49qHjg1FfKLmCGmFJKOSUto4TueYa
	 YeoqqMlwqEnzsDe1jjJeahjfKzIPfXIOLLy7EBdlPao/q+Zxy6H4m40sKDc1hPhGBB3D1
	 X8PscyitGhLcu+laxpLL86zSzhRZ4pvxaksiwFNBzF0ltMk8Fr2wu2aTA0hqzFvyrSVWm
	 QmXjCX2iLtDiPui/7xhi9Opt01X/8b/mUHEKDw3x5xGG4mGfbzBqz7fNyfz2vZflC6Ln1
	 91YQdkOZasYGxWguCpCQdessYPsJDbe48J5pYQreSvKfJB/OHCM08XcIaXVEjCwI6JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhFCXWpwNarxEOpUajqu2F9KwOw5ObKgw/O46EGmmUA=;
	b=zBu7gwX53xf9AJ9NK+vnIVabKbJUr5fnNgcmChdpYql7IchdnRsSjWvXwyMNG3Qjeqco
	 L85nP9BUx55bCpq4GBdypwrXz9WmTjDZVeq3MOMJhw0htp/78PP9g9U3a3TpPf+4UKyVs
	 unUJ5QEPh89Gk+BJgNHVSjA4oixTXIhCh/YbxFdIxHm8bbXTYTXvE3RDzmP7+rjH9XZRt
	 3TmmPMthFDMf4+WXi1xh3uc/TpUKTMNpjXd3IliSrIEfrXXkQc7XVgnlNVUAJTzTlPPdA
	 E0+vT1Jspj0QCz1ilDQpaubU0APDlr4qzJpbk9LcPFPegDp5ARzJC9pWQiHhWNnny8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWptp+IM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBDC606D4B8;
	Fri, 13 Nov 2026 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWptp+IM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD4B1F000C7;
	Fri, 13 Nov 2026 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591531;
	bh=zhFCXWpwNarxEOpUajqu2F9KwOw5ObKgw/O46EGmmUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWptp+IMTaAPd5Ky1/uz72RR7WsVzGSfOFYX2okKY2Mw/T8QRQC6nfVKyMneAOiFI
	 cAVl57MujYfxXpN1CU/Z86JVXefnj73YDIMivN9ACcvVd98gqEmjlX5tgnExUhU2c7
	 VroilxHpj0yP5e4nnRCiRUzfw9NDElVad7oU2Q30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 588/670] mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
Date: Fri, 13 Nov 2026 10:52:32 -0500
Message-ID: <20261113153831.770359567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 9057170a941f0c5f4058f6fb9ab5d5fc9fcc9e83 ]

Patch series "mm: stop calling pmd_folio() on special PMDs", v3.

Two page table walkers resolve the folio behind a PMD with pmd_folio(),
which is only valid for a PMD mapping a refcounted struct page:

  madvise_cold_or_pageout_pte_range() mm/madvise.c
  queue_folios_pmd() mm/mempolicy.c

vmf_insert_pfn_pmd() installs special PMDs holding a raw pfn that need not
have a memmap entry at all.  Both walkers can reach one and fault on the
first folio field read.  The PTE halves of both already use
vm_normal_folio(); these two patches make the PMD halves match.

The four callers of vmf_insert_pfn_pmd(), and which walker each reaches:

  drivers/vfio/pci/vfio_pci_core.c        VM_PFNMAP     mempolicy
  drivers/gpu/drm/drm_gem_shmem_helper.c  VM_PFNMAP     mempolicy
  drivers/gpu/drm/panthor/panthor_gem.c   VM_PFNMAP     mempolicy
  drivers/hv/mshv_vtl_main.c              VM_MIXEDMAP   both

can_madv_lru_vma() rejects VM_PFNMAP, so only mshv_vtl_low reaches the
madvise walker, and that needs CAP_SYS_ADMIN.  queue_pages_walk_ops
supplies its own ->test_walk, so walk_page_test()'s generic VM_PFNMAP skip
never runs and vfio-pci is reachable by any process holding the device fd.
Hence the different stable tags.

One behaviour change: mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP
region now returns 0 rather than -EIO.  The PTE loop already returned 0
there.  drm_gem_shmem and panthor are where this is observable, since they
PMD map pages that do have a memmap entry and so never faulted.

Reproducer
==========

No hardware needed.  An out of tree module stands in for the drivers
above: three misc devices, each with a ->huge_fault calling
vmf_insert_pfn_pmd(), plus VM_HUGEPAGE so the fault path takes the PMD
branch.

  /dev/pmdspec_mixed    VM_MIXEDMAP, pfn at the 1 TiB mark, no memmap
  /dev/pmdspec_pfnmap   VM_PFNMAP,   pfn at the 1 TiB mark, no memmap
  /dev/pmdspec_real     VM_PFNMAP,   real alloc_pages(PMD_ORDER) on node 0

Userspace maps the device into a PMD aligned window, reads one byte to
fault the PMD in, checks a module parameter to confirm it went in, then
issues the operation.

  vng --run <bzImage> --user root --memory 4G --verbose \
      --append "numa=fake=2" \
      --exec "insmod pmdspec.ko && ./pmdspec_test <subtest>"

numa=fake=2 gives a node 1 to bind to; the module allocates its real page
on node 0, which is what makes queue_folio_required() true.

  subtest        operation                              parent   series
  --------------------------------------------------------------------
  madv_cold      madvise(MADV_COLD)                     oops     ret=0
  madv_pageout   madvise(MADV_PAGEOUT)                  oops     ret=0
  mbind_mixed    mbind(MPOL_BIND, n1, MPOL_MF_MOVE)     oops     ret=0
  mbind_pfnmap   mbind(MPOL_BIND, n1, MPOL_MF_STRICT)   oops     ret=0
  mbind_real     mbind(MPOL_BIND, n1, MPOL_MF_STRICT)   -EIO     ret=0

Two things the table shows that are easy to miss in the code:

  - mbind_mixed passes only MPOL_MF_MOVE.  MPOL_MF_STRICT is not needed for
    a VM_MIXEDMAP vma: walk_page_test() only skips VM_PFNMAP, and
    vma_migratable() is true for VM_MIXEDMAP.

  - mbind_real demonstrates the user visible change (-EIO -> 0)

This patch (of 2):

mmap a VM_PFNMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - a vfio-pci MMIO BAR does this - then

	mbind(p, len, MPOL_BIND, &mask, maxnode, MPOL_MF_STRICT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff96dc0000008
  RIP: 0010:queue_folios_pte_range+0xaf/0x440
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   queue_pages_range+0x64/0xa0
   do_mbind+0x25e/0x640

queue_folios_pmd(), inlined above, calls pmd_folio() on that PMD.  The pfn
is raw MMIO with no memmap entry, so the folio lands in unpopulated
vmemmap.  Neither guard stops the walk:

  walk_page_test()         skips VM_PFNMAP, but queue_pages_walk_ops
                           supplies ->test_walk, so it never runs
  queue_pages_test_walk()  honours vma_migratable(), but only while
                           MPOL_MF_STRICT is clear

A VM_MIXEDMAP vma needs neither flag, being vma_migratable(), so plain
mbind(MPOL_MF_MOVE) reaches this too - and there the bad folio carries on
into migrate_folio_add() and folio_isolate_lru().  mshv_vtl_low is such a
mapping.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE loop in
queue_folios_pte_range() already does with vm_normal_folio().  This also
filters the huge zero PMD, so its separate check is no longer needed.

mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
rather than -EIO.  The PTE loop already returned 0 there.

Link: https://lore.kernel.org/20260926105110.2156652-1-gourry@gourry.net
Link: https://lore.kernel.org/20260926105110.2156652-2-gourry@gourry.net
Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>
[ sashal: Passed *pmd to vm_normal_folio_pmd() instead of the upstream cached pmdval variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6f29f764762b2..193ebf34bf083 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -500,7 +500,8 @@ static inline bool queue_folio_required(struct folio *folio,
 	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
 }
 
-static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
+static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
+		struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -509,11 +510,9 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 		qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(*pmd);
-	if (is_huge_zero_folio(folio)) {
-		walk->action = ACTION_CONTINUE;
+	folio = vm_normal_folio_pmd(walk->vma, addr, *pmd);
+	if (!folio || folio_is_zone_device(folio))
 		return;
-	}
 	if (!queue_folio_required(folio, qp))
 		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
@@ -545,7 +544,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		queue_folios_pmd(pmd, walk);
+		queue_folios_pmd(pmd, addr, walk);
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.53.0



