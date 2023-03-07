Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA97BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E920BC433D2;
	Tue,  7 Mar 2023 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211430;
	bh=LHBUekxiZsO/KNw8HvEnInJHDZhQ4nN6HtA2I1XcErw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFKQI9OZhsS1gyCNkz9Jv2wvr9QreqXgrxas4zitJdvRiIlj28Ln/8zDChnXY0InH
	 pFADt2YyE0h/VR5baIJVSGTTavlbopmpKWkLcfDil01BkngNRGb6Q1gViZM7Vf9oxo
	 5vXOLgPLEU1gvE/MhWVF6B0ZeangJNYgz7MJlV5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 6.2 0828/1001] KVM: SVM: Flush the "current" TLB when activating AVIC
Date: Tue,  7 Mar 2023 18:00:00 +0100
Message-Id: <20230307170057.700953747@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 0ccf3e7cb95a2db8ddb2a44812037ffba8166dc9 upstream.

Flush the TLB when activating AVIC as the CPU can insert into the TLB
while AVIC is "locally" disabled.  KVM doesn't treat "APIC hardware
disabled" as VM-wide AVIC inhibition, and so when a vCPU has its APIC
hardware disabled, AVIC is not guaranteed to be inhibited.  As a result,
KVM may create a valid NPT mapping for the APIC base, which the CPU can
cache as a non-AVIC translation.

Note, Intel handles this in vmx_set_virtual_apic_mode().

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20230106011306.85230-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vc
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
+		/*
+		 * Flush the TLB, the guest may have inserted a non-APIC
+		 * mapping into the TLB while AVIC was disabled.
+		 */
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
+
 		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */


