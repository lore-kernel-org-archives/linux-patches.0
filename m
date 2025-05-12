Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1CE1A08CA;
	Mon, 12 May 2025 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072150; cv=none; b=N7gizv0q3IZ2zUcRU/fybAvMIk3so4FAlfw/aXTjJJnXGo8hf5w81fn9m55cu5YuJGsBNHWlDCMrKJsHFhtSHkGwB0fOBrrTIFon3mP1ZY1h3ahpkOwRY0SVoUiQAyky6vOA4QU72rwB1EhG4MO4CJ1QY76J5hFRiOzYIxR1K9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072150; c=relaxed/simple;
	bh=BVsoVlAbRZ5yEKzzJGpQQZO3dl50+b99LgKxkokh8QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMJZF7NP+mhmDg2mynvXH1EJYRkzx5gU9/JUMenLXtkePgooHUOu+b2kFKRmxTv1h3AF1zdlVyerEnYhbVXPsnJP8O0K/hC1ouqvsgp/rbclaTICpAgQE0lV+MTPV+S/qV+Za351G+SWrEHWDAYn5pFusiDR2aRib7g3jh0VPlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdSeYtWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdSeYtWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46030C4CEE7;
	Mon, 12 May 2025 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072150;
	bh=BVsoVlAbRZ5yEKzzJGpQQZO3dl50+b99LgKxkokh8QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdSeYtWrqq4wk8K0lv6Lc6AOEwfjcrDimFG2NvPf6CedDufJTb49sYtDmlf7YBKOB
	 LweWR4ejYtJWJD8CEkMtkOtG2i59cwyxrRHD37SSpc6TkgrgD/5tHeGvLejLSnBUcK
	 lPWckIUYGWRAzjSARqXC80LTo0MdjxlC1WrbtDls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Crivellari <marco.crivellari@suse.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 154/197] MIPS: Fix idle VS timer enqueue
Date: Mon, 12 May 2025 19:40:04 +0200
Message-ID: <20250512172050.657796914@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit 56651128e2fbad80f632f388d6bf1f39c928267a ]

MIPS re-enables interrupts on its idle routine and performs
a TIF_NEED_RESCHED check afterwards before putting the CPU to sleep.

The IRQs firing between the check and the 'wait' instruction may set the
TIF_NEED_RESCHED flag. In order to deal with this possible race, IRQs
interrupting __r4k_wait() rollback their return address to the
beginning of __r4k_wait() so that TIF_NEED_RESCHED is checked
again before going back to sleep.

However idle IRQs can also queue timers that may require a tick
reprogramming through a new generic idle loop iteration but those timers
would go unnoticed here because __r4k_wait() only checks
TIF_NEED_RESCHED. It doesn't check for pending timers.

Fix this with fast-forwarding idle IRQs return address to the end of the
idle routine instead of the beginning, so that the generic idle loop
handles both TIF_NEED_RESCHED and pending timers.

CONFIG_CPU_MICROMIPS has been removed along with the nop instructions.
There, NOPs are 2 byte in size, so change the code with 3 _ssnop which are
always 4 byte and remove the ifdef. Added ehb to make sure the hazard
is always cleared.

Fixes: c65a5480ff29 ("[MIPS] Fix potential latency problem due to non-atomic cpu_wait.")
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/idle.h |  3 +-
 arch/mips/kernel/genex.S     | 62 +++++++++++++++++++++---------------
 arch/mips/kernel/idle.c      |  7 ----
 3 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/arch/mips/include/asm/idle.h b/arch/mips/include/asm/idle.h
index 0992cad9c632e..2bc3678455ed0 100644
--- a/arch/mips/include/asm/idle.h
+++ b/arch/mips/include/asm/idle.h
@@ -6,8 +6,7 @@
 #include <linux/linkage.h>
 
 extern void (*cpu_wait)(void);
-extern void r4k_wait(void);
-extern asmlinkage void __r4k_wait(void);
+extern asmlinkage void r4k_wait(void);
 extern void r4k_wait_irqoff(void);
 
 static inline int using_rollback_handler(void)
diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index a572ce36a24f2..46d975d00298d 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -104,42 +104,52 @@ handle_vcei:
 
 	__FINIT
 
-	.align	5	/* 32 byte rollback region */
-LEAF(__r4k_wait)
-	.set	push
-	.set	noreorder
-	/* start of rollback region */
-	LONG_L	t0, TI_FLAGS($28)
-	nop
-	andi	t0, _TIF_NEED_RESCHED
-	bnez	t0, 1f
-	 nop
-	nop
-	nop
-#ifdef CONFIG_CPU_MICROMIPS
-	nop
-	nop
-	nop
-	nop
-#endif
+	/* Align to 32 bytes for the maximum idle interrupt region size. */
+	.align	5
+LEAF(r4k_wait)
+	/* Keep the ISA bit clear for calculations on local labels here. */
+0:	.fill 	0
+	/* Start of idle interrupt region. */
+	local_irq_enable
+	/*
+	 * If an interrupt lands here, before going idle on the next
+	 * instruction, we must *NOT* go idle since the interrupt could
+	 * have set TIF_NEED_RESCHED or caused a timer to need resched.
+	 * Fall through -- see rollback_handler below -- and have the
+	 * idle loop take care of things.
+	 */
+1:	.fill	0
+	/* The R2 EI/EHB sequence takes 8 bytes, otherwise pad up.  */
+	.if		1b - 0b > 32
+	.error	"overlong idle interrupt region"
+	.elseif	1b - 0b > 8
+	.align	4
+	.endif
+2:	.fill	0
+	.equ	r4k_wait_idle_size, 2b - 0b
+	/* End of idle interrupt region; size has to be a power of 2. */
 	.set	MIPS_ISA_ARCH_LEVEL_RAW
+r4k_wait_insn:
 	wait
-	/* end of rollback region (the region size must be power of two) */
-1:
+r4k_wait_exit:
+	.set	mips0
+	local_irq_disable
 	jr	ra
-	 nop
-	.set	pop
-	END(__r4k_wait)
+	END(r4k_wait)
+	.previous
 
 	.macro	BUILD_ROLLBACK_PROLOGUE handler
 	FEXPORT(rollback_\handler)
 	.set	push
 	.set	noat
 	MFC0	k0, CP0_EPC
-	PTR_LA	k1, __r4k_wait
-	ori	k0, 0x1f	/* 32 byte rollback region */
-	xori	k0, 0x1f
+	/* Subtract/add 2 to let the ISA bit propagate through the mask.  */
+	PTR_LA	k1, r4k_wait_insn - 2
+	ori 	k0, r4k_wait_idle_size - 2
+	.set	noreorder
 	bne	k0, k1, \handler
+	PTR_ADDIU 	k0, r4k_wait_exit - r4k_wait_insn + 2
+	.set	reorder
 	MTC0	k0, CP0_EPC
 	.set pop
 	.endm
diff --git a/arch/mips/kernel/idle.c b/arch/mips/kernel/idle.c
index 5abc8b7340f88..80e8a04a642e0 100644
--- a/arch/mips/kernel/idle.c
+++ b/arch/mips/kernel/idle.c
@@ -35,13 +35,6 @@ static void __cpuidle r3081_wait(void)
 	write_c0_conf(cfg | R30XX_CONF_HALT);
 }
 
-void __cpuidle r4k_wait(void)
-{
-	raw_local_irq_enable();
-	__r4k_wait();
-	raw_local_irq_disable();
-}
-
 /*
  * This variant is preferable as it allows testing need_resched and going to
  * sleep depending on the outcome atomically.  Unfortunately the "It is
-- 
2.39.5



