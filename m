Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBA172602;
	Tue, 26 Aug 2025 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212615; cv=none; b=MQjmRqZXwawbvXXIh79sLOgXJRze2et1s+l6SHkWncUkQWL7/Gj2pSInLYT05Gf7FH3ouoFGegzKN8WyDOBi/tnHuq6UeAVmWw1Pueb7hYFMjM8BnY0w1Msu1mLlQLHBVvXOirZZSYI/otpSM8hozJfg8a96Kq7on2S+wpe9228=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212615; c=relaxed/simple;
	bh=Ta13OrJ0tShf94nQ7FQHW2ByMrbvvtXYuerjIt14YPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3lwGJmBCwREa7KnqoBt3sbLqjQNGGiLbjagqOU12uMOQsIREylxw7sbFsv++JmFw7QFhUOfq5PtBd4cThyRH1U0sBubEVpJr4B13HXZNFTeb+grBSn6nq51hH/K39oRR97jEZThme76UysNuoXTVZEFvENPzGbYPBipjJvfmcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmSLZNVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmSLZNVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FADDC116B1;
	Tue, 26 Aug 2025 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212614;
	bh=Ta13OrJ0tShf94nQ7FQHW2ByMrbvvtXYuerjIt14YPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmSLZNVpALYpSNy5L613XkWG3UH2M2+UYt4BPAJ0QyIdGk55DZfdfJtW9pI4afc4W
	 5nNK6eq5Ssfc32jqwqBIm743jsPR+0WAifhIESI/G1aM8zfVzg+hruf7MbCsoZ26AL
	 4sT/yA7cUO6qvULNT3k86EZ0OsvwZ4A6pjMENN2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/587] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
Date: Tue, 26 Aug 2025 13:03:06 +0200
Message-ID: <20250826110953.893876738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 76bce9f10162cd4b36ac0b7889649b22baf70ebd ]

Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
occurs while L2 is active.

Note, commit d39850f57d21 ("KVM: x86: Drop @vcpu parameter from
kvm_x86_ops.hwapic_isr_update()") removed the parameter with the
justification that doing so "allows for a decent amount of (future)
cleanup in the APIC code", but it's not at all clear what cleanup was
intended, or if it was ever realized.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20241128000010.4051275-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: account for lack of kvm_x86_call(), drop vmx/x86_ops.h change]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/lapic.c            | 8 ++++----
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5dfb8cc9616e..5fc89d255550 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1657,7 +1657,7 @@ struct kvm_x86_ops {
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
-	void (*hwapic_isr_update)(int isr);
+	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66c7f2367bb3..cbf85a1ffb74 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -750,7 +750,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(vec);
+		static_call_cond(kvm_x86_hwapic_isr_update)(apic->vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -795,7 +795,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2772,7 +2772,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
-		static_call_cond(kvm_x86_hwapic_isr_update)(-1);
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -3072,7 +3072,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e53620e18925..cde01eb1f5e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6834,7 +6834,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	kvm_release_pfn_clean(pfn);
 }
 
-static void vmx_hwapic_isr_update(int max_isr)
+static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	u16 status;
 	u8 old;
-- 
2.50.1



