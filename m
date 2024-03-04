Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923EE7CF18;
	Mon,  4 Mar 2024 21:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587904; cv=none; b=O4STc9nNRb/y8C5XoeG736RwsQ9mMxJDBzGlJhAN0QW7CTYVBhW0GxesnftrQR0dcvLFvV5f8MeqFDPWTGb9frUT+7/4+uOKw6EBR4Itc6unOboK71C6V/+GaE2mDJDGlYRUEB/I+29N0scdjbQ2rH+0f4ir+z/osF+kLnEpdnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587904; c=relaxed/simple;
	bh=eain4lAB6ngw/EYFGJE8S/GekDPPy6sCq/XOawazIU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XM84V5VcmssNxALNIRFNfTweN3Z8vL4qQEVNxZdih7M/DNhaOxMFwrqmOsUuHyu6Ug+XW24dYgdIMFQ6PzdJw+u1scwZoLEjtJ+kQnkMFSAyRhOXVvtYFZ1nkSPz2tFyJXZxCzEP6mxN/x6fmaEnj8qe5WFs3LmIwISrchpXyWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1PMhKMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1PMhKMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C36C433C7;
	Mon,  4 Mar 2024 21:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587904;
	bh=eain4lAB6ngw/EYFGJE8S/GekDPPy6sCq/XOawazIU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1PMhKMo4w8cCynAyAyYl0ngtgVphRQp605NIqqlgmKchnKjtiA0mRM0fML6U93Dh
	 Gw8WpGdOTIW4Cp3wRPEbTccLp0BUTF22TQKF5VXoa1iiob6qu9IBwykuI0w8fOUB5M
	 J1uJ6oEDS8rXBMEWWFuePCv/eTqi+xcuuVrQ60b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 117/162] mm/debug_vm_pgtable: fix BUG_ON with pud advanced test
Date: Mon,  4 Mar 2024 21:23:02 +0000
Message-ID: <20240304211555.507877682@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>

commit 720da1e593b85a550593b415bf1d79a053133451 upstream.

Architectures like powerpc add debug checks to ensure we find only devmap
PUD pte entries.  These debug checks are only done with CONFIG_DEBUG_VM.
This patch marks the ptes used for PUD advanced test devmap pte entries so
that we don't hit on debug checks on architecture like ppc64 as below.

WARNING: CPU: 2 PID: 1 at arch/powerpc/mm/book3s64/radix_pgtable.c:1382 radix__pud_hugepage_update+0x38/0x138
....
NIP [c0000000000a7004] radix__pud_hugepage_update+0x38/0x138
LR [c0000000000a77a8] radix__pudp_huge_get_and_clear+0x28/0x60
Call Trace:
[c000000004a2f950] [c000000004a2f9a0] 0xc000000004a2f9a0 (unreliable)
[c000000004a2f980] [000d34c100000000] 0xd34c100000000
[c000000004a2f9a0] [c00000000206ba98] pud_advanced_tests+0x118/0x334
[c000000004a2fa40] [c00000000206db34] debug_vm_pgtable+0xcbc/0x1c48
[c000000004a2fc10] [c00000000000fd28] do_one_initcall+0x60/0x388

Also

 kernel BUG at arch/powerpc/mm/book3s64/pgtable.c:202!
 ....

 NIP [c000000000096510] pudp_huge_get_and_clear_full+0x98/0x174
 LR [c00000000206bb34] pud_advanced_tests+0x1b4/0x334
 Call Trace:
 [c000000004a2f950] [000d34c100000000] 0xd34c100000000 (unreliable)
 [c000000004a2f9a0] [c00000000206bb34] pud_advanced_tests+0x1b4/0x334
 [c000000004a2fa40] [c00000000206db34] debug_vm_pgtable+0xcbc/0x1c48
 [c000000004a2fc10] [c00000000000fd28] do_one_initcall+0x60/0x388

Link: https://lkml.kernel.org/r/20240129060022.68044-1-aneesh.kumar@kernel.org
Fixes: 27af67f35631 ("powerpc/book3s64/mm: enable transparent pud hugepage")
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/debug_vm_pgtable.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -362,6 +362,12 @@ static void __init pud_advanced_tests(st
 	vaddr &= HPAGE_PUD_MASK;
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	/*
+	 * Some architectures have debug checks to make sure
+	 * huge pud mapping are only found with devmap entries
+	 * For now test with only devmap entries.
+	 */
+	pud = pud_mkdevmap(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);
 	pudp_set_wrprotect(args->mm, vaddr, args->pudp);
@@ -374,6 +380,7 @@ static void __init pud_advanced_tests(st
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	pud = pud_mkdevmap(pud);
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
@@ -391,6 +398,7 @@ static void __init pud_advanced_tests(st
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	pud = pud_mkdevmap(pud);
 	pud = pud_mkyoung(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);


