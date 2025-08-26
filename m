Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0311329D273;
	Tue, 26 Aug 2025 11:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208385; cv=none; b=riQ1Izr0JXAW6vy8LjG+RyIJlq6UqRfoh5TbaPH6KfJsoKxCo3Q8NITiVcUIq4ZXvc/KrUXvJ2stXWrG+IzLehmdHgh/PEU8gCdIGsLtUQmyBoqAcRtpuBx57JXdaO2JjfTIaCHqugRhvpxHKn6BBQC7jW0NWgmNwvUDgZRvd8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208385; c=relaxed/simple;
	bh=ODkcoQdC4Nnam/YLTQ/h2/gojbCwhO8xX/uZUct3MZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1tX9cWQVBBxJVX84xpfcS39HbkJu8Qy626bHJPoP6wKjpUgC77E8PlbVCmjP11Zsyxyz7hFu8jeuzGMzthBFgXRz8+O0EuSkWBjGGdfvgwKaczfOCFNV1rzJ1LCuAHf1gHWJdkbwjYplOreSxsGd3ggacXVjfKwbz50Dt6MmoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tg/Vl8/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tg/Vl8/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF57C113CF;
	Tue, 26 Aug 2025 11:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208384;
	bh=ODkcoQdC4Nnam/YLTQ/h2/gojbCwhO8xX/uZUct3MZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tg/Vl8/nLkatWPciucCMK6FVszJlrVC8O52ELl3Ko8K/6ACEsMfvbpRZT6WUwaa7j
	 g6g4STSNKuB3UJfjRelsIHiP3xI6m+fbEzzSwM2BAxOX/XFWI2SjUQ7xEj8bE01yHO
	 vOZ/dzxEEYIZuG01mrCgUxXj15LYuIz1+8ukIRfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 090/322] parisc: Define and use set_pte_at()
Date: Tue, 26 Aug 2025 13:08:25 +0200
Message-ID: <20250826110917.888402202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John David Anglin <dave.anglin@bell.net>

commit 802e55488bc2cc1ab6423b720255a785ccac42ce upstream.

When a PTE is changed, we need to flush the PTE. set_pte_at()
was lost in the folio update. PA-RISC version is the same as
the generic version.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -276,7 +276,7 @@ extern unsigned long *empty_zero_page;
 #define pte_none(x)     (pte_val(x) == 0)
 #define pte_present(x)	(pte_val(x) & _PAGE_PRESENT)
 #define pte_user(x)	(pte_val(x) & _PAGE_USER)
-#define pte_clear(mm, addr, xp)  set_pte(xp, __pte(0))
+#define pte_clear(mm, addr, xp) set_pte_at((mm), (addr), (xp), __pte(0))
 
 #define pmd_flag(x)	(pmd_val(x) & PxD_FLAG_MASK)
 #define pmd_address(x)	((unsigned long)(pmd_val(x) &~ PxD_FLAG_MASK) << PxD_VALUE_SHIFT)
@@ -398,6 +398,7 @@ static inline void set_ptes(struct mm_st
 	}
 }
 #define set_ptes set_ptes
+#define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
 
 /* Used for deferring calls to flush_dcache_page() */
 
@@ -462,7 +463,7 @@ static inline int ptep_test_and_clear_yo
 	if (!pte_young(pte)) {
 		return 0;
 	}
-	set_pte(ptep, pte_mkold(pte));
+	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
 	return 1;
 }
 
@@ -472,7 +473,7 @@ pte_t ptep_clear_flush(struct vm_area_st
 struct mm_struct;
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	set_pte(ptep, pte_wrprotect(*ptep));
+	set_pte_at(mm, addr, ptep, pte_wrprotect(*ptep));
 }
 
 #define pte_same(A,B)	(pte_val(A) == pte_val(B))


