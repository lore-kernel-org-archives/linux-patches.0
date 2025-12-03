Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5509935E554;
	Wed,  3 Dec 2025 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780665; cv=none; b=MaMCuEZdzPSgKBfT1CCqoCVGnikKJTAEdXer5JoZX6QOUu1BuBtQjpZ8O4gvZGvERo9129CEzAv5y8ScoOj/b9hVdclOe35v2ZmzHinKgA2XQrMC+7dYxBbCvGN4PtHYn0MKeBotroK4Aw1pKCVe/tT7TTB4oreKKm8satnqX6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780665; c=relaxed/simple;
	bh=toPIEmPNOCXO6T4TXIsQv1jthlqibTG5Ra1Z7D5pt7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NskudtyOYeekKITya8JqiNIj+xtF7pP4FMn8i6MTFIFqKY78tadxgWxgCLWKhiSGfzumT2iJh+yKjmPiyH2Vfg+glJX3xnMZImEeydFBXQGdzAeEb/Axnv69LQyUQLnMESjC7NzDvy8exUjUe3Ge6caZZX0wBh7V0nROkgdRAbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcuZgMyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcuZgMyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9D8C4CEF5;
	Wed,  3 Dec 2025 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780665;
	bh=toPIEmPNOCXO6T4TXIsQv1jthlqibTG5Ra1Z7D5pt7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcuZgMyLvot6RgmmIzuJj2sim3KV1D55Bk/fjfQgP08tPq+fApc/1riFqynIWs1Y5
	 99O1zfrASI3dBG8eye9vc/IRTOY57vNt2TAAyNC0r05P+e63uIduLhE4cUstqNdgLI
	 n3K1bnNKN5oYihpkkP1F6ZTt3wLeXCOtdsWrFgYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 053/132] iio: buffer: support getting dma channel from the buffer
Date: Wed,  3 Dec 2025 16:28:52 +0100
Message-ID: <20251203152345.260799014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit a514bb109eada64f798f1c86c17182229cc20fe7 upstream.

Add a new buffer accessor .get_dma_dev() in order to get the
struct device responsible for actually providing the dma channel. We
cannot assume that we can use the parent of the IIO device for mapping
the DMA buffer. This becomes important on systems (like the Xilinx/AMD
zynqMP Ultrascale) where memory (or part of it) is mapped above the
32 bit range. On such systems and given that a device by default has
a dma mask of 32 bits we would then need to rely on bounce buffers (to
swiotlb) for mapping memory above the dma mask limit.

In the process, add an iio_buffer_get_dma_dev() helper function to get
the proper DMA device.

Cc: stable@vger.kernel.org
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   21 ++++++++++++++++-----
 include/linux/iio/buffer_impl.h   |    2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1623,19 +1623,28 @@ static int iio_dma_resv_lock(struct dma_
 	return 0;
 }
 
+static struct device *iio_buffer_get_dma_dev(const struct iio_dev *indio_dev,
+					     struct iio_buffer *buffer)
+{
+	if (buffer->access->get_dma_dev)
+		return buffer->access->get_dma_dev(buffer);
+
+	return indio_dev->dev.parent;
+}
+
 static struct dma_buf_attachment *
 iio_buffer_find_attachment(struct iio_dev_buffer_pair *ib,
 			   struct dma_buf *dmabuf, bool nonblock)
 {
-	struct device *dev = ib->indio_dev->dev.parent;
 	struct iio_buffer *buffer = ib->buffer;
+	struct device *dma_dev = iio_buffer_get_dma_dev(ib->indio_dev, buffer);
 	struct dma_buf_attachment *attach = NULL;
 	struct iio_dmabuf_priv *priv;
 
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dev
+		if (priv->attach->dev == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			attach = priv->attach;
 			break;
@@ -1653,6 +1662,7 @@ static int iio_buffer_attach_dmabuf(stru
 {
 	struct iio_dev *indio_dev = ib->indio_dev;
 	struct iio_buffer *buffer = ib->buffer;
+	struct device *dma_dev = iio_buffer_get_dma_dev(indio_dev, buffer);
 	struct dma_buf_attachment *attach;
 	struct iio_dmabuf_priv *priv, *each;
 	struct dma_buf *dmabuf;
@@ -1679,7 +1689,7 @@ static int iio_buffer_attach_dmabuf(stru
 		goto err_free_priv;
 	}
 
-	attach = dma_buf_attach(dmabuf, indio_dev->dev.parent);
+	attach = dma_buf_attach(dmabuf, dma_dev);
 	if (IS_ERR(attach)) {
 		err = PTR_ERR(attach);
 		goto err_dmabuf_put;
@@ -1719,7 +1729,7 @@ static int iio_buffer_attach_dmabuf(stru
 	 * combo. If we do, refuse to attach.
 	 */
 	list_for_each_entry(each, &buffer->dmabufs, entry) {
-		if (each->attach->dev == indio_dev->dev.parent
+		if (each->attach->dev == dma_dev
 		    && each->attach->dmabuf == dmabuf) {
 			/*
 			 * We unlocked the reservation object, so going through
@@ -1758,6 +1768,7 @@ static int iio_buffer_detach_dmabuf(stru
 {
 	struct iio_buffer *buffer = ib->buffer;
 	struct iio_dev *indio_dev = ib->indio_dev;
+	struct device *dma_dev = iio_buffer_get_dma_dev(indio_dev, buffer);
 	struct iio_dmabuf_priv *priv;
 	struct dma_buf *dmabuf;
 	int dmabuf_fd, ret = -EPERM;
@@ -1772,7 +1783,7 @@ static int iio_buffer_detach_dmabuf(stru
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == indio_dev->dev.parent
+		if (priv->attach->dev == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			list_del(&priv->entry);
 
--- a/include/linux/iio/buffer_impl.h
+++ b/include/linux/iio/buffer_impl.h
@@ -50,6 +50,7 @@ struct sg_table;
  * @enqueue_dmabuf:	called from userspace via ioctl to queue this DMABUF
  *			object to this buffer. Requires a valid DMABUF fd, that
  *			was previouly attached to this buffer.
+ * @get_dma_dev:	called to get the DMA channel associated with this buffer.
  * @lock_queue:		called when the core needs to lock the buffer queue;
  *                      it is used when enqueueing DMABUF objects.
  * @unlock_queue:       used to unlock a previously locked buffer queue
@@ -90,6 +91,7 @@ struct iio_buffer_access_funcs {
 			      struct iio_dma_buffer_block *block,
 			      struct dma_fence *fence, struct sg_table *sgt,
 			      size_t size, bool cyclic);
+	struct device * (*get_dma_dev)(struct iio_buffer *buffer);
 	void (*lock_queue)(struct iio_buffer *buffer);
 	void (*unlock_queue)(struct iio_buffer *buffer);
 


