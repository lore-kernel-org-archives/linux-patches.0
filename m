Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C8437A82E;
	Sat, 17 Oct 2026 07:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222425; cv=none; b=utvtvHMpAuR599v9uSRAQScF8LyWc23mg0a1uDtdq41JMBcrsqNnZwHkb5FaqtX+UqlDWYb3ezWYVpl7VWgaetN/HIa2wLVUieAxJBI5SefBVKJVJOgxwor/v6NKzYvZtwwn5K1Cm2dZdB59e0B8tuU6A03EFv07Y5+znucj2TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222425; c=relaxed/simple;
	bh=200c43DEa75rYqEMyh4/uZINH7Lx8Qe5ZZzhSpX8Hxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8vMft45qi8CXF9T+Nrn/yPG8Se7A5x/wF4r1YYzuyQI8vFQE7spqL6Ys15BiRXJfvODukcsKyuuPt6XiAplgzddv8yeoz30p/k4bylx8/tKmcdHjvyYXL6IkGl9rMXu/0QjfTXypRUtP94P7cD+hDKasB7WVNPqaOJ6aoQzOU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zr29vzOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zr29vzOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3B11F000C5;
	Sat, 17 Oct 2026 07:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222424;
	bh=r9YxmsLTjPhiFwkEVKwk+A6gx0FFZxjGtWCjs4zo080=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zr29vzOf+q50cpNPC6zQQOhJwrDtksdXSL/7WgPNL5V/qJRL4gJh/ebeIBoIvGIH/
	 Rubo/gcg3h8A1AUjNXB1wMPSYcmgFuZE9VzhS2kvCjBtoYgXvBJAwRhleCJA0mDKyP
	 yPxymZ+W7z8CmkthgNUm9xYxDFyvYZlxms/63Suwcb7NP8g+xOhZj0/YeUwSFFbogb
	 eNsLv9T9mCQCT94m4XA5nbpGf1x13wVu28lfENVlfZUemwK1jNRXxSwWlJ14c1AL6z
	 KH23Yf9rAywnJPtqkuldQZZyAjJD+vsCnuEwkhT0mLPn7+jUHRgDz14fyjKWoJtsKT
	 74PpMZpLq01Xw==
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
Subject: [RFC PATCH v2 13/13] vfio/pci: Allow VFIO BAR mmap with an attached guest_memfd
Date: Sat, 17 Oct 2026 13:01:49 +0530
Message-ID: <20261017073149.1303738-14-aneesh.kumar@kernel.org>
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

Allow existing and new VFIO BAR VMAs when the attached guest_memfd was
created with GUEST_MEMFD_FLAG_MMAP. Keep BAR VMA exclusion when the flag
is absent. CPU mappings use the VFIO fd; mmap on the PFN-backed
guest_memfd fd remains disabled.

Invalidate existing BAR mappings, including huge mappings, during
attachment. Subsequent faults use base-page mappings so each page's
shared-range attributes are checked separately. Hold memory_lock from
the attribute check through PTE insertion.

Invalidate BAR mappings before private conversion and on provider
detach. Taking memory_lock for writing waits for active
faults, BAR read/write and ioeventfd accesses before invalidation.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst          | 29 +++++++++++-----
 drivers/vfio/pci/vfio_pci_core.c        | 16 ++++++---
 drivers/vfio/pci/vfio_pci_gmem.c        | 46 ++++++++++++++++---------
 drivers/vfio/pci/vfio_pci_gmem.h        |  2 ++
 drivers/vfio/pci/vfio_pci_gmem_access.c | 31 +++++++++++++++++
 include/linux/vfio_pci_core.h           |  5 +++
 6 files changed, 99 insertions(+), 30 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ca81e2762656..c1a660d56ba0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6514,8 +6514,9 @@ The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
 specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
 
   ============================= ================================================
-  GUEST_MEMFD_FLAG_MMAP         Enable using mmap() on the guest_memfd file
-                                descriptor.
+  GUEST_MEMFD_FLAG_MMAP         Enable userspace mappings. For VFIO PCI
+                                resources, mappings use the resource fd;
+                                otherwise they use the guest_memfd fd.
   GUEST_MEMFD_FLAG_INIT_SHARED  Make all memory in the file shared during
                                 KVM_CREATE_GUEST_MEMFD (memory files created
                                 without INIT_SHARED will be marked private).
@@ -6531,13 +6532,23 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
 
 With USE_RESOURCE, the resource mapping superblock supplies provider
 operations. Callbacks identify folio or PFN backing. PFN providers require
-INIT_SHARED and a VM supporting protected resource mappings; mmap is disabled.
-
-For a VFIO PCI device resource, creation fails with EBUSY if any VFIO BAR
-VMA or dma-buf export exists. This includes unfaulted mappings and mappings
-inherited by another process. Userspace must remove all such mappings before
-creating the device guest_memfd. While the provider is attached, mmap() on
-any VFIO fd for that device fails with EBUSY. Closing the guest_memfd releases
+INIT_SHARED and a VM supporting protected resource mappings. Mapping a
+PFN-backed guest_memfd fd is not supported.
+
+For a VFIO PCI device resource, creation fails with EBUSY if another provider
+or any dma-buf export exists. Without GUEST_MEMFD_FLAG_MMAP, creation also fails
+with EBUSY if any VFIO BAR VMA exists, including unfaulted or inherited VMAs.
+While attached without MMAP, mmap() on any VFIO fd for the device fails with
+EBUSY. With MMAP, existing BAR VMAs and new VFIO mmap() calls are allowed.
+Attachment revokes existing BAR translations, including huge mappings. While
+attached, faults use base-page mappings and check the guest_memfd attributes
+for the faulting page.
+
+Conversion to private memory revokes VFIO BAR translations before delegation.
+Access to a private page raises SIGBUS; conversion back to shared permits new
+faults on the existing VMA. Reset, power and memory-decode changes also revoke
+BAR translations. Detachment revokes translations and blocks faults until
+provider release clears the association. Closing the guest_memfd releases
 the provider once its last reference is dropped and cleanup completes.
 
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1258343a6832..96ec45a23505 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1713,9 +1713,7 @@ static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 	loff_t end = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
 	loff_t len = end - start;
 
-	/* An attached provider excludes every VFIO BAR VMA. */
-	if (!vdev->gmem)
-		unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
+	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
 	vfio_pci_gmem_invalidate(vdev);
 }
 
@@ -1766,6 +1764,15 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return VM_FAULT_SIGBUS;
 
+	/* Check each page separately while guest_memfd controls BAR access. */
+	if (order && vdev->gmem)
+		return VM_FAULT_FALLBACK;
+
+	/* memory_lock keeps revocation from racing admission and PTE insertion. */
+	if (!vfio_pci_gmem_access_allowed(vdev,
+				(u64)vmf->pgoff << PAGE_SHIFT, PAGE_SIZE))
+		return VM_FAULT_SIGBUS;
+
 	if (!order)
 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
 
@@ -1842,7 +1849,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	void __iomem *bar_io;
 
 	guard(rwsem_read)(&vdev->memory_lock);
-	if (vdev->gmem)
+
+	if (!vfio_pci_gmem_mmap_allowed(vdev))
 		return -EBUSY;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
diff --git a/drivers/vfio/pci/vfio_pci_gmem.c b/drivers/vfio/pci/vfio_pci_gmem.c
index 1ab65e43eb1d..e4e1b0de3cf6 100644
--- a/drivers/vfio/pci/vfio_pci_gmem.c
+++ b/drivers/vfio/pci/vfio_pci_gmem.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/guest_memfd.h>
 #include <linux/iommufd.h>
+#include <linux/kvm.h>
 #include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
@@ -88,8 +89,9 @@ static bool vfio_gmem_has_private_mmio(void *data)
  *
  * Require an opened IOMMUFD-backed file and exclude another provider and
  * dma-buf exports. Pin the source file and the existing vDEVICE after its
- * backend validates the VM. VFIO BAR VMAs and provider attachment are mutually
- * exclusive for the entire provider lifetime.
+ * backend validates the VM. Without MMAP, exclude BAR VMAs for the provider
+ * lifetime. With MMAP, revoke existing BAR mappings before attachment
+ * completes; subsequent faults check guest_memfd attributes.
  *
  * Return: Provider context on success, or an ERR_PTR() on failure.
  */
@@ -119,18 +121,28 @@ static void *vfio_gmem_attach(struct file *file, struct guest_memfd *gdev)
 	down_write(&vdev->memory_lock);
 	/*
 	 * Allow only one guest_memfd provider per device. Existing dma-buf
-	 * exports bypass guest_memfd access checks. A BAR VMA can fault even
-	 * if it has never installed a PTE. Exclude both under memory_lock,
-	 * paired with mmap admission and dma-buf export.
+	 * exports bypass guest_memfd access checks and cannot be revoked by
+	 * private conversion. BAR VMAs require MMAP: attachment revokes their
+	 * PTEs and subsequent faults check the provider's range attributes.
 	 */
-	if (vdev->gmem || atomic_read(&vdev->mmap_count) ||
-	    !list_empty(&vdev->dmabufs)) {
+	if (vdev->gmem || !list_empty(&vdev->dmabufs)) {
 		up_write(&vdev->memory_lock);
 		ret = -EBUSY;
 		goto fail;
 	}
+
+	/* Without MMAP, exclude unfaulted and inherited BAR VMAs too. */
+	if (!(gdev->flags & GUEST_MEMFD_FLAG_MMAP) &&
+	    atomic_read(&vdev->mmap_count)) {
+		up_write(&vdev->memory_lock);
+		ret = -EBUSY;
+		goto fail;
+	}
+
 	vdev->gmem = ctx;
 	up_write(&vdev->memory_lock);
+	/* Faults deny access until the vDEVICE and guest_memfd file are ready. */
+	vfio_gmem_invalidate_mmio(ctx);
 	ivdev = iommufd_device_attach_mmio_provider(vdev->vdev.iommufd_device,
 						    gdev->kvm, ctx,
 						    vfio_gmem_has_private_mmio,
@@ -238,8 +250,8 @@ static int vfio_gmem_get_pfn(void *data, u64 offset, unsigned long *pfn)
  * @context: attached provider context
  * @req: protected private request, or NULL for shared cleanup
  *
- * Check the virtual device ID before private mapping. The core has already
- * invalidated shared guest mappings; VFIO userspace mappings are excluded.
+ * Check the virtual device ID and revoke VFIO userspace mappings before
+ * private mapping. The core has already invalidated shared guest mappings.
  * Keep that mutex held across architecture cleanup and attribute publication.
  *
  * Called with the inode invalidate lock held. On success,
@@ -262,15 +274,14 @@ static int vfio_gmem_prepare_conversion(void *context,
 	}
 	if (req) {
 		/*
-		 * VFIO BAR read/write and ioeventfd accesses hold memory_lock for
-		 * reading through the MMIO operation. Wait for accesses that passed
-		 * the shared-range check before conversion took the inode invalidate
-		 * lock. New accesses to the attached range are denied because
+		 * VFIO faults, BAR read/write and ioeventfd accesses hold memory_lock
+		 * for reading through PTE insertion or the MMIO operation. Drain
+		 * admitted accesses and revoke existing PTEs before delegation.
+		 * New accesses to the attached range are denied because
 		 * host_accessible() cannot acquire that lock for reading with
 		 * filemap_invalidate_trylock_shared().
 		 */
-		down_write(&ctx->vdev->memory_lock);
-		up_write(&ctx->vdev->memory_lock);
+		vfio_gmem_invalidate_mmio(ctx);
 	}
 	return 0; /* Keep mmio_lock held until finish_conversion(). */
 }
@@ -299,8 +310,8 @@ static void vfio_gmem_finish_conversion(void *context,
  * vfio_gmem_detach() - stop invalidation callbacks before core teardown
  * @data: attached provider context
  *
- * Mark the provider detached under the VFIO memory lock. VFIO userspace
- * mappings remain excluded until release clears the provider association.
+ * Mark the provider detached under the VFIO memory lock and revoke BAR
+ * translations. Faults remain blocked until release clears the association.
  */
 static void vfio_gmem_detach(void *data)
 {
@@ -309,6 +320,7 @@ static void vfio_gmem_detach(void *data)
 	guard(iommufd_vdevice_mmio)(ctx->ivdev);
 	scoped_guard(rwsem_write, &ctx->vdev->memory_lock)
 		ctx->callbacks_detached = true;
+	vfio_gmem_invalidate_mmio(ctx);
 }
 
 /**
diff --git a/drivers/vfio/pci/vfio_pci_gmem.h b/drivers/vfio/pci/vfio_pci_gmem.h
index 76a2fbe1472a..91d3894bf8a9 100644
--- a/drivers/vfio/pci/vfio_pci_gmem.h
+++ b/drivers/vfio/pci/vfio_pci_gmem.h
@@ -21,4 +21,6 @@ struct vfio_pci_gmem {
 	bool callbacks_detached;
 };
 
+void vfio_gmem_invalidate_mmio(struct vfio_pci_gmem *ctx);
+
 #endif /* VFIO_PCI_GMEM_H */
diff --git a/drivers/vfio/pci/vfio_pci_gmem_access.c b/drivers/vfio/pci/vfio_pci_gmem_access.c
index b723a0877ff3..b7d15b2c1372 100644
--- a/drivers/vfio/pci/vfio_pci_gmem_access.c
+++ b/drivers/vfio/pci/vfio_pci_gmem_access.c
@@ -2,6 +2,7 @@
 /* Shared/private access and guest revocation are controlled by guest_memfd. */
 #include <linux/guest_memfd.h>
 #include <linux/iommufd.h>
+#include <linux/kvm.h>
 #include <linux/vfio_pci_core.h>
 
 #include "vfio_pci_gmem.h"
@@ -26,6 +27,36 @@ void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev)
 		ctx->gmem->invalidate(ctx->gmem);
 }
 
+/**
+ * vfio_gmem_invalidate_mmio() - revoke VFIO and shared guest BAR mappings
+ * @ctx: attached provider context
+ *
+ * Drain VFIO faults and host I/O, then remove existing BAR PTEs before
+ * delegation or teardown. The BAR zap also invalidates shared guest mappings
+ * while core callbacks remain attached. During private conversion the inode
+ * invalidate lock excludes new access through the host_accessible() check.
+ *
+ * Caller holds the vDEVICE MMIO mutex, except during attachment before the
+ * vDEVICE is assigned. No private conversion can start at that point.
+ */
+void vfio_gmem_invalidate_mmio(struct vfio_pci_gmem *ctx)
+{
+	if (ctx->ivdev)
+		lockdep_assert_held(&ctx->ivdev->mmio_lock);
+
+	vfio_pci_zap_and_down_write_memory_lock(ctx->vdev);
+	up_write(&ctx->vdev->memory_lock);
+}
+
+/* Serialize the creation flag check with attachment under memory_lock. */
+bool vfio_pci_gmem_mmap_allowed(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_pci_gmem *ctx = vdev->gmem;
+
+	lockdep_assert_held(&vdev->memory_lock);
+	return !ctx || (ctx->gmem->flags & GUEST_MEMFD_FLAG_MMAP);
+}
+
 /**
  * vfio_pci_gmem_access_allowed() - check a host BAR access against its range
  * @vdev: VFIO PCI device supplying the BAR
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 716b1dc443be..6d2af77295fe 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -158,12 +158,17 @@ struct vfio_pci_core_device {
 #if IS_ENABLED(CONFIG_VFIO_PCI_GMEM)
 extern const struct guest_memfd_provider_operations vfio_pci_gmem_provider_ops;
 void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev);
+bool vfio_pci_gmem_mmap_allowed(struct vfio_pci_core_device *vdev);
 bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
 				u64 offset, u64 size);
 bool vfio_pci_gmem_io_access_allowed(struct vfio_pci_core_device *vdev,
 				   void __iomem *io, size_t size);
 #else
 static inline void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev) {}
+static inline bool vfio_pci_gmem_mmap_allowed(struct vfio_pci_core_device *vdev)
+{
+	return true;
+}
 static inline bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
 					     u64 offset, u64 size)
 {
-- 
2.43.0

