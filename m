Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B11143880;
	Tue, 10 Sep 2024 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963172; cv=none; b=VoMPBNKfdUB2f90HRSTFAbj9tUQTsZsdTfmxxxV4zwyX7PbTH4vUHJcqTZq0GNKTELsFwSZM2hkojUCWzkFmWogWnMtcRUXBeucRMExqdPQZkz4mwkaOqawRiTvtaOs2ZjBa4qVfJbZeIRmL/pVTTtzgNQMEyy4NEkj0pm0UE/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963172; c=relaxed/simple;
	bh=JsUgj/Iv0jn9sxa6AEKPAsXfkGAHU9HNUy4nkvEw0QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+jW/17tgXhl+dUX3JzZXu0pB3ujHgHAC8URG17VDq0XiQJd+Lv3hj1HkWcTKkhNG6uOp3vYZjJ3M4WiQWsHjPEasFarA+bUVgAwL9niuPZdMDe3n3JNIaiipZYNuhBLnlNk/NAHywK42v5i8T5OOFpBc6znbSt43FdDtfNpDT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOW7O9kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOW7O9kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ABDC4CEC3;
	Tue, 10 Sep 2024 10:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963171;
	bh=JsUgj/Iv0jn9sxa6AEKPAsXfkGAHU9HNUy4nkvEw0QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOW7O9kV7GzBOdeCyxPYS/T6/bdRn7oHb3kHcRFmuH5ShuZk3NfsWDGVxrUHOghS3
	 yuj4QlcC+MESjuM+7f8fRoUE3PFHDDwmhjYxo6pd7TcVWeKy5UPiIVNV5qfTFD5NpW
	 O4h3wIMw/I3BK7VznJ0bH22fw569hea5Yy523/lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/192] mm: Fix pmd_read_atomic()
Date: Tue, 10 Sep 2024 11:33:03 +0200
Message-ID: <20240910092604.491396323@linuxfoundation.org>
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

[ Upstream commit 024d232ae4fcd7a7ce8ea239607d6c1246d7adc8 ]

AFAICT there's no reason to do anything different than what we do for
PTEs. Make it so (also affects SH).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221022114424.711181252%40infradead.org
Stable-dep-of: 71c186efc1b2 ("userfaultfd: fix checks for huge PMDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pgtable-3level.h | 56 ---------------------------
 include/linux/pgtable.h               | 47 +++++++++++++++++-----
 2 files changed, 37 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 28556d22feb8..94f50b0100a5 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -34,62 +34,6 @@ static inline void native_set_pte(pte_t *ptep, pte_t pte)
 	ptep->pte_low = pte.pte_low;
 }
 
-#define pmd_read_atomic pmd_read_atomic
-/*
- * pte_offset_map_lock() on 32-bit PAE kernels was reading the pmd_t with
- * a "*pmdp" dereference done by GCC. Problem is, in certain places
- * where pte_offset_map_lock() is called, concurrent page faults are
- * allowed, if the mmap_lock is hold for reading. An example is mincore
- * vs page faults vs MADV_DONTNEED. On the page fault side
- * pmd_populate() rightfully does a set_64bit(), but if we're reading the
- * pmd_t with a "*pmdp" on the mincore side, a SMP race can happen
- * because GCC will not read the 64-bit value of the pmd atomically.
- *
- * To fix this all places running pte_offset_map_lock() while holding the
- * mmap_lock in read mode, shall read the pmdp pointer using this
- * function to know if the pmd is null or not, and in turn to know if
- * they can run pte_offset_map_lock() or pmd_trans_huge() or other pmd
- * operations.
- *
- * Without THP if the mmap_lock is held for reading, the pmd can only
- * transition from null to not null while pmd_read_atomic() runs. So
- * we can always return atomic pmd values with this function.
- *
- * With THP if the mmap_lock is held for reading, the pmd can become
- * trans_huge or none or point to a pte (and in turn become "stable")
- * at any time under pmd_read_atomic(). We could read it truly
- * atomically here with an atomic64_read() for the THP enabled case (and
- * it would be a whole lot simpler), but to avoid using cmpxchg8b we
- * only return an atomic pmdval if the low part of the pmdval is later
- * found to be stable (i.e. pointing to a pte). We are also returning a
- * 'none' (zero) pmdval if the low part of the pmd is zero.
- *
- * In some cases the high and low part of the pmdval returned may not be
- * consistent if THP is enabled (the low part may point to previously
- * mapped hugepage, while the high part may point to a more recently
- * mapped hugepage), but pmd_none_or_trans_huge_or_clear_bad() only
- * needs the low part of the pmd to be read atomically to decide if the
- * pmd is unstable or not, with the only exception when the low part
- * of the pmd is zero, in which case we return a 'none' pmd.
- */
-static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
-{
-	pmdval_t ret;
-	u32 *tmp = (u32 *)pmdp;
-
-	ret = (pmdval_t) (*tmp);
-	if (ret) {
-		/*
-		 * If the low part is null, we must not read the high part
-		 * or we can end up with a partial pmd.
-		 */
-		smp_rmb();
-		ret |= ((pmdval_t)*(tmp + 1)) << 32;
-	}
-
-	return (pmd_t) { .pmd = ret };
-}
-
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
 	set_64bit((unsigned long long *)(ptep), native_pte_val(pte));
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 5f0d7d0b9471..8f31e2ff6b58 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -316,6 +316,13 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_GET
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return READ_ONCE(*pmdp);
+}
+#endif
+
 #ifdef CONFIG_GUP_GET_PTE_LOW_HIGH
 /*
  * WARNING: only to be used in the get_user_pages_fast() implementation.
@@ -361,15 +368,42 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
 
 	return pte;
 }
-#else /* CONFIG_GUP_GET_PTE_LOW_HIGH */
+#define ptep_get_lockless ptep_get_lockless
+
+#if CONFIG_PGTABLE_LEVELS > 2
+static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
+{
+	pmd_t pmd;
+
+	do {
+		pmd.pmd_low = pmdp->pmd_low;
+		smp_rmb();
+		pmd.pmd_high = pmdp->pmd_high;
+		smp_rmb();
+	} while (unlikely(pmd.pmd_low != pmdp->pmd_low));
+
+	return pmd;
+}
+#define pmdp_get_lockless pmdp_get_lockless
+#endif /* CONFIG_PGTABLE_LEVELS > 2 */
+#endif /* CONFIG_GUP_GET_PTE_LOW_HIGH */
+
 /*
  * We require that the PTE can be read atomically.
  */
+#ifndef ptep_get_lockless
 static inline pte_t ptep_get_lockless(pte_t *ptep)
 {
 	return ptep_get(ptep);
 }
-#endif /* CONFIG_GUP_GET_PTE_LOW_HIGH */
+#endif
+
+#ifndef pmdp_get_lockless
+static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
+{
+	return pmdp_get(pmdp);
+}
+#endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
@@ -1339,17 +1373,10 @@ static inline int pud_trans_unstable(pud_t *pud)
 #endif
 }
 
-#ifndef pmd_read_atomic
 static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 {
-	/*
-	 * Depend on compiler for an atomic pmd read. NOTE: this is
-	 * only going to work, if the pmdval_t isn't larger than
-	 * an unsigned long.
-	 */
-	return *pmdp;
+	return pmdp_get_lockless(pmdp);
 }
-#endif
 
 #ifndef arch_needs_pgtable_deposit
 #define arch_needs_pgtable_deposit() (false)
-- 
2.43.0



