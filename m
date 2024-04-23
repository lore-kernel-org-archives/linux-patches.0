Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16341448E2;
	Tue, 23 Apr 2024 21:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908644; cv=none; b=HrWARvkLQClTEHGcVan8awNguHFYLmaHKrpjaJqNTlahnBe9PyFpfVU0Vpx4nm76IKZKWtV/UQg+nhuEm4DiWqhkrGCylDWUvm6QzIcJgqjVU+NaoIvY+e96d9LtO7lV+Ja1Kz6MEMxNZrT0myKBMmmxMXzdJIaB9LGgVf9t7w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908644; c=relaxed/simple;
	bh=Sp/ndlYSPAfIWvRU3h+hIcfenSjWgt+3clbbteIl/y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx4dciKN38lp2m9di/i4TYnm8hBrismskBbzesN6jIVuOOZoW/0cGu0P/uxppbbMyvcC94LXwpj1+Ecf984HsFXqR6VkWgbSm1VNZ9+0kOeLhwRICGtd6HQbOoI2z8hYT0ne04T55AhBLSuNTQDh6yHuHhFjKFTBRBrvk65aKLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=158plMWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="158plMWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84511C116B1;
	Tue, 23 Apr 2024 21:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908644;
	bh=Sp/ndlYSPAfIWvRU3h+hIcfenSjWgt+3clbbteIl/y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=158plMWXqIHWniLBZn5FQHOZbwlkuqPFCGc91xscr/WVkdXWdpIlfiwQGtNXrlaae
	 U2sonhpnqPzOaMXlwhAIih/RNdlLbgwEQK/4PRF6EkN11VA+ru5gppQatlfTttz9de
	 /mfvqHev5aADNpKbJUEo3eqi28vRFrWe/T8iVjkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 129/158] KVM: x86: Snapshot if a vCPUs vendor model is AMD vs. Intel compatible
Date: Tue, 23 Apr 2024 14:39:26 -0700
Message-ID: <20240423213859.906921835@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -828,6 +828,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	struct kvm_hypervisor_cpuid kvm_cpuid;
+	bool is_amd_compatible;
 
 	/*
 	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -362,6 +362,7 @@ static void kvm_vcpu_after_set_cpuid(str
 
 	kvm_update_pv_runtime(vcpu);
 
+	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -125,6 +125,16 @@ static inline bool guest_cpuid_is_intel(
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
@@ -4788,7 +4788,7 @@ static void reset_guest_rsvds_bits_mask(
 				context->cpu_role.base.level, is_efer_nx(context),
 				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
-				guest_cpuid_is_amd_or_hygon(vcpu));
+				guest_cpuid_is_amd_compatible(vcpu));
 }
 
 static void __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3317,7 +3317,7 @@ static bool is_mci_status_msr(u32 msr)
 static bool can_set_mci_status(struct kvm_vcpu *vcpu)
 {
 	/* McStatusWrEn enabled? */
-	if (guest_cpuid_is_amd_or_hygon(vcpu))
+	if (guest_cpuid_is_amd_compatible(vcpu))
 		return !!(vcpu->arch.msr_hwcr & BIT_ULL(18));
 
 	return false;


