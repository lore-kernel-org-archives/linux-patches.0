Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7679C1EB5A;
	Mon,  4 Mar 2024 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587790; cv=none; b=fY6CCQz6Bo4wcQoYRWQdbyjdB49ndEGP3doL3Jnid6eA6aCl5Nc3d7qppdnbO6GFFnG4J3cDg0YBtzU7o1I6e/BQBTpfuCbXXnXDgwUvD4008+qNafUhnRUbVCMVX4q0ObxnfwdCO/p9naIVbpqo4n2CVAa7oaX8yWDZgxmW9Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587790; c=relaxed/simple;
	bh=pwSELbZ+07C0jxpCbM9G5YyEJZRs4CKQPnH29bMeYR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbnh5fn37N/6SDdfHeYb5jRvdk8vqO8h4dYGSGz3l3VWayvnnvOLVYcSg3S6cwiwRLj3HlZ61hp5qzPKiwy4TqP1Ry4A42ZJiAAZJ6cgMj4XWKEssdRo1OlhKsSWMcrUFO2TPAVL6RhgH+Ohpmf/PjesqEipS9XHC4aZ8UT9E3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZyL8eSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZyL8eSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77D2C433F1;
	Mon,  4 Mar 2024 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587790;
	bh=pwSELbZ+07C0jxpCbM9G5YyEJZRs4CKQPnH29bMeYR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZyL8eSxT9n+WAetUYwEV95wYciCY9LW1eIaXS5HnmV+1k1A0LR/56ezI+X6yFWuI
	 jt9ASi63EwL78MWjNPsjciny2ib1tfqAFjRb7Krvdh91gD63RYEZ9ySXTThK28LDOa
	 ng3xkwN4xHiWdB/HVYVQWP8Ax68Iud2R4qP0S+Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 067/162] Revert "riscv: mm: support Svnapot in huge vmap"
Date: Mon,  4 Mar 2024 21:22:12 +0000
Message-ID: <20240304211553.992766847@linuxfoundation.org>
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



