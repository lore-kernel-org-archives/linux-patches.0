Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF27718B462;
	Tue, 10 Sep 2024 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964478; cv=none; b=HStxg44bmfxMkumqTVuk0RGVVlFgYDOcENJzCjr0DHLFkSZwYm3KNDXfKFn7Qwvc091hDPozIoHsHxTaDncYtKPJA/ERCsm0to2BZ3/VfS/EsYeWOUS71wNntEVF/DzP+yqMyni2sPbuN/82QMC7Txa/jhAJjkI5dO/FVjD2wuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964478; c=relaxed/simple;
	bh=8suC4PMMCm6AFIMZYmMkG6BSihA1xyRVLFeT9QPv6Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpBaYwIRfFSKqIIgAw9esc2RQjZpdvZUf2vAamF+tbnLVXLThBpfDw3XOIsAMOldlX1EEdHorUfiOwYXyRycHfuTz+a+wa+YFQNEceDkYXIavrlWl9nrAST7MjUgCLqVkstNMd3NOZAjH3+t1mJu2b4IqMc36xVaFZP773oyIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVfxRVRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVfxRVRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37884C4CEC3;
	Tue, 10 Sep 2024 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964478;
	bh=8suC4PMMCm6AFIMZYmMkG6BSihA1xyRVLFeT9QPv6Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVfxRVRdf0AK3AJeVVKIeoUS4nQY1VIThPXRdB9KJ7YmdP4Bml3hak3ZoEGKz4nwO
	 dI4HjRQ5RKn7jX8in/skNFoZfO/ZtpYDBZgA3BCfn6fhNadCI11a46Zg+FHgHpYwAv
	 GDcrt4+B066i/yKqk+5N06odhphq6jmcqjn7GMzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 196/269] riscv: Use WRITE_ONCE() when setting page table entries
Date: Tue, 10 Sep 2024 11:33:03 +0200
Message-ID: <20240910092615.094075592@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

commit c30fa83b49897e708a52e122dd10616a52a4c82b upstream.

To avoid any compiler "weirdness" when accessing page table entries which
are concurrently modified by the HW, let's use WRITE_ONCE() macro
(commit 20a004e7b017 ("arm64: mm: Use READ_ONCE/WRITE_ONCE when accessing
page tables") gives a great explanation with more details).

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231213203001.179237-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable-64.h |    6 +++---
 arch/riscv/include/asm/pgtable.h    |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -198,7 +198,7 @@ static inline int pud_user(pud_t pud)
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
-	*pudp = pud;
+	WRITE_ONCE(*pudp, pud);
 }
 
 static inline void pud_clear(pud_t *pudp)
@@ -274,7 +274,7 @@ static inline unsigned long _pmd_pfn(pmd
 static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 {
 	if (pgtable_l4_enabled)
-		*p4dp = p4d;
+		WRITE_ONCE(*p4dp, p4d);
 	else
 		set_pud((pud_t *)p4dp, (pud_t){ p4d_val(p4d) });
 }
@@ -347,7 +347,7 @@ static inline pud_t *pud_offset(p4d_t *p
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	if (pgtable_l5_enabled)
-		*pgdp = pgd;
+		WRITE_ONCE(*pgdp, pgd);
 	else
 		set_p4d((p4d_t *)pgdp, (p4d_t){ pgd_val(pgd) });
 }
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -248,7 +248,7 @@ static inline int pmd_leaf(pmd_t pmd)
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
-	*pmdp = pmd;
+	WRITE_ONCE(*pmdp, pmd);
 }
 
 static inline void pmd_clear(pmd_t *pmdp)
@@ -515,7 +515,7 @@ static inline int pte_same(pte_t pte_a,
  */
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
-	*ptep = pteval;
+	WRITE_ONCE(*ptep, pteval);
 }
 
 void flush_icache_pte(pte_t pte);


