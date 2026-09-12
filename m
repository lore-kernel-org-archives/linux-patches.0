Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57358472091;
	Sat, 12 Sep 2026 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232433; cv=none; b=gDGh9rkUqKGoSt7yXZU/C0JWWELl1krlxy/KS/IZrRLE73qO6LriuuJJnbWZZqNum3nGPLeoPoFsy7LQ9sy/U31bzHyEWRAmbk5Nv9egEAgTNjl/KY+zxQ/zT0d3eMH+3XKM82k8y8XpL3ElEun+7bEWphk86YWqYjR/7fg3G4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232433; c=relaxed/simple;
	bh=SITR3PK/YU5piWweb9LjkYPFSdhvALVxHIOVoyNNKkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBrFm58PPTjiT6m4RjA4CrD5DeIJnODMYdDDIN8d7xTI7VOCE9fbHg90pnB251MZiQYPXV3bVOyBg1iUzV9x1ceME+WPZBiflLsI1hgaJLVR/HsU+ijMOVO8cb5RVPS1o+WMu7EApjBDCiLoeK1uAnVKDtQhV5G3OOGAXM78qj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnsyVN2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnsyVN2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752151F000FF;
	Sat, 12 Sep 2026 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232432;
	bh=bNMVbbvKkTvHs9Z1Wj0nUMtf+dBFRvpczQCZ6xEe5DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnsyVN2MdvNE8+WawRBqF7e2nZnjlvtTO70ptD5C8pLHc9SE22Qu0yZjE96LNPQBV
	 PZNCpuAl+IPyLS/NR41H+VYDExblREMeEqEId1sJETTqFHDeUQGXQ2+pxeh8rnhDo8
	 DUm7CJDeih81gWM6rLX5sEGeO1Zk5fep+cFZ4IT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 010/935] x86/insn-eval: Move assign_register() out of KVM as insn_assign_reg()
Date: Sat, 12 Sep 2026 08:50:40 +0200
Message-ID: <20260912065527.077793797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 1fe104b048d77d6cb25bd938e6a67450fb50e61d upstream.

KVM's instruction emulator has a small helper, assign_register(), that
writes a value into a register following the x86 rules for writes to
general-purpose registers: an 8- or 16-bit write leaves the rest of the
register untouched, a 32-bit write zero-extends the result to 64 bits,
and a 64-bit write replaces the whole register.

The TDX guest #VE handler needs the same logic for port I/O emulation
to get 32-bit zero-extension right.  Rather than add a third copy of
the same switch, move the helper verbatim to <asm/insn-eval.h>, rename
it to insn_assign_reg(), and route KVM's callers through it.

Add <asm/insn.h> to the header's includes so it builds standalone in
callers that have not pulled it in transitively.

No functional change.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260713133753.223947-3-kirill@shutemov.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn-eval.h |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/emulate.c           |   26 ++++----------------------
 2 files changed, 40 insertions(+), 22 deletions(-)

--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <asm/insn.h>
 #include <asm/ptrace.h>
 
 #define INSN_CODE_SEG_ADDR_SZ(params) ((params >> 4) & 0xf)
@@ -31,4 +32,39 @@ int insn_fetch_from_user_inatomic(struct
 bool insn_decode_from_regs(struct insn *insn, struct pt_regs *regs,
 			   unsigned char buf[MAX_INSN_SIZE], int buf_size);
 
+/*
+ * Write @val into *@reg following the x86 rules for writes to
+ * general-purpose registers (Intel SDM Vol. 1, "General-Purpose
+ * Registers in 64-Bit Mode"): an 8- or 16-bit write leaves the rest of
+ * the register untouched, a 32-bit write zero-extends the result into
+ * the upper 32 bits, and a 64-bit write replaces the whole register.
+ *
+ * @bytes is the width of the write, not a property of the instruction:
+ * an instruction that, say, sign-extends a 32-bit immediate into a
+ * 64-bit register does a 64-bit write here.
+ *
+ * @reg need not be 8-byte aligned: KVM's instruction emulator offsets
+ * the pointer by one byte to address the high-byte registers (AH, CH,
+ * DH, BH).  Use narrow stores for the sub-word cases so the access
+ * width matches @bytes and the adjacent bytes are left alone.
+ */
+static inline void insn_assign_reg(unsigned long *reg, u64 val, int bytes)
+{
+	switch (bytes) {
+	case 1:
+		*(u8 *)reg = (u8)val;
+		break;
+	case 2:
+		*(u16 *)reg = (u16)val;
+		break;
+	case 4:
+		/* A 32-bit write zero-extends into the upper 32 bits. */
+		*reg = (u32)val;
+		break;
+	case 8:
+		*reg = val;
+		break;
+	}
+}
+
 #endif /* _ASM_X86_INSN_EVAL_H */
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -23,6 +23,7 @@
 #include "kvm_emulate.h"
 #include <linux/stringify.h>
 #include <asm/debugreg.h>
+#include <asm/insn-eval.h>
 #include <asm/nospec-branch.h>
 
 #include "x86.h"
@@ -525,25 +526,6 @@ static void assign_masked(ulong *dest, u
 	*dest = (*dest & ~mask) | (src & mask);
 }
 
-static void assign_register(unsigned long *reg, u64 val, int bytes)
-{
-	/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
-	switch (bytes) {
-	case 1:
-		*(u8 *)reg = (u8)val;
-		break;
-	case 2:
-		*(u16 *)reg = (u16)val;
-		break;
-	case 4:
-		*reg = (u32)val;
-		break;	/* 64b: zero-extend */
-	case 8:
-		*reg = val;
-		break;
-	}
-}
-
 static inline unsigned long ad_mask(struct x86_emulate_ctxt *ctxt)
 {
 	return (1UL << (ctxt->ad_bytes << 3)) - 1;
@@ -591,7 +573,7 @@ register_address_increment(struct x86_em
 {
 	ulong *preg = reg_rmw(ctxt, reg);
 
-	assign_register(preg, *preg + inc, ctxt->ad_bytes);
+	insn_assign_reg(preg, *preg + inc, ctxt->ad_bytes);
 }
 
 static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
@@ -1781,7 +1763,7 @@ static int load_segment_descriptor(struc
 
 static void write_register_operand(struct operand *op)
 {
-	return assign_register(op->addr.reg, op->val, op->bytes);
+	return insn_assign_reg(op->addr.reg, op->val, op->bytes);
 }
 
 static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
@@ -2015,7 +1997,7 @@ static int em_popa(struct x86_emulate_ct
 		rc = emulate_pop(ctxt, &val, ctxt->op_bytes);
 		if (rc != X86EMUL_CONTINUE)
 			break;
-		assign_register(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
+		insn_assign_reg(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
 		--reg;
 	}
 	return rc;


