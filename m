Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4480E2E36E8;
	Tue, 22 Jul 2025 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192963; cv=none; b=EWYSbz7PWRWMx8XJrRSpKJwo3QvE94w1DTO+TUHGjtVrKo9QaItPRbD6WsrhIDtBN4lFIKxKqm7om6bLQpySRidcNQkSbV/gZDM7WrdZU7rF8w84vaUmaV/nluJQDVH4tRgrmDd9Ct1O7bu5WArT2Tmf7jGG4VctDx97UeUj+V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192963; c=relaxed/simple;
	bh=5yiMyiLv5lczmoeIGGLXi6hyrlSRrS5OUmYleUhKfxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvExBEoJAftsFJ2Fl3+SjUMlY4Z0abn8lwd2KAjrrXShrBffTAN7ivf5hbG6Cfek+qRdJi79clwLzBCgHRk2skHYrVuES3D3FjRLf2mYcNj720kZS9nkeICIEEC75G+X/T5qhodQs0Lf1Qe82pxnQyMAXgpntnf99FRYbe/zov4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1Q8UB/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1Q8UB/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98B5C4CEEB;
	Tue, 22 Jul 2025 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192963;
	bh=5yiMyiLv5lczmoeIGGLXi6hyrlSRrS5OUmYleUhKfxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1Q8UB/kTgL2oBngN948vA2e3S8lPt+1qAyXQizNOhVRLEhqochPFg9Wuygc7qFA4
	 3CrH2fm67nYjhCFOkSLN/waIHqXJCr6muQ9iz2va4QMwm+C0alNviYyXCPrtguefWe
	 Xoj5pVXzp0rOzVCA09eeLFSlq1bLrofT7UsEAnh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/158] riscv: Enable interrupt during exception handling
Date: Tue, 22 Jul 2025 15:44:55 +0200
Message-ID: <20250722134344.895326258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 969f028bf2c40573ef18061f702ede3ebfe12b42 ]

force_sig_fault() takes a spinlock, which is a sleeping lock with
CONFIG_PREEMPT_RT=y. However, exception handling calls force_sig_fault()
with interrupt disabled, causing a sleeping in atomic context warning.

This can be reproduced using userspace programs such as:
    int main() { asm ("ebreak"); }
or
    int main() { asm ("unimp"); }

There is no reason that interrupt must be disabled while handling
exceptions from userspace.

Enable interrupt while handling user exceptions. This also has the added
benefit of avoiding unnecessary delays in interrupt handling.

Fixes: f0bddf50586d ("riscv: entry: Convert to generic entry")
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250625085630.3649485-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 9c83848797a78..80230de167def 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -6,6 +6,7 @@
 #include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 #include <linux/randomize_kstack.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
@@ -151,7 +152,9 @@ asmlinkage __visible __trap_section void name(struct pt_regs *regs)		\
 {										\
 	if (user_mode(regs)) {							\
 		irqentry_enter_from_user_mode(regs);				\
+		local_irq_enable();						\
 		do_trap_error(regs, signo, code, regs->epc, "Oops - " str);	\
+		local_irq_disable();						\
 		irqentry_exit_to_user_mode(regs);				\
 	} else {								\
 		irqentry_state_t state = irqentry_nmi_enter(regs);		\
@@ -173,17 +176,14 @@ asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_regs *re
 
 	if (user_mode(regs)) {
 		irqentry_enter_from_user_mode(regs);
-
 		local_irq_enable();
 
 		handled = riscv_v_first_use_handler(regs);
-
-		local_irq_disable();
-
 		if (!handled)
 			do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
 				      "Oops - illegal instruction");
 
+		local_irq_disable();
 		irqentry_exit_to_user_mode(regs);
 	} else {
 		irqentry_state_t state = irqentry_nmi_enter(regs);
@@ -308,9 +308,11 @@ asmlinkage __visible __trap_section void do_trap_break(struct pt_regs *regs)
 {
 	if (user_mode(regs)) {
 		irqentry_enter_from_user_mode(regs);
+		local_irq_enable();
 
 		handle_break(regs);
 
+		local_irq_disable();
 		irqentry_exit_to_user_mode(regs);
 	} else {
 		irqentry_state_t state = irqentry_nmi_enter(regs);
-- 
2.39.5



