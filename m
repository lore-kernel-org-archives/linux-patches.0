Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AC3443E44;
	Thu, 30 Jul 2026 15:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426642; cv=none; b=n22OyM0risQ7wvyzOz5jdJ+e1owsBexQR/557iDhdBk9ApAwq2LEQjU3TwFl5MuFFEByadC4/LH3n4KtRe8ZA/Y1oHVtu34wVE6BoG9WGH8VmN0zHW2KlBvCHozNEulcVOaCcxzpaJHO39cm0789ItDkHcIJ9hwfEFc87dcvTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426642; c=relaxed/simple;
	bh=v+DC22oWqbChZIpshT+/ZTu7K2ne3LqzttJ/ELTPecc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFem2ViFgviqwDGWObGf2ClWmdQ1KbAYgUWxEe+VQjXJjxuQ6D0J8yFVwimKgGsju0ChjSEjyzKqZ0pGPSpXbmUHxQfG1/AlYexZRFkzZuPf/o3rnBPEZX7f2x7Y9Ukjc6G/2couewx64A8jUkQOkLQJghL9kjHAMr68UcrWnOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeBtExaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeBtExaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC0B1F00A3A;
	Thu, 30 Jul 2026 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426641;
	bh=szLbRhdt+DIRIQXl4tqm5owNRcOqusR26TCwQj47v8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeBtExafRZHvnxvQ35Nb0qjwByfpwOFAwaxEQncL6WgFAdss2iV/YAStLQPQKdG6n
	 LWSLupw9YerxASjHUvrH00XeaMCalGRtZ/WGpujF1+qXU1wz20LqAP+w7h7AT6cUly
	 N2n0Bn9VYlgmf4uAjaFTZUb10OvRVAZIc+wyejNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/602] vduse: take out allocations from vduse_dev_alloc_coherent
Date: Thu, 30 Jul 2026 16:14:43 +0200
Message-ID: <20260730141446.286114129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit 489d76520612abf9a4ede4344349105406c91a73 ]

The function vduse_dev_alloc_coherent will be called under rwlock in
next patches.  Make it out of the lock to avoid increasing its fail
rate.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-10-eperezma@redhat.com>
Stable-dep-of: 9c1523803445 ("VDUSE: avoid leaking information to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |   24 +++++++-----------------
 drivers/vdpa/vdpa_user/iova_domain.h |    5 ++---
 drivers/vdpa/vdpa_user/vduse_dev.c   |   14 ++++++++++----
 3 files changed, 19 insertions(+), 24 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -493,17 +493,15 @@ void vduse_domain_unmap_page(struct vdus
 	vduse_domain_free_iova(iovad, dma_addr, size);
 }
 
-void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
-				  size_t size, dma_addr_t *dma_addr,
-				  gfp_t flag, unsigned long attrs)
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
@@ -533,7 +526,6 @@ void vduse_domain_free_coherent(struct v
 	struct iova_domain *iovad = &domain->consistent_iovad;
 	struct vhost_iotlb_map *map;
 	struct vdpa_map_file *map_file;
-	phys_addr_t pa;
 
 	spin_lock(&domain->iotlb_lock);
 	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
@@ -545,12 +537,10 @@ void vduse_domain_free_coherent(struct v
 	map_file = (struct vdpa_map_file *)map->opaque;
 	fput(map_file->file);
 	kfree(map_file);
-	pa = map->addr;
 	vhost_iotlb_map_free(domain->iotlb, map);
 	spin_unlock(&domain->iotlb_lock);
 
 	vduse_domain_free_iova(iovad, dma_addr, size);
-	free_pages_exact(phys_to_virt(pa), size);
 }
 
 static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
--- a/drivers/vdpa/vdpa_user/iova_domain.h
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -67,9 +67,8 @@ void vduse_domain_unmap_page(struct vdus
 			     dma_addr_t dma_addr, size_t size,
 			     enum dma_data_direction dir, unsigned long attrs);
 
-void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
-				  size_t size, dma_addr_t *dma_addr,
-				  gfp_t flag, unsigned long attrs);
+dma_addr_t vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
+				       size_t size, void *orig);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
 				dma_addr_t dma_addr, unsigned long attrs);
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -883,18 +883,23 @@ static void *vduse_dev_alloc_coherent(st
 {
 	struct vduse_dev *vdev = dev_to_vduse(dev);
 	struct vduse_iova_domain *domain = vdev->domain;
-	unsigned long iova;
 	void *addr;
 
 	*dma_addr = DMA_MAPPING_ERROR;
-	addr = vduse_domain_alloc_coherent(domain, size,
-				(dma_addr_t *)&iova, flag, attrs);
+
+	addr = alloc_pages_exact(size, flag);
 	if (!addr)
 		return NULL;
 
-	*dma_addr = (dma_addr_t)iova;
+	*dma_addr = vduse_domain_alloc_coherent(domain, size, addr);
+	if (*dma_addr == DMA_MAPPING_ERROR)
+		goto err;
 
 	return addr;
+
+err:
+	free_pages_exact(addr, size);
+	return NULL;
 }
 
 static void vduse_dev_free_coherent(struct device *dev, size_t size,
@@ -905,6 +910,7 @@ static void vduse_dev_free_coherent(stru
 	struct vduse_iova_domain *domain = vdev->domain;
 
 	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
+	free_pages_exact(vaddr, size);
 }
 
 static size_t vduse_dev_max_mapping_size(struct device *dev)


