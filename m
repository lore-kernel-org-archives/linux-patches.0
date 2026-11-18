Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019917;
	b=eGeu0LOKqN3IL0jb7agazsCIBPy5JOwckIfa7uc55zBjNEp6GCzDgysuWN0BgFA7cIWG
	 YrcEjNb7iX2WW9LgsJxKqwn+tEjrNW1s1gG6yMGPfWzj9MlyNjPtqurYg22t1m6cqj9sr
	 OeGgDpKDIkWxFXHyPQD/Csa2wKjKMGn8nM0QQAVV9abXvRPUQSiw3FK3Xvy9tUYB9RAGa
	 gwuelRIdsnDwwzloqhhLICNhp45Sed3t5bDpXt0OSfxc4hJYg0qA9smJovmaqN3GdDX/7
	 HJJqI2BAdxGlcm/Z2SA2PXaWWbPBzd4FC3PGetD8KrKQMZN81zOe8Vllx4a2vaVfvVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQL7NpDVU/sowV/5eg9EzCJj1/e5lvj/6L4U3gADVdo=;
	b=Nw5RQjlkZyRpoILov1iJoE3Xfmu9VMA2zCLjx+LWBrZLNM4qnF9+BuAqxJTlbieH495d
	 cg6mBgychvPTxhTaboglgLBAN2cLWkVuHEyoDvoiMrbFjUytZkJWcJwN4+ufW2FHzlaWr
	 NRT2bIzyd4/VQPY2EAg808vOcnkSG2G2hXTtkfYKZ5X+1gXXYr+hDjz5qafVYM1bLSJdz
	 PPE9D9eX68boYu6538n6i6vAMZpiuTjMiH5rME9e5HreiOYT5buqKpaOn9lU+GCh/0fH/
	 e0sfDGu+AK8RS6jUNO1vcXJJ11AsztxgphK/6E9Aw9GtkqzSzn+MrUPEJG2UTnQ88Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LikliMSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0F6606A31C;
	Wed, 18 Nov 2026 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LikliMSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DF41F000C4;
	Wed, 18 Nov 2026 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019917;
	bh=bQL7NpDVU/sowV/5eg9EzCJj1/e5lvj/6L4U3gADVdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LikliMSEUbNo/r7DHslwpogxLAXEvLw5hyTg2uTbZJ0jS/wvZBDFmgY+CgjB+VSEh
	 tSziV/fdHnU3mPMHCmmtrKWhMEilV0cZ2I9+g637H0wB+aC8ROESr3Bk1p0b/9rkCQ
	 3B0u3BOsaOo+sovZi9JtRTOOK5snM2rhQhfglyP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1766/2651] s390/percpu: Rework to simplify percpu_entry() and percpu_exit()
Date: Wed, 18 Nov 2026 15:50:06 +0100
Message-ID: <20261118150351.013071575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 7849fb83e4cf814710003e4c83e161f97cf7ab1c ]

The percpu code section functionality uses a rather complex method to
figure out if the register, which contains the address of the current
cpu's percpu variable, needs to be adjusted.

If an interrupt happens within a percpu code section (indicated by a
lowcore field), the instruction at the interrupted location is
checked. If it is not a specific AG instruction, the register needs to
be updated. This mechanism needs to take kprobes into account, and
enforces a specific instruction ordering.

Mark Rutland provided a different solution for arm64 [1] which comes
without such limitations, but requires to use one more instruction, and
two more registers. Given that this simplifies percpu_entry() and
percpu_exit() it seems to be worth to go that route.

Change s390 to implement a similar approach. This requires to encode
three register numbers into the "percpu_register" field, which is used
to indicate if a percpu code section is executed.

The used mviy instruction can write only one byte, which allows to
encode only two register numbers. Use a register pair for the inline
assemblies, and only encode the even register number of the register
pair to work around this.

The generated code changes like this for e.g. a simple this_cpu_inc():

Old:

c0 20 00 00 00 00  larl    %r2,c6 <foo+0x6> <-- load address of percpu var
b9 04 00 32        lgr     %r3,%r2          <-- pointless copy of address
eb 03 03 c0 00 52  mviy    960,3            <-- start of percpu code section
                                                - gpr 3 contains percpu var address
e3 30 03 b8 00 08  ag      %r3,952          <-- add percpu offset
eb 01 30 00 00 7a  agsi    0(%r3),1         <-- atomic inc
eb 00 03 c0 00 52  mviy    960,0            <-- end of percpu code section

New:

c0 10 00 00 00 00  larl    %r1,c6 <foo+0x6> <-- load address of percpu var
eb 21 03 c0 00 52  mviy    960,33           <-- start of percpu code section
                                                33 == 0x21:
						- gpr 1 contains percpu var address
						- gpr 2 used for percpu offset
  					        - gpr 2+1 == 3 used for current cpu's percpu var address
e3 20 03 b8 00 04  lg      %r2,952          <-- load percpu offset
41 32 10 00        la      %r3,0(%r2,%r1)   <-- generate current cpu's percpu var address
eb 01 30 00 00 7a  agsi    0(%r3),1         <-- atomic inc
eb 00 03 c0 00 52  mviy    960,0            <-- end of percpu code section

In the above "new" code example 33 (0x21) is used as indicator value to
mark that a percpu code section is executed. This value implies that
registers 2 and 3 will (only) hold the percpu offset and the current
cpu's percpu var address. Those registers will be updated by
percpu_exit() if the process was migrated to a different cpu to contain
the percpu offset and percpu var address of the new cpu.

Note that because of the pointless lgr instruction in the "old" code
example the two code sequences have identical size, and it looks like
only one more register is used. However this is because of suboptimal
gcc code generation.

[1] https://lore.kernel.org/all/20260908151741.394589-1-mark.rutland@arm.com/

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/entry-percpu.h |  71 +++--------
 arch/s390/include/asm/percpu.h       | 177 +++++++++++++++++----------
 arch/s390/kernel/irq.c               |  10 +-
 arch/s390/kernel/nmi.c               |   4 +-
 arch/s390/kernel/traps.c             |   4 +-
 5 files changed, 138 insertions(+), 128 deletions(-)

diff --git a/arch/s390/include/asm/entry-percpu.h b/arch/s390/include/asm/entry-percpu.h
index 89c9e44f6f833..f6f79ec4bee3b 100644
--- a/arch/s390/include/asm/entry-percpu.h
+++ b/arch/s390/include/asm/entry-percpu.h
@@ -2,79 +2,42 @@
 #ifndef ARCH_S390_ENTRY_PERCPU_H
 #define ARCH_S390_ENTRY_PERCPU_H
 
-#include <linux/kprobes.h>
+#include <linux/bitfield.h>
 #include <linux/percpu.h>
 #include <asm/lowcore.h>
 #include <asm/ptrace.h>
-#include <asm/asm-offsets.h>
 
 static __always_inline void percpu_entry(struct pt_regs *regs)
 {
 	struct lowcore *lc = get_lowcore();
 
-	if (user_mode(regs))
-		return;
 	regs->cpu = lc->cpu_nr;
 	regs->percpu_register = lc->percpu_register;
 	lc->percpu_register = 0;
 }
 
-static __always_inline bool percpu_code_check(struct pt_regs *regs)
-{
-	unsigned int insn, disp;
-	struct kprobe *p;
-
-	if (likely(user_mode(regs) || !regs->percpu_register))
-		return false;
-	/*
-	 * Within a percpu code section - check if the percpu base register
-	 * needs to be updated. This is the case if the PSW does not point to
-	 * the ADD instruction within the section.
-	 * - AG %rx,percpu_offset_in_lowcore(%r0,%r0)
-	 * which adds the percpu offset to the percpu base register.
-	 */
-	lockdep_assert_preemption_disabled();
-again:
-	insn = READ_ONCE(*(u16 *)psw_bits(regs->psw).ia);
-	if (unlikely(insn == BREAKPOINT_INSTRUCTION)) {
-		p = get_kprobe((void *)psw_bits(regs->psw).ia);
-		/*
-		 * If the kprobe is concurrently removed on a different CPU
-		 * it might not be found anymore. However text must have
-		 * been restored - try again.
-		 */
-		if (!p)
-			goto again;
-		insn = p->opcode;
-	}
-	if ((insn & 0xff0f) != 0xe300)
-		return true;
-	disp = LC_PERCPU_OFFSET;
-	if (machine_has_relocated_lowcore())
-		disp += LOWCORE_ALT_ADDRESS;
-	insn = (disp & 0xff000) >> 4 | (disp & 0x00fff) << 16 | 0x8;
-	if (*(u32 *)(psw_bits(regs->psw).ia + 2) != insn)
-		return true;
-	return false;
-}
-
-static __always_inline void percpu_exit(struct pt_regs *regs, bool needs_fixup)
+static __always_inline void percpu_exit(struct pt_regs *regs)
 {
+	unsigned char regval, regpcp, regoff, regptr;
 	struct lowcore *lc = get_lowcore();
-	unsigned char reg;
 
-	if (user_mode(regs))
-		return;
-	reg = regs->percpu_register;
-	lc->percpu_register = reg;
-	if (likely(!needs_fixup))
+	if (!regs->percpu_register)
 		return;
-	/* Check if process has been migrated to a different CPU. */
+	regval = regs->percpu_register;
+	lc->percpu_register = regval;
+	/* Migrated to a different CPU? */
 	if (regs->cpu == lc->cpu_nr)
 		return;
-	/* Fixup percpu base register */
-	regs->gprs[reg] -= __per_cpu_offset[regs->cpu];
-	regs->gprs[reg] += lc->percpu_offset;
+	regpcp = FIELD_GET(PCPU_REG_PCP, regval);
+	regoff = FIELD_GET(PCPU_REG_OFF, regval);
+	regptr = regoff + 1;
+	/*
+	 * Update register 'regoff' with the current CPU's percpu offset,
+	 * and recalculate and update current CPU's percpu variable address
+	 * contained in register 'regptr'.
+	 */
+	regs->gprs[regoff] = lc->percpu_offset;
+	regs->gprs[regptr] = regs->gprs[regpcp] + regs->gprs[regoff];
 }
 
 #endif
diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index cd0d7c138d661..b5417e34cc976 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -67,28 +67,32 @@
  * this. The idea is that this_cpu operations based on atomic instructions are
  * guarded with mviy instructions:
  *
- * - The first mviy instruction writes the register number, which contains the
- *   percpu address variable to lowcore. This also indicates that a percpu
- *   code section is executed.
+ * - The first mviy instruction writes the register number of the percpu address
+ *   variable and the even register number of a register pair (which encodes two
+ *   registers: the even register for the percpu offset and the odd register for
+ *   the percpu pointer) to lowcore. This also indicates that a percpu code
+ *   section is executed.
  *
- * - The first mviy instruction following the mviy instruction must be the ag
- *   instruction which adds the percpu offset to the percpu address register.
+ * - The mviy instruction is followed by the lg instruction which loads the
+ *   percpu offset into the even register of the pair and the la instruction
+ *   which adds the percpu offset and the percpu address into the odd register
+ *   of the pair (the percpu pointer register).
  *
  * - Afterwards the atomic percpu operation follows.
  *
  * - Then a second mviy instruction writes a zero to lowcore, which indicates
  *   the end of the percpu code section.
  *
- * - In case of an interrupt/exception/nmi the register number which was
- *   written to lowcore is copied to the exception frame (pt_regs), and a zero
- *   is written to lowcore.
+ * - In case of an interrupt/exception/nmi the encoded register numbers which
+ *   were written to lowcore are copied to the exception frame (pt_regs), and a
+ *   zero is written to lowcore.
  *
  * - On return to the previous context it is checked if a percpu code section
- *   was executed (saved register number not zero), and if the process was
- *   migrated to a different cpu. If the percpu offset was already added to
- *   the percpu address register (instruction address does _not_ point to the
- *   ag instruction) the content of the percpu address register is adjusted so
- *   it points to percpu variable of the new cpu.
+ *   was executed (saved register value not zero), and if the process was
+ *   migrated to a different cpu. The content of the percpu offset register
+ *   (even register of the pair) is reloaded with the current cpu's percpu
+ *   offset and the percpu pointer register (odd register of the pair) is
+ *   recalculated so it points to the percpu variable of the new cpu.
  *
  * Inline assemblies making use of this typically have a code sequence like:
  *
@@ -115,22 +119,53 @@
 #define UNDEF_GR_NUM								\
 	".purgem _GR_NUM\n"
 
+#define PCPU_REG_PCP_SHIFT		0
+#define PCPU_REG_PCP			GENMASK(3, 0)
+#define PCPU_REG_OFF_SHIFT		4
+#define PCPU_REG_OFF			GENMASK(7, 4)
+
 #define __PCPU_MVIY(lcreg, imm)							\
 	ALTERNATIVE("	mviy	" lcreg			"(%%r0)," imm "\n",	\
 		    "	mviy	" lcreg "+" LC_ALT_ADDR "(%%r0)," imm "\n",	\
 		    ALT_FEATURE(MFEATURE_LOWCORE))
 
-#define __PCPU_AG(reg, lcoff)							\
-	ALTERNATIVE("	ag	" reg ", " lcoff		 "(%%r0)\n",	\
-		    "	ag	" reg ", " lcoff "+" LC_ALT_ADDR "(%%r0)\n",	\
+#define __PCPU_LG(regoff, lcoff)						\
+	ALTERNATIVE("	lg	" regoff ", " lcoff		    "(%%r0)\n",	\
+		    "	lg	" regoff ", " lcoff "+" LC_ALT_ADDR "(%%r0)\n",	\
 		    ALT_FEATURE(MFEATURE_LOWCORE))
 
-#define __PCPU_BEGIN(lcreg, lcoff, reg)						\
+#define __PCPU_LA(regptr, regoff, regpcp)					\
+	"	la	" regptr ",0(" regoff "," regpcp ")\n"
+
+#define __PCPU_CALC_REGVAL(regpcp, regoff)					\
+	"(" regpcp " << " __stringify(PCPU_REG_PCP_SHIFT) ") |"			\
+	"(" regoff " << " __stringify(PCPU_REG_OFF_SHIFT) ")"
+
+#define __PCPU_CHECK_REGS(regpcp, regoff, regptr)				\
+	".if " regoff " & 1\n"							\
+	"	.error \"Percpu offset register must be even\"\n"		\
+	".endif\n"								\
+	".if (" regpcp " == 0) || (" regoff " == 0)\n"				\
+	"	.error \"Percpu address and offset register must be non-zero\"\n"\
+	".endif\n"								\
+	".if " regptr " != " regoff " + 1\n"					\
+	"	.error \"Percpu pointer and offset register must be a pair\"\n" \
+	".endif\n"								\
+	".if (" regpcp " == " regoff ") || (" regpcp " == " regptr ")\n"	\
+	"	.error \"Percpu registers must be distinct\"\n"			\
+	".endif\n"
+
+#define __PCPU_BEGIN(lcreg, lcoff, regpcp, regoff, regptr)			\
 	DEFINE_GR_NUM								\
-	"_GR_NUM .Lreg, " reg "\n"						\
+	"_GR_NUM .Lregpcp, " regpcp "\n"					\
+	"_GR_NUM .Lregoff, " regoff "\n"					\
+	"_GR_NUM .Lregptr, " regptr "\n"					\
 	UNDEF_GR_NUM								\
-	__PCPU_MVIY(lcreg, ".Lreg")						\
-	__PCPU_AG(reg, lcoff)
+	__PCPU_CHECK_REGS(".Lregpcp", ".Lregoff", ".Lregptr")			\
+	".set .Lregval, " __PCPU_CALC_REGVAL(".Lregpcp", ".Lregoff") "\n"	\
+	__PCPU_MVIY(lcreg, ".Lregval")						\
+	__PCPU_LG(regoff, lcoff)						\
+	__PCPU_LA(regptr, regoff, regpcp)
 
 #define __PCPU_END(lcreg)							\
 	__PCPU_MVIY(lcreg, "0")
@@ -151,6 +186,7 @@
 #define arch_this_cpu_add(pcp, val, op1, op2, szcast)				\
 do {										\
 	typedef typeof(pcp) pcp_op_T__;						\
+	union register_pair rp__;						\
 	pcp_op_T__ val__ = (val);						\
 	pcp_op_T__ old__, *ptr__;						\
 										\
@@ -158,25 +194,27 @@ do {										\
 	if (__builtin_constant_p(val__) &&					\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {			\
 		asm volatile(							\
-			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-			op2 "   0(%[ptr__]),%[val__]\n"				\
+			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+				      "%[pair__]","%N[pair__]")			\
+			op2 "   0(%N[pair__]),%[val__]\n"			\
 			__PCPU_END("%[lcreg]")					\
-			: [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
+			: [pair__] "=&a" (rp__.pair), "+m" (*ptr__),		\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
-			: [val__] "i" ((szcast)val__),				\
+			: [val__] "i" ((szcast)val__), [ptr__] "a" (ptr__),	\
 			  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 			  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	} else {								\
 		asm volatile(							\
-			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-			op1 "   %[old__],%[val__],0(%[ptr__])\n"		\
+			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+				     "%[pair__]","%N[pair__]")			\
+			op1 "   %[old__],%[val__],0(%N[pair__])\n"		\
 			__PCPU_END("%[lcreg]")					\
-			: [old__] "=&d" (old__),				\
-			  [ptr__] "+&a" (ptr__),  "+m" (*ptr__),		\
+			: [old__] "=&d" (old__), [pair__] "=&a" (rp__.pair),	\
+			  "+m" (*ptr__),					\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
-			: [val__] "d" (val__),					\
+			: [val__] "d" (val__), [ptr__] "a" (ptr__),		\
 			  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 			  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -190,18 +228,20 @@ do {										\
 #define arch_this_cpu_add_return(pcp, val, op)				\
 ({									\
 	typedef typeof(pcp) pcp_op_T__; 				\
+	union register_pair rp__;					\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		op "	%[old__],%[val__],0(%[ptr__])\n"		\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			     "%[pair__]","%N[pair__]")			\
+		op "	%[old__],%[val__],0(%N[pair__])\n"		\
 		__PCPU_END("%[lcreg]")					\
-		: [old__] "=&d" (old__),				\
-		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
+		: [old__] "=&d" (old__), [pair__] "=&a" (rp__.pair),	\
+		  "+m" (*ptr__),					\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [val__] "d" (val__),					\
+		: [val__] "d" (val__), [ptr__] "a" (ptr__),		\
 		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -215,18 +255,20 @@ do {										\
 #define arch_this_cpu_to_op(pcp, val, op)				\
 do {									\
 	typedef typeof(pcp) pcp_op_T__; 				\
+	union register_pair rp__;					\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		op "    %[old__],%[val__],0(%[ptr__])\n"		\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			     "%[pair__]","%N[pair__]")			\
+		op "    %[old__],%[val__],0(%N[pair__])\n"		\
 		__PCPU_END("%[lcreg]")					\
-		: [old__] "=&d" (old__),				\
-		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
+		: [old__] "=&d" (old__), [pair__] "=&a" (rp__.pair),	\
+		  "+m" (*ptr__),					\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [val__] "d" (val__),					\
+		: [val__] "d" (val__), [ptr__] "a" (ptr__),		\
 		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -243,17 +285,20 @@ do {									\
 #define arch_this_cpu_read(pcp, op)					\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
+	union register_pair rp__;					\
 	unsigned long res__;						\
 	pcp_op_T__ *ptr__;						\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		op "	%[res__],0(%[ptr__])\n"				\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			      "%[pair__]","%N[pair__]")			\
+		op "	%[res__],0(%N[pair__])\n"			\
 		__PCPU_END("%[lcreg]")					\
-		: [res__] "=&d" (res__), [ptr__] "+&a" (ptr__),		\
+		: [res__] "=&d" (res__), [pair__] "=&a" (rp__.pair),	\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		: [ptr__] "a" (ptr__),					\
+		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (*ptr__),						\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -269,16 +314,18 @@ do {									\
 #define arch_this_cpu_write(pcp, val, op)				\
 do {									\
 	typedef typeof(pcp) pcp_op_T__;					\
+	union register_pair rp__;					\
 	pcp_op_T__ *ptr__, val__ = (val);				\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		op "    %[val__],0(%[ptr__])\n"				\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			      "%[pair__]","%N[pair__]")			\
+		op "    %[val__],0(%N[pair__])\n"			\
 		__PCPU_END("%[lcreg]")					\
-		: [ptr__] "+&a" (ptr__), "=m" (*ptr__),			\
+		: [pair__] "=&a" (rp__.pair), "=m" (*ptr__),		\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [val__] "d" (val__),					\
+		: [val__] "d" (val__), [ptr__] "a" (ptr__),		\
 		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -306,17 +353,19 @@ do {									\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ old__ = (oval), new__ = (nval);			\
+	union register_pair rp__;					\
 	pcp_op_T__ *ptr__;						\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		op "	%[old__],%[new__],0(%[ptr__])\n"		\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			     "%[pair__]","%N[pair__]")			\
+		op "	%[old__],%[new__],0(%N[pair__])\n"		\
 		__PCPU_END("%[lcreg]")					\
-		: [old__] "+&d" (old__),				\
-		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
+		: [old__] "+&d" (old__), [pair__] "=&a" (rp__.pair),	\
+		  "+m" (*ptr__),					\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [new__] "d" (new__),					\
+		: [new__] "d" (new__), [ptr__] "a" (ptr__),		\
 		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -335,17 +384,19 @@ do {									\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
 	u128 old__ = (oval), new__ = (nval);				\
+	union register_pair rp__;					\
 	pcp_op_T__ *ptr__;						\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		"	cdsg	%[old__],%[new__],0(%[ptr__])\n"	\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			     "%[pair__]","%N[pair__]")			\
+		"	cdsg	%[old__],%[new__],0(%N[pair__])\n"	\
 		__PCPU_END("%[lcreg]")					\
-		: [old__] "+&d" (old__), [ptr__] "+&a" (ptr__),		\
+		: [old__] "+&d" (old__), [pair__] "=&a" (rp__.pair),	\
 		  "+m" (*ptr__),					\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [new__] "d" (new__),					\
+		: [new__] "d" (new__), [ptr__] "a" (ptr__),		\
 		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
@@ -368,19 +419,21 @@ do {									\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ old__, new__ = (nval);				\
+	union register_pair rp__;					\
 	pcp_op_T__ *ptr__;						\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
-		"	" ldop "	%[old__],0(%[ptr__])\n"		\
-		"0:	" csop "	%[old__],%[new__],0(%[ptr__])\n"\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
+			     "%[pair__]","%N[pair__]")			\
+		"	" ldop "	%[old__],0(%N[pair__])\n"	\
+		"0:	" csop "	%[old__],%[new__],0(%N[pair__])\n"\
 		"	jnz	0b\n"					\
 		__PCPU_END("%[lcreg]")					\
-		: [old__] "=&d" (old__),				\
-		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
+		: [old__] "=&d" (old__), [pair__] "=&a" (rp__.pair),	\
+		  "+m" (*ptr__),					\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [new__] "d" (new__),					\
+		: [new__] "d" (new__), [ptr__] "a" (ptr__),		\
 		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
 		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index c923496aa7b48..8f21bea349a65 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -144,9 +144,9 @@ static int irq_pending(struct pt_regs *regs)
 
 void noinstr do_io_irq(struct pt_regs *regs)
 {
-	bool from_idle, percpu_needs_fixup;
 	struct pt_regs *old_regs;
 	irqentry_state_t state;
+	bool from_idle;
 
 	percpu_entry(regs);
 	state = irqentry_enter(regs);
@@ -174,21 +174,20 @@ void noinstr do_io_irq(struct pt_regs *regs)
 			do_irq_async(regs, IO_INTERRUPT);
 	} while (machine_is_lpar() && irq_pending(regs));
 
-	percpu_needs_fixup = percpu_code_check(regs);
 	irq_exit_rcu();
 	set_irq_regs(old_regs);
 	irqentry_exit(regs, state);
 
 	if (from_idle)
 		regs->psw.mask &= ~(PSW_MASK_EXT | PSW_MASK_IO | PSW_MASK_WAIT);
-	percpu_exit(regs, percpu_needs_fixup);
+	percpu_exit(regs);
 }
 
 void noinstr do_ext_irq(struct pt_regs *regs)
 {
-	bool from_idle, percpu_needs_fixup;
 	struct pt_regs *old_regs;
 	irqentry_state_t state;
+	bool from_idle;
 
 	percpu_entry(regs);
 	state = irqentry_enter(regs);
@@ -214,14 +213,13 @@ void noinstr do_ext_irq(struct pt_regs *regs)
 
 	do_irq_async(regs, EXT_INTERRUPT);
 
-	percpu_needs_fixup = percpu_code_check(regs);
 	irq_exit_rcu();
 	set_irq_regs(old_regs);
 	irqentry_exit(regs, state);
 
 	if (from_idle)
 		regs->psw.mask &= ~(PSW_MASK_EXT | PSW_MASK_IO | PSW_MASK_WAIT);
-	percpu_exit(regs, percpu_needs_fixup);
+	percpu_exit(regs);
 }
 
 static void show_msi_interrupt(struct seq_file *p, int irq)
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 17297a8b63d95..56a15edc65d71 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -361,7 +361,6 @@ NOKPROBE_SYMBOL(s390_backup_mcck_info);
  */
 void notrace s390_do_machine_check(struct pt_regs *regs)
 {
-	bool percpu_needs_fixup;
 	static int ipd_count;
 	static DEFINE_SPINLOCK(ipd_lock);
 	static unsigned long long last_ipd;
@@ -495,9 +494,8 @@ void notrace s390_do_machine_check(struct pt_regs *regs)
 	if (mcck_pending)
 		schedule_mcck_handler();
 
-	percpu_needs_fixup = percpu_code_check(regs);
 	irqentry_nmi_exit(regs, irq_state);
-	percpu_exit(regs, percpu_needs_fixup);
+	percpu_exit(regs);
 }
 NOKPROBE_SYMBOL(s390_do_machine_check);
 
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index b6ba4465f59de..dd051046170bb 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -338,7 +338,6 @@ static void (*pgm_check_table[128])(struct pt_regs *regs);
 void noinstr __do_pgm_check(struct pt_regs *regs, unsigned long flags)
 {
 	struct lowcore *lc = get_lowcore();
-	bool percpu_needs_fixup;
 	irqentry_state_t state;
 	struct pgm_stat *stat;
 	unsigned int trapnr;
@@ -400,9 +399,8 @@ void noinstr __do_pgm_check(struct pt_regs *regs, unsigned long flags)
 		pgm_check_table[trapnr](regs);
 out:
 	local_irq_disable();
-	percpu_needs_fixup = percpu_code_check(regs);
 	irqentry_exit(regs, state);
-	percpu_exit(regs, percpu_needs_fixup);
+	percpu_exit(regs);
 }
 
 static int pgm_check_stat_show(struct seq_file *p, void *v)
-- 
2.53.0



