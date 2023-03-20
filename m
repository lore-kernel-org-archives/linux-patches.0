Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2CB1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70765C433D2;
	Mon, 20 Mar 2023 15:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325044;
	bh=WoHtjj8OLiwyM8WH0skVJldRCid1d/QYTnhjXPDK7Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5BFenT+Zghejlc951OKjc3CgAUtSPUdHglK6FgUyXGalK1qUqDjuttwG7fGFRO4w
	 dkE69w+Pg1nwZV9226Gz3DH5wrfMLhIEnlABbJcFANZc8+qfi8l8NuCjQ8LyHwAV7t
	 GqokRbj7sQlceg/e4h2YncJ+H52bvN9dzQNKSL/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/211] drm/virtio: Pass correct device to dma_sync_sgtable_for_device()
Date: Mon, 20 Mar 2023 15:52:17 +0100
Message-Id: <20230320145513.400639300@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>

[ Upstream commit a54bace095d00e9222161495649688bc43de4dde ]

The "vdev->dev.parent" should be used instead of "vdev->dev" as a device
for which to perform the DMA operation in both
virtio_gpu_cmd_transfer_to_host_2d(3d).

Because the virtio-gpu device "vdev->dev" doesn't really have DMA OPS
assigned to it, but parent (virtio-pci or virtio-mmio) device
"vdev->dev.parent" has. The more, the sgtable in question the code is
trying to sync here was mapped for the parent device (by using its DMA OPS)
previously at:
virtio_gpu_object_shmem_init()->drm_gem_shmem_get_pages_sgt()->
dma_map_sgtable(), so should be synced here for the same parent device.

Fixes: b5c9ed70d1a9 ("drm/virtio: Improve DMA API usage for shmem BOs")
Signed-off-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230224153450.526222-1-olekstysh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 9ff8660b50ade..208e9434cb28d 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -597,7 +597,7 @@ void virtio_gpu_cmd_transfer_to_host_2d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
-		dma_sync_sgtable_for_device(&vgdev->vdev->dev,
+		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    bo->base.sgt, DMA_TO_DEVICE);
 
 	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
@@ -1019,7 +1019,7 @@ void virtio_gpu_cmd_transfer_to_host_3d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
-		dma_sync_sgtable_for_device(&vgdev->vdev->dev,
+		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    bo->base.sgt, DMA_TO_DEVICE);
 
 	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
-- 
2.39.2



