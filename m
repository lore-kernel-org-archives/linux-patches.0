Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9197551DDF3;
	Wed, 30 Sep 2026 18:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793661; cv=none; b=g+tl8M73OFq5rqjTHfT+PK1CXt3Fw3KiZuzHf2oHmzvMeqb43jviu5GiXJ5YUfvyvY34Hemi2QBkpTGp7nN9vMQTBvWIjhIQ6wKf2PTRgWbQc+GFYamH1E9frqpfEIcmOsfkfF3tc3OP6z9caP6iZsQ3fx76ZTraVPVip/RcStg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793661; c=relaxed/simple;
	bh=tf8ivjuvLwLhcunLQ2hkZByt79PbFWGhwwQzI5pdwhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccasQTmpwz2MY6KtLxsUJhOZoGv6jtnnxKwwv7YENvaBOOnnn0E+m0y0XVawHMo4TUj+LQmJxpdwH05sNCBz3SRcQJn7U9LFHViFhQyqU586SA3X8nxCM7CGPYW1be4EbC6oAyeTOsX8dSl9WQ3oCbISyH4D7B9dAZoAeMfWIn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaLJ4vV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaLJ4vV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD52F1F000FF;
	Wed, 30 Sep 2026 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793659;
	bh=37HgPgTXzAqYeaL2yKF1MPobW2qKxzGc7fiTZhu3kfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaLJ4vV3T3Hi7YBssIur2uAe4vOdsMBlxR6ufgxrjKI7nMkIMg22PqxmHUkInWTSG
	 Jdb4bCiViY9af6LSc4kvyWovc1ofsI2/YAXfFFJQV7vty6ZpmY1hZ/kKxM3v6oXWRn
	 cX3j9BBY2logKJP+dtlAJ7R7ruT2zFcvxW1Z1PVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Jonathan Davies <jonathan.davies@nutanix.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 316/395] KVM: arm64: nv: Fix null ptr deref on nested wp/unmap, teardown race
Date: Wed, 30 Sep 2026 17:29:38 +0200
Message-ID: <20260930152347.512032203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 4c74e233cdedd11592775fae2a6243e67ca3f891 upstream.

Commit 7270cc9157f4 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU
notifiers") introduced VNCR_EL2 invalidation in both kvm_nested_s2_unmap()
and kvm_nested_s2_wp().

However at the point of this being performed concurrent stage 2 teardown of
a nested guest can cause kvm->arch.mmu.pgt to be set to NULL.

This happens in kvm_flush_shadow_all() -> kvm_arch_flush_shadow_all() ->
kvm_free_stage2_pgd() and is performed under the kvm->mmu_lock.

Commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow stage 2 page
tables") introduced the teardown of the entire nested MMU range, which then
invokes stage2_apply_range() with resched=true:

mmu_notifier_invalidate_range_start()
  -> ... -> kvm_mmu_notifier_invalidate_range_start()
    -> kvm_mmu_unmap_gfn_range()
      -> kvm_unmap_gfn_range()
        -> kvm_nested_s2_unmap()
          -> kvm_stage2_unmap_range()
            -> __unmap_stage2_range()
                -> stage2_apply_range()

This means that stage2_apply_range() can drop the kvm->mmu_lock and thus
concurrent progress can be made in lockstep with
kvm_arch_flush_shadow_all().

If kvm_arch_flush_shadow_all() advances ahead of stage2_apply_range() and
completes its operation it guarantees a NULL pointer deref.

Since kvm_free_stage2_pgd() is performed under the kvm->mmu_lock this will
either be observed NULL or not and serialised against
kvm_free_stage2_pgd().

Resolve the issue by abstracting the invalidation to a new function,
kvm_invalidate_vncr_ipa_all(), and check that the pgt is non-NULL before
dereferencing it.

Fixes: 7270cc9157f4 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Jonathan Davies <jonathan.davies@nutanix.com>
Link: https://patch.msgid.link/20260901-kvm-arm-nested-virt-fix-v3-2-b154676f7e4c@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1129,6 +1129,17 @@ void kvm_handle_s1e2_tlbi(struct kvm_vcp
 	invalidate_vncr_va(vcpu->kvm, &scope);
 }
 
+static void kvm_invalidate_vncr_ipa_all(struct kvm *kvm)
+{
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	/* if the mmu lock was dropped, pgt teardown may have raced. */
+	if (pgt)
+		kvm_invalidate_vncr_ipa(kvm, 0, BIT(pgt->ia_bits));
+}
+
 void kvm_nested_s2_wp(struct kvm *kvm)
 {
 	int i;
@@ -1142,7 +1153,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
 	}
 
-	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
+	kvm_invalidate_vncr_ipa_all(kvm);
 }
 
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
@@ -1158,7 +1169,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 	}
 
-	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
+	kvm_invalidate_vncr_ipa_all(kvm);
 }
 
 void kvm_nested_s2_flush(struct kvm *kvm)


