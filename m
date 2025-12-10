Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0024C3016F3;
	Wed, 10 Dec 2025 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352013; cv=none; b=lXHe0j35Q5T0i+tgUe41Acd+2MIni0WPRx3t9Y/5Crb6IFyy2fETxdCFYJo6pvie5XAySoPV2Gq1FGAU3oz61S7ocNeVbnOx0Ey9UFqlxaJwDvLhObVvtTfZUvrrFL+j95jqVSzOQhDD64nzMEDtWO4pQCLUry2PY/hZ9EVLZdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352013; c=relaxed/simple;
	bh=plBNLf9J0XI30JkOyXwYUNM/jxN2KB2hD5KjSvLrIo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdqVvs9sWowpYEs28oM2Nk1W3FxXhdxld+j8ueQaktveqAsPbIBlo9jZbMRraP/XGuL48iKK2sfH2goih2jegkaV9nHx7Iy9jRM1/5QWO6Eq3276nw5vH8C569LeVimSpivynTKezNJCEvdu+UvorVxkd7xVO7/i9jp2enDO8nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2NfBoZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2NfBoZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B163C4CEF1;
	Wed, 10 Dec 2025 07:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352012;
	bh=plBNLf9J0XI30JkOyXwYUNM/jxN2KB2hD5KjSvLrIo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2NfBoZ3ybJnixZvjSthXOpuaIc+UM0KPvbU5fcjKx9hamKxA4KNJ+pu6Qv/ithv7
	 fdc9rG1fWPg/gxumq7OXxT2nRLh6/CPYOox06ZrRAzVPxS65dmLkduS09TRkVn0wsd
	 dVp6Yivi90r/Oj4ihl9SbjI18VVtkShDJAoQD0iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 09/60] KVM: SVM: Dont skip unrelated instruction if INT3/INTO is replaced
Date: Wed, 10 Dec 2025 16:29:39 +0900
Message-ID: <20251210072948.077073066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

commit 4da3768e1820cf15cced390242d8789aed34f54d upstream.

When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
instruction, discard the exception and retry the instruction if the code
stream is changed (e.g. by a different vCPU) between when the CPU
executes the instruction and when KVM decodes the instruction to get the
next RIP.

As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
INT3/INTO instead of retrying the instruction"), failure to verify that
the correct INTn instruction was decoded can effectively clobber guest
state due to decoding the wrong instruction and thus specifying the
wrong next RIP.

The bug most often manifests as "Oops: int3" panics on static branch
checks in Linux guests.  Enabling or disabling a static branch in Linux
uses the kernel's "text poke" code patching mechanism.  To modify code
while other CPUs may be executing that code, Linux (temporarily)
replaces the first byte of the original instruction with an int3 (opcode
0xcc), then patches in the new code stream except for the first byte,
and finally replaces the int3 with the first byte of the new code
stream.  If a CPU hits the int3, i.e. executes the code while it's being
modified, then the guest kernel must look up the RIP to determine how to
handle the #BP, e.g. by emulating the new instruction.  If the RIP is
incorrect, then this lookup fails and the guest kernel panics.

The bug reproduces almost instantly by hacking the guest kernel to
repeatedly check a static branch[1] while running a drgn script[2] on
the host to constantly swap out the memory containing the guest's TSS.

[1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
[2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b

Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Link: https://patch.msgid.link/1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    9 +++++++++
 arch/x86/kvm/svm/svm.c          |   24 +++++++++++++-----------
 arch/x86/kvm/x86.c              |   21 +++++++++++++++++++++
 3 files changed, 43 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2123,6 +2123,11 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
  *			     the gfn, i.e. retrying the instruction will hit a
  *			     !PRESENT fault, which results in a new shadow page
  *			     and sends KVM back to square one.
+ *
+ * EMULTYPE_SKIP_SOFT_INT - Set in combination with EMULTYPE_SKIP to only skip
+ *                          an instruction if it could generate a given software
+ *                          interrupt, which must be encoded via
+ *                          EMULTYPE_SET_SOFT_INT_VECTOR().
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
@@ -2133,6 +2138,10 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_PF		    (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
+#define EMULTYPE_SKIP_SOFT_INT	    (1 << 9)
+
+#define EMULTYPE_SET_SOFT_INT_VECTOR(v)	((u32)((v) & 0xff) << 16)
+#define EMULTYPE_GET_SOFT_INT_VECTOR(e)	(((e) >> 16) & 0xff)
 
 static inline bool kvm_can_emulate_event_vectoring(int emul_type)
 {
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -280,6 +280,7 @@ static void svm_set_interrupt_shadow(str
 }
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   int emul_type,
 					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -301,7 +302,7 @@ static int __svm_skip_emulated_instructi
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (!kvm_emulate_instruction(vcpu, emul_type))
 			return 0;
 
 		if (unlikely(!commit_side_effects))
@@ -319,11 +320,13 @@ done:
 
 static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	return __svm_skip_emulated_instruction(vcpu, true);
+	return __svm_skip_emulated_instruction(vcpu, EMULTYPE_SKIP, true);
 }
 
-static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
+static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu, u8 vector)
 {
+	const int emul_type = EMULTYPE_SKIP | EMULTYPE_SKIP_SOFT_INT |
+			      EMULTYPE_SET_SOFT_INT_VECTOR(vector);
 	unsigned long rip, old_rip = kvm_rip_read(vcpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -339,7 +342,7 @@ static int svm_update_soft_interrupt_rip
 	 * in use, the skip must not commit any side effects such as clearing
 	 * the interrupt shadow or RFLAGS.RF.
 	 */
-	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+	if (!__svm_skip_emulated_instruction(vcpu, emul_type, !nrips))
 		return -EIO;
 
 	rip = kvm_rip_read(vcpu);
@@ -375,7 +378,7 @@ static void svm_inject_exception(struct
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (kvm_exception_is_soft(ex->vector) &&
-	    svm_update_soft_interrupt_rip(vcpu))
+	    svm_update_soft_interrupt_rip(vcpu, ex->vector))
 		return;
 
 	svm->vmcb->control.event_inj = ex->vector
@@ -3662,11 +3665,12 @@ static bool svm_set_vnmi_pending(struct
 
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
+	struct kvm_queued_interrupt *intr = &vcpu->arch.interrupt;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
-	if (vcpu->arch.interrupt.soft) {
-		if (svm_update_soft_interrupt_rip(vcpu))
+	if (intr->soft) {
+		if (svm_update_soft_interrupt_rip(vcpu, intr->nr))
 			return;
 
 		type = SVM_EVTINJ_TYPE_SOFT;
@@ -3674,12 +3678,10 @@ static void svm_inject_irq(struct kvm_vc
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
-			   vcpu->arch.interrupt.soft, reinjected);
+	trace_kvm_inj_virq(intr->nr, intr->soft, reinjected);
 	++vcpu->stat.irq_injections;
 
-	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-				       SVM_EVTINJ_VALID | type;
+	svm->vmcb->control.event_inj = intr->nr | SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9021,6 +9021,23 @@ static bool is_vmware_backdoor_opcode(st
 	return false;
 }
 
+static bool is_soft_int_instruction(struct x86_emulate_ctxt *ctxt,
+				    int emulation_type)
+{
+	u8 vector = EMULTYPE_GET_SOFT_INT_VECTOR(emulation_type);
+
+	switch (ctxt->b) {
+	case 0xcc:
+		return vector == BP_VECTOR;
+	case 0xcd:
+		return vector == ctxt->src.val;
+	case 0xce:
+		return vector == OF_VECTOR;
+	default:
+		return false;
+	}
+}
+
 /*
  * Decode an instruction for emulation.  The caller is responsible for handling
  * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
@@ -9131,6 +9148,10 @@ int x86_emulate_instruction(struct kvm_v
 	 * injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
+		if (emulation_type & EMULTYPE_SKIP_SOFT_INT &&
+		    !is_soft_int_instruction(ctxt, emulation_type))
+			return 0;
+
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			ctxt->eip = (u32)ctxt->_eip;
 		else


