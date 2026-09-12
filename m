Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA48E2DBF75;
	Sat, 12 Sep 2026 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213627; cv=none; b=PF2UZoTjEnAQG/B87YMl9IiGkDq/Bte+cqYifpWWvDTAQbVM0yYu9P3GeufhgMCh9xksN0VVBEaDVeQRTpuQyfe+H/vXVcgJEpafmEpvpTnEoVrV29Ca+yaxW0NE6zUjKNDOGcXyhdzDmW39mVzniDII0+MheC3BFpFIk85/7y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213627; c=relaxed/simple;
	bh=YmpnJ4HnLO+bdbj0/+uuJxVMB/j/7gP1N28HRYMWpBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiCyvXy6EHdoSBQtMburpY1cD1/8EcUslQJG3In5XkrnlapFnHhijejQcNaIY4Uw2HomVzpJ+C6vjZcZCO1j87KoWoTTS3FPgKD53dYUnJ5UVZ/St5falQcdvI1JGYaIrA5c3ubxPBGTYLzDmap0P3mbrNMeVBrJPn+FLVxWW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMR5xJl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMR5xJl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6E21F00893;
	Sat, 12 Sep 2026 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213625;
	bh=QrSRZjy8icJOXH/MOclo0lN3EspvNsJ89yOEvhVf9Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMR5xJl+OoEMobwfOa3AJ84yQYTIP4LwB97YOwlQRcfv4pDwu0l2kSmVBo0Gfykhj
	 3/wcZoWt9giD0G+pDUU/MsfP0zbVgUroelKH5bO9H3focWOPFANRW/btkelf0GzqPk
	 2xz8X3R2dwyoAxCaIFymtNHXV8NI2DHdC6jr0tMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0160/1376] KVM: x86/mmu: Fold kvm_mmu_zap_memslot() into kvm_arch_flush_shadow_memslot()
Date: Sat, 12 Sep 2026 08:43:06 +0200
Message-ID: <20260912065611.117116281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7107,23 +7107,6 @@ out_flush:
 	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 }
 
-static void kvm_mmu_zap_memslot(struct kvm *kvm,
-				struct kvm_memory_slot *slot)
-{
-	struct kvm_gfn_range range = {
-		.slot = slot,
-		.start = slot->base_gfn,
-		.end = slot->base_gfn + slot->npages,
-		.may_block = true,
-	};
-	bool flush;
-
-	write_lock(&kvm->mmu_lock);
-	flush = kvm_unmap_gfn_range(kvm, &range);
-	kvm_mmu_zap_memslot_pages_and_flush(kvm, slot, flush);
-	write_unlock(&kvm->mmu_lock);
-}
-
 static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
@@ -7133,10 +7116,22 @@ static inline bool kvm_memslot_flush_zap
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	if (kvm_memslot_flush_zap_all(kvm))
+	struct kvm_gfn_range range = {
+		.slot = slot,
+		.start = slot->base_gfn,
+		.end = slot->base_gfn + slot->npages,
+		.may_block = true,
+	};
+	bool flush;
+
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


