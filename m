Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E3C3C0611;
	Tue, 21 Jul 2026 21:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669511; cv=none; b=fSKjTUySt8jMrmrQ6537XTikeww7HYEjVJXCZC5NhVXtN5Z2dUgKtUAHwgzOZMQVjQoQs5IuQ4Bisq/LoREKrHUwOYSThmI/SpZstRABE8+9/a7wvxjgAaYXLZUhGBMbNIkdm9NAg/Qs1APpEGb9tsv5mkTc2sUmOYswRZ4P88g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669511; c=relaxed/simple;
	bh=GkqvBQHwDVkUUZdS0jjT+4zs3fcN0pl7hfO34gReXl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBOePQYICIQhw4doHWq3oZhDAHVMgrAO+LrRB+idWDG5m1vz31FD5S/+8liH2KMbHv5sDqSpiymUtsXud6u5+jwAiL/ABY+qPA9olSYFn5FJ8zW6GxBA9ZrXOF0hKaNUCQMw32GBJNibUU0KJZ40p00ZJndMg6Ser5yiQUdFVAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMWJfYdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMWJfYdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809F51F000E9;
	Tue, 21 Jul 2026 21:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669510;
	bh=7i8sQZhS9CzwVlcgILe2uqoP2BTKXfO8j8O8jJCd6Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMWJfYdEqvNkLBKSFsUFZGg5MO3K0OUiq9M0FSOZLFzDyGWdiAcUa93zVoOoLBa1+
	 CzCQUE94KEpQsIH9uUCFKHejpW6LJ3zonaNFGrt7Hy76LuAWq2Uo9Z4kGMW4zx02E8
	 OG3YrasxblCpKJxoQp5SbjzYgTg9AIhjVbGtY3fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0582/1067] virtio_ring: introduce virtqueue_set_dma_premapped()
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152437.624095133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 8daafe9ebbd21a54bf91f9ff81decf215c203edd ]

This helper allows the driver change the dma mode to premapped mode.
Under the premapped mode, the virtio core do not do dma mapping
internally.

This just work when the use_dma_api is true. If the use_dma_api is false,
the dma options is not through the DMA APIs, that is not the standard
way of the linux kernel.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Message-Id: <20230810123057.43407-4-xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 9e5ad06ea826 ("virtio-net: fix len check in receive_big()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  2 ++
 2 files changed, 55 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 06a64c4adc987a..be657868d40482 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -172,6 +172,9 @@ struct vring_virtqueue {
 	/* Host publishes avail event idx */
 	bool event;
 
+	/* Do DMA mapping by driver */
+	bool premapped;
+
 	/* Head of free buffer list. */
 	unsigned int free_head;
 	/* Number we've added since last sync. */
@@ -2031,6 +2034,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 #endif
 	vq->packed_ring = true;
 	vq->use_dma_api = vring_use_dma_api(vdev);
+	vq->premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2518,6 +2522,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->broken = false;
 #endif
 	vq->use_dma_api = vring_use_dma_api(vdev);
+	vq->premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2636,6 +2641,54 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 }
 EXPORT_SYMBOL_GPL(virtqueue_resize);
 
+/**
+ * virtqueue_set_dma_premapped - set the vring premapped mode
+ * @_vq: the struct virtqueue we're talking about.
+ *
+ * Enable the premapped mode of the vq.
+ *
+ * The vring in premapped mode does not do dma internally, so the driver must
+ * do dma mapping in advance. The driver must pass the dma_address through
+ * dma_address of scatterlist. When the driver got a used buffer from
+ * the vring, it has to unmap the dma address.
+ *
+ * This function must be called immediately after creating the vq, or after vq
+ * reset, and before adding any buffers to it.
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error.
+ * 0: success.
+ * -EINVAL: vring does not use the dma api, so we can not enable premapped mode.
+ */
+int virtqueue_set_dma_premapped(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u32 num;
+
+	START_USE(vq);
+
+	num = vq->packed_ring ? vq->packed.vring.num : vq->split.vring.num;
+
+	if (num != vq->vq.num_free) {
+		END_USE(vq);
+		return -EINVAL;
+	}
+
+	if (!vq->use_dma_api) {
+		END_USE(vq);
+		return -EINVAL;
+	}
+
+	vq->premapped = true;
+
+	END_USE(vq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtqueue_set_dma_premapped);
+
 /* Only available for split ring */
 struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      unsigned int num,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index dcab9c7e878433..7281a7e02460b5 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -78,6 +78,8 @@ bool virtqueue_enable_cb(struct virtqueue *vq);
 
 unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
 
+int virtqueue_set_dma_premapped(struct virtqueue *_vq);
+
 bool virtqueue_poll(struct virtqueue *vq, unsigned);
 
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
-- 
2.53.0



