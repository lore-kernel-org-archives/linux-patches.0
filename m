Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2F212CDA5;
	Tue, 26 Aug 2025 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212656; cv=none; b=AH3bcdLGyjSm2iJRiACDdyOzalh/I5m4pnq0YjclOAC7VueRUGMAf/xYqjKxMuAMfajy+pwN+S1JRfm+4mUWKSR9DJasQwrEtoqJw0L0DEr+c2eY8xLaNeRB4Lm8es+GzGf6Okm6aojXJhYgDIyMHuz+ImCYsIbJGSvh6axigik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212656; c=relaxed/simple;
	bh=nQEITT8/AdXw+8BZuM1jrZyLiTwzgVfLkub2CEL77MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzJ3zvpMO9CRGyqcnuHseDreA3dwtx8aFsPbmrwaBlH10E5a5Lqm8WPA7Uw8cegAXVLGysJHnd+mR0JJ9u1gikJEs5zISBS0r+VBeo4fG/KPd28KwTR8dCr8sQRQUi22B2w6g8iZl93LgxyofBQtSKo3WnQ1h8iB/MI9RlWKRSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKGC9gzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKGC9gzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF93C113CF;
	Tue, 26 Aug 2025 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212656;
	bh=nQEITT8/AdXw+8BZuM1jrZyLiTwzgVfLkub2CEL77MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKGC9gznck2j5E8dQ4EYKEdYBD+ieHQ/XEJksvkgiz57aGQUCyjIwHwzARz2u1kLk
	 bWgH0D0xc8KMDHLF+fyNiMQVCQ4w0FuuN0d+UvBPMiYoJXCSooJVNwCvnS4Z9OTXIK
	 ql0LS45j4HW7ZNZ1fCOf3ALhWTB0+1MMiawFrn0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 051/587] KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
Date: Tue, 26 Aug 2025 13:03:20 +0200
Message-ID: <20250826110954.241591364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 095686e6fcb4150f0a55b1a25987fad3d8af58d6 ]

Add a consistency check for L2's guest_ia32_debugctl, as KVM only supports
a subset of hardware functionality, i.e. KVM can't rely on hardware to
detect illegal/unsupported values.  Failure to check the vmcs12 value
would allow the guest to load any harware-supported value while running L2.

Take care to exempt BTF and LBR from the validity check in order to match
KVM's behavior for writes via WRMSR, but without clobbering vmcs12.  Even
if VM_EXIT_SAVE_DEBUG_CONTROLS is set in vmcs12, L1 can reasonably expect
that vmcs12->guest_ia32_debugctl will not be modified if writes to the MSR
are being intercepted.

Arguably, KVM _should_ update vmcs12 if VM_EXIT_SAVE_DEBUG_CONTROLS is set
*and* writes to MSR_IA32_DEBUGCTLMSR are not being intercepted by L1, but
that would incur non-trivial complexity and wouldn't change the fact that
KVM's handling of DEBUGCTL is blatantly broken.  I.e. the extra complexity
is not worth carrying.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250610232010.162191-7-seanjc@google.com
Stable-dep-of: 7d0cce6cbe71 ("KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++++++--
 arch/x86/kvm/vmx/vmx.c    |  5 ++---
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fdf7503491f9..10236ecdad95 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2564,7 +2564,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl &
+						  vmx_get_supported_debugctl(vcpu, false));
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
@@ -3045,7 +3046,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
+	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
@@ -4435,6 +4437,12 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		(vmcs12->vm_entry_controls & ~VM_ENTRY_IA32E_MODE) |
 		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
 
+	/*
+	 * Note!  Save DR7, but intentionally don't grab DEBUGCTL from vmcs02.
+	 * Writes to DEBUGCTL that aren't intercepted by L1 are immediately
+	 * propagated to vmcs12 (see vmx_set_msr()), as the value loaded into
+	 * vmcs02 doesn't strictly track vmcs12.
+	 */
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
 		kvm_get_dr(vcpu, 7, (unsigned long *)&vmcs12->guest_dr7);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aaa767ed170e..32f1a38a1010 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2149,7 +2149,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
-static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 {
 	u64 debugctl = 0;
 
@@ -2168,8 +2168,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
-static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
-				  bool host_initiated)
+bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
 {
 	u64 invalid;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 50d32d830890..5816fdd2dfa8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -429,6 +429,9 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
+bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
+
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
  * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
-- 
2.50.1



