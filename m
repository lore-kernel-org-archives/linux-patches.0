Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A92283A17;
	Tue, 30 Jul 2024 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358980; cv=none; b=WZ4RJFFNs7chMbqnh76cXKJ3sHj1VVBBH16/x58c04THySE8BXBxyEN5lH6katpdjjJObgB+BA1MdEEUDPNknSFqMWsTl3bqGdIPyLZ9e532ePpt1I21xVljJtQF2xYwH63XMX/cibGadDUZLhTUMjCvTMWgJmQbMG+m+e3ppRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358980; c=relaxed/simple;
	bh=LaiDfFqcl40I3B0D0o3COPR2D65F3gGPWhoj3ZM1pnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+MMJvspRYQi63PtEWwevdskd8y9asPl6hj+rnb1PfPUhjcg66DEZ3Tskoa0vOTEKPlSvv0hbXeE+VRJwFM7t11r7VEbAHAqdYDlLMGztHIWbuoNUYIgRpmfXH45JPZtuKKPI3mC/Drq2vLBOeHilra1zPXmbfF6bVrwGFqQedM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4HYKJqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4HYKJqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08167C32782;
	Tue, 30 Jul 2024 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358980;
	bh=LaiDfFqcl40I3B0D0o3COPR2D65F3gGPWhoj3ZM1pnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4HYKJqILO52ASpRoaRT5LvjqWFYJ8uITcj46h2PgloqxG2ryZcS/vE0W7Ci3DmfM
	 w6Is2FmU9Y91sVvMs53Vj+WJq0r6B48jvAG7MKbE1OIMDbdkCokM9cG2/WcgMzgvUE
	 9ainx1Mhu/V8oIhCJ8Hy/IyHeZvaVwaNLdbWOyA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 416/568] KVM: nVMX: Request immediate exit iff pending nested event needs injection
Date: Tue, 30 Jul 2024 17:48:43 +0200
Message-ID: <20240730151656.131347569@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1758,7 +1758,7 @@ struct kvm_x86_nested_ops {
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
@@ -3962,7 +3962,7 @@ static bool nested_vmx_preemption_timer_
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
-static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	return nested_vmx_preemption_timer_pending(vcpu) ||
 	       to_vmx(vcpu)->nested.mtf_pending;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10254,7 +10254,7 @@ static int kvm_check_and_inject_events(s
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, true))
 		*req_immediate_exit = true;
 
 	/*
@@ -12882,7 +12882,7 @@ static inline bool kvm_vcpu_has_events(s
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, false))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))


