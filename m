Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428AE29ACC5;
	Mon, 23 Mar 2026 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282929; cv=none; b=pUZZWOGJhTeQPiSiWLJO9hEDekqJQA6+1/ZYF3NQ4ds2mwFPdZnfYn7mHN9UiUci7x1bx0RbvywEhjEl9z93xCnVv523i+DFO5xjMH211ecl6J/tD2rhdkJIXo/NcU5v3ajWfITbaKABU1iqCcBD7ri2HVRDl1YjH+xQ0U+8JSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282929; c=relaxed/simple;
	bh=ltj9VdynTqoU1HMk7FpojDJov98Syt7omUxwqvf/90k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVbl+dz+FE6iMDv3KUzrvFgyiOHIuvo0h4jink8KFamPZPc6We358L5PLRdsBlwjixqrKfZizxJcdF5g/FN/UN+0RImuDl2v8qQ/m0iyxBaYiREjPyHom/PSJQ92+cwntbRKMLlugXngypnArjjGEmXJxPxWFJZxmK/cI7lY4SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/D4shIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/D4shIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D435C4CEF7;
	Mon, 23 Mar 2026 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282928;
	bh=ltj9VdynTqoU1HMk7FpojDJov98Syt7omUxwqvf/90k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/D4shImxGuKKxsdRoR3LWBjZTruB7Y5ZLi01/RDUD4U/ruucxtbU7fAbdEC/ksF/
	 hAdj9vsL8mEap3AfDT9RjFbESl64ygEqqWhfBl/GRjCmpyEyz5LGx9t/4XvWKq7dT6
	 O2kpcdarm126FhPLAb/hq7EtapU9Wm6YOixIqXz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 339/481] arm64: reorganise PAGE_/PROT_ macros
Date: Mon, 23 Mar 2026 14:45:21 +0100
Message-ID: <20260323134533.359462171@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joey Gouly <joey.gouly@arm.com>

[ Upstream commit fa4cdccaa58224a12591f2c045c24abc5251bb9d ]

Make these macros available to assembly code, so they can be re-used by the
PIE initialisation code.

This involves adding some extra macros, prepended with _ that are the raw
values not `pgprot` values.

A dummy value for PTE_MAYBE_NG is also provided, for use in assembly.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20230606145859.697944-14-joey.gouly@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: c25c4aa3f79a ("arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-prot.h |   72 ++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 28 deletions(-)

--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -27,6 +27,40 @@
  */
 #define PMD_PRESENT_INVALID	(_AT(pteval_t, 1) << 59) /* only when !PMD_SECT_VALID */
 
+#define _PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
+#define _PROT_SECT_DEFAULT	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
+
+#define PROT_DEFAULT		(_PROT_DEFAULT | PTE_MAYBE_NG)
+#define PROT_SECT_DEFAULT	(_PROT_SECT_DEFAULT | PMD_MAYBE_NG)
+
+#define PROT_DEVICE_nGnRnE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRnE))
+#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRE))
+#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_NC))
+#define PROT_NORMAL		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL))
+#define PROT_NORMAL_TAGGED	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_TAGGED))
+
+#define PROT_SECT_DEVICE_nGnRE	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_DEVICE_nGnRE))
+#define PROT_SECT_NORMAL	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
+#define PROT_SECT_NORMAL_EXEC	(PROT_SECT_DEFAULT | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
+
+#define _PAGE_DEFAULT		(_PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
+
+#define _PAGE_KERNEL		(PROT_NORMAL)
+#define _PAGE_KERNEL_RO		((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY)
+#define _PAGE_KERNEL_ROX	((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY)
+#define _PAGE_KERNEL_EXEC	(PROT_NORMAL & ~PTE_PXN)
+#define _PAGE_KERNEL_EXEC_CONT	((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
+
+#define _PAGE_SHARED		(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
+#define _PAGE_SHARED_EXEC	(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_WRITE)
+#define _PAGE_READONLY		(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
+#define _PAGE_READONLY_EXEC	(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN)
+#define _PAGE_EXECONLY		(_PAGE_DEFAULT | PTE_RDONLY | PTE_NG | PTE_PXN)
+
+#ifdef __ASSEMBLY__
+#define PTE_MAYBE_NG	0
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <asm/cpufeature.h>
@@ -34,9 +68,6 @@
 
 extern bool arm64_use_ng_mappings;
 
-#define _PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
-#define _PROT_SECT_DEFAULT	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
-
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
 
@@ -50,26 +81,11 @@ extern bool arm64_use_ng_mappings;
 #define PTE_MAYBE_GP		0
 #endif
 
-#define PROT_DEFAULT		(_PROT_DEFAULT | PTE_MAYBE_NG)
-#define PROT_SECT_DEFAULT	(_PROT_SECT_DEFAULT | PMD_MAYBE_NG)
-
-#define PROT_DEVICE_nGnRnE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRnE))
-#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRE))
-#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_NC))
-#define PROT_NORMAL		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL))
-#define PROT_NORMAL_TAGGED	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_TAGGED))
-
-#define PROT_SECT_DEVICE_nGnRE	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_DEVICE_nGnRE))
-#define PROT_SECT_NORMAL	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
-#define PROT_SECT_NORMAL_EXEC	(PROT_SECT_DEFAULT | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
-
-#define _PAGE_DEFAULT		(_PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
-
-#define PAGE_KERNEL		__pgprot(PROT_NORMAL)
-#define PAGE_KERNEL_RO		__pgprot((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY)
-#define PAGE_KERNEL_ROX		__pgprot((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY)
-#define PAGE_KERNEL_EXEC	__pgprot(PROT_NORMAL & ~PTE_PXN)
-#define PAGE_KERNEL_EXEC_CONT	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
+#define PAGE_KERNEL		__pgprot(_PAGE_KERNEL)
+#define PAGE_KERNEL_RO		__pgprot(_PAGE_KERNEL_RO)
+#define PAGE_KERNEL_ROX		__pgprot(_PAGE_KERNEL_ROX)
+#define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_EXEC_CONT	__pgprot(_PAGE_KERNEL_EXEC_CONT)
 
 #define PAGE_S2_MEMATTR(attr, has_fwb)					\
 	({								\
@@ -83,11 +99,11 @@ extern bool arm64_use_ng_mappings;
 
 #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
 /* shared+writable pages are clean by default, hence PTE_RDONLY|PTE_WRITE */
-#define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
-#define PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_WRITE)
-#define PAGE_READONLY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
-#define PAGE_READONLY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN)
-#define PAGE_EXECONLY		__pgprot(_PAGE_DEFAULT | PTE_RDONLY | PTE_NG | PTE_PXN)
+#define PAGE_SHARED		__pgprot(_PAGE_SHARED)
+#define PAGE_SHARED_EXEC	__pgprot(_PAGE_SHARED_EXEC)
+#define PAGE_READONLY		__pgprot(_PAGE_READONLY)
+#define PAGE_READONLY_EXEC	__pgprot(_PAGE_READONLY_EXEC)
+#define PAGE_EXECONLY		__pgprot(_PAGE_EXECONLY)
 
 #endif /* __ASSEMBLY__ */
 


