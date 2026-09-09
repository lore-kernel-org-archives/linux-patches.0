Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B585456855D;
	Wed,  9 Sep 2026 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962510; cv=none; b=lMjOsBCdhh7U6HbPCGPw//ooOPU5jBFjGx3Q31A1R5skZ3w4YntB7GIdYr2SjGCSgzd3zmeacXIe+c1j5e+loZFV5w+FSXBXus8uymSj1Vv8Ui3EOMOTWAFKAGI03k+9VdvRIHbNkv/R5M106gO+sQPusamANBjD6NtM+cBDRGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962510; c=relaxed/simple;
	bh=H92Le78A58r1Mz/ZEuH0oBsOtiyzLJiLsHa20GNS/Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdHtkDsozTdky42BCFQ3evDJoKyigh8t1Mnd+uR4U0UiMaEOQv/f+mFP+51Xg0EKGdADX9cMrGjYZ5DOaGpAXozSOIoGm7njWafLAIgIZxVWjzppsxK6zC68mJfb6F7DmeL3Bo8hgzM01MMmPDq3A+P6J5Y2n/Jn0/HiIFzGzkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6maI9Zo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6maI9Zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B521F00A3A;
	Wed,  9 Sep 2026 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962508;
	bh=p9EQ4l0sHw0sHDYGrsqqqGP/fBkkTlReMZDvJ19YLEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6maI9ZowqtyQizd3Bj0J/6bLiRUERN8Llin44xT4ohdkuJPgmp57M3ox6P3yigur
	 L15LRPE0glcR9E8Ec1j9F4ylts3hfhpZCpsqKVEVngtbcDr8eFNUY0n2sti1I0WEyY
	 2wn3RArs+o7ynSim24YPRlxMBEEMpgT3/P7gtoh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Phil Rosenthal <phil@phil.gs>
Subject: [PATCH 7.2 298/556] KVM: x86/mmu: Consume the locked rmap value in the lockless rmap walk
Date: Wed,  9 Sep 2026 15:39:38 +0200
Message-ID: <20260909134241.173253161@linuxfoundation.org>
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

From: Phil Rosenthal <phil@phil.gs>

commit e428f9779a43737d830111238816f1928b07aefb upstream.

__kvm_rmap_lock() deliberately elides the rmap lock when it observes an
empty rmap.  In that case kvm_rmap_lock_readonly() also re-enables
preemption and returns zero, so the caller holds neither the rmap lock
nor a preemption reference.  The elision documents the invariant it
relies on:

	 * Elide the lock if the rmap is empty, as lockless walkers (read-only
	 * mode) don't need to (and can't) walk an empty rmap, nor can they add
	 * entries to the rmap.  I.e. the only paths that process empty rmaps
	 * do so while holding mmu_lock for write, and are mutually exclusive.

kvm_rmap_age_gfn_range() ignores the returned value and unconditionally
enters for_each_rmap_spte_lockless().  The iterator started with
rmap_get_first(), which re-reads rmap_head->val rather than using the
value returned by the lock.  If a writer populates the rmap between the
lock's read and the iterator's re-read, the aging path walks the newly
installed rmap without holding its lock.

For a KVM_RMAP_MANY rmap this leaves the walker following a
pte_list_desc chain that it never locked.  A writer holding mmu_lock for
write may free that chain (e.g. kvm_zap_all_rmap_sptes() on the recycle
path, or any rmap zap) via kmem_cache_free() while the walk is in
progress, giving a slab use-after-free.  Nothing serialises the two: the
aging path runs without mmu_lock when CONFIG_KVM_MMU_LOCKLESS_AGING=y,
and the rmap lock that would otherwise exclude the writer was elided.
Because the empty path re-enables preemption, the interval between the
two reads can span an arbitrary scheduling delay.

Fix the class of bug by having the lockless walk consume the value
returned by the lock instead of re-reading the rmap.  Split
rmap_get_first() into __rmap_get_first(), which starts an iterator from
an already-read rmap value, and make for_each_rmap_spte_lockless() take
that value and call __rmap_get_first() directly.
kvm_rmap_age_gfn_range() passes the value returned by
kvm_rmap_lock_readonly(): when the lock was elided the value is zero,
__rmap_get_first() returns NULL, and the walk is skipped.  No lockless
walker re-reads the rmap, so the lock-elision invariant cannot be
violated, and no lock()-without-paired-unlock() path is added to the
aging code.

Fixes: af3b6a9eba48 ("KVM: x86/mmu: Walk rmaps (shadow MMU) without holding mmu_lock when aging gfns")
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Phil Rosenthal <phil@phil.gs>
Link: https://patch.msgid.link/20260720-rmap-age-elided-submit-v2-1-668973030d47@phil.gs
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1245,18 +1245,9 @@ struct rmap_iterator {
 	int pos;			/* index of the sptep */
 };
 
-/*
- * Iteration must be started by this function.  This should also be used after
- * removing/dropping sptes from the rmap link because in such cases the
- * information in the iterator may not be valid.
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
-			   struct rmap_iterator *iter)
+static u64 *__rmap_get_first(unsigned long rmap_val,
+			     struct rmap_iterator *iter)
 {
-	unsigned long rmap_val = kvm_rmap_get(rmap_head);
-
 	if (!rmap_val)
 		return NULL;
 
@@ -1271,6 +1262,19 @@ static u64 *rmap_get_first(struct kvm_rm
 }
 
 /*
+ * Iteration must be started by this function.  This should also be used after
+ * removing/dropping sptes from the rmap link because in such cases the
+ * information in the iterator may not be valid.
+ *
+ * Returns sptep if found, NULL otherwise.
+ */
+static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
+			   struct rmap_iterator *iter)
+{
+	return __rmap_get_first(kvm_rmap_get(rmap_head), iter);
+}
+
+/*
  * Must be used with a valid iterator: e.g. after rmap_get_first().
  *
  * Returns sptep if found, NULL otherwise.
@@ -1304,8 +1308,9 @@ static u64 *rmap_get_next(struct rmap_it
 	__for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)			\
 		if (!WARN_ON_ONCE(!is_shadow_present_pte(*(_sptep_))))	\
 
-#define for_each_rmap_spte_lockless(_rmap_head_, _iter_, _sptep_, _spte_)	\
-	__for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)			\
+#define for_each_rmap_spte_lockless(_rmap_val_, _iter_, _sptep_, _spte_)	\
+	for (_sptep_ = __rmap_get_first(_rmap_val_, _iter_);			\
+	     _sptep_; _sptep_ = rmap_get_next(_iter_))				\
 		if (is_shadow_present_pte(_spte_ = mmu_spte_get_lockless(sptep)))
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
@@ -1743,7 +1748,7 @@ static bool kvm_rmap_age_gfn_range(struc
 			rmap_head = gfn_to_rmap(gfn, level, range->slot);
 			rmap_val = kvm_rmap_lock_readonly(rmap_head);
 
-			for_each_rmap_spte_lockless(rmap_head, &iter, sptep, spte) {
+			for_each_rmap_spte_lockless(rmap_val, &iter, sptep, spte) {
 				if (!is_accessed_spte(spte))
 					continue;
 


