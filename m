Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC64D11193;
	Mon,  4 Mar 2024 21:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588489; cv=none; b=CPfyYKracQgM9QQWc6fvL6jC91JYNr5z4IpH4JcFtnMkSXx6J+p9pp7adQLXgVEw3xEuwfMSC4ixp89x5bcZ2cralQw40/LoU/buxWqpy+d3CyXSAVRXEOgVR56Wg1LI/a4OkEQFGMHPN8Htgq063GZJ/1oV8kgStdqmh24hZG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588489; c=relaxed/simple;
	bh=leFmyRY3YVxHq06ymcbDG3cQ/PcAHLQR0Ym2hbI4pkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2RD+C0rm1luUZVAj4sKACEMwH8IKDHxVDkPN3509WI7J9uCo2DzXhVa/Gou6gAKuxz0r0SZoZXsd74YF1o+DK4MeffDCMjVjL4TZtu6MPpjM5K9HPSA8dVqyguRSud81QKUToMzRBMLGt0YF4WOzGhiQxFeOc/Hx+3joe2VWfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZfE9JyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZfE9JyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D19BC433C7;
	Mon,  4 Mar 2024 21:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588489;
	bh=leFmyRY3YVxHq06ymcbDG3cQ/PcAHLQR0Ym2hbI4pkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZfE9JyVhrSgQ2g7gjsHq82/TZ4FBzl0LfJK2H4Oc1whdHIpqN01BU3kugmQPBrDc
	 pbQS6Hi6il0jkwUPPE2fIGyVkGQk9SxFaCc7RFfoJrf2E0Gki4E0wPy8EZuh59GGeS
	 heeZQVSDd+8ZGbMfot36ZLqnGG8wqnblCVhZGXls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 103/143] mm/debug_vm_pgtable: fix BUG_ON with pud advanced test
Date: Mon,  4 Mar 2024 21:23:43 +0000
Message-ID: <20240304211553.202254271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
 mm/debug_vm_pgtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 5662e29fe253..65c19025da3d 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -362,6 +362,12 @@ static void __init pud_advanced_tests(struct pgtable_debug_args *args)
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
@@ -374,6 +380,7 @@ static void __init pud_advanced_tests(struct pgtable_debug_args *args)
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	pud = pud_mkdevmap(pud);
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
@@ -391,6 +398,7 @@ static void __init pud_advanced_tests(struct pgtable_debug_args *args)
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	pud = pud_mkdevmap(pud);
 	pud = pud_mkyoung(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);
-- 
2.44.0



