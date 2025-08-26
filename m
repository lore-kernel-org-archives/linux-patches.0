Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658FA1FBCB1;
	Tue, 26 Aug 2025 13:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214155; cv=none; b=WJgynKOisHlTlrSHIRwqU6sDYHoWDpr1z+JphRIGvU/3zSq4d8C1RsAyShzsaUV38whrgXjP5X+YrAXf1hZHYvr/ZviCaqMbbDqqa8uyuzGieh4c8/zasP0NWh4wwdx5v2/uINohn9WsdFQrxnAIkqJX7ZGs7AWqVk0Kbh9ciQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214155; c=relaxed/simple;
	bh=sIZAGsMU4YUl3Y+obqY4NGAfzhGPFkTHszMQgxjRWLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfAZlPm4jKFt4jvd0G0oUrvRHr5Q1p+igMnLNXEFsjSdvsQLAYpfLNAuAh/uZCXx+JCnBqRfVR76siOMMhNBj/C+xniWnkETIBMS+dinjPTg2qO9qxP+y3wVEnObmQCHmbc/3wNaFNJ/KXP/CNeT6PrLh3VAk4bx9UrMABYDlyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVdZ53Bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVdZ53Bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF13CC113CF;
	Tue, 26 Aug 2025 13:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214155;
	bh=sIZAGsMU4YUl3Y+obqY4NGAfzhGPFkTHszMQgxjRWLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVdZ53BfcMQbesTcNuxMnZrdN04nA9n371iPTIbpD9EfuyFnnQ3xe9e/Qd3cFIb5r
	 231NlIHZTj/5WhWc/b5XRqcmbmOfBtsdF38JnU0ldSTQp9/UWY2nqKW0APa5wFJB3F
	 95x/2ZT3AH48qMbayhnZk4qEbFxLxU41+Na7XaY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 6.1 031/482] KVM: x86: Snapshot the hosts DEBUGCTL in common x86
Date: Tue, 26 Aug 2025 13:04:44 +0200
Message-ID: <20250826110931.575038804@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit fb71c795935652fa20eaf9517ca9547f5af99a76 ]

Move KVM's snapshot of DEBUGCTL to kvm_vcpu_arch and take the snapshot in
common x86, so that SVM can also use the snapshot.

Opportunistically change the field to a u64.  While bits 63:32 are reserved
on AMD, not mentioned at all in Intel's SDM, and managed as an "unsigned
long" by the kernel, DEBUGCTL is an MSR and therefore a 64-bit value.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: resolve minor syntatic conflict in vmx_vcpu_load()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 8 ++------
 arch/x86/kvm/vmx/vmx.h          | 2 --
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6db42ee82032..555c7bf35e28 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -677,6 +677,7 @@ struct kvm_vcpu_arch {
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
+	u64 host_debugctl;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	bool load_eoi_exitmap_pending;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7b87fbc69b21..c24da2cff208 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1418,13 +1418,9 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  */
 static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
-
-	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -7275,8 +7271,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
-	if (vmx->host_debugctlmsr)
-		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vcpu->arch.host_debugctl)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 #ifndef CONFIG_X86_64
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8b4b149bd9c1..357819872d80 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -352,8 +352,6 @@ struct vcpu_vmx {
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
-	unsigned long host_debugctlmsr;
-
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6dc8f662fa4..ba24bb50af57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4742,6 +4742,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
+	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
-- 
2.50.1



