Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC28C3D967A;
	Wed,  9 Sep 2026 14:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962521; cv=none; b=tYX4oc35mPsB1XortzZdTy4BjPOnNtOLoxseSWdyUktidV0z+R4YvqR7Y2+rONNGJVNkA20pOwD1HSB5kexSUhXHgfl0SV5BnlkaUhh4LQQDp6ferRQARsHBfc+j/2nysSXELJvHqKa5Mef3ADqTBZjVKXnFGGSLWcLve1nKlDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962521; c=relaxed/simple;
	bh=V7h7yaWwqiHSyfEoTo4WpFmr2DgdwzIM7Ci0ECYTCPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMQddn/nAhu+LiiuCqeLUBfJ59j4Go3nOJ7f+/aZV3ErK7SJS6fhb21A/ejJhNRoTVLEsF+LY2u6Y+bbZvjf/lPj7yrt/pWq1TDSXj8mvC+tw40LTPWn1kR/nRXtaFPJbNObrBPn21AgJ/kO1a35xlMyXeUnBGA2iPA7MF5rSVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHG262sN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHG262sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416821F00A3A;
	Wed,  9 Sep 2026 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962519;
	bh=eFjhBfALOprkxes6x+KehV0Qr/exZrQU1qApaxGL/O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHG262sNKw5Ykw16S4GTzKUcO/YRaBQi/nv48sJ8NKpbYo2Vll9lv1IqXweRfhH/y
	 IkKyDp1QV4s/YAcQflo2f0jxbOBw5p0JtZkkB0nkvG04SIc+FegejOaUFP1jiE0Pxm
	 BQEYeqyI6Sg7wjyl9Og18ymR9Kc4/EV3Em+RYiu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Marc Zyngier <maz@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 319/556] KVM: arm64: Remove VM-wide VNCR mapping counter
Date: Wed,  9 Sep 2026 15:39:59 +0200
Message-ID: <20260909134241.884664250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit c55bc773b6e814406658fae7dc5c15f639ed816e upstream.

The global VNCR mapping counter is used to decide whether an L1
provided VNCR page is mapped in L0 on any CPU at the point of
dealing with a TLB invalidation. It is incremented when a mapping
is made in the fixmap, and decremented when unmapped.

As it turns out, this tracking has several flaws:

- we are trying to invalidate TLBs, and the mapping is only an
  opportunistic consequence of the TLB. Checking this counter to
  decide whether a TLB needs to be invalidated may result in missed
  invalidations.

- an L1 vcpu invalidating its own TLB (a very likely case) will not
  succeed in invalidating the VNCR pseudo TLB because that page is
  not mapped in L0 at this stage.

Given that this tracking fails at delivering the minimum guarantees
that are required and is only a performance optimisation, remove it
completely.

Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://patch.msgid.link/20260806091026.620700-2-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    3 ---
 arch/arm64/kvm/hyp/vhe/switch.c   |    3 +--
 arch/arm64/kvm/nested.c           |    3 ---
 3 files changed, 1 insertion(+), 8 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -411,9 +411,6 @@ struct kvm_arch {
 	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
-	/* Count the number of VNCR_EL2 currently mapped */
-	atomic_t vncr_map_count;
-
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -427,8 +427,7 @@ static bool kvm_hyp_handle_tlbi_el2(stru
 	 * If we have to check for any VNCR mapping being invalidated,
 	 * go back to the slow path for further processing.
 	 */
-	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
-	    atomic_read(&vcpu->kvm->arch.vncr_map_count))
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
 		return false;
 
 	__kvm_skip_instr(vcpu);
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -48,7 +48,6 @@ void kvm_init_nested(struct kvm *kvm)
 {
 	kvm->arch.nested_mmus = NULL;
 	kvm->arch.nested_mmus_size = 0;
-	atomic_set(&kvm->arch.vncr_map_count, 0);
 }
 
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
@@ -930,7 +929,6 @@ static void this_cpu_reset_vncr_fixmap(s
 	if (unmap_l1_vncr(vcpu->arch.vncr_tlb) == -1)
 		clear_fixmap(vncr_fixmap(smp_processor_id()));
 	host_data_clear_flag(L1_VNCR_MAPPED);
-	atomic_dec(&vcpu->kvm->arch.vncr_map_count);
 }
 
 void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
@@ -1640,7 +1638,6 @@ static void kvm_map_l1_vncr(struct kvm_v
 		atomic_set(&vt->cpu, smp_processor_id());
 		__set_fixmap(vncr_fixmap(atomic_read(&vt->cpu)), vt->hpa, prot);
 		host_data_set_flag(L1_VNCR_MAPPED);
-		atomic_inc(&vcpu->kvm->arch.vncr_map_count);
 	}
 }
 


