Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047506;
	b=2iaiu8PfLncbEWW0AAhR8cW+2tgr9d9/U15cArPBQxj40NePWTcfP8o7zwTyidrIMWSL
	 akb8SPge+/PZCbDR5XgJonSjp5itd9mmtTc3lRjdvAATzQ5j7C7kkzl7WAjVHcHxGqvFT
	 UOLBz/QS1rR1ZwhEwe1tIq16zqwA077yFibHAPO5dDbtoo03+ibT0hHYLD/V650LeHn5t
	 ByAoInNtTpdlJRJoB+9zr+3gpAUndiL8rP1RpYexONWGmIbmO93C3khOTn4p2KZf2K3Qm
	 /oqSNeNQu12wpum6gAKr6xHq/M6i90LyvHBonLByGGTYoR3GBq0o0mJeVPjDcWLx9CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dodrWtatEYqk4F9e+6tkbBLFy0yH3LR1+mI9XEhADxo=;
	b=d8UrivcdGAxa3y+lrP38TLy7ebOwk4eABh/j5B6BIu8t6mhAs59VmmpALNsGI4AtslAb
	 WTl1Izv5vSxIYM7bSE16bIx2lbNSp2RAmtXcRkunmT8n0Wa4wRnCsB0AR36bIyWBBR7c2
	 aWHHHOtVSlvsIrLaqgrHDl9mPd+MAVKZA6+2I6bWComSgeW1DGHUKvZfxtwlAE9LtoQvZ
	 cwH1wtlpKLp6Mw/SJG1TvCKObcGAg/+CNhpWFA7rorHuMEPw/CPAMxFqiKgtdpTIvjIPf
	 KzJt1bHWjQ9o3Y7R0GnM2Eud2B50XBhV8yJerpMi6u9m1a8YGqCmQMD3v6KeG7pOIgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2h8VteKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED95606A32C;
	Thu, 19 Nov 2026 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2h8VteKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B091F000C4;
	Thu, 19 Nov 2026 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047505;
	bh=dodrWtatEYqk4F9e+6tkbBLFy0yH3LR1+mI9XEhADxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2h8VteKi26CEp9vsQUZ04dmUD1Zj5JE11d5WjqWNPIH9ZpbyWTs98aajdxY1cCySb
	 70M0Wk7FVuRSfwu4mlQfPeloHNnUY2OH2dq6rDcRbVwSsHsjwvOSzOWSYczjuIM3ft
	 h+xa0b44yam7DtNgSvoqlJxQPkK3SemiDxtpYYEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhe <lizhe.67@bytedance.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1663/2857] mm/hugetlb: fix mremap deadlock when PMD sharing is possible
Date: Wed, 18 Nov 2026 15:44:57 +0100
Message-ID: <20261118150301.203755895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhe <lizhe.67@bytedance.com>

[ Upstream commit 92daa8652f88c8cfc05f4899a8408a04b02f211e ]

move_hugetlb_page_tables() holds the mapping's i_mmap_rwsem for
write while moving hugetlb PTEs. This prevents races with truncation
and protects huge_pmd_unshare(), but the move loop must not call
helpers that can acquire the same rwsem for read.

huge_pte_alloc() can do that when the destination can use PMD
sharing: it may call huge_pmd_share(), which takes i_mmap_rwsem for
read while searching for a shareable PMD table. Calling it while the
move path already holds i_mmap_rwsem for write can deadlock.

Avoid that path for PMD-sized hugetlb mappings that can use PMD
sharing. Instead of allocating or sharing the destination page table
while moving, zap the source range and let the destination fault path
populate or share the PMD lazily.

Reuse the hugetlb unmap logic for the source-side zap by splitting
the core loop out of __unmap_hugepage_range(). The wrapper keeps the
existing tlb_start_vma(), tlb_end_vma() and huge_pmd_unshare_flush()
behavior, while move_hugetlb_page_tables() can reuse the unmap loop
with its existing mmu_gather.

Link: https://lore.kernel.org/20261022034543.51226-4-lizhe.67@bytedance.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: moved existing MMU notifier calls into the unmap wrapper to preserve notification ordering ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 66 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9660566a1ba4b..a4b5243281af0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -99,6 +99,10 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct page *ref_page,
+				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -5292,6 +5296,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
+		const unsigned long offset_to_last_dst_entry =
+			(new_addr | last_addr_mask) - new_addr;
 
 		src_pte = huge_pte_offset(mm, old_addr, sz);
 		if (!src_pte) {
@@ -5308,6 +5314,24 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 			continue;
 		}
 
+		/*
+		 * Avoid entering the destination PMD sharing path while holding
+		 * i_mmap_rwsem for write. Leave destination page table
+		 * population to the fault path, which can share the PMD lazily.
+		 */
+		if (sz == PMD_SIZE && want_pmd_share(new_vma, new_addr)) {
+			const unsigned long unmap_size =
+				min(old_end - old_addr,
+				    offset_to_last_dst_entry + sz);
+
+			hugetlb_unmap_range(&tlb, vma, old_addr,
+					    old_addr + unmap_size, NULL,
+					    ZAP_FLAG_DROP_MARKER);
+			old_addr += unmap_size - sz;
+			new_addr += unmap_size - sz;
+			continue;
+		}
+
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
 			break;
@@ -5327,9 +5351,10 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	return len + old_addr - old_end;
 }
 
-static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end,
-				   struct page *ref_page, zap_flags_t zap_flags)
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct page *ref_page,
+				zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5339,27 +5364,12 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
-	/*
-	 * This is a hugetlb vma, all the pte entries should point
-	 * to huge page.
-	 */
-	tlb_change_page_size(tlb, sz);
-	tlb_start_vma(tlb, vma);
-
-	/*
-	 * If sharing possible, alert mmu notifiers of worst case.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
-				end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
-	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5446,6 +5456,26 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		if (ref_page)
 			break;
 	}
+}
+
+static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   struct page *ref_page, zap_flags_t zap_flags)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+
+	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
+	tlb_start_vma(tlb, vma);
+
+	/*
+	 * If sharing possible, alert mmu notifiers of worst case.
+	 */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
+				end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+	hugetlb_unmap_range(tlb, vma, start, end, ref_page, zap_flags);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
-- 
2.53.0



