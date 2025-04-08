Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E4A3AC1C;
	Tue,  8 Apr 2025 11:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113551; cv=none; b=X2SPCL5s5xrjRQ1Hn0/tLZEjSHZH2JNcbX/2Iw4nVMobwm1BbXhy+S7x960+ZBL8XP5AlOvpr8imgYrpBUvXis4eL+D6euxQXJWgWD3yNGCxjHtpE1YKosNWfCStoFFZEyCmqpDNZaWYZmayKf6eB0RLqlpU9ZT/gc3bwoNBfKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113551; c=relaxed/simple;
	bh=gCBP44HmAkDyj232p4aKJxoIKT5i+Yu6zOq4opyg+Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+Tu03rSJPAdXCJzpFErr02MWq5hldRlmHY+arPkyyvvVk7EtiurRzC6Fc4Jd7UgskC3DEkhSvA6JMlFrl9pMvpWW2zx1NSErdu8TcpMoh6YJZr+F0XeOjyW28OOkEwYJem3KedSAFOblZEA5+VONDpsFgOMiXAN/T5oYdIp9PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNoQcb9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNoQcb9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751DBC4CEE5;
	Tue,  8 Apr 2025 11:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113550;
	bh=gCBP44HmAkDyj232p4aKJxoIKT5i+Yu6zOq4opyg+Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNoQcb9iQZS8BZ24uPbrum5VOAZzzRg7kcTS4mBk1pjgGzZufinYQFAo+N/cODBJl
	 /IFjrkMlcC4Gg6IWk+q6obAVTSyCQ4Tj1PrVKxXpL7fLGIjs3hlq25HKWRPzaJfkqr
	 A1598tdmE9lKaLeFLNtYK9BIQJVteqGazZyOMv0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/268] riscv: Fix hugetlb retrieval of number of ptes in case of !present pte
Date: Tue,  8 Apr 2025 12:50:13 +0200
Message-ID: <20250408104834.006545888@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 83d78ac677b9fdd8ea763507c6fe02d6bf415f3a ]

Ryan sent a fix [1] for arm64 that applies to riscv too: in some hugetlb
functions, we must not use the pte value to get the size of a mapping
because the pte may not be present.

So use the already present size parameter for huge_pte_clear() and the
newly introduced size parameter for huge_ptep_get_and_clear(). And make
sure to gather A/D bits only on present ptes.

Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Link: https://lore.kernel.org/all/20250217140419.1702389-1-ryan.roberts@arm.com/ [1]
Link: https://lore.kernel.org/r/20250317072551.572169-1-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/hugetlbpage.c | 76 ++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index c9d70dc310d59..57afbc3270a3c 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -148,22 +148,25 @@ unsigned long hugetlb_mask_last_page(struct hstate *h)
 static pte_t get_clear_contig(struct mm_struct *mm,
 			      unsigned long addr,
 			      pte_t *ptep,
-			      unsigned long pte_num)
+			      unsigned long ncontig)
 {
-	pte_t orig_pte = ptep_get(ptep);
-	unsigned long i;
-
-	for (i = 0; i < pte_num; i++, addr += PAGE_SIZE, ptep++) {
-		pte_t pte = ptep_get_and_clear(mm, addr, ptep);
-
-		if (pte_dirty(pte))
-			orig_pte = pte_mkdirty(orig_pte);
-
-		if (pte_young(pte))
-			orig_pte = pte_mkyoung(orig_pte);
+	pte_t pte, tmp_pte;
+	bool present;
+
+	pte = ptep_get_and_clear(mm, addr, ptep);
+	present = pte_present(pte);
+	while (--ncontig) {
+		ptep++;
+		addr += PAGE_SIZE;
+		tmp_pte = ptep_get_and_clear(mm, addr, ptep);
+		if (present) {
+			if (pte_dirty(tmp_pte))
+				pte = pte_mkdirty(pte);
+			if (pte_young(tmp_pte))
+				pte = pte_mkyoung(pte);
+		}
 	}
-
-	return orig_pte;
+	return pte;
 }
 
 static pte_t get_clear_contig_flush(struct mm_struct *mm,
@@ -212,6 +215,26 @@ static void clear_flush(struct mm_struct *mm,
 	flush_tlb_range(&vma, saddr, addr);
 }
 
+static int num_contig_ptes_from_size(unsigned long sz, size_t *pgsize)
+{
+	unsigned long hugepage_shift;
+
+	if (sz >= PGDIR_SIZE)
+		hugepage_shift = PGDIR_SHIFT;
+	else if (sz >= P4D_SIZE)
+		hugepage_shift = P4D_SHIFT;
+	else if (sz >= PUD_SIZE)
+		hugepage_shift = PUD_SHIFT;
+	else if (sz >= PMD_SIZE)
+		hugepage_shift = PMD_SHIFT;
+	else
+		hugepage_shift = PAGE_SHIFT;
+
+	*pgsize = 1 << hugepage_shift;
+
+	return sz >> hugepage_shift;
+}
+
 /*
  * When dealing with NAPOT mappings, the privileged specification indicates that
  * "if an update needs to be made, the OS generally should first mark all of the
@@ -226,22 +249,10 @@ void set_huge_pte_at(struct mm_struct *mm,
 		     pte_t pte,
 		     unsigned long sz)
 {
-	unsigned long hugepage_shift, pgsize;
+	size_t pgsize;
 	int i, pte_num;
 
-	if (sz >= PGDIR_SIZE)
-		hugepage_shift = PGDIR_SHIFT;
-	else if (sz >= P4D_SIZE)
-		hugepage_shift = P4D_SHIFT;
-	else if (sz >= PUD_SIZE)
-		hugepage_shift = PUD_SHIFT;
-	else if (sz >= PMD_SIZE)
-		hugepage_shift = PMD_SHIFT;
-	else
-		hugepage_shift = PAGE_SHIFT;
-
-	pte_num = sz >> hugepage_shift;
-	pgsize = 1 << hugepage_shift;
+	pte_num = num_contig_ptes_from_size(sz, &pgsize);
 
 	if (!pte_present(pte)) {
 		for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
@@ -295,13 +306,14 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      unsigned long addr,
 			      pte_t *ptep, unsigned long sz)
 {
+	size_t pgsize;
 	pte_t orig_pte = ptep_get(ptep);
 	int pte_num;
 
 	if (!pte_napot(orig_pte))
 		return ptep_get_and_clear(mm, addr, ptep);
 
-	pte_num = napot_pte_num(napot_cont_order(orig_pte));
+	pte_num = num_contig_ptes_from_size(sz, &pgsize);
 
 	return get_clear_contig(mm, addr, ptep, pte_num);
 }
@@ -351,6 +363,7 @@ void huge_pte_clear(struct mm_struct *mm,
 		    pte_t *ptep,
 		    unsigned long sz)
 {
+	size_t pgsize;
 	pte_t pte = ptep_get(ptep);
 	int i, pte_num;
 
@@ -359,8 +372,9 @@ void huge_pte_clear(struct mm_struct *mm,
 		return;
 	}
 
-	pte_num = napot_pte_num(napot_cont_order(pte));
-	for (i = 0; i < pte_num; i++, addr += PAGE_SIZE, ptep++)
+	pte_num = num_contig_ptes_from_size(sz, &pgsize);
+
+	for (i = 0; i < pte_num; i++, addr += pgsize, ptep++)
 		pte_clear(mm, addr, ptep);
 }
 
-- 
2.39.5



