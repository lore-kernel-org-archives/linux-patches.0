Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FCB210FB;
	Thu, 15 Aug 2024 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732395; cv=none; b=rbQj0skUTt0DNWR2iZy51GxQvpvFpFtv6ao6VSKdAR7s03Frh96QcJArQlUFDA0ghhnYRB19035J1S2OYrXoRpW2Q5zXQwtc5Ub4b2nvcb3ZKrOj5FHATw5H6juxVuW+gFL+ImV4f7iUmIoLxqLblpZSza14QaKRLfb2KrsnGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732395; c=relaxed/simple;
	bh=FQoOMVlUAkGOOOS4mVGh89vjlu8SobWj8s4btPUIX34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAu8aeLDXKpryDo37PxSOU0Y05eT5iV0vBG+5KMmjXbAB++rDIok/UacajA29BQ80noa9ssZgyFWBN4E1fzTvgoEvLzEBxIyr4qAWBEzZ/HRsPDlGUTBkjc1TXOk5AQe+HcChWnqlCDgn58qEPOahT7KoDBt1XyoSkAzb/yalvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CL/v4ddD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CL/v4ddD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1CFC32786;
	Thu, 15 Aug 2024 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732395;
	bh=FQoOMVlUAkGOOOS4mVGh89vjlu8SobWj8s4btPUIX34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CL/v4ddDTmW2aXJTk44fcw2l+hRD6rt5B653jjxgebq9lLlmQFhtXmF9ZacHLJ59U
	 H1/orU62A+NN9XPHDMwnms+sDhwmzklcgcBMerza5WWhFcvTUbuHvHdCh8+sHfigRF
	 b3E+GfaBUF1aPAPTpBrmpXQPNterRKfJmsqJZ3AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 149/352] KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
Date: Thu, 15 Aug 2024 15:23:35 +0200
Message-ID: <20240815131925.024949998@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4738,14 +4738,19 @@ static int vmx_nmi_allowed(struct kvm_vc
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
@@ -359,6 +359,7 @@ bool vmx_guest_inject_ac(struct kvm_vcpu
 void update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);


