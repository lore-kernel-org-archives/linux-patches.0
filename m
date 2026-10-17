Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBE942E40D;
	Sat, 17 Oct 2026 07:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222417; cv=none; b=TWehWewOSzv+rUZWQO+SjBQaJJCiKfoUrdqiglntjxT5rNvODjqOwghDcppkjyoNOV/junJMuPc8Q9ROMHLoxa1SUXYseglGrw/thX8KcUPHm9DCBibciHhPxHN1/O2y7z62vNiLRwkIBKgBvjmtem2n4iVYh67wWLog5rN4IAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222417; c=relaxed/simple;
	bh=KUTgIMs0EEwAgS8sSDSykDVrFzMvKw7tSQmAMvc7RZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Fke8xvjJi8XD7JBF7HCi3COXL+AoHZIcWf4V+vHlAHxW8qnHwEK8Hv4SuQYJiO56wnBXc+DPMWwVmxPN7jGi/dnDXRdCwVMsocDWyPx2+OXgCYYMTJIsq+WSYoUdN08QViJAS6iORiqD1o+enP20q0OntW8C4veWxSqK8xwiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5vIm5n9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5vIm5n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974EF1F000C4;
	Sat, 17 Oct 2026 07:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222415;
	bh=+1dPmNhbO2S4deilduWA6kkvV36pP46GglzyasswYW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5vIm5n9de4+wXyHwnBZTpjTLi01PJWB1jAynPiQgsXre1SOSEVvnlUpofIPrgKdw
	 BZOaovySuowyd9lZXPjIk00u0IjU3jObJytyq2p4vd1XkpELLuev9BObiGheLxYk9C
	 Bk4eaFajyZM3tpkj0Rors/t7JfIWvXJLd6NL1aqiH2fHZZ1W9N2tN+JHOxFp3/8/we
	 LQtpUbh1DV6BfAFSYfmuWJzjsSF5ueUY5HIwB4CxHhpdx1IIb/BmglMPV+GYSmtZLs
	 nlMw3XlH9oBmv1+Xy72+zNFqNhnFx69CfsdAWAFLAlpvwqjeDiUxQqWQk2U7gQ7FBq
	 jtCVZ9Wv3TGXw==
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
Subject: [RFC PATCH v2 12/13] KVM: Invalidate guest_memfd mappings before removing memslot bindings
Date: Sat, 17 Oct 2026 13:01:48 +0530
Message-ID: <20261017073149.1303738-13-aneesh.kumar@kernel.org>
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

Unmap guest_memfd ranges before deleting the memslot. Remove private
device mappings before committing deletion, and invalidate remaining
mappings while holding the inode invalidate lock.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 70 ++++++++++++++++++++++++++++++++++++++++--
 virt/kvm/guest_memfd.h |  6 ++++
 virt/kvm/kvm_main.c    |  4 +++
 3 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6476b64c5928..05ab01925532 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1307,6 +1307,58 @@ static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
 	return ret;
 }
 
+/**
+ * kvm_gmem_prepare_memslot_delete() - remove guest_memfd mappings before deletion
+ * @slot: original guest_memfd memslot being removed
+ *
+ * The caller has replaced the active slot with an entry marked
+ * KVM_MEMSLOT_INVALID, preventing new guest faults from creating mappings.
+ * Remove private device mappings, then invalidate the remaining guest_memfd
+ * mappings, including shared mappings.
+ *
+ * Perform this cleanup while the guest_memfd binding still provides the
+ * file-offset-to-GPA translation needed to locate the guest mappings.
+ * The device provider remains attached until guest_memfd close.
+ *
+ * Caller holds slots_lock.
+ * Return: 0 on success or a negative error code.
+ */
+int kvm_gmem_prepare_memslot_delete(const struct kvm_memory_slot *slot)
+{
+	struct file *file = READ_ONCE(slot->gmem.file);
+	pgoff_t start = slot->gmem.pgoff;
+	pgoff_t end = start + slot->npages;
+	struct inode *inode;
+	int ret;
+
+	/* slots_lock keeps the bindings alive until file release can finish. */
+	file = get_file_active(&file);
+	if (!file) {
+		/* Let .release drain the bindings before deletion can discard them. */
+		if (READ_ONCE(slot->gmem.file))
+			return -EBUSY;
+		return 0;
+	}
+
+	inode = file_inode(file);
+	if (gmem_provider_has_pfns(GMEM_I(inode))) {
+		ret = kvm_gmem_device_convert(inode, start, slot->npages, NULL, NULL);
+		if (ret)
+			goto out;
+	}
+
+	filemap_invalidate_lock(inode->i_mapping);
+	__kvm_gmem_invalidate_start(file->private_data, start, end,
+				    kvm_gmem_get_all_gfns_filter(inode));
+	__kvm_gmem_invalidate_end(file->private_data, start, end);
+	filemap_invalidate_unlock(inode->i_mapping);
+	ret = 0;
+out:
+	fput(file);
+	return ret;
+}
+
+
 int kvm_gmem_device_map(struct kvm *kvm, u64 gpa, u64 size, u64 pa, u64 vdev_id)
 {
 	struct guest_memfd_device_request req = { gpa, pa, vdev_id };
@@ -1608,11 +1660,19 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
-static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem_file *f)
+static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct file *file)
 {
+	struct gmem_file *f = file->private_data;
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
 
+	/*
+	 * Unmap this slot's guest mappings before removing it from f->bindings.
+	 * The invalidation helper walks f->bindings to find the slots to unmap.
+	 */
+	__kvm_gmem_invalidate_start(f, start, end,
+				    kvm_gmem_get_all_gfns_filter(file_inode(file)));
+	__kvm_gmem_invalidate_end(f, start, end);
 	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
@@ -1644,12 +1704,16 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * until the caller drops slots_lock.
 	 */
 	if (!file) {
-		__kvm_gmem_unbind(slot, slot->gmem.file->private_data);
+		struct file *closing_file = slot->gmem.file;
+
+		filemap_invalidate_lock(closing_file->f_mapping);
+		__kvm_gmem_unbind(slot, closing_file);
+		filemap_invalidate_unlock(closing_file->f_mapping);
 		return;
 	}
 
 	filemap_invalidate_lock(file->f_mapping);
-	__kvm_gmem_unbind(slot, file->private_data);
+	__kvm_gmem_unbind(slot, file);
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
diff --git a/virt/kvm/guest_memfd.h b/virt/kvm/guest_memfd.h
index 0f9c6f840838..6fad6adfdadc 100644
--- a/virt/kvm/guest_memfd.h
+++ b/virt/kvm/guest_memfd.h
@@ -11,6 +11,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, uoff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
+int kvm_gmem_prepare_memslot_delete(const struct kvm_memory_slot *slot);
 #else
 static inline int kvm_gmem_init(struct module *module)
 {
@@ -29,6 +30,11 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 }
+
+static inline int kvm_gmem_prepare_memslot_delete(const struct kvm_memory_slot *slot)
+{
+	return 0;
+}
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #endif /* __KVM_GUEST_MEMFD_H__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f3f46a8563b3..58da57b8a268 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1696,6 +1696,10 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
+	if (!r && change == KVM_MR_DELETE) {
+		if (old->flags & KVM_MEM_GUEST_MEMFD)
+			r = kvm_gmem_prepare_memslot_delete(old);
+	}
 
 	/* Free the bitmap on failure if it was allocated above. */
 	if (r && new && new->dirty_bitmap && (!old || !old->dirty_bitmap))
-- 
2.43.0

