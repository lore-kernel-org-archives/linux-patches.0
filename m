Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12849434E30;
	Thu, 16 Jul 2026 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212417; cv=none; b=fyW9o2fVPzKbjXUmuTKv33BYT6uuO6bBLCDwLYGrZvgGRm1Sw4OY88tMPuQC3Uq5xoPrLWBitGtw41tfPDruasTqw/PjleDjVy2YfPwDJOA742fEfoLxUnqBv+VYBk/sCdiZAwSMyT+d7RFEBTUJuNvpWisLU09nD7t+1fQELTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212417; c=relaxed/simple;
	bh=9u3fFYIC+oHNwSl+PpenQQCEm19aBFHRY2DhPcl6Phg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVyYYu7L3F6mbwxBg31P9kUAAVg2seluREx+YKw4yYz1nLl4I+UoR0xS57Aflyxa4FlbI4Bpuv6iUT3DXCa5AHTroEqSKRzgbQ9sFtFDBgdqQwKCyNW3nL2KsYlop8YgPZzP00bDIGp/dwdh50h0mYRF+nwtPwYDOsV8zB9VQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCLPTWP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCLPTWP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC9E1F000E9;
	Thu, 16 Jul 2026 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212415;
	bh=mQGlTprebXPkOBqKzcuK0wnoiAAdlDDwVDaE6j2j0a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCLPTWP4pk91ldJg0Krb+FOg5MDw/EIKaeVquut/+WBbUP/nI2RCXcWQZNds8BqAo
	 sFcQbD1nWx2lMrzFjKqscWYQSqYe8f+5vW41uHl2ETUOc8VT7rZ1LvOLCHKTiX5nh9
	 dpuY+BwzYa+E1axnJT1KtAaiTva41bx1f57tBWyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 318/349] KVM: VMX: Refresh GUEST_PENDING_DBG_EXCEPTIONS.BS on all injected #DBs
Date: Thu, 16 Jul 2026 15:34:12 +0200
Message-ID: <20260716133040.432303590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit c5bad4fa2d5dfd8c25140051a9807eba387a19b8 upstream.

Move KVM's stuffing of GUEST_PENDING_DBG_EXCEPTIONS.BS when RFLAGS.TF=1 and
MOV/POP SS or STI blocking is active into the exception injection code so
that KVM fixes up the VMCS for all injected #DBs, not only those that are
reflected back into the guest after #DB interception.  E.g. if KVM queues
a #DB in the emulator, or more importantly if userspace does save/restore
exactly on the #DB+shadow boundary, then KVM needs to massage the VMCS to
avoid the VM-Entry consistency check.

Opportunistically update the wording of the comment to describe the
behavior as a workaround of flawed CPU behavior/architecture, to make it
clear that the *only* thing KVM is doing is fudging around a consistency
check.  Per the SDM:

  There are no pending debug exceptions after VM entry if any of the
  following are true:

    * The VM entry is vectoring with one of the following interruption
      types: external interrupt, non-maskable interrupt (NMI), hardware
      exception, or privileged software exception.

I.e. forcing GUEST_PENDING_DBG_EXCEPTIONS.BS does *not* impact guest-
visible behavior.

Fixes: b9bed78e2fa9 ("KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS blocking shadow")
Cc: stable@vger.kernel.org
Reported-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Closes: https://lore.kernel.org/all/b1a294bc9ed4dae532474a5dc6c8cb6e5962de7c.1757416809.git.houwenlong.hwl@antgroup.com
Reviewed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Link: https://patch.msgid.link/20260515222638.1949982-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1833,6 +1833,24 @@ void vmx_inject_exception(struct kvm_vcp
 	u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	/*
+	 * When injecting a #DB, single-stepping is enabled in RFLAGS, and STI
+	 * or MOV-SS blocking is active, set vmcs.PENDING_DBG_EXCEPTIONS.BS to
+	 * prevent a false positive from VM-Entry consistency check.  VM-Entry
+	 * asserts that a single-step #DB _must_ be pending in this scenario,
+	 * as the previous instruction cannot have toggled RFLAGS.TF 0=>1
+	 * (because STI and POP/MOV don't modify RFLAGS), therefore the one
+	 * instruction delay when activating single-step breakpoints must have
+	 * already expired.  However, the CPU isn't smart enough to peek at
+	 * vmcs.VM_ENTRY_INTR_INFO_FIELD and so doesn't realize that yes, there
+	 * is indeed a #DB pending/imminent.
+	 */
+	if (ex->vector == DB_VECTOR &&
+	    (vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
+	    vmx_get_interrupt_shadow(vcpu))
+		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+			    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
+
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (ex->has_error_code) {
@@ -5323,26 +5341,9 @@ static int handle_exception_nmi(struct k
 			 * avoid single-step #DB and MTF updates, as ICEBP is
 			 * higher priority.  Note, skipping ICEBP still clears
 			 * STI and MOVSS blocking.
-			 *
-			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
-			 * if single-step is enabled in RFLAGS and STI or MOVSS
-			 * blocking is active, as the CPU doesn't set the bit
-			 * on VM-Exit due to #DB interception.  VM-Entry has a
-			 * consistency check that a single-step #DB is pending
-			 * in this scenario as the previous instruction cannot
-			 * have toggled RFLAGS.TF 0=>1 (because STI and POP/MOV
-			 * don't modify RFLAGS), therefore the one instruction
-			 * delay when activating single-step breakpoints must
-			 * have already expired.  Note, the CPU sets/clears BS
-			 * as appropriate for all other VM-Exits types.
 			 */
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
-			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
-				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
-				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;


