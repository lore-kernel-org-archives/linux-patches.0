Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4954278161;
	Sat, 12 Sep 2026 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226829; cv=none; b=h8upxI20FnrR7xE8cHr6SSeyOknPaK435H8T+fD0C165s29AU8KFUP2TUvA9QS3LJ6pNBbPR81dnEXsWL7aZ0TLMDyKYnl9+uRzRFG9YwsSaT1HTAV6Br5ESmf+rbWoVGBaxkMQAiOBSvb5FyLap9zPKT28qt5bcFPFC7w+O5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226829; c=relaxed/simple;
	bh=3dwHToInXiIWpPjEi7qa4FWF4uGWwvgLFhYR31aMVWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/JWvP1RVwBPJi9TN0KVyMihe9QO0T7UzFe9sx9IyciWPEhaEy/2y9F0hZiow3arm7jHLnwR+W4Vw1CLW8t8rO3AmnGp89UzOz6zVxdYDm/oe08KxdFMvZvPCZx9J9HETbc1mmwvHNs3tdU6zCfHb/QiDI1+wE3Jbvx3BEmgpto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwcrCLO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwcrCLO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69C21F000FF;
	Sat, 12 Sep 2026 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226828;
	bh=lZvAkX2a593ay1BNwnyPQoGhqA1GTD6s+uLbEZV+5HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwcrCLO/L/kcY8FbWG2cH6OoxL0LdGf/lnq0czHzV0L7eivQek92oMeHC/E+mppe+
	 Kdal252o4KA0kAOqxOK+UITEQRHQZFt3WymKKTupwT/ZRwZ3/5t00hGzsG3POlww13
	 T/TEmZ9WsK0VBpr8ZM8FjoxDgCfyZvmql0qI2qrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0014/1191] x86/insn-eval: Move assign_register() out of KVM as insn_assign_reg()
Date: Sat, 12 Sep 2026 08:45:42 +0200
Message-ID: <20260912065548.428382585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,4 +45,39 @@ enum mmio_type {
 
 enum mmio_type insn_decode_mmio(struct insn *insn, int *bytes);
 
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
 #include <asm/ibt.h>
 
@@ -519,25 +520,6 @@ static void assign_masked(ulong *dest, u
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
@@ -585,7 +567,7 @@ register_address_increment(struct x86_em
 {
 	ulong *preg = reg_rmw(ctxt, reg);
 
-	assign_register(preg, *preg + inc, ctxt->ad_bytes);
+	insn_assign_reg(preg, *preg + inc, ctxt->ad_bytes);
 }
 
 static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
@@ -1800,7 +1782,7 @@ static int load_segment_descriptor(struc
 
 static void write_register_operand(struct operand *op)
 {
-	return assign_register(op->addr.reg, op->val, op->bytes);
+	return insn_assign_reg(op->addr.reg, op->val, op->bytes);
 }
 
 static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
@@ -2034,7 +2016,7 @@ static int em_popa(struct x86_emulate_ct
 		rc = emulate_pop(ctxt, &val, ctxt->op_bytes);
 		if (rc != X86EMUL_CONTINUE)
 			break;
-		assign_register(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
+		insn_assign_reg(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
 		--reg;
 	}
 	return rc;


