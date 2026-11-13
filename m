Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590660;
	b=lwCkMLSib5hISgtJXejYGHt6xYpsXLZ9j02aWHKnhTNu2AOvOwCXAUjg84XP+ypJStXM
	 MLsgJcRKhbQcAmYl+d0EEYUle2NApjWPNEO0+Z//6Q/YhCb+dhXQYQbDogaw8OfIDUZBf
	 mIFKaXOeMJ0oo25vxg1nR1PDakOeskwxFBq/ZxhTka6rV5shIP0yNu1V8Y4ZavMJeu2zp
	 F92vSlc+PDvT+zcbMXQFUtr1b6TqTF7fw7TPUSmXy0KKnHFImFQCSsnNXojlrNSHkST1C
	 RuzyF+ztAvxk0KBgSTl1WO5z/0Y4ebXRUwafUfDc6iMCyYs9SxJw4OG9hr4a/0zJSNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Ja/5gV3zrJcmm6kaki62/MFKptH2qNrUeZ6QJ91ekg=;
	b=eNsMxmjLPF/FdfQJC8hLVM5cNe7YB6/a7tsuPCppSeVnt3/HLRy4Qq/T5sI26fPz/UI7
	 6+CXWMDBNhp4p5reC+FsR77uFl7fRB1AXA04sHXDTWlQ2pDnExRvRvJSSz8I94rmlMVnL
	 t/IhRFauT2caxx7D6/9b7f9KDL1Mcz3CSUawsY46KC1QhftrE+rLFq/lPkLcqGQgEwG7p
	 kY5IE5tvL8OctVnrzE7ODU3JxlMSOhnnSgTBVNh995CuJNhlFIVPR4xWuLCTKfKnGR9uN
	 WOPXflSas+BrKOkKP3Tn3+PiiETNtC2IyuI2yXhYxItp9VFzc2ljcoJ331tJxMUY/pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOYMdQc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC36E606B204;
	Fri, 13 Nov 2026 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOYMdQc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A7D1F000C6;
	Fri, 13 Nov 2026 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590660;
	bh=5Ja/5gV3zrJcmm6kaki62/MFKptH2qNrUeZ6QJ91ekg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOYMdQc7ICmFXFFBDEfzW3ke819KR+QdFnJgCvTiOxdTiOz06ig077lvSLEtj9Otd
	 CNKjNbtpXhxn72q816HqfPK2JHx1/HTqiCzaZUaVCqE5yHECavS9w8GB9eEGzgQ8zF
	 57kFmBj8ykAxPooy+7F/u9osDhbea5bKISD+gSjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 578/686] KVM: arm64: nv: Move L2->L1 switch on interrupt early
Date: Fri, 13 Nov 2026 10:51:51 -0500
Message-ID: <20261113153841.260566398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 21d3b33234ebbb675c2a2a0fa7b12d2d83953d7a ]

NV request generation to switch from L2 to L1 on interrupt is buried
into the vgic flush code, while we should be able to deliver requests
as early as possible.

Similarly, MI generation happens *after* the need for a request has been
evaluated, which means we potentially delay the maintenance interrupt by
a full exit/entry cycle.

Move these two things to happen much earlier in the entry code, and make
sure the MI generation and PMU interrupt serve as input to the request
switching back from L2 to L1.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-2-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: retained the maintenance-interrupt recalculation guard to accommodate delayed nested VGIC register synchronization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c       |  4 ++--
 arch/arm64/kvm/nested.c    | 10 ++++++++++
 arch/arm64/kvm/vgic/vgic.c | 11 ++---------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4e0db01a528a8..1cf6b60382003 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1225,11 +1225,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
-		kvm_nested_flush_hwstate(vcpu);
-
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_flush_hwstate(vcpu);
 
+		kvm_nested_flush_hwstate(vcpu);
+
 		local_irq_disable();
 
 		/*
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 92853a343c429..9e1ce558fb7e9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -16,6 +16,7 @@
 #include <asm/sysreg.h>
 
 #include "sys_regs.h"
+#include "vgic/vgic.h"
 
 struct vncr_tlb {
 	/* The guest's VNCR_EL2 */
@@ -1879,6 +1880,9 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
  *
  * What follows is some slop to (1) react to exception routing / masking and (2)
  * preserve the pending SError state across translation regimes.
+ *
+ * Also generate the maintenance interrupt state, and finally check that if
+ * we need to take an interrupt targetting the guest hypervisor.
  */
 void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1887,6 +1891,12 @@ void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
 
 	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
 		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
+
+	if (!vgic_state_is_nested(vcpu))
+		vgic_v3_nested_update_mi(vcpu);
+
+	if (vgic_state_is_nested(vcpu) && kvm_vgic_vcpu_pending_irq(vcpu))
+		kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
 }
 
 void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 7c8ec44824157..23720e1131b40 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -969,7 +969,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 *
 	 *   We do that by placing a request to ourselves which will
 	 *   abort the entry procedure and inject the exception at the
-	 *   beginning of the run loop.
+	 *   beginning of the run loop (see kvm_nested_flush_hwstate()).
 	 *
 	 * - Otherwise, do exactly *NOTHING*. The guest state is
 	 *   already loaded, and we can carry on with running it.
@@ -977,15 +977,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * If we have NV, but are not in a nested state, compute the
 	 * maintenance interrupt state, as it may fire.
 	 */
-	if (vgic_state_is_nested(vcpu)) {
-		if (kvm_vgic_vcpu_pending_irq(vcpu))
-			kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
-
+	if (vgic_state_is_nested(vcpu))
 		return;
-	}
-
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
 
 	/*
 	 * If there are no virtual interrupts active or pending for this
-- 
2.53.0



