Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0053321D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301214; cv=none; b=MuTQO6h5xd8ttBW4kJ++akUdtWmY9f4ZyAkAUusEHfn1g2Dz/85do9A9Q5oM823u8y0n/YEr7LJATkobgzvtpheOJaoiJxM8fnkaNWRXi4smVwYYBhebfbGwQO0kFcCdA+Ug5+xbsESa/9Q8Cl8IIgniLNH86s+110cEjQ+g8sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301214; c=relaxed/simple;
	bh=Frj5Wg4cQizQehTYpq5U9RIBzwG5HQCPs29sGuuHwjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6AeKdBuSYuBw8GUGzVObC1o/TQtlxdmh306ARA8MxouP49HOP/Y6Y70zCEkm6vdheuWPAiB3FPvv1dA++zZpZ/RkEYdkIrcHZKh95qw+HqTtKSBKBlO2IspizIrYWa1bOGnoxT8JQp77g/kYpCty5S3sp1oo22wx1iAf8RjBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=faCMALqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="faCMALqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D698DC19423;
	Sat, 28 Feb 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301214;
	bh=Frj5Wg4cQizQehTYpq5U9RIBzwG5HQCPs29sGuuHwjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faCMALqvoz+s2RD4kEDHPn251MoOmXum6dCDqSgPdYBxNoRPB2ZV9uvsKPrglSbgT
	 Ssx+41C4nr/k55OJdiQfWOoycoV4vCmEdbpRiHHD30qvlAX0mGTTcsqr/oSH5o6P+r
	 ocC/3XIsGwFReNqdTeHAHGOEOrGfsIs5O2hVZCjCw1Lv0edmVaQaeuimEHqNPU6tea
	 OXUFER68OZ8RKoQCEY0ALsbYCZbFKorYWk7TVjIsXmkZ8T59h9we1YggwPJmUbDUHu
	 GQzU3A7o7nNj3wqkfc1KFe7+8ftZDjPrf6npRPOjCO+77YXB70ICyppKf0jI74rVDH
	 bFsuQtZtoME8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/752] arm64: hugetlbpage: avoid unused-but-set-parameter warning (gcc-16)
Date: Sat, 28 Feb 2026 12:41:41 -0500
Message-ID: <20260228174750.1542406-390-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 729a2e8e9ac47099a967567389cc9d73ef4194ca ]

gcc-16 warns about an instance that older compilers did not:

arch/arm64/mm/hugetlbpage.c: In function 'huge_pte_clear':
arch/arm64/mm/hugetlbpage.c:369:57: error: parameter 'addr' set but not used [-Werror=unused-but-set-parameter=]

The issue here is that __pte_clear() does not actually use its second
argument, but when CONFIG_ARM64_CONTPTE is enabled it still gets
updated.

Replace the macro with an inline function to let the compiler see
the argument getting passed down.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0944e296dd4a4..9016ae8de5c9e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -175,8 +175,6 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define pte_none(pte)		(!pte_val(pte))
-#define __pte_clear(mm, addr, ptep) \
-				__set_pte(ptep, __pte(0))
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
 /*
@@ -1316,6 +1314,13 @@ static inline bool pud_user_accessible_page(pud_t pud)
 /*
  * Atomic pte/pmd modifications.
  */
+
+static inline void __pte_clear(struct mm_struct *mm,
+			       unsigned long addr, pte_t *ptep)
+{
+	__set_pte(ptep, __pte(0));
+}
+
 static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
 					      unsigned long address,
 					      pte_t *ptep)
-- 
2.51.0

