Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624360;
	b=icVpQr1suYM+WRgXiZ44RE8WEg2EYjTgPqNFHH5G38Iuu04rCtTFyF+xjoUiUM65GRC8
	 wrbYRWwPxE8pvnnz8EVh+5U7mMipKuNCuNLU0me5qNWi/ACiLsLwxvHrhB/r9fCTKBYf2
	 E1sw4VVTfBolEDV44+lVOeT8JjBdAT9E/+dkMSvlD7zV8iPleqZ0sImy6/MJpcsMEGqG5
	 DHQOa64FbP6g70nLj0v/n5dTt25va5dZqJDp26nt43xekJ0BMDSLzOELkNxyWSXMK8YCO
	 fbkQtQ+/AbB4oDz+C/SaJ2fjvKVf0DHZo98ARRsav6AM0tFnN8NSnwpAmTZD1SbkkcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApRmExv3xNjeDERWVSaS3Xa+MnWcXcUrPgCIZeMhAWI=;
	b=DW8oEQ7S9aPPR9MfGkWERd7FoCcekHZMG4COvM2D3R6Nkk9GeYWKQ+9o+eV/8YAN1YYR
	 JJO4nLjoyT05jFdrVQtRq4o4VlBiAP1MmrWhjXpAe/B50EZ+xS7MU3uJnt/xWWfH0xDcf
	 FGhG2Gu+LnEc76vRrrbWtqvGb/9PQtbrpSyXt3FzT3chAwJbwEIXjs+A6QEm7XJD0chbB
	 PFa7e2ly95btevB5NUHyKJ89x+dB+kt3mOb1TOntq89vLGgn0mQxMK7S/M6kZRjCQS55P
	 W8EgKvPsuEwwVHuEVud85cpYaJ7hEfh4rzjM6T32+PxIML5O4XfQVBNUduJxPzAzaZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgRhGUtP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8967D606A33B;
	Wed, 25 Nov 2026 16:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgRhGUtP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C207D1F000D8;
	Wed, 25 Nov 2026 16:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624360;
	bh=ApRmExv3xNjeDERWVSaS3Xa+MnWcXcUrPgCIZeMhAWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgRhGUtP1Y4Ongc3c+U9uFLkwMkYR1PHH6Xjc4BwhyC/S5k+NLux33ncjTqgyvNGY
	 HCMj/tq520rCt2h5gxC6N/kbNR0HqlFqQSXKp5XKUwhtRJw3nlIhDgkcaYcbvT11yx
	 xUm4gOl67+uoAdm06uUSITrNC5NY2qmVN6PoybEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/816] vdpa_sim: serialize IOTLB updates with dataplane access
Date: Wed, 25 Nov 2026 15:27:59 +0100
Message-ID: <20261125143852.236898717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f7d346809e749..04dbdb8bf25a7 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -714,6 +714,7 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
@@ -722,6 +723,7 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	ret = vhost_iotlb_add_range_ctx(&vdpasim->iommu[asid], iova,
 					iova + size - 1, pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return ret;
 }
@@ -734,6 +736,7 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
@@ -741,6 +744,7 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	}
 	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 33e3100b3836d..f222d58d9ff95 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -976,6 +976,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
+		/* Stop device access before releasing the pinned pages. */
+		vhost_vdpa_general_unmap(v, map, asid);
 		pinned = PFN_DOWN(map->size);
 		for (pfn = PFN_DOWN(map->addr);
 		     pinned > 0; pfn++, pinned--) {
@@ -985,7 +987,6 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 			unpin_user_page(page);
 		}
 		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
-		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
-- 
2.53.0



