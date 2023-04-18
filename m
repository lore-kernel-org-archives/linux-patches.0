Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C02566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B86BC433D2;
	Tue, 18 Apr 2023 12:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820846;
	bh=d+1+j25dYCJGzNpfzeYx0GOT7AUi3FP7DXwjglfAOCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DI1gq0XmKa+GgCAQAxz3Fs30DUx5czxiVI1QqtMwdDu6kxt/u0O/jzajfMeUoQTG8
	 IAVIF9cOS3fcrL0lxUvD+gTGI+zhzHSrw3ixMFyAoBhdOcm5IOoJ+Dzkc2m+Jv9+cu
	 BRUTqch0+UGZHhdiPgD+E5s5TMmdhAJhwdg8qDyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 54/57] KVM: nVMX: add missing consistency checks for CR0 and CR4
Date: Tue, 18 Apr 2023 14:21:54 +0200
Message-Id: <20230418120300.621452323@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

commit 112e66017bff7f2837030f34c2bc19501e9212d5 upstream.

The effective values of the guest CR0 and CR4 registers may differ from
those included in the VMCS12.  In particular, disabling EPT forces
CR4.PAE=1 and disabling unrestricted guest mode forces CR0.PG=CR0.PE=1.

Therefore, checks on these bits cannot be delegated to the processor
and must be performed by KVM.

Reported-by: Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: drop CC() macro calls, as tracing is not implemented in 4.19]
[OP: adjust "return -EINVAL" -> "return 1" to match current return logic]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -12752,7 +12752,7 @@ static int nested_vmx_check_vmcs_link_pt
 static int check_vmentry_postreqs(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 				  u32 *exit_qual)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*exit_qual = ENTRY_FAIL_DEFAULT;
 
@@ -12765,6 +12765,13 @@ static int check_vmentry_postreqs(struct
 		return 1;
 	}
 
+	if ((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG)
+		return 1;
+
+	if ((ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
+	    (ia32e && !(vmcs12->guest_cr0 & X86_CR0_PG)))
+		return 1;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -12776,7 +12783,6 @@ static int check_vmentry_postreqs(struct
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer) ||
 		    ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA) ||
 		    ((vmcs12->guest_cr0 & X86_CR0_PG) &&


