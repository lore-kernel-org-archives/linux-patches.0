Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04909348C7B;
	Wed,  9 Sep 2026 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961626; cv=none; b=WgdW80JmvgSw7GN+7uG40I/MZDs9H7p3ZCkgn+LBcy8XCGl+kszKestn9I9Clom3RaLdW7XA7C74j8Q+auQ/gGS+Yp2FlqsrX/wGijvDHX5W+M908mPpPemomsJq3S516v3WF0/mZTDzc7/QxoPNykBitmmsMl6CfiM/APjEAG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961626; c=relaxed/simple;
	bh=F6erifaC/DxvT6yaFqaHckRqn70BQ13e7aJpsnphB1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juhpvrLc/yuwyPhJAWk7D+JZhxkH6HG7H7l8bF5ss+dw2GQLxSWAGb3/wsyBcxeNhqyKoHEzo/RMcdj4jVPiu5V6oTu7zhKhgppc+O0UVo1nGFlbdWxk6AkCxPXr/H9eaNiIRdBa74gBqLecniEPLYAyub10iEs293rnE5iKqDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZvyb0SE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZvyb0SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0D71F00A3A;
	Wed,  9 Sep 2026 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961624;
	bh=pk5iYlLy4KCs2/EdJFkDmalP+zElq+qzXEJM/icutWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZvyb0SEvZ5Vl+5AkVOJkCUozpe2YzMTgQqfb8iaCDwjAjacHqB5gSPqeWWAr5lgX
	 SZ5udNqJz1IjNayjIE8SiYFo0qpYNnf/HUGBh7GuuoOFArSq/dk62sFOwNMXwuGLLx
	 hjYi+pqthnLUT8gbE63yMxmcPHZPHa+Q9RgKwasg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 014/556] KVM: x86/mmu: Fold kvm_mmu_zap_memslot() into kvm_arch_flush_shadow_memslot()
Date: Wed,  9 Sep 2026 15:34:54 +0200
Message-ID: <20260909134230.984985059@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 06d38eaa78fdac1cc889f261fa420eba8e9caa1a ]

Fold kvm_mmu_zap_memslot() into its sole caller so that its GFN range
structure can be used to trigger guest_memfd invalidations regardless of
whether KVM will do a partial or full zap of the MMU.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-8-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: d1a3c2162334 ("KVM: SEV: Forcefully invalidate SNP VMSA if its backing gmem page is zapped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7535,8 +7535,14 @@ out_flush:
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
@@ -7547,25 +7553,14 @@ static void kvm_mmu_zap_memslot(struct k
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


