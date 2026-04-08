Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2844B3D75C9;
	Wed,  8 Apr 2026 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674123; cv=none; b=Wz1QiJ/pQe1aoe475BqpRyTG0AblvuXK5VT1CzFzJIraKVq7XPhDasvXpcDKe9fFWJkTSEoGaoEeJV1Weavq9ACLo65895mq75azbgLl97fJMM5gnkzGe/sfshB0p75tMhV7aNYwFF/7a3kOXVlmix3GAcAWGVjARJ/pynzCECw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674123; c=relaxed/simple;
	bh=4dr1lm8gzXOr3VI16dSs13mT6z55E07qIqOXCteOwJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsfakyCYKqxhgpt3lUJ+zW6g3sfgVfnYU8u5/pFP8xyZdhyfy5T+e+GSXYV8/PcGvc3tgxtCNSUozdQ/1R4T+SNmXA7eNXEuVTuI/THp+e9EF8StqZfSUeLEecQ8f+M8yIakqGppe5mm9HoEd++D0KW+mzFLWwvgBQPyRf1SSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKrRqd3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKrRqd3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8064C19421;
	Wed,  8 Apr 2026 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674123;
	bh=4dr1lm8gzXOr3VI16dSs13mT6z55E07qIqOXCteOwJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKrRqd3UDeZjIoyIpSoEPU5Mm/N+R63+26J6mVW6rSga8Tmp6AECCeZvwFt6QBAfO
	 a/6wWEriamknMpVbstuh+YMewFA80Wgb+4N5JcG/DZOl84BfYGRNY5SgGgAC8DIt71
	 RywqQl10L+MvYEW45cm5TiDIhPokwccnotqI2ilU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/242] mm: replace READ_ONCE() with standard page table accessors
Date: Wed,  8 Apr 2026 20:04:19 +0200
Message-ID: <20260408175935.282337893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit c0efdb373c3aaacb32db59cadb0710cac13e44ae ]

Replace all READ_ONCE() with a standard page table accessors i.e
pxdp_get() that defaults into READ_ONCE() in cases where platform does not
override.

Link: https://lkml.kernel.org/r/20251007063100.2396936-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ffef67b93aa3 ("mm/memory: fix PMD/PUD checks in follow_pfnmap_start()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c            |   10 +++++-----
 mm/hmm.c            |    2 +-
 mm/memory.c         |    4 ++--
 mm/mprotect.c       |    2 +-
 mm/sparse-vmemmap.c |    2 +-
 mm/vmscan.c         |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1013,7 +1013,7 @@ static struct page *follow_pud_mask(stru
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
@@ -1038,7 +1038,7 @@ static struct page *follow_p4d_mask(stru
 	p4d_t *p4dp, p4d;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	BUILD_BUG_ON(p4d_leaf(p4d));
 
 	if (!p4d_present(p4d) || p4d_bad(p4d))
@@ -3301,7 +3301,7 @@ static int gup_fast_pud_range(p4d_t *p4d
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
-		pud_t pud = READ_ONCE(*pudp);
+		pud_t pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
@@ -3327,7 +3327,7 @@ static int gup_fast_p4d_range(pgd_t *pgd
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
-		p4d_t p4d = READ_ONCE(*p4dp);
+		p4d_t p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
@@ -3349,7 +3349,7 @@ static void gup_fast_pgd_range(unsigned
 
 	pgdp = pgd_offset(current->mm, addr);
 	do {
-		pgd_t pgd = READ_ONCE(*pgdp);
+		pgd_t pgd = pgdp_get(pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -423,7 +423,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 	/* Normally we don't want to split the huge page */
 	walk->action = ACTION_CONTINUE;
 
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud)) {
 		spin_unlock(ptl);
 		return hmm_vma_walk_hole(start, end, -1, walk);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6451,12 +6451,12 @@ retry:
 		goto out;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
 		goto out;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto out;
 	if (pud_leaf(pud)) {
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -447,7 +447,7 @@ again:
 			break;
 		}
 
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -337,7 +337,7 @@ int __meminit vmemmap_populate_hugepages
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(READ_ONCE(*pmd))) {
+		if (pmd_none(pmdp_get(pmd))) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3631,7 +3631,7 @@ static int walk_pud_range(p4d_t *p4d, un
 	pud = pud_offset(p4d, start & P4D_MASK);
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
-		pud_t val = READ_ONCE(pud[i]);
+		pud_t val = pudp_get(pud + i);
 
 		next = pud_addr_end(addr, end);
 


