Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CE44499AC;
	Thu, 30 Jul 2026 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425058; cv=none; b=hMsdeWM9Oo17WtvNcGLRmprjTquAvIie74TaUZs8EbfIShxfqQ/FGBR0jNaHSLp3hvwVCED7QT99zpBatV2bGMGz7f4xoWU3drZo70B3zPZ2FoiBBt9f3DNJWoUZVJnAAhxpuwFeWcb3RjS5mAsH2QE9CkssyBPWt1rhiUtMS/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425058; c=relaxed/simple;
	bh=YsUhEt1HzQ6F6VNn2YD97/KwuegpFhFMlHkYE0TlB6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZjswoLpmXCyylklyZHJ8ethw2eHcDVLRI6NXObVZ/BnU5R+iRCksdGa4/J8jYTMF+ExewoaQ6PY0GXnp5bzvc91hfApwUmUEGDE/5g+Ejo3i3kWFnpzNZt0Y18Wu6C41fyq9vCzNK4YbGeAF+sVCzbmz0LJ7NJxghTkkHthLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5NymcaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5NymcaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0481F000E9;
	Thu, 30 Jul 2026 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425057;
	bh=jF+J8LWUGXAvCKe1Ty10IO/5kIp30z4tmpaLXDxdEc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5NymcaOT+QSy4ye4LIDgftGMcJOUT5ZfCT7uo7mvZoj6bmdu6D2be1YBthoxWdoV
	 KtzJn3241dQ9ZFpOtmA4y+2qOSN03gODxYVEV7qaQ1KYg6o3B7BHbG473fYWu8BF05
	 lO8R2UQEGL3KgvOvYLMQNr1gaB+VnT8MHXPA/7OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 612/675] vduse: return internal vq group struct as map token
Date: Thu, 30 Jul 2026 16:15:42 +0200
Message-ID: <20260730141458.125018203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit 02e3f7ffe2906033da73b7c7ea8180b131d0cdbc ]

Return the internal struct that represents the vq group as virtqueue map
token, instead of the device.  This allows the map functions to access
the information per group.

At this moment all the virtqueues share the same vq group, that only
can point to ASID 0.  This change prepares the infrastructure for actual
per-group address space handling

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-5-eperezma@redhat.com>
Stable-dep-of: 9c1523803445 ("VDUSE: avoid leaking information to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |   21 ++----
 drivers/vdpa/vdpa_user/iova_domain.h |    5 -
 drivers/vdpa/vdpa_user/vduse_dev.c   |  109 ++++++++++++++++++++++++++++++-----
 include/linux/virtio.h               |    6 -
 4 files changed, 108 insertions(+), 33 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -493,17 +493,15 @@ void vduse_domain_unmap_page(struct vdus
 	vduse_domain_free_iova(iovad, dma_addr, size);
 }
 
-void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
-				  size_t size, dma_addr_t *dma_addr,
-				  gfp_t flag)
+dma_addr_t vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
+				       size_t size, void *orig)
 {
 	struct iova_domain *iovad = &domain->consistent_iovad;
 	unsigned long limit = domain->iova_limit;
 	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
-	void *orig = alloc_pages_exact(size, flag);
 
-	if (!iova || !orig)
-		goto err;
+	if (!iova)
+		return DMA_MAPPING_ERROR;
 
 	spin_lock(&domain->iotlb_lock);
 	if (vduse_iotlb_add_range(domain, (u64)iova, (u64)iova + size - 1,
@@ -514,17 +512,12 @@ void *vduse_domain_alloc_coherent(struct
 	}
 	spin_unlock(&domain->iotlb_lock);
 
-	*dma_addr = iova;
+	return iova;
 
-	return orig;
 err:
-	*dma_addr = DMA_MAPPING_ERROR;
-	if (orig)
-		free_pages_exact(orig, size);
-	if (iova)
-		vduse_domain_free_iova(iovad, iova, size);
+	vduse_domain_free_iova(iovad, iova, size);
 
-	return NULL;
+	return DMA_MAPPING_ERROR;
 }
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
--- a/drivers/vdpa/vdpa_user/iova_domain.h
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -67,9 +67,8 @@ void vduse_domain_unmap_page(struct vdus
 			     dma_addr_t dma_addr, size_t size,
 			     enum dma_data_direction dir, unsigned long attrs);
 
-void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
-				  size_t size, dma_addr_t *dma_addr,
-				  gfp_t flag);
+dma_addr_t vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
+				       size_t size, void *orig);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
 				void *vaddr, dma_addr_t dma_addr,
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -22,6 +22,7 @@
 #include <linux/uio.h>
 #include <linux/vdpa.h>
 #include <linux/nospec.h>
+#include <linux/virtio.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
 #include <uapi/linux/vduse.h>
@@ -83,6 +84,10 @@ struct vduse_umem {
 	struct mm_struct *mm;
 };
 
+struct vduse_vq_group {
+	struct vduse_dev *dev;
+};
+
 struct vduse_dev {
 	struct vduse_vdpa *vdev;
 	struct device *dev;
@@ -115,6 +120,7 @@ struct vduse_dev {
 	u32 vq_num;
 	u32 vq_align;
 	struct vduse_umem *umem;
+	struct vduse_vq_group *groups;
 	struct mutex mem_lock;
 	unsigned int bounce_size;
 	struct mutex domain_lock;
@@ -615,6 +621,16 @@ static int vduse_vdpa_set_vq_state(struc
 	return 0;
 }
 
+static union virtio_map vduse_get_vq_map(struct vdpa_device *vdpa, u16 idx)
+{
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+	union virtio_map ret = {
+		.group = &dev->groups[0],
+	};
+
+	return ret;
+}
+
 static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx,
 				struct vdpa_vq_state *state)
 {
@@ -834,6 +850,7 @@ static const struct vdpa_config_ops vdus
 	.get_vq_affinity	= vduse_vdpa_get_vq_affinity,
 	.reset			= vduse_vdpa_reset,
 	.set_map		= vduse_vdpa_set_map,
+	.get_vq_map		= vduse_get_vq_map,
 	.free			= vduse_vdpa_free,
 };
 
@@ -841,7 +858,14 @@ static void vduse_dev_sync_single_for_de
 					     dma_addr_t dma_addr, size_t size,
 					     enum dma_data_direction dir)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	vduse_domain_sync_single_for_device(domain, dma_addr, size, dir);
 }
@@ -850,7 +874,14 @@ static void vduse_dev_sync_single_for_cp
 					     dma_addr_t dma_addr, size_t size,
 					     enum dma_data_direction dir)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	vduse_domain_sync_single_for_cpu(domain, dma_addr, size, dir);
 }
@@ -860,7 +891,14 @@ static dma_addr_t vduse_dev_map_page(uni
 				     enum dma_data_direction dir,
 				     unsigned long attrs)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return DMA_MAPPING_ERROR;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	return vduse_domain_map_page(domain, page, offset, size, dir, attrs);
 }
@@ -869,7 +907,14 @@ static void vduse_dev_unmap_page(union v
 				 size_t size, enum dma_data_direction dir,
 				 unsigned long attrs)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	return vduse_domain_unmap_page(domain, dma_addr, size, dir, attrs);
 }
@@ -877,33 +922,57 @@ static void vduse_dev_unmap_page(union v
 static void *vduse_dev_alloc_coherent(union virtio_map token, size_t size,
 				      dma_addr_t *dma_addr, gfp_t flag)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
-	unsigned long iova;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
 	void *addr;
 
 	*dma_addr = DMA_MAPPING_ERROR;
-	addr = vduse_domain_alloc_coherent(domain, size,
-					   (dma_addr_t *)&iova, flag);
+	if (!token.group)
+		return NULL;
+
+	addr = alloc_pages_exact(size, flag);
 	if (!addr)
 		return NULL;
 
-	*dma_addr = (dma_addr_t)iova;
+	vdev = token.group->dev;
+	domain = vdev->domain;
+	*dma_addr = vduse_domain_alloc_coherent(domain, size, addr);
+	if (*dma_addr == DMA_MAPPING_ERROR)
+		goto err;
 
 	return addr;
+
+err:
+	free_pages_exact(addr, size);
+	return NULL;
 }
 
 static void vduse_dev_free_coherent(union virtio_map token, size_t size,
 				    void *vaddr, dma_addr_t dma_addr,
 				    unsigned long attrs)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
 }
 
 static bool vduse_dev_need_sync(union virtio_map token, dma_addr_t dma_addr)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return false;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	return dma_addr < domain->bounce_size;
 }
@@ -917,7 +986,14 @@ static int vduse_dev_mapping_error(union
 
 static size_t vduse_dev_max_mapping_size(union virtio_map token)
 {
-	struct vduse_iova_domain *domain = token.iova_domain;
+	struct vduse_dev *vdev;
+	struct vduse_iova_domain *domain;
+
+	if (!token.group)
+		return 0;
+
+	vdev = token.group->dev;
+	domain = vdev->domain;
 
 	return domain->bounce_size;
 }
@@ -1716,6 +1792,7 @@ static int vduse_destroy_dev(char *name)
 	if (dev->domain)
 		vduse_domain_destroy(dev->domain);
 	kfree(dev->name);
+	kfree(dev->groups);
 	vduse_dev_destroy(dev);
 	module_put(THIS_MODULE);
 
@@ -1874,6 +1951,11 @@ static int vduse_create_dev(struct vduse
 	dev->device_features = config->features;
 	dev->device_id = config->device_id;
 	dev->vendor_id = config->vendor_id;
+	dev->groups = kcalloc(1, sizeof(dev->groups[0]), GFP_KERNEL);
+	if (!dev->groups)
+		goto err_vq_groups;
+	dev->groups[0].dev = dev;
+
 	dev->name = kstrdup(config->name, GFP_KERNEL);
 	if (!dev->name)
 		goto err_str;
@@ -1910,6 +1992,8 @@ err_dev:
 err_idr:
 	kfree(dev->name);
 err_str:
+	kfree(dev->groups);
+err_vq_groups:
 	vduse_dev_destroy(dev);
 err:
 	return ret;
@@ -2071,7 +2155,6 @@ static int vdpa_dev_add(struct vdpa_mgmt
 		return -ENOMEM;
 	}
 
-	dev->vdev->vdpa.vmap.iova_domain = dev->domain;
 	ret = _vdpa_register_device(&dev->vdev->vdpa, dev->vq_num);
 	if (ret) {
 		put_device(&dev->vdev->vdpa.dev);
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -41,13 +41,13 @@ struct virtqueue {
 	void *priv;
 };
 
-struct vduse_iova_domain;
+struct vduse_vq_group;
 
 union virtio_map {
 	/* Device that performs DMA */
 	struct device *dma_dev;
-	/* VDUSE specific mapping data */
-	struct vduse_iova_domain *iova_domain;
+	/* VDUSE specific virtqueue group for doing map */
+	struct vduse_vq_group *group;
 };
 
 int virtqueue_add_outbuf(struct virtqueue *vq,


