Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C712116F6;
	Tue, 17 Mar 2026 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767619; cv=none; b=OBHkJLzZjV3h+t569WWzxu9k7oTM9qDWpZsV+O4StQjQL/DmVHyxv/tGoGyrbXg6tYWEYsmcFxlO3tee9WU0Aq0YAnmO/+STvn4hrwVXqwODDQJ3ZnjhaxEK+ipigtss3NM9aAsM68LIIGq41TQJSP199AEQjogZuvXARl11vDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767619; c=relaxed/simple;
	bh=AQWAqGabsNhZY5ovI8XIzKdCWxnSu8H4krinDWdZwlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCNZjJItzcuG2mPZ94Ei7GZR1SDGJ/EIbBWuErzhLd9uC+yHIVQt3BI7XuM0ll7zdZGkeHirIOPSOY/DvF/zNH4nYjar2i4lmtc5Vo7xDc3bpmBrD93DXWSxiOw2IzbVY4TjEGzs/PdjDxxpopzQwe6XKN300YmMEqUw7ZHhOlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2E53gEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2E53gEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818D2C4CEF7;
	Tue, 17 Mar 2026 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767619;
	bh=AQWAqGabsNhZY5ovI8XIzKdCWxnSu8H4krinDWdZwlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2E53gElgKjvBq1+VH6SgeVntV5XuFqlZCswGuENlmSIIQqObxgi364r+cSr4GGnl
	 6PziH1o9oMhlMvN/+KcQod28VaASTr/wL0pA5+8zqdupk20xJOepRM9KFJq3V7FIR7
	 euSTcrnD1nwxJk5f0SYnyIO+WSahAs8FwG7D4c2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 124/333] KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC
Date: Tue, 17 Mar 2026 17:32:33 +0100
Message-ID: <20260317163003.963728962@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,7 +321,7 @@ void avic_init_vmcb(struct vcpu_svm *svm
 	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
-	if (kvm_apicv_activated(svm->vcpu.kvm))
+	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_activate_vmcb(svm);
 	else
 		avic_deactivate_vmcb(svm);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1141,7 +1141,7 @@ static void init_vmcb(struct kvm_vcpu *v
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
 		avic_init_vmcb(svm, vmcb);
 
 	if (vnmi)


