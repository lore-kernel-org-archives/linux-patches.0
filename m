Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E661A76A1;
	Tue, 30 Jul 2024 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360182; cv=none; b=IROzayMom57bFEkcectSDF9MrXvvR1Wp2iLZxV9RYAJ2N3Muu22oKLdiaCIAW3R8K0Ou30kGcI8f7sUyWwiLYotzbmEMupCPx0qEBtS3eHAB1KRKJzult/NCSRLJp9CjlEEXJq8fAIqoWdZWwgcqA+WRUxZKpI+TtlaqaW/qvls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360182; c=relaxed/simple;
	bh=SFmNJp3ug2FsIzR1B+DY7EIb++L4pLncWhMNGd+OQwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oti2NbtmpO5sA8MxSyxrTx5h7fysidv3CoJrw1ARZ3pG5YPeT1/ESBrS2w9kK+1BqFh7FyhC7nIBlBPPYL5sZUyf1N7EyrY3LGRFrbLAXX+xh1L4uQi4l+trb09m5zWH8BIKr7RbaNPRtsCGmTb8MwMame1xJxZOCnUThAZ1g+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAlopz+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAlopz+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8815AC32782;
	Tue, 30 Jul 2024 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360182;
	bh=SFmNJp3ug2FsIzR1B+DY7EIb++L4pLncWhMNGd+OQwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAlopz+6tTQZ5w5/WKAj419G32EP50AbxDjH9hCPtjPmMETSK+6oXHkoKYG6yZd/u
	 K13Leyspl//rSRxKU1N0wQbLlwqS76FWDf7PtPEhwBC6hlXGqAB41aYwDvY5YrnhsA
	 edjbMKBSzFFL/vhY0HSPlwMMh8eOvTBVDKAW/+us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.10 620/809] KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
Date: Tue, 30 Jul 2024 17:48:16 +0200
Message-ID: <20240730151749.331261330@linuxfoundation.org>
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

commit 322a569c4b4188a0da2812f9e952780ce09b74ba upstream.

Move the non-VMX chunk of the "interrupt blocked" checks to a separate
helper so that KVM can reuse the code to detect if interrupts are blocked
for L2, e.g. to determine if a virtual interrupt _for L2_ is a valid wake
event.  If L1 disables HLT-exiting for L2, nested APICv is enabled, and L2
HLTs, then L2 virtual interrupts are valid wake events, but if and only if
interrupts are unblocked for L2.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240607172609.3205077-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   11 ++++++++---
 arch/x86/kvm/vmx/vmx.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5052,14 +5052,19 @@ int vmx_nmi_allowed(struct kvm_vcpu *vcp
 	return !vmx_nmi_blocked(vcpu);
 }
 
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
+{
+	return !(vmx_get_rflags(vcpu) & X86_EFLAGS_IF) ||
+	       (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
+}
+
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
 		return false;
 
-	return !(vmx_get_rflags(vcpu) & X86_EFLAGS_IF) ||
-	       (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
+	return __vmx_interrupt_blocked(vcpu);
 }
 
 int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -406,6 +406,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);


