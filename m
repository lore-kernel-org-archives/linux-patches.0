Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675F11CB5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt99uyp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823BDC433C9;
	Mon, 23 Oct 2023 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061572;
	bh=4dJVnfALTF1dAzNedwmPuzV8ZV5naxzL1NmOKRCRLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt99uyp2NXtNgUQPHZA817FhCDDPmU9WSQeonq8QaHSgKsQbNuDMZQk8loaspEmoo
	 XyqGPn4J53tl0BOAYofUp1yOqLquXrr2A5rSXB/zuHLyCWBnZ5pR3xtnYOL6IWREeM
	 CoRW118w5REmEbDr8yWubj9vAp1w61sDwkoAKyho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Amit Daniel Kachhap <amit.kachhap@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 066/202] arm64: rework FPAC exception handling
Date: Mon, 23 Oct 2023 12:56:13 +0200
Message-ID: <20231023104828.481875551@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit a1fafa3b24a70461bbf3e5c0770893feb0a49292 upstream.

If an FPAC exception is taken from EL1, the entry code will call
do_ptrauth_fault(), where due to:

	BUG_ON(!user_mode(regs))

... the kernel will report a problem within do_ptrauth_fault() rather
than reporting the original context the FPAC exception was taken from.
The pt_regs and ESR value reported will be from within
do_ptrauth_fault() and the code dump will be for the BRK in BUG_ON(),
which isn't sufficient to debug the cause of the original exception.

This patch makes the reporting better by having separate EL0 and EL1
FPAC exception handlers, with the latter calling die() directly to
report the original context the FPAC exception was taken from.

Note that we only need to prevent kprobes of the EL1 FPAC handler, since
the EL0 FPAC handler cannot be called recursively.

For consistency with do_el0_svc*(), I've named the split functions
do_el{0,1}_fpac() rather than do_el{0,1}_ptrauth_fault(). I've also
clarified the comment to not imply there are casues other than FPAC
exceptions.

Prior to this patch FPAC exceptions are reported as:

| kernel BUG at arch/arm64/kernel/traps.c:517!
| Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-rc3-00130-g9c8a180a1cdf-dirty #12
| Hardware name: FVP Base RevC (DT)
| pstate: 00400009 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : do_ptrauth_fault+0x3c/0x40
| lr : el1_fpac+0x34/0x54
| sp : ffff80000a3bbc80
| x29: ffff80000a3bbc80 x28: ffff0008001d8000 x27: 0000000000000000
| x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
| x23: 0000000020400009 x22: ffff800008f70fa4 x21: ffff80000a3bbe00
| x20: 0000000072000000 x19: ffff80000a3bbcb0 x18: fffffbfffda37000
| x17: 3120676e696d7573 x16: 7361202c6e6f6974 x15: 0000000081a90000
| x14: 0040000000000041 x13: 0040000000000001 x12: ffff000001a90000
| x11: fffffbfffda37480 x10: 0068000000000703 x9 : 0001000080000000
| x8 : 0000000000090000 x7 : 0068000000000f03 x6 : 0060000000000783
| x5 : ffff80000a3bbcb0 x4 : ffff0008001d8000 x3 : 0000000072000000
| x2 : 0000000000000000 x1 : 0000000020400009 x0 : ffff80000a3bbcb0
| Call trace:
|  do_ptrauth_fault+0x3c/0x40
|  el1h_64_sync_handler+0xc4/0xd0
|  el1h_64_sync+0x64/0x68
|  test_pac+0x8/0x10
|  smp_init+0x7c/0x8c
|  kernel_init_freeable+0x128/0x28c
|  kernel_init+0x28/0x13c
|  ret_from_fork+0x10/0x20
| Code: 97fffe5e a8c17bfd d50323bf d65f03c0 (d4210000)

With this patch applied FPAC exceptions are reported as:

| Internal error: Oops - FPAC: 0000000072000000 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-rc3-00132-g78846e1c4757-dirty #11
| Hardware name: FVP Base RevC (DT)
| pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : test_pac+0x8/0x10
| lr : 0x0
| sp : ffff80000a3bbe00
| x29: ffff80000a3bbe00 x28: 0000000000000000 x27: 0000000000000000
| x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
| x23: ffff80000a2c8000 x22: 0000000000000000 x21: 0000000000000000
| x20: ffff8000099fa5b0 x19: ffff80000a007000 x18: fffffbfffda37000
| x17: 3120676e696d7573 x16: 7361202c6e6f6974 x15: 0000000081a90000
| x14: 0040000000000041 x13: 0040000000000001 x12: ffff000001a90000
| x11: fffffbfffda37480 x10: 0068000000000703 x9 : 0001000080000000
| x8 : 0000000000090000 x7 : 0068000000000f03 x6 : 0060000000000783
| x5 : ffff80000a2c6000 x4 : ffff0008001d8000 x3 : ffff800009f88378
| x2 : 0000000000000000 x1 : 0000000080210000 x0 : ffff000001a90000
| Call trace:
|  test_pac+0x8/0x10
|  smp_init+0x7c/0x8c
|  kernel_init_freeable+0x128/0x28c
|  kernel_init+0x28/0x13c
|  ret_from_fork+0x10/0x20
| Code: d50323bf d65f03c0 d503233f aa1f03fe (d50323bf)

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220913101732.3925290-5-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/exception.h |    3 ++-
 arch/arm64/kernel/entry-common.c   |    4 ++--
 arch/arm64/kernel/traps.c          |   16 ++++++++++------
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -47,5 +47,6 @@ void bad_el0_sync(struct pt_regs *regs,
 void do_cp15instr(unsigned int esr, struct pt_regs *regs);
 void do_el0_svc(struct pt_regs *regs);
 void do_el0_svc_compat(struct pt_regs *regs);
-void do_ptrauth_fault(struct pt_regs *regs, unsigned int esr);
+void do_el0_fpac(struct pt_regs *regs, unsigned long esr);
+void do_el1_fpac(struct pt_regs *regs, unsigned long esr);
 #endif	/* __ASM_EXCEPTION_H */
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -187,7 +187,7 @@ static void noinstr el1_fpac(struct pt_r
 {
 	enter_from_kernel_mode(regs);
 	local_daif_inherit(regs);
-	do_ptrauth_fault(regs, esr);
+	do_el1_fpac(regs, esr);
 	local_daif_mask();
 	exit_to_kernel_mode(regs);
 }
@@ -357,7 +357,7 @@ static void noinstr el0_fpac(struct pt_r
 {
 	enter_from_user_mode();
 	local_daif_restore(DAIF_PROCCTX);
-	do_ptrauth_fault(regs, esr);
+	do_el0_fpac(regs, esr);
 }
 
 asmlinkage void noinstr el0_sync_handler(struct pt_regs *regs)
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -418,16 +418,20 @@ void do_bti(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_bti);
 
-void do_ptrauth_fault(struct pt_regs *regs, unsigned int esr)
+void do_el0_fpac(struct pt_regs *regs, unsigned long esr)
+{
+	force_signal_inject(SIGILL, ILL_ILLOPN, regs->pc, esr);
+}
+
+void do_el1_fpac(struct pt_regs *regs, unsigned long esr)
 {
 	/*
-	 * Unexpected FPAC exception or pointer authentication failure in
-	 * the kernel: kill the task before it does any more harm.
+	 * Unexpected FPAC exception in the kernel: kill the task before it
+	 * does any more harm.
 	 */
-	BUG_ON(!user_mode(regs));
-	force_signal_inject(SIGILL, ILL_ILLOPN, regs->pc, esr);
+	die("Oops - FPAC", regs, esr);
 }
-NOKPROBE_SYMBOL(do_ptrauth_fault);
+NOKPROBE_SYMBOL(do_el1_fpac);
 
 #define __user_cache_maint(insn, address, res)			\
 	if (address >= user_addr_max()) {			\


