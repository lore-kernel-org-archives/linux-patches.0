Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2A11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DCC433C8;
	Mon, 28 Aug 2023 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218346;
	bh=xO4M9RAJBEYhgjbhYDX/Y54LSY+9WLsRxuKLnj+Vwc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJk5u5VANW52TRMAfz+G6jVBQYU/o1W9YcuWHuLYdsxqLsB84MC3amTt92rYwm/lZ
	 1wrsYof60f8CXxFvvI6Af48pD4ebWq34akM5LzSg6k8IAIDgqfu9NzjJC5iC3Pl/w5
	 6Gq6QkHHKQwme6qFDcjDeLsCXVFcWMhDHtMNSLLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/129] powerpc/mm: Move pgtable_t into platform headers
Date: Mon, 28 Aug 2023 12:12:00 +0200
Message-ID: <20230828101154.024643278@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit d09780f3a8d48fd49136d7bae8f0ae30de7f261a ]

This patch move pgtable_t into platform headers.

It gets rid of the CONFIG_PPC_64K_PAGES case for PPC64
as nohash/64 doesn't support CONFIG_PPC_64K_PAGES.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Stable-dep-of: 66b2ca086210 ("powerpc/64s/radix: Fix soft dirty tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |  2 ++
 arch/powerpc/include/asm/book3s/64/mmu.h      |  9 +++++++++
 arch/powerpc/include/asm/nohash/32/mmu.h      |  4 ++++
 arch/powerpc/include/asm/nohash/64/mmu.h      |  4 ++++
 arch/powerpc/include/asm/page.h               | 14 --------------
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index e38c91388c40f..5bd26c218b94f 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -42,6 +42,8 @@ struct ppc_bat {
 	u32 batu;
 	u32 batl;
 };
+
+typedef struct page *pgtable_t;
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/include/asm/book3s/64/mmu.h
index 9c8c669a6b6a3..488e7ed07e967 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_POWERPC_BOOK3S_64_MMU_H_
 #define _ASM_POWERPC_BOOK3S_64_MMU_H_
 
+#include <asm/page.h>
+
 #ifndef __ASSEMBLY__
 /*
  * Page size definition
@@ -24,6 +26,13 @@ struct mmu_psize_def {
 };
 extern struct mmu_psize_def mmu_psize_defs[MMU_PAGE_COUNT];
 
+/*
+ * For BOOK3s 64 with 4k and 64K linux page size
+ * we want to use pointers, because the page table
+ * actually store pfn
+ */
+typedef pte_t *pgtable_t;
+
 #endif /* __ASSEMBLY__ */
 
 /* 64-bit classic hash table MMU */
diff --git a/arch/powerpc/include/asm/nohash/32/mmu.h b/arch/powerpc/include/asm/nohash/32/mmu.h
index af0e8b54876ab..f61f933a4cd8c 100644
--- a/arch/powerpc/include/asm/nohash/32/mmu.h
+++ b/arch/powerpc/include/asm/nohash/32/mmu.h
@@ -16,4 +16,8 @@
 #include <asm/nohash/32/mmu-8xx.h>
 #endif
 
+#ifndef __ASSEMBLY__
+typedef struct page *pgtable_t;
+#endif
+
 #endif /* _ASM_POWERPC_NOHASH_32_MMU_H_ */
diff --git a/arch/powerpc/include/asm/nohash/64/mmu.h b/arch/powerpc/include/asm/nohash/64/mmu.h
index 87871d027b75e..e6585480dfc40 100644
--- a/arch/powerpc/include/asm/nohash/64/mmu.h
+++ b/arch/powerpc/include/asm/nohash/64/mmu.h
@@ -5,4 +5,8 @@
 /* Freescale Book-E software loaded TLB or Book-3e (ISA 2.06+) MMU */
 #include <asm/nohash/mmu-book3e.h>
 
+#ifndef __ASSEMBLY__
+typedef struct page *pgtable_t;
+#endif
+
 #endif /* _ASM_POWERPC_NOHASH_64_MMU_H_ */
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index f6a1265face29..ddfb4b965e5bd 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -335,20 +335,6 @@ void arch_free_page(struct page *page, int order);
 #endif
 
 struct vm_area_struct;
-#ifdef CONFIG_PPC_BOOK3S_64
-/*
- * For BOOK3s 64 with 4k and 64K linux page size
- * we want to use pointers, because the page table
- * actually store pfn
- */
-typedef pte_t *pgtable_t;
-#else
-#if defined(CONFIG_PPC_64K_PAGES) && defined(CONFIG_PPC64)
-typedef pte_t *pgtable_t;
-#else
-typedef struct page *pgtable_t;
-#endif
-#endif
 
 #include <asm-generic/memory_model.h>
 #endif /* __ASSEMBLY__ */
-- 
2.40.1



