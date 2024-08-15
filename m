Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8501494C5;
	Thu, 15 Aug 2024 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729865; cv=none; b=usRigqksiLaPAsUjGL6+PAuNRmRgXQV0u2boFf4peWD17+SRtNKHnWeSnFGV4S5rtQ5jo5SugIibywCVXghgb85RFioQN3aXKRD4Zd9N6tzBCPFMD+eskYUaG32w2FIUYXTO2kuZEuWLtfR9OmEZQQQrfZgzEA/fGpfRYQ7XAZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729865; c=relaxed/simple;
	bh=NrCMUxYYHGlIdVkdzxNcxKJg3Q2pEYM2Yi4+Xg3VR+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXtzVIPVLPYyF/CuXEZ/VJcBplFW7VuY9g7JsM8T6HLyQP7boGruucqg8s1L4r71AcCMF6oEMFb5j5qI3pNGcjM3ivad1DS16bGo8xNxTUez6kh7R9PTadeNH4qY/QCaGcSnSiUZiIMt9Z38y4MdWaKyBxqU7rlAxx0IolTljwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVmHsTNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVmHsTNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A08C32786;
	Thu, 15 Aug 2024 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729865;
	bh=NrCMUxYYHGlIdVkdzxNcxKJg3Q2pEYM2Yi4+Xg3VR+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVmHsTNjRvgP3S34ybzWQODQLrE5sGEArBdFYWpsc4ohoBxUH0M29/AE0LFZM29FT
	 rnTJpLXrQM7tKqpkd6bGcmstU4c1wDM56ksfsh6xciCQb/9XidqhM89sDpbamsFN9O
	 hqhsp+TpsXPjxqa5isrSYw/r7qMoIl3KyIXYkgAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 200/484] KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
Date: Thu, 15 Aug 2024 15:20:58 +0200
Message-ID: <20240815131949.136529701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4706,14 +4706,19 @@ static int vmx_nmi_allowed(struct kvm_vc
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
 
 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -388,6 +388,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);


