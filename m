Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477E472091;
	Sat, 12 Sep 2026 13:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219021; cv=none; b=DN5sB0z/d+fagQZPEbormxz50wQYFCGPYerzMyQrxj213byFyOxmVK81b/YkTIzd2DhIWigykEpKxEKnLwkf1MecbUB/o5IhZ/+aNxRcpqteoolQOPcdeXKwdMvbkpa3wd9kkO1dW8i5j5e3CKc6JeKIuvKUMzcrHG1gJXuozfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219021; c=relaxed/simple;
	bh=dokjrGSWWe3nALG5+Yof+BMQrOWrNKnGLempW4XhJf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdOyUf1sAjxcQRr85bmPo3/kW6Jwz3pXouipGWenoZ3Ww51yzEKPoZlw5Vysx+oC3720Ny8TdkQsdheRMwcdwmtX+Y+nqwRclUywyJQB/g/6Qspw/5GXR9d52bG5uQQi4h+zq5KPiK6tWED36r0G0j6JWkZCQYdVWjZPdWPRum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ijcs88Ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ijcs88Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273441F000FF;
	Sat, 12 Sep 2026 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219020;
	bh=53ZZjUGysdxRFyDodiFAt6Twn8/n73O01CiOXBfosZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ijcs88Ron85b0ODJ3rxpoUDzh6QeIsM19vHA5+pDmBRfpNZyuQXviENMgiMj20vWy
	 Nl/0MZVaZy8YiRNw0ZTHcqK5PO1SwMUneCbwmlgkJH2nfnMjzKhVBZY44ZXnXjJ63W
	 eTglaBXpM/bwUH3WPnsdypjaJ3LtWqSWbN7Ch9m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1266/1376] arm64: Enable ARCH_HAS_NONLEAF_PMD_YOUNG
Date: Sat, 12 Sep 2026 09:01:32 +0200
Message-ID: <20260912065635.757933915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 62df5870ebf7cec96a51c9b9008daf167e22db14 ]

With the support of FEAT_HAFT, the NONLEAF_PMD_YOUNG can be enabled
on arm64 since the hardware is capable of updating the AF flag for
PMD table descriptor. Since the AF bit of the table descriptor
shares the same bit position in block descriptors, we only need
to implement arch_has_hw_nonleaf_pmd_young() and select related
configs. The related pmd_young test/update operations keeps the
same with and already implemented for transparent page support.

Currently ARCH_HAS_NONLEAF_PMD_YOUNG is used to improve the
efficiency of lru-gen aging.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20241102104235.62560-5-yangyicong@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig               | 1 +
 arch/arm64/include/asm/pgtable.h | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index dd98fa97aad00..10aa534852fb9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -38,6 +38,7 @@ config ARM64
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 2de5a70a47ce3..a66a474949c86 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1266,7 +1266,7 @@ static inline int __ptep_clear_flush_young(struct vm_area_struct *vma,
 	return young;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
@@ -1274,7 +1274,7 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 {
 	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
@@ -1509,6 +1509,10 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
  */
 #define arch_has_hw_pte_young		cpu_has_hw_af
 
+#ifdef CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
+#define arch_has_hw_nonleaf_pmd_young	system_supports_haft
+#endif
+
 /*
  * Experimentally, it's cheap to set the access flag in hardware and we
  * benefit from prefaulting mappings as 'old' to start with.
-- 
2.53.0



