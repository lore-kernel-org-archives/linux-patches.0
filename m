Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0A37A82E;
	Sat, 17 Oct 2026 07:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222331; cv=none; b=Vpse0P8uARcG08bz4vtoATCAaSGEtXG4en+6UJlv+7l8M5QUvIIICB8umKKfIzdkb01ryqIAx0ZFfXw2j/fBCJF6TACViRdVOabs3tbVdudgptcwZvfcKwXG99vnWyoIp7j7AsCD4am6dglA/YcSDsv7uUB3qx1Mv6J7O6ChO+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222331; c=relaxed/simple;
	bh=gHKRvT8dWzdkS9mWimiyCe8kWr0eMrsTEqqsjs2N3Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpaO8PZI+cC9Ift07xkqEpw/IcagQlekzZykOw/wlCv5EBAxkuucQmHmX0dcqpb57/ccYed4CsMZqmxD+iQYSCk0kjGzik0KcybC0tBfVY62xsv9oswuJz2qDl0VAtLJxWvNL3bpA2c5qc/WvU75y4yr1FNOWE4Tj+Deqrfna+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAhTB+JD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAhTB+JD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159F91F000C5;
	Sat, 17 Oct 2026 07:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222329;
	bh=WMizhnGNYEc3tWuikJAQCuks2B2cqaDXxVi0L5I39Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAhTB+JDFwCdxaf7nJGUvOf5V6/9UJIvB96yCCT0jedRvclKEHih9SZG0XytVEQjh
	 QVwoImtbwPW573PfW/L1RVZNxr54de3W8qibarLT3A8k6k9++YiwvAkuXfS77sLrYy
	 R7SRKyuEWrMd9yol8K3HkyNAtWdCep4KWGb/yvMcTOC1yclPZ1+QUD9iVQxTRjVYb2
	 jU6BnB+y8y84zxcml6FzFo1b7QM6dZ3ac24L7Kyxw/h7ZoqwbhSPaxb/3u3yIThOfX
	 b8fHjJiw7a+YMtaywDeH9xKdGL/FPAS1oEHIdDcHUG7Z4pymo6zZjM5U0QMbsg3gvL
	 m3r7C+Ot7nQYQ==
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
Subject: [RFC PATCH v2 01/13] KVM: guest_memfd: Support PFN-backed resource providers
Date: Sat, 17 Oct 2026 13:01:37 +0530
Message-ID: <20261017073149.1303738-2-aneesh.kumar@kernel.org>
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

Device resources such as PCI BARs supply PFNs directly and cannot use
the folio allocation path. Extend guest_memfd provider operations with
bind() and get_pfn() callbacks and identify the backing type from the
callbacks supplied by the provider.

Require providers to supply either folio allocation or PFN lookup,
along with the callbacks appropriate to that backing type. PFN providers
require INIT_SHARED and architecture support for protected device
mappings.

Pass creation flags to providers so they can control mappings through
the resource fd. Keep mmap on PFN-backed guest_memfd files disabled.

Resolve shared faults through get_pfn() without taking folio references.
Reject dirty logging and read-only device memslots.

Provider release may run after file release and must not access the VM.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst |   4 +
 include/linux/guest_memfd.h    |  39 ++++++--
 include/linux/kvm_host.h       |   6 ++
 mm/shmem.c                     |   3 +-
 virt/kvm/guest_memfd.c         | 165 +++++++++++++++++++++++++++------
 5 files changed, 180 insertions(+), 37 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5ece28765d2c..078f672a115b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6529,6 +6529,10 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
                                 require noswap and huge=never mount options.
   ============================= ================================================
 
+With USE_RESOURCE, the resource mapping superblock supplies provider
+operations. Callbacks identify folio or PFN backing. PFN providers require
+INIT_SHARED and a VM supporting protected resource mappings; mmap is disabled.
+
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
 private fault (unless in-place conversion is disabled and the backing
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 60eb4f008c24..1bc9a23afa4e 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -7,23 +7,46 @@
 struct file;
 struct folio;
 struct mempolicy;
+struct kvm;
+
+/* Binding data stays valid only while the provider is active. */
+struct guest_memfd_device_binding {
+	/* Architecture-specific mapping owner, e.g. an RMM vDEVICE handle. */
+	unsigned long owner;
+	u64 vdev_id;
+};
+
+struct guest_memfd {
+	struct kvm *kvm;
+	u64 size;
+	u64 flags;
+};
 
 /**
- * struct guest_memfd_provider_operations - Operations for external memory providers
- * @attach: Attach to a resource file, perform filesystem-specific validation,
- *          and return an opaque provider context.
- * @release: Release provider context and unpin any resources.
- * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
- * @invalidate_folio: Notify provider that a folio has been invalidated.
+ * struct guest_memfd_provider_operations - External memory provider operations
+ * @attach: Validate the resource and attach it to the core context. Return
+ *          an opaque provider or ERR_PTR(). Success pins backing resources
+ *          and these operations until release().
+ * @release: Release the provider context and backing references. Must not
+ *           access the VM or invoke callbacks that do; the file may be gone.
+ * @alloc_folio: Allocate an uninserted folio for an index and NUMA policy.
+ * @invalidate_folio: Notify the folio provider before releasing a folio.
+ * @bind: Validate a PFN interval and return its protected mapping owner.
+ * @get_pfn: Resolve a shared resource offset without taking a folio reference.
  *
- * Used by filesystems and device drivers that provide memory for guest_memfd.
+ * Provider operations supply exactly one of alloc_folio() and get_pfn().
+ * PFN providers start shared and require the bind and conversion callbacks
+ * supported by the core. Folio providers use core allocation and conversion.
  */
 struct guest_memfd_provider_operations {
-	void *(*attach)(struct file *resource_file);
+	void *(*attach)(struct file *resource, struct guest_memfd *gmem);
 	void (*release)(void *provider);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
+	int (*bind)(void *provider, u64 offset, u64 size,
+		struct guest_memfd_device_binding *binding);
+	int (*get_pfn)(void *provider, u64 offset, unsigned long *pfn);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1dda54e8dee8..2aa728de75e8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -56,6 +56,7 @@
  */
 #define KVM_MEMSLOT_INVALID			(1UL << 16)
 #define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
+#define KVM_MEMSLOT_GMEM_DEVICE			(1UL << 18)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2605,9 +2606,14 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+struct guest_memfd_device_binding;
+
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_gmem_range_has_attributes(struct kvm_memory_slot *slot, gfn_t start,
 				   gfn_t end, u64 attributes);
+bool kvm_arch_gmem_device_supported(struct kvm *kvm);
+void kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
+		const struct guest_memfd_device_binding *binding);
 int kvm_gmem_set_attributes(struct kvm_memory_slot *slot, gfn_t start,
 			    gfn_t end, u64 attributes);
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
diff --git a/mm/shmem.c b/mm/shmem.c
index 493b72af52aa..d8f8a3b1fe59 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5239,7 +5239,8 @@ static const struct inode_operations shmem_special_inode_operations = {
 };
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-static void *shmem_gmem_attach(struct file *resource_file)
+static void *shmem_gmem_attach(struct file *resource_file,
+		struct guest_memfd *gmem)
 {
 	struct inode *inode = file_inode(resource_file);
 	struct shmem_sb_info *sbinfo;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a65a1eda8b90..9a8b66bd623a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -2,6 +2,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/guest_memfd.h>
 #include <linux/kvm_host.h>
@@ -38,6 +39,7 @@ struct gmem_inode {
 	struct inode vfs_inode;
 	struct list_head gmem_file_list;
 
+	struct guest_memfd device;
 	void *provider;
 	const struct guest_memfd_provider_operations *provider_ops;
 
@@ -56,6 +58,11 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
+static bool gmem_provider_has_pfns(struct gmem_inode *gi)
+{
+	return gi->provider_ops && gi->provider_ops->get_pfn;
+}
+
 static inline struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
 						      pgoff_t index,
 						      struct mempolicy *mpol)
@@ -75,7 +82,7 @@ static inline void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 
 static inline void gmem_provider_release(struct gmem_inode *gi)
 {
-	if (gi->provider_ops && gi->provider_ops->release)
+	if (gi->provider_ops)
 		gi->provider_ops->release(gi->provider);
 }
 
@@ -189,6 +196,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	struct mempolicy *policy;
 	struct folio *folio;
 
+	if (gmem_provider_has_pfns(gi))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/*
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
@@ -237,6 +247,8 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
 {
+	if (gmem_provider_has_pfns(GMEM_I(inode)))
+		return KVM_FILTER_SHARED;
 	if (gmem_in_place_conversion)
 		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
 
@@ -393,6 +405,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 {
 	int ret;
 
+	if (gmem_provider_has_pfns(GMEM_I(file_inode(file))))
+		return -EOPNOTSUPP;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
@@ -477,7 +492,11 @@ DEFINE_CLASS(gmem_get_file, struct file *, if (_T) fput(_T),
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
-	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	/* PFN providers may allow resource fd mmap, but not guest_memfd mmap. */
+	return !gmem_provider_has_pfns(gi) &&
+		(gi->flags & GUEST_MEMFD_FLAG_MMAP);
 }
 
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
@@ -733,6 +752,9 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	struct ma_state mas;
 	int r = 0;
 
+	if (gmem_provider_has_pfns(gi))
+		return -EOPNOTSUPP;
+
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
@@ -1007,34 +1029,90 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
 	return r;
 }
 
-static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
+bool __weak kvm_arch_gmem_device_supported(struct kvm *kvm)
+{
+	return false;
+}
+
+void __weak kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
+		const struct guest_memfd_device_binding *binding)
+{
+}
+
+static int kvm_gmem_validate_provider(struct kvm *kvm,
+		struct gmem_inode *gi,
+		const struct guest_memfd_provider_operations *ops)
+{
+	/* Every provider must support attachment and release. */
+	if (!ops || !ops->attach || !ops->release)
+		return -EOPNOTSUPP;
+
+	/* Providers must supply exactly one backing mechanism. */
+	if (!!ops->alloc_folio == !!ops->get_pfn)
+		return -EOPNOTSUPP;
+
+	/* Folio providers use the core's binding and conversion paths. */
+	if (!ops->get_pfn) {
+		/* PFN-specific callbacks are invalid for folio providers. */
+		if (ops->bind)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+
+	/* PFN providers must support binding. */
+	if (!ops->bind)
+		return -EOPNOTSUPP;
+
+	/* PFN providers do not manage folios. */
+	if (ops->invalidate_folio)
+		return -EOPNOTSUPP;
+
+	/* The VM must support protected resource mappings. */
+	if (!kvm_arch_gmem_device_supported(kvm))
+		return -EOPNOTSUPP;
+
+	/* PFN-backed memory must start shared. */
+	if (!(gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int kvm_gmem_attach_resource(struct kvm *kvm,
+		struct inode *inode, int resource_fd)
 {
+	const struct guest_memfd_provider_operations *ops;
+	struct gmem_inode *gi = GMEM_I(inode);
 	struct file *resource_file;
-	struct inode *res_inode;
-	const struct guest_memfd_provider_operations *ops = NULL;
 	void *provider;
+	int ret;
 
 	resource_file = fget_raw(resource_fd);
 	if (!resource_file)
 		return -EBADF;
 
-	res_inode = file_inode(resource_file);
-	ops = res_inode->i_sb->s_op->gmem_provider_ops;
+	ops = resource_file->f_mapping->host->i_sb->s_op->gmem_provider_ops;
 
-	if (!ops || !ops->attach || !ops->alloc_folio) {
-		fput(resource_file);
-		return -EOPNOTSUPP;
+	ret = kvm_gmem_validate_provider(kvm, gi, ops);
+	if (ret)
+		goto out_put;
+
+	gi->device.kvm = kvm;
+	gi->device.size = i_size_read(inode);
+	/* The provider needs creation flags before attachment is published. */
+	gi->device.flags = gi->flags;
+	provider = ops->attach(resource_file, &gi->device);
+	if (IS_ERR(provider)) {
+		ret = PTR_ERR(provider);
+		goto out_put;
 	}
 
-	provider = ops->attach(resource_file);
+	gi->provider = provider;
+	gi->provider_ops = ops;
+	ret = 0;
+out_put:
 	fput(resource_file);
-	if (IS_ERR(provider))
-		return PTR_ERR(provider);
-
-	GMEM_I(inode)->provider = provider;
-	GMEM_I(inode)->provider_ops = ops;
-
-	return 0;
+	return ret;
 }
 
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
@@ -1072,7 +1150,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 		goto err_inode;
 
 	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE) {
-		err = kvm_gmem_attach_resource(inode, resource_fd);
+		err = kvm_gmem_attach_resource(kvm, inode, resource_fd);
 		if (err)
 			goto err_inode;
 	}
@@ -1125,6 +1203,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, uoff_t offset)
 {
+	struct guest_memfd_device_binding binding = {};
 	uoff_t size = slot->npages << PAGE_SHIFT;
 	unsigned long start, end;
 	struct gmem_file *f;
@@ -1140,16 +1219,16 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return -EBADF;
 
 	if (file->f_op != &kvm_gmem_fops)
-		goto err;
+		goto out_put;
 
 	f = file->private_data;
 	if (f->kvm != kvm)
-		goto err;
+		goto out_put;
 
 	inode = file_inode(file);
 
 	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
-		goto err;
+		goto out_put;
 
 	filemap_invalidate_lock(inode->i_mapping);
 
@@ -1159,9 +1238,23 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!xa_empty(&f->bindings) &&
 	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
 		r = -EEXIST;
-		filemap_invalidate_unlock(inode->i_mapping);
-		goto err;
+		goto out_unlock;
+	}
+
+	if (gmem_provider_has_pfns(GMEM_I(inode))) {
+		if (slot->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+			r = -EINVAL;
+			goto out_unlock;
+		}
+		r = GMEM_I(inode)->provider_ops->bind(GMEM_I(inode)->provider, offset,
+						      size, &binding);
+		if (r)
+			goto out_unlock;
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY | KVM_MEMSLOT_GMEM_DEVICE;
 	}
+	r = xa_err(xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL));
+	if (r)
+		goto out_unlock;
 
 	/*
 	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
@@ -1170,19 +1263,20 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (slot->flags & KVM_MEMSLOT_GMEM_DEVICE)
+		kvm_arch_gmem_device_bind(slot, &binding);
 	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
-	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
+	r = 0;
+out_unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
-
+out_put:
 	/*
 	 * Drop the reference to the file, even on success.  The file pins KVM,
 	 * not the other way 'round.  Active bindings are invalidated if the
 	 * file is closed before memslots are destroyed.
 	 */
-	r = 0;
-err:
 	fput(file);
 	return r;
 }
@@ -1289,6 +1383,21 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
 
+	if (gmem_provider_has_pfns(GMEM_I(file_inode(file)))) {
+		struct gmem_inode *gi = GMEM_I(file_inode(file));
+		unsigned long device_pfn;
+
+		*max_order = 0;
+		if (kvm_gmem_is_private_mem(file_inode(file), index))
+			r = -EAGAIN;
+		else
+			r = gi->provider_ops->get_pfn(gi->provider,
+						(u64)index << PAGE_SHIFT, &device_pfn);
+		if (!r)
+			*pfn = device_pfn;
+		goto out;
+	}
+
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
-- 
2.43.0

