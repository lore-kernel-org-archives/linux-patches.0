Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD4154C15;
	Tue, 27 May 2025 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365328; cv=none; b=fYkW6NYDYDqRSHRdGqTIxzUcyiwuz7H2WA5H8Ic/WGGTPc5NlwisXqrk/BfT8u6hDLXVJFkJkrk+LeIlCGcMiX65+Lrl/GRKvIFYgcSeopUILq4+dMzm4x+Oc7/WieZ0USo1XR0fm14McQXNyjGo/D3T3kmNKxo0fu9Uk6IJG+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365328; c=relaxed/simple;
	bh=A6ag0CbVb0lWQHN6X0l8JewoOy7UJOHtiY6lvyAlcow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cx0yNqd8aA+az1DDFTRZcaQs2tsNz45/De05ccYOtyXmdpcmyXQK4gPQS2FkB+27PIg/JyKuNdztUPIHFSA4Eu1oqezOivZGyBly2AC6FloR3Q6shRG5BuHxgO/bLaqTJJG3KmlZvtUSvXe171L6pK+CuKX3fxFk5sOyuSE4/Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+VvOEKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+VvOEKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B748EC4CEE9;
	Tue, 27 May 2025 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365328;
	bh=A6ag0CbVb0lWQHN6X0l8JewoOy7UJOHtiY6lvyAlcow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+VvOEKkgyxKOpSSzUZ6WMvDu8HOA2v9qWAKqY0KpfVYeyZYYk+mq6ydoU4yYlrAh
	 d+Vuu9PEp8vufOFgHQG0sFYQj5u8Z93qURWfz9ZEdJWz9+rDNZgIvrZ7p4dgq0MoVm
	 4omm38vXpkBDFrktZIkPik5rYaithmNgtRWDJFYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/626] genirq/msi: Store the IOMMU IOVA directly in msi_desc instead of iommu_cookie
Date: Tue, 27 May 2025 18:23:26 +0200
Message-ID: <20250527162457.749682268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 1f7df3a691740a7736bbc99dc4ed536120eb4746 ]

The IOMMU translation for MSI message addresses has been a 2-step process,
separated in time:

 1) iommu_dma_prepare_msi(): A cookie pointer containing the IOVA address
    is stored in the MSI descriptor when an MSI interrupt is allocated.

 2) iommu_dma_compose_msi_msg(): this cookie pointer is used to compute a
    translated message address.

This has an inherent lifetime problem for the pointer stored in the cookie
that must remain valid between the two steps. However, there is no locking
at the irq layer that helps protect the lifetime. Today, this works under
the assumption that the iommu domain is not changed while MSI interrupts
being programmed. This is true for normal DMA API users within the kernel,
as the iommu domain is attached before the driver is probed and cannot be
changed while a driver is attached.

Classic VFIO type1 also prevented changing the iommu domain while VFIO was
running as it does not support changing the "container" after starting up.

However, iommufd has improved this so that the iommu domain can be changed
during VFIO operation. This potentially allows userspace to directly race
VFIO_DEVICE_ATTACH_IOMMUFD_PT (which calls iommu_attach_group()) and
VFIO_DEVICE_SET_IRQS (which calls into iommu_dma_compose_msi_msg()).

This potentially causes both the cookie pointer and the unlocked call to
iommu_get_domain_for_dev() on the MSI translation path to become UAFs.

Fix the MSI cookie UAF by removing the cookie pointer. The translated IOVA
address is already known during iommu_dma_prepare_msi() and cannot change.
Thus, it can simply be stored as an integer in the MSI descriptor.

The other UAF related to iommu_get_domain_for_dev() will be addressed in
patch "iommu: Make iommu_dma_prepare_msi() into a generic operation" by
using the IOMMU group mutex.

Link: https://patch.msgid.link/r/a4f2cd76b9dc1833ee6c1cf325cba57def22231c.1740014950.git.nicolinc@nvidia.com
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 28 +++++++++++++---------------
 include/linux/msi.h       | 33 ++++++++++++---------------------
 2 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 2a9fa0c8cc00f..0f0caf59023c7 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1815,7 +1815,7 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 	static DEFINE_MUTEX(msi_prepare_lock); /* see below */
 
 	if (!domain || !domain->iova_cookie) {
-		desc->iommu_cookie = NULL;
+		msi_desc_set_iommu_msi_iova(desc, 0, 0);
 		return 0;
 	}
 
@@ -1827,11 +1827,12 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 	mutex_lock(&msi_prepare_lock);
 	msi_page = iommu_dma_get_msi_page(dev, msi_addr, domain);
 	mutex_unlock(&msi_prepare_lock);
-
-	msi_desc_set_iommu_cookie(desc, msi_page);
-
 	if (!msi_page)
 		return -ENOMEM;
+
+	msi_desc_set_iommu_msi_iova(
+		desc, msi_page->iova,
+		ilog2(cookie_msi_granule(domain->iova_cookie)));
 	return 0;
 }
 
@@ -1842,18 +1843,15 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
  */
 void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 {
-	struct device *dev = msi_desc_to_dev(desc);
-	const struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	const struct iommu_dma_msi_page *msi_page;
+#ifdef CONFIG_IRQ_MSI_IOMMU
+	if (desc->iommu_msi_shift) {
+		u64 msi_iova = desc->iommu_msi_iova << desc->iommu_msi_shift;
 
-	msi_page = msi_desc_get_iommu_cookie(desc);
-
-	if (!domain || !domain->iova_cookie || WARN_ON(!msi_page))
-		return;
-
-	msg->address_hi = upper_32_bits(msi_page->iova);
-	msg->address_lo &= cookie_msi_granule(domain->iova_cookie) - 1;
-	msg->address_lo += lower_32_bits(msi_page->iova);
+		msg->address_hi = upper_32_bits(msi_iova);
+		msg->address_lo = lower_32_bits(msi_iova) |
+				  (msg->address_lo & ((1 << desc->iommu_msi_shift) - 1));
+	}
+#endif
 }
 
 static int iommu_dma_init(void)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 59a421fc42bf0..63d0e51f7a801 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -165,6 +165,10 @@ struct msi_desc_data {
  * @dev:	Pointer to the device which uses this descriptor
  * @msg:	The last set MSI message cached for reuse
  * @affinity:	Optional pointer to a cpu affinity mask for this descriptor
+ * @iommu_msi_iova: Optional shifted IOVA from the IOMMU to override the msi_addr.
+ *                  Only used if iommu_msi_shift != 0
+ * @iommu_msi_shift: Indicates how many bits of the original address should be
+ *                   preserved when using iommu_msi_iova.
  * @sysfs_attr:	Pointer to sysfs device attribute
  *
  * @write_msi_msg:	Callback that may be called when the MSI message
@@ -183,7 +187,8 @@ struct msi_desc {
 	struct msi_msg			msg;
 	struct irq_affinity_desc	*affinity;
 #ifdef CONFIG_IRQ_MSI_IOMMU
-	const void			*iommu_cookie;
+	u64				iommu_msi_iova : 58;
+	u64				iommu_msi_shift : 6;
 #endif
 #ifdef CONFIG_SYSFS
 	struct device_attribute		*sysfs_attrs;
@@ -284,28 +289,14 @@ struct msi_desc *msi_next_desc(struct device *dev, unsigned int domid,
 
 #define msi_desc_to_dev(desc)		((desc)->dev)
 
-#ifdef CONFIG_IRQ_MSI_IOMMU
-static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
-{
-	return desc->iommu_cookie;
-}
-
-static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
-					     const void *iommu_cookie)
-{
-	desc->iommu_cookie = iommu_cookie;
-}
-#else
-static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
+static inline void msi_desc_set_iommu_msi_iova(struct msi_desc *desc, u64 msi_iova,
+					       unsigned int msi_shift)
 {
-	return NULL;
-}
-
-static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
-					     const void *iommu_cookie)
-{
-}
+#ifdef CONFIG_IRQ_MSI_IOMMU
+	desc->iommu_msi_iova = msi_iova >> msi_shift;
+	desc->iommu_msi_shift = msi_shift;
 #endif
+}
 
 int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
 			       struct msi_desc *init_desc);
-- 
2.39.5



