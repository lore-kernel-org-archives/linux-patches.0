Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F9E2F37;
	Tue, 20 May 2025 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750012; cv=none; b=Umz3ethJYCU8IQsrY0MA9f1rhO8BOC8qUaUWK0ZUG4Z36yDMt0KxyJ/3t8V14psWXZvJ+YY82Ayd425m/WVFgfNS6sC5LFRiIWZ9+wZSZsPkz1934G1ym/8hLr1l7FqBh9LKayNwEgs75CxCOqcNfv43YWn6pbF4ONzblbjrlU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750012; c=relaxed/simple;
	bh=pwx3ODVa5J6LOeSVg0WhrH+TOWam2lGp1Wt01xVH/uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHW21jTl0OlXC8w5DuFAzy2AKs9sVwUdLDK6tBHtCf8MkO50nDLdYdvHAlFogoZY56e9if3+snocavlHBKsX1IgGKb5pniTNPrt/3sfFFHwu70bBhlRW4uptzq3U9+sQCzK6n0pqLm7cdVr0V2eXwaj+InNg4sK54Om00nkBsHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiaBRADi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiaBRADi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ED2C4CEE9;
	Tue, 20 May 2025 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750012;
	bh=pwx3ODVa5J6LOeSVg0WhrH+TOWam2lGp1Wt01xVH/uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiaBRADif4BkyPrwF3jIFuag4mOALfuz/1yaJM6Adzd9fe1020i10FVPgzzR7biab
	 aR979AT6hgJeiGBcoyRnv7Ua4b3sIWLtPk9IFqH9lBdaURk6LSpNSIa9YWH6qqoqCG
	 6vPoR5S5ndL0LOEzZmXosyYjaTK/LaC673vqevtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/143] KVM: Add member to struct kvm_gfn_range to indicate private/shared
Date: Tue, 20 May 2025 15:49:29 +0200
Message-ID: <20250520125810.621798301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaku Yamahata <isaku.yamahata@intel.com>

[ Upstream commit dca6c88532322830d5d92486467fcc91b67a9ad8 ]

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on: enum kvm_gfn_range_filter
attr_filter. Update the core zapping operations to set them appropriately.

TDX utilizes two GPA aliases for the same memslots, one for memory that is
for private memory and one that is for shared. For private memory, KVM
cannot always perform the same operations it does on memory for default
VMs, such as zapping pages and having them be faulted back in, as this
requires guest coordination. However, some operations such as guest driven
conversion of memory between private and shared should zap private memory.

Internally to the MMU, private and shared mappings are tracked on separate
roots. Mapping and zapping operations will operate on the respective GFN
alias for each root (private or shared). So zapping operations will by
default zap both aliases. Add fields in struct kvm_gfn_range to allow
callers to specify which aliases so they can only target the aliases
appropriate for their specific operation.

There was feedback that target aliases should be specified such that the
default value (0) is to operate on both aliases. Several options were
considered. Several variations of having separate bools defined such
that the default behavior was to process both aliases. They either allowed
nonsensical configurations, or were confusing for the caller. A simple
enum was also explored and was close, but was hard to process in the
caller. Instead, use an enum with the default value (0) reserved as a
disallowed value. Catch ranges that didn't have the target aliases
specified by looking for that specific value.

Set target alias with enum appropriately for these MMU operations:
 - For KVM's mmu notifier callbacks, zap shared pages only because private
   pages won't have a userspace mapping
 - For setting memory attributes, kvm_arch_pre_set_memory_attributes()
   chooses the aliases based on the attribute.
 - For guest_memfd invalidations, zap private only.

Link: https://lore.kernel.org/kvm/ZivIF9vjKcuGie3s@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-3-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 9129633d568e ("KVM: x86/mmu: Prevent installing hugepages when mem attributes are changing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c   |  6 ++++++
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/guest_memfd.c   |  2 ++
 virt/kvm/kvm_main.c      | 14 ++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9242c0649adf1..4943732e07cd7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7633,6 +7633,12 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	/* Unmap the old attribute page. */
+	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+		range->attr_filter = KVM_FILTER_SHARED;
+	else
+		range->attr_filter = KVM_FILTER_PRIVATE;
+
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15206450929d5..2e836d44f7386 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -260,11 +260,17 @@ union kvm_mmu_notifier_arg {
 	unsigned long attributes;
 };
 
+enum kvm_gfn_range_filter {
+	KVM_FILTER_SHARED		= BIT(0),
+	KVM_FILTER_PRIVATE		= BIT(1),
+};
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	enum kvm_gfn_range_filter attr_filter;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8f079a61a56db..bb062d3d24572 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -118,6 +118,8 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
+			/* guest memfd is relevant to only private mappings. */
+			.attr_filter = KVM_FILTER_PRIVATE,
 		};
 
 		if (!found_memslot) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 279e03029ce14..b99de3b5ffbc0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -632,6 +632,11 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.attr_filter = KVM_FILTER_SHARED;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -2454,6 +2459,14 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
 
+	/*
+	 * If/when KVM supports more attributes beyond private .vs shared, this
+	 * _could_ set KVM_FILTER_{SHARED,PRIVATE} appropriately if the entire target
+	 * range already has the desired private vs. shared state (it's unclear
+	 * if that is a net win).  For now, KVM reaches this point if and only
+	 * if the private flag is being toggled, i.e. all mappings are in play.
+	 */
+
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		slots = __kvm_memslots(kvm, i);
 
@@ -2510,6 +2523,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
+		.arg.attributes = attributes,
 		.handler = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
 		.flush_on_ret = true,
-- 
2.39.5



