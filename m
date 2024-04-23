Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E1B14388F;
	Tue, 23 Apr 2024 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908814; cv=none; b=uNPPmZssBI1br4WcPh77gbdcqItquNCK1nQVMhJ/37qCcHAOHsF7B0jxqa12mHL4T3Fe6zY7+ZrpnAEm20G5IQh6DIJwsyD7k1NmxjUW6CwKgGCTq0hT0kX05hJCp3EMwB0WGTKjcv/lF32IgEFdJOLyQ+OmzkkAkkXlK+qh0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908814; c=relaxed/simple;
	bh=RFyF2/jSKKeY9m3ij8gBat46dbpXkBXsUn4afKctYVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWdm89Im7QN9QdRLtEIRuWZ+ZK8TTLBfJkirRyK8UWdZCWgLXHrYtSXhDVVQg1/PVCDm8x2sr3Vgi2Qc5nokVK+r7xOzJBDMIBL1wXgIpClWP1YLy/b/0CgUuRZxzgBxakAZno1/pJFv/JS4mlt95UJOqLpQsF/LywcdtirhmM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKA8+Qgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKA8+Qgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D04C116B1;
	Tue, 23 Apr 2024 21:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908814;
	bh=RFyF2/jSKKeY9m3ij8gBat46dbpXkBXsUn4afKctYVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKA8+Qgg9xJW9XPhyxjUgQ/opJvzOBQSbBcK2aQpZy1yc1dLE4A5gYQmZOFrEkQCg
	 YNaYtaTkt+NOoraoj9nBp+1ftVpPE8YIb25yd4UKGGrDMmgXi//5zrtT46bDN0crP7
	 BugHJWM5U6HGSi3sqP2QqvkdLj0NGcqwCU+uBqZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 59/71] KVM: x86: Snapshot if a vCPUs vendor model is AMD vs. Intel compatible
Date: Tue, 23 Apr 2024 14:40:12 -0700
Message-ID: <20240423213846.218900084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -732,6 +732,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
+	bool is_amd_compatible;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -189,6 +189,7 @@ static void kvm_vcpu_after_set_cpuid(str
 
 	kvm_update_pv_runtime(vcpu);
 
+	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -121,6 +121,16 @@ static inline bool guest_cpuid_is_intel(
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
@@ -4351,7 +4351,7 @@ static void reset_rsvds_bits_mask(struct
 				context->root_level, is_efer_nx(context),
 				guest_can_use_gbpages(vcpu),
 				is_cr4_pse(context),
-				guest_cpuid_is_amd_or_hygon(vcpu));
+				guest_cpuid_is_amd_compatible(vcpu));
 }
 
 static void
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3107,7 +3107,7 @@ static void kvmclock_sync_fn(struct work
 static bool can_set_mci_status(struct kvm_vcpu *vcpu)
 {
 	/* McStatusWrEn enabled? */
-	if (guest_cpuid_is_amd_or_hygon(vcpu))
+	if (guest_cpuid_is_amd_compatible(vcpu))
 		return !!(vcpu->arch.msr_hwcr & BIT_ULL(18));
 
 	return false;


