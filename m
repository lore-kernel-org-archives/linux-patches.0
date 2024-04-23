Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3690420B3E;
	Tue, 23 Apr 2024 21:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908537; cv=none; b=ejiJ4sOl6HwiQgi8drN0wjB+EMBHMXeDlcnZAw3i6oS3m25HLA5PZNWvfcCWUvvKDHIXNaV4tV+N/etQiCnXeiuxLGaTbozsqKO39G4qyXYZ0+RuPJysdv1G6zVPHqbC9ocgrrFpwRO8jraAOQO9Dcf2SuQhLTVVpZnok6jgMMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908537; c=relaxed/simple;
	bh=P+rWb+3tDpBzmZEs+6/CZrPW+hNgL5We+C9z5LlX1mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtakBYJZAudvuxyemOwlNJND3nnOqktDFEgSKdVMxll5QTah4yx+O7k9ktXiLiwlR6yaPLHsmUCVkGQGbvoIaGBEtHC5O8eyZsXJye24ZrkTiFTZM2cd4cpd+TYSwwbc6vHdCefF6XfE0hnHLJZ30HjTSiDwH517inMN3vIFCIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xilliDsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xilliDsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032F5C116B1;
	Tue, 23 Apr 2024 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908537;
	bh=P+rWb+3tDpBzmZEs+6/CZrPW+hNgL5We+C9z5LlX1mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xilliDsw+NHl7RBOKAlHNwXdE6awLulKjEC48C6f0LgRRnlx8qMYtmLO+37hnkpQ9
	 RM/pGftkMMj8fTJYl3OEOElcbtOFzJKtST0LQEYFL2rHuRbTM10mudGHcRoMw4QpNS
	 JKj5tuCb3gweBcsd0+pdmSpTybXzdjwj2ZATnvSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com,
	Vipin Sharma <vipinsh@google.com>,
	Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>
Subject: [PATCH 6.8 130/158] KVM: x86/mmu: Write-protect L2 SPTEs in TDP MMU when clearing dirty status
Date: Tue, 23 Apr 2024 14:39:12 -0700
Message-ID: <20240423213900.124987826@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1498,6 +1498,16 @@ void kvm_tdp_mmu_try_split_huge_pages(st
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
@@ -1508,7 +1518,8 @@ void kvm_tdp_mmu_try_split_huge_pages(st
 static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			   gfn_t start, gfn_t end)
 {
-	u64 dbit = kvm_ad_enabled() ? shadow_dirty_mask : PT_WRITABLE_MASK;
+	const u64 dbit = tdp_mmu_need_write_protect(root) ? PT_WRITABLE_MASK :
+							    shadow_dirty_mask;
 	struct tdp_iter iter;
 	bool spte_set = false;
 
@@ -1523,7 +1534,7 @@ retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+		KVM_MMU_WARN_ON(dbit == shadow_dirty_mask &&
 				spte_ad_need_write_protect(iter.old_spte));
 
 		if (!(iter.old_spte & dbit))
@@ -1570,8 +1581,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
-	u64 dbit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
-						   shadow_dirty_mask;
+	const u64 dbit = (wrprot || tdp_mmu_need_write_protect(root)) ? PT_WRITABLE_MASK :
+									shadow_dirty_mask;
 	struct tdp_iter iter;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -1583,7 +1594,7 @@ static void clear_dirty_pt_masked(struct
 		if (!mask)
 			break;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+		KVM_MMU_WARN_ON(dbit == shadow_dirty_mask &&
 				spte_ad_need_write_protect(iter.old_spte));
 
 		if (iter.level > PG_LEVEL_4K ||


