Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E01576EA4;
	Wed,  9 Sep 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963896; cv=none; b=bJDEhpdXiso1HbM47u6KE3Zr55PLPqkrnidAnWbviBhzMi3W2/vszG3z8uCMjHKcUqJHaLeGwkPilCqH63l3J9yxMDq82EcCCv98NBythgcPnZoPUhsST5PIdgnILEQMVXrPULosX3bMJN6sR2vfTDyWLfmXZGag0qdXYAwmbrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963896; c=relaxed/simple;
	bh=9OizKxMC3D/GsYgxo6W5O0JrfGyka6gZlz/8pPuB+3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WETc9e7PNoSDYtXV8LoN+rWnNUh+cOZXiQ935o4snv1Kg/o0MP42WH20ox3nI2/+3iUC5C/fjAZn8eJC8ujob5bAU4/flKq7EGc/DFxkZG08pGUhOReJNQnBshPGxRgBN60/dg/YiDqgnyUD+AaSgDyZzPF7Gk2HbEo8JyVwNxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4eZSl8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4eZSl8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5CE1F00A3A;
	Wed,  9 Sep 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963895;
	bh=op9n8zb9CBU01l4DNfLIv2l7YOWgyKwoCSrXSEdISIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4eZSl8qA7aT3xv+Vuwn4zYtrpjGOvVK9HFugDvVH7Tt39vpvRAYrArEd+KCFJP96
	 Wxruxk2tukEjxBj3Omd1yuj79D6IYhEmIpMMWYGWX3w+yF/FWPzEVsKgoB0dO9oj9J
	 /22RdtBI92R5/Lk8d1QcRGTYxMAuXOIyw8+JqbFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	James Houghton <jthoughton@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 237/583] KVM: x86/mmu: Use CMPXCHG when clearing Accessed bit in TDP MMU
Date: Wed,  9 Sep 2026 15:38:42 +0200
Message-ID: <20260909134246.363116986@linuxfoundation.org>
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

commit 3d679b7cb31f74bf2303123ce4ee3266eeee999a upstream.

Use LOCK CMPXCHG instead of LOCK AND to clear the Accessed bit when aging
SPTEs in the TDP MMU, as doing a LOCK AND can corrupt a FROZEN SPTE and
allow a third CPU to effectively overwrite the FROZEN SPTE.  As pointed
out by AI of some kind, because the magic FROZEN_SPTE value is a "full"
SPTE, not a single bit, and includes the Accessed bit, clearing the
Accessed bit in a FROZEN SPTE will result in is_frozen_spte() getting a
false negative.

E.g. if CPU0 freezes an SPTE, and CPU1 clears the Accessed bit in the
frozen SPTE, then CPU2 could come along and overwrite the frozen SPTE with
a shadow-present SPTE.

Thankfully, the false negative is largely benign, because outside of TDX,
which doesn't support aging, KVM only freezes leaf SPTEs when removing an
upper level shadow page.  So while KVM could clobber a frozen SPTE back to
a shadow-present SPTE, and could even use the new SPTE, the subsequent TLB
flush will make the orphaned, shadow-present SPTE unreachable.  Failure to
ever zap the orphaned leaf SPTE would show up in KVM's stats, but otherwise
is benign (because KVM no longer keeps an elevated refcount for leaf SPTEs).

Opportunistically add a comment to warn future developers away from using
kvm_tdp_mmu_write_spte_atomic() and tdp_mmu_clear_spte_bits_atomic(), as
they are generally unsafe.  Keep the helpers, e.g. instead of open-coding
the atomic64_fetch_and() in tdp_mmu_clear_spte_bits(), as scary warnings
usually are more effective deterrent against recidivism than removal of the
dangerous code.

Alternatively, KVM could use different bits for the magic FROZEN_SPTE value,
e.g. setting the Dirty bits (with effective IPAT and Global aliases) would
likely be "ok", as IPAT/Global are extremely unlikely to be cleared without
doing a full SPTE write, and KVM's clearing of Dirty bits shares logic with
Write-Protection, which must do a full SPTE write (via cmpxchg64() in the
TDP MMU) to ensure KVM isn't clobbering state.  But there is zero reason to
carry that risk (beyond stubbornness in wanting to preserve a "cute" idea),
as the cost of LOCK CMPXCHG and LOCK AND are within 1-2 uops of each other
on modern hardware.

Fixes: b146a9b34aed ("KVM: x86/mmu: Age TDP MMU SPTEs without holding mmu_lock")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Link: https://patch.msgid.link/20260728002236.869865-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_iter.h |    7 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |   20 +++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -19,6 +19,13 @@ static inline u64 kvm_tdp_mmu_read_spte(
 	return READ_ONCE(*rcu_dereference(sptep));
 }
 
+/*
+ * WARNING!  mmu_lock must be held for write when using the "write atomic" or
+ * "clear bits atomic" APIs, otherwise KVM could overwrite the "wrong" old SPTE
+ * value, i.e. clobber an update from a different CPU.  The only exception is
+ * when KVM is freezing a leaf SPTE for removal, in which case KVM doesn't care
+ * about the exact old SPTE value (KVM will react to the actual old value).
+ */
 static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 {
 	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1380,19 +1380,17 @@ static void kvm_tdp_mmu_age_spte(struct
 {
 	u64 new_spte;
 
-	if (spte_ad_enabled(iter->old_spte)) {
-		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
-								shadow_accessed_mask);
+	if (spte_ad_enabled(iter->old_spte))
 		new_spte = iter->old_spte & ~shadow_accessed_mask;
-	} else {
+	else
 		new_spte = mark_spte_for_access_track(iter->old_spte);
-		/*
-		 * It is safe for the following cmpxchg to fail. Leave the
-		 * Accessed bit set, as the spte is most likely young anyway.
-		 */
-		if (__tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
-			return;
-	}
+
+	/*
+	 * Don't bother retrying if another CPU modified the SPTE, the SPTE is
+	 * either being zapped or is likely still in-use, i.e. is still young.
+	 */
+	if (__tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
+		return;
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
 				       iter->old_spte, new_spte);


