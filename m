Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF95145330;
	Tue, 23 Apr 2024 21:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908658; cv=none; b=Ga4kCMPPt7RtFwwuoVUUHtDt8FY+W/kYCKe3GYUY7DOpgvgVXniN9aMzOHCI06Z0/qMhtU5ZfH3lGJNifOEuIonjz9c+1++69hUjQqbLwqJPRto3rB8LYWb+YhL0Opdf4wyw380kN6B3m+ETAXAvX5yOvflwpwTRDaNmc9WphYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908658; c=relaxed/simple;
	bh=G+jDSPulQCWm6WWQ66LDKKjGIFjbnLNlpSced28vEUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZixRs60DOCS8KWDjserjIlQcJRwbU747naE26Rhgvc44O/VH7cqUXfrRquaUCtQFDWjKY06VCBLfArppO6b82NTrRFtN4pDOP+1oSuIOD1yVUu/mNJOWHv6Jzg8jTSvt+DIzoBpj+PzhwZ2frifkI13+slSbeuFco2ON9Gh6qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9yUs/nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9yUs/nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B72C3277B;
	Tue, 23 Apr 2024 21:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908658;
	bh=G+jDSPulQCWm6WWQ66LDKKjGIFjbnLNlpSced28vEUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9yUs/nZA3cXYKopUFALFqarQdcgjyuW7/5FjM8k/LovixIp1+4AWu/ik9Z/I2AOH
	 DIIU+3ri+ReQqVzbWDTyhRPQc1zaIACuKazs7I9X90XweAXyGcCHR9tafhM1LnmS3+
	 YOqHMV25ofQLKBqrX8fd8lmCrY2uG0d5BTsRNiNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com,
	Vipin Sharma <vipinsh@google.com>,
	Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>
Subject: [PATCH 6.6 132/158] KVM: x86/mmu: Write-protect L2 SPTEs in TDP MMU when clearing dirty status
Date: Tue, 23 Apr 2024 14:39:29 -0700
Message-ID: <20240423213859.993739101@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Matlack <dmatlack@google.com>

commit 2673dfb591a359c75080dd5af3da484b89320d22 upstream.

Check kvm_mmu_page_ad_need_write_protect() when deciding whether to
write-protect or clear D-bits on TDP MMU SPTEs, so that the TDP MMU
accounts for any role-specific reasons for disabling D-bit dirty logging.

Specifically, TDP MMU SPTEs must be write-protected when the TDP MMU is
being used to run an L2 (i.e. L1 has disabled EPT) and PML is enabled.
KVM always disables PML when running L2, even when L1 and L2 GPAs are in
the some domain, so failing to write-protect TDP MMU SPTEs will cause
writes made by L2 to not be reflected in the dirty log.

Reported-by: syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900d58a45dcaab9e4821
Fixes: 5982a5392663 ("KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot")
Cc: stable@vger.kernel.org
Cc: Vipin Sharma <vipinsh@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Link: https://lore.kernel.org/r/20240315230541.1635322-2-dmatlack@google.com
[sean: massage shortlog and changelog, tweak ternary op formatting]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1506,6 +1506,16 @@ void kvm_tdp_mmu_try_split_huge_pages(st
 	}
 }
 
+static bool tdp_mmu_need_write_protect(struct kvm_mmu_page *sp)
+{
+	/*
+	 * All TDP MMU shadow pages share the same role as their root, aside
+	 * from level, so it is valid to key off any shadow page to determine if
+	 * write protection is needed for an entire tree.
+	 */
+	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled();
+}
+
 /*
  * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
  * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
@@ -1516,7 +1526,8 @@ void kvm_tdp_mmu_try_split_huge_pages(st
 static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			   gfn_t start, gfn_t end)
 {
-	u64 dbit = kvm_ad_enabled() ? shadow_dirty_mask : PT_WRITABLE_MASK;
+	const u64 dbit = tdp_mmu_need_write_protect(root) ? PT_WRITABLE_MASK :
+							    shadow_dirty_mask;
 	struct tdp_iter iter;
 	bool spte_set = false;
 
@@ -1530,7 +1541,7 @@ retry:
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+		KVM_MMU_WARN_ON(dbit == shadow_dirty_mask &&
 				spte_ad_need_write_protect(iter.old_spte));
 
 		if (!(iter.old_spte & dbit))
@@ -1578,8 +1589,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
-	u64 dbit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
-						   shadow_dirty_mask;
+	const u64 dbit = (wrprot || tdp_mmu_need_write_protect(root)) ? PT_WRITABLE_MASK :
+									shadow_dirty_mask;
 	struct tdp_iter iter;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -1591,7 +1602,7 @@ static void clear_dirty_pt_masked(struct
 		if (!mask)
 			break;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+		KVM_MMU_WARN_ON(dbit == shadow_dirty_mask &&
 				spte_ad_need_write_protect(iter.old_spte));
 
 		if (iter.level > PG_LEVEL_4K ||


