Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621204;
	b=M4CEYVIy9pTpYsgD3IpF9aU1JnrzTwTIqGDKRZ7aszazyoeBukf9Fytxh+z2hvJuKOJj
	 Z7M76mlrNL2bfaVmrJliQRNIJQ+Ofjrytq6eSfFXAq/5y7Pk60HvP2cAipZD+2UtgI2s1
	 Wt/L6Y0Ug0IEB3++LkFAsDAoPNxHgi/0diMpRi7WYrtbYXCHVqj5tkW2g32FLYA1a0bVM
	 sJfua8dEhOT34OgDEInG8B0FrIQeLxhYwZcRkdh5YOrrOovofwtMzP2+Z3d6AvjM/zk6E
	 5vWLqp0265qTzM2A2QtOEPAp6c9L4bZetHXIuxbHMCpGupj7RKYZISGIFwvKuiNcKAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37aUkjr/XfRgd5wIzChDmrWUWuFnBwaFpXEUc59zjiY=;
	b=QbN8HrnYZuJkThDxTw0b0yTEPfzVhb9aGURTNFBeahgoeZfS55N0wj3Oi9tpJRK6dfFh
	 B8OWMkFBRDKLgX8PDd+ZqBbjOaMGO2Smp6p74bjiKIExzBeOaa/CgFL5zrPIeZUQvlGns
	 oEwo70BVDh+/PPSAUaWqKkw+xxd1czGFh5tSvt99gbDF6M87XEDfNKT5xbjKF7pvS2/gl
	 qzZwfAWtYnsvV2sr4icXQfrm11mKAI2PA9u+2qpzW8qcGTxZ39zsDtQ1DR9NeDfvacfHE
	 CPBaz2cTp3vPZcEYKiA1JBy84Be4dhed7di2GmC07H8rGkdySvawwuBnSgmdl51FQbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HvdkTR83;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2185606A6B4;
	Wed, 25 Nov 2026 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HvdkTR83
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97731F00A3E;
	Wed, 25 Nov 2026 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621204;
	bh=37aUkjr/XfRgd5wIzChDmrWUWuFnBwaFpXEUc59zjiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvdkTR83udT3ddjo/SmodUqhAznUOGiVMRVBJtLp4BGIFNjfasbPccwSnsCj13QNU
	 IMS2OWV4Npw2pXkSFl+GmY2cggtmdWlSHuKAPrLvPQP6mSOYY32MuNQoUgMNA/mEX0
	 alLkXzOAIJmGEWJQN/R8yyNDpzMlCO24zxwCeVbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/990] vdpa: invalidate DMA mappings before releasing memory
Date: Wed, 25 Nov 2026 15:25:19 +0100
Message-ID: <20261125143825.652688259@linuxfoundation.org>
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

[ Upstream commit acbf36deb53d9e14e4768bf58883795a8232aa5b ]

vdpa can release pinned pages and file references before the device stops
using the corresponding mappings, allowing stale DMA to corrupt memory.

Invalidate mappings before dropping their backing references. For set_map
backends, publish an IOTLB without the invalidated range and keep the old
references if that fails. Do this immediately even within a batch.

Serialize vdpa_sim set_map updates with its worker so publishing a new map
cannot race an active transfer. Abort mlx5 map replacement when resumable
virtqueues cannot be suspended, since changing the memory region while
those queues remain active would preserve the same stale DMA window. Reject
zero-sized and wrapping invalidations before calculating their inclusive
range end.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20260911-fix-vdpa-iotlb-lifetime-v3-2-8766d371748e@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 10 +++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  3 +++
 drivers/vhost/vdpa.c              | 40 ++++++++++++++++++++++++-------
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index c49167d760a62..6cf55ce8ad4a8 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3048,7 +3048,15 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	bool teardown = !is_resumable(ndev);
 	int err;
 
-	suspend_vqs(ndev, 0, ndev->cur_num_vqs);
+	if ((mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) && !mvdev->suspended) {
+		err = suspend_vqs(ndev, 0, ndev->cur_num_vqs);
+		if (err && !teardown) {
+			for (int i = 0; i < ndev->cur_num_vqs; i++)
+				resume_vqs(ndev, i, 1);
+			mlx5_vdpa_put_mr(mvdev, new_mr);
+			return err;
+		}
+	}
 	if (teardown) {
 		err = save_channels_info(ndev);
 		if (err) {
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 50a28e35d185a..aeed6bab3e174 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -641,6 +641,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 
 	iommu = &vdpasim->iommu[asid];
@@ -655,11 +656,13 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			goto err;
 	}
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 	return 0;
 
 err:
 	vhost_iotlb_reset(iommu);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 	return ret;
 }
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 62c2ea705b38b..eeb57c832d740 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -996,10 +996,10 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	struct vdpa_map_file *map_file;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
+		vhost_vdpa_general_unmap(v, map, asid);
 		map_file = (struct vdpa_map_file *)map->opaque;
 		fput(map_file->file);
 		kfree(map_file);
-		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -1073,21 +1073,39 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	return 0;
 }
 
-static void vhost_vdpa_unmap(struct vhost_vdpa *v,
-			     struct vhost_iotlb *iotlb,
-			     u64 iova, u64 size)
+static int vhost_vdpa_unmap(struct vhost_vdpa *v,
+			    struct vhost_iotlb *iotlb,
+			    u64 iova, u64 size)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_iotlb_map *map;
+	struct vhost_iotlb new_iotlb;
 	u32 asid = iotlb_to_asid(iotlb);
+	u64 last = iova + size - 1;
+	int ret;
 
-	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1, asid);
+	if (ops->set_map && !ops->dma_map) {
+		vhost_iotlb_init(&new_iotlb, iotlb->limit, iotlb->flags);
+		list_for_each_entry(map, &iotlb->list, link) {
+			if (map->start <= last && map->last >= iova)
+				continue;
+			ret = vhost_iotlb_add_range_ctx(&new_iotlb, map->start,
+							map->last, map->addr,
+							map->perm, map->opaque);
+			if (ret)
+				goto reset;
+		}
 
-	if (ops->set_map) {
-		if (!v->in_batch)
-			ops->set_map(vdpa, asid, iotlb);
+		ret = ops->set_map(vdpa, asid, &new_iotlb);
+reset:
+		vhost_iotlb_reset(&new_iotlb);
+		if (ret)
+			return ret;
 	}
 
+	vhost_vdpa_iotlb_unmap(v, iotlb, iova, last, asid);
+	return 0;
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
@@ -1337,7 +1355,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
 		break;
 	case VHOST_IOTLB_INVALIDATE:
-		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
+		if (!msg->size || msg->iova > U64_MAX - msg->size + 1) {
+			r = -EINVAL;
+			break;
+		}
+		r = vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
 		v->batch_asid = asid;
-- 
2.53.0



