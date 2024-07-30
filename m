Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C971A6192;
	Tue, 30 Jul 2024 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357668; cv=none; b=H+9JX5dOxOAJmqVh7yC28mYxMrn9nQFWW66/DkA9XwV/meIH70Zm/ZMazCwaaoAHp/eFw93wQ7MKxOmVs7kcpnDHwSKpRyjKZyoD3fv9hrwjJXbojv3uSSyep0lpkpAhyPR1AZs1dkmjVy404Fu4Cc2pwCyuJSvLLj0bENqHHqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357668; c=relaxed/simple;
	bh=REUe+d+nsFVOK1M54qt+idNYA6RMTHSsuR660kw6Kcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzovzC24T0ZUGqfF6L6zZg5WY5Vmycar9d6aXoYXTDsyj2Sfn4n0hh8sw95Qb5yRDomSVxO4NvJQ4LUJUyhniFcdCUEZTlgLvqQy8kUY4goiJJbvplJXrwclAnVJZLjgE4SShBQp+wFI1JQmSaRxCDfuwBwbpzOL82K2UUn09uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNemjpMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNemjpMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC2DC32782;
	Tue, 30 Jul 2024 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357668;
	bh=REUe+d+nsFVOK1M54qt+idNYA6RMTHSsuR660kw6Kcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNemjpMfrSX8aTIaF0EiTuLf4gon3n/NSssj0u5BiBZgiocIAeHmWEcGGtIMRSq5d
	 PhTiijJfWdMHFeKZh6hN/kr7FDEEmzmkSQgsal+gOSHP+qqzSpfpHYZ2JzqaW9Ymko
	 Y0d4fbzWjRnRkrHNL7NN1Ait5mT5n9bnLFP+jLwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 314/440] KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
Date: Tue, 30 Jul 2024 17:49:07 +0200
Message-ID: <20240730151628.086979627@linuxfoundation.org>
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
@@ -4980,14 +4980,19 @@ static int vmx_nmi_allowed(struct kvm_vc
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
@@ -413,6 +413,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);


