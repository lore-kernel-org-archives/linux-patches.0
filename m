Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBC140B11F;
	Sat, 17 Oct 2026 07:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222355; cv=none; b=eGOIU7+osICAvCF5vPnS750Y6q3z4tJipGDjPuHUVNTGiOEYxNmUpKsZS8ImT0udxVT46L+wJEAm7a2BIgmSb1KWEjsldQrIjOnL2tGeREhjjzx/ikF9ekBN1QncMjmORgX+JAANikZWkJXP2z785VxciXBw/jqtZ/cdFWS9W7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222355; c=relaxed/simple;
	bh=JfxCjDFg4IerbLzgO4uquCB2H/xB/9+RQBQMX/GujkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VH7EEOrUaWmpquqx24n3Zk2oB9Lau5gU5n2JmdXu+6hQDOpqIWsjQuxf/X6x/K4RhRIIcAYnOReZSchGsqh7rZ9In/Dfrib5JhwnVlpqYxCaqYLy9c66HNHJvI+bv6PYnmpCMQIcvcq+8Q5ZQJCSCkDhMj/TCYh/ugFpz8Ia1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHKfzdoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHKfzdoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6641F000C4;
	Sat, 17 Oct 2026 07:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222353;
	bh=TZjBl2dAOVfDI9Efx8Hvdr7TmXSsAIRVPzW9BJfE8LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHKfzdoqw+Y6vfDqctwtUaQYBmW56p4ln6iqdXehlzf6zwIaeyRY4tN7YznQU0iGT
	 Y3H6i48Hn2Wz1BImasDnSb9WZuOfZ0iRmt3vhHPZ6WSCFlPl8p3NyojMBOGBEHr/MA
	 4dnLN6Jjrm0YFhf98Im59hMa14nDQe7DC+eDTPq6wmm7MGGPXRkzusoRKHOKRqjwe/
	 H/rAHFMfUnh0owmNx088puUzMuiC9ppyPjd5nJcG/T9zIOeWMrBrD2z7bqaVmDnWwW
	 4YXNAfhoGN3s4zkxyA1W3m4dLmus3wqUcMPEcvp7tRHNotPLAxwzwFubaE0SYBfVDQ
	 5L1VimD+0VWLQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v2 04/13] KVM: guest_memfd: Add device provider access callbacks
Date: Sat, 17 Oct 2026 13:01:40 +0530
Message-ID: <20261017073149.1303738-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose callbacks for device providers to check whether a range is shared,
query whether private ranges remain, and invalidate shared guest mappings.

Use a nonblocking acquisition of the inode invalidate lock for host
access checks, avoiding deadlock with conversion while a provider holds
its memory lock. Invalidate shared mappings under SRCU and the KVM MMU
lock, advancing the MMU invalidation sequence so concurrent faults retry.

Initialize callback state before attaching the provider and publish the
guest_memfd file after creation completes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |   6 ++
 virt/kvm/guest_memfd.c      | 117 ++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 7ae8df07a26e..f0c62889f823 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -26,6 +26,12 @@ struct guest_memfd {
 	struct kvm *kvm;
 	u64 size;
 	u64 flags;
+	struct file *gmem_file;
+
+	/* Revoke shared guest translations synchronously. */
+	void (*invalidate)(struct guest_memfd *gmem);
+	bool (*has_private)(struct guest_memfd *gmem);
+	bool (*host_accessible)(struct guest_memfd *gmem, u64 offset, u64 size);
 };
 
 /**
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2782e64e9c8..d2b1e2e9dfee 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1066,6 +1066,118 @@ int __weak kvm_arch_gmem_device_unmap(struct kvm *kvm, u64 gpa, u64 size)
 	return -EOPNOTSUPP;
 }
 
+static bool gmem_device_host_accessible(struct guest_memfd *gdev,
+		u64 offset, u64 size)
+{
+	struct file *file = READ_ONCE(gdev->gmem_file);
+	struct inode *inode;
+	pgoff_t first, last;
+	bool shared;
+
+	if (!file)
+		return false;
+
+	/* Unwrapped BAR offsets have no private guest_memfd mappings. */
+	if (offset >= gdev->size)
+		return true;
+
+	size = min(size, gdev->size - offset);
+	if (!size)
+		return false;
+
+	first = offset >> PAGE_SHIFT;
+	last = ((offset + size - 1) >> PAGE_SHIFT) + 1;
+	inode = file_inode(file);
+	/*
+	 * Keep guest_memfd attributes stable against conversion while checking
+	 * host access. This check only reads attributes, so a shared lock lets
+	 * other access checks run concurrently.
+	 *
+	 * VFIO callers hold memory_lock, but conversion takes the invalidate
+	 * lock exclusively before taking memory_lock for writing.
+	 * Waiting here could deadlock with conversion. Try the shared lock and
+	 * deny access if it cannot be acquired.
+	 */
+	if (!filemap_invalidate_trylock_shared(inode->i_mapping))
+		return false;
+
+	shared = __kvm_gmem_range_has_attributes(inode, first, last - first, 0);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+	return shared;
+}
+
+/**
+ * gmem_device_invalidate() - invalidate shared guest mappings of device memory
+ * @gdev: device guest_memfd whose provider is revoking access
+ *
+ * VFIO invokes this callback when zapping BAR mappings. Removing host BAR
+ * mappings alone leaves guest stage-2 mappings intact, so unmap the shared
+ * ranges in memslots backed by this guest_memfd and flush guest TLBs as needed.
+ * Advance the MMU invalidation sequence so faults that obtained a provider PFN
+ * before revocation retry instead of installing a stale mapping.
+ *
+ * SRCU protects memslot traversal, and the KVM MMU lock serializes unmapping
+ * with guest faults. Do not acquire the inode invalidate lock: conversion may
+ * already hold it, and VFIO callers hold memory_lock in the reverse order.
+ *
+ * Caller holds the provider memory lock to exclude new provider PFN
+ * lookups during invalidation.
+ */
+static void gmem_device_invalidate(struct guest_memfd *gdev)
+{
+	struct file *file = gdev->gmem_file;
+	struct kvm *kvm = gdev->kvm;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int srcu_idx, bkt, as;
+	bool flush = false, found_memslot = false;
+
+	if (!file)
+		return;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	KVM_MMU_LOCK(kvm);
+
+	for (as = 0; as < kvm_arch_nr_memslot_as_ids(kvm); as++) {
+		slots = __kvm_memslots(kvm, as);
+		kvm_for_each_memslot(slot, bkt, slots) {
+			struct kvm_gfn_range range = {
+				.slot = slot,
+				.start = slot->base_gfn,
+				.end = slot->base_gfn + slot->npages,
+				.attr_filter = KVM_FILTER_SHARED,
+				.may_block = false,
+			};
+
+			if (READ_ONCE(slot->gmem.file) != file)
+				continue;
+
+			if (!found_memslot) {
+				found_memslot = true;
+				kvm_mmu_invalidate_start(kvm);
+			}
+
+			flush |= kvm_mmu_unmap_gfn_range(kvm, &range);
+		}
+	}
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	if (found_memslot)
+		kvm_mmu_invalidate_end(kvm);
+
+	KVM_MMU_UNLOCK(kvm);
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+}
+
+/* The attribute tree owns mapping state; this summary is read under provider locks. */
+static bool gmem_device_has_private(struct guest_memfd *gdev)
+{
+	struct gmem_inode *gi = container_of(gdev, struct gmem_inode, device);
+
+	return READ_ONCE(gi->device_has_private);
+}
+
 static void kvm_gmem_device_update_private(struct gmem_inode *gi)
 {
 	MA_STATE(mas, &gi->attributes, 0, 0);
@@ -1291,6 +1403,9 @@ static int kvm_gmem_attach_resource(struct kvm *kvm,
 	gi->device.size = i_size_read(inode);
 	/* The provider needs creation flags before attachment is published. */
 	gi->device.flags = gi->flags;
+	gi->device.invalidate = gmem_device_invalidate;
+	gi->device.host_accessible = gmem_device_host_accessible;
+	gi->device.has_private = gmem_device_has_private;
 	provider = ops->attach(resource_file, &gi->device);
 	if (IS_ERR(provider)) {
 		ret = PTR_ERR(provider);
@@ -1359,6 +1474,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 	xa_init(&f->bindings);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
+	WRITE_ONCE(GMEM_I(inode)->device.gmem_file, file);
 	fd_install(fd, file);
 	return fd;
 
@@ -1743,6 +1859,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
 	gi->device_has_private = false;
+	memset(&gi->device, 0, sizeof(gi->device));
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
-- 
2.43.0

