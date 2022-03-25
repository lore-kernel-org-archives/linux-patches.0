Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70C01FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AF3C340F1;
	Fri, 25 Mar 2022 01:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170677;
	bh=m3w3r1c8QaoAa/4E7jG5lgT4qMcnOu+M1qbKI3e9peY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=rUnjZDt1oaiWD8Cg4oy7ytkk+NLwwVGSgisCBr3cYojPGezrNnTyij2iq0WcAkI2y
	 bTP4PSEhbnqpmSuhO5HgVI8upPJkNopr+u2H9aZt2vrc7+003+X8PKE0JvKJwPrcAh
	 zNirnb54d7O2skAzzO5vVFi+qC8ZjhMOqTkpwVgY=
Date: Thu, 24 Mar 2022 18:11:16 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 054/114] kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged
Message-Id: <20220325011117.93AF3C340F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged

HW_TAGS KASAN relies on ARM Memory Tagging Extension (MTE).  With MTE, a
memory region must be mapped as MT_NORMAL_TAGGED to allow setting memory
tags via MTE-specific instructions.

Add proper protection bits to vmalloc() allocations.  These allocations
are always backed by page_alloc pages, so the tags will actually be
getting set on the corresponding physical memory.

Link: https://lkml.kernel.org/r/983fc33542db2f6b1e77b34ca23448d4640bbb9e.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Co-developed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmalloc.h |    6 ++++++
 include/linux/vmalloc.h          |    7 +++++++
 mm/vmalloc.c                     |    9 +++++++++
 3 files changed, 22 insertions(+)

--- a/arch/arm64/include/asm/vmalloc.h~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -25,4 +25,10 @@ static inline bool arch_vmap_pmd_support
 
 #endif
 
+#define arch_vmap_pgprot_tagged arch_vmap_pgprot_tagged
+static inline pgprot_t arch_vmap_pgprot_tagged(pgprot_t prot)
+{
+	return pgprot_tagged(prot);
+}
+
 #endif /* _ASM_ARM64_VMALLOC_H */
--- a/include/linux/vmalloc.h~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/include/linux/vmalloc.h
@@ -115,6 +115,13 @@ static inline int arch_vmap_pte_supporte
 }
 #endif
 
+#ifndef arch_vmap_pgprot_tagged
+static inline pgprot_t arch_vmap_pgprot_tagged(pgprot_t prot)
+{
+	return prot;
+}
+#endif
+
 /*
  *	Highlevel APIs for driver use
  */
--- a/mm/vmalloc.c~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/mm/vmalloc.c
@@ -3128,6 +3128,15 @@ again:
 		goto fail;
 	}
 
+	/*
+	 * Modify protection bits to allow tagging.
+	 * This must be done before mapping by __vmalloc_area_node().
+	 */
+	if (kasan_hw_tags_enabled() &&
+	    pgprot_val(prot) == pgprot_val(PAGE_KERNEL))
+		prot = arch_vmap_pgprot_tagged(prot);
+
+	/* Allocate physical pages and map them into vmalloc space. */
 	addr = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
 	if (!addr)
 		goto fail;
_
