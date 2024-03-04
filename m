Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AC68F58;
	Mon,  4 Mar 2024 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588350; cv=none; b=m+KX6ReepRNJZJV2rWQ1Laa9Jap5ZYxvJFH7Hj+pP2W9mPLqXqJf9xfMncMFQBKVRHp5RubPWuXzCACh9xn1GgC0VrqFwNrlMLeRQmeb7DxgPXKSDQNH2y8Qla7ezrNvwuRAxTrtXly9S8D5SvV0fTUlk2z83XlP7Rum0aTmmIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588350; c=relaxed/simple;
	bh=DbwPAvBXqGCtNHcdP7WfSnRAsbynOSQ9VmkHtuvkcQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8rR+iW6bxNggFL+CCjFUUQPIya8KZRtJjJObtjFdCH5XG7qaj94QkFi+ABByLFH0lc1dnqH3UBg6fdDAX5Efys/krl5Ag+L8HmNLrxOqskXs8mQQou3Y4rJqoed+UP9gV2hVyYJgRNl1LjZ1EPxfSAUGd9ZdgjCVkN7s8xRtLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNlvyZ0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNlvyZ0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D42C433F1;
	Mon,  4 Mar 2024 21:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588350;
	bh=DbwPAvBXqGCtNHcdP7WfSnRAsbynOSQ9VmkHtuvkcQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNlvyZ0IgvLtrvm6A7Opfn2hKaQeW1XFlBHLz+OXOtAIkhqNyd/9/ttDxSfjFa9L9
	 J+vZwghMowdqXKg3c9DiD/+G+3seIIntbeZc0YIzddsICeDEYHXxYBFcwFn2lZYxuv
	 Vj7Ykb+efJvjsj6yMhzJ7YjTL9cfDUl1xREilUq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/143] riscv: Fix build error if !CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
Date: Mon,  4 Mar 2024 21:22:49 +0000
Message-ID: <20240304211551.495243218@linuxfoundation.org>
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



