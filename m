Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588B51A6192;
	Tue, 30 Jul 2024 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359136; cv=none; b=LdRUMQyhN4yLgODq1CM5JioYGqf26s15/Q+c36nDiD7ChtdTCDzTUuFDviFwFvJgRulDP0S0AeGzKp6LphUo8kMzn7iUJZa5KufgzXko2I6tzFy18TDw8KYU/HNWHglFUkg2I9BxaVORMuA3PZPqLdfnZU7N2XPHt8//zxQw5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359136; c=relaxed/simple;
	bh=coh/iGgDO0f/42m29oDdeuwmQHtACBWYiQgowOXfD84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPQZcWgc7rZWDl6zO+rbdcI5/0jixMhnH98ZaMcaMjB1mtpDWURMJ4D/uEPcDM+4y844RgnuxHfUL+G6yhTGXrxBEfdbuBGQ9sAX54mvYPRmw40lWD9hbfieGUPIPApONOV5IMlKsAjtQdj24EbXc8OZwiTGkLC3DD+CzPJMESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPqB52kU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPqB52kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3A4C32782;
	Tue, 30 Jul 2024 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359136;
	bh=coh/iGgDO0f/42m29oDdeuwmQHtACBWYiQgowOXfD84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPqB52kUC43uEOf5ARgwoe+k9YYeOHke5jdMSpPhByN9XBaRegnp6upT32AIlNsDr
	 yOToshxFhZJIaIhd4ZQXAuDjZeGjT5ds7DTyyrLNHFE3t3iIXwNhV7QUdnM+okJbcJ
	 G1jPtbmG0Ajryx2Kv3HyvrTknxbmxN0EzpglN200=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 415/568] KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
Date: Tue, 30 Jul 2024 17:48:42 +0200
Message-ID: <20240730151656.093389952@linuxfoundation.org>
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
@@ -5048,14 +5048,19 @@ static int vmx_nmi_allowed(struct kvm_vc
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
@@ -400,6 +400,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);


