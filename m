Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8C53816;
	Tue, 23 Jan 2024 00:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969789; cv=none; b=XVhNEE7kQcP992yZsT2IY8RLOGW301OCphyfdWLl1zYXlOwdGBL1ObbtbCM706dLyzYkLTvTE9D8FQLXD+g0kGMxKRAkm+EN7nxH6lr+rKtB1OCIeMd29Y7Z2q9oGsQsfvH6vZG06piLCulNuzzXpKBnrhHYrYeJp5TV1BAB8Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969789; c=relaxed/simple;
	bh=8fcyCqUq6pRfVidrtERIwRO0VswcPiPji1DJv1n5HYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaFCn/YKFSzx0/6B0njIXaPvaEBs8xbEiUQ77txkc0/r9jlcHtMqZsWFCLs0S1AzEtYu0eoGmSn0JiSvdrUJ+4qSSlGOX8shEiFdeg432uVyozw5Zvfd63j45jaxiv4+RdM/wRLEjkg6t9+GFMrMImpNRYV7Idg8/AaV6N4FU4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jaII2sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jaII2sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F94CC433C7;
	Tue, 23 Jan 2024 00:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969789;
	bh=8fcyCqUq6pRfVidrtERIwRO0VswcPiPji1DJv1n5HYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jaII2sajakQB5w9jL+Ya+ZBGI9Q9IHv518y3ho5bG1a08NIcyqCgrmlgamtZJFIw
	 0AyL34F9xcW+vNeb9EN5Bf3r8PcPe2Nw8SRLRPRkP17OJhAMrii71gn7l2hgcOPtrz
	 jAD0TByqkRx5osFc7dhlCvhvnY3EsXSYkz3o8vXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.7 426/641] LoongArch: Fix and simplify fcsr initialization on execve()
Date: Mon, 22 Jan 2024 15:55:30 -0800
Message-ID: <20240122235831.323393532@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit c2396651309eba291c15e32db8fbe44c738b5921 upstream.

There has been a lingering bug in LoongArch Linux systems causing some
GCC tests to intermittently fail (see Closes link).  I've made a minimal
reproducer:

    zsh% cat measure.s
    .align 4
    .globl _start
    _start:
        movfcsr2gr  $a0, $fcsr0
        bstrpick.w  $a0, $a0, 16, 16
        beqz        $a0, .ok
        break       0
    .ok:
        li.w        $a7, 93
        syscall     0
    zsh% cc mesaure.s -o measure -nostdlib
    zsh% echo $((1.0/3))
    0.33333333333333331
    zsh% while ./measure; do ; done

This while loop should not stop as POSIX is clear that execve must set
fenv to the default, where FCSR should be zero.  But in fact it will
just stop after running for a while (normally less than 30 seconds).
Note that "$((1.0/3))" is needed to reproduce this issue because it
raises FE_INVALID and makes fcsr0 non-zero.

The problem is we are currently relying on SET_PERSONALITY2() to reset
current->thread.fpu.fcsr.  But SET_PERSONALITY2() is executed before
start_thread which calls lose_fpu(0).  We can see if kernel preempt is
enabled, we may switch to another thread after SET_PERSONALITY2() but
before lose_fpu(0).  Then bad thing happens: during the thread switch
the value of the fcsr0 register is stored into current->thread.fpu.fcsr,
making it dirty again.

The issue can be fixed by setting current->thread.fpu.fcsr after
lose_fpu(0) because lose_fpu() clears TIF_USEDFPU, then the thread
switch won't touch current->thread.fpu.fcsr.

The only other architecture setting FCSR in SET_PERSONALITY2() is MIPS.
I've ran a similar test on MIPS with mainline kernel and it turns out
MIPS is buggy, too.  Anyway MIPS do this for supporting different FP
flavors (NaN encodings, etc.) which do not exist on LoongArch.  So for
LoongArch, we can simply remove the current->thread.fpu.fcsr setting
from SET_PERSONALITY2() and do it in start_thread(), after lose_fpu(0).

The while loop failing with the mainline kernel has survived one hour
after this change on LoongArch.

Fixes: 803b0fc5c3f2baa ("LoongArch: Add process management")
Closes: https://github.com/loongson-community/discussions/issues/7
Link: https://lore.kernel.org/linux-mips/7a6aa1bbdbbe2e63ae96ff163fab0349f58f1b9e.camel@xry111.site/
Cc: stable@vger.kernel.org
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/elf.h |    5 -----
 arch/loongarch/kernel/elf.c      |    5 -----
 arch/loongarch/kernel/process.c  |    1 +
 3 files changed, 1 insertion(+), 10 deletions(-)

--- a/arch/loongarch/include/asm/elf.h
+++ b/arch/loongarch/include/asm/elf.h
@@ -241,8 +241,6 @@ void loongarch_dump_regs64(u64 *uregs, c
 do {									\
 	current->thread.vdso = &vdso_info;				\
 									\
-	loongarch_set_personality_fcsr(state);				\
-									\
 	if (personality(current->personality) != PER_LINUX)		\
 		set_personality(PER_LINUX);				\
 } while (0)
@@ -259,7 +257,6 @@ do {									\
 	clear_thread_flag(TIF_32BIT_ADDR);				\
 									\
 	current->thread.vdso = &vdso_info;				\
-	loongarch_set_personality_fcsr(state);				\
 									\
 	p = personality(current->personality);				\
 	if (p != PER_LINUX32 && p != PER_LINUX)				\
@@ -340,6 +337,4 @@ extern int arch_elf_pt_proc(void *ehdr,
 extern int arch_check_elf(void *ehdr, bool has_interpreter, void *interp_ehdr,
 			  struct arch_elf_state *state);
 
-extern void loongarch_set_personality_fcsr(struct arch_elf_state *state);
-
 #endif /* _ASM_ELF_H */
--- a/arch/loongarch/kernel/elf.c
+++ b/arch/loongarch/kernel/elf.c
@@ -23,8 +23,3 @@ int arch_check_elf(void *_ehdr, bool has
 {
 	return 0;
 }
-
-void loongarch_set_personality_fcsr(struct arch_elf_state *state)
-{
-	current->thread.fpu.fcsr = boot_cpu_data.fpu_csr0;
-}
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -85,6 +85,7 @@ void start_thread(struct pt_regs *regs,
 	regs->csr_euen = euen;
 	lose_fpu(0);
 	lose_lbt(0);
+	current->thread.fpu.fcsr = boot_cpu_data.fpu_csr0;
 
 	clear_thread_flag(TIF_LSX_CTX_LIVE);
 	clear_thread_flag(TIF_LASX_CTX_LIVE);


