Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB8254AF7;
	Mon, 12 May 2025 17:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071928; cv=none; b=hQv+/Ycs5OMvXcSE6DJT6bVQunbLJUOF8lnrBrJb+1f1JvVMtI/uc2Zw+5yZ6skwCQ03aYqjDCUEVLbyNLswMtAk4EwHkmDJbJyBDs1UXxfaUNNWJXdghJ10TdewVxn5jIqTiif0zuUZdP6T2LawnKZWXF7szniNaABFDw9QUnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071928; c=relaxed/simple;
	bh=spRJZVCtJpkGWZnqRGV2/AmeOgjLOH4vrRtfvlMN2w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9nCJ36fdpOo5aamdgO9/oVSLGzs3iLw6uxkPjIc9qztKS4e87OnKoSG6p3mT6NNRuEmIKW17M24WYlUbhJkUMbSfU7uoKzv1/NWM7zASCol7671F522XZrPvW548lY5izFUQ7T9azyrAGuQEHjdJRWnRYFUBUc5YefVFvFzIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcnTqs4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcnTqs4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4CEC4CEE7;
	Mon, 12 May 2025 17:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071928;
	bh=spRJZVCtJpkGWZnqRGV2/AmeOgjLOH4vrRtfvlMN2w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcnTqs4KKW/pY9XcBNt8qobmvr8N7u7NXwavugkYcl/JsibJr3T7OnIMflm1ds1gB
	 6298orop8UrifIk5+944+nyoWSkzejuAfy22rb5utGqvigOCGTUpBRe0PVTGpTMWAC
	 HQXzVVJV8h2PeqkGUM8/AhwqND0+AfxO2QNzM2cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.14 081/197] KVM: x86/mmu: Prevent installing hugepages when mem attributes are changing
Date: Mon, 12 May 2025 19:38:51 +0200
Message-ID: <20250512172047.672557340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 9129633d568edd36aa22bf703b12835153cec985 upstream.

When changing memory attributes on a subset of a potential hugepage, add
the hugepage to the invalidation range tracking to prevent installing a
hugepage until the attributes are fully updated.  Like the actual hugepage
tracking updates in kvm_arch_post_set_memory_attributes(), process only
the head and tail pages, as any potential hugepages that are entirely
covered by the range will already be tracked.

Note, only hugepage chunks whose current attributes are NOT mixed need to
be added to the invalidation set, as mixed attributes already prevent
installing a hugepage, and it's perfectly safe to install a smaller
mapping for a gfn whose attributes aren't changing.

Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
Cc: stable@vger.kernel.org
Reported-by: Michael Roth <michael.roth@amd.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Link: https://lore.kernel.org/r/20250430220954.522672-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   69 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 16 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7496,9 +7496,30 @@ void kvm_mmu_pre_destroy_vm(struct kvm *
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+				int level)
+{
+	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
+}
+
+static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+				 int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
+}
+
+static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+			       int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
+}
+
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range)
 {
+	struct kvm_memory_slot *slot = range->slot;
+	int level;
+
 	/*
 	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
 	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
@@ -7513,6 +7534,38 @@ bool kvm_arch_pre_set_memory_attributes(
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	if (WARN_ON_ONCE(range->end <= range->start))
+		return false;
+
+	/*
+	 * If the head and tail pages of the range currently allow a hugepage,
+	 * i.e. reside fully in the slot and don't have mixed attributes, then
+	 * add each corresponding hugepage range to the ongoing invalidation,
+	 * e.g. to prevent KVM from creating a hugepage in response to a fault
+	 * for a gfn whose attributes aren't changing.  Note, only the range
+	 * of gfns whose attributes are being modified needs to be explicitly
+	 * unmapped, as that will unmap any existing hugepages.
+	 */
+	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
+		gfn_t start = gfn_round_for_level(range->start, level);
+		gfn_t end = gfn_round_for_level(range->end - 1, level);
+		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
+
+		if ((start != range->start || start + nr_pages > range->end) &&
+		    start >= slot->base_gfn &&
+		    start + nr_pages <= slot->base_gfn + slot->npages &&
+		    !hugepage_test_mixed(slot, start, level))
+			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
+
+		if (end == start)
+			continue;
+
+		if ((end + nr_pages) > range->end &&
+		    (end + nr_pages) <= (slot->base_gfn + slot->npages) &&
+		    !hugepage_test_mixed(slot, end, level))
+			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
+	}
+
 	/* Unmap the old attribute page. */
 	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		range->attr_filter = KVM_FILTER_SHARED;
@@ -7522,23 +7575,7 @@ bool kvm_arch_pre_set_memory_attributes(
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
-static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				int level)
-{
-	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
-}
-
-static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				 int level)
-{
-	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
-}
 
-static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-			       int level)
-{
-	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
-}
 
 static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 			       gfn_t gfn, int level, unsigned long attrs)


