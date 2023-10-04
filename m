Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEC81D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dh8xAUMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60712C433CB;
	Wed,  4 Oct 2023 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443924;
	bh=GQIb728sshTnZThF3+dNlrtOtH9sA3+oQLWFLfqn4j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dh8xAUMTKtMW8KzUDxY3LHNuyMTsW/hF18WCYKy6D5QyTrzvvRJM7JfROKJGVWVKR
	 D5RYg/zRNF8JNE1jMxkHL7zlIc9Okh/74dzTDhWUf2t+4O8vQSlfw1ke9QI7pc5Nf6
	 YSt7Cb/VK31Y+Hp8Kh1P2maYsaavIu9897Xq+AnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 069/321] powerpc/dexcr: Move HASHCHK trap handler
Date: Wed,  4 Oct 2023 19:53:34 +0200
Message-ID: <20231004175232.399032571@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit c3f4309693758b13fbb34b3741c2e2801ad28769 ]

Syzkaller reported a sleep in atomic context bug relating to the HASHCHK
handler logic:

  BUG: sleeping function called from invalid context at arch/powerpc/kernel/traps.c:1518
  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 25040, name: syz-executor
  preempt_count: 0, expected: 0
  RCU nest depth: 0, expected: 0
  no locks held by syz-executor/25040.
  irq event stamp: 34
  hardirqs last  enabled at (33): [<c000000000048b38>] prep_irq_for_enabled_exit arch/powerpc/kernel/interrupt.c:56 [inline]
  hardirqs last  enabled at (33): [<c000000000048b38>] interrupt_exit_user_prepare_main+0x148/0x600 arch/powerpc/kernel/interrupt.c:230
  hardirqs last disabled at (34): [<c00000000003e6a4>] interrupt_enter_prepare+0x144/0x4f0 arch/powerpc/include/asm/interrupt.h:176
  softirqs last  enabled at (0): [<c000000000281954>] copy_process+0x16e4/0x4750 kernel/fork.c:2436
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  CPU: 15 PID: 25040 Comm: syz-executor Not tainted 6.5.0-rc5-00001-g3ccdff6bb06d #3
  Hardware name: IBM,9105-22A POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1040.00 (NL1040_021) hv:phyp pSeries
  Call Trace:
  [c0000000a8247ce0] [c00000000032b0e4] __might_resched+0x3b4/0x400 kernel/sched/core.c:10189
  [c0000000a8247d80] [c0000000008c7dc8] __might_fault+0xa8/0x170 mm/memory.c:5853
  [c0000000a8247dc0] [c00000000004160c] do_program_check+0x32c/0xb20 arch/powerpc/kernel/traps.c:1518
  [c0000000a8247e50] [c000000000009b2c] program_check_common_virt+0x3bc/0x3c0

To determine if a trap was caused by a HASHCHK instruction, we inspect
the user instruction that triggered the trap. However this may sleep
if the page needs to be faulted in (get_user_instr() reaches
__get_user(), which calls might_fault() and triggers the bug message).

Move the HASHCHK handler logic to after we allow IRQs, which is fine
because we are only interested in HASHCHK if it's a user space trap.

Fixes: 5bcba4e6c13f ("powerpc/dexcr: Handle hashchk exception")
Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230915034604.45393-1-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 56 ++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 7ef147e2a20d7..109b93874df92 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1512,23 +1512,11 @@ static void do_program_check(struct pt_regs *regs)
 			return;
 		}
 
-		if (cpu_has_feature(CPU_FTR_DEXCR_NPHIE) && user_mode(regs)) {
-			ppc_inst_t insn;
-
-			if (get_user_instr(insn, (void __user *)regs->nip)) {
-				_exception(SIGSEGV, regs, SEGV_MAPERR, regs->nip);
-				return;
-			}
-
-			if (ppc_inst_primary_opcode(insn) == 31 &&
-			    get_xop(ppc_inst_val(insn)) == OP_31_XOP_HASHCHK) {
-				_exception(SIGILL, regs, ILL_ILLOPN, regs->nip);
-				return;
-			}
+		/* User mode considers other cases after enabling IRQs */
+		if (!user_mode(regs)) {
+			_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
+			return;
 		}
-
-		_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
-		return;
 	}
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (reason & REASON_TM) {
@@ -1561,16 +1549,44 @@ static void do_program_check(struct pt_regs *regs)
 
 	/*
 	 * If we took the program check in the kernel skip down to sending a
-	 * SIGILL. The subsequent cases all relate to emulating instructions
-	 * which we should only do for userspace. We also do not want to enable
-	 * interrupts for kernel faults because that might lead to further
-	 * faults, and loose the context of the original exception.
+	 * SIGILL. The subsequent cases all relate to user space, such as
+	 * emulating instructions which we should only do for user space. We
+	 * also do not want to enable interrupts for kernel faults because that
+	 * might lead to further faults, and loose the context of the original
+	 * exception.
 	 */
 	if (!user_mode(regs))
 		goto sigill;
 
 	interrupt_cond_local_irq_enable(regs);
 
+	/*
+	 * (reason & REASON_TRAP) is mostly handled before enabling IRQs,
+	 * except get_user_instr() can sleep so we cannot reliably inspect the
+	 * current instruction in that context. Now that we know we are
+	 * handling a user space trap and can sleep, we can check if the trap
+	 * was a hashchk failure.
+	 */
+	if (reason & REASON_TRAP) {
+		if (cpu_has_feature(CPU_FTR_DEXCR_NPHIE)) {
+			ppc_inst_t insn;
+
+			if (get_user_instr(insn, (void __user *)regs->nip)) {
+				_exception(SIGSEGV, regs, SEGV_MAPERR, regs->nip);
+				return;
+			}
+
+			if (ppc_inst_primary_opcode(insn) == 31 &&
+			    get_xop(ppc_inst_val(insn)) == OP_31_XOP_HASHCHK) {
+				_exception(SIGILL, regs, ILL_ILLOPN, regs->nip);
+				return;
+			}
+		}
+
+		_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
+		return;
+	}
+
 	/* (reason & REASON_ILLEGAL) would be the obvious thing here,
 	 * but there seems to be a hardware bug on the 405GP (RevD)
 	 * that means ESR is sometimes set incorrectly - either to
-- 
2.40.1



