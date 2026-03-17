Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E07B2F744F;
	Tue, 17 Mar 2026 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765959; cv=none; b=tVIy9ry8699uE9x+E9ogKB4xTOazoS/SH027zPXdrI080Vyh9q7E7DrT2LIt9OOOOzH1K95ApuANwX7/kJyAz8BfZ7FgeZZeVMrCsFrgKZD26aU1uU+HjfwcalIFkFz3lwHTFLohHRIHgnCZhncIeMIN52k+7MGiLNcqrTqnMoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765959; c=relaxed/simple;
	bh=1CunbzpgR8o0oJurPq9p773sfRDBEdYAhzYw48IoJ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ghn71RjuahtfCfb9DcgxhIsvPiHmbctXVx6p8gsb6UljxxiVjusmycZIfXKAGGEzgRn9VshfD60SJ8ZWgC2AoOl/gd6N1oDRIkuX+01A1ydI41hhXv+ihbYP7i5M8R4D3738CUChjZ/UHIEag5PMX13espJNV79nidTvXd7W0bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JK2K3yDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JK2K3yDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9729C19424;
	Tue, 17 Mar 2026 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765959;
	bh=1CunbzpgR8o0oJurPq9p773sfRDBEdYAhzYw48IoJ5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JK2K3yDB8/Rcule1lboeQq5mJ8RcgZLuqWNqGpDV6giUnKiNWGmpjcF6gGv5V1WDJ
	 O1GOs5yuRlM64/aCTFJgYjCp0XBssEvTXlAUs5rkzS/5K/XJjvRDjEbv4XOqsGX8/K
	 zJUYNCKbSWiNBRV6OseEAtklZJnOMU25MMebLUGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.19 137/378] KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC
Date: Tue, 17 Mar 2026 17:31:34 +0100
Message-ID: <20260317163012.054403563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -368,7 +368,7 @@ void avic_init_vmcb(struct vcpu_svm *svm
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


