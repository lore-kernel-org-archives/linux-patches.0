Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD313890F8;
	Sat, 17 Oct 2026 18:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260782; cv=none; b=j07frVWXELXSJ3XRBai00FrN/w6VsqVlrptSsjZMCsugBDf2t5gViMrkc2DzNjSSRcjcCNnbV8B1kiHy1F429EMP0YpzmNNggKLu8jTqoiLEXw5LmI2Kk7lS8GPVWU9ARcpfPNH/0tkM4s6RL2WacWPZKKnOy4VgamezQ3qVeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260782; c=relaxed/simple;
	bh=RvBXnB0QJIGslxrM0BOBwSuCAQfI43UTmq24GVOJYtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhB11RPjMuKrFA6E9TCVxhbcZR7rqy8suGVHRb17PG0bmu9v7wBzFDDoTCPtbgfe9nRyKH54Au08iK2XkXgo4ft4JZ2qBOJscOmVED2LGQ/EjzfuSLz24G4d2vXZAG0P0D6D1KYSm3mhER/iCCKE+cxpAd+Jzl+YMOcVh22X9dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb8kh6ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb8kh6ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD041F000C4;
	Sat, 17 Oct 2026 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260781;
	bh=xz1SBhFVTZvIkLM+Rc3FAmwl2BQzYmiczGvnFT980bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bb8kh6ii0gwT7nv1Hs2Ntsbuy3SeXFPLAPRq6f6dBx2+tflQHXjrrimdove74yJbJ
	 xFXJFrGfEbBuanleiHdeUVZczNzy0vDbreAkOhrbO1P7GppS15zSutl9Os0YuobaPR
	 9+Xntg8LRqSx3t0EUKrN+IdEZjSJcBfj9PQ46HX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Leggett <benjamin@edera.io>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1657/1674] drm/virtio: use the DMA API for resource backing on Xen
Date: Sat, 17 Oct 2026 18:05:29 +0200
Message-ID: <20261017160513.603666019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Leggett <benjamin@edera.io>

[ Upstream commit 6a736d2f9d0c6e6217fe7532bc4c50ceca71db78 ]

On a Xen PV domain page addresses bear no relation to the real machine
addresses the host would have to use to reach it.
virtio_ring.c handles this correctly, vring_use_map_api() returns true
for any xen_domain() regardless of VIRTIO_F_ACCESS_PLATFORM.

virtio-gpu makes the same decision independently, but its copy
looks only at the feature bit:

	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);

QEMU does not set iommu_platform on virtio-vga by default, so
VIRTIO_F_ACCESS_PLATFORM is not negotiated, use_dma_api is false, and
virtio_gpu_object_shmem_init() describes the framebuffer's backing pages
to the host with sg_phys().  Those are guest-physical addresses. In a PV
domain they resolve, on the host side, to pages belonging to some other
domain, so the host scans out unrelated memory.

Move the decision into virtio_gpu_use_dma_api() and give it the
xen_domain() check, like vring_use_map_api() has. This
additionally enables the dma_sync_sgtable_for_device() calls in
virtgpu_vq.c, which are required for correctness whenever swiotlb
is in play.

Reproduced with a Xen 4.21 PV dom0 nested inside QEMU 8.2 with
virtio-vga, on both a distro 6.8 kernel and 6.18 LTS. A PVH dom0
works fine and doesn't need this fix because it is identity-mapped,
only PV dom0s are affected.

Fixes: a3b815f09bb8 ("drm/virtio: add iommu support.")
Signed-off-by: Ben Leggett <benjamin@edera.io>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260806-virtgpu-xen-dma-v1-1-e499b345bbad@edera.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.h    | 20 ++++++++++++++++++++
 drivers/gpu/drm/virtio/virtgpu_object.c |  2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c     |  4 ++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 9f9ded45cd6a1..de36af56df863 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -43,6 +43,8 @@
 #include <drm/drm_probe_helper.h>
 #include <drm/virtgpu_drm.h>
 
+#include <xen/xen.h>
+
 #define DRIVER_NAME "virtio_gpu"
 #define DRIVER_DESC "virtio GPU"
 #define DRIVER_DATE "0"
@@ -58,6 +60,24 @@
 #define MAX_CAPSET_ID 63
 #define MAX_RINGS 64
 
+/*
+ * Whether the host must be told about resource backing pages by DMA address
+ * rather than guest-physical address.
+ *
+ * This mirrors vring_use_map_api() in drivers/virtio/virtio_ring.c, including
+ * its xen_domain() case.
+ */
+static inline bool virtio_gpu_use_dma_api(const struct virtio_device *vdev)
+{
+	if (!virtio_has_dma_quirk(vdev))
+		return true;
+
+	if (xen_domain())
+		return true;
+
+	return false;
+}
+
 struct virtio_gpu_object_params {
 	unsigned long size;
 	bool dumb;
diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index c7e74cf130221..c4f8cdf85f60a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -137,7 +137,7 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 					struct virtio_gpu_mem_entry **ents,
 					unsigned int *nents)
 {
-	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
+	bool use_dma_api = virtio_gpu_use_dma_api(vgdev->vdev);
 	struct scatterlist *sg;
 	struct sg_table *pages;
 	int si;
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index a4d1a77103259..d2c83f3e74b99 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -601,7 +601,7 @@ void virtio_gpu_cmd_transfer_to_host_2d(struct virtio_gpu_device *vgdev,
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(objs->objs[0]);
 	struct virtio_gpu_transfer_to_host_2d *cmd_p;
 	struct virtio_gpu_vbuffer *vbuf;
-	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
+	bool use_dma_api = virtio_gpu_use_dma_api(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
 		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
@@ -1020,7 +1020,7 @@ void virtio_gpu_cmd_transfer_to_host_3d(struct virtio_gpu_device *vgdev,
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(objs->objs[0]);
 	struct virtio_gpu_transfer_host_3d *cmd_p;
 	struct virtio_gpu_vbuffer *vbuf;
-	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
+	bool use_dma_api = virtio_gpu_use_dma_api(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
 		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
-- 
2.53.0



