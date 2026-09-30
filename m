Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122BD3B2D1A;
	Wed, 30 Sep 2026 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791790; cv=none; b=unD0S9hKSb2TKGy9ejH2ctG/KPzF8TqB+ypXwE/xzHzK3e/m45BQmBggAnsASlOS9Hoz/8hYK9HBpSamZ1xAZOJNsLxYgevGEa93DYriPEwfc2mP4Bu1i+DoYhzasLzJDV/rPOY4xNuNmWgXU6bH3Yacz+0gdCPDg8+eltE8Afs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791790; c=relaxed/simple;
	bh=zfwZyvLWRDK9u05onvXlM7hmY7vzwH9bD9Bu/TMEudY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOXQzx14dph34+HhqH4lfthZAhMTUIUqHU6qL7xDOzvaSG1Yx/GfluIXhyB6O0d/gVEUwgVeg0PcsIMNXU1g8XfK+RfjsTS8tudN5eycPHYvLbiYN8pfh6U0Ct8X7UAu2N/edbqhutlctBqFE+nzc0YQxmpdmLkvGq7MGXObcm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjCwOHa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjCwOHa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCCF1F000FF;
	Wed, 30 Sep 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791789;
	bh=BTzSJGE8qaeMjiuH1NEblQszLbfOeSyG/rHj3ATi9hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjCwOHa37j6W+n8ucX9d/URmoWSM1uhT4mtSMkWieUGwKBn0prNcrDgzAn2q04aiR
	 2z05/ObLy+fPaYzOkSf0SYh3Esf04FiS5gKGhkCCJkS6gQLfW4cSuNBZS4QrnlFWvy
	 vCxyz4amngrwujYiPW5nRCVWCgCI7KOe873kkosE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/752] Revert "alpha: dont leak hardware-fabricated FP exception bits to user space"
Date: Wed, 30 Sep 2026 17:24:57 +0200
Message-ID: <20260930152407.525171778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit f55e039ce84f2bb01c6efca1029998f4dc7a83d8.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/traps.c  |  6 +--
 arch/alpha/math-emu/math.c | 88 +++++---------------------------------
 2 files changed, 14 insertions(+), 80 deletions(-)

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 8629b8ccb8b2f..a78e93256ecb1 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -200,12 +200,12 @@ static long dummy_emul(void) { return 0; }
 long (*alpha_fp_emul_imprecise)(struct pt_regs *regs, unsigned long writemask)
   = (void *)dummy_emul;
 EXPORT_SYMBOL_GPL(alpha_fp_emul_imprecise);
-long (*alpha_fp_emul) (unsigned long pc, unsigned long summary)
+long (*alpha_fp_emul) (unsigned long pc)
   = (void *)dummy_emul;
 EXPORT_SYMBOL_GPL(alpha_fp_emul);
 #else
 long alpha_fp_emul_imprecise(struct pt_regs *regs, unsigned long writemask);
-long alpha_fp_emul (unsigned long pc, unsigned long summary);
+long alpha_fp_emul (unsigned long pc);
 #endif
 
 asmlinkage void
@@ -219,7 +219,7 @@ do_entArith(unsigned long summary, unsigned long write_mask,
 		   emulate the instruction.  If the processor supports
 		   precise exceptions, we don't have to search.  */
 		if (!amask(AMASK_PRECISE_TRAP))
-			si_code = alpha_fp_emul(regs->pc - 4, summary);
+			si_code = alpha_fp_emul(regs->pc - 4);
 		else
 			si_code = alpha_fp_emul_imprecise(regs, write_mask);
 		if (si_code == 0)
diff --git a/arch/alpha/math-emu/math.c b/arch/alpha/math-emu/math.c
index 14b0bc325914d..4212258f3cfdc 100644
--- a/arch/alpha/math-emu/math.c
+++ b/arch/alpha/math-emu/math.c
@@ -57,13 +57,13 @@ MODULE_DESCRIPTION("FP Software completion module");
 MODULE_LICENSE("GPL v2");
 
 extern long (*alpha_fp_emul_imprecise)(struct pt_regs *, unsigned long);
-extern long (*alpha_fp_emul) (unsigned long pc, unsigned long summary);
+extern long (*alpha_fp_emul) (unsigned long pc);
 
 static long (*save_emul_imprecise)(struct pt_regs *, unsigned long);
-static long (*save_emul) (unsigned long pc, unsigned long summary);
+static long (*save_emul) (unsigned long pc);
 
 long do_alpha_fp_emul_imprecise(struct pt_regs *, unsigned long);
-long do_alpha_fp_emul(unsigned long, unsigned long);
+long do_alpha_fp_emul(unsigned long);
 
 static int alpha_fp_emul_init_module(void)
 {
@@ -91,22 +91,7 @@ module_exit(alpha_fp_emul_cleanup_module);
 
 
 /*
- * Exception bits of the exception summary register (EXC_SUM).  Bit 0 is the
- * software completion bit; bits 1 through 5 report the exceptions the
- * hardware attributed to the trapping instruction, and lie at the same
- * positions as the corresponding IEEE_TRAP_ENABLE_* bits.
- */
-#define EXC_SUM_INV	(1UL << 1)
-#define EXC_SUM_DZE	(1UL << 2)
-#define EXC_SUM_OVF	(1UL << 3)
-#define EXC_SUM_UNF	(1UL << 4)
-#define EXC_SUM_INE	(1UL << 5)
-#define EXC_SUM_MASK	(EXC_SUM_INV | EXC_SUM_DZE | EXC_SUM_OVF	\
-			 | EXC_SUM_UNF | EXC_SUM_INE)
-
-/*
- * Emulate the floating point instruction at address PC.  SUMMARY is the
- * exception summary register the trap was delivered with.  Returns -1 if the
+ * Emulate the floating point instruction at address PC.  Returns -1 if the
  * instruction to be emulated is illegal (such as with the opDEC trap), else
  * the SI_CODE for a SIGFPE signal, else 0 if everything's ok.
  *
@@ -115,7 +100,7 @@ module_exit(alpha_fp_emul_cleanup_module);
  * stick the result of the operation into the appropriate register.
  */
 long
-alpha_fp_emul (unsigned long pc, unsigned long summary)
+alpha_fp_emul (unsigned long pc)
 {
 	FP_DECL_EX;
 	FP_DECL_S(SA); FP_DECL_S(SB); FP_DECL_S(SR);
@@ -320,56 +305,12 @@ alpha_fp_emul (unsigned long pc, unsigned long summary)
 		swcr |= (_fex << IEEE_STATUS_TO_EXCSUM_SHIFT);
 		current_thread_info()->ieee_state
 		  |= (_fex << IEEE_STATUS_TO_EXCSUM_SHIFT);
-	}
 
-	/*
-	 * EV6 records exception status bits in the FPCR before delivering the
-	 * software completion trap, and swcr_update_status() above merged them
-	 * into SWCR.  Some can be wrong for the instruction we just emulated:
-	 * a CVTTS of a value exactly representable as a subnormal sets FPCR_UNF
-	 * even though the result is exact.  Clear the exceptions the trap
-	 * reported but that soft-fp did not raise.
-	 */
-	if (implver() == IMPLVER_EV6) {
-		unsigned long spurious = summary & EXC_SUM_MASK;
-
-		if (spurious & (EXC_SUM_UNF | EXC_SUM_OVF)) {
-			/*
-			 * EXC_SUM reports only the underflow or overflow,
-			 * but the hardware sets INE alongside it in the FPCR.
-			 */
-			spurious |= EXC_SUM_INE;
-		} else if (!spurious) {
-			/*
-			 * No exception reported, so this was a denormal
-			 * operand trap, for which INE and UNF can be
-			 * fabricated as well.
-			 */
-			spurious = EXC_SUM_INE | EXC_SUM_UNF;
-		}
+		/* Update hardware control register.  */
+		fpcr &= (~FPCR_MASK | FPCR_DYN_MASK);
+		fpcr |= ieee_swcr_to_fpcr(swcr);
+		wrfpcr(fpcr);
 
-		/*
-		 * Never clear an exception software has confirmed.  Every
-		 * instruction that genuinely raises one traps for software
-		 * completion and is recorded in ieee_state above, so a bit
-		 * found there -- including one just set from _fex -- belongs
-		 * to this or an earlier instruction and must survive.
-		 */
-		spurious &= ~(current_thread_info()->ieee_state
-			      >> IEEE_STATUS_TO_EXCSUM_SHIFT);
-
-		swcr &= ~(spurious << IEEE_STATUS_TO_EXCSUM_SHIFT);
-	}
-
-	/*
-	 * Update hardware control register.  This has to happen even when
-	 * soft-fp raised nothing, to clear any fabricated bits.
-	 */
-	fpcr &= (~FPCR_MASK | FPCR_DYN_MASK);
-	fpcr |= ieee_swcr_to_fpcr(swcr);
-	wrfpcr(fpcr);
-
-	if (_fex) {
 		/* Do we generate a signal?  */
 		_fex = _fex & swcr & IEEE_TRAP_ENABLE_MASK;
 		si_code = 0;
@@ -451,16 +392,9 @@ alpha_fp_emul_imprecise (struct pt_regs *regs, unsigned long write_mask)
 			break;
 		}
 		if (!write_mask) {
-			/*
-			 * Re-execute insns in the trap-shadow.  Pass no
-			 * exception summary: it describes the trap, which
-			 * was taken anywhere in the shadow, and so is not
-			 * attribution for this instruction.  Nothing is
-			 * lost, since only EV6 -- which traps precisely and
-			 * never comes this way -- needs it.
-			 */
+			/* Re-execute insns in the trap-shadow.  */
 			regs->pc = trigger_pc + 4;
-			si_code = alpha_fp_emul(trigger_pc, 0);
+			si_code = alpha_fp_emul(trigger_pc);
 			goto egress;
 		}
 		trigger_pc -= 4;
-- 
2.53.0



