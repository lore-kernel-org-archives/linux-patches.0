Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220EB2253FE;
	Mon, 10 Mar 2025 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628222; cv=none; b=lPRzrYq0TORBvAxn9bxL/e8phCo6e+LVLdUp+uL6Zb7YHfXJtwqaXe6klPFteX/kOP03GKiGob6+j2c8xH6OmTCMVgQUxtlDxq1eT5wUqtLtkEMO+5gwGu7LkXKp/pOW1k7hKGrauG0y5HkAPuUWAq/9gN1wY8OFzwjDpGUbPXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628222; c=relaxed/simple;
	bh=IxV9CqmiYgUAaDJJynT4v6gzmBgfxOoOVjw+fTLP6S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5ziGEVwmPh6j4VHjv+akeivCe/KxQHep+iRtV8qXAubrYRJwJqZc423zOq8iqjmM1b8U7urWWUHowlSlY/HTIPGuDGkL8RcBHJIbA+LSGBuItR/umE25DkviL6lKTEHaByJk5pa0go+QtqYo4AdJwLR4JAeB8LqXmTHDQ3soAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwktffV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwktffV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1272C4CEE5;
	Mon, 10 Mar 2025 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628222;
	bh=IxV9CqmiYgUAaDJJynT4v6gzmBgfxOoOVjw+fTLP6S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwktffV2GjPml97PaMuTFTg1ZDlFQ+DYmzbrydzbGCqeDmAirr/PEn5gI5qgAL0f1
	 qoqCjtagzO82rHqdYGh2dox1Ndp0xaKT6//LF5dY/Zew2K4lD+KBc9oAhxfvxD+UVO
	 WeZS203npDGoeszf3cngSKbSBMUWizQa7lwchT40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 128/145] arm64: hugetlb: Fix huge_ptep_get_and_clear() for non-present ptes
Date: Mon, 10 Mar 2025 18:07:02 +0100
Message-ID: <20250310170439.935251768@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.

arm64 supports multiple huge_pte sizes. Some of the sizes are covered by
a single pte entry at a particular level (PMD_SIZE, PUD_SIZE), and some
are covered by multiple ptes at a particular level (CONT_PTE_SIZE,
CONT_PMD_SIZE). So the function has to figure out the size from the
huge_pte pointer. This was previously done by walking the pgtable to
determine the level and by using the PTE_CONT bit to determine the
number of ptes at the level.

But the PTE_CONT bit is only valid when the pte is present. For
non-present pte values (e.g. markers, migration entries), the previous
implementation was therefore erroneously determining the size. There is
at least one known caller in core-mm, move_huge_pte(), which may call
huge_ptep_get_and_clear() for a non-present pte. So we must be robust to
this case. Additionally the "regular" ptep_get_and_clear() is robust to
being called for non-present ptes so it makes sense to follow the
behavior.

Fix this by using the new sz parameter which is now provided to the
function. Additionally when clearing each pte in a contig range, don't
gather the access and dirty bits if the pte is not present.

An alternative approach that would not require API changes would be to
store the PTE_CONT bit in a spare bit in the swap entry pte for the
non-present case. But it felt cleaner to follow other APIs' lead and
just pass in the size.

As an aside, PTE_CONT is bit 52, which corresponds to bit 40 in the swap
entry offset field (layout of non-present pte). Since hugetlb is never
swapped to disk, this field will only be populated for markers, which
always set this bit to 0 and hwpoison swap entries, which set the offset
field to a PFN; So it would only ever be 1 for a 52-bit PVA system where
memory in that high half was poisoned (I think!). So in practice, this
bit would almost always be zero for non-present ptes and we would only
clear the first entry if it was actually a contiguous block. That's
probably a less severe symptom than if it was always interpreted as 1
and cleared out potentially-present neighboring PTEs.

Cc: stable@vger.kernel.org
Fixes: 66b3923a1a0f ("arm64: hugetlb: add support for PTE contiguous bit")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/r/20250226120656.2400136-3-ryan.roberts@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/hugetlbpage.c |   51 ++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -121,20 +121,11 @@ static int find_num_contig(struct mm_str
 
 static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 {
-	int contig_ptes = 0;
+	int contig_ptes = 1;
 
 	*pgsize = size;
 
 	switch (size) {
-#ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SIZE:
-		if (pud_sect_supported())
-			contig_ptes = 1;
-		break;
-#endif
-	case PMD_SIZE:
-		contig_ptes = 1;
-		break;
 	case CONT_PMD_SIZE:
 		*pgsize = PMD_SIZE;
 		contig_ptes = CONT_PMDS;
@@ -143,6 +134,8 @@ static inline int num_contig_ptes(unsign
 		*pgsize = PAGE_SIZE;
 		contig_ptes = CONT_PTES;
 		break;
+	default:
+		WARN_ON(!__hugetlb_valid_size(size));
 	}
 
 	return contig_ptes;
@@ -184,24 +177,23 @@ static pte_t get_clear_contig(struct mm_
 			     unsigned long pgsize,
 			     unsigned long ncontig)
 {
-	pte_t orig_pte = ptep_get(ptep);
-	unsigned long i;
+	pte_t pte, tmp_pte;
+	bool present;
 
-	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++) {
-		pte_t pte = ptep_get_and_clear(mm, addr, ptep);
-
-		/*
-		 * If HW_AFDBM is enabled, then the HW could turn on
-		 * the dirty or accessed bit for any page in the set,
-		 * so check them all.
-		 */
-		if (pte_dirty(pte))
-			orig_pte = pte_mkdirty(orig_pte);
-
-		if (pte_young(pte))
-			orig_pte = pte_mkyoung(orig_pte);
+	pte = ptep_get_and_clear(mm, addr, ptep);
+	present = pte_present(pte);
+	while (--ncontig) {
+		ptep++;
+		addr += pgsize;
+		tmp_pte = ptep_get_and_clear(mm, addr, ptep);
+		if (present) {
+			if (pte_dirty(tmp_pte))
+				pte = pte_mkdirty(pte);
+			if (pte_young(tmp_pte))
+				pte = pte_mkyoung(pte);
+		}
 	}
-	return orig_pte;
+	return pte;
 }
 
 static pte_t get_clear_contig_flush(struct mm_struct *mm,
@@ -408,13 +400,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
 {
 	int ncontig;
 	size_t pgsize;
-	pte_t orig_pte = ptep_get(ptep);
-
-	if (!pte_cont(orig_pte))
-		return ptep_get_and_clear(mm, addr, ptep);
-
-	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
 
+	ncontig = num_contig_ptes(sz, &pgsize);
 	return get_clear_contig(mm, addr, ptep, pgsize, ncontig);
 }
 


