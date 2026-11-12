Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469306;
	b=XE7CFi0/owy+ioT6LY63O0d5n3BwxCzmuItS9kJZBJCNa5cXmbvsB4opXAjvQnjb56FX
	 C55maIzBjV5Nd+sk8IOur4N2UFiP1tiuNtLLIygNymyWhqyC7zOxCr3BEdNKHmZiKOwdV
	 GoGWjRb1zuKu9U8Pf3zCMbRQKu9EvhwsXrDFZ1ecdnhdRXHH0Lb/7RvwLsuECVrUS2dbw
	 +kKYBijD5Dbl86tRth6WB9OmXw0mmrUPywUnaajwqB3k+wswJdODNXkohOD5RpB0BM9Bj
	 jnx114WrNFpFHF3CAnuLognBVD4uenzITBm6Vs4YUCjWZdq5LaI8D0j7ZUVxhM8o8XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=733XHS3lHTPFiN2IAEsYNhrbLpDn7MKjpwShXuMnNIo=;
	b=4La10C+szSdXS9aN++yVvluaYlinv2RSAyESOw0JsD/wXiTVVd9Jj7N82tEon51mRw7B
	 4vwYZEln7HPthaO9oKOc4R2DJgmw7x6e306UN+1H00fu/t1RuxRMfW9XffLwykiIiSxkP
	 JmGJZEkEAxAP0vdGimS3Eseot+ubeVxWCFNJhKdtHz0zbMW4q+dNuQJ7gDs0xr49AL+8X
	 PXDtLV2iGIbGe0oUvw+oNbIWImnVCpE9Wo11bgKxirdh+Cq4RZ+r2fwpgcpnSlvUjHx7v
	 WbeEccAxxcCVzQEC7pMy0liLGBq/j8Bi93xYri7FENDF8FF7Ps+9I3eyADVVgOLKWqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJi0v0P0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E6606A32E;
	Thu, 12 Nov 2026 07:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJi0v0P0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCC71F00A09;
	Thu, 12 Nov 2026 07:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469306;
	bh=733XHS3lHTPFiN2IAEsYNhrbLpDn7MKjpwShXuMnNIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJi0v0P0GiPABukg2kyxWrNpRtxeim6kA1KHcW/7a/2QXDc0wiYKe1UQ1a8bi+qtx
	 7GQJ1nHEkWYTw/PiJdyX5GtfODSKPrPepco76GU9dSdhNqc3pIPHNWjMmjefX9a+lx
	 gQYkv0UBCxtXKZMH43hzGg8Ic0Ty4sgzmesFB1YvjuDZ5Um92cFtkAGzBEXwoK2rQz
	 Sg0oiL+jF4sOAlkxa/uvdsrtPufDlgLNLa1KhVTdI+bsFH9ECLv21SssP4PJZ7kfs8
	 UFZCVfIEzQtQ6kBGWElAXvOp6w9XUpSjmGyeGO+afA42uHEOq7cLlhKH91eUMdcYEY
	 5jiJnlHnTR/Ig==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v5 03/16] KVM: guest_memfd: Let providers coordinate mapping changes
Date: Thu, 12 Nov 2026 13:11:07 +0530
Message-ID: <20261112074120.1570072-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add optional paired lock() and unlock() callbacks so providers can prevent
memory changes during guest invalidation and attribute conversion. Reject
providers that supply only one callback.

Take the provider lock with the inode invalidate lock held for write,
before guest invalidation. Release it after invalidation and any
successful attribute publication. Use the same locking for revocation
and final inode cleanup.

This lock is separate from the lock taken by get_pfn() for an individual
PFN. Existing providers can omit both callbacks.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  8 ++++++
 virt/kvm/guest_memfd.c      | 50 +++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 3d84fd0adec1..b63ca59773f9 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -36,6 +36,12 @@ struct guest_memfd_handle {
  * @attach: Attach to a resource file, perform filesystem-specific validation,
  *          and return an opaque provider context.
  * @release: Release provider context and unpin any resources.
+ * @lock: Optional provider lock for mapping and attribute changes. Called
+ *        with the inode invalidate lock held for write, before guest
+ *        invalidation starts.
+ * @unlock: Release the provider lock taken by lock(). Called after guest
+ *          invalidation ends and any successful attribute publication, with
+ *          the inode invalidate lock still held.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -66,6 +72,8 @@ struct guest_memfd_handle {
 struct guest_memfd_provider_operations {
 	void *(*attach)(struct inode *gmem_inode, struct file *resource_file);
 	void (*release)(void *provider);
+	void (*lock)(void *provider);
+	void (*unlock)(void *provider);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 026a7bd0fe76..5fda14a53488 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -96,6 +96,9 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (!ops || !ops->attach)
 		return false;
 
+	if (!!ops->lock != !!ops->unlock)
+		return false;
+
 	if (ops == &gmem_native_provider_ops)
 		return !kvm_gmem_is_pfn_mode(gi);
 
@@ -269,6 +272,42 @@ static void gmem_provider_put_pfn_range(struct gmem_inode *gi, pgoff_t index,
 		gi->provider_ops->put_pfn_range(gi->provider, index, nr_pages);
 }
 
+/**
+ * gmem_provider_lock_updates - Take the provider lock for memory updates
+ * @gi: guest_memfd inode containing the attached provider
+ *
+ * Prevent providers from moving or reassigning memory during guest
+ * invalidation, attribute conversion/publication, revocation, unbinding and
+ * final cleanup. Pair with gmem_provider_unlock_updates(). Providers
+ * requiring no additional locking may omit both lock() and unlock().
+ *
+ * This is separate from locking inside get_pfn(); it neither acquires a PFN
+ * reference nor pairs with gmem_unlock_handle().
+ *
+ * Caller holds the inode invalidate lock for write through
+ * gmem_provider_unlock_updates().
+ */
+static void gmem_provider_lock_updates(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->lock)
+		gi->provider_ops->lock(gi->provider);
+}
+
+/**
+ * gmem_provider_unlock_updates - Release the provider lock for memory updates
+ * @gi: guest_memfd inode passed to gmem_provider_lock_updates()
+ *
+ * Release the provider lock after guest invalidation and any attribute
+ * publication are complete. This does not unlock or put an individual PFN reference.
+ *
+ * Caller holds the inode invalidate lock for write.
+ */
+static void gmem_provider_unlock_updates(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->unlock)
+		gi->provider_ops->unlock(gi->provider);
+}
+
 static void gmem_provider_release(struct gmem_inode *gi)
 {
 	if (gi->provider_ops && gi->provider_ops->release)
@@ -506,6 +545,7 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 	pgoff_t max_pages = i_size_read(inode) >> PAGE_SHIFT;
+	struct gmem_inode *gi = GMEM_I(inode);
 	loff_t offset, len;
 	pgoff_t end;
 
@@ -526,6 +566,8 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
+	gmem_provider_lock_updates(gi);
+
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
@@ -543,6 +585,7 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	}
 
 	kvm_gmem_invalidate_end(inode, start, end);
+	gmem_provider_unlock_updates(gi);
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
@@ -1118,6 +1161,8 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	 * checks and can proceed to do guest-breaking changes.
 	 */
 
+	gmem_provider_lock_updates(gi);
+
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
@@ -1127,6 +1172,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
 
 	kvm_gmem_invalidate_end(inode, start, end);
+	gmem_provider_unlock_updates(gi);
 out:
 	filemap_invalidate_unlock(mapping);
 	return r;
@@ -1793,8 +1839,12 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi)) {
 		pgoff_t nr_pages = i_size_read(inode) >> PAGE_SHIFT;
 
+		filemap_invalidate_lock(inode->i_mapping);
+		gmem_provider_lock_updates(gi);
 		kvm_gmem_pfn_reclaim(gi, 0, nr_pages);
 		gmem_provider_put_pfn_range(gi, 0, nr_pages);
+		gmem_provider_unlock_updates(gi);
+		filemap_invalidate_unlock(inode->i_mapping);
 	}
 
 	gmem_provider_release(gi);
-- 
2.43.0

