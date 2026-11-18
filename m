Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036683;
	b=suHAMnRCF7LZY+VrwoExSNQsmjpScK/MAHGhusyBigCwkbn4szrGNTG4AZZd77mGtF/w
	 Vur1T7+iIXvXKjcTrTc0F1Nuowrp0v6BpzClA9Ugnel8AXiabQtbVLAu3RGOB1IzR1Stq
	 PdSLobQq5xVQAZ5Z7a5kIt5vV6WJ+o/FHWajbu71AHDJQm08yj1rDEwi+Rq3VB/Xe9ofu
	 f03FVq4/T89ZqZF+dD/67qlMMg36BQ0ckW6dS37E0VR0fhZF2GNAyxBQ70wYP1/LwAfZg
	 FeluEMyB5NDrDKiAt1w6eB8Bz3UBoifQLniuOVOeA3hQlJq3R1jxhqHCCTYxXptf72w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kyGwritq25r2grpr6HkbHu8Dlb5fch16pCkC2dMx5ig=;
	b=EPwe3hbWzWV7xA4x1NcKVZ0APA5Lj9/c4pNnG7mFrmMJCtEP76O5Dl8hTQcPN28O63Cp
	 WV5JK8RL0N9cmY6Me5W8PbAGIPKhj2s4CvPr/ssAOLGNi84D1DmFdxVoLIWU5mHOFjlj7
	 +ROezk73nDrt13GGbaCiMpV07dDJ5YDI3NfKU7k4ekkSFxch/mSulxhNBOg4YKgX7tRSF
	 cS0PhCvEzSXNr2lqskVK5PmE6FmnCI4gx2FaeovQZfb0vELQkcpI9XC3DszVk/w8DAG2J
	 n2v9KJW3t/IiONsW872HwsQ1qjw2SjoTRXpQKasHeXcpCSDVfWNd422f6SwGtdi4MSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lJ8/bKd0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6F9606A320;
	Wed, 18 Nov 2026 21:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJ8/bKd0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9C61F000C4;
	Wed, 18 Nov 2026 21:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036682;
	bh=kyGwritq25r2grpr6HkbHu8Dlb5fch16pCkC2dMx5ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJ8/bKd0BW/hr2qMCqXBzdTswGgHVcPwX2znbs9kMy9SG1ltfebQGoc5aab07SKpJ
	 PAbNVpKxJXEZh6KGRIUFrkcWDmXxEqjXIYscOWiPYRpxrDSb6brms7lqAai849CzRG
	 ctbEHLZibGRgqNxq9PGYNctjMO55xVhDJ4fNoP8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1110/3318] ARM: 9488/1: smp: set current pointer in assembly before jumping into C
Date: Wed, 18 Nov 2026 15:28:52 +0100
Message-ID: <20261118150353.300620066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f6e551e7d515579b952422c93415470fb672d848 ]

With CONFIG_KCOV_INSTRUMENT_ALL=y, secondary CPUs fail to come online
on ARMv6K/ARMv7 SMP:

  CPU1: failed to boot: -38

The compiler inserts a call to __sanitizer_cov_trace_pc() at the entry
of secondary_start_kernel(), before set_current(task). The KCOV hook
dereferences current while TPIDRURO is still uninitialized, causing a
data abort before cpu_init() has installed the exception stacks. The
secondary CPU consequently never completes startup.

Initialize current in the secondary assembly handoff, as
__mmap_switched already does for the boot CPU.

With current set in assembly, the set_current() call in
secondary_start_kernel() is redundant. Drop it together with the
function and the task argument. The hotplug resuscitate path in
arch_cpu_idle_dead() needs no hand-off either, as smp_ops.cpu_die()
can only return if the CPU kept its register state, TPIDRURO included.

Assisted-by: Claude:claude-fable-5

Fixes: 50596b7559bf ("ARM: smp: Store current pointer in TPIDRURO register if available")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/smp.h   |  2 +-
 arch/arm/kernel/head-nommu.S |  1 +
 arch/arm/kernel/head.S       |  1 +
 arch/arm/kernel/smp.c        | 15 ++-------------
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 8c05a7f374d8b..84aa6a663e816 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -43,7 +43,7 @@ extern void set_smp_ipi_range(int ipi_base, int nr_ipi);
  * Called from platform specific assembly code, this is the
  * secondary CPU entry point.
  */
-asmlinkage void secondary_start_kernel(struct task_struct *task);
+asmlinkage void secondary_start_kernel(void);
 
 
 /*
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index b9d6818f1ee16..f80bbfbd3a6f8 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -116,6 +116,7 @@ ENTRY(secondary_startup)
 	ldr	r7, __secondary_data		@ reload r7
 	ldr	sp, [r7, #12]			@ set up the stack pointer
 	ldr	r0, [r7, #16]			@ set up task pointer
+	set_current r0, r1
 	mov	fp, #0
 	b	secondary_start_kernel
 ENDPROC(secondary_startup)
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index f22c50d4bd417..a22403a629efa 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -442,6 +442,7 @@ ENTRY(__secondary_switched)
 	adr_l	r7, secondary_data + 12		@ get secondary_data.stack
 	ldr	sp, [r7]
 	ldr	r0, [r7, #4]			@ get secondary_data.task
+	set_current r0, r1
 	mov	fp, #0
 	b	secondary_start_kernel
 ENDPROC(__secondary_switched)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 3431c0553f45c..f548ada379afb 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -371,12 +371,9 @@ void __noreturn arch_cpu_idle_dead(void)
 	 */
 	__asm__("mov	sp, %0\n"
 	"	mov	fp, #0\n"
-	"	mov	r0, %1\n"
 	"	b	secondary_start_kernel"
 		:
-		: "r" (task_stack_page(current) + THREAD_SIZE - 8),
-		  "r" (current)
-		: "r0");
+		: "r" (task_stack_page(current) + THREAD_SIZE - 8));
 
 	unreachable();
 }
@@ -397,23 +394,15 @@ static void smp_store_cpu_info(unsigned int cpuid)
 	check_cpu_icache_size(cpuid);
 }
 
-static void set_current(struct task_struct *cur)
-{
-	/* Set TPIDRURO */
-	asm("mcr p15, 0, %0, c13, c0, 3" :: "r"(cur) : "memory");
-}
-
 /*
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
-asmlinkage void secondary_start_kernel(struct task_struct *task)
+asmlinkage void secondary_start_kernel(void)
 {
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu;
 
-	set_current(task);
-
 	secondary_biglittle_init();
 
 	/*
-- 
2.53.0



