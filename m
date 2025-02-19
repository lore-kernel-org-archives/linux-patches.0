Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA70D1C4609;
	Wed, 19 Feb 2025 08:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955453; cv=none; b=e2Ve3zUKJ4AsZJnDXk3uR0PC3WL8Hni3AVd8mO4RLsGFhCG3nS9vSIhIUDG9/6nCIn/gJqxsj6Fi6It34XghXIqxT0b6NGybjL9BNpAJRLTN0+qwz1oCJ0ogUIWONS5rncgT8iAHBOqr0g8Q6Ueg+uB2PBjETD1tvMLXReBXgms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955453; c=relaxed/simple;
	bh=K4SXdyNvHEOEL2TFKwOEVdvhY17FgYOJhNQ0m0p1fS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmrWu6I1rTznCM1gW1fGR5XJLhho/oJ98lgDKmaZHH0gVrfF+4TZEhJI5VbAma70TXN8ES0hz7keNLaetYK6/UaG2V550VLP+7/p0EkHd4J7yOZXAEbSNksUDba7ieEEmbHgJ3lzVxmph3rpH1zK1ScnP6Gl0Usz19J5nU/xpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAtFaRbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAtFaRbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B485C4CEE8;
	Wed, 19 Feb 2025 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955452;
	bh=K4SXdyNvHEOEL2TFKwOEVdvhY17FgYOJhNQ0m0p1fS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAtFaRbDJQehJvAA/zylDJKHHCYay1uE9mocLE+w6q4L7Lv6yydQ9oRj8RHQ1Wqiv
	 oX5VX26/r87XlBNTshpBBCKhAjMfyWH7yjfEr6B0PNNO2SlIJKPz4WASSPLgNGU++6
	 imCnT0mAY/mp8LFeAwphkFtav2IEg6nNCAPtT9Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/152] LoongArch: Fix idle VS timer enqueue
Date: Wed, 19 Feb 2025 09:27:04 +0100
Message-ID: <20250219082550.474648806@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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
index 2bb3aa2dcfcb2..e75c2dbd5f2c5 100644
--- a/arch/loongarch/kernel/genex.S
+++ b/arch/loongarch/kernel/genex.S
@@ -18,27 +18,29 @@
 
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
 
 SYM_CODE_START(handle_vint)
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



