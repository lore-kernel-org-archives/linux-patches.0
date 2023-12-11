Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82BCE548;
	Mon, 11 Dec 2023 18:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nniEBUdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70054C433C8;
	Mon, 11 Dec 2023 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321199;
	bh=Cy6THxsgEmHSDfpNvutcUY/pyWrglPpUn3fIkSGkYD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nniEBUdbnH3iEJS2qZ+wX4LKerK/WR8simWYtZSj/PciIBaY93HrpqJJMGPpqCv0R
	 gYNRpt6Ji37JaLLQYAYOcVlC16tqhk1rcD5VzXq9ccLW7UopYtbVVGWTQUCF+hEOxC
	 zh7+LcZGzRVcRGy3NcwnbaLpm2jHv2Kfhfekl6NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Gonda <pgonda@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 134/141] KVM: SVM: Update EFER software model on CR0 trap for SEV-ES
Date: Mon, 11 Dec 2023 19:23:13 +0100
Message-ID: <20231211182032.367564244@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

commit 4cdf351d3630a640ab6a05721ef055b9df62277f upstream.

In general, activating long mode involves setting the EFER_LME bit in
the EFER register and then enabling the X86_CR0_PG bit in the CR0
register. At this point, the EFER_LMA bit will be set automatically by
hardware.

In the case of SVM/SEV guests where writes to CR0 are intercepted, it's
necessary for the host to set EFER_LMA on behalf of the guest since
hardware does not see the actual CR0 write.

In the case of SEV-ES guests where writes to CR0 are trapped instead of
intercepted, the hardware *does* see/record the write to CR0 before
exiting and passing the value on to the host, so as part of enabling
SEV-ES support commit f1c6366e3043 ("KVM: SVM: Add required changes to
support intercepts under SEV-ES") dropped special handling of the
EFER_LMA bit with the understanding that it would be set automatically.

However, since the guest never explicitly sets the EFER_LMA bit, the
host never becomes aware that it has been set. This becomes problematic
when userspace tries to get/set the EFER values via
KVM_GET_SREGS/KVM_SET_SREGS, since the EFER contents tracked by the host
will be missing the EFER_LMA bit, and when userspace attempts to pass
the EFER value back via KVM_SET_SREGS it will fail a sanity check that
asserts that EFER_LMA should always be set when X86_CR0_PG and EFER_LME
are set.

Fix this by always inferring the value of EFER_LMA based on X86_CR0_PG
and EFER_LME, regardless of whether or not SEV-ES is enabled.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Reported-by: Peter Gonda <pgonda@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210507165947.2502412-2-seanjc@google.com>
[A two year old patch that was revived after we noticed the failure in
 KVM_SET_SREGS and a similar patch was posted by Michael Roth.  This is
 Sean's patch, but with Michael's more complete commit message. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1750,15 +1750,17 @@ void svm_set_cr0(struct kvm_vcpu *vcpu,
 	bool old_paging = is_paging(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
+	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
-			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
+			if (!vcpu->arch.guest_state_protected)
+				svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
 		}
 
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer &= ~EFER_LMA;
-			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
+			if (!vcpu->arch.guest_state_protected)
+				svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
 		}
 	}
 #endif


