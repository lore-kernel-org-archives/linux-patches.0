Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2790242DFE6;
	Sat, 17 Oct 2026 07:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222363; cv=none; b=G6WWijwPmJ5KZwMbqYCIqiqjQHcq2Cx3SdT4Cw/DY94Dx5GMQ0MEqa9jW5X1NEpM/h3MEjS9DOZ40yH4m7YPCaytEZRPjUq6IHHgqtQJXjQMiwr8UPfc82TTm9emKhIhup+hHsFi6ZtiSn03vU7sCGwP1lzgkqMiA3i8WFysOK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222363; c=relaxed/simple;
	bh=DHbgnnBF8Chn7ND95xcMfI+fgwD0hcosjMZu9s1L2Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWr+ksFfT+75QVHggF3svUht3K7gkeVLOlsuST3kmIwJ/M8r9iAyEdos81U/6svleIqtuGGnT/03wawCNRePeeSeOmDHSfaI1/YqkxjpvXU47yv4K/0mAaRYRi/iDu/X1mh3sgxcf7K2pwwHofRHpahzmMNd3FrELVJ4I68goN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LdP/d8pj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdP/d8pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5812E1F000C5;
	Sat, 17 Oct 2026 07:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222361;
	bh=5SRO9rR/pY5NU2Xjv8KPBYCPdeYN2G2tXDUKxxKH3qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdP/d8pjDGv9EI3q+AOONfRRIzVneQTHgH+8436jyhcBVOp57mkOz+mwRs2P4w98r
	 psI1mjIxhxj32t0i6vIrd1pBZBlhXSB8X3oeri7labU7MWe1Yj7qE8dBRS7ylMX6or
	 m8VX48hKx3wwTNq6SusHK+lisKCEe3joVfMB7Y8i/OmGLEpDgzUoxWK5veB+85V8av
	 1SVw5efspkncAFba94r1eSW0RBpISIg1SKH1gvy16wikcaWbgDP2feXzE9yl+gO1mS
	 DFCwz1qJGyQxychZnZqzVYuHh/maNVA8cKo/l8hi59zBdTyrLZWS0rO60rvGKKhs6X
	 VPmjkHUtEeiEQ==
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
Subject: [RFC PATCH v2 05/13] vfio/pci: Track userspace BAR mappings
Date: Sat, 17 Oct 2026 13:01:41 +0530
Message-ID: <20261017073149.1303738-6-aneesh.kumar@kernel.org>
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

Track userspace mappings of PCI BARs so a later patch can reject
guest_memfd attachment while such mappings exist.

Count the initial mmap explicitly because vm_ops->open() is not called
for it. Use the VMA open and close callbacks to track duplication and
unmapping, keeping the count nonzero until the last mapping is unmapped.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++++++++++++++
 include/linux/vfio_pci_core.h    |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6757054e9d87..795b4ab1174e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1806,7 +1806,23 @@ static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
 	return vfio_pci_mmap_huge_fault(vmf, 0);
 }
 
+static void vfio_pci_mmap_open(struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+
+	atomic_inc(&vdev->mmap_count);
+}
+
+static void vfio_pci_mmap_close(struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+
+	atomic_dec(&vdev->mmap_count);
+}
+
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
+	.open = vfio_pci_mmap_open,
+	.close = vfio_pci_mmap_close,
 	.fault = vfio_pci_mmap_page_fault,
 #ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
 	.huge_fault = vfio_pci_mmap_huge_fault,
@@ -1888,6 +1904,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
 			VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
+	/* Initial mmap does not invoke vm_ops->open(). */
+	vfio_pci_mmap_open(vma);
 
 	return 0;
 }
@@ -2197,6 +2215,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 		return ret;
 	INIT_LIST_HEAD(&vdev->dmabufs);
 	init_rwsem(&vdev->memory_lock);
+	atomic_set(&vdev->mmap_count, 0);
 	xa_init(&vdev->ctx);
 
 	return 0;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 9a1674c152aa..dc15b462126e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -8,6 +8,7 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/vfio.h>
@@ -148,6 +149,7 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+	atomic_t		mmap_count;
 	struct list_head	dmabufs;
 };
 
-- 
2.43.0

