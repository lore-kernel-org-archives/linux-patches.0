Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D0FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F14C433EF;
	Mon, 15 May 2023 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170183;
	bh=/8PdVh+BUwh3rmthoLjTGELpaX8ZcEQsrIeFgrBAu+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM/y3vj89Jxs9ui8GVRYopdWyW7X18rsEDAV7a7qOqQV1JjDDe3yMZ8LdJZOGtjZ7
	 8iK2xWG9dsTSKMs6byYHi16JHxO+RLo86f8sCCyqnHgRuP7/CHT4tcVqobhvNzD6n/
	 utAa8Hom4aJwzaibo6QOaVpjG6+JG4ZWLik97bSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/239] KVM: VMX: Make CR0.WP a guest owned bit
Date: Mon, 15 May 2023 18:24:46 +0200
Message-Id: <20230515161722.283075952@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Krause <minipli@grsecurity.net>

[ Upstream commit fb509f76acc8d42bed11bca308404f81c2be856a ]

Guests like grsecurity that make heavy use of CR0.WP to implement kernel
level W^X will suffer from the implied VMEXITs.

With EPT there is no need to intercept a guest change of CR0.WP, so
simply make it a guest owned bit if we can do so.

This implies that a read of a guest's CR0.WP bit might need a VMREAD.
However, the only potentially affected user seems to be kvm_init_mmu()
which is a heavy operation to begin with. But also most callers already
cache the full value of CR0 anyway, so no additional VMREAD is needed.
The only exception is nested_vmx_load_cr3().

This change is VMX-specific, as SVM has no such fine grained control
register intercept control.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-7-minipli@grsecurity.net
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v6.1.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/kvm_cache_regs.h |  2 +-
 arch/x86/kvm/vmx/nested.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c        |  2 +-
 arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3febc342360cc..896cc73949442 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -4,7 +4,7 @@
 
 #include <linux/kvm_host.h>
 
-#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
+#define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8e56ec6e72e9d..9d683b6067c7b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4460,7 +4460,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
 	 * (KVM doesn't change it);
 	 */
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs12->host_cr0);
 
 	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
@@ -4611,7 +4611,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
 
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
 
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4984357c5d441..07aab85922441 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4695,7 +4695,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
-	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
 
 	set_cr4_guest_host_mask(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea456..e2b04f4c0fef3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -640,6 +640,24 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 				(1 << VCPU_EXREG_EXIT_INFO_1) | \
 				(1 << VCPU_EXREG_EXIT_INFO_2))
 
+static inline unsigned long vmx_l1_guest_owned_cr0_bits(void)
+{
+	unsigned long bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+
+	/*
+	 * CR0.WP needs to be intercepted when KVM is shadowing legacy paging
+	 * in order to construct shadow PTEs with the correct protections.
+	 * Note!  CR0.WP technically can be passed through to the guest if
+	 * paging is disabled, but checking CR0.PG would generate a cyclical
+	 * dependency of sorts due to forcing the caller to ensure CR0 holds
+	 * the correct value prior to determining which CR0 bits can be owned
+	 * by L1.  Keep it simple and limit the optimization to EPT.
+	 */
+	if (!enable_ept)
+		bits &= ~X86_CR0_WP;
+	return bits;
+}
+
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_vmx, kvm);
-- 
2.39.2



