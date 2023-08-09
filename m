Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5338417AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7644BC433C7;
	Wed,  9 Aug 2023 11:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581066;
	bh=sGfr9qVlXBCbSwrRZvXj7sy5R6dx9c9NxFyxmVNElJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUyFP9LOttYKHB4mWeyDRg9v2SZxUfXwl1yYr/NvWENNnH/OXXWqakiAP0oXK37TG
	 gIQZkc1QAxIL9njir5wUBWe1CoCp+F7J5GoiN7+OOybJEiekRd9KbFKnZGBjMPA9y7
	 DHPZbL/c9jJ3WKy52hBaizT/oAqfcW2kbZFmFtYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/201] KVM: VMX: Invert handling of CR0.WP for EPT without unrestricted guest
Date: Wed,  9 Aug 2023 12:41:36 +0200
Message-ID: <20230809103646.962841888@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

[ Upstream commit ee5a5584cba316bc90bc2fad0c6d10b71f1791cb ]

Opt-in to forcing CR0.WP=1 for shadow paging, and stop lying about WP
being "always on" for unrestricted guest.  In addition to making KVM a
wee bit more honest, this paves the way for additional cleanup.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210713163324.627647-22-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: c4abd7352023 ("KVM: VMX: Don't fudge CR0 and CR4 for restricted L2 guest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9aedc7b06da7a..574acfa98fa9b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -135,8 +135,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
-	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | 	\
-	 X86_CR0_WP | X86_CR0_PG | X86_CR0_PE)
+	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
 
 #define KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR4_VMXE
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
@@ -3064,9 +3063,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
-static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
-					unsigned long cr0,
-					struct kvm_vcpu *vcpu)
+static void ept_update_paging_mode_cr0(unsigned long cr0, struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -3085,9 +3082,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	}
-
-	if (!(cr0 & X86_CR0_WP))
-		*hw_cr0 &= ~X86_CR0_WP;
 }
 
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
@@ -3100,6 +3094,8 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else {
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
+		if (!enable_ept)
+			hw_cr0 |= X86_CR0_WP;
 
 		if (vmx->rmode.vm86_active && (cr0 & X86_CR0_PE))
 			enter_pmode(vcpu);
@@ -3118,7 +3114,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 
 	if (enable_ept && !is_unrestricted_guest(vcpu))
-		ept_update_paging_mode_cr0(&hw_cr0, cr0, vcpu);
+		ept_update_paging_mode_cr0(cr0, vcpu);
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0, hw_cr0);
-- 
2.40.1



