Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E1437A82E;
	Sat, 17 Oct 2026 07:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222378; cv=none; b=bFp7EBjBDuVLB4euxt9MhUtL3fUY8JC6wogBIZuwHm1tco+pmLhzw3nDhudnIqtZJlZ5DPnYFXSP3Xsqzp4tE1H7zooW0hE9XV6/5VDGsGDipWMn9lokZlBRCUDlGy5OqU5XcRlGPrQrW+yeGUNAiZ3VoktUD1bSqgKfXQu5HSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222378; c=relaxed/simple;
	bh=quFViuijSjHUjUQYOG6b6zo1VYB+1ufy2n5W5Ks62MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lj5NAPsjicH28OaVms+4Of+d0CcbDuAqHcha8+pjALZ7F1E1SzOqRghIwIBIwDs5ydV/kzt/QNr5n1o6iar6/0DbExjept7ZVQ3OoKXbpjimvZO30leUuVApIbJXRLlKsZmO3i+mWpCC8V5l+9xUA/Q0b2MOPlDwIVMeb1CvGEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUFn38SK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUFn38SK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9331F000C5;
	Sat, 17 Oct 2026 07:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222376;
	bh=VBG9ScCfiH6fz7puKiU2lwWfHfIitW9s1vc4ZSpI5jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUFn38SKC3FtY+Vcumtl5AFEXJahaoPGIfunkLk9/3nKBPUm6Rt3A7B0CbjNwbutT
	 wsm8CtNTF1RJbohJwyqFCD87JvSnbmDv1u8BI8Cmg1bvwNv85h9kdnZOgUEKg/RNE4
	 jL8oQZCI3AiwGptwfz6cjXn7j8R7skXajzk4KVXEKn8b0OM4J0jxlScJoATP4HSQqS
	 0xjgDyhL1dUDugsa07FkFWBge2U2985fmZQTk8lsUrqiaJJHJ88TstSkOdJTNrAHsh
	 aACbxWpbTNGkNtOzPJY2DXfpnfqvShxQth7g+R5A4ZUlXOd+p8f6shhX5SE0TW+RNm
	 aIvwPHy36eGPA==
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
Subject: [RFC PATCH v2 07/13] vfio/pci: Restrict host BAR access for guest_memfd providers
Date: Sat, 17 Oct 2026 13:01:43 +0530
Message-ID: <20261017073149.1303738-8-aneesh.kumar@kernel.org>
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

Add the access and invalidation helpers needed by a PCI guest_memfd
provider. Check shared-range attributes for BAR read/write and ioeventfd
access, and revoke shared guest mappings when VFIO changes device state.

Reject new VFIO mmap and dma-buf exports while a provider is attached.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/Kconfig                |  11 +++
 drivers/vfio/pci/Makefile               |   1 +
 drivers/vfio/pci/vfio_pci_core.c        |   9 ++-
 drivers/vfio/pci/vfio_pci_dmabuf.c      |  10 +++
 drivers/vfio/pci/vfio_pci_gmem.h        |  15 ++++
 drivers/vfio/pci/vfio_pci_gmem_access.c | 101 ++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c        |  13 ++-
 include/linux/vfio_pci_core.h           |  22 ++++++
 8 files changed, 178 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.h
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem_access.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 296bf01e185e..e5dedf3e4a65 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -55,6 +55,17 @@ config VFIO_PCI_ZDEV_KVM
 
 	  To enable s390x KVM vfio-pci extensions, say Y.
 
+config VFIO_PCI_GMEM
+	bool "VFIO PCI device guest_memfd resource provider"
+	depends on VFIO_PCI && IOMMUFD && KVM
+	depends on KVM_GUEST_MEMFD
+	help
+	  Allow the VFIO PCI device fd to provide BAR PFNs to guest_memfd,
+	  including confidential-device range conversion through its
+	  existing IOMMUFD vDEVICE. This requires a capable TSM backend.
+	  Shared access is revoked before private range mapping and is
+	  restored only after private mappings and device state permit it.
+
 config VFIO_PCI_DMABUF
 	def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
 
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 6138f1bf241d..d491b38ad9c2 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -3,6 +3,7 @@
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_GMEM) += vfio_pci_gmem_access.o
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 795b4ab1174e..1258343a6832 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1713,7 +1713,10 @@ static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 	loff_t end = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
 	loff_t len = end - start;
 
-	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
+	/* An attached provider excludes every VFIO BAR VMA. */
+	if (!vdev->gmem)
+		unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
+	vfio_pci_gmem_invalidate(vdev);
 }
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
@@ -1838,6 +1841,10 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	u64 phys_len, req_len, pgoff, req_start;
 	void __iomem *bar_io;
 
+	guard(rwsem_read)(&vdev->memory_lock);
+	if (vdev->gmem)
+		return -EBUSY;
+
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..b3ae2d97629f 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -306,6 +306,16 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	/* dma_buf_put() now frees priv */
 	INIT_LIST_HEAD(&priv->dmabufs_elm);
 	down_write(&vdev->memory_lock);
+	/*
+	 * dma-buf consumers bypass guest_memfd range access checks, and their
+	 * mappings are not revoked by conversion to private memory. Exclude
+	 * exports while attached; memory_lock serializes this with attachment.
+	 */
+	if (vdev->gmem) {
+		up_write(&vdev->memory_lock);
+		dma_buf_put(priv->dmabuf);
+		return -EBUSY;
+	}
 	dma_resv_lock(priv->dmabuf->resv, NULL);
 	priv->revoked = !__vfio_pci_memory_enabled(vdev);
 	list_add_tail(&priv->dmabufs_elm, &vdev->dmabufs);
diff --git a/drivers/vfio/pci/vfio_pci_gmem.h b/drivers/vfio/pci/vfio_pci_gmem.h
new file mode 100644
index 000000000000..a8edd20357e7
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_gmem.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VFIO_PCI_GMEM_H
+#define VFIO_PCI_GMEM_H
+
+#include <linux/guest_memfd.h>
+
+struct iommufd_vdevice;
+struct vfio_pci_core_device;
+
+struct vfio_pci_gmem {
+	struct guest_memfd *gmem;
+	struct iommufd_vdevice *ivdev;
+};
+
+#endif /* VFIO_PCI_GMEM_H */
diff --git a/drivers/vfio/pci/vfio_pci_gmem_access.c b/drivers/vfio/pci/vfio_pci_gmem_access.c
new file mode 100644
index 000000000000..40219f05345b
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_gmem_access.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Shared/private access and guest revocation are controlled by guest_memfd. */
+#include <linux/guest_memfd.h>
+#include <linux/iommufd.h>
+#include <linux/vfio_pci_core.h>
+
+#include "vfio_pci_gmem.h"
+#include "vfio_pci_priv.h"
+
+/**
+ * vfio_pci_gmem_invalidate() - notify KVM of BAR mappings invalidate
+ * @vdev: VFIO PCI device whose BAR translations are being revoked
+ *
+ * Called by vfio_pci_zap_bars() after it removes host BAR mappings. Notify
+ * guest_memfd synchronously so KVM removes the corresponding shared guest
+ * mappings. This helper does not remove host mappings or change attributes.
+ * Skip notification if no provider is attached.
+ *
+ */
+void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_pci_gmem *ctx = vdev->gmem;
+
+	lockdep_assert_held_write(&vdev->memory_lock);
+	if (ctx)
+		ctx->gmem->invalidate(ctx->gmem);
+}
+
+/**
+ * vfio_pci_gmem_access_allowed() - check a host BAR access against its range
+ * @vdev: VFIO PCI device supplying the BAR
+ * @offset: byte offset in the VFIO region namespace
+ * @size: access length in bytes
+ *
+ * Consult completed guest_memfd attributes for the requested interval.
+ * Private mappings in another interval do not block this access. Try the
+ * inode lock instead of waiting in the reverse order from conversion.
+ *
+ * Return: true when the requested interval is accessible.
+ */
+bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
+		u64 offset, u64 size)
+{
+	struct vfio_pci_gmem *ctx = vdev->gmem;
+
+	lockdep_assert_held(&vdev->memory_lock);
+	if (!ctx)
+		return true;
+
+	/* Attachment publishes the context before resolving its vDEVICE. */
+	if (!ctx->ivdev)
+		return false;
+
+	return ctx->gmem->host_accessible(ctx->gmem,
+					  offset, size);
+}
+
+/**
+ * vfio_pci_gmem_io_access_allowed() - resolve a mapped BAR address
+ * @vdev: VFIO PCI device supplying the iomap
+ * @io: address used by ordinary VFIO read, write or ioeventfd
+ * @size: access width in bytes
+ *
+ * Standard BAR iomaps are cached in barmap. Resolve those to file offsets
+ * before applying range admission. Generic VFIO's remaining memory I/O uses
+ * a temporary ROM iomap, which cannot be bound to a device guest_memfd.
+ * Callers supply VFIO's own validated iomap pointers.
+ *
+ * Return: true when the I/O interval is accessible.
+ */
+bool vfio_pci_gmem_io_access_allowed(struct vfio_pci_core_device *vdev,
+		void __iomem *io, size_t size)
+{
+	unsigned long addr = (unsigned long)io;
+	int bar;
+
+	lockdep_assert_held(&vdev->memory_lock);
+	if (!vdev->gmem)
+		return vfio_pci_gmem_access_allowed(vdev, 0, size);
+
+	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
+		unsigned long base = (unsigned long)vdev->barmap[bar];
+		u64 offset;
+
+		if (!base || addr < base)
+			continue;
+
+		offset = addr - base;
+		if (offset >= pci_resource_len(vdev->pdev, bar))
+			continue;
+
+		if (size > pci_resource_len(vdev->pdev, bar) - offset)
+			return false;
+
+		return vfio_pci_gmem_access_allowed(vdev,
+				VFIO_PCI_INDEX_TO_OFFSET(bar) + offset, size);
+	}
+	/* The ROM has no private provider mappings, but lifecycle checks apply. */
+	return vfio_pci_gmem_access_allowed(vdev,
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX), size);
+}
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 7f14dd46de17..54c1b3d2f725 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -44,7 +44,9 @@ int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 {									\
 	if (test_mem) {							\
 		down_read(&vdev->memory_lock);				\
-		if (!__vfio_pci_memory_enabled(vdev)) {			\
+		if (!__vfio_pci_memory_enabled(vdev) ||			\
+		    !vfio_pci_gmem_io_access_allowed(vdev, io,		\
+						     sizeof(u##size))) {	\
 			up_read(&vdev->memory_lock);			\
 			return -EIO;					\
 		}							\
@@ -70,7 +72,9 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 {									\
 	if (test_mem) {							\
 		down_read(&vdev->memory_lock);				\
-		if (!__vfio_pci_memory_enabled(vdev)) {			\
+		if (!__vfio_pci_memory_enabled(vdev) ||			\
+		    !vfio_pci_gmem_io_access_allowed(vdev, io,		\
+						     sizeof(u##size))) {	\
 			up_read(&vdev->memory_lock);			\
 			return -EIO;					\
 		}							\
@@ -380,7 +384,10 @@ static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 	if (ioeventfd->test_mem) {
 		if (!down_read_trylock(&vdev->memory_lock))
 			return 1; /* Lock contended, use thread */
-		if (!__vfio_pci_memory_enabled(vdev)) {
+		if (!__vfio_pci_memory_enabled(vdev) ||
+		    !vfio_pci_gmem_access_allowed(vdev,
+				VFIO_PCI_INDEX_TO_OFFSET(ioeventfd->bar) +
+				ioeventfd->pos, ioeventfd->count)) {
 			up_read(&vdev->memory_lock);
 			return 0;
 		}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index dc15b462126e..9f8aa81eb1c9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -151,8 +151,30 @@ struct vfio_pci_core_device {
 	struct rw_semaphore	memory_lock;
 	atomic_t		mmap_count;
 	struct list_head	dmabufs;
+	/* Attached provider; publication/removal require memory_lock for write. */
+	struct vfio_pci_gmem *gmem;
 };
 
+#if IS_ENABLED(CONFIG_VFIO_PCI_GMEM)
+void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev);
+bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
+				u64 offset, u64 size);
+bool vfio_pci_gmem_io_access_allowed(struct vfio_pci_core_device *vdev,
+				   void __iomem *io, size_t size);
+#else
+static inline void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev) {}
+static inline bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
+					     u64 offset, u64 size)
+{
+	return true;
+}
+static inline bool vfio_pci_gmem_io_access_allowed(struct vfio_pci_core_device *vdev,
+						void __iomem *io, size_t size)
+{
+	return true;
+}
+#endif
+
 enum vfio_pci_io_width {
 	VFIO_PCI_IO_WIDTH_1 = 1,
 	VFIO_PCI_IO_WIDTH_2 = 2,
-- 
2.43.0

