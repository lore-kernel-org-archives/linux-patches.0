Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F88313298;
	Mon, 13 Apr 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099107; cv=none; b=kGGnfEXxhZSnZoPfoGxOWhypvJ3ztYREeHGTvZXXWloFJpKLs/9/0OSDP5i/fMMWut48qs7xujDBsUdtnqj3VbwdTuGvFfeZ6qIPw/KIgPykhWkRGOH8di2Ga8+YcSYs4hb0HDnqldp/MAmIlk/hV1BYEwfvEbvE8koTKGX/VJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099107; c=relaxed/simple;
	bh=Pm7oeMN5gvzW7GBIYtBZpq9f8oglcKzFbkRLSRZvB98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYMyIEDWpbFaRJ2xU1N0y7NdgkcwNaWm4KWLK1kkBxB5122dH/w3w3iia1/zheRYfHTGQoSaXPZq5k2CNHWsi39YuWIn2bRQTRJdj/qUzgLVJMByTUwLeWP5Y9RnkDR+IYYzHshk2fIgPFGHZydasRA2iI1/qfZuZSuXlRLuPrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DodV8oLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DodV8oLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A83C2BCAF;
	Mon, 13 Apr 2026 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099106;
	bh=Pm7oeMN5gvzW7GBIYtBZpq9f8oglcKzFbkRLSRZvB98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DodV8oLz2yhQh/48PXyjuYGg96d1JW7qWSV5lltUUIWkHZmjMfhiLC+alKBk71ife
	 PUJlzo2l/dotwQ6saxRfwiH1fRHikX5P8LYd/Hqw9K44ylD2U4eAnjDQkvvaGv4KoB
	 RBM4aC+uIAfMyiSHU1FrNU9jZdXWD5mY6Zx+hrkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Will Deacon <will@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/491] arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation
Date: Mon, 13 Apr 2026 17:57:06 +0200
Message-ID: <20260413155825.831809275@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit c25c4aa3f79a488cc270507935a29c07dc6bddfc ]

Commit 143937ca51cc ("arm64, mm: avoid always making PTE dirty in
pte_mkwrite()") changed pte_mkwrite_novma() to only clear PTE_RDONLY
when PTE_DIRTY is set. This was to allow writable-clean PTEs for swap
pages that haven't actually been written.

However, this broke kexec and hibernation for some platforms. Both go
through trans_pgd_create_copy() -> _copy_pte(), which calls
pte_mkwrite_novma() to make the temporary linear-map copy fully
writable. With the updated pte_mkwrite_novma(), read-only kernel pages
(without PTE_DIRTY) remain read-only in the temporary mapping.
While such behaviour is fine for user pages where hardware DBM or
trapping will make them writeable, subsequent in-kernel writes by the
kexec relocation code will fault.

Add PTE_DIRTY back to all _PAGE_KERNEL* protection definitions. This was
the case prior to 5.4, commit aa57157be69f ("arm64: Ensure
VM_WRITE|VM_SHARED ptes are clean by default"). With the kernel
linear-map PTEs always having PTE_DIRTY set, pte_mkwrite_novma()
correctly clears PTE_RDONLY.

Fixes: 143937ca51cc ("arm64, mm: avoid always making PTE dirty in pte_mkwrite()")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: stable@vger.kernel.org
Reported-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Link: https://lore.kernel.org/r/20251204062722.3367201-1-jianpeng.chang.cn@windriver.com
Cc: Will Deacon <will@kernel.org>
Cc: Huang, Ying <ying.huang@linux.alibaba.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ added PTE_DIRTY to PAGE_KERNEL* macros directly instead of _PAGE_KERNEL*  ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-prot.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -65,11 +65,11 @@ extern bool arm64_use_ng_mappings;
 
 #define _PAGE_DEFAULT		(_PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
 
-#define PAGE_KERNEL		__pgprot(PROT_NORMAL)
-#define PAGE_KERNEL_RO		__pgprot((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY)
-#define PAGE_KERNEL_ROX		__pgprot((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY)
-#define PAGE_KERNEL_EXEC	__pgprot(PROT_NORMAL & ~PTE_PXN)
-#define PAGE_KERNEL_EXEC_CONT	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
+#define PAGE_KERNEL		__pgprot(PROT_NORMAL | PTE_DIRTY)
+#define PAGE_KERNEL_RO		__pgprot((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY | PTE_DIRTY)
+#define PAGE_KERNEL_ROX		__pgprot((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY | PTE_DIRTY)
+#define PAGE_KERNEL_EXEC	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_DIRTY)
+#define PAGE_KERNEL_EXEC_CONT	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_CONT | PTE_DIRTY)
 
 #define PAGE_S2_MEMATTR(attr)						\
 	({								\


