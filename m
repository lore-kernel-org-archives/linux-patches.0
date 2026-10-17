Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7FF414DDB;
	Sat, 17 Oct 2026 07:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222339; cv=none; b=kldIK9O5/gL4gxk6u6uK5DRL1OKWpVfKRADljo9NdbJqWaSWLGi7bOl2nonHB+ScpyvrbqWLgZDHrTRq00mREpqvX6LAlCM4BNTmQpK7qLt0fBco4H5SY1eULXKLCu4sy1gvLuDEmiA2rhLXeKCEVWJTv1z9fRi+hmfx78RDrwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222339; c=relaxed/simple;
	bh=ktycfPfPvXu4zeGR3LiArn/cqtC3ogZUQtFpvicJbu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp0lFiDpAxqe092SixaB4lWzbIJ7quyGBSfCBg1/yHwJdHdMyT31OEiB+BnmYr0uIexy+DHYor1VO7tuAkNz3008uletSHxtexpbyr2yvCQNty2inwANq8Ai7vSQWNWPeozi5Gok2sIoyITqqfZ8NnGGQg2JiKuEUnkHvMcv9ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m30FL41V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m30FL41V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB931F000C6;
	Sat, 17 Oct 2026 07:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222337;
	bh=Sbdn5hUiIa2uQGdhpugbFc05xRlWJGBAvAUVhdCtQ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m30FL41VPfvhzLkY/rjHelsyfcmV4ln9EINFIxw/+Dv1ckWXboYSF/tSKyeTQNSsX
	 UY7m7ywcrP3mo/QS0p7iMf7t16fA6ZsQyilneQs71PnnZPM4VshkRCfWot940rSlCw
	 4fXye3bn8Fzrp1I9fTDV4wtIov5SqOppmD81/iXdBrAAMLSMEKug+i+XP7iGVylhLu
	 VSDURrr0mNv0X+X/nrIYsraDzBE0GsPGg6wMZ6maHCgPQNdnJhhBjRZ2LqT0zONRwy
	 xX6pDtUF/PFOPSmrtfXVfvs0trj/V+pqQFmorc8Yt0sEhexfCz4u/H4UZZVU2m36q2
	 78rfpDcom0xMA==
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
Subject: [RFC PATCH v2 02/13] KVM: guest_memfd: Support private/shared conversion of device memory
Date: Sat, 17 Oct 2026 13:01:38 +0530
Message-ID: <20261017073149.1303738-3-aneesh.kumar@kernel.org>
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

Allow architectures to convert device-backed guest_memfd ranges to
private memory. Coordinate conversion with the device provider and
update guest_memfd attributes only after the architecture operation
succeeds.

Hold the inode invalidate lock across conversion and the attribute
update. Provider callbacks allow a device conversion lock to cover the
same operation, with the inode lock acquired first. This prevents faults
and competing device operations from observing an incomplete conversion.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  12 +++
 include/linux/kvm_host.h    |   5 +
 virt/kvm/guest_memfd.c      | 201 +++++++++++++++++++++++++++++++++++-
 3 files changed, 213 insertions(+), 5 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 1bc9a23afa4e..7ae8df07a26e 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -9,6 +9,12 @@ struct folio;
 struct mempolicy;
 struct kvm;
 
+struct guest_memfd_device_request {
+	u64 gpa;
+	u64 pa;
+	u64 vdev_id;
+};
+
 /* Binding data stays valid only while the provider is active. */
 struct guest_memfd_device_binding {
 	/* Architecture-specific mapping owner, e.g. an RMM vDEVICE handle. */
@@ -33,6 +39,8 @@ struct guest_memfd {
  * @invalidate_folio: Notify the folio provider before releasing a folio.
  * @bind: Validate a PFN interval and return its protected mapping owner.
  * @get_pfn: Resolve a shared resource offset without taking a folio reference.
+ * @prepare_conversion: Prepare protected PFN conversion; NULL request shares.
+ * @finish_conversion: Finish conversion after attribute publication.
  *
  * Provider operations supply exactly one of alloc_folio() and get_pfn().
  * PFN providers start shared and require the bind and conversion callbacks
@@ -47,6 +55,10 @@ struct guest_memfd_provider_operations {
 	int (*bind)(void *provider, u64 offset, u64 size,
 		struct guest_memfd_device_binding *binding);
 	int (*get_pfn)(void *provider, u64 offset, unsigned long *pfn);
+	int (*prepare_conversion)(void *provider,
+		const struct guest_memfd_device_request *req);
+	void (*finish_conversion)(void *provider,
+		const struct guest_memfd_device_request *req);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2aa728de75e8..1602f0a711d6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2614,6 +2614,11 @@ bool kvm_gmem_range_has_attributes(struct kvm_memory_slot *slot, gfn_t start,
 bool kvm_arch_gmem_device_supported(struct kvm *kvm);
 void kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
 		const struct guest_memfd_device_binding *binding);
+int kvm_arch_gmem_device_map(struct kvm *kvm,
+		const struct kvm_memory_slot *slot,
+		u64 gpa, u64 size, u64 pa);
+int kvm_arch_gmem_device_unmap(struct kvm *kvm, u64 gpa, u64 size);
+int kvm_gmem_device_map(struct kvm *kvm, u64 gpa, u64 size, u64 pa, u64 vdev_id);
 int kvm_gmem_set_attributes(struct kvm_memory_slot *slot, gfn_t start,
 			    gfn_t end, u64 attributes);
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9a8b66bd623a..b2782e64e9c8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -40,6 +40,13 @@ struct gmem_inode {
 	struct list_head gmem_file_list;
 
 	struct guest_memfd device;
+	/*
+	 * Whether the completed attribute tree contains any private device range.
+	 * Updated under the inode invalidate and provider conversion locks;
+	 * provider readers use READ_ONCE() without taking the inode lock.
+	 * This avoids reversing the inode -> vDEVICE MMIO lock order.
+	 */
+	bool device_has_private;
 	void *provider;
 	const struct guest_memfd_provider_operations *provider_ops;
 
@@ -330,6 +337,10 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
+static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
+		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
+		const struct kvm_memory_slot *slot);
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
@@ -752,8 +763,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	struct ma_state mas;
 	int r = 0;
 
-	if (gmem_provider_has_pfns(gi))
-		return -EOPNOTSUPP;
+	if (gmem_provider_has_pfns(gi)) {
+		*err_index = start;
+		if (to_private)
+			return -EPERM;
+		return kvm_gmem_device_convert(inode, start, nr_pages, NULL, NULL);
+	}
 
 	mt = &gi->attributes;
 
@@ -1039,6 +1054,179 @@ void __weak kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
 {
 }
 
+int __weak kvm_arch_gmem_device_map(struct kvm *kvm,
+		const struct kvm_memory_slot *slot,
+		u64 gpa, u64 size, u64 pa)
+{
+	return -EOPNOTSUPP;
+}
+
+int __weak kvm_arch_gmem_device_unmap(struct kvm *kvm, u64 gpa, u64 size)
+{
+	return -EOPNOTSUPP;
+}
+
+static void kvm_gmem_device_update_private(struct gmem_inode *gi)
+{
+	MA_STATE(mas, &gi->attributes, 0, 0);
+	void *entry;
+	bool private = false;
+
+	mas_for_each(&mas, entry, ULONG_MAX) {
+		if (kvm_gmem_get_attributes(&gi->vfs_inode, entry) &
+		    KVM_MEMORY_ATTRIBUTE_PRIVATE) {
+			private = true;
+			break;
+		}
+	}
+	WRITE_ONCE(gi->device_has_private, private);
+}
+
+/* The protected request and its slot identify exactly one private range. */
+static int kvm_gmem_device_make_private(struct inode *inode,
+		const struct kvm_memory_slot *slot,
+		const struct guest_memfd_device_request *req,
+		pgoff_t nr_pages)
+{
+	return kvm_arch_gmem_device_map(GMEM_I(inode)->device.kvm, slot,
+					req->gpa, (u64)nr_pages << PAGE_SHIFT,
+					req->pa);
+}
+
+/* The inode lock protects both attributes and the offset-to-GPA bindings. */
+static int kvm_gmem_device_make_shared(struct inode *inode,
+	       pgoff_t start, pgoff_t end)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	struct gmem_file *f;
+	void *entry;
+
+	MA_STATE(mas, &gi->attributes, start, start);
+
+	mas_for_each(&mas, entry, end - 1) {
+		pgoff_t first = max(start, mas.index);
+		pgoff_t last = min(end, mas.last + 1);
+
+		if (!(kvm_gmem_get_attributes(inode, entry) &
+		      KVM_MEMORY_ATTRIBUTE_PRIVATE))
+			continue;
+
+		while (first < last) {
+			struct kvm_memory_slot *slot = NULL;
+			pgoff_t high;
+			u64 gpa;
+			int ret;
+
+			kvm_gmem_for_each_file(f, inode) {
+				slot = xa_load(&f->bindings, first);
+				if (slot)
+					break;
+			}
+			if (!slot)
+				return -EINVAL;
+
+			high = min(last, slot->gmem.pgoff + slot->npages);
+			gpa = (slot->base_gfn + first - slot->gmem.pgoff) << PAGE_SHIFT;
+			ret = kvm_arch_gmem_device_unmap(gi->device.kvm, gpa,
+						      (high - first) << PAGE_SHIFT);
+			if (ret)
+				return ret;
+
+			first = high;
+		}
+	}
+	return 0;
+}
+
+static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
+		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
+		const struct kvm_memory_slot *slot)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	u64 attrs = req ? KVM_MEMORY_ATTRIBUTE_PRIVATE : 0;
+	bool prepared = false;
+	int ret;
+
+	MA_STATE(mas, &gi->attributes, start, start + nr_pages - 1);
+
+	filemap_invalidate_lock(inode->i_mapping);
+	if (__kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (req && !__kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	ret = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
+	if (ret)
+		goto out;
+
+	kvm_gmem_invalidate_start(inode, start, start + nr_pages, KVM_FILTER_SHARED);
+	if (req && READ_ONCE(gi->device.kvm->vm_dead))
+		ret = -EIO;
+	else
+		ret = gi->provider_ops->prepare_conversion(gi->provider, req);
+	if (!ret) {
+		prepared = true;
+		if (req)
+			ret = kvm_gmem_device_make_private(inode, slot, req, nr_pages);
+		else
+			ret = kvm_gmem_device_make_shared(inode, start, start + nr_pages);
+	}
+	if (!ret) {
+		mas_store_prealloc(&mas, xa_mk_value(attrs));
+		kvm_gmem_device_update_private(gi);
+	} else {
+		mas_destroy(&mas);
+	}
+
+	kvm_gmem_invalidate_end(inode, start, start + nr_pages);
+	if (prepared)
+		gi->provider_ops->finish_conversion(gi->provider, req);
+out:
+	filemap_invalidate_unlock(inode->i_mapping);
+	return ret;
+}
+
+int kvm_gmem_device_map(struct kvm *kvm, u64 gpa, u64 size, u64 pa, u64 vdev_id)
+{
+	struct guest_memfd_device_request req = { gpa, pa, vdev_id };
+	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	struct file *file;
+	int ret;
+
+	if (!size)
+		return -EINVAL;
+
+	if (!PAGE_ALIGNED(gpa | size | pa))
+		return -EINVAL;
+
+	/* Caller holds SRCU across the pending architecture request. */
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot || (slot->flags & KVM_MEMSLOT_INVALID))
+		return -EINVAL;
+
+	if (!(slot->flags & KVM_MEMSLOT_GMEM_DEVICE))
+		return -EINVAL;
+
+	if ((size >> PAGE_SHIFT) > slot->npages - (gfn - slot->base_gfn))
+		return -EINVAL;
+
+	file = kvm_gmem_get_file(slot);
+	if (!file)
+		return -ENOENT;
+	ret = kvm_gmem_device_convert(file_inode(file),
+				      kvm_gmem_get_index(slot, gfn),
+				      size >> PAGE_SHIFT, &req, slot);
+	fput(file);
+	return ret;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_device_map);
+
 static int kvm_gmem_validate_provider(struct kvm *kvm,
 		struct gmem_inode *gi,
 		const struct guest_memfd_provider_operations *ops)
@@ -1054,13 +1242,15 @@ static int kvm_gmem_validate_provider(struct kvm *kvm,
 	/* Folio providers use the core's binding and conversion paths. */
 	if (!ops->get_pfn) {
 		/* PFN-specific callbacks are invalid for folio providers. */
-		if (ops->bind)
+		if (ops->bind || ops->prepare_conversion ||
+		    ops->finish_conversion)
 			return -EOPNOTSUPP;
 		return 0;
 	}
 
-	/* PFN providers must support binding. */
-	if (!ops->bind)
+	/* PFN providers must support binding and conversion. */
+	if (!ops->bind || !ops->prepare_conversion ||
+	    !ops->finish_conversion)
 		return -EOPNOTSUPP;
 
 	/* PFN providers do not manage folios. */
@@ -1552,6 +1742,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->flags = 0;
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
+	gi->device_has_private = false;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
-- 
2.43.0

