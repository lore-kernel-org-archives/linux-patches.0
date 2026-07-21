Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E23C0617;
	Tue, 21 Jul 2026 21:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669514; cv=none; b=BiKAR6CLAKzXQmmu4n/J/+uA5HfROaKf8+Yni7lZaWFkE6xO8vjbJjjggeAuk2YOUB27ib2GWhejJhk/ahIX5pottkUM/OnrMl0CFqZl7H1cQScR3MiM2og92a26Po2sLykEEqRqCd6mVl24FgCd9iAd3D8jIKTLZaxuKBl0hjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669514; c=relaxed/simple;
	bh=Hn5C34P+5OOk2UqEmGdOKRZYBpYYl3XwN5LEp4K/I78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxENdgcjAb5JRhUpiLHyzhxGWAO9BkToPT3fOQ60KpJC5xfoabUhM3MIrRGGQuDzTw3pOcRc0yG7AEpRwvgNGc2RshcNJxhDMDxGAJYYAl3g7hr35KUyItmGjOgQNtjrFzvzzKydxiEf/BytbwqcY8Cssa/J1b8Di170BXvwMqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4zlXvHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4zlXvHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5CF1F000E9;
	Tue, 21 Jul 2026 21:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669512;
	bh=rcvyfGnqoV2cu0Ui0X7ZqApn+mVIfzSAfW0e5lxvG1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4zlXvHYD+pbG0fe6P9J8Rbgf2r1uYnKz/VKc6kXDuisNlIRP3Tx81qx9x/uWbdkX
	 3de1/+g3dWCVGcotCIOAIi/8X8MkI+y47yZoBA4IIOiJSN/r7y9oMXR01Ogd1ISzdV
	 lrhHxBw4mEkY1Ce2c/KntrNELVatWaQXtkoAZRUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0583/1067] virtio_ring: introduce dma map api for virtqueue
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152437.647620080@linuxfoundation.org>
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

[ Upstream commit b6253b4e21939f1bb54e8fdb84c23af9c3fb834a ]

Added virtqueue_dma_map_api* to map DMA addresses for virtual memory in
advance. The purpose is to keep memory mapped across multiple add/get
buf operations.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Message-Id: <20230810123057.43407-11-xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 9e5ad06ea826 ("virtio-net: fix len check in receive_big()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  8 +++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index be657868d40482..25c9ecae60aaaf 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2926,4 +2926,73 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring);
 
+/**
+ * virtqueue_dma_map_single_attrs - map DMA for _vq
+ * @_vq: the struct virtqueue we're talking about.
+ * @ptr: the pointer of the buffer to do dma
+ * @size: the size of the buffer to do dma
+ * @dir: DMA direction
+ * @attrs: DMA Attrs
+ *
+ * The caller calls this to do dma mapping in advance. The DMA address can be
+ * passed to this _vq when it is in pre-mapped mode.
+ *
+ * return DMA address. Caller should check that by virtqueue_dma_mapping_error().
+ */
+dma_addr_t virtqueue_dma_map_single_attrs(struct virtqueue *_vq, void *ptr,
+					  size_t size,
+					  enum dma_data_direction dir,
+					  unsigned long attrs)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return (dma_addr_t)virt_to_phys(ptr);
+
+	return dma_map_single_attrs(vring_dma_dev(vq), ptr, size, dir, attrs);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_map_single_attrs);
+
+/**
+ * virtqueue_dma_unmap_single_attrs - unmap DMA for _vq
+ * @_vq: the struct virtqueue we're talking about.
+ * @addr: the dma address to unmap
+ * @size: the size of the buffer
+ * @dir: DMA direction
+ * @attrs: DMA Attrs
+ *
+ * Unmap the address that is mapped by the virtqueue_dma_map_* APIs.
+ *
+ */
+void virtqueue_dma_unmap_single_attrs(struct virtqueue *_vq, dma_addr_t addr,
+				      size_t size, enum dma_data_direction dir,
+				      unsigned long attrs)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return;
+
+	dma_unmap_single_attrs(vring_dma_dev(vq), addr, size, dir, attrs);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_unmap_single_attrs);
+
+/**
+ * virtqueue_dma_mapping_error - check dma address
+ * @_vq: the struct virtqueue we're talking about.
+ * @addr: DMA address
+ *
+ * Returns 0 means dma valid. Other means invalid dma address.
+ */
+int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return 0;
+
+	return dma_mapping_error(vring_dma_dev(vq), addr);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_mapping_error);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7281a7e02460b5..b16e77ff2b3e56 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/gfp.h>
+#include <linux/dma-mapping.h>
 
 /**
  * struct virtqueue - a queue to register buffers for sending or receiving.
@@ -208,4 +209,11 @@ void unregister_virtio_driver(struct virtio_driver *drv);
 #define module_virtio_driver(__virtio_driver) \
 	module_driver(__virtio_driver, register_virtio_driver, \
 			unregister_virtio_driver)
+
+dma_addr_t virtqueue_dma_map_single_attrs(struct virtqueue *_vq, void *ptr, size_t size,
+					  enum dma_data_direction dir, unsigned long attrs);
+void virtqueue_dma_unmap_single_attrs(struct virtqueue *_vq, dma_addr_t addr,
+				      size_t size, enum dma_data_direction dir,
+				      unsigned long attrs);
+int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr);
 #endif /* _LINUX_VIRTIO_H */
-- 
2.53.0



