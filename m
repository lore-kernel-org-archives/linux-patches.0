Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4A62459EA;
	Tue, 29 Apr 2025 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947745; cv=none; b=U0LoJinN4OA+EQSXhfsvc0dLvEQFN1eIgnmxetgxCpkQUiumq/IgG5HnxqvxMrATXrcVegX4zIe9e4pGvkIY4za/1RFyGbbL3VPph+HdFyYv2xKxc7fLkUOg5W3BYpKeUjYEckffmVZfxaJwWrT8UnD/BkPARRBdyM6YMmjJpCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947745; c=relaxed/simple;
	bh=HSPLHliQV7cXiIP1TOiyyPoXtBf/4GNvfkjbeOL60+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBD0T7d/a6or7p4RATkVPomGehxRcBkTu01lzJGTlO0LDvzSXYh/+VJjgD7xubLpN7DMEGJP45AjAvKceoWxKsPpQgo6sb9jMMfRvGTsCcy+VUs3XRqrHgg7jVKchmNqy/h+WolRU8qG6uUDZVqhNNhR7odtMA6nbGVszl7iUjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wL6H8ft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wL6H8ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B703C4CEEA;
	Tue, 29 Apr 2025 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947745;
	bh=HSPLHliQV7cXiIP1TOiyyPoXtBf/4GNvfkjbeOL60+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wL6H8ftjDeGZY/+VpMjmBm8v9rKN8j6at+j0gODeFdSYG0pdn9oYBsxudUyLierG
	 IyFcff1m+JNH2y4QDXrGFF1hpB4HIAKBiDstrOdXJyAhzwgexGmLSgv3WvFuCuDQuw
	 b14UN6xKk+pmMdz5qoFsCwXWqnfmnhMUSQT3aSS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/280] LoongArch: Make do_xyz() exception handlers more robust
Date: Tue, 29 Apr 2025 18:40:32 +0200
Message-ID: <20250429161118.832308762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index c57b4134f3e84..00424b7e34c15 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -553,9 +553,10 @@ asmlinkage void noinstr do_ale(struct pt_regs *regs)
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
 #else
+	bool pie = regs_irqs_disabled(regs);
 	unsigned int *pc;
 
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_enable();
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, regs->csr_badvaddr);
@@ -582,7 +583,7 @@ asmlinkage void noinstr do_ale(struct pt_regs *regs)
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 #endif
 	irqentry_exit(regs, state);
@@ -614,12 +615,13 @@ static void bug_handler(struct pt_regs *regs)
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
@@ -685,7 +687,7 @@ asmlinkage void noinstr do_bce(struct pt_regs *regs)
 	force_sig_bnderr((void __user *)badv, (void __user *)lower, (void __user *)upper);
 
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 
 	irqentry_exit(regs, state);
@@ -703,11 +705,12 @@ asmlinkage void noinstr do_bce(struct pt_regs *regs)
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
@@ -773,7 +776,7 @@ asmlinkage void noinstr do_bp(struct pt_regs *regs)
 	}
 
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 
 	irqentry_exit(regs, state);
@@ -1008,6 +1011,7 @@ static void init_restore_lbt(void)
 
 asmlinkage void noinstr do_lbt(struct pt_regs *regs)
 {
+	bool pie = regs_irqs_disabled(regs);
 	irqentry_state_t state = irqentry_enter(regs);
 
 	/*
@@ -1017,7 +1021,7 @@ asmlinkage void noinstr do_lbt(struct pt_regs *regs)
 	 * (including the user using 'MOVGR2GCSR' to turn on TM, which
 	 * will not trigger the BTE), we need to check PRMD first.
 	 */
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_enable();
 
 	if (!cpu_has_lbt) {
@@ -1031,7 +1035,7 @@ asmlinkage void noinstr do_lbt(struct pt_regs *regs)
 	preempt_enable();
 
 out:
-	if (regs->csr_prmd & CSR_PRMD_PIE)
+	if (!pie)
 		local_irq_disable();
 
 	irqentry_exit(regs, state);
-- 
2.39.5



