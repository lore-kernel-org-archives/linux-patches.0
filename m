Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD01168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6TXYmEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA54C433C8;
	Mon, 23 Oct 2023 11:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061592;
	bh=Wt7yuTHzsfpxmvi/8Cfo8+/zF+I6jwp73ld2tuPqIx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6TXYmEnxQqta2+5dYCFPNKUKoHyV2RFYmvgpU9KPOuWpWGScNyq/HlRmZQSMOm7q
	 pt3IQE19SGl5Qc4JLzv5z52jh9luCwKZrJUqzmMJtIU93GXgOlBmNJkzUrA8niIvfg
	 D6v9CZ7Y0StFlgSucDLpYi/rLD0V6a9MR7dRHaSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 072/202] arm64: rework EL0 MRS emulation
Date: Mon, 23 Oct 2023 12:56:19 +0200
Message-ID: <20231023104828.647951430@linuxfoundation.org>
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

commit f5962add74b61f8ae31c6311f75ca35d7e1d2d8f upstream.

On CPUs without FEAT_IDST, ID register emulation is slower than it needs
to be, as all threads contend for the same lock to perform the
emulation. This patch reworks the emulation to avoid this unnecessary
contention.

On CPUs with FEAT_IDST (which is mandatory from ARMv8.4 onwards), EL0
accesses to ID registers result in a SYS trap, and emulation of these is
handled with a sys64_hook. These hooks are statically allocated, and no
locking is required to iterate through the hooks and perform the
emulation, allowing emulation to occur in parallel with no contention.

On CPUs without FEAT_IDST, EL0 accesses to ID registers result in an
UNDEFINED exception, and emulation of these accesses is handled with an
undef_hook. When an EL0 MRS instruction is trapped to EL1, the kernel
finds the relevant handler by iterating through all of the undef_hooks,
requiring undef_lock to be held during this lookup.

This locking is only required to safely traverse the list of undef_hooks
(as it can be concurrently modified), and the actual emulation of the
MRS does not require any mutual exclusion. This locking is an
unfortunate bottleneck, especially given that MRS emulation is enabled
unconditionally and is never disabled.

This patch reworks the non-FEAT_IDST MRS emulation logic so that it can
be invoked directly from do_el0_undef(). This removes the bottleneck,
allowing MRS traps to be handled entirely in parallel, and is a stepping
stone to making all of the undef_hooks lock-free.

I've tested this in a 64-vCPU VM on a 64-CPU ThunderX2 host, with a
benchmark which spawns a number of threads which each try to read
ID_AA64ISAR0_EL1 1000000 times. This is vastly more contention than will
ever be seen in realistic usage, but clearly demonstrates the removal of
the bottleneck:

  | Threads || Time (seconds)                       |
  |         || Before           || After            |
  |         || Real   | System  || Real   | System  |
  |---------++--------+---------++--------+---------|
  |       1 ||   0.29 |    0.20 ||   0.24 |    0.12 |
  |       2 ||   0.35 |    0.51 ||   0.23 |    0.27 |
  |       4 ||   1.08 |    3.87 ||   0.24 |    0.56 |
  |       8 ||   4.31 |   33.60 ||   0.24 |    1.11 |
  |      16 ||   9.47 |  149.39 ||   0.23 |    2.15 |
  |      32 ||  19.07 |  605.27 ||   0.24 |    4.38 |
  |      64 ||  65.40 | 3609.09 ||   0.33 |   11.27 |

Aside from the speedup, there should be no functional change as a result
of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221019144123.612388-6-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    3 ++-
 arch/arm64/kernel/cpufeature.c      |   23 +++++------------------
 arch/arm64/kernel/traps.c           |    3 +++
 3 files changed, 10 insertions(+), 19 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -759,7 +759,8 @@ static inline bool system_supports_tlb_r
 		cpus_have_const_cap(ARM64_HAS_TLB_RANGE);
 }
 
-extern int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
+int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
+bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
 static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
 {
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2852,35 +2852,22 @@ int do_emulate_mrs(struct pt_regs *regs,
 	return rc;
 }
 
-static int emulate_mrs(struct pt_regs *regs, u32 insn)
+bool try_emulate_mrs(struct pt_regs *regs, u32 insn)
 {
 	u32 sys_reg, rt;
 
+	if (compat_user_mode(regs) || !aarch64_insn_is_mrs(insn))
+		return false;
+
 	/*
 	 * sys_reg values are defined as used in mrs/msr instruction.
 	 * shift the imm value to get the encoding.
 	 */
 	sys_reg = (u32)aarch64_insn_decode_immediate(AARCH64_INSN_IMM_16, insn) << 5;
 	rt = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
-	return do_emulate_mrs(regs, sys_reg, rt);
-}
-
-static struct undef_hook mrs_hook = {
-	.instr_mask = 0xfff00000,
-	.instr_val  = 0xd5300000,
-	.pstate_mask = PSR_AA32_MODE_MASK,
-	.pstate_val = PSR_MODE_EL0t,
-	.fn = emulate_mrs,
-};
-
-static int __init enable_mrs_emulation(void)
-{
-	register_undef_hook(&mrs_hook);
-	return 0;
+	return do_emulate_mrs(regs, sys_reg, rt) == 0;
 }
 
-core_initcall(enable_mrs_emulation);
-
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -408,6 +408,9 @@ void do_el0_undef(struct pt_regs *regs,
 	if (user_insn_read(regs, &insn))
 		goto out_err;
 
+	if (try_emulate_mrs(regs, insn))
+		return;
+
 	if (call_undef_hook(regs, insn) == 0)
 		return;
 


