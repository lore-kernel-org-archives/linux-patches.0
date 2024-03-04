Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3168F58;
	Mon,  4 Mar 2024 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588320; cv=none; b=Un8Gv6t4yq/dtl+CI7dLAUFB6SNfZ9jtADeBKZN+BolljoDpKpvtdN9GOBDYqfw2XdLVNW4/kujgJWGV4XfvnFlyWQYE/U/qhDH1Nsa+BaMvm9eaHoO/EUCTtYFHleZnhgAMnN/mHKbRBE0hV10QQTES1LlO+KymrrQOh5/U37o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588320; c=relaxed/simple;
	bh=OQkgjK36JcRDhg/sG8HEciJk7IDyZZBs06phuQBS1u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRIzaxTrnS2VxjGXP5bRFrBUzaGsR0j2LwmqJVsRADFQ9wt2uOTDAwQWcA1R6lnv4ll/aN76XQejRdb267V7cz7uq3zPeo7AHgXpLiCw3QHpGLDOAHl7cs8nlGTnbQ951yf4BHfvvgIclu0v0efz1uen5+OokEQWXHvNS2ic3bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awjp3uSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awjp3uSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E2CC433C7;
	Mon,  4 Mar 2024 21:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588320;
	bh=OQkgjK36JcRDhg/sG8HEciJk7IDyZZBs06phuQBS1u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awjp3uSE4DEOhZ3Fp4yMWcQdgEHN3wgCKtRLzV7IZlhvsTVVgQUSDqFzEILI03reT
	 oxxFCOBYOJ6Bh1vnZMq/w/UU/pKGZmP8Pxz1djZP0b3+oLC0Bxv8xMhB7M3VZruhi1
	 XZD6goJblipDRH9RFxMAEfqTOZEaInZCxU3dvjPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/143] Revert "riscv: mm: support Svnapot in huge vmap"
Date: Mon,  4 Mar 2024 21:23:03 +0000
Message-ID: <20240304211551.946014375@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 16ab4646c9057e0528b985ad772e3cb88c613db2 ]

This reverts commit ce173474cf19fe7fbe8f0fc74e3c81ec9c3d9807.

We cannot correctly deal with NAPOT mappings in vmalloc/vmap because if
some part of a NAPOT mapping is unmapped, the remaining mapping is not
updated accordingly. For example:

ptr = vmalloc_huge(64 * 1024, GFP_KERNEL);
vunmap_range((unsigned long)(ptr + PAGE_SIZE),
	     (unsigned long)(ptr + 64 * 1024));

leads to the following kernel page table dump:

0xffff8f8000ef0000-0xffff8f8000ef1000    0x00000001033c0000         4K PTE N   ..     ..   D A G . . W R V

Meaning the first entry which was not unmapped still has the N bit set,
which, if accessed first and cached in the TLB, could allow access to the
unmapped range.

That's because the logic to break the NAPOT mapping does not exist and
likely won't. Indeed, to break a NAPOT mapping, we first have to clear
the whole mapping, flush the TLB and then set the new mapping ("break-
before-make" equivalent). That works fine in userspace since we can handle
any pagefault occurring on the remaining mapping but we can't handle a kernel
pagefault on such mapping.

So fix this by reverting the commit that introduced the vmap/vmalloc
support.

Fixes: ce173474cf19 ("riscv: mm: support Svnapot in huge vmap")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240227205016.121901-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vmalloc.h | 61 +-------------------------------
 1 file changed, 1 insertion(+), 60 deletions(-)

diff --git a/arch/riscv/include/asm/vmalloc.h b/arch/riscv/include/asm/vmalloc.h
index 924d01b56c9a1..51f6dfe19745a 100644
--- a/arch/riscv/include/asm/vmalloc.h
+++ b/arch/riscv/include/asm/vmalloc.h
@@ -19,65 +19,6 @@ static inline bool arch_vmap_pmd_supported(pgprot_t prot)
 	return true;
 }
 
-#ifdef CONFIG_RISCV_ISA_SVNAPOT
-#include <linux/pgtable.h>
+#endif
 
-#define arch_vmap_pte_range_map_size arch_vmap_pte_range_map_size
-static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr, unsigned long end,
-							 u64 pfn, unsigned int max_page_shift)
-{
-	unsigned long map_size = PAGE_SIZE;
-	unsigned long size, order;
-
-	if (!has_svnapot())
-		return map_size;
-
-	for_each_napot_order_rev(order) {
-		if (napot_cont_shift(order) > max_page_shift)
-			continue;
-
-		size = napot_cont_size(order);
-		if (end - addr < size)
-			continue;
-
-		if (!IS_ALIGNED(addr, size))
-			continue;
-
-		if (!IS_ALIGNED(PFN_PHYS(pfn), size))
-			continue;
-
-		map_size = size;
-		break;
-	}
-
-	return map_size;
-}
-
-#define arch_vmap_pte_supported_shift arch_vmap_pte_supported_shift
-static inline int arch_vmap_pte_supported_shift(unsigned long size)
-{
-	int shift = PAGE_SHIFT;
-	unsigned long order;
-
-	if (!has_svnapot())
-		return shift;
-
-	WARN_ON_ONCE(size >= PMD_SIZE);
-
-	for_each_napot_order_rev(order) {
-		if (napot_cont_size(order) > size)
-			continue;
-
-		if (!IS_ALIGNED(size, napot_cont_size(order)))
-			continue;
-
-		shift = napot_cont_shift(order);
-		break;
-	}
-
-	return shift;
-}
-
-#endif /* CONFIG_RISCV_ISA_SVNAPOT */
-#endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 #endif /* _ASM_RISCV_VMALLOC_H */
-- 
2.43.0



