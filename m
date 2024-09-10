Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B21143880;
	Tue, 10 Sep 2024 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963169; cv=none; b=VVUoJ7Z6lVJeGy7U1WGW9NT3/gxJ27WDI+EwDAoO1GWwd795EI9uePqHGaqbDBEc6yu1p5WbFa3t8GtNybLFb7l1R+zgCQIpkCCh0Hj/6Kdi+CqBgzkIW9rZltKF8m1ZtL8R+nu9BnVkI/X67ckwHmNTg9EE9tkgIHUz2zwaMQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963169; c=relaxed/simple;
	bh=1r+WHUuYh1d3OTfs7L3mpbxHeJMx5Y/Lk335urbiCeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfL/dcpXY9Tlyhrb2gFwALbOPVHSGyFuVPykzvmNXSNHGrdTE0rhVKjCJe7PuMdoagu8UpX5JD7DuKTEyDeE5lMk8DukjPhvJXx+hRRTfdm5SaOilWKbsRp0sOkgiyBpuQkv/ATva02coOAqMnj+/57KXuwwaAOFGbZcrzSYoNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBBR3/Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBBR3/Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629F5C4CEC3;
	Tue, 10 Sep 2024 10:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963168;
	bh=1r+WHUuYh1d3OTfs7L3mpbxHeJMx5Y/Lk335urbiCeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBBR3/JuC7xSqeY1PsWViwBoxWyNJjTRvxtH8XBWa3l/Hf4oICKSvTZnMQ8Tr5MhJ
	 QgwZ80nzw9S+Wg3MPNev6cGxpvQ3j4ezX7aszlSd7MTCHQld5/I56MtaWfcD0asm5Y
	 cN88mjTURUBB6tNmHAqQxXpNJ0o+DfLE9NDPai3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/192] x86/mm/pae: Make pmd_t similar to pte_t
Date: Tue, 10 Sep 2024 11:33:02 +0200
Message-ID: <20240910092604.456070042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit fbfdec9989e69e0b17aa3bf32fcb22d04cc33301 ]

Instead of mucking about with at least 2 different ways of fudging
it, do the same thing we do for pte_t.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221022114424.580310787%40infradead.org
Stable-dep-of: 71c186efc1b2 ("userfaultfd: fix checks for huge PMDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pgtable-3level.h       | 42 +++++++--------------
 arch/x86/include/asm/pgtable-3level_types.h |  7 ++++
 arch/x86/include/asm/pgtable_64_types.h     |  1 +
 arch/x86/include/asm/pgtable_types.h        |  4 +-
 4 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 28421a887209..28556d22feb8 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -87,7 +87,7 @@ static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 		ret |= ((pmdval_t)*(tmp + 1)) << 32;
 	}
 
-	return (pmd_t) { ret };
+	return (pmd_t) { .pmd = ret };
 }
 
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
@@ -121,12 +121,11 @@ static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
 	ptep->pte_high = 0;
 }
 
-static inline void native_pmd_clear(pmd_t *pmd)
+static inline void native_pmd_clear(pmd_t *pmdp)
 {
-	u32 *tmp = (u32 *)pmd;
-	*tmp = 0;
+	pmdp->pmd_low = 0;
 	smp_wmb();
-	*(tmp + 1) = 0;
+	pmdp->pmd_high = 0;
 }
 
 static inline void native_pud_clear(pud_t *pudp)
@@ -162,25 +161,17 @@ static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
-union split_pmd {
-	struct {
-		u32 pmd_low;
-		u32 pmd_high;
-	};
-	pmd_t pmd;
-};
-
 #ifdef CONFIG_SMP
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
 {
-	union split_pmd res, *orig = (union split_pmd *)pmdp;
+	pmd_t res;
 
 	/* xchg acts as a barrier before setting of the high bits */
-	res.pmd_low = xchg(&orig->pmd_low, 0);
-	res.pmd_high = orig->pmd_high;
-	orig->pmd_high = 0;
+	res.pmd_low = xchg(&pmdp->pmd_low, 0);
+	res.pmd_high = READ_ONCE(pmdp->pmd_high);
+	WRITE_ONCE(pmdp->pmd_high, 0);
 
-	return res.pmd;
+	return res;
 }
 #else
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
@@ -199,17 +190,12 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 	 * anybody.
 	 */
 	if (!(pmd_val(pmd) & _PAGE_PRESENT)) {
-		union split_pmd old, new, *ptr;
-
-		ptr = (union split_pmd *)pmdp;
-
-		new.pmd = pmd;
-
 		/* xchg acts as a barrier before setting of the high bits */
-		old.pmd_low = xchg(&ptr->pmd_low, new.pmd_low);
-		old.pmd_high = ptr->pmd_high;
-		ptr->pmd_high = new.pmd_high;
-		return old.pmd;
+		old.pmd_low = xchg(&pmdp->pmd_low, pmd.pmd_low);
+		old.pmd_high = READ_ONCE(pmdp->pmd_high);
+		WRITE_ONCE(pmdp->pmd_high, pmd.pmd_high);
+
+		return old;
 	}
 
 	do {
diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
index 56baf43befb4..80911349519e 100644
--- a/arch/x86/include/asm/pgtable-3level_types.h
+++ b/arch/x86/include/asm/pgtable-3level_types.h
@@ -18,6 +18,13 @@ typedef union {
 	};
 	pteval_t pte;
 } pte_t;
+
+typedef union {
+	struct {
+		unsigned long pmd_low, pmd_high;
+	};
+	pmdval_t pmd;
+} pmd_t;
 #endif	/* !__ASSEMBLY__ */
 
 #define SHARED_KERNEL_PMD	(!static_cpu_has(X86_FEATURE_PTI))
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 6c7f7c526450..4ea3755f2444 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -19,6 +19,7 @@ typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
 
 typedef struct { pteval_t pte; } pte_t;
+typedef struct { pmdval_t pmd; } pmd_t;
 
 #ifdef CONFIG_X86_5LEVEL
 extern unsigned int __pgtable_l5_enabled;
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index e3028373f0b4..d0e9654d7272 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -363,11 +363,9 @@ static inline pudval_t native_pud_val(pud_t pud)
 #endif
 
 #if CONFIG_PGTABLE_LEVELS > 2
-typedef struct { pmdval_t pmd; } pmd_t;
-
 static inline pmd_t native_make_pmd(pmdval_t val)
 {
-	return (pmd_t) { val };
+	return (pmd_t) { .pmd = val };
 }
 
 static inline pmdval_t native_pmd_val(pmd_t pmd)
-- 
2.43.0



