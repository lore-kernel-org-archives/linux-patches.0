Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8511EB5A;
	Mon,  4 Mar 2024 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587733; cv=none; b=nEXOrNk26E7QtMnXbf8Z8nrLMj3jyokS6+9t+LRHBZ2tOZALEi6Yr8w8iCxSwT3XqI8aUXqQjxH84uYHJT9iNSBVIfF5mRHe0HKZOeM0yoG8YJMRQfcLt0ZRkuEzmCGSa8UMY+2gMaxBMgukneAlKmki43ntph8MdnoTS4gNcO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587733; c=relaxed/simple;
	bh=m2vgb9fgz0nic+IWMy5ttjj+N51fVnvDJ3RFhEDCEoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQYz2TRrXzrlQfQ461SX+cCLeU8PBkD+SmOU0G9dXH9SWpQRG5i3CieTeucvK0wUdFKXgKOSkbL7t8YG8MatsXzSOlMOKx3xZD13yo+aTKuHCyf4m5SzPBoZa+9MSZRmIYagKsuGu4VIRUeR227RWdQr8wsg2Y5LixCZ26ZtgIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sjjLgBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sjjLgBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720AAC433C7;
	Mon,  4 Mar 2024 21:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587732;
	bh=m2vgb9fgz0nic+IWMy5ttjj+N51fVnvDJ3RFhEDCEoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sjjLgBy8uesf5l6YEdbHlxLRY799s+VDDsdesx+qo5GEdxj5Zp06pGQtcDWQaf6M
	 QJWBt8WktEdzrjK17MkJZsM7T/nfkNprn5sDqXkMjEmWJYVnPMpF4Vy5KwzeiK1umv
	 Se2r3b455em1KmiWKFxPh2j7uWYUgwv3H8m2j9Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 044/162] riscv: tlb: fix __p*d_free_tlb()
Date: Mon,  4 Mar 2024 21:21:49 +0000
Message-ID: <20240304211553.263786488@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 8246601a7d391ce8207408149d65732f28af81a1 ]

If non-leaf PTEs I.E pmd, pud or p4d is modified, a sfence.vma is
a must for safe, imagine if an implementation caches the non-leaf
translation in TLB, although I didn't meet this HW so far, but it's
possible in theory.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: c5e9b2c2ae82 ("riscv: Improve tlb_flush()")
Link: https://lore.kernel.org/r/20231219175046.2496-2-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgalloc.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index d169a4f41a2e7..c80bb9990d32e 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -95,7 +95,13 @@ static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 		__pud_free(mm, pud);
 }
 
-#define __pud_free_tlb(tlb, pud, addr)  pud_free((tlb)->mm, pud)
+#define __pud_free_tlb(tlb, pud, addr)					\
+do {									\
+	if (pgtable_l4_enabled) {					\
+		pagetable_pud_dtor(virt_to_ptdesc(pud));		\
+		tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pud));	\
+	}								\
+} while (0)
 
 #define p4d_alloc_one p4d_alloc_one
 static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
@@ -124,7 +130,11 @@ static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 		__p4d_free(mm, p4d);
 }
 
-#define __p4d_free_tlb(tlb, p4d, addr)  p4d_free((tlb)->mm, p4d)
+#define __p4d_free_tlb(tlb, p4d, addr)					\
+do {									\
+	if (pgtable_l5_enabled)						\
+		tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(p4d));	\
+} while (0)
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 static inline void sync_kernel_mappings(pgd_t *pgd)
@@ -149,7 +159,11 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-#define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)				\
+do {								\
+	pagetable_pmd_dtor(virt_to_ptdesc(pmd));		\
+	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pmd));	\
+} while (0)
 
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-- 
2.43.0



