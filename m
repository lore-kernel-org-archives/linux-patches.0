Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AAD4C83
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC01C433F1;
	Mon, 16 Jan 2023 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886791;
	bh=xjQYmfARQnJY1+jSGLas8jXFQIn/IjZC7ndNe5304iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsX+4XgxbVxEYa8DycCrNaXgetrr3dx6wLdkDW/2fyJcUOJtm2BUIqbDN6RPiPwgS
	 3H+/lzsgOrSJ85iRGcGuxj1bitr2dDhwO3wNX0CwT1bSj6pLWmyoMfck1qR5U4FzrQ
	 QeFRo6TQzR4x4y30sZXGJk9xwZZwGFkGAObFzBbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Arcangeli <aarcange@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 546/658] KVM: x86: optimize more exit handlers in vmx.c
Date: Mon, 16 Jan 2023 16:50:34 +0100
Message-Id: <20230116154934.508827223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Arcangeli <aarcange@redhat.com>

[ Upstream commit f399e60c45f6b6e6ad6dfcedff1dd6386e086b0b ]

Eliminate wasteful call/ret non RETPOLINE case and unnecessary fentry
dynamic tracing hooking points.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 31de69f4eea7 ("KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 52f024eeac3d..0fae9b448ab9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4802,7 +4802,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int handle_external_interrupt(struct kvm_vcpu *vcpu)
+static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
 	return 1;
@@ -5074,21 +5074,6 @@ static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmcs_writel(GUEST_DR7, val);
 }
 
-static int handle_cpuid(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_cpuid(vcpu);
-}
-
-static int handle_rdmsr(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_rdmsr(vcpu);
-}
-
-static int handle_wrmsr(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_wrmsr(vcpu);
-}
-
 static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 {
 	kvm_apic_update_ppr(vcpu);
@@ -5105,11 +5090,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_halt(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_halt(vcpu);
-}
-
 static int handle_vmcall(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_hypercall(vcpu);
@@ -5657,11 +5637,11 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
 	[EXIT_REASON_CR_ACCESS]               = handle_cr,
 	[EXIT_REASON_DR_ACCESS]               = handle_dr,
-	[EXIT_REASON_CPUID]                   = handle_cpuid,
-	[EXIT_REASON_MSR_READ]                = handle_rdmsr,
-	[EXIT_REASON_MSR_WRITE]               = handle_wrmsr,
+	[EXIT_REASON_CPUID]                   = kvm_emulate_cpuid,
+	[EXIT_REASON_MSR_READ]                = kvm_emulate_rdmsr,
+	[EXIT_REASON_MSR_WRITE]               = kvm_emulate_wrmsr,
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
-	[EXIT_REASON_HLT]                     = handle_halt,
+	[EXIT_REASON_HLT]                     = kvm_emulate_halt,
 	[EXIT_REASON_INVD]		      = handle_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
 	[EXIT_REASON_RDPMC]                   = handle_rdpmc,
-- 
2.35.1



