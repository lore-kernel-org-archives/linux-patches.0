Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E471E522;
	Thu, 30 Jan 2025 14:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246931; cv=none; b=kG+fNmYYYv0BFJP94s3W43QumCqCtkf7SdxmcNBxR0EJ4Djn3ZSwtTaOh4xQorAmlYBr+4bxTxSi0rMkhxcU3OXhhyj2B9rQVx5HDV1JEjfabXXXeai/6vVLamDirO7Dm/Ctq1mLQeDdgRxHrWvYouiwv4AsH+FMoNe5dNALl6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246931; c=relaxed/simple;
	bh=6Zzsn00fTDhnJW9eGDoJJcO/6q0W0OR1erCU+ck36t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQwq+eRl+EFEwtoEV7fBolMucrUTB+KYWAb8X5N+7POK4FSR99tR1AFvcY5Q2CC8znjC6BfZd1B+zC74kR07xlVrq2XJ9EMGLAJrIPUL1Sc2OEPaO05hsVdjYhaFtyURHXno+ieo7QgOR7d4CnyDRfFfzrOfxP4FJhDKbyF9s+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBfbzs+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBfbzs+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8120C4CED2;
	Thu, 30 Jan 2025 14:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246931;
	bh=6Zzsn00fTDhnJW9eGDoJJcO/6q0W0OR1erCU+ck36t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBfbzs+1rzEAVU9j4UwaZEm2Z//peP+eZcwnz5bEa125u+dlQJYueXgXJPwLX5dK5
	 TiZydF47NfXCgmtInibQPaPC3GRzVekS8xXIxqx9gKNUVCE44ksqFEtR5TI6Fg2MtV
	 8cD2HziyjbGaboGW8YrEkNt2HCDacO3sP5uJv0MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 024/133] riscv: Fix sleeping in invalid context in die()
Date: Thu, 30 Jan 2025 15:00:13 +0100
Message-ID: <20250130140143.483253612@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -25,7 +25,7 @@ int show_unhandled_signals = 1;
 
 extern asmlinkage void handle_exception(void);
 
-static DEFINE_SPINLOCK(die_lock);
+static DEFINE_RAW_SPINLOCK(die_lock);
 
 void die(struct pt_regs *regs, const char *str)
 {
@@ -36,7 +36,7 @@ void die(struct pt_regs *regs, const cha
 
 	oops_enter();
 
-	spin_lock_irqsave(&die_lock, flags);
+	raw_spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -53,7 +53,7 @@ void die(struct pt_regs *regs, const cha
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irqrestore(&die_lock, flags);
+	raw_spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())


