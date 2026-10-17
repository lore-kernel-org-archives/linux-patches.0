Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CF73F54A4;
	Sat, 17 Oct 2026 07:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222385; cv=none; b=fuGN301qb7L8qd5n81o6jzCIt9sevqmvvE0DeEkzaIgpStvT0gmYgwo0g/nxkVybytBmZQv4mnZVAkOuOgZLBgoHdnkTSciRxou/sqloHQh2jSA6DvHzsxnnz57/1tm8CvY26Xh6v7EnX1O7Nr4iQxzP0OCmuvWovSI460gCsp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222385; c=relaxed/simple;
	bh=b/rIlY395fPVwLCop9vGlftt9/WY+cikcjMSwIbLKyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBH2vE1PftW2a2W3vtshV0ARnmpCgpxI45PClZNMSFRTk18/9OKkat0qv6FYUQSdxO+jFrcOiMzmWJ+zsBh+K162yb2SnFVjuyu5JyBimA6pTrCV8La4cVH6fc5AnDne7+miCUEsrZIhaD8ypNuoFrJzkwnq+WKcyxYI0z3r1WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OW86Gwb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OW86Gwb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB041F000C4;
	Sat, 17 Oct 2026 07:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222383;
	bh=GLuNvb9r0klQRC8/yCwu1Ou3zY6li7MM1WCs65OfKlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OW86Gwb6o/2Du8K5P7ILf2e0CGZa718vV+9Z2bhJgnvTt/velxHTSZaVKflnTd9Wl
	 K0NpIMBlCx10sBxebowQMv7A6z59WgvTwhnFb/qIpWx053p1OgZdulPBXNhP+sYya6
	 KN6EJoNf1bNAtjOd2Pt0f/+L/AjbTgRO4DnPH8kNi2s6MYK8NPeHTBV6JQQSINOYJj
	 ievLkFpg5z3H1GyTEniVbIPT1hznCH1ncHaYlxIq3Ly3okLw3F28hUNEINb4hnFWmz
	 G+OH0uP9jRPJ0svx11QSla7vkxNDGasl/iRZg451SzNUb2LhnnADxtt+Xa9FKZ+RLY
	 FtkOvpsjgW8+A==
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
Subject: [RFC PATCH v2 08/13] vfio/pci: Provide guest_memfd backing for PCI BARs
Date: Sat, 17 Oct 2026 13:01:44 +0530
Message-ID: <20261017073149.1303738-9-aneesh.kumar@kernel.org>
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

Allow an ordinary VFIO PCI device fd to supply BAR memory to
guest_memfd. Validate eligible BAR ranges and provide their PFNs for
shared guest mappings. Keep the VFIO file and its IOMMUFD vDEVICE alive
while the provider is attached.

Reject attachment while VFIO BAR mappings or dma-buf exports exist.

Hold the vDEVICE MMIO mutex across conversion and attribute updates.
Before private conversion, take the VFIO memory lock for writing to wait
for ongoing BAR reads and writes to finish. Host access checks try
inode invalidate lock without waiting, avoiding deadlock with
conversion, which acquires that lock first.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst   |   6 +
 drivers/vfio/pci/Makefile        |   1 +
 drivers/vfio/pci/vfio_pci.c      |   3 +
 drivers/vfio/pci/vfio_pci_gmem.c | 325 +++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_gmem.h |   3 +
 include/linux/vfio_pci_core.h    |   1 +
 6 files changed, 339 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 078f672a115b..0bc38d53a1b3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6533,6 +6533,12 @@ With USE_RESOURCE, the resource mapping superblock supplies provider
 operations. Callbacks identify folio or PFN backing. PFN providers require
 INIT_SHARED and a VM supporting protected resource mappings; mmap is disabled.
 
+For a VFIO PCI device resource, creation fails with EBUSY if any VFIO BAR
+VMA or dma-buf export exists. This includes unfaulted mappings and mappings
+inherited by another process. Userspace must remove all such mappings before
+creating the device guest_memfd. While the provider is attached, mmap() on
+any VFIO fd for that device fails with EBUSY.
+
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
 private fault (unless in-place conversion is disabled and the backing
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index d491b38ad9c2..1abb7448c8b1 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -4,6 +4,7 @@ vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_con
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_GMEM) += vfio_pci_gmem_access.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_GMEM) += vfio_pci_gmem.o
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 830369ff878d..ad4e612c3336 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -147,6 +147,9 @@ static int vfio_pci_init_dev(struct vfio_device *core_vdev)
 }
 
 static const struct vfio_device_ops vfio_pci_ops = {
+#if IS_ENABLED(CONFIG_VFIO_PCI_GMEM)
+	.gmem_provider_ops = &vfio_pci_gmem_provider_ops,
+#endif
 	.name		= "vfio-pci",
 	.init		= vfio_pci_init_dev,
 	.release	= vfio_pci_core_release_dev,
diff --git a/drivers/vfio/pci/vfio_pci_gmem.c b/drivers/vfio/pci/vfio_pci_gmem.c
new file mode 100644
index 000000000000..8cb5f0cb3bb8
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_gmem.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/guest_memfd.h>
+#include <linux/iommufd.h>
+#include <linux/overflow.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/vfio_pci_core.h>
+
+#include "../vfio.h"
+#include "vfio_pci_priv.h"
+#include "vfio_pci_gmem.h"
+
+/**
+ * vfio_gmem_resolve_bar_range() - validate and resolve a VFIO BAR interval
+ * @ctx: attached VFIO provider
+ * @offset: byte offset in the VFIO region namespace
+ * @size: interval length in bytes
+ * @bar: output BAR index
+ * @bar_offset: output byte offset within that BAR
+ * @pa: output starting physical address
+ *
+ * Check alignment, mmap eligibility, and wrapper and BAR bounds. These checks
+ * establish the provider interval; the VMM approves the protected REC
+ * physical-address claim.
+ * Output parameters are valid only on success.
+ *
+ * Return: 0 on success or -EINVAL for an ineligible interval.
+ */
+static int vfio_gmem_resolve_bar_range(struct vfio_pci_gmem *ctx, u64 offset,
+		u64 size, u32 *bar, u64 *bar_offset, phys_addr_t *pa)
+{
+	struct pci_dev *pdev = ctx->vdev->pdev;
+	resource_size_t start, len;
+	u32 index = offset >> VFIO_PCI_OFFSET_SHIFT;
+	u64 off = offset & ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
+
+	if (!size || !PAGE_ALIGNED(offset | size))
+		return -EINVAL;
+
+	if (offset >= ctx->gmem->size ||
+	    size > ctx->gmem->size - offset)
+		return -EINVAL;
+
+	if (index >= PCI_STD_NUM_BARS)
+		return -EINVAL;
+
+	start = pci_resource_start(pdev, index);
+	len = pci_resource_len(pdev, index);
+
+	if (!ctx->vdev->bar_mmap_supported[index] ||
+	    !(pci_resource_flags(pdev, index) & IORESOURCE_MEM) ||
+	    !PAGE_ALIGNED(start))
+		return -EINVAL;
+
+	if (off >= len || size > len - off)
+		return -EINVAL;
+
+	/* The interval must not cross into the next VFIO region. */
+	if (size > (1ULL << VFIO_PCI_OFFSET_SHIFT) - off)
+		return -EINVAL;
+
+	if (check_add_overflow(start, off, pa))
+		return -EINVAL;
+
+	*bar = index;
+	*bar_offset = off;
+	return 0;
+}
+
+/**
+ * vfio_gmem_has_private_mmio() - check for private BAR ranges
+ * @data: attached VFIO provider context
+ *
+ * Return: true if the core has committed private BAR ranges.
+ */
+static bool vfio_gmem_has_private_mmio(void *data)
+{
+	struct vfio_pci_gmem *ctx = data;
+
+	lockdep_assert_held(&ctx->ivdev->mmio_lock);
+	return ctx->gmem->has_private(ctx->gmem);
+}
+
+/**
+ * vfio_gmem_attach() - attach the ordinary VFIO PCI fd to guest_memfd
+ * @file: open VFIO device file supplying the BAR namespace
+ * @gdev: guest_memfd core callbacks and owning VM
+ *
+ * Require an opened IOMMUFD-backed file and exclude another provider and
+ * dma-buf exports. Pin the source file and the existing vDEVICE after its
+ * backend validates the VM. VFIO BAR VMAs and provider attachment are mutually
+ * exclusive for the entire provider lifetime.
+ *
+ * Return: Provider context on success, or an ERR_PTR() on failure.
+ */
+static void *vfio_gmem_attach(struct file *file, struct guest_memfd *gdev)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_pci_core_device *vdev =
+		container_of(df->device, struct vfio_pci_core_device, vdev);
+	struct vfio_pci_gmem *ctx;
+	struct iommufd_vdevice *ivdev;
+	int ret;
+
+	ctx = kzalloc_obj(*ctx);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->vdev = vdev;
+	ctx->gmem = gdev;
+
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	/* Paired with smp_store_release() after vfio_df_open(). */
+	if (!smp_load_acquire(&df->access_granted) || !df->iommufd) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	down_write(&vdev->memory_lock);
+	/*
+	 * Allow only one guest_memfd provider per device. Existing dma-buf
+	 * exports bypass guest_memfd access checks. A BAR VMA can fault even
+	 * if it has never installed a PTE. Exclude both under memory_lock,
+	 * paired with mmap admission and dma-buf export.
+	 */
+	if (vdev->gmem || atomic_read(&vdev->mmap_count) ||
+	    !list_empty(&vdev->dmabufs)) {
+		up_write(&vdev->memory_lock);
+		ret = -EBUSY;
+		goto fail;
+	}
+	vdev->gmem = ctx;
+	up_write(&vdev->memory_lock);
+	ivdev = iommufd_device_attach_mmio_provider(vdev->vdev.iommufd_device,
+						    gdev->kvm, ctx,
+						    vfio_gmem_has_private_mmio,
+						    &ctx->owner);
+	if (IS_ERR(ivdev)) {
+		ret = PTR_ERR(ivdev);
+		scoped_guard(rwsem_write, &vdev->memory_lock)
+			vdev->gmem = NULL;
+		goto fail;
+	}
+	scoped_guard(rwsem_write, &vdev->memory_lock)
+		ctx->ivdev = ivdev;
+	/* Defer VFIO last-close and IOMMUFD unbind until gmem is released. */
+	ctx->resource = get_file(file);
+	mutex_unlock(&vdev->vdev.dev_set->lock);
+	return ctx;
+fail:
+	mutex_unlock(&vdev->vdev.dev_set->lock);
+	kfree(ctx);
+	return ERR_PTR(ret);
+}
+
+/**
+ * vfio_gmem_bind() - bind an eligible BAR interval to a memslot
+ * @data: provider context returned by vfio_gmem_attach()
+ * @offset: byte offset in the VFIO region namespace
+ * @size: length in bytes
+ * @binding: receives the pinned mapping owner and virtual device ID
+ *
+ * Validate the BAR interval and reserve the BAR through the ordinary
+ * VFIO iomap machinery.
+ *
+ * Called with the inode invalidate lock held;
+ * Return: 0 on success or a negative error code.
+ */
+static int vfio_gmem_bind(void *data, u64 offset, u64 size,
+		struct guest_memfd_device_binding *binding)
+{
+	struct vfio_pci_gmem *ctx = data;
+	phys_addr_t pa;
+	u64 off;
+	u32 bar;
+	int ret;
+
+	guard(iommufd_vdevice_mmio)(ctx->ivdev);
+	ret = vfio_gmem_resolve_bar_range(ctx, offset, size, &bar, &off, &pa);
+	if (ret)
+		return ret;
+
+	/* Reserve the physical resource with the ordinary VFIO BAR machinery. */
+	ret = PTR_ERR_OR_ZERO(vfio_pci_core_get_iomap(ctx->vdev, bar));
+	if (!ret) {
+		binding->owner = ctx->owner;
+		binding->vdev_id = ctx->ivdev->virt_id;
+	}
+	return ret;
+}
+
+/**
+ * vfio_gmem_get_pfn() - obtain a shared BAR PFN for a guest fault
+ * @data: attached provider context
+ * @offset: page-aligned byte offset in the VFIO region namespace
+ * @pfn: receives the bare BAR PFN
+ *
+ * Check shared-access admission, power state and PCI memory decoding under
+ * the VFIO memory lock before resolving the resource. The PFN has no RAM
+ * page reference to release. The core checks completed attributes and the
+ * fault path checks the invalidation sequence before installing a mapping.
+ *
+ * Guest_memfd calls this only for shared device ranges. Private mappings use
+ * the physical address from an approved protected device request through
+ * kvm_arch_gmem_device_map(). Installing private mappings through ordinary
+ * PFN faults would bypass that approval path.
+ *
+ * Called with the inode invalidate lock held
+ * Return: 0 on success, -EAGAIN while shared access is unavailable, -ENODEV
+ * after detachment, or a resource-validation error.
+ */
+static int vfio_gmem_get_pfn(void *data, u64 offset, unsigned long *pfn)
+{
+	struct vfio_pci_gmem *ctx = data;
+	struct vfio_pci_core_device *vdev = ctx->vdev;
+	phys_addr_t pa;
+	u64 off;
+	u32 bar;
+	int ret;
+
+	guard(rwsem_read)(&vdev->memory_lock);
+	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
+		return -EAGAIN;
+
+	ret = vfio_gmem_resolve_bar_range(ctx, offset, PAGE_SIZE,
+					  &bar, &off, &pa);
+	if (!ret)
+		*pfn = PHYS_PFN(pa);
+	return ret;
+}
+
+/**
+ * vfio_gmem_prepare_conversion() - serialize device range conversion
+ * @context: attached provider context
+ * @req: protected private request, or NULL for shared cleanup
+ *
+ * Check the virtual device ID before private mapping. The core has already
+ * invalidated shared guest mappings; VFIO userspace mappings are excluded.
+ * Keep that mutex held across architecture cleanup and attribute publication.
+ *
+ * Called with the inode invalidate lock held. On success,
+ * vfio_gmem_finish_conversion() must release the retained MMIO mutex.
+ * Return: 0 with the MMIO mutex held, or a negative error with it released.
+ */
+static int vfio_gmem_prepare_conversion(void *context,
+		const struct guest_memfd_device_request *req)
+{
+	struct vfio_pci_gmem *ctx = context;
+
+	iommufd_vdevice_mmio_lock(ctx->ivdev);
+	if (req && req->vdev_id != ctx->ivdev->virt_id) {
+		iommufd_vdevice_mmio_unlock(ctx->ivdev);
+		return -EPERM;
+	}
+	if (req) {
+		/*
+		 * VFIO BAR read/write and ioeventfd accesses hold memory_lock for
+		 * reading through the MMIO operation. Wait for accesses that passed
+		 * the shared-range check before conversion took the inode invalidate
+		 * lock. New accesses to the attached range are denied because
+		 * host_accessible() cannot acquire that lock for reading with
+		 * filemap_invalidate_trylock_shared().
+		 */
+		down_write(&ctx->vdev->memory_lock);
+		up_write(&ctx->vdev->memory_lock);
+	}
+	return 0; /* Keep mmio_lock held until finish_conversion(). */
+}
+
+/**
+ * vfio_gmem_finish_conversion() - release the conversion mutex
+ * @context: attached provider context
+ * @req: protected private request, or NULL for shared cleanup
+ *
+ * Release the MMIO mutex after the core publishes completed attributes.
+ * Subsequent faults and host I/O check their own range; no device-wide private
+ * or shared admission state is published here.
+ *
+ * Called with the inode invalidate lock and the vDEVICE MMIO mutex held
+ * after successful preparation.
+ */
+static void vfio_gmem_finish_conversion(void *context,
+		const struct guest_memfd_device_request *req)
+{
+	struct vfio_pci_gmem *ctx = context;
+
+	iommufd_vdevice_mmio_unlock(ctx->ivdev);
+}
+
+/**
+ * vfio_gmem_release() - release a provider after successful core cleanup
+ * @data: provider context to release
+ *
+ * Detach from the pinned vDEVICE, clear the VFIO provider association and
+ * drop the source file reference before freeing the context.
+ *
+ * Takes the VFIO device-set lock and the vDEVICE MMIO and VFIO memory
+ * locks while detaching.
+ */
+static void vfio_gmem_release(void *data)
+{
+	struct vfio_pci_gmem *ctx = data;
+	struct vfio_pci_core_device *vdev = ctx->vdev;
+
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	iommufd_vdevice_detach_mmio_provider(ctx->ivdev);
+	down_write(&vdev->memory_lock);
+	vdev->gmem = NULL;
+	up_write(&vdev->memory_lock);
+	mutex_unlock(&vdev->vdev.dev_set->lock);
+	fput(ctx->resource);
+	kfree(ctx);
+}
+
+const struct guest_memfd_provider_operations vfio_pci_gmem_provider_ops = {
+	.attach = vfio_gmem_attach,
+	.bind = vfio_gmem_bind,
+	.get_pfn = vfio_gmem_get_pfn,
+	.prepare_conversion = vfio_gmem_prepare_conversion,
+	.finish_conversion = vfio_gmem_finish_conversion,
+	.release = vfio_gmem_release,
+};
+EXPORT_SYMBOL_GPL(vfio_pci_gmem_provider_ops);
+
+MODULE_IMPORT_NS("IOMMUFD");
diff --git a/drivers/vfio/pci/vfio_pci_gmem.h b/drivers/vfio/pci/vfio_pci_gmem.h
index a8edd20357e7..b4ca831196fd 100644
--- a/drivers/vfio/pci/vfio_pci_gmem.h
+++ b/drivers/vfio/pci/vfio_pci_gmem.h
@@ -9,7 +9,10 @@ struct vfio_pci_core_device;
 
 struct vfio_pci_gmem {
 	struct guest_memfd *gmem;
+	struct vfio_pci_core_device *vdev;
 	struct iommufd_vdevice *ivdev;
+	struct file *resource;
+	unsigned long owner;
 };
 
 #endif /* VFIO_PCI_GMEM_H */
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 9f8aa81eb1c9..716b1dc443be 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -156,6 +156,7 @@ struct vfio_pci_core_device {
 };
 
 #if IS_ENABLED(CONFIG_VFIO_PCI_GMEM)
+extern const struct guest_memfd_provider_operations vfio_pci_gmem_provider_ops;
 void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev);
 bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
 				u64 offset, u64 size);
-- 
2.43.0

