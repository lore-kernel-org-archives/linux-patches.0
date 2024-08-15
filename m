Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFEE1A7068;
	Thu, 15 Aug 2024 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731014; cv=none; b=r4guaqiJuBgsekwqtU5ZHdQjokEJHW+/9p1rxNeB83UQwUDlPzfbVCD653t1srlRPfDt9IqLEeYqQ1AlUYDifZX0dCCzCAWGId2ADgZTl4qzIyagxrzRFTuj2hJU9h65sTugVGhCFxn5GvM+UQ+lPPGAwLYN9uFY4K0kkU2F3BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731014; c=relaxed/simple;
	bh=OoRRYk2Xv2Bz4pZtuEjx4Z1r8g6zaT0w1qtttg25l5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKnaIr/lNkIE/qbGGbYLmkQRUiFcnlLu00Ssz9oPa3AIm71yE5BA9RIrI4hhgoG52pAJxzdaOcvCLcNX9OUvIQFyKG8x53rs8/NwtWdO8kaQV3NBYBG7hFufFqrz12NSfNUTrlCPIm1LNuGLtRVKY/28ufyoTLrKXosn55fEpbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL77cZnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL77cZnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC72C4AF0A;
	Thu, 15 Aug 2024 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731013;
	bh=OoRRYk2Xv2Bz4pZtuEjx4Z1r8g6zaT0w1qtttg25l5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL77cZnUOraiTLjmGm0xYAvObqc6sbG9jbhEz5BXi27m6UIYG23VcaN0YAE+fMxLo
	 3X3Y0jY9lGm/5zI1o8M+EA8x0NgWavep1tUfuIbMc+GXEP5GQh9JwK35EklSg8w655
	 s+Fy/EBgzEzNhttPW+c6Y+TGhrjgpQJMfMvw2qgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Hildenbrand <david@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Gavin Shan <gshan@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 64/67] mm/debug_vm_pgtable: drop RANDOM_ORVALUE trick
Date: Thu, 15 Aug 2024 15:26:18 +0200
Message-ID: <20240815131840.757320401@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Xu <peterx@redhat.com>

commit 0b1ef4fde7a24909ff2afacffd0d6afa28b73652 upstream.

Macro RANDOM_ORVALUE was used to make sure the pgtable entry will be
populated with !none data in clear tests.

The RANDOM_ORVALUE tried to cover mostly all the bits in a pgtable entry,
even if there's no discussion on whether all the bits will be vaild.  Both
S390 and PPC64 have their own masks to avoid touching some bits.  Now it's
the turn for x86_64.

The issue is there's a recent report from Mikhail Gavrilov showing that
this can cause a warning with the newly added pte set check in commit
8430557fc5 on writable v.s.  userfaultfd-wp bit, even though the check
itself was valid, the random pte is not.  We can choose to mask more bits
out.

However the need to have such random bits setup is questionable, as now
it's already guaranteed to be true on below:

  - For pte level, the pgtable entry will be installed with value from
    pfn_pte(), where pfn points to a valid page.  Hence the pte will be
    !none already if populated with pfn_pte().

  - For upper-than-pte level, the pgtable entry should contain a directory
    entry always, which is also !none.

All the cases look like good enough to test a pxx_clear() helper.  Instead
of extending the bitmask, drop the "set random bits" trick completely.  Add
some warning guards to make sure the entries will be !none before clear().

Link: https://lkml.kernel.org/r/20240523132139.289719-1-peterx@redhat.com
Fixes: 8430557fc584 ("mm/page_table_check: support userfault wr-protect entries")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/r/CABXGCsMB9A8-X+Np_Q+fWLURYL_0t3Y-MdoNabDM-Lzk58-DGA@mail.gmail.com
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/debug_vm_pgtable.c |   31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -39,22 +39,7 @@
  * Please refer Documentation/mm/arch_pgtable_helpers.rst for the semantics
  * expectations that are being validated here. All future changes in here
  * or the documentation need to be in sync.
- *
- * On s390 platform, the lower 4 bits are used to identify given page table
- * entry type. But these bits might affect the ability to clear entries with
- * pxx_clear() because of how dynamic page table folding works on s390. So
- * while loading up the entries do not change the lower 4 bits. It does not
- * have affect any other platform. Also avoid the 62nd bit on ppc64 that is
- * used to mark a pte entry.
  */
-#define S390_SKIP_MASK		GENMASK(3, 0)
-#if __BITS_PER_LONG == 64
-#define PPC64_SKIP_MASK		GENMASK(62, 62)
-#else
-#define PPC64_SKIP_MASK		0x0
-#endif
-#define ARCH_SKIP_MASK (S390_SKIP_MASK | PPC64_SKIP_MASK)
-#define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
 struct pgtable_debug_args {
@@ -510,8 +495,7 @@ static void __init pud_clear_tests(struc
 		return;
 
 	pr_debug("Validating PUD clear\n");
-	pud = __pud(pud_val(pud) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->pudp, pud);
+	WARN_ON(pud_none(pud));
 	pud_clear(args->pudp);
 	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
@@ -547,8 +531,7 @@ static void __init p4d_clear_tests(struc
 		return;
 
 	pr_debug("Validating P4D clear\n");
-	p4d = __p4d(p4d_val(p4d) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->p4dp, p4d);
+	WARN_ON(p4d_none(p4d));
 	p4d_clear(args->p4dp);
 	p4d = READ_ONCE(*args->p4dp);
 	WARN_ON(!p4d_none(p4d));
@@ -581,8 +564,7 @@ static void __init pgd_clear_tests(struc
 		return;
 
 	pr_debug("Validating PGD clear\n");
-	pgd = __pgd(pgd_val(pgd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->pgdp, pgd);
+	WARN_ON(pgd_none(pgd));
 	pgd_clear(args->pgdp);
 	pgd = READ_ONCE(*args->pgdp);
 	WARN_ON(!pgd_none(pgd));
@@ -633,10 +615,8 @@ static void __init pte_clear_tests(struc
 	if (WARN_ON(!args->ptep))
 		return;
 
-#ifndef CONFIG_RISCV
-	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
-#endif
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	WARN_ON(pte_none(pte));
 	flush_dcache_page(page);
 	barrier();
 	ptep_clear(args->mm, args->vaddr, args->ptep);
@@ -649,8 +629,7 @@ static void __init pmd_clear_tests(struc
 	pmd_t pmd = READ_ONCE(*args->pmdp);
 
 	pr_debug("Validating PMD clear\n");
-	pmd = __pmd(pmd_val(pmd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->pmdp, pmd);
+	WARN_ON(pmd_none(pmd));
 	pmd_clear(args->pmdp);
 	pmd = READ_ONCE(*args->pmdp);
 	WARN_ON(!pmd_none(pmd));


