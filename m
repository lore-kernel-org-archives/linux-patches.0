Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31E7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D692C433C8;
	Sun, 17 Sep 2023 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980795;
	bh=7z1yttt3Z9Md1fPQ0S6gH/nJ9oulVBhVpYBPhPUuKLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXDIa0X3h1sJO1rM7IPZX/WYLjsUiN6xLtjqII0xFcF4QyVa/5klaB9IoRNzRjCtP
	 GLb3i9IhWu+bxvnCrB7GlMbHBetjMKJ8karWiRVDIXS8BuMMdsTHKmJZBh/BHcvwCx
	 LptBAR24WsU77Vapaduj7zacEMqv3mBeNQl3hmkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Alyssa Ross <hi@alyssa.is>
Subject: [PATCH 6.1 010/219] drm/virtio: Conditionally allocate virtio_gpu_fence
Date: Sun, 17 Sep 2023 21:12:17 +0200
Message-ID: <20230917191041.349158410@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Gurchetan Singh <gurchetansingh@chromium.org>

commit 70d1ace56db6c79d39dbe9c0d5244452b67e2fde upstream.

We don't want to create a fence for every command submission.  It's
only necessary when userspace provides a waitable token for submission.
This could be:

1) bo_handles, to be used with VIRTGPU_WAIT
2) out_fence_fd, to be used with dma_fence apis
3) a ring_idx provided with VIRTGPU_CONTEXT_PARAM_POLL_RINGS_MASK
   + DRM event API
4) syncobjs in the future

The use case for just submitting a command to the host, and expecting
no response.  For example, gfxstream has GFXSTREAM_CONTEXT_PING that
just wakes up the host side worker threads.  There's also
CROSS_DOMAIN_CMD_SEND which just sends data to the Wayland server.

This prevents the need to signal the automatically created
virtio_gpu_fence.

In addition, VIRTGPU_EXECBUF_RING_IDX is checked when creating a
DRM event object.  VIRTGPU_CONTEXT_PARAM_POLL_RINGS_MASK is
already defined in terms of per-context rings.  It was theoretically
possible to create a DRM event on the global timeline (ring_idx == 0),
if the context enabled DRM event polling.  However, that wouldn't
work and userspace (Sommelier).  Explicitly disallow it for
clarity.

Signed-off-by: Gurchetan Singh <gurchetansingh@chromium.org>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # edited coding style
Link: https://patchwork.freedesktop.org/patch/msgid/20230707213124.494-1-gurchetansingh@chromium.org
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -43,13 +43,9 @@ static int virtio_gpu_fence_event_create
 					 struct virtio_gpu_fence *fence,
 					 uint32_t ring_idx)
 {
-	struct virtio_gpu_fpriv *vfpriv = file->driver_priv;
 	struct virtio_gpu_fence_event *e = NULL;
 	int ret;
 
-	if (!(vfpriv->ring_idx_mask & BIT_ULL(ring_idx)))
-		return 0;
-
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e)
 		return -ENOMEM;
@@ -121,6 +117,7 @@ static int virtio_gpu_execbuffer_ioctl(s
 	struct virtio_gpu_device *vgdev = dev->dev_private;
 	struct virtio_gpu_fpriv *vfpriv = file->driver_priv;
 	struct virtio_gpu_fence *out_fence;
+	bool drm_fence_event;
 	int ret;
 	uint32_t *bo_handles = NULL;
 	void __user *user_bo_handles = NULL;
@@ -216,15 +213,24 @@ static int virtio_gpu_execbuffer_ioctl(s
 			goto out_memdup;
 	}
 
-	out_fence = virtio_gpu_fence_alloc(vgdev, fence_ctx, ring_idx);
-	if(!out_fence) {
-		ret = -ENOMEM;
-		goto out_unresv;
-	}
+	if ((exbuf->flags & VIRTGPU_EXECBUF_RING_IDX) &&
+	    (vfpriv->ring_idx_mask & BIT_ULL(ring_idx)))
+		drm_fence_event = true;
+	else
+		drm_fence_event = false;
+
+	if ((exbuf->flags & VIRTGPU_EXECBUF_FENCE_FD_OUT) ||
+	    exbuf->num_bo_handles ||
+	    drm_fence_event)
+		out_fence = virtio_gpu_fence_alloc(vgdev, fence_ctx, ring_idx);
+	else
+		out_fence = NULL;
 
-	ret = virtio_gpu_fence_event_create(dev, file, out_fence, ring_idx);
-	if (ret)
-		goto out_unresv;
+	if (drm_fence_event) {
+		ret = virtio_gpu_fence_event_create(dev, file, out_fence, ring_idx);
+		if (ret)
+			goto out_unresv;
+	}
 
 	if (out_fence_fd >= 0) {
 		sync_file = sync_file_create(&out_fence->f);


