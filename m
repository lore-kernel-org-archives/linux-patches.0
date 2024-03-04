Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF310A35;
	Mon,  4 Mar 2024 21:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587688; cv=none; b=OU49KyiDxGEpywDtRXNT11hx7p6kb1GqvekwXmF5+6Wiy2d/jNv1wQ0cFYg/XkhhqFyLdFZilNqlq5iKta/LrnPBZj3bamdKqUHCzIlqKFF+s1w9XKpDo9n//Xva+R8l4SZIctN++DlhBVl+kcR1PS12UOIgWQ4r3A5WPI+kFa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587688; c=relaxed/simple;
	bh=30kZtix8Hk4hQ4XZlKPNOu9JdsjMu85d5TJ6GVRJS7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STQ5Y+RyEJK6Ato0cAHooi8PKIYE486yrKpjWivo/CHG47nAkEJMN/xvMoYbvTKJCOuw67lq0/KHAo00kyL+WVYpuAym4xtFRxUuOOVBcaOzXGPdzoxqYYCb3ITxnXSpLu7r6kHw2AQCLnDPs6MyPDiL0W1//kUAC58EsrB+bUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmkLEDHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmkLEDHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936B6C433F1;
	Mon,  4 Mar 2024 21:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587687;
	bh=30kZtix8Hk4hQ4XZlKPNOu9JdsjMu85d5TJ6GVRJS7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmkLEDHVqCn+jGWXcKpawWPW6imJHxhhZRXKga5+xdFytC2gKtJeet2kyjmTYt3+T
	 mHf1anoZl/gbYeR3DVXcBA/9cPSzUZB5SBFPeCEfjqw9mLoLCkcAZE0tqLVzK9c1PY
	 WU1Fbur5uZcjvHerf9OrxCo7niWTxACHAVkpEBFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 052/162] riscv: Fix build error if !CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
Date: Mon,  4 Mar 2024 21:21:57 +0000
Message-ID: <20240304211553.524231649@linuxfoundation.org>
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

[ Upstream commit fc325b1a915f6d0c821bfcea21fb3f1354c4323b ]

The new riscv specific arch_hugetlb_migration_supported() must be
guarded with a #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION to avoid
the following build error:

In file included from include/linux/hugetlb.h:851,
                    from kernel/fork.c:52:
>> arch/riscv/include/asm/hugetlb.h:15:42: error: static declaration of 'arch_hugetlb_migration_supported' follows non-static declaration
      15 | #define arch_hugetlb_migration_supported arch_hugetlb_migration_supported
         |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/hugetlb.h:916:20: note: in expansion of macro 'arch_hugetlb_migration_supported'
     916 | static inline bool arch_hugetlb_migration_supported(struct hstate *h)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/hugetlb.h:14:6: note: previous declaration of 'arch_hugetlb_migration_supported' with type 'bool(struct hstate *)' {aka '_Bool(struct hstate *)'}
      14 | bool arch_hugetlb_migration_supported(struct hstate *h);
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402110258.CV51JlEI-lkp@intel.com/
Fixes: ce68c035457b ("riscv: Fix arch_hugetlb_migration_supported() for NAPOT")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240211083640.756583-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/hugetlb.h | 2 ++
 arch/riscv/mm/hugetlbpage.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/hugetlb.h b/arch/riscv/include/asm/hugetlb.h
index 20f9c3ba23414..22deb7a2a6ec4 100644
--- a/arch/riscv/include/asm/hugetlb.h
+++ b/arch/riscv/include/asm/hugetlb.h
@@ -11,8 +11,10 @@ static inline void arch_clear_hugepage_flags(struct page *page)
 }
 #define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 bool arch_hugetlb_migration_supported(struct hstate *h);
 #define arch_hugetlb_migration_supported arch_hugetlb_migration_supported
+#endif
 
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
 #define __HAVE_ARCH_HUGE_PTE_CLEAR
diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index e7b69281875b2..fbe918801667d 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -426,10 +426,12 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
 	return __hugetlb_valid_size(size);
 }
 
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 bool arch_hugetlb_migration_supported(struct hstate *h)
 {
 	return __hugetlb_valid_size(huge_page_size(h));
 }
+#endif
 
 #ifdef CONFIG_CONTIG_ALLOC
 static __init int gigantic_pages_init(void)
-- 
2.43.0



