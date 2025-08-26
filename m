Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E0347C3;
	Tue, 26 Aug 2025 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213557; cv=none; b=kO6GuQyd3CuJezzs/8EV+txVatv+KbSdHBm+bi3OiRQtIDVB2aAQ5hOqfZYvHALT5qduT9yCo0bM7xW8YT3iz4jrXN0bXZOp2dSbVbT1sdvIaATHesP0LVjHrTLG4qbjxasPGHa1gFr4PU3GGO4nIiN3xZfUfFtKm8YD49oZTk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213557; c=relaxed/simple;
	bh=S+RzEyg6Vs+qT98M5WroKTknaLH9rlq6nzamzE9vMnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emksEF5IhyzRDuOahqL4QAkAx3/HnBxu9Gx+YjrZubNU37MSfegBktyqPfjoZMYGHJZeuHXOGxQ6f0sLMrTf8DpFwVLT55KUFm2ZZPLyvNBPdd0WdLzTEMGnSmlzxvVsUwUl1RcYgZpooRVLrWo6XsWaNJa5E2CchjqFjEGvPtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poU1rQjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poU1rQjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D089AC4CEF1;
	Tue, 26 Aug 2025 13:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213557;
	bh=S+RzEyg6Vs+qT98M5WroKTknaLH9rlq6nzamzE9vMnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poU1rQjCtWeLbjSFfgDDHErKP9+S66atxTKVLoqATFVGI8EDwFGfqe+e8zsxdWXXU
	 BXY7bkdta9CL5GNI9KbBhki6l8tlCZwLcKdTIf9pZrsfL3LLjdgJldymOv4oKCkcbr
	 DZxw71w5t/uqM2Vly9wzwvfOpd0hVBTXUQ3VZ/L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 393/587] parisc: Define and use set_pte_at()
Date: Tue, 26 Aug 2025 13:09:02 +0200
Message-ID: <20250826111002.917493077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


