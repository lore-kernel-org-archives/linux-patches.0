Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD93C1D49;
	Sat, 17 Oct 2026 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255516; cv=none; b=jZmjgC83JNqH7pDiBt5hunrWwpusPFtLouawrkxW4y17U68rt6tWJHYD6NEG8EuzW7KjUHqCd4dSBtkqrg42e7jAyHS1l4iSjGdj1TFd9uuSMKdINp0BC7dm+6GZIwsGaTQJK3C51tTmfhw9Gnl0/Nio3zi5EhzD6icca68o2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255516; c=relaxed/simple;
	bh=IfXoR4X5MSd4yr2CfghWlN2aPwpb/8pqrtGq1pbl81s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRPpZLm9K3wT4eL7zy8TImZztoR29rY/auiziozCUQrUfAXPwMNX0qiGDN9/efq16XXxEvW2GE51xgDH1Mx+5NfP46X9QwHlye1KdS1/Oivr28JsnmlSpdhLiattODtZfDrhM2uWLCYMNTmNW6RiqtfnaXJIyYrL/T/YlKhesfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZb9px0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZb9px0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343C11F000C4;
	Sat, 17 Oct 2026 16:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255515;
	bh=NrlG+UJw9/Vv6p4hcmivwxrZ/zG/YT/lTPCst6esF18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZb9px0iuf6uDSKAjWQuQQ7HB0E+TlNfCFINkDF93W6Rja/vaAl5CtRaTqGVHWr4l
	 mcGvyHfs3eiJj6aUQ0oMDQDp2NYkyFgAtM8380aF3Iaom8IdnpatkioNdtDTBjf+c9
	 YzIzRMqSZxB6WiqQucj7zN5fOjU9o3AbYTpe7T0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Leggett <benjamin@edera.io>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 803/869] drm/virtio: use the DMA API for resource backing on Xen
Date: Sat, 17 Oct 2026 18:00:44 +0200
Message-ID: <20261017160057.489888739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c73fbb239ddc4..a597c73a2bf1a 100644
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
@@ -61,6 +63,24 @@
 /* See virtio_gpu_ctx_create. One additional character for NULL terminator. */
 #define DEBUG_NAME_MAX_LEN 65
 
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
index 4369275cb56b5..9bf7e69b85aa6 100644
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



