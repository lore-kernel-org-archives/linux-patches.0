Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856E214F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOuTykNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1675C433C7;
	Mon, 23 Oct 2023 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060080;
	bh=5zA+0Jbi+LwdrXcUywgQjO7QJl/nPbUCua6qLqV4tMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOuTykNTcmqG6L+lQBogeqZbsOMyOSLBCR52LcTcQsC/rtsThifMm8kNCJt/GTpLz
	 XhbkivXtYSiPtxwrThkQmNxNp/isLvfNthpyz0kVxCU6oAHFTUlixad/xm0jXfYxBs
	 i1ifvMEi0+u/qdwMNXFj6UIExtMluNU5V0mrV7nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Stachecki <stachecki.tyler@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 025/196] KVM: x86: Constrain guest-supported xfeatures only at KVM_GET_XSAVE{2}
Date: Mon, 23 Oct 2023 12:54:50 +0200
Message-ID: <20231023104829.195202788@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 8647c52e9504c99752a39f1d44f6268f82c40a5c upstream.

Mask off xfeatures that aren't exposed to the guest only when saving guest
state via KVM_GET_XSAVE{2} instead of modifying user_xfeatures directly.
Preserving the maximal set of xfeatures in user_xfeatures restores KVM's
ABI for KVM_SET_XSAVE, which prior to commit ad856280ddea ("x86/kvm/fpu:
Limit guest user_xfeatures to supported bits of XCR0") allowed userspace
to load xfeatures that are supported by the host, irrespective of what
xfeatures are exposed to the guest.

There is no known use case where userspace *intentionally* loads xfeatures
that aren't exposed to the guest, but the bug fixed by commit ad856280ddea
was specifically that KVM_GET_SAVE{2} would save xfeatures that weren't
exposed to the guest, e.g. would lead to userspace unintentionally loading
guest-unsupported xfeatures when live migrating a VM.

Restricting KVM_SET_XSAVE to guest-supported xfeatures is especially
problematic for QEMU-based setups, as QEMU has a bug where instead of
terminating the VM if KVM_SET_XSAVE fails, QEMU instead simply stops
loading guest state, i.e. resumes the guest after live migration with
incomplete guest state, and ultimately results in guest data corruption.

Note, letting userspace restore all host-supported xfeatures does not fix
setups where a VM is migrated from a host *without* commit ad856280ddea,
to a target with a subset of host-supported xfeatures.  However there is
no way to safely address that scenario, e.g. KVM could silently drop the
unsupported features, but that would be a clear violation of KVM's ABI and
so would require userspace to opt-in, at which point userspace could
simply be updated to sanitize the to-be-loaded XSAVE state.

Reported-by: Tyler Stachecki <stachecki.tyler@gmail.com>
Closes: https://lore.kernel.org/all/20230914010003.358162-1-tstachecki@bloomberg.net
Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
Cc: stable@vger.kernel.org
Cc: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Message-Id: <20230928001956.924301-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    5 +----
 arch/x86/kvm/cpuid.c         |    8 --------
 arch/x86/kvm/x86.c           |   18 ++++++++++++++++--
 3 files changed, 17 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1543,10 +1543,7 @@ static int fpstate_realloc(u64 xfeatures
 		fpregs_restore_userregs();
 
 	newfps->xfeatures = curfps->xfeatures | xfeatures;
-
-	if (!guest_fpu)
-		newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
-
+	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
 	newfps->xfd = curfps->xfd & ~xfeatures;
 
 	/* Do the final updates within the locked region */
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -338,14 +338,6 @@ static void kvm_vcpu_after_set_cpuid(str
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	/*
-	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
-	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
-	 * supported by the host.
-	 */
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0 |
-						       XFEATURE_MASK_FPSSE;
-
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5305,12 +5305,26 @@ static int kvm_vcpu_ioctl_x86_set_debugr
 static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
 					  u8 *state, unsigned int size)
 {
+	/*
+	 * Only copy state for features that are enabled for the guest.  The
+	 * state itself isn't problematic, but setting bits in the header for
+	 * features that are supported in *this* host but not exposed to the
+	 * guest can result in KVM_SET_XSAVE failing when live migrating to a
+	 * compatible host without the features that are NOT exposed to the
+	 * guest.
+	 *
+	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
+	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
+	 * supported by the host.
+	 */
+	u64 supported_xcr0 = vcpu->arch.guest_supported_xcr0 |
+			     XFEATURE_MASK_FPSSE;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return;
 
 	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
-				       vcpu->arch.guest_fpu.fpstate->user_xfeatures,
-				       vcpu->arch.pkru);
+				       supported_xcr0, vcpu->arch.pkru);
 }
 
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,


