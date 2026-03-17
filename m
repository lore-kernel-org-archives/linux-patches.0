Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741BE244694;
	Tue, 17 Mar 2026 16:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765955; cv=none; b=esaaIHNTaDOj5V4ZjZD07CH8S5uG5jOrof2W2CrGMr7DDxUc/6SR25j2rYJzWDW0e9hpqQAD3Aw+cORufnK0qNM0PP5tnnGqlHQoOkAaOxA8+AfMHCehxt4UmIJVzeixuj7udNZq9w66P21x/ryo9qp7cRIbCWX7dRFnK3kUMKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765955; c=relaxed/simple;
	bh=uP4YDgKPqy4xYWPY5beT2HfKKuPJN15rS10aKjZCiGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmrSmSlzCmAvjZmr/ML/LFl2bgESv8MYI5GgWQakXK146tX0uu3jx4fh1wac27dehW3hAp7KFjDxcVUYYbLmK/U60B84FOU/JkKh9lwO96Nu0ZUf2KPP/SUqq12JJI4M9ZhaPMLQ5Uy6bwCbjVNaQqqnYX5VLAaFmxsRser/zys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6K4i4K1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6K4i4K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECE1C4CEF7;
	Tue, 17 Mar 2026 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765955;
	bh=uP4YDgKPqy4xYWPY5beT2HfKKuPJN15rS10aKjZCiGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6K4i4K1AT+W9JILj0FF7Q0e9sboBwznW4VwAx2JzD5xI/lJY6xrW5o7vVEtT1R6R
	 e2h10Ob6dLznb6twM7ffzp11XDKoP1IJ3tDVymuBCN8ntKPx+KY3gdba2dSe6dkjFC
	 dvMTtv9E8D2Kv+FKTMSDsCuBKx5Ox8xsQd+X/jJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.19 136/378] KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM
Date: Tue, 17 Mar 2026 17:31:33 +0100
Message-ID: <20260317163012.017810337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

commit e2ffe85b6d2bb7780174b87aa4468a39be17eb81 upstream.

Add KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM to allow L1 to set
FREEZE_IN_SMM in vmcs12's GUEST_IA32_DEBUGCTL field, as permitted
prior to commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
DEBUGCTLMSR_FREEZE_IN_SMM while running the guest").  Enable the quirk
by default for backwards compatibility (like all quirks); userspace
can disable it via KVM_CAP_DISABLE_QUIRKS2 for consistency with the
constraints on WRMSR(IA32_DEBUGCTL).

Note that the quirk only bypasses the consistency check.  The vmcs02 bit is
still owned by the host, and PMCs are not frozen during virtualized SMM.
In particular, if a host administrator decides that PMCs should not be
frozen during physical SMM, then L1 has no say in the matter.

Fixes: 095686e6fcb4 ("KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter")
Cc: stable@vger.kernel.org
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://patch.msgid.link/20260205231537.1278753-1-jmattson@google.com
[sean: tag for stable@, clean-up and fix goofs in the comment and docs]
Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rename quirk. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/api.rst  |    8 ++++++++
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/include/uapi/asm/kvm.h |    1 +
 arch/x86/kvm/vmx/nested.c       |   22 ++++++++++++++++++----
 4 files changed, 29 insertions(+), 5 deletions(-)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8438,6 +8438,14 @@ KVM_X86_QUIRK_IGNORE_GUEST_PAT      By d
                                     guest software, for example if it does not
                                     expose a bochs graphics device (which is
                                     known to have had a buggy driver).
+
+KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM   By default, KVM relaxes the consistency
+                                      check for GUEST_IA32_DEBUGCTL in vmcs12
+                                      to allow FREEZE_IN_SMM to be set.  When
+                                      this quirk is disabled, KVM requires this
+                                      bit to be cleared.  Note that the vmcs02
+                                      bit is still completely controlled by the
+                                      host, regardless of the quirk setting.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2470,7 +2470,8 @@ int memslot_rmap_alloc(struct kvm_memory
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
 	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
-	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
+	 KVM_X86_QUIRK_IGNORE_GUEST_PAT |	\
+	 KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM)
 
 #define KVM_X86_CONDITIONAL_QUIRKS		\
 	(KVM_X86_QUIRK_CD_NW_CLEARED |		\
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -476,6 +476,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
 #define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
+#define KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM (1 << 10)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3292,10 +3292,24 @@ static int nested_vmx_check_guest_state(
 	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
 		return -EINVAL;
 
-	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
-	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-		return -EINVAL;
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
+		u64 debugctl = vmcs12->guest_ia32_debugctl;
+
+		/*
+		 * FREEZE_IN_SMM is not virtualized, but allow L1 to set it in
+		 * vmcs12's DEBUGCTL under a quirk for backwards compatibility.
+		 * Note that the quirk only relaxes the consistency check.  The
+		 * vmcc02 bit is still under the control of the host.  In
+		 * particular, if a host administrator decides to clear the bit,
+		 * then L1 has no say in the matter.
+		 */
+		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM))
+			debugctl &= ~DEBUGCTLMSR_FREEZE_IN_SMM;
+
+		if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+		    CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))
+			return -EINVAL;
+	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
 	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))


