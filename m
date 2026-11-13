Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590332;
	b=y7zJdLaw+BDqyvhg/C8/JeHpejt25ndinN2uDulUA2upOiChYmuaMjbGkEZuSopUhWIa
	 okH2dq1PsP9XhbCk3NpLPSOtn3D4DoxLkLlB32eIEysUhJEHLq2fU1R4YBPgUv8gsYIAz
	 MkyJlYr28H7YjPZGmuffAHeoAi0xGsVp2p8H5sgMlhSRp+er4OT8qdW6QiloR+9BdyTyo
	 9BExEOB/iFv6eZOR0KaH02dmKnHs7UF4nNqw481CJFtXP8o5c1gbdgGaKbvFeBBMOUBt/
	 TdXvSfuxlGS+D8TaNLbeMUI//XYnO4hnzpPQKVyzqh944uug6MgMaWq3e/QmHJ2swlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=erKu3rwGl5NzcbXw8z3Pc/EFXZa7lZhHXQBeF5oDDb4=;
	b=nCPNQMqZJvGvKbPrdPqJi39upC7vQru5i/bi/f9u477oIwJoG93WjGO6YFWPAt8QTe0+
	 EOQP0GRsrAWvDz3s86ORNS9Lpj11KOkVM2amiJMqoIt739idxbqXtOxk47V8Iy7KvR034
	 HxX4VCbOH52peIfkJRQiB0j0Zm3Za3noFu4/flO2fj5sL3T1gq4fKc0tVQSr39eVW2CFU
	 4m9AERFiFwSD59fRprkzNb2tWyPUsqZ/mAXlu9Qdi8B5Z3ujKXtU1t3Lm8M4PRIoJcDaz
	 UoFZfLhuG2uJ+CCleRxyMkJxWQFFc6EL4Jk44lkBEfh2jPB0zM8NOihcneUjw55NdJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pss+x+89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435F1606D49D;
	Fri, 13 Nov 2026 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pss+x+89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ABE1F000CB;
	Fri, 13 Nov 2026 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590331;
	bh=erKu3rwGl5NzcbXw8z3Pc/EFXZa7lZhHXQBeF5oDDb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pss+x+89k76+qWwELSs7a/NCOnxoOhuXAOBHAcoqKk2W1H809B5h27XPDOH5zptuK
	 ro9HoKBz7r9rMleLwrYlBsPdIao19a3VR0Dx9LiVjMVP3XA/6DoidMJLt2PwO5sMU+
	 jrcuE7MeVd4WZOOgrgKfItN7lXAiuAzUe4hfKYYA=
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
Subject: [PATCH 6.18 311/686] mm/hugetlb: fix mremap deadlock when PMD sharing is possible
Date: Fri, 13 Nov 2026 10:47:24 -0500
Message-ID: <20261113153831.485526174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1d71352bfec57..bf1188e9b1c9b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -126,6 +126,10 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static void hugetlb_free_folio(struct folio *folio)
@@ -5860,6 +5864,8 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
+		const unsigned long offset_to_last_dst_entry =
+			(new_addr | last_addr_mask) - new_addr;
 
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
@@ -5876,6 +5882,24 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
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
@@ -5895,9 +5919,10 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	return len + old_addr - old_end;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct folio *folio, zap_flags_t zap_flags)
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	const bool folio_provided = !!folio;
@@ -5915,13 +5940,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
-	/*
-	 * This is a hugetlb vma, all the pte entries should point
-	 * to huge page.
-	 */
-	tlb_change_page_size(tlb, sz);
-	tlb_start_vma(tlb, vma);
-
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -6050,6 +6068,15 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (folio_provided)
 			break;
 	}
+}
+
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			    unsigned long start, unsigned long end,
+			    struct folio *folio, zap_flags_t zap_flags)
+{
+	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
+	tlb_start_vma(tlb, vma);
+	hugetlb_unmap_range(tlb, vma, start, end, folio, zap_flags);
 	tlb_end_vma(tlb, vma);
 
 	huge_pmd_unshare_flush(tlb, vma);
-- 
2.53.0



