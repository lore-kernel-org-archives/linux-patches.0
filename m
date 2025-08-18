Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B81343D9B;
	Mon, 18 Aug 2025 14:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526507; cv=none; b=WsuV30EvMdQCIOFFSWsK1BaXT4WFXTWNR3kuT5uC8K6bivVNwffjY75soSpvZiYXc0u2e/T9VbflqXv1nr6pp5sGpEiUIUqlLYuouCTVdro+he4VlOquX8tKzPfYMRXywS1OTtHrzR4fKJ22zYMoLB/XbB9YSlZJ+N/mgN1Yf1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526507; c=relaxed/simple;
	bh=ElOtp7yp7HnxPIIigSrEl3EobIbcgs7+FW6vwJEHWIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvd8JePxMo7dSPEv1XoXx8/Dr6ZxQD56UvDuCSoQ9DZQf8xGO0oS6zIcYqS/wcNy/un6/9cRNX8O5hZrnJI5/QXS3v984FhLeSZO/VY5EFwhB0wSreQLRrvm9ZyTj/BiaFxZMcQoHT21v9YPQmlbANmfPrRQao7KPX2GomlSiQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5GXk6YE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5GXk6YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BB1C4CEEB;
	Mon, 18 Aug 2025 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526507;
	bh=ElOtp7yp7HnxPIIigSrEl3EobIbcgs7+FW6vwJEHWIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5GXk6YEYOLeqCDlx1jjKtJ3OvckqdvP+KfadTyvuyT4Kgyy32OliRToS8l9OLQNd
	 f9hoAPXE5QmHRAKGezeUlmZSYtDvOOYgDw6LRT0j3ufomhQexhcqUyb25eQT+ibm9o
	 zETd3xuJSq8hXOD+ud6+i8srEYbjmdldgtseVtwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 557/570] KVM: VMX: Extract checking of guests DEBUGCTL into helper
Date: Mon, 18 Aug 2025 14:49:04 +0200
Message-ID: <20250818124527.327835448@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 8a4351ac302cd8c19729ba2636acfd0467c22ae8 ]

Move VMX's logic to check DEBUGCTL values into a standalone helper so that
the code can be used by nested VM-Enter to apply the same logic to the
value being loaded from vmcs12.

KVM needs to explicitly check vmcs12->guest_ia32_debugctl on nested
VM-Enter, as hardware may support features that KVM does not, i.e. relying
on hardware to detect invalid guest state will result in false negatives.
Unfortunately, that means applying KVM's funky suppression of BTF and LBR
to vmcs12 so as not to break existing guests.

No functional change intended.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/r/20250610232010.162191-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 6b1dd26544d0 ("KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while running the guest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2193,6 +2193,19 @@ static u64 vmx_get_supported_debugctl(st
 	return debugctl;
 }
 
+static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
+				  bool host_initiated)
+{
+	u64 invalid;
+
+	invalid = data & ~vmx_get_supported_debugctl(vcpu, host_initiated);
+	if (invalid & (DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR)) {
+		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+		invalid &= ~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR);
+	}
+	return !invalid;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2261,19 +2274,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, s
 		}
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_DEBUGCTLMSR: {
-		u64 invalid;
-
-		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
-		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
-			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
-			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-		}
-
-		if (invalid)
+	case MSR_IA32_DEBUGCTLMSR:
+		if (!vmx_is_valid_debugctl(vcpu, data, msr_info->host_initiated))
 			return 1;
 
+		data &= vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
+
 		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
@@ -2283,7 +2289,6 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, s
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
-	}
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&


