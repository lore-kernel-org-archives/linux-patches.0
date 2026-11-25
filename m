Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621201;
	b=4+ySgP/GTWpwxjhE1g+olLvUwMMTC2w436MWUUQDJaapFqZIVEiAzvzxpEa2jHcBhMKr
	 UDTpty5gYyYV0umrIi+SQKf4LSJsegfW0O+YMU+a1Jbe6uPET0pLz3r6Zc6GKcna9fKC7
	 /E1Ru8hLrMasNs+gcQKvtNpQSMVPWCiD+WBpqL8IwGG6tTQG8DPhvqPmNvQhev2F3bhOv
	 0AvYb/paVUOn4GdWsMsBtmVLirkvbyb9BtNH08wdVXDXr/SOW1oRtUqynBF/VPX+lsBAe
	 7yrd1+PcgtMHHx2vDFahGbLDsmDeGTmQdCoEJ5EKBE83mBFTT0mNJAJz4X9tQrvOxbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66ZeZ1/CYrb4zSP8xui2/DsDjALzq4RYSlVogetHf4k=;
	b=fRtI0iXUX549rmz/9FzYg9eQsqmsMF4KjYCXz0EDStXzvhev/+PHZrcHnPv0db7C6Uzl
	 lgcaXGdbHm7bgE08SBAkcjT55AYiZuLeJ1x4GYgPuhEKpDrCYj1pJSELShL6+ikqvymoj
	 UjvOt5ioiHjZhjxxRQeWqZhTN2JYi4LzYBABYXE7tdBhmCBkPvJHz1yNWc7gs3VRmAFEh
	 Ifn4Rxxr3RQseWK3Ib1/kDEiQzaOgkYYdefFbnyu6wirYwHUj8Al1sfnulOeIf0yUPmaC
	 6o8je8SIkg6rCz5Xg9yh9L9m/yHD1+KHkKLBBtZ9Gfq2y414JX0oFd/0nC000bYPUlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFIvuBCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096C8606A696;
	Wed, 25 Nov 2026 15:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFIvuBCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3619E1F000C0;
	Wed, 25 Nov 2026 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621200;
	bh=66ZeZ1/CYrb4zSP8xui2/DsDjALzq4RYSlVogetHf4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFIvuBCMOXDgGw0QbrqJx6NHs6RpLS9BRGbUs/bVeueS3moHSAgRRHbaJMOmFQMk9
	 0jBi424GXXb/WXmfFFoCntTGu+cHfQ285/sfMpE6mckRy2ojPe7qhtx1vnrcY8KjJx
	 KaXOZFKsOec/pJpNBdApKKSGI4xHtONEVTiqg+20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/990] vdpa_sim: serialize IOTLB updates with dataplane access
Date: Wed, 25 Nov 2026 15:25:18 +0100
Message-ID: <20261125143825.628488560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 8517ed4429a2eefd002dce00ea46e23e6714350b ]

The simulator translates IOTLB entries into iovecs or bvecs under
iommu_lock, then drops the lock before copying data. A concurrent DMA
unmap can delete the mapping and release its pinned backing pages while
the copy is still in progress, leading to a UAF in _copy_from_iter().

Use the existing simulator mutex to serialize DMA map changes with the
full backend work function. Also make vhost-vdpa stop device access before
unpinning the backing pages. Otherwise, waiting in the simulator DMA unmap
callback happens after the pages have already been released and cannot
protect their lifetime.

Keep iommu_lock for the IOTLB table itself and avoid adding a second
long-lived lock to the simulator.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20260911-fix-vdpa-iotlb-lifetime-v3-1-8766d371748e@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 4 ++++
 drivers/vhost/vdpa.c             | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 44055778b6940..50a28e35d185a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -716,6 +716,7 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
@@ -724,6 +725,7 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	ret = vhost_iotlb_add_range_ctx(&vdpasim->iommu[asid], iova,
 					iova + size - 1, pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return ret;
 }
@@ -736,6 +738,7 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
@@ -743,6 +746,7 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	}
 	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e4ddaf0e5abc6..62c2ea705b38b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -974,6 +974,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
+		/* Stop device access before releasing the pinned pages. */
+		vhost_vdpa_general_unmap(v, map, asid);
 		pinned = PFN_DOWN(map->size);
 		for (pfn = PFN_DOWN(map->addr);
 		     pinned > 0; pfn++, pinned--) {
@@ -983,7 +985,6 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 			unpin_user_page(page);
 		}
 		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
-		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
-- 
2.53.0



