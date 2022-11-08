Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E7615CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CF5C433C1;
	Tue,  8 Nov 2022 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916928;
	bh=6ZqlEWEL9637fJ6JWmQ42OVo8u5lKp4gAc2o/CLp/oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMAxTpJTXomamP9dD5auzyGDyR8exiU/AkfPaRYR1YA1O3QIvYPcAg2/W8XogVg83
	 H5EmzrRBePZn8QgEQdEZxheNfKvUN8TYmL+4Z/3NU3VAzrL2upSKgXARIwVhuY2i4F
	 eP7jrjY8JXLWs4LR1RRhQfsGE2BLxXfNjrLEQCtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 176/197] KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
Date: Tue,  8 Nov 2022 14:40:14 +0100
Message-Id: <20221108133402.920552165@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

commit 18e897d213cb152c786abab14919196bd9dc3a9f upstream.

Fold vmx_supported_debugctl() into vcpu_supported_debugctl(), its only
caller.  Setting bits only to clear them a few instructions later is
rather silly, and splitting the logic makes things seem more complicated
than they actually are.

Opportunistically drop DEBUGCTLMSR_LBR_MASK now that there's a single
reference to the pair of bits.  The extra layer of indirection provides
no meaningful value and makes it unnecessarily tedious to understand
what KVM is doing.

No functional change.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221006000314.73240-4-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/capabilities.h |   15 ---------------
 arch/x86/kvm/vmx/vmx.c          |   12 +++++++-----
 2 files changed, 7 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -24,8 +24,6 @@ extern int __read_mostly pt_mode;
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
-#define DEBUGCTLMSR_LBR_MASK		(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
-
 struct nested_vmx_msrs {
 	/*
 	 * We only store the "true" versions of the VMX capability MSRs. We
@@ -425,19 +423,6 @@ static inline u64 vmx_get_perf_capabilit
 	return perf_cap;
 }
 
-static inline u64 vmx_supported_debugctl(void)
-{
-	u64 debugctl = 0;
-
-	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
-		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
-
-	if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
-		debugctl |= DEBUGCTLMSR_LBR_MASK;
-
-	return debugctl;
-}
-
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2018,13 +2018,15 @@ static u64 nested_vmx_truncate_sysenter_
 
 static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 {
-	u64 debugctl = vmx_supported_debugctl();
+	u64 debugctl = 0;
 
-	if (!intel_pmu_lbr_is_enabled(vcpu))
-		debugctl &= ~DEBUGCTLMSR_LBR_MASK;
+	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
-		debugctl &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
+	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
+	    intel_pmu_lbr_is_enabled(vcpu))
+		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
 	return debugctl;
 }


