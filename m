Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183218C925;
	Tue, 10 Sep 2024 10:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963254; cv=none; b=ou+J4zTDMQ90H4t7jPiqNQ3m4gMnLsdzRguJUz3c3Ik6Jq74O9hqY/Y61d0/viLB80ZuTvME9/dXSt1EpQzjS18lTX+qrfbz4fgfBk8otGtaGkXux3rQW/sSVPsK7kZF0bDRs2emhRIXa9AP/kyc0ZfyqE/fl/tW4cF7DY7wdQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963254; c=relaxed/simple;
	bh=C0HItraWQo2cKwoxjU9UyXMZiy27iVZ5MG6reerC8jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/ylMRKtPEvc5e6ZC9CuTvcCHEQJkKzhhSeAZMrPYdVxulvKlmJoqS2+LVr8Au5nmcFYiF5+GSHDG58Sdt1WSkgGaAcUd5JLld/EmwEDI/y6vwsKvlBafH1Tr7CJeZqXKJqhEXYTwnZscyrCWS93HXiLySFBOoncWLFTv1BtfVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyTpJKt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyTpJKt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B61FC4CEC3;
	Tue, 10 Sep 2024 10:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963253;
	bh=C0HItraWQo2cKwoxjU9UyXMZiy27iVZ5MG6reerC8jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyTpJKt8QkQPuSTh7/jaDSn5nKF+V67RGIzMS0RuwQy10IOZz+Jxs3VvtIX97aU70
	 Bx1K1wdFYQAtRqJmfy75p9qwPuwCRY2/MZqCKElej4iPjlqwUhyXDddpaGTqXJgQqM
	 cxP6PuqjygkYqNdN7TK3sMwHMNKZsD6+Vg1TBD28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 187/192] x86/mm: Fix PTI for i386 some more
Date: Tue, 10 Sep 2024 11:33:31 +0200
Message-ID: <20240910092605.506280450@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit c48b5a4cf3125adb679e28ef093f66ff81368d05 upstream.

So it turns out that we have to do two passes of
pti_clone_entry_text(), once before initcalls, such that device and
late initcalls can use user-mode-helper / modprobe and once after
free_initmem() / mark_readonly().

Now obviously mark_readonly() can cause PMD splits, and
pti_clone_pgtable() doesn't like that much.

Allow the late clone to split PMDs so that pagetables stay in sync.

[peterz: Changelog and comments]
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.kernel.org/r/20240806184843.GX37996@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pti.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -241,7 +241,7 @@ static pmd_t *pti_user_pagetable_walk_pm
  *
  * Returns a pointer to a PTE on success, or NULL on failure.
  */
-static pte_t *pti_user_pagetable_walk_pte(unsigned long address)
+static pte_t *pti_user_pagetable_walk_pte(unsigned long address, bool late_text)
 {
 	gfp_t gfp = (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO);
 	pmd_t *pmd;
@@ -251,10 +251,15 @@ static pte_t *pti_user_pagetable_walk_pt
 	if (!pmd)
 		return NULL;
 
-	/* We can't do anything sensible if we hit a large mapping. */
+	/* Large PMD mapping found */
 	if (pmd_large(*pmd)) {
-		WARN_ON(1);
-		return NULL;
+		/* Clear the PMD if we hit a large mapping from the first round */
+		if (late_text) {
+			set_pmd(pmd, __pmd(0));
+		} else {
+			WARN_ON_ONCE(1);
+			return NULL;
+		}
 	}
 
 	if (pmd_none(*pmd)) {
@@ -283,7 +288,7 @@ static void __init pti_setup_vsyscall(vo
 	if (!pte || WARN_ON(level != PG_LEVEL_4K) || pte_none(*pte))
 		return;
 
-	target_pte = pti_user_pagetable_walk_pte(VSYSCALL_ADDR);
+	target_pte = pti_user_pagetable_walk_pte(VSYSCALL_ADDR, false);
 	if (WARN_ON(!target_pte))
 		return;
 
@@ -301,7 +306,7 @@ enum pti_clone_level {
 
 static void
 pti_clone_pgtable(unsigned long start, unsigned long end,
-		  enum pti_clone_level level)
+		  enum pti_clone_level level, bool late_text)
 {
 	unsigned long addr;
 
@@ -390,7 +395,7 @@ pti_clone_pgtable(unsigned long start, u
 				return;
 
 			/* Allocate PTE in the user page-table */
-			target_pte = pti_user_pagetable_walk_pte(addr);
+			target_pte = pti_user_pagetable_walk_pte(addr, late_text);
 			if (WARN_ON(!target_pte))
 				return;
 
@@ -452,7 +457,7 @@ static void __init pti_clone_user_shared
 		phys_addr_t pa = per_cpu_ptr_to_phys((void *)va);
 		pte_t *target_pte;
 
-		target_pte = pti_user_pagetable_walk_pte(va);
+		target_pte = pti_user_pagetable_walk_pte(va, false);
 		if (WARN_ON(!target_pte))
 			return;
 
@@ -475,7 +480,7 @@ static void __init pti_clone_user_shared
 	start = CPU_ENTRY_AREA_BASE;
 	end   = start + (PAGE_SIZE * CPU_ENTRY_AREA_PAGES);
 
-	pti_clone_pgtable(start, end, PTI_CLONE_PMD);
+	pti_clone_pgtable(start, end, PTI_CLONE_PMD, false);
 }
 #endif /* CONFIG_X86_64 */
 
@@ -492,11 +497,11 @@ static void __init pti_setup_espfix64(vo
 /*
  * Clone the populated PMDs of the entry text and force it RO.
  */
-static void pti_clone_entry_text(void)
+static void pti_clone_entry_text(bool late)
 {
 	pti_clone_pgtable((unsigned long) __entry_text_start,
 			  (unsigned long) __entry_text_end,
-			  PTI_LEVEL_KERNEL_IMAGE);
+			  PTI_LEVEL_KERNEL_IMAGE, late);
 }
 
 /*
@@ -571,7 +576,7 @@ static void pti_clone_kernel_text(void)
 	 * pti_set_kernel_image_nonglobal() did to clear the
 	 * global bit.
 	 */
-	pti_clone_pgtable(start, end_clone, PTI_LEVEL_KERNEL_IMAGE);
+	pti_clone_pgtable(start, end_clone, PTI_LEVEL_KERNEL_IMAGE, false);
 
 	/*
 	 * pti_clone_pgtable() will set the global bit in any PMDs
@@ -638,8 +643,15 @@ void __init pti_init(void)
 
 	/* Undo all global bits from the init pagetables in head_64.S: */
 	pti_set_kernel_image_nonglobal();
+
 	/* Replace some of the global bits just for shared entry text: */
-	pti_clone_entry_text();
+	/*
+	 * This is very early in boot. Device and Late initcalls can do
+	 * modprobe before free_initmem() and mark_readonly(). This
+	 * pti_clone_entry_text() allows those user-mode-helpers to function,
+	 * but notably the text is still RW.
+	 */
+	pti_clone_entry_text(false);
 	pti_setup_espfix64();
 	pti_setup_vsyscall();
 }
@@ -656,10 +668,11 @@ void pti_finalize(void)
 	if (!boot_cpu_has(X86_FEATURE_PTI))
 		return;
 	/*
-	 * We need to clone everything (again) that maps parts of the
-	 * kernel image.
+	 * This is after free_initmem() (all initcalls are done) and we've done
+	 * mark_readonly(). Text is now NX which might've split some PMDs
+	 * relative to the early clone.
 	 */
-	pti_clone_entry_text();
+	pti_clone_entry_text(true);
 	pti_clone_kernel_text();
 
 	debug_checkwx_user();


