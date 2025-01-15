Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2542248BA1;
	Wed, 15 Jan 2025 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938212; cv=none; b=p+PzSmJBKVTgVrULMFH6PQu9p/CNvUMQaUJE3GdRx4UtO6cSpevzflyVgYLxElL55EAbRiQT3G4+CYtkgN6t29D/4ickni1iw8XZF6xorUZoaq55ZGw1VGYBvUg1Djs6KCIxN3TYlOeUW67avjFmah+UaDMQX8WssN1oP4nfMvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938212; c=relaxed/simple;
	bh=7ydR5Sx0uPpGyidMa4XNrq6Lh4ofBg2RI8Ku8hy33Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qE1Z1RETVVmjtsNn7SadBef69aZ0nlDwCDAKRVx7BoluUpAq/iR872JTdHsS3otwkXrDYeVqAakvRl3HjIw5+fjgveL8PtDUVPWNblPy4rZY1G+bYxkqLICOcbxVgTUEfx05dAk/uEuJzUgdQLVABQYc9FTjdSaJgdzwlKgBqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eexcFxrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eexcFxrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04439C4CEDF;
	Wed, 15 Jan 2025 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938212;
	bh=7ydR5Sx0uPpGyidMa4XNrq6Lh4ofBg2RI8Ku8hy33Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eexcFxrUILl9q8La0AGNdqNviVhkl3/JmTHkjHTKAsVrhWRTYuh8l+Cz6I5pTcofc
	 vSHe12MA2aIZJy7Ou97w3QO5F12byg72zTE4gV7U1Fnh94IMtDbywMhgmhwgO534n+
	 v5FY10iUMHVBW7imCBdm7UXoQEjg7aNnDoIvkeYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 116/189] riscv: Fix sleeping in invalid context in die()
Date: Wed, 15 Jan 2025 11:36:52 +0100
Message-ID: <20250115103611.091669230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
@@ -35,7 +35,7 @@
 
 int show_unhandled_signals = 1;
 
-static DEFINE_SPINLOCK(die_lock);
+static DEFINE_RAW_SPINLOCK(die_lock);
 
 static int copy_code(struct pt_regs *regs, u16 *val, const u16 *insns)
 {
@@ -81,7 +81,7 @@ void die(struct pt_regs *regs, const cha
 
 	oops_enter();
 
-	spin_lock_irqsave(&die_lock, flags);
+	raw_spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -100,7 +100,7 @@ void die(struct pt_regs *regs, const cha
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irqrestore(&die_lock, flags);
+	raw_spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())


