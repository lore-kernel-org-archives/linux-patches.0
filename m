Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12821345;
	Mon, 24 Feb 2025 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408292; cv=none; b=FlQeEX5kyVTXmjyHwhnPH5k/6PF+cUFGyN/sunvozGDpdQFwj97PQ4HiHd51L13lTx8ukzJwGdLPX6shGNHlXxyWkUO8i8V9FQ5eM9XYvg6naB18Qb9/6Vi0EnlXpb6D1UXYLhCFiR4FTqy8v57v7zgrcgjryy3E9eOFHno8fJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408292; c=relaxed/simple;
	bh=0DNtuYuCETJRXznZl4hKBA3PTiEC9LYADQmkWAvNVLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvHyWy+oW6la1Plu99By55GGD0+UvByMrU9sei1tzKz/0RpVAjWLYthcUKSIK7X3fc+Q3KdDFr1mdCZJodAq2b+jjTlqTy/BrCnCEFKrh0RlM36iAr6UA2tfBfxzSmf6XmzByTUWyDrj5imVGFH2E7Q3t0PPAFcRIz5EC2Muuzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPE44Nsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPE44Nsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7290AC4CED6;
	Mon, 24 Feb 2025 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408291;
	bh=0DNtuYuCETJRXznZl4hKBA3PTiEC9LYADQmkWAvNVLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPE44NswJfIIpe7VNbCBavU409zeyBRRyifKrCQWhslCnIJWWpOrkFCy/y3PsqsCA
	 0SJAvEmlrV1RU17dmtpdFXOXermEcwuPsWSHoy3iBQlzwL8WQYkicb3PT8gg//WOME
	 jNfzVOJ6SCIMfSRU04mz/JQKwdl2UIec9F1z6Jgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/154] KVM: x86: Get vcpu->arch.apic_base directly and drop kvm_get_apic_base()
Date: Mon, 24 Feb 2025 15:33:34 +0100
Message-ID: <20250224142607.677657994@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d91060e342a66b52d9bd64f0b123b9c306293b76 ]

Access KVM's emulated APIC base MSR value directly instead of bouncing
through a helper, as there is no reason to add a layer of indirection, and
there are other MSRs with a "set" but no "get", e.g. EFER.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-4-seanjc@google.com
Link: https://lore.kernel.org/r/20241101183555.1794700-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 04bc93cf49d1 ("KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.h |  1 -
 arch/x86/kvm/x86.c   | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1b8ef9856422a..441abc4f4afd9 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -117,7 +117,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0846e3af5f6c5..36bedf235340c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -667,14 +667,9 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.apic_base;
-}
-
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
-	return kvm_apic_mode(kvm_get_apic_base(vcpu));
+	return kvm_apic_mode(vcpu->arch.apic_base);
 }
 EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
 
@@ -4314,7 +4309,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 1 << 24;
 		break;
 	case MSR_IA32_APICBASE:
-		msr_info->data = kvm_get_apic_base(vcpu);
+		msr_info->data = vcpu->arch.apic_base;
 		break;
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
@@ -10159,7 +10154,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 
 	kvm_run->if_flag = kvm_x86_call(get_if_flag)(vcpu);
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
-	kvm_run->apic_base = kvm_get_apic_base(vcpu);
+	kvm_run->apic_base = vcpu->arch.apic_base;
 
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
@@ -11718,7 +11713,7 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.efer;
-	sregs->apic_base = kvm_get_apic_base(vcpu);
+	sregs->apic_base = vcpu->arch.apic_base;
 }
 
 static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-- 
2.39.5



