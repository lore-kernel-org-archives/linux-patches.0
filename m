Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB1D576EA4;
	Wed,  9 Sep 2026 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963890; cv=none; b=BdaooByOv7uy+I//D28UAU8TgbznMItsYIbDyrrVJCqOw6HNTUWgK4njg4e35aGUNoYNd6jIIr3nqtRnuAfTe+Wq/rF/DmEnDL0LIktwd28pFQji0i6+kmxI4lzuQiiviPwWUlvb3g/RSFKJ7Io930zcKdk7gYuhgMbNOeRRq1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963890; c=relaxed/simple;
	bh=JkZnvJoCx0yJAOTk+o1PGTO+F8AzyEoJrnEbvfAwOss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5/AUmwaGBsSqjOAOe38DMZVMlzdq7QGCiCUyQaQeYujiY0WXsGRfO8HJiDUz4FNfE3IE6QIvGG4OoIwR7mrWRL78dxsC9UPD93rg4ycmBQAMX0MqCOXDYFEzniVRFZwYXkYK4IknyFztMp2Cr5rcMuDeJFm2hwWZne/G5JtCaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cII1+CMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cII1+CMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05C31F00A3D;
	Wed,  9 Sep 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963889;
	bh=skGkGuvAdQ23Su80OnlK2Q2j5iOQWdwLCTPk/DPwCDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cII1+CMO6WlqZqm+f7g7PUgRYrFT/0kyRAIS6WLRrntyIp7WYaVrEb4WzKhuQ7qYq
	 u4Bz4theQkAAIu/NeQL48dsFbA2csUYA3gQ8vKDPgeeH88ZiydEjOAg3VEEJz/J5Ry
	 LWhHjoysJIE+TbqKR7VY+nQzn0gPqKCxMhLTHLyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 235/583] KVM: x86/mmu: Fold kvm_mmu_zap_memslot() into kvm_arch_flush_shadow_memslot()
Date: Wed,  9 Sep 2026 15:38:40 +0200
Message-ID: <20260909134246.295121396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 06d38eaa78fdac1cc889f261fa420eba8e9caa1a upstream.

Fold kvm_mmu_zap_memslot() into its sole caller so that its GFN range
structure can be used to trigger guest_memfd invalidations regardless of
whether KVM will do a partial or full zap of the MMU.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-8-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7335,8 +7335,14 @@ out_flush:
 	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 }
 
-static void kvm_mmu_zap_memslot(struct kvm *kvm,
-				struct kvm_memory_slot *slot)
+static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
+	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+}
+
+void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
 {
 	struct kvm_gfn_range range = {
 		.slot = slot,
@@ -7347,25 +7353,14 @@ static void kvm_mmu_zap_memslot(struct k
 	};
 	bool flush;
 
-	write_lock(&kvm->mmu_lock);
-	flush = kvm_unmap_gfn_range(kvm, &range);
-	kvm_mmu_zap_memslot_pages_and_flush(kvm, slot, flush);
-	write_unlock(&kvm->mmu_lock);
-}
-
-static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
-{
-	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
-	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
-}
-
-void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-				   struct kvm_memory_slot *slot)
-{
-	if (kvm_memslot_flush_zap_all(kvm))
+	if (kvm_memslot_flush_zap_all(kvm)) {
 		kvm_mmu_zap_all_fast(kvm);
-	else
-		kvm_mmu_zap_memslot(kvm, slot);
+	} else {
+		write_lock(&kvm->mmu_lock);
+		flush = kvm_unmap_gfn_range(kvm, &range);
+		kvm_mmu_zap_memslot_pages_and_flush(kvm, slot, flush);
+		write_unlock(&kvm->mmu_lock);
+	}
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)


