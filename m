Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAF879C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E91C433D2;
	Thu, 12 Jan 2023 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534013;
	bh=/dZrnIdh+893lVwjXBbroY1g1w75W8jvjVAt8xXP8hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWjH/SARIQHmHfA1YigZf3883IBqbp1kynX1+27nRi7Xc6+cDuKuiqLbzggKuXB9/
	 4WFvRUTwJ/6Zh3C0S+sfXXQrSMmRbhRajJC1KG3tzi0bNMpVcM0yVtxplhYueuxpeA
	 VhcrI41yDc/t1V9cnUOGcJIYxW/E4UJyldZybb0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Li <ercli@ucdavis.edu>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 636/783] KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
Date: Thu, 12 Jan 2023 14:55:52 +0100
Message-Id: <20230112135553.800796718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 9cc409325ddd776f6fd6293d5ce93ce1248af6e4 upstream.

Inject #GP for if VMXON is attempting with a CR0/CR4 that fails the
generic "is CRx valid" check, but passes the CR4.VMXE check, and do the
generic checks _after_ handling the post-VMXON VM-Fail.

The CR4.VMXE check, and all other #UD cases, are special pre-conditions
that are enforced prior to pivoting on the current VMX mode, i.e. occur
before interception if VMXON is attempted in VMX non-root mode.

All other CR0/CR4 checks generate #GP and effectively have lower priority
than the post-VMXON check.

Per the SDM:

    IF (register operand) or (CR0.PE = 0) or (CR4.VMXE = 0) or ...
        THEN #UD;
    ELSIF not in VMX operation
        THEN
            IF (CPL > 0) or (in A20M mode) or
            (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);
    ELSIF in VMX non-root operation
        THEN VMexit;
    ELSIF CPL > 0
        THEN #GP(0);
    ELSE VMfail("VMXON executed in VMX root operation");
    FI;

which, if re-written without ELSIF, yields:

    IF (register operand) or (CR0.PE = 0) or (CR4.VMXE = 0) or ...
        THEN #UD

    IF in VMX non-root operation
        THEN VMexit;

    IF CPL > 0
        THEN #GP(0)

    IF in VMX operation
        THEN VMfail("VMXON executed in VMX root operation");

    IF (in A20M mode) or
       (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);

Note, KVM unconditionally forwards VMXON VM-Exits that occur in L2 to L1,
i.e. there is no need to check the vCPU is not in VMX non-root mode.  Add
a comment to explain why unconditionally forwarding such exits is
functionally correct.

Reported-by: Eric Li <ercli@ucdavis.edu>
Fixes: c7d855c2aff2 ("KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20221006001956.329314-1-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4901,24 +4901,35 @@ static int handle_vmon(struct kvm_vcpu *
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
-	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
-	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
-	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 * Manually check CR4.VMXE checks, KVM must force CR4.VMXE=1 to enter
+	 * the guest and so cannot rely on hardware to perform the check,
+	 * which has higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON).
 	 *
-	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
-	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
-	 * Mode, but KVM will never take the guest out of those modes.
+	 * Rely on hardware for the other pre-VM-Exit checks, CR0.PE=1, !VM86
+	 * and !COMPATIBILITY modes.  For an unrestricted guest, KVM doesn't
+	 * force any of the relevant guest state.  For a restricted guest, KVM
+	 * does force CR0.PE=1, but only to also force VM86 in order to emulate
+	 * Real Mode, and so there's no need to check CR0.PE manually.
 	 */
-	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
-	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
 	/*
-	 * CPL=0 and all other checks that are lower priority than VM-Exit must
-	 * be checked manually.
+	 * The CPL is checked for "not in VMX operation" and for "in VMX root",
+	 * and has higher priority than the VM-Fail due to being post-VMXON,
+	 * i.e. VMXON #GPs outside of VMX non-root if CPL!=0.  In VMX non-root,
+	 * VMXON causes VM-Exit and KVM unconditionally forwards VMXON VM-Exits
+	 * from L2 to L1, i.e. there's no need to check for the vCPU being in
+	 * VMX non-root.
+	 *
+	 * Forwarding the VM-Exit unconditionally, i.e. without performing the
+	 * #UD checks (see above), is functionally ok because KVM doesn't allow
+	 * L1 to run L2 without CR4.VMXE=0, and because KVM never modifies L2's
+	 * CR0 or CR4, i.e. it's L2's responsibility to emulate #UDs that are
+	 * missed by hardware due to shadowing CR0 and/or CR4.
 	 */
 	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
@@ -4928,6 +4939,17 @@ static int handle_vmon(struct kvm_vcpu *
 	if (vmx->nested.vmxon)
 		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
 
+	/*
+	 * Invalid CR0/CR4 generates #GP.  These checks are performed if and
+	 * only if the vCPU isn't already in VMX operation, i.e. effectively
+	 * have lower priority than the VM-Fail above.
+	 */
+	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
+	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	if ((vmx->msr_ia32_feature_control & VMXON_NEEDED_FEATURES)
 			!= VMXON_NEEDED_FEATURES) {
 		kvm_inject_gp(vcpu, 0);


