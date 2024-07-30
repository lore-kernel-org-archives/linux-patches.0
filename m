Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B104B183CD5;
	Tue, 30 Jul 2024 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357679; cv=none; b=G7mIfoUzss7MiA1aYzKk/grOxWMgL6pT7VmGxofsV/i7dmZ+F0IM6988D7AW9PeVk6ocLjZ5DTy19z0t21tKANOdOlKfas9hvmOayvVMkNRyOQ4DX3bBg7eCdAc4rFNflH8tZ6RkShWgjTEDttDwu5+2ouuNgMCkQnYW5RU93wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357679; c=relaxed/simple;
	bh=+caJ2JWR7urpEHEBsXA2ZHg17lbcFsmKI+dKilw4UWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOKLQiHGqc3ctl+ABA0+mXG0F/svdecQDkbggmUZPIKucynTd9XRXNQ+O+IW3/F/DU/DQGi+EmPbd3JO2kKXOA9Dkd9ZQKuBElKOTYxqzFK0jZS3YY5UkrIZUmrKUR/0xhQMJ0dmbuXL95Wb7Ji4BUFNI4iSrIzZNGbfzfBUMxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0QMYioj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0QMYioj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340DEC32782;
	Tue, 30 Jul 2024 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357679;
	bh=+caJ2JWR7urpEHEBsXA2ZHg17lbcFsmKI+dKilw4UWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0QMYiojXVbDI6CYUl2X944CtcFQydTtq27JV54pvMDD3bULuPHYiGb6BlUnil9zC
	 QEA2qayEjyvzrGQyGNB3sypq2ELid5E6UjRtTmk/8e8+65WbolRXeVEOlA1CQMi1x2
	 hq27ckNPTjy4XUI9mGvQlrDOvRLidKIQ5FHlXGlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 315/440] KVM: nVMX: Request immediate exit iff pending nested event needs injection
Date: Tue, 30 Jul 2024 17:49:08 +0200
Message-ID: <20240730151628.125542613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 32f55e475ce2c4b8b124d335fcfaf1152ba977a1 upstream.

When requesting an immediate exit from L2 in order to inject a pending
event, do so only if the pending event actually requires manual injection,
i.e. if and only if KVM actually needs to regain control in order to
deliver the event.

Avoiding the "immediate exit" isn't simply an optimization, it's necessary
to make forward progress, as the "already expired" VMX preemption timer
trick that KVM uses to force a VM-Exit has higher priority than events
that aren't directly injected.

At present time, this is a glorified nop as all events processed by
vmx_has_nested_events() require injection, but that will not hold true in
the future, e.g. if there's a pending virtual interrupt in vmcs02.RVI.
I.e. if KVM is trying to deliver a virtual interrupt to L2, the expired
VMX preemption timer will trigger VM-Exit before the virtual interrupt is
delivered, and KVM will effectively hang the vCPU in an endless loop of
forced immediate VM-Exits (because the pending virtual interrupt never
goes away).

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240607172609.3205077-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/vmx/nested.c       |    2 +-
 arch/x86/kvm/x86.c              |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1651,7 +1651,7 @@ struct kvm_x86_nested_ops {
 	bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
 				    u32 error_code);
 	int (*check_events)(struct kvm_vcpu *vcpu);
-	bool (*has_events)(struct kvm_vcpu *vcpu);
+	bool (*has_events)(struct kvm_vcpu *vcpu, bool for_injection);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3934,7 +3934,7 @@ static bool nested_vmx_preemption_timer_
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
-static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	return nested_vmx_preemption_timer_pending(vcpu) ||
 	       to_vmx(vcpu)->nested.mtf_pending;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10131,7 +10131,7 @@ static int kvm_check_and_inject_events(s
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, true))
 		*req_immediate_exit = true;
 
 	/*
@@ -13013,7 +13013,7 @@ static inline bool kvm_vcpu_has_events(s
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, false))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))


