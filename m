Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061155;
	b=Ew7kYHd98g8b+vRzl6opl2wlx1epEIKDMwyt2J5fOE2UZVVPb+JRx5YVg5m5Gpwreqot
	 aIYpsqqUwK+TtBBDfbrZYSV+TXkrJftT4gRdBxfzsK0pPgX/pzXLPzw4FsMblklRw+vjy
	 5kS//ZrDP82UnFd0oNsXa4je2yskAScW32/DyWMuTpecctftggU7Ou9LmeUlfGvfi1lcv
	 j3szMZ8fM6B74uckyhLYbi0/K3bO4Vd/qstP06GhIjZWZw+066OjBaFhvoPpcR4XWXTha
	 Rb4+SBzHQwQ/2O9RL2WIztog+WKWlw80L6290cNaFlki7TMKTR+qHI/kgkZB2QwveLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j7MogKYhcj/Gl9RpswZBUlejpBR1ep7oY1XzSJDD/jo=;
	b=C7llDwC0ASC/yms5mzBZVwvxp11xTKu/I7YJ737xZ13RQAX4VeoEziQJuTAEVWSyBOlv
	 8mrGelbNY+74wH/jSuVPoBtv95owfVtSnUMbsLiSl1iJDBmTI2zANcNf2AluI0S5xrXD9
	 jIyLOIFYbb6U9lrXn8zMejnQqVV8r5Fk0gtoYJCMyQzqrY4SYpqqRcv2L2bDGgoZrKYca
	 FKRCw2dTBvA2M8yZBYIIdWj03XR2yd/lFpxINhiK2BosI0idpTn8Gn7rVOLz7RLJWHKiQ
	 OOtGyEfxzJQLMwjKZ9y+vR3z9bKTHOi8qMUk2ut4kH1uWh58he8+rlTsO2yDpQoVxXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyPpN0qb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C009A606D805;
	Sat,  7 Nov 2026 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyPpN0qb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF0E1F0089F;
	Sat,  7 Nov 2026 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061154;
	bh=j7MogKYhcj/Gl9RpswZBUlejpBR1ep7oY1XzSJDD/jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyPpN0qbqxFKlbDV6JrWfaX2qjW4voHWiaH5uKLGcvCPiYGU1lTjyxccgK+j+WaLy
	 I/X9neAMGV7xf+lVcB0ReKu3PTr1G+CBqy/7PWPUmGcACnRn08hJ84GsLA/yrkbXRf
	 EZwYYdDdA7B2mZoZ4b8/iZEPpvPmS3Op4gxzHYNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0454/1536] KVM: x86/mmu: Use split "zap all fast" helpers when invalidating memslot
Date: Sat,  7 Nov 2026 08:41:10 -0500
Message-ID: <20261107135010.282922378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit db095727ff5739f4f46ee641ee6ef450032886db ]

Manually invoke the front half and back half of the "zap all fast" flow
when invalidating a memslot so that mmu_lock is acquired at function scope
in kvm_arch_flush_shadow_memslot().   This will allow putting more code
inside the critical section without having to take mmu_lock twice in quick
succession.

Opportunistically open code checking whether or not to do the fast zap, to
discourage removing the local "zap_all" in a future cleanup, i.e. to ensure
the SLOT_ZAP_ALL quirk is queried exactly once.  Processing the front half
but not the back half of the fast zap (if SLOT_ZAP_ALL were disabled
concurrently) would result in KVM unnecessarily keeping invalid TDP MMU
roots until the VM is destroyed.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-10-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1dfc568631e29..2ff392fa15518 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7149,12 +7149,6 @@ static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
 	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 }
 
-static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
-{
-	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
-	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
-}
-
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
@@ -7164,16 +7158,23 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 		.end = slot->base_gfn + slot->npages,
 		.may_block = true,
 	};
+	bool zap_all = kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
+		       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
 	bool flush;
 
-	if (kvm_memslot_flush_zap_all(kvm)) {
-		kvm_mmu_zap_all_fast(kvm);
+	write_lock(&kvm->mmu_lock);
+
+	if (zap_all) {
+		__kvm_mmu_zap_all_fast_front_half(kvm);
 	} else {
-		write_lock(&kvm->mmu_lock);
 		flush = kvm_unmap_gfn_range(kvm, &range);
 		kvm_mmu_zap_memslot_pages_and_flush(kvm, slot, flush);
-		write_unlock(&kvm->mmu_lock);
 	}
+
+	write_unlock(&kvm->mmu_lock);
+
+	if (zap_all)
+		__kvm_mmu_zap_all_fast_back_half(kvm);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
-- 
2.53.0



