Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC503AC0EB;
	Mon, 23 Mar 2026 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278316; cv=none; b=T+FTaQw8WK/1MIdic6FY6WlpDKQGGepy7inDsPnB6FRwvK3OANAkwW3z5hwqcrZhBWsELFCIGjgxW6m0k/+9Ek1AK8aKsK04vNZNp+mo0DuGDazrYrDdlnpPUqQ9+v4BAwFs7dQjfKn6G5XIOC7T3Y+IHr1cLnq/R+vHZqGydkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278316; c=relaxed/simple;
	bh=KF+X9ETunkXjG7cQq/no0fW+zbCQiWPWgEiwQ6I7DC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ksz//be6E3fJN56Cw7sAQbBOl+9FEU4onrFbwLswDUGOggG61rySNPsYo5Zvd7lw3LztruwjgTt136Cf/ILaBL+nqFT8U2Eb/26OJsO28brZk65BaE8VM0TA2oNkA95tQvwldp/sZ+smfEfrGVMVTA4OpiZqHYr2WJKlq6wrx4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODBiQ705; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODBiQ705"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72979C4CEF7;
	Mon, 23 Mar 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278315;
	bh=KF+X9ETunkXjG7cQq/no0fW+zbCQiWPWgEiwQ6I7DC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODBiQ705IVzXhqb0T4D+8WMqcoKUx4esDTXTxqFRuVWc9o7+oSri1Y/ahOumip9o7
	 Y4qdShR9HTRc9QtND5F7qtuTIq+GbFwy68Qz3J4s5LnRkRYh5rGjPaFAekdm1cMWkW
	 XzV8tZS2J/AAmIeqVxo7jY+5hdhqEYMyUgyA0BJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 268/567] KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC
Date: Mon, 23 Mar 2026 14:43:08 +0100
Message-ID: <20260323134540.462373236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -253,7 +253,7 @@ void avic_init_vmcb(struct vcpu_svm *svm
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
-	if (kvm_apicv_activated(svm->vcpu.kvm))
+	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_activate_vmcb(svm);
 	else
 		avic_deactivate_vmcb(svm);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1375,7 +1375,7 @@ static void init_vmcb(struct kvm_vcpu *v
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
 		avic_init_vmcb(svm, vmcb);
 
 	if (vnmi)


