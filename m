Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C5E4F4049;
	Wed, 30 Sep 2026 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787677; cv=none; b=J45YQTIP0b+KbTvLSwTcjqcpZq5ufOvRj1+oKHFjo3Lx68HFQ7rj5WvYe0Ani1ePq+S1kHC1w6DdXTEQV7DPWCl0l7qwGLq99DgPzCqvEihMlBew/gNFFIaj//8+y0KNIhYnrf1c5abREguZR8EHscf0nAWCSHQRZIAk/axRc8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787677; c=relaxed/simple;
	bh=vaSwSYQJd59Dti8JsQJ/3WYF/YWUYFWn+amPPzS5IJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnKkZrosmBBjRArvtOeDdZ6wuMx+eGqrWnW4eCECU1U8/QuEKiguf/aCBuPSoXqdUPN78yxvgjtLYhTBuShIhiTFfvHdwTDPJxPxugQeZk5U0wz4etrgnZWVXuhWRLJIO+O1fo9mYcaygWlLof1CSx/5pMMwhxf5+Nm7G1iGtV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sChCfRKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sChCfRKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AADD1F000FF;
	Wed, 30 Sep 2026 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787675;
	bh=lQTFFx0N1LLYZ/JmXjyRu9+OXSoa5re8NQE5QQkyxK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sChCfRKtdM5NUg5h/vezpsCtVBQTf8qwdxhw8+1oBtqDaeFC+HZ21zH6ZvKfQy9LT
	 fwHkZB2v5u+HARor0l1Mn08Y2IbgGhr+fWZqMpBU+1jfQG6NSTIpZyTagEF7jymnkQ
	 9dbS6fhqFMN4h6hhcg55wP8N9AEa5GnOinA4Sxb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Gao <zcgao@amazon.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 7.2 315/457] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Wed, 30 Sep 2026 17:27:00 +0200
Message-ID: <20260930152352.823122863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Gao <zcgao@amazon.com>

commit f166586f74dd5d9cbadaabf86ef81c8ddf6cafa7 upstream.

__damon_va_prepare_access_check() picks a random byte address within the
region and stores it in r->sampling_addr.  damon_va_mkold() passes it into
a page table walk, which hands it to damon_ptep_mkold() as the address of
the page to sample:

  damon_va_mkold(mm, r->sampling_addr)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_mkold_pmd_entry()
        damon_ptep_mkold(pte, vma, addr)
          ptep_test_and_clear_young(vma, addr, pte)
          mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)

For arm64, before commit 6f0e1142173a ("arm64: mm: support batch clearing
of the young flag for large folios"), the contpte helper walked exactly
CONT_PTES entries from the aligned-down page table pointer and used @addr
only to pass down to each entry, so an unaligned value was harmless:

        ptep = contpte_align_down(ptep);
        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
        for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)

Now the range to walk is derived from @addr instead: end = addr + nr *
PAGE_SIZE, rounded up to CONT_PTE_SIZE.  For a sample in the last page of
a contpte block, the sub-page offset puts end just past the block
boundary, so the round-up lands a whole block further and the walk clears
PTE_AF in CONT_PTES entries beyond the sampled block.  For the last block
in a page table page, those entries are past the end of that page, so the
walk writes into the page that follows.

Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
c/m6g.4xlarge).  The kernel sometimes crashes at or shortly after the
DAMON test.

What the overrun does depends on the page that happens to follow the page
table, so there is no single signature.  If that page is read-only, the
write faults in the sampling path itself:

  Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
    FSC = 0x0f: level 3 permission fault
    CM = 0, WnR = 1, TnD = 0, TagAccess = 0
  CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
  pc : contpte_test_and_clear_young_ptes+0x70/0xc0
  lr : damon_ptep_mkold+0x1e8/0x1f8
  Call trace:
   contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
   damon_mkold_pmd_entry+0x150/0x170
   walk_pmd_range+0x110/0x2b0
   walk_pud_range+0x10c/0x208
   walk_pgd_range+0x134/0x258
   __walk_page_range+0x98/0x1b0
   walk_page_range_vma_unsafe+0x90/0x148
   walk_page_range_vma+0x28/0x40
   damon_va_walk_page_range+0x114/0x2b8
   damon_va_prepare_access_checks+0xec/0x1a8
   kdamond_fn+0x534/0x770
   kthread+0x128/0x138
   ret_from_fork+0x10/0x20

Otherwise the page is writable, the PTE_AF clearing succeeds silently and
the damage only surfaces later, in whatever happened to own the page, so
the backtrace is unrelated to DAMON and differs between runs.

Pass a page-aligned address to the ptep_test_and_clear_young() call in
damon_ptep_mkold(), which is the only place DAMON can reach
contpte_test_and_clear_young_ptes() from.  Nothing else sees the aligned
address, and r->sampling_addr itself is left as is, so the sampling and
region bookkeeping semantics are unchanged.

Link: https://lore.kernel.org/20260904002829.116381-1-sj@kernel.org
Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/ops-common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index fbda70d8ea4d..8fc61d06d358 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -61,7 +61,12 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	 * device aspects.
 	 */
 	if (likely(pte_present(pteval)))
-		young |= ptep_test_and_clear_young(vma, addr, pte);
+		/*
+		 * Arch implementation of ptep_test_and_clear_young() may
+		 * require aligned @addr
+		 */
+		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
+				pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);
-- 
2.55.0



