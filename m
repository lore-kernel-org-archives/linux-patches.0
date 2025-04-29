Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50A3FFD;
	Tue, 29 Apr 2025 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950453; cv=none; b=rIzjUe22F0FgV4y6fgHDJOxdqWzp+OCfzOT47zK0S9Iax244VwWXQ5eXnJRLfrjEfOTYtKbnvKQ8sjLQLKhOyNKAtoHuHax6qUDyWfUv6csr1LFDTHrFsyISKyNL4V+15fv/DDqMtd7kmbEdBbcA+aBY1Pd8auKuZJ7i+8PM8kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950453; c=relaxed/simple;
	bh=d7qjuBgFzkq+Z/fbmlRVGUxmmGiQ56dsOau17e5Ym6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOGpXI2yJmdYvj00eIfQ3d3h9djoEbivgvUKxtyW6xFJFbGQlgxnXLpujVOxc9XAhqjQAYIFZJRzCbgErzYIoTjq10akBepHmSAqquzMc1M5OXxcP6w/g21gLgKp8uN3t3nbgUjKcOd8fnEH/VYvR7ettNP9btiA6qzrubpME2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5XuhHA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5XuhHA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1370C4CEE3;
	Tue, 29 Apr 2025 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950453;
	bh=d7qjuBgFzkq+Z/fbmlRVGUxmmGiQ56dsOau17e5Ym6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5XuhHA9KkknVNV2gAVrcewgc3+iI6lAbaIMXVnw5OeBK3g0CxyFxC1tNrCvZrXwK
	 oZEDbwHG69+/xp429hyoaiK9YjonG3amo6251wE87oYkwpIhUkzx/u0xpwd94khAg6
	 PQFuNmZCxa6vbdwzLfcKa8PaEBtRSklHAP4IPwRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/204] LoongArch: Make do_xyz() exception handlers more robust
Date: Tue, 29 Apr 2025 18:42:39 +0200
Message-ID: <20250429161102.331866836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit cc73cc6bcdb5f959670e3ff9abdc62461452ddff ]

Currently, interrupts need to be disabled before single-step mode is
set, it requires that CSR_PRMD_PIE be cleared in save_local_irqflag()
which is called by setup_singlestep(), this is reasonable.

But in the first kprobe breakpoint exception, if the irq is enabled at
the beginning of do_bp(), it will not be disabled at the end of do_bp()
due to the CSR_PRMD_PIE has been cleared in save_local_irqflag(). So for
this case, it may corrupt exception context when restoring the exception
after do_bp() in handle_bp(), this is not reasonable.

In order to restore exception safely in handle_bp(), it needs to ensure
the irq is disabled at the end of do_bp(), so just add a local variable
to record the original interrupt status in the parent context, then use
it as the check condition to enable and disable irq in do_bp().

While at it, do the similar thing for other do_xyz() exception handlers
to make them more robust.

Fixes: 6d4cc40fb5f5 ("LoongArch: Add kprobes support")
Suggested-by: Jinyang He <hejinyang@loongson.cn>
Suggested-by: Huacai Chen <chenhuacai@loongson.cn>
Co-developed-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/traps.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
index d59052c03d9b7..2b4b99b4e6c94 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -527,9 +527,10 @@ asmlinkage void noinstr do_ale(struct pt_regs *regs)
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
 #else
+	bool pie = regs_irqs_disabled(regs);
 	unsigned int *pc;
 
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_enable();
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, regs->csr_badvaddr);
@@ -556,7 +557,7 @@ asmlinkage void noinstr do_ale(struct pt_regs *regs)
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 #endif
 	irqentry_exit(regs, state);
@@ -588,12 +589,13 @@ static void bug_handler(struct pt_regs *regs)
 asmlinkage void noinstr do_bce(struct pt_regs *regs)
 {
 	bool user = user_mode(regs);
+	bool pie = regs_irqs_disabled(regs);
 	unsigned long era = exception_era(regs);
 	u64 badv = 0, lower = 0, upper = ULONG_MAX;
 	union loongarch_instruction insn;
 	irqentry_state_t state = irqentry_enter(regs);
 
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_enable();
 
 	current->thread.trap_nr = read_csr_excode();
@@ -659,7 +661,7 @@ asmlinkage void noinstr do_bce(struct pt_regs *regs)
 	force_sig_bnderr((void __user *)badv, (void __user *)lower, (void __user *)upper);
 
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 
 	irqentry_exit(regs, state);
@@ -677,11 +679,12 @@ asmlinkage void noinstr do_bce(struct pt_regs *regs)
 asmlinkage void noinstr do_bp(struct pt_regs *regs)
 {
 	bool user = user_mode(regs);
+	bool pie = regs_irqs_disabled(regs);
 	unsigned int opcode, bcode;
 	unsigned long era = exception_era(regs);
 	irqentry_state_t state = irqentry_enter(regs);
 
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_enable();
 
 	if (__get_inst(&opcode, (u32 *)era, user))
@@ -747,7 +750,7 @@ asmlinkage void noinstr do_bp(struct pt_regs *regs)
 	}
 
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 
 	irqentry_exit(regs, state);
@@ -982,6 +985,7 @@ static void init_restore_lbt(void)
 
 asmlinkage void noinstr do_lbt(struct pt_regs *regs)
 {
+	bool pie = regs_irqs_disabled(regs);
 	irqentry_state_t state = irqentry_enter(regs);
 
 	/*
@@ -991,7 +995,7 @@ asmlinkage void noinstr do_lbt(struct pt_regs *regs)
 	 * (including the user using 'MOVGR2GCSR' to turn on TM, which
 	 * will not trigger the BTE), we need to check PRMD first.
 	 */
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_enable();
 
 	if (!cpu_has_lbt) {
@@ -1005,7 +1009,7 @@ asmlinkage void noinstr do_lbt(struct pt_regs *regs)
 	preempt_enable();
 
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 
 	irqentry_exit(regs, state);
-- 
2.39.5



