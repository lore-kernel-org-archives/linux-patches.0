Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC33320B3E;
	Tue, 23 Apr 2024 21:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908533; cv=none; b=M0l0QkZtC1EF6Sy+m+IB27lCfsPjZAq41WQh4IiKIYPvFrYOc1RZ2g2j3YDoGaM+0J6CQrly8iefwAkaztRJGkMj/6t++0XGGQCWaCajRXPAXGMjNcpaEnUtjx//ezRn+bz6vC+x/fkRqjsU8/8SDKsUMSrD2IfMPQ03tQq3s4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908533; c=relaxed/simple;
	bh=xA15Qg5eZ86NPEgxjC/cyb17sUXI42YSkxlAhF7NPVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbssvjlgdj5jHo1HZDs8CmBFqx+49rfxaBdM5BAM+X9/ln4PPlEcpybHXlfBmG223h6hJWMdZ8A7j9lCduNqJcHgd0PXnb9Z1/XIeObo/tOU3Wcvq1xiGCJxSXGJjxG67TK9xsKe8sqZSakiOgkFsuqeuFNK1KUd56BFqhi5XHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w19UQFs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w19UQFs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B259FC3277B;
	Tue, 23 Apr 2024 21:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908533;
	bh=xA15Qg5eZ86NPEgxjC/cyb17sUXI42YSkxlAhF7NPVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w19UQFs3BW0AxHffoTX2vcenJGYlOKMPFisK7OsIzhYO0TTV5CvtDPtTUy0unEhCb
	 uzRylDLvtdwWPaaUd+gHrGDWkzdbP+ba6+lPnY0lIaKrbIX/i0p36UFKDbiDnm9tIK
	 GH0BLUWWPJB0MNtq8l5/eFhV47QsFqi7GZXhg/3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.8 126/158] KVM: x86: Snapshot if a vCPUs vendor model is AMD vs. Intel compatible
Date: Tue, 23 Apr 2024 14:39:08 -0700
Message-ID: <20240423213900.000274338@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit fd706c9b1674e2858766bfbf7430534c2b26fbef upstream.

Add kvm_vcpu_arch.is_amd_compatible to cache if a vCPU's vendor model is
compatible with AMD, i.e. if the vCPU vendor is AMD or Hygon, along with
helpers to check if a vCPU is compatible AMD vs. Intel.  To handle Intel
vs. AMD behavior related to masking the LVTPC entry, KVM will need to
check for vendor compatibility on every PMI injection, i.e. querying for
AMD will soon be a moderately hot path.

Note!  This subtly (or maybe not-so-subtly) makes "Intel compatible" KVM's
default behavior, both if userspace omits (or never sets) CPUID 0x0 and if
userspace sets a completely unknown vendor.  One could argue that KVM
should treat such vCPUs as not being compatible with Intel *or* AMD, but
that would add useless complexity to KVM.

KVM needs to do *something* in the face of vendor specific behavior, and
so unless KVM conjured up a magic third option, choosing to treat unknown
vendors as neither Intel nor AMD means that checks on AMD compatibility
would yield Intel behavior, and checks for Intel compatibility would yield
AMD behavior.  And that's far worse as it would effectively yield random
behavior depending on whether KVM checked for AMD vs. Intel vs. !AMD vs.
!Intel.  And practically speaking, all x86 CPUs follow either Intel or AMD
architecture, i.e. "supporting" an unknown third architecture adds no
value.

Deliberately don't convert any of the existing guest_cpuid_is_intel()
checks, as the Intel side of things is messier due to some flows explicitly
checking for exactly vendor==Intel, versus some flows assuming anything
that isn't "AMD compatible" gets Intel behavior.  The Intel code will be
cleaned up in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240405235603.1173076-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |    1 +
 arch/x86/kvm/cpuid.h            |   10 ++++++++++
 arch/x86/kvm/mmu/mmu.c          |    2 +-
 arch/x86/kvm/x86.c              |    2 +-
 5 files changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -854,6 +854,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	struct kvm_hypervisor_cpuid kvm_cpuid;
+	bool is_amd_compatible;
 
 	/*
 	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -366,6 +366,7 @@ static void kvm_vcpu_after_set_cpuid(str
 
 	kvm_update_pv_runtime(vcpu);
 
+	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -120,6 +120,16 @@ static inline bool guest_cpuid_is_intel(
 	return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
 }
 
+static inline bool guest_cpuid_is_amd_compatible(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.is_amd_compatible;
+}
+
+static inline bool guest_cpuid_is_intel_compatible(struct kvm_vcpu *vcpu)
+{
+	return !guest_cpuid_is_amd_compatible(vcpu);
+}
+
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4922,7 +4922,7 @@ static void reset_guest_rsvds_bits_mask(
 				context->cpu_role.base.level, is_efer_nx(context),
 				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
-				guest_cpuid_is_amd_or_hygon(vcpu));
+				guest_cpuid_is_amd_compatible(vcpu));
 }
 
 static void __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3422,7 +3422,7 @@ static bool is_mci_status_msr(u32 msr)
 static bool can_set_mci_status(struct kvm_vcpu *vcpu)
 {
 	/* McStatusWrEn enabled? */
-	if (guest_cpuid_is_amd_or_hygon(vcpu))
+	if (guest_cpuid_is_amd_compatible(vcpu))
 		return !!(vcpu->arch.msr_hwcr & BIT_ULL(18));
 
 	return false;


