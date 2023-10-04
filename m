Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DCF1C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmdasimL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26616C433C8;
	Wed,  4 Oct 2023 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444501;
	bh=k/wg75wZZfFHSQioghpWOOmiHqkSrk1HjQfJhRL7F00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmdasimLnhj1A/AWjAyvegeE6wwylZWVf3av+2XTO1c19ahe/K+oSUyeOUMiGPnqz
	 nQm6iXKeVYWKecCRhWb6WeV994aMQ8CUybBvbqI6fBQtct2ghWmndjI1CxClbYqJGq
	 gfx5JBb28S75awdAhQI3OR7FPM2YliD6LP/q1Nb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.5 244/321] KVM: SVM: Fix TSC_AUX virtualization setup
Date: Wed,  4 Oct 2023 19:56:29 +0200
Message-ID: <20231004175240.557047366@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit e0096d01c4fcb8c96c05643cfc2c20ab78eae4da upstream.

The checks for virtualizing TSC_AUX occur during the vCPU reset processing
path. However, at the time of initial vCPU reset processing, when the vCPU
is first created, not all of the guest CPUID information has been set. In
this case the RDTSCP and RDPID feature support for the guest is not in
place and so TSC_AUX virtualization is not established.

This continues for each vCPU created for the guest. On the first boot of
an AP, vCPU reset processing is executed as a result of an APIC INIT
event, this time with all of the guest CPUID information set, resulting
in TSC_AUX virtualization being enabled, but only for the APs. The BSP
always sees a TSC_AUX value of 0 which probably went unnoticed because,
at least for Linux, the BSP TSC_AUX value is 0.

Move the TSC_AUX virtualization enablement out of the init_vmcb() path and
into the vcpu_after_set_cpuid() path to allow for proper initialization of
the support after the guest CPUID information has been set.

With the TSC_AUX virtualization support now in the vcpu_set_after_cpuid()
path, the intercepts must be either cleared or set based on the guest
CPUID input.

Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <4137fbcb9008951ab5f0befa74a0399d2cce809a.1694811272.git.thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   31 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c |    9 ++-------
 arch/x86/kvm/svm/svm.h |    1 +
 3 files changed, 29 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2945,6 +2945,32 @@ int sev_es_string_io(struct vcpu_svm *sv
 				    count, in);
 }
 
+static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
+		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
+	}
+}
+
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_cpuid_entry2 *best;
+
+	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
+	best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
+	if (best)
+		vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
+
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_vcpu_after_set_cpuid(svm);
+}
+
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -2991,11 +3017,6 @@ static void sev_es_init_vmcb(struct vcpu
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
-
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
-	    (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP) ||
-	     guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDPID)))
-		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4217,7 +4217,6 @@ static bool svm_has_emulated_msr(struct
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_cpuid_entry2 *best;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -4252,12 +4251,8 @@ static void svm_vcpu_after_set_cpuid(str
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
 				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
-	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
-	if (sev_guest(vcpu->kvm)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
-		if (best)
-			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
-	}
+	if (sev_guest(vcpu->kvm))
+		sev_vcpu_after_set_cpuid(svm);
 
 	init_vmcb_after_set_cpuid(vcpu);
 }
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -733,6 +733,7 @@ void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_init_vmcb(struct vcpu_svm *svm);
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);


