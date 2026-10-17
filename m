Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1050737A82E;
	Sat, 17 Oct 2026 07:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222401; cv=none; b=HaoFdW1eiH45saK9jyfetjw821gQNFMNcviXdzg3vmLUYazEf0NVW+hMvZWHdctTkz9rJuuS6xiRzqVUGE0p83IVRcan2rp0xYcPNDtasiOUkAov7fPtXiUbI/TVAKJKgdLjBA4YwwzfRUAVbaNbePC8AQlCktjJAkAopD4ZO9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222401; c=relaxed/simple;
	bh=nGeIZM2M9MS084MhDfiiP7jzU2o1u7ZBx6iTtKMAbJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYEz29ZszLgr6hhtZt6QmwzSqyr3p3rS7ED6f1adwQ0gFsZhAzORQ1oBqDDRxkSw5vy2Ne2HroGwuZlGSbZEj/ccyr63oH9xQtXRXwHCprIBTjHGWU9q2kQGiwvJJUKc8JUTZkYUL7UvYlZYDY7ydLytWgN5i4v3PDCpTn31b0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RC1dyxQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RC1dyxQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4241F000C4;
	Sat, 17 Oct 2026 07:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222399;
	bh=PgD0/8EUvEge+1DO9vHoe/yxjfpVUi6jTZWSVlZodZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RC1dyxQtqzL7np4oczMyTssV0TfLlOht/EkKEyJtVvczL4/3vPX0T9GihORYUX6Lz
	 VFfvIl9EtSHT3XglExM7ZbFgGn++tr+AdKEhZLzrsODPdLJsP5KEl75D6Z3cyR3adv
	 Hyry5Md0z2YZfpA05BB8tc6fbQq9eD1RWYp2Y9zZwkVY7L+2PkA+TvM/4RkorsbBW3
	 3Yfw08cr57sIYdQ1GERtb0Im4LTLOc61VkAbUQPldJ6qQlkp0sstTqHngvE/e4nsqj
	 ofcJLe2wDR/UPYiLny57HvkWUnU0DdIZD6mORcCghWEC4LxkJxJcXPnk7mY4PuzsTu
	 Z8whRD3EiwqGw==
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
Subject: [RFC PATCH v2 10/13] vfio/pci: Detach guest_memfd access before teardown
Date: Sat, 17 Oct 2026 13:01:46 +0530
Message-ID: <20261017073149.1303738-11-aneesh.kumar@kernel.org>
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

Implement the guest_memfd detach callback and forward it through the VFIO
filesystem provider. Require the backing driver to supply the callback.

Mark the provider detached under the vDEVICE MMIO mutex and VFIO memory
lock, draining in-flight access and invalidation callbacks. Reject further
host accesses, PFN lookups, bindings and private conversions while allowing
shared cleanup.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_gmem.c        | 25 +++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_gmem.h        |  6 ++++++
 drivers/vfio/pci/vfio_pci_gmem_access.c |  7 +++++--
 drivers/vfio/vfio_main.c                | 10 ++++++++--
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_gmem.c b/drivers/vfio/pci/vfio_pci_gmem.c
index 8cb5f0cb3bb8..1ab65e43eb1d 100644
--- a/drivers/vfio/pci/vfio_pci_gmem.c
+++ b/drivers/vfio/pci/vfio_pci_gmem.c
@@ -176,6 +176,8 @@ static int vfio_gmem_bind(void *data, u64 offset, u64 size,
 	int ret;
 
 	guard(iommufd_vdevice_mmio)(ctx->ivdev);
+	if (ctx->callbacks_detached)
+		return -ENODEV;
 	ret = vfio_gmem_resolve_bar_range(ctx, offset, size, &bar, &off, &pa);
 	if (ret)
 		return ret;
@@ -219,6 +221,8 @@ static int vfio_gmem_get_pfn(void *data, u64 offset, unsigned long *pfn)
 	int ret;
 
 	guard(rwsem_read)(&vdev->memory_lock);
+	if (ctx->callbacks_detached)
+		return -ENODEV;
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return -EAGAIN;
 
@@ -248,6 +252,10 @@ static int vfio_gmem_prepare_conversion(void *context,
 	struct vfio_pci_gmem *ctx = context;
 
 	iommufd_vdevice_mmio_lock(ctx->ivdev);
+	if (req && ctx->callbacks_detached) {
+		iommufd_vdevice_mmio_unlock(ctx->ivdev);
+		return -ENODEV;
+	}
 	if (req && req->vdev_id != ctx->ivdev->virt_id) {
 		iommufd_vdevice_mmio_unlock(ctx->ivdev);
 		return -EPERM;
@@ -287,6 +295,22 @@ static void vfio_gmem_finish_conversion(void *context,
 	iommufd_vdevice_mmio_unlock(ctx->ivdev);
 }
 
+/**
+ * vfio_gmem_detach() - stop invalidation callbacks before core teardown
+ * @data: attached provider context
+ *
+ * Mark the provider detached under the VFIO memory lock. VFIO userspace
+ * mappings remain excluded until release clears the provider association.
+ */
+static void vfio_gmem_detach(void *data)
+{
+	struct vfio_pci_gmem *ctx = data;
+
+	guard(iommufd_vdevice_mmio)(ctx->ivdev);
+	scoped_guard(rwsem_write, &ctx->vdev->memory_lock)
+		ctx->callbacks_detached = true;
+}
+
 /**
  * vfio_gmem_release() - release a provider after successful core cleanup
  * @data: provider context to release
@@ -318,6 +342,7 @@ const struct guest_memfd_provider_operations vfio_pci_gmem_provider_ops = {
 	.get_pfn = vfio_gmem_get_pfn,
 	.prepare_conversion = vfio_gmem_prepare_conversion,
 	.finish_conversion = vfio_gmem_finish_conversion,
+	.detach = vfio_gmem_detach,
 	.release = vfio_gmem_release,
 };
 EXPORT_SYMBOL_GPL(vfio_pci_gmem_provider_ops);
diff --git a/drivers/vfio/pci/vfio_pci_gmem.h b/drivers/vfio/pci/vfio_pci_gmem.h
index b4ca831196fd..76a2fbe1472a 100644
--- a/drivers/vfio/pci/vfio_pci_gmem.h
+++ b/drivers/vfio/pci/vfio_pci_gmem.h
@@ -13,6 +13,12 @@ struct vfio_pci_gmem {
 	struct iommufd_vdevice *ivdev;
 	struct file *resource;
 	unsigned long owner;
+	/*
+	 * Disables callbacks and new bind/private requests. Set once with
+	 * both the vDEVICE MMIO and VFIO memory locks held; readers hold
+	 * either lock. Shared cleanup remains allowed after detachment.
+	 */
+	bool callbacks_detached;
 };
 
 #endif /* VFIO_PCI_GMEM_H */
diff --git a/drivers/vfio/pci/vfio_pci_gmem_access.c b/drivers/vfio/pci/vfio_pci_gmem_access.c
index 40219f05345b..b723a0877ff3 100644
--- a/drivers/vfio/pci/vfio_pci_gmem_access.c
+++ b/drivers/vfio/pci/vfio_pci_gmem_access.c
@@ -14,7 +14,7 @@
  * Called by vfio_pci_zap_bars() after it removes host BAR mappings. Notify
  * guest_memfd synchronously so KVM removes the corresponding shared guest
  * mappings. This helper does not remove host mappings or change attributes.
- * Skip notification if no provider is attached.
+ * Skip notification if no provider is attached or its callbacks are detached.
  *
  */
 void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev)
@@ -22,7 +22,7 @@ void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev)
 	struct vfio_pci_gmem *ctx = vdev->gmem;
 
 	lockdep_assert_held_write(&vdev->memory_lock);
-	if (ctx)
+	if (ctx && !ctx->callbacks_detached)
 		ctx->gmem->invalidate(ctx->gmem);
 }
 
@@ -35,6 +35,7 @@ void vfio_pci_gmem_invalidate(struct vfio_pci_core_device *vdev)
  * Consult completed guest_memfd attributes for the requested interval.
  * Private mappings in another interval do not block this access. Try the
  * inode lock instead of waiting in the reverse order from conversion.
+ * Detachment excludes access during teardown.
  *
  * Return: true when the requested interval is accessible.
  */
@@ -51,6 +52,8 @@ bool vfio_pci_gmem_access_allowed(struct vfio_pci_core_device *vdev,
 	if (!ctx->ivdev)
 		return false;
 
+	if (ctx->callbacks_detached)
+		return false;
 	return ctx->gmem->host_accessible(ctx->gmem,
 					  offset, size);
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2051e14ac616..d6ea08c08e03 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -274,9 +274,9 @@ static void *vfio_gmem_provider_attach(struct file *file,
 	if (!ops || !ops->attach || !ops->release)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/* VFIO requires PFN lookup, binding and conversion. */
+	/* VFIO requires PFN lookup, binding, conversion and detachment. */
 	if (!ops->get_pfn || !ops->bind || !ops->prepare_conversion ||
-	    !ops->finish_conversion)
+	    !ops->finish_conversion || !ops->detach)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	/* VFIO provides PFNs, not folios. */
@@ -340,7 +340,12 @@ static void vfio_gmem_provider_finish_conversion(
 	provider->ops->finish_conversion(provider->data, req);
 }
 
+static void vfio_gmem_provider_detach(void *data)
+{
+	struct vfio_gmem_provider *provider = data;
 
+	provider->ops->detach(provider->data);
+}
 
 static const struct guest_memfd_provider_operations vfio_gmem_provider_ops = {
 	.attach = vfio_gmem_provider_attach,
@@ -349,6 +354,7 @@ static const struct guest_memfd_provider_operations vfio_gmem_provider_ops = {
 	.get_pfn = vfio_gmem_provider_get_pfn,
 	.prepare_conversion = vfio_gmem_provider_prepare_conversion,
 	.finish_conversion = vfio_gmem_provider_finish_conversion,
+	.detach = vfio_gmem_provider_detach,
 };
 
 static const struct super_operations vfio_fs_super_ops = {
-- 
2.43.0

