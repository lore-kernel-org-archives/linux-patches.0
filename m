Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D731EB22;
	Tue, 13 Feb 2024 17:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845878; cv=none; b=Acx+U9ALJUlAgZrcvRUq8Q0WvQM/V0kgk4ukNGcvlSJi70y+zhI884VW3t5GPhCyE7aL91u5two+lhsFcKXny84O6EMMXhDEH/mqYpLyuiHBE89ctqbZi+cgmJb2qcbh0WDwhBIlnhvHYQyY1dU0K6R1J7tD+3ZViB1rqLBJkf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845878; c=relaxed/simple;
	bh=o1Yalo5tkqf20UxD+WRX+7KNPX48M8qtaBo0qEUnmgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMLsXDHcyOAkld90rogpbUNL2zDdeE8mOMsBl8U1wk+Syf40OGTtAW9JQmrmMVf1nCVuQG9QwHxI++UpziLh4RwSHYgdFF8qn9arU8OYSeqvnj8jflBcI20TT1lsAVV9S4LAkWovqK8b+Q3cl2dgvqGehOkEMLVzL0BKzp0BiCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy6WSUW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy6WSUW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B54C43330;
	Tue, 13 Feb 2024 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845878;
	bh=o1Yalo5tkqf20UxD+WRX+7KNPX48M8qtaBo0qEUnmgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fy6WSUW/KuwWKJXlaYt3kmBQYzBItEiSn84AU5AjNiXCRARnA+aFXFrs1BMAaizbt
	 DEODDMNGM5FB4jVbQlH3xuU8IdlT9VgxVdb99XRgE8Vzzbu0NZlEQxzcyAopvB+B67
	 g7p1Y1fV8wuvE3hhovHPM2QeOe52ZLUt0/2ID1uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 082/124] riscv: Fix arch_hugetlb_migration_supported() for NAPOT
Date: Tue, 13 Feb 2024 18:21:44 +0100
Message-ID: <20240213171856.130172015@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

[ Upstream commit ce68c035457bdd025a9961e0ba2157323090c581 ]

arch_hugetlb_migration_supported() must be reimplemented to add support
for NAPOT hugepages, which is done here.

Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240130120114.106003-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/hugetlb.h |  3 +++
 arch/riscv/mm/hugetlbpage.c      | 16 +++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/hugetlb.h b/arch/riscv/include/asm/hugetlb.h
index 4c5b0e929890..20f9c3ba2341 100644
--- a/arch/riscv/include/asm/hugetlb.h
+++ b/arch/riscv/include/asm/hugetlb.h
@@ -11,6 +11,9 @@ static inline void arch_clear_hugepage_flags(struct page *page)
 }
 #define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
+bool arch_hugetlb_migration_supported(struct hstate *h);
+#define arch_hugetlb_migration_supported arch_hugetlb_migration_supported
+
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
 #define __HAVE_ARCH_HUGE_PTE_CLEAR
 void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index 87af75ee7186..e7b69281875b 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -364,7 +364,7 @@ void huge_pte_clear(struct mm_struct *mm,
 		pte_clear(mm, addr, ptep);
 }
 
-static __init bool is_napot_size(unsigned long size)
+static bool is_napot_size(unsigned long size)
 {
 	unsigned long order;
 
@@ -392,7 +392,7 @@ arch_initcall(napot_hugetlbpages_init);
 
 #else
 
-static __init bool is_napot_size(unsigned long size)
+static bool is_napot_size(unsigned long size)
 {
 	return false;
 }
@@ -409,7 +409,7 @@ int pmd_huge(pmd_t pmd)
 	return pmd_leaf(pmd);
 }
 
-bool __init arch_hugetlb_valid_size(unsigned long size)
+static bool __hugetlb_valid_size(unsigned long size)
 {
 	if (size == HPAGE_SIZE)
 		return true;
@@ -421,6 +421,16 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
 		return false;
 }
 
+bool __init arch_hugetlb_valid_size(unsigned long size)
+{
+	return __hugetlb_valid_size(size);
+}
+
+bool arch_hugetlb_migration_supported(struct hstate *h)
+{
+	return __hugetlb_valid_size(huge_page_size(h));
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 static __init int gigantic_pages_init(void)
 {
-- 
2.43.0



