Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4914142E40A;
	Sat, 17 Oct 2026 07:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222409; cv=none; b=DIX69AA8pEGWJqd+yk0KWrHRWg/cb20K2+NCxOO8Hto+WQRpTDlhqus7nUhrxXchs1wbBNIMZeSlsCODa0y/X4cVLDFy67woCmvu0aunBhgpQ909SMukho8uwmQWwyw2wn08ir6t2S0nMcfjeJICDtejDZKOHdk+m3vmwJrUrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222409; c=relaxed/simple;
	bh=PIPO4kAl88S3cdyxQuxXFTXHjnjfjED1NyVAzZtWD+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9Uuhr/MnmSbk3CVyFaTBpfN2LYmJLPtnoeVOHqf4FDSYDzPwZwxa4Tgoh5LgofW/jPmtQKGPLpGRENWXOX615/fMRxWXt3L+9FYE+775J9WlyJ/kDzO8jEXV7cq2z2oSxbyvW8MRQcWS2Zg8C8zb/XOGsPgodbrVKgachhY7cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNucZWTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNucZWTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810BB1F000C5;
	Sat, 17 Oct 2026 07:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222407;
	bh=0GhJJYXOiqXJaNEQPlF7eWXFhQyKn4WEuYINTbISF1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNucZWTJkna3d2lb7aaumU1hougoL+gLkkPLBtQEpRlYLoTV3vI7HQW8FxqSD7F60
	 2olVrbduK2lN8kpuLBxdeNHcko2L9I352KgvzDhFxIh1YJX+1dbY8Mn4HBv2Nw8dk3
	 rLBW5PpA79zW4l0fUGjf1GVPb2HmboCrIxlUnT1s9oplWeL/OOkMrv3KFx7Gn59KOR
	 37pqzYrYQ2CFJbbiuOAkkoFzqVbJ464R4W3NpH6q85lXG/SANU0T6iXAaQ+FZnnoNL
	 jboN0pp5gjxF8UJkGEZiScpk0nY8lnXuHzGrgb10cqB5fmTDZdQnQvcAzq64JPzia0
	 7uV9qamAKJl6g==
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
Subject: [RFC PATCH v2 11/13] KVM: guest_memfd: Remove device mappings on final close
Date: Sat, 17 Oct 2026 13:01:47 +0530
Message-ID: <20261017073149.1303738-12-aneesh.kumar@kernel.org>
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

On final guest_memfd close, detach the device provider before removing
private device mappings. Keep memslot bindings available so cleanup can
resolve device ranges to guest addresses.

Hold the inode invalidate lock across detach and conversion cleanup, and
clear the core file pointer before releasing the file-owned VM reference.
Require PFN providers to supply detach() and reject it for folio providers.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst |  3 ++-
 virt/kvm/guest_memfd.c         | 27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0bc38d53a1b3..ca81e2762656 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6537,7 +6537,8 @@ For a VFIO PCI device resource, creation fails with EBUSY if any VFIO BAR
 VMA or dma-buf export exists. This includes unfaulted mappings and mappings
 inherited by another process. Userspace must remove all such mappings before
 creating the device guest_memfd. While the provider is attached, mmap() on
-any VFIO fd for that device fails with EBUSY.
+any VFIO fd for that device fails with EBUSY. Closing the guest_memfd releases
+the provider once its last reference is dropped and cleanup completes.
 
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d2b1e2e9dfee..6476b64c5928 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -340,6 +340,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
 		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
 		const struct kvm_memory_slot *slot);
+static void kvm_gmem_device_close(struct inode *inode);
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
@@ -462,6 +463,9 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	filemap_invalidate_lock(inode->i_mapping);
 
+	if (gmem_provider_has_pfns(GMEM_I(inode)))
+		kvm_gmem_device_close(inode);
+
 	xa_for_each(&f->bindings, index, slot)
 		WRITE_ONCE(slot->gmem.file, NULL);
 
@@ -1339,6 +1343,23 @@ int kvm_gmem_device_map(struct kvm *kvm, u64 gpa, u64 size, u64 pa, u64 vdev_id)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_device_map);
 
+static void kvm_gmem_device_close(struct inode *inode)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	int ret;
+
+	gi->provider_ops->detach(gi->provider);
+	ret = gi->provider_ops->prepare_conversion(gi->provider, NULL);
+	if (!ret) {
+		ret = kvm_gmem_device_make_shared(inode, 0,
+						  i_size_read(inode) >> PAGE_SHIFT);
+		if (!ret)
+			WRITE_ONCE(gi->device_has_private, false);
+		gi->provider_ops->finish_conversion(gi->provider, NULL);
+	}
+	WRITE_ONCE(gi->device.gmem_file, NULL);
+}
+
 static int kvm_gmem_validate_provider(struct kvm *kvm,
 		struct gmem_inode *gi,
 		const struct guest_memfd_provider_operations *ops)
@@ -1355,14 +1376,14 @@ static int kvm_gmem_validate_provider(struct kvm *kvm,
 	if (!ops->get_pfn) {
 		/* PFN-specific callbacks are invalid for folio providers. */
 		if (ops->bind || ops->prepare_conversion ||
-		    ops->finish_conversion)
+		    ops->finish_conversion || ops->detach)
 			return -EOPNOTSUPP;
 		return 0;
 	}
 
-	/* PFN providers must support binding and conversion. */
+	/* PFN providers must support binding, conversion and detachment. */
 	if (!ops->bind || !ops->prepare_conversion ||
-	    !ops->finish_conversion)
+	    !ops->finish_conversion || !ops->detach)
 		return -EOPNOTSUPP;
 
 	/* PFN providers do not manage folios. */
-- 
2.43.0

