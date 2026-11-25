Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624389;
	b=iJGUikCl3nsiX+z3Z8CGkQrArxoy1mSkUtMSa5fBGQZTjJ03JnntAXX1rITgQYKowgGF
	 NSLv7DtPwMcjD5nApFNHaWgRMvCFW1KfBUD3Wo5ljW6MN/UHU/18pUP2o3NkiB9pcXHtU
	 0mRH1BKAg+y9KHxtAxtT91LrX1N8XUkm4BA9UKgudrQCFcfiSFKGh8w+H1WIA62OeERtQ
	 pkiFGkEfaAMb85ISqeat24hfieAS/iL1jKZK7NtMlB+NojSNyPDC4JPfc1ClebwNlFUgU
	 Rb3rqq/KOL/cVUSlevZ1BVjj7HUFHPWWKUYURAZvQzdR/sfyQtvRpU0UOKNjCmk/caw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cK3sJa0lddCRd1Hgnx+cP9cyMH7O2N9Cc0QF9WdS9HA=;
	b=hBMjTiKxOmX+cPYYE8j5b34sOCW6YIW0Zy8ibIi2S/AoconWiEe6dgU/w8MJ3K2IUidV
	 hXPizqcMJqxGyb16jIF6gRMUYzHxw2QOO/7uap2zbrnBn/iGwOLr4gclaBZFzDJtMUzLh
	 SjiFZYQkK1o3CHib3FAMQ3yj2X9i8GlZ7iwlPnbPEakqeAK5Cs+/KxUNhxXY1LKxrh9//
	 aEdGTodF7z3VGA7H0oRoabreg7RUHKozRCJ32eOT9+fouKp465E1MsMghqz55MpD7CNv1
	 gIThm8CvVoWsi8OsPrIEd7ZvnhJxktE/h4ttIlbGQzMO/oPeXcQ+x6ainbvBMB0aviQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKNgYTZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE178606A33A;
	Wed, 25 Nov 2026 16:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKNgYTZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA341F0089F;
	Wed, 25 Nov 2026 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624389;
	bh=cK3sJa0lddCRd1Hgnx+cP9cyMH7O2N9Cc0QF9WdS9HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKNgYTZ8xK/4SupF0V2eYvDqQ1qSYwWAYQA41KBdnnWUZh5iIPKsCcRigHQW022BU
	 8Xm5pLR5HnpB9pe9dK5OZG8uCpzDthrK8IFhttTMY7q003/GpFsB5lM4ehaFLdMz7U
	 O3IhL7+jiLzuQR6gdNDYP0XQ0M/ZCEh6bRkC33yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/816] vdpa: invalidate DMA mappings before releasing memory
Date: Wed, 25 Nov 2026 15:28:00 +0100
Message-ID: <20261125143852.259309763@linuxfoundation.org>
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
index 66d5231f03c22..dd577f24bf753 100644
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
index 04dbdb8bf25a7..0e5e194a4558c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -639,6 +639,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 
 	iommu = &vdpasim->iommu[asid];
@@ -653,11 +654,13 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
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
index f222d58d9ff95..d467422559cdc 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -998,10 +998,10 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
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
@@ -1075,21 +1075,39 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
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
@@ -1339,7 +1357,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
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



