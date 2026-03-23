Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310723BA222;
	Mon, 23 Mar 2026 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282561; cv=none; b=beMyj/ywVVLw3Pr93EyUW1VN8QhT8PjqydE/Iosm9HDDGOb4FvT9kh+hC7grrqaX0R7bt42G+43eV/rP99eshoTJhBx08k+Ue/6nG/liwNzRY5Nm9HXj/b/4Td7yCjgXJSQIHxtwPIlCh5u0wEHsg4ECg806G6Jfgzha9maSz3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282561; c=relaxed/simple;
	bh=+yNZibrtB9sRNGiDIH34j6ZnOi/Xi+1dmPnMpb//TZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1KOgiqyVoBRKFGxSjGtqmEn3o3duIhnbHSZ44XiF0OqtrPkJJKGpqwaaJvxd2pVZNizraGLVZMEdGbzVEGnfe6+geYAc2mbLF54uTrlju/oLczMUijRDZEtW+mUYUz35j3ZTGYtUiKpIaQoYgKDr2qmesaor+VZ99UETIa5WYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHnEmGCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHnEmGCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F73C2BCB0;
	Mon, 23 Mar 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282561;
	bh=+yNZibrtB9sRNGiDIH34j6ZnOi/Xi+1dmPnMpb//TZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHnEmGCq92OeSb+4sRSjsiU4nEHTO0m+V5N1GHkkZbE3PvkhyUOx5tf7AVhncCHii
	 YPJ4hgkPnGtES9DNapUly9kNMnxkM5RZgAWfd+2Lv4t+L1AOU6zYUvUkt/UfIJAtlC
	 RFZwQq7c4KH0pRmDvkbYGjc0k+vIurxO9+lyqQL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 203/481] KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC
Date: Mon, 23 Mar 2026 14:43:05 +0100
Message-ID: <20260323134530.122478376@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 3989a6d036c8ec82c0de3614bed23a1dacd45de5 upstream.

Initialize all per-vCPU AVIC control fields in the VMCB if AVIC is enabled
in KVM and the VM has an in-kernel local APIC, i.e. if it's _possible_ the
vCPU could activate AVIC at any point in its lifecycle.  Configuring the
VMCB if and only if AVIC is active "works" purely because of optimizations
in kvm_create_lapic() to speculatively set apicv_active if AVIC is enabled
*and* to defer updates until the first KVM_RUN.  In quotes because KVM
likely won't do the right thing if kvm_apicv_activated() is false, i.e. if
a vCPU is created while APICv is inhibited at the VM level for whatever
reason.  E.g. if the inhibit is *removed* before KVM_REQ_APICV_UPDATE is
handled in KVM_RUN, then __kvm_vcpu_update_apicv() will elide calls to
vendor code due to seeing "apicv_active == activate".

Cleaning up the initialization code will also allow fixing a bug where KVM
incorrectly leaves CR8 interception enabled when AVIC is activated without
creating a mess with respect to whether AVIC is activated or not.

Cc: stable@vger.kernel.org
Fixes: 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before enabling AVIC")
Fixes: 6c3e4422dd20 ("svm: Add support for dynamic APICv")
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://patch.msgid.link/20260203190711.458413-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |    2 +-
 arch/x86/kvm/svm/svm.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -245,7 +245,7 @@ void avic_init_vmcb(struct vcpu_svm *svm
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
-	if (kvm_apicv_activated(svm->vcpu.kvm))
+	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_activate_vmcb(svm);
 	else
 		avic_deactivate_vmcb(svm);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1307,7 +1307,7 @@ static void init_vmcb(struct kvm_vcpu *v
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
 		avic_init_vmcb(svm, vmcb);
 
 	if (vgif) {


