Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7C1AF0C8;
	Wed, 19 Feb 2025 08:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953897; cv=none; b=gyKOjxi9Kh8iuCCO/m+Iwb1Gr0r2TyYK8T/amneDa24xdGt0q4gc24IeKfRChlPQT0+qG87WrZ7stHXoAP4fg8Y4DjPhoUnCeVHIjlcHFNG3OSd9Jz9MpyBxAdue0ggXDR2FXF/fnfcfxIr0iQaiLch7p1zQ5RmJbMxiOZnoJ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953897; c=relaxed/simple;
	bh=/q8pT/sueomoMnUqDxXTowa04esvBQ0kh8wFhi3ddBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFUO0myPjuqUOTgCwq7N51+46UYOPJG2k3SSxn3vrxe3SH5m6voMOa0fvemL5u9nW68TJb+t/4KVl6H2yttVH7jCA0aYC0D/DaTkLsa+9xjWQ8lqWtx13rjO9mYipAjAMcfR0+8SexY5JxfSJQmJ+KIuTbfJxzISwpniY11gdVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wM0DP98J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wM0DP98J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8AEC4CED1;
	Wed, 19 Feb 2025 08:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953897;
	bh=/q8pT/sueomoMnUqDxXTowa04esvBQ0kh8wFhi3ddBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wM0DP98JJBHUDdSJO05e7o3EybItsjbj8lB3j1brIrpNEVZS/17y1bWKOi8AARqjJ
	 Y0bRZToDbY5VqEzzF9sfQmPWSNq4TXRcYmJ3QE0uGv3EMHsJ6M68dUUz7TiWrOT708
	 J0YgoT2JzOakv1S4B+wwskwI32lTNMkz0U4YpJWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/274] LoongArch: Fix idle VS timer enqueue
Date: Wed, 19 Feb 2025 09:24:44 +0100
Message-ID: <20250219082610.713150919@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit edb1942542bc538707cea221e9c7923a6270465f ]

LoongArch re-enables interrupts on its idle routine and performs a
TIF_NEED_RESCHED check afterwards before putting the CPU to sleep.

The IRQs firing between the check and the idle instruction may set the
TIF_NEED_RESCHED flag. In order to deal with such a race, IRQs
interrupting __arch_cpu_idle() rollback their return address to the
beginning of __arch_cpu_idle() so that TIF_NEED_RESCHED is checked
again before going back to sleep.

However idle IRQs can also queue timers that may require a tick
reprogramming through a new generic idle loop iteration but those timers
would go unnoticed here because __arch_cpu_idle() only checks
TIF_NEED_RESCHED. It doesn't check for pending timers.

Fix this with fast-forwarding idle IRQs return address to the end of the
idle routine instead of the beginning, so that the generic idle loop can
handle both TIF_NEED_RESCHED and pending timers.

Fixes: 0603839b18f4 ("LoongArch: Add exception/interrupt handling")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/genex.S | 28 +++++++++++++++-------------
 arch/loongarch/kernel/idle.c  |  3 +--
 arch/loongarch/kernel/reset.c |  6 +++---
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/kernel/genex.S b/arch/loongarch/kernel/genex.S
index 86d5d90ebefe5..4f09121417818 100644
--- a/arch/loongarch/kernel/genex.S
+++ b/arch/loongarch/kernel/genex.S
@@ -18,16 +18,19 @@
 
 	.align	5
 SYM_FUNC_START(__arch_cpu_idle)
-	/* start of rollback region */
-	LONG_L	t0, tp, TI_FLAGS
-	nop
-	andi	t0, t0, _TIF_NEED_RESCHED
-	bnez	t0, 1f
-	nop
-	nop
-	nop
+	/* start of idle interrupt region */
+	ori	t0, zero, CSR_CRMD_IE
+	/* idle instruction needs irq enabled */
+	csrxchg	t0, t0, LOONGARCH_CSR_CRMD
+	/*
+	 * If an interrupt lands here; between enabling interrupts above and
+	 * going idle on the next instruction, we must *NOT* go idle since the
+	 * interrupt could have set TIF_NEED_RESCHED or caused an timer to need
+	 * reprogramming. Fall through -- see handle_vint() below -- and have
+	 * the idle loop take care of things.
+	 */
 	idle	0
-	/* end of rollback region */
+	/* end of idle interrupt region */
 1:	jr	ra
 SYM_FUNC_END(__arch_cpu_idle)
 
@@ -35,11 +38,10 @@ SYM_CODE_START(handle_vint)
 	UNWIND_HINT_UNDEFINED
 	BACKUP_T0T1
 	SAVE_ALL
-	la_abs	t1, __arch_cpu_idle
+	la_abs	t1, 1b
 	LONG_L	t0, sp, PT_ERA
-	/* 32 byte rollback region */
-	ori	t0, t0, 0x1f
-	xori	t0, t0, 0x1f
+	/* 3 instructions idle interrupt region */
+	ori	t0, t0, 0b1100
 	bne	t0, t1, 1f
 	LONG_S	t0, sp, PT_ERA
 1:	move	a0, sp
diff --git a/arch/loongarch/kernel/idle.c b/arch/loongarch/kernel/idle.c
index 0b5dd2faeb90b..54b247d8cdb69 100644
--- a/arch/loongarch/kernel/idle.c
+++ b/arch/loongarch/kernel/idle.c
@@ -11,7 +11,6 @@
 
 void __cpuidle arch_cpu_idle(void)
 {
-	raw_local_irq_enable();
-	__arch_cpu_idle(); /* idle instruction needs irq enabled */
+	__arch_cpu_idle();
 	raw_local_irq_disable();
 }
diff --git a/arch/loongarch/kernel/reset.c b/arch/loongarch/kernel/reset.c
index 1ef8c63835351..de8fa5a8a825c 100644
--- a/arch/loongarch/kernel/reset.c
+++ b/arch/loongarch/kernel/reset.c
@@ -33,7 +33,7 @@ void machine_halt(void)
 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
 
 	while (true) {
-		__arch_cpu_idle();
+		__asm__ __volatile__("idle 0" : : : "memory");
 	}
 }
 
@@ -53,7 +53,7 @@ void machine_power_off(void)
 #endif
 
 	while (true) {
-		__arch_cpu_idle();
+		__asm__ __volatile__("idle 0" : : : "memory");
 	}
 }
 
@@ -74,6 +74,6 @@ void machine_restart(char *command)
 		acpi_reboot();
 
 	while (true) {
-		__arch_cpu_idle();
+		__asm__ __volatile__("idle 0" : : : "memory");
 	}
 }
-- 
2.39.5



