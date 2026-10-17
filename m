Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60E2DEA8F;
	Sat, 17 Oct 2026 07:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222370; cv=none; b=tDR+kJSzqhQwLpCRvqgT8dXT1Fg8WaEcexaqANNOxPA1CF+3HWDO0zbM87AoX65rpWeALdKhzeZlNEVjQNYD8/QO3uQb9MHyah7GCV6hk9oDtMHVZ7nNYcEZp3MayI5zn0pcdOvhSZCA+/S7CWR1eHG7W4dqBIP2K+GKSQpkAqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222370; c=relaxed/simple;
	bh=ZnPTkICYmpdttPFhS0VW+/V23rOUITYYR5TreTCtOc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLf0bisIF6bRaXPnwF5cQmr5rvrl+Hix4HoXaeDcsVUbbSGI3tksdh0Z7ejK7GVB/nceWfXutR064uNrYi1o/SoTwErvLk37b4iejGRQEBwT6o1xik3NtVnaHAF8l2voTjdE/7sRdksnpmbE2zq/dMQAUpfsuXEjFniiir66j5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUnZwsZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUnZwsZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6975B1F000C4;
	Sat, 17 Oct 2026 07:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222369;
	bh=BbJlHltSHQHhGJbK9eSE80Dc2l9NQKj+oxVuhsDZGss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUnZwsZnKnSvOKVNJWCoik6ZjajEJK80JUQS7CyJy2DFsaeUJWT8y/tIt6t0d2kSt
	 pU5PFRDsQ1bt8vA1ly56nUZECdwzrYoVHg2XfRnfU1FUDeWgu6TEsqJygUqS/nhS2N
	 ywa3acm748Xvc2ZbxBu09BH13BHvwzOERLoSnujHwHfwL/fh9XSdk4wPKnk9375huY
	 Z4D/wHDsArXr7A2CldCZFetf0JuIfBUAV1qqmhv0wxR6reNFlqSlgHkJlJk+oAjMvf
	 XjuBVm76eIQA433/3Q5E1XhjojQFSeR1Gyd2Kahq68HM9Gte/0TD+SgBS8SG9bkQjS
	 CgFg0T1hgaZ8Q==
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
Subject: [RFC PATCH v2 06/13] vfio: Dispatch guest_memfd provider operations through the filesystem
Date: Sat, 17 Oct 2026 13:01:42 +0530
Message-ID: <20261017073149.1303738-7-aneesh.kumar@kernel.org>
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

Expose guest_memfd provider operations through the VFIO mapping
superblock and forward them to the device driver. Validate the driver
callbacks before attachment and keep the source file pinned through
provider release.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/vfio_main.c | 115 ++++++++++++++++++++++++++++++++++++++-
 include/linux/vfio.h     |   4 ++
 2 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ed96acfa8635..2051e14ac616 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -14,8 +14,10 @@
 #include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/fs.h>
+#include <linux/guest_memfd.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
+#include <linux/kvm.h>
 #if IS_ENABLED(CONFIG_KVM)
 #include <linux/kvm_host.h>
 #endif
@@ -248,9 +250,120 @@ struct vfio_device *_vfio_alloc_device(size_t size, struct device *dev,
 }
 EXPORT_SYMBOL_GPL(_vfio_alloc_device);
 
+struct vfio_gmem_provider {
+	const struct guest_memfd_provider_operations *ops;
+	void *data;
+	struct file *file;
+};
+
+static void *vfio_gmem_provider_attach(struct file *file,
+		struct guest_memfd *gmem)
+{
+	const struct guest_memfd_provider_operations *ops;
+	struct vfio_gmem_provider *provider;
+	struct vfio_device_file *df;
+	void *data;
+
+	/* Reject other file types before interpreting their private_data. */
+	if (file->f_op != &vfio_device_fops)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	df = file->private_data;
+	ops = df->device->ops->gmem_provider_ops;
+	/* Every provider must support attachment and release. */
+	if (!ops || !ops->attach || !ops->release)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* VFIO requires PFN lookup, binding and conversion. */
+	if (!ops->get_pfn || !ops->bind || !ops->prepare_conversion ||
+	    !ops->finish_conversion)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* VFIO provides PFNs, not folios. */
+	if (ops->alloc_folio || ops->invalidate_folio)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	provider = kzalloc_obj(*provider);
+	if (!provider)
+		return ERR_PTR(-ENOMEM);
+
+	data = ops->attach(file, gmem);
+	if (IS_ERR(data)) {
+		kfree(provider);
+		return data;
+	}
+
+	provider->ops = ops;
+	provider->data = data;
+	/* Pin the driver operations through release(), including its return. */
+	provider->file = get_file(file);
+	return provider;
+}
+
+static void vfio_gmem_provider_release(void *data)
+{
+	struct vfio_gmem_provider *provider = data;
+
+	provider->ops->release(provider->data);
+	fput(provider->file);
+	kfree(provider);
+}
+
+static int vfio_gmem_provider_bind(void *data, u64 offset, u64 size,
+				   struct guest_memfd_device_binding *binding)
+{
+	struct vfio_gmem_provider *provider = data;
+
+	return provider->ops->bind(provider->data, offset, size, binding);
+}
+
+static int vfio_gmem_provider_get_pfn(void *data, u64 offset, unsigned long *pfn)
+{
+	struct vfio_gmem_provider *provider = data;
+
+	return provider->ops->get_pfn(provider->data, offset, pfn);
+}
+
+static int vfio_gmem_provider_prepare_conversion(
+		void *context, const struct guest_memfd_device_request *req)
+{
+	struct vfio_gmem_provider *provider = context;
+
+	return provider->ops->prepare_conversion(provider->data, req);
+}
+
+static void vfio_gmem_provider_finish_conversion(
+		void *context, const struct guest_memfd_device_request *req)
+{
+	struct vfio_gmem_provider *provider = context;
+
+	provider->ops->finish_conversion(provider->data, req);
+}
+
+
+
+static const struct guest_memfd_provider_operations vfio_gmem_provider_ops = {
+	.attach = vfio_gmem_provider_attach,
+	.release = vfio_gmem_provider_release,
+	.bind = vfio_gmem_provider_bind,
+	.get_pfn = vfio_gmem_provider_get_pfn,
+	.prepare_conversion = vfio_gmem_provider_prepare_conversion,
+	.finish_conversion = vfio_gmem_provider_finish_conversion,
+};
+
+static const struct super_operations vfio_fs_super_ops = {
+	.statfs = simple_statfs,
+	.gmem_provider_ops = &vfio_gmem_provider_ops,
+};
+
 static int vfio_fs_init_fs_context(struct fs_context *fc)
 {
-	return init_pseudo(fc, VFIO_MAGIC) ? 0 : -ENOMEM;
+	struct pseudo_fs_context *ctx = init_pseudo(fc, VFIO_MAGIC);
+
+	if (!ctx)
+		return -ENOMEM;
+	ctx->ops = &vfio_fs_super_ops;
+	return 0;
 }
 
 static struct file_system_type vfio_fs_type = {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 0cc91c6f96d2..f33573f99048 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -81,6 +81,8 @@ struct vfio_device {
 	struct dentry *debug_root;
 };
 
+struct guest_memfd_provider_operations;
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -111,9 +113,11 @@ struct vfio_device {
  *         if none was provided.
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
+ * @gmem_provider_ops: Optional driver guest_memfd resource operations
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
  */
 struct vfio_device_ops {
+	const struct guest_memfd_provider_operations *gmem_provider_ops;
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);
-- 
2.43.0

