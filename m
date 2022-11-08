Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3F615CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF2FC433D6;
	Tue,  8 Nov 2022 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916343;
	bh=kCralLE13pmSkoQEfYL4xMsoITVA1sOIb0Prt9G9yfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfpaJm4inXe92Qka5cuokOztbkELXp9VxXotN3LtpCcsUX8e8laE+1c3cbzDiauT4
	 psgFYZ7cJn1FwGpdmsq/DOD96k0PtbCBbJLhXOr8HBzcujkkr5rhtjBpJzVQGeS0KH
	 MJ8tiu9U14XbfeNWQQ71kalEDcyhOX8suymHwRlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 134/144] KVM: x86: emulator: introduce emulator_recalc_and_set_mode
Date: Tue,  8 Nov 2022 14:40:11 +0100
Message-Id: <20221108133350.958473636@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

commit d087e0f79fa0dd336a9a6b2f79ec23120f5eff73 upstream.

Some instructions update the cpu execution mode, which needs to update the
emulation mode.

Extract this code, and make assign_eip_far use it.

assign_eip_far now reads CS, instead of getting it via a parameter,
which is ok, because callers always assign CS to the same value
before calling this function.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-12-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   85 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 28 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -795,8 +795,7 @@ static int linearize(struct x86_emulate_
 			   ctxt->mode, linear);
 }
 
-static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
-			     enum x86emul_mode mode)
+static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
 	ulong linear;
 	int rc;
@@ -806,41 +805,71 @@ static inline int assign_eip(struct x86_
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, mode, &linear);
+	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
 }
 
+static inline int emulator_recalc_and_set_mode(struct x86_emulate_ctxt *ctxt)
+{
+	u64 efer;
+	struct desc_struct cs;
+	u16 selector;
+	u32 base3;
+
+	ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
+
+	if (!(ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE)) {
+		/* Real mode. cpu must not have long mode active */
+		if (efer & EFER_LMA)
+			return X86EMUL_UNHANDLEABLE;
+		ctxt->mode = X86EMUL_MODE_REAL;
+		return X86EMUL_CONTINUE;
+	}
+
+	if (ctxt->eflags & X86_EFLAGS_VM) {
+		/* Protected/VM86 mode. cpu must not have long mode active */
+		if (efer & EFER_LMA)
+			return X86EMUL_UNHANDLEABLE;
+		ctxt->mode = X86EMUL_MODE_VM86;
+		return X86EMUL_CONTINUE;
+	}
+
+	if (!ctxt->ops->get_segment(ctxt, &selector, &cs, &base3, VCPU_SREG_CS))
+		return X86EMUL_UNHANDLEABLE;
+
+	if (efer & EFER_LMA) {
+		if (cs.l) {
+			/* Proper long mode */
+			ctxt->mode = X86EMUL_MODE_PROT64;
+		} else if (cs.d) {
+			/* 32 bit compatibility mode*/
+			ctxt->mode = X86EMUL_MODE_PROT32;
+		} else {
+			ctxt->mode = X86EMUL_MODE_PROT16;
+		}
+	} else {
+		/* Legacy 32 bit / 16 bit mode */
+		ctxt->mode = cs.d ? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
+	}
+
+	return X86EMUL_CONTINUE;
+}
+
 static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
-	return assign_eip(ctxt, dst, ctxt->mode);
+	return assign_eip(ctxt, dst);
 }
 
-static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
-			  const struct desc_struct *cs_desc)
+static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
-	enum x86emul_mode mode = ctxt->mode;
-	int rc;
+	int rc = emulator_recalc_and_set_mode(ctxt);
 
-#ifdef CONFIG_X86_64
-	if (ctxt->mode >= X86EMUL_MODE_PROT16) {
-		if (cs_desc->l) {
-			u64 efer = 0;
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
 
-			ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-			if (efer & EFER_LMA)
-				mode = X86EMUL_MODE_PROT64;
-		} else
-			mode = X86EMUL_MODE_PROT32; /* temporary value */
-	}
-#endif
-	if (mode == X86EMUL_MODE_PROT16 || mode == X86EMUL_MODE_PROT32)
-		mode = cs_desc->d ? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
-	rc = assign_eip(ctxt, dst, mode);
-	if (rc == X86EMUL_CONTINUE)
-		ctxt->mode = mode;
-	return rc;
+	return assign_eip(ctxt, dst);
 }
 
 static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
@@ -2153,7 +2182,7 @@ static int em_jmp_far(struct x86_emulate
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2234,7 +2263,7 @@ static int em_ret_far(struct x86_emulate
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	rc = assign_eip_far(ctxt, eip, &new_desc);
+	rc = assign_eip_far(ctxt, eip);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -3458,7 +3487,7 @@ static int em_call_far(struct x86_emulat
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	if (rc != X86EMUL_CONTINUE)
 		goto fail;
 


