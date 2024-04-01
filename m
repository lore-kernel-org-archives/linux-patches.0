Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95EBA3F;
	Mon,  1 Apr 2024 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990899; cv=none; b=XCz1vaEW8LzLC/PJ8vynbQn8V6atF1JxIXD67dEgv4MLL8i+RYXFOiSmD+N/nnmHENYUYC0TpOF1VYkucYBrCXkY4eW6zEcpqGLTMEB0Rm1dOZcgScmOkXE7c3dIQS5X/mAbb/oLXelNnSMF9onpQjZKmMhLmrYIFauXNhzlS2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990899; c=relaxed/simple;
	bh=dXVbM1sVoEPjH6IQlvWbhJihCX3yx/YruJdzkUoIdWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSdhs+RmraNaoKiu5E82+pG7ZF+58tvkn8Urx7H2RgOtMMDESovFt/QIRkE/HX+HOOQ9njbI5bBP1jtdE/UkNoIlFwaetFbC6KLETpEImVWFw3/HFwHVM2Oe9fus3RZ6Cno3afViwRa6asL0mfQdXahPJClhy29cSDhL595fqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzpSD6YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzpSD6YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7791BC433C7;
	Mon,  1 Apr 2024 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990898;
	bh=dXVbM1sVoEPjH6IQlvWbhJihCX3yx/YruJdzkUoIdWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzpSD6YYRD8ZUehmqNnFrB0ax4H/M8hKfU//AATijViUobcSLBIbl3nZHcjnypSpi
	 0Wlv5MOdYDgeJTn63sVpLABNYusQquzutLpUaDhoFqORggV0mTajlelco56mvHbRld
	 Egy2cEzAZGiYeAkTErIKIinz+rkNWcZ2udllOcwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/272] vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date: Mon,  1 Apr 2024 17:44:51 +0200
Message-ID: <20240401152533.798174239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 0886196ca8810c5b1f5097b71c4bc0df40b10208 ]

Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accounting, and as such it is controlled by the cgroup
mechanism.

The way to find the relevant allocations was for example to look at the
close_device function and trace back all the kfrees to their
allocations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20230108154427.32609-4-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: fe9a7082684e ("vfio/pci: Disable auto-enable of exclusive INTx IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/container.c           |  2 +-
 drivers/vfio/pci/vfio_pci_config.c |  6 +++---
 drivers/vfio/pci/vfio_pci_core.c   |  7 ++++---
 drivers/vfio/pci/vfio_pci_igd.c    |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c  | 10 ++++++----
 drivers/vfio/pci/vfio_pci_rdwr.c   |  2 +-
 drivers/vfio/virqfd.c              |  2 +-
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index d74164abbf401..ab9d8e3481f75 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -366,7 +366,7 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_container *container;
 
-	container = kzalloc(sizeof(*container), GFP_KERNEL);
+	container = kzalloc(sizeof(*container), GFP_KERNEL_ACCOUNT);
 	if (!container)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 4a350421c5f62..523e0144c86fa 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1244,7 +1244,7 @@ static int vfio_msi_cap_len(struct vfio_pci_core_device *vdev, u8 pos)
 	if (vdev->msi_perm)
 		return len;
 
-	vdev->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL);
+	vdev->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL_ACCOUNT);
 	if (!vdev->msi_perm)
 		return -ENOMEM;
 
@@ -1731,11 +1731,11 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 	 * no requirements on the length of a capability, so the gap between
 	 * capabilities needs byte granularity.
 	 */
-	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	map = kmalloc(pdev->cfg_size, GFP_KERNEL_ACCOUNT);
 	if (!map)
 		return -ENOMEM;
 
-	vconfig = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	vconfig = kmalloc(pdev->cfg_size, GFP_KERNEL_ACCOUNT);
 	if (!vconfig) {
 		kfree(map);
 		return -ENOMEM;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index e030c2120183e..f357fd157e1ed 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -141,7 +141,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 			 * of the exclusive page in case that hot-add
 			 * device's bar is assigned into it.
 			 */
-			dummy_res = kzalloc(sizeof(*dummy_res), GFP_KERNEL);
+			dummy_res =
+				kzalloc(sizeof(*dummy_res), GFP_KERNEL_ACCOUNT);
 			if (dummy_res == NULL)
 				goto no_mmap;
 
@@ -856,7 +857,7 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	region = krealloc(vdev->region,
 			  (vdev->num_regions + 1) * sizeof(*region),
-			  GFP_KERNEL);
+			  GFP_KERNEL_ACCOUNT);
 	if (!region)
 		return -ENOMEM;
 
@@ -1637,7 +1638,7 @@ static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
 
-	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
+	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
 	if (!mmap_vma)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 5e6ca59269548..dd70e2431bd74 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -180,7 +180,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 	if (!addr || !(~addr))
 		return -ENODEV;
 
-	opregionvbt = kzalloc(sizeof(*opregionvbt), GFP_KERNEL);
+	opregionvbt = kzalloc(sizeof(*opregionvbt), GFP_KERNEL_ACCOUNT);
 	if (!opregionvbt)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 40c3d7cf163f6..bffb0741518b9 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -177,7 +177,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
-	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
+	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL_ACCOUNT);
 	if (!vdev->ctx)
 		return -ENOMEM;
 
@@ -216,7 +216,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	vdev->ctx[0].name = kasprintf(GFP_KERNEL, "vfio-intx(%s)",
+	vdev->ctx[0].name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)",
 				      pci_name(pdev));
 	if (!vdev->ctx[0].name)
 		return -ENOMEM;
@@ -284,7 +284,8 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
+	vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx),
+			    GFP_KERNEL_ACCOUNT);
 	if (!vdev->ctx)
 		return -ENOMEM;
 
@@ -343,7 +344,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
-	vdev->ctx[vector].name = kasprintf(GFP_KERNEL, "vfio-msi%s[%d](%s)",
+	vdev->ctx[vector].name = kasprintf(GFP_KERNEL_ACCOUNT,
+					   "vfio-msi%s[%d](%s)",
 					   msix ? "x" : "", vector,
 					   pci_name(pdev));
 	if (!vdev->ctx[vector].name)
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e352a033b4aef..e27de61ac9fe7 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -470,7 +470,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		goto out_unlock;
 	}
 
-	ioeventfd = kzalloc(sizeof(*ioeventfd), GFP_KERNEL);
+	ioeventfd = kzalloc(sizeof(*ioeventfd), GFP_KERNEL_ACCOUNT);
 	if (!ioeventfd) {
 		ret = -ENOMEM;
 		goto out_unlock;
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 414e98d82b02e..a928c68df4763 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -115,7 +115,7 @@ int vfio_virqfd_enable(void *opaque,
 	int ret = 0;
 	__poll_t events;
 
-	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
+	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL_ACCOUNT);
 	if (!virqfd)
 		return -ENOMEM;
 
-- 
2.43.0



