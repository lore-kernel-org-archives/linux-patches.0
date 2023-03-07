Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3ABA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613CDC433D2;
	Tue,  7 Mar 2023 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211342;
	bh=UOWIIVLPcOJm+oyAXP948aROb1ce6Dv0PVEYvTMKTFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1gO5yZFszZkvWHNNQmdH0dKJ9lPxJxI2P+kFGpKphSc4Solmb2l9vyna4X0u1iNI
	 glmel7J8lxngBeZBY/h6IPO5CBbMBXgDmSnimlEDCpDjlR3G+lXt10TZDAxDGRYTBF
	 NJio0UnS1YERHEFdfBGjWdeZQyYGGneicZJkLdYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.2 0824/1001] KVM: x86: Purge "highest ISR" cache when updating APICv state
Date: Tue,  7 Mar 2023 17:59:56 +0100
Message-Id: <20230307170057.507724364@linuxfoundation.org>
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

commit 97a71c444a147ae41c7d0ab5b3d855d7f762f3ed upstream.

Purge the "highest ISR" cache when updating APICv state on a vCPU.  The
cache must not be used when APICv is active as hardware may emulate EOIs
(and other operations) without exiting to KVM.

This fixes a bug where KVM will effectively block IRQs in perpetuity due
to the "highest ISR" never getting reset if APICv is activated on a vCPU
while an IRQ is in-service.  Hardware emulates the EOI and KVM never gets
a chance to update its cache.

Fixes: b26a695a1d78 ("kvm: lapic: Introduce APICv update helper function")
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230106011306.85230-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2429,6 +2429,7 @@ void kvm_apic_update_apicv(struct kvm_vc
 		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -2484,7 +2485,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vc
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -2772,7 +2772,6 @@ int kvm_apic_set_state(struct kvm_vcpu *
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));


