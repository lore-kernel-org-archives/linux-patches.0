Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC3C44AB99;
	Tue, 21 Jul 2026 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669516; cv=none; b=aiD3j09gTlFQkP34/fbh5GLxuQuua5K7to30buNxKWMfOk2EzDkvEjbyqjBz/LTp8qvrweIqA+7LntbzXLM1ume98JHlVS4WeJUxj8QEgfoGCuCJDMEDd7Z2jn38P+53nDhJD+Q1RPTMHoGtghT8VrsFSrzALcpW8D2h4Vy3F0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669516; c=relaxed/simple;
	bh=YG2ID6lnCjiREuDkgFp3248rEvpgqX9cVU+EFqegr5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3eeP8IZX8HkeuUDeM5I1dRzFB4SiPCozDt3MQJBbf/vCR/O4eDopZnV7Plr5r/DHm/9fz53LH7BJX1KU6X1mOLYZmfiPkr58Hba/5P/xRicF9FExioxfztyl7K0Kb9nqdHnQHX97Jm2Kau8chtBkAWN2o/OskG25s6lzx6l8HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahtazTSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahtazTSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C611F000E9;
	Tue, 21 Jul 2026 21:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669515;
	bh=5Acw1kpYfX39pcvd6rKdrNWp6zhky7eTrSiRzwkbaPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahtazTSFaUaroT6+/ef0g7vFLraF1FUXmHVhvN+leoqwLdZUju9jWY/ceSJSXo9/h
	 xUmOidS9V2eThXXNg6Tm2TqQy6bQ0g256Fk4jXHtufvdAf1WftYVJ8RTtzjrjRms6e
	 v3idHdHLloSst5/pSW5sTZK3w7tpIW1LY+zYtkjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0584/1067] virtio_ring: introduce dma sync api for virtqueue
Date: Tue, 21 Jul 2026 17:19:45 +0200
Message-ID: <20260721152437.669216384@linuxfoundation.org>
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

[ Upstream commit 8bd2f71054bd0bc997833e9825143672eb7e2801 ]

These API has been introduced:

* virtqueue_dma_need_sync
* virtqueue_dma_sync_single_range_for_cpu
* virtqueue_dma_sync_single_range_for_device

These APIs can be used together with the premapped mechanism to sync the
DMA address.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Message-Id: <20230810123057.43407-12-xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 9e5ad06ea826 ("virtio-net: fix len check in receive_big()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 76 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  8 ++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 25c9ecae60aaaf..c0534f01b459a9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2995,4 +2995,80 @@ int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr)
 }
 EXPORT_SYMBOL_GPL(virtqueue_dma_mapping_error);
 
+/**
+ * virtqueue_dma_need_sync - check a dma address needs sync
+ * @_vq: the struct virtqueue we're talking about.
+ * @addr: DMA address
+ *
+ * Check if the dma address mapped by the virtqueue_dma_map_* APIs needs to be
+ * synchronized
+ *
+ * return bool
+ */
+bool virtqueue_dma_need_sync(struct virtqueue *_vq, dma_addr_t addr)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return false;
+
+	return dma_need_sync(vring_dma_dev(vq), addr);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_need_sync);
+
+/**
+ * virtqueue_dma_sync_single_range_for_cpu - dma sync for cpu
+ * @_vq: the struct virtqueue we're talking about.
+ * @addr: DMA address
+ * @offset: DMA address offset
+ * @size: buf size for sync
+ * @dir: DMA direction
+ *
+ * Before calling this function, use virtqueue_dma_need_sync() to confirm that
+ * the DMA address really needs to be synchronized
+ *
+ */
+void virtqueue_dma_sync_single_range_for_cpu(struct virtqueue *_vq,
+					     dma_addr_t addr,
+					     unsigned long offset, size_t size,
+					     enum dma_data_direction dir)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct device *dev = vring_dma_dev(vq);
+
+	if (!vq->use_dma_api)
+		return;
+
+	dma_sync_single_range_for_cpu(dev, addr, offset, size,
+				      DMA_BIDIRECTIONAL);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_sync_single_range_for_cpu);
+
+/**
+ * virtqueue_dma_sync_single_range_for_device - dma sync for device
+ * @_vq: the struct virtqueue we're talking about.
+ * @addr: DMA address
+ * @offset: DMA address offset
+ * @size: buf size for sync
+ * @dir: DMA direction
+ *
+ * Before calling this function, use virtqueue_dma_need_sync() to confirm that
+ * the DMA address really needs to be synchronized
+ */
+void virtqueue_dma_sync_single_range_for_device(struct virtqueue *_vq,
+						dma_addr_t addr,
+						unsigned long offset, size_t size,
+						enum dma_data_direction dir)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct device *dev = vring_dma_dev(vq);
+
+	if (!vq->use_dma_api)
+		return;
+
+	dma_sync_single_range_for_device(dev, addr, offset, size,
+					 DMA_BIDIRECTIONAL);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_sync_single_range_for_device);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b16e77ff2b3e56..82a29db54e7d17 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -216,4 +216,12 @@ void virtqueue_dma_unmap_single_attrs(struct virtqueue *_vq, dma_addr_t addr,
 				      size_t size, enum dma_data_direction dir,
 				      unsigned long attrs);
 int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr);
+
+bool virtqueue_dma_need_sync(struct virtqueue *_vq, dma_addr_t addr);
+void virtqueue_dma_sync_single_range_for_cpu(struct virtqueue *_vq, dma_addr_t addr,
+					     unsigned long offset, size_t size,
+					     enum dma_data_direction dir);
+void virtqueue_dma_sync_single_range_for_device(struct virtqueue *_vq, dma_addr_t addr,
+						unsigned long offset, size_t size,
+						enum dma_data_direction dir);
 #endif /* _LINUX_VIRTIO_H */
-- 
2.53.0



