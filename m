Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825531A76B4;
	Tue, 30 Jul 2024 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360188; cv=none; b=Jn8QYgwbnJHni1ueNx+qbEKrqCyQBIChgE/eVdyBn812vWaYJW+WIBPqo2YkiD6MfSaDdcjkSMcQI4Jq/Nr75fhvCNdzlxR6dWWJHfUyD98daFpcjrum9inJ+A9ftpNsqKe7dGsWQuHnGIs2ZBxgcm0kaZRIoBm/24ExfQkDuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360188; c=relaxed/simple;
	bh=SKuT1tWdaY00XBNp49SPcpsKsVKeMmo6fs0UQv5P4yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M07azdUjPGqmJKMWaAt2GRaEhszxc1j63LTH+p0BHKQvmAu+MDO2IdBKwHaounX/sOUQ5zMvpDacJH03BC0kChi3lNOdmgHjYgAUZB8UR+EpaZCZ30YNqFlbsY4gufNdrdU8SJOt3Ho9mtcbT/qD4BbWeg5BVDTwZMPZVinzsvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s18RgRbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s18RgRbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC00C32782;
	Tue, 30 Jul 2024 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360188;
	bh=SKuT1tWdaY00XBNp49SPcpsKsVKeMmo6fs0UQv5P4yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s18RgRbqKYlaDJXOq2UQXj8Nh7OSPsVGzZhe6ZIeB3S9xq48KCSJUtGrkjbVoJjPD
	 CeCy1nio1IOhLiJOILAO1VzpZNFPll3IW0H4XJ4nPLQqKU0w2MXOdkDDlGu+gs31sr
	 Yly3gUv8pcBEGttgmUaXY5Fs17uVfcE3wShh/22s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.10 622/809] KVM: nVMX: Request immediate exit iff pending nested event needs injection
Date: Tue, 30 Jul 2024 17:48:18 +0200
Message-ID: <20240730151749.409334062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1819,7 +1819,7 @@ struct kvm_x86_nested_ops {
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
@@ -4032,7 +4032,7 @@ static bool nested_vmx_preemption_timer_
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
-static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	return nested_vmx_preemption_timer_pending(vcpu) ||
 	       to_vmx(vcpu)->nested.mtf_pending;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10516,7 +10516,7 @@ static int kvm_check_and_inject_events(s
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, true))
 		*req_immediate_exit = true;
 
 	/*
@@ -13146,7 +13146,7 @@ static inline bool kvm_vcpu_has_events(s
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, false))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))


