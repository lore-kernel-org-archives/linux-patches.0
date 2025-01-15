Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5BB248BA0;
	Wed, 15 Jan 2025 10:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937665; cv=none; b=FPem0IfAxIf0EHsi9KpCDvYGrjLm0pUjVtYOObrr2RTJLmQtumkFo7ojaYw85lJRYG50kOPWQSG9AoaVGLEaQOLyp8qd47rDIwzsbanikuOWM6jKufgMyHW/xFjpckLy0boHIbyFH34lFvKzL3RO2R4XHsn2ZzaAhbH+4d/89Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937665; c=relaxed/simple;
	bh=l+RlmR1N4KC7lq8oJeB8Ffve8grQWMiCYDblaSpjkpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgSuKsceHCVCBzsr1rzB2k/Rh8OhyMrYVXCOSuBuCykoce7HTvvSnEIBaCU8sfiDNnnPHuaNCAJck49bDudpCtXPXZbbb5kAFB5mZFC00LfQkGjMWxCIaGPT4ZSO+knFYIbg/+tGDEqwz+QrjQlHvw5zBnhziykAhs/qpA+XIo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWchJY8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWchJY8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27257C4CEE1;
	Wed, 15 Jan 2025 10:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937664;
	bh=l+RlmR1N4KC7lq8oJeB8Ffve8grQWMiCYDblaSpjkpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWchJY8gthuJS7m9tumK7FSg3tQxufMXpMn40ad0llGsAXJ2yVqYhPCshVnYZhIXP
	 IEccpHlPXqbM9o6Ca/oVtU3mnaiE4v7C5ugW1Aj8NTI/gxGmx7XCDL5SQyeti+Fkkl
	 ZQVbnWldPedvLbWrFRMlJdOx3o+yarVjWDYa/IkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 45/92] riscv: Fix sleeping in invalid context in die()
Date: Wed, 15 Jan 2025 11:37:03 +0100
Message-ID: <20250115103549.328488921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 6a97f4118ac07cfdc316433f385dbdc12af5025e upstream.

die() can be called in exception handler, and therefore cannot sleep.
However, die() takes spinlock_t which can sleep with PREEMPT_RT enabled.
That causes the following warning:

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 285, name: mutex
preempt_count: 110001, expected: 0
RCU nest depth: 0, expected: 0
CPU: 0 UID: 0 PID: 285 Comm: mutex Not tainted 6.12.0-rc7-00022-ge19049cf7d56-dirty #234
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
    dump_backtrace+0x1c/0x24
    show_stack+0x2c/0x38
    dump_stack_lvl+0x5a/0x72
    dump_stack+0x14/0x1c
    __might_resched+0x130/0x13a
    rt_spin_lock+0x2a/0x5c
    die+0x24/0x112
    do_trap_insn_illegal+0xa0/0xea
    _new_vmalloc_restore_context_a0+0xcc/0xd8
Oops - illegal instruction [#1]

Switch to use raw_spinlock_t, which does not sleep even with PREEMPT_RT
enabled.

Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20241118091333.1185288-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -27,7 +27,7 @@
 
 int show_unhandled_signals = 1;
 
-static DEFINE_SPINLOCK(die_lock);
+static DEFINE_RAW_SPINLOCK(die_lock);
 
 void die(struct pt_regs *regs, const char *str)
 {
@@ -38,7 +38,7 @@ void die(struct pt_regs *regs, const cha
 
 	oops_enter();
 
-	spin_lock_irqsave(&die_lock, flags);
+	raw_spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -55,7 +55,7 @@ void die(struct pt_regs *regs, const cha
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irqrestore(&die_lock, flags);
+	raw_spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())


