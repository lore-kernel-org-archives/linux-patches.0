Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F66E1F8ACE;
	Tue, 17 Dec 2024 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456412; cv=none; b=qP5SJrmGA8btO0JHYGDNQ4g+rlna0DOuG4srQfzjwI4ulvfpZ8ntA8JU6fibHBwTMpQ2vot/a/+5aixg3Ph6aWpSeUGbWbVPbAsE80SBkjqmYdge04br1lGcSwqwCHWhkI+ejTIOjUPkhRkfaKd+z5L0MofqUOIhTn/52UwK9Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456412; c=relaxed/simple;
	bh=w2VYmqVQJIkPS1I/+C1TmKdEetm26WY5AI4q85iFVUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ziar4tiQjCImK7zrTy05C3xwfUwi0l5VJQvU7a9ylY/+/YU0huotmrAJvvdnb+FaGtbT3/GCP4qEb1ud3iGgDUTrtnyZE8QJct06lR0VPfynHownP05Llt3otL/vxORJnLyyi1HyzOwHBkvF4h2XwOZQXPMGcO9UdWic5LVCblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcBXxL7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcBXxL7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BF0C4CED3;
	Tue, 17 Dec 2024 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456412;
	bh=w2VYmqVQJIkPS1I/+C1TmKdEetm26WY5AI4q85iFVUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcBXxL7cY3v9M/ZauLZ9xbFd60oNDK9vPClZQnhIg0rD3HWOA1DKXjhIwQr86geFy
	 ZXjaj0fxQSJbZuv5fYXgFCnfWm6JmLKWn7CRTm7aP3mh68kxtKRo4QLJdA439aoY2B
	 KnKLxuOrUVtmDGlbambJiJwj+6NTzatwpiWg608Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 012/172] virtio_ring: add a func argument recycle_done to virtqueue_resize()
Date: Tue, 17 Dec 2024 18:06:08 +0100
Message-ID: <20241217170546.758116437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

commit 8d6712c892019b9b9dc5c7039edd3c9d770b510b upstream.

When virtqueue_resize() has actually recycled all unused buffers,
additional work may be required in some cases. Relying solely on its
return status is fragile, so introduce a new function argument
'recycle_done', which is invoked when the recycle really occurs.

Cc: <stable@vger.kernel.org> # v6.11+
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c     |    4 ++--
 drivers/virtio/virtio_ring.c |    6 +++++-
 include/linux/virtio.h       |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3165,7 +3165,7 @@ static int virtnet_rx_resize(struct virt
 
 	virtnet_rx_pause(vi, rq);
 
-	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_unmap_free_buf);
+	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_unmap_free_buf, NULL);
 	if (err)
 		netdev_err(vi->dev, "resize rx fail: rx queue index: %d err: %d\n", qindex, err);
 
@@ -3228,7 +3228,7 @@ static int virtnet_tx_resize(struct virt
 
 	virtnet_tx_pause(vi, sq);
 
-	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
+	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf, NULL);
 	if (err)
 		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qindex, err);
 
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2716,6 +2716,7 @@ EXPORT_SYMBOL_GPL(vring_create_virtqueue
  * @_vq: the struct virtqueue we're talking about.
  * @num: new ring num
  * @recycle: callback to recycle unused buffers
+ * @recycle_done: callback to be invoked when recycle for all unused buffers done
  *
  * When it is really necessary to create a new vring, it will set the current vq
  * into the reset state. Then call the passed callback to recycle the buffer
@@ -2736,7 +2737,8 @@ EXPORT_SYMBOL_GPL(vring_create_virtqueue
  *
  */
 int virtqueue_resize(struct virtqueue *_vq, u32 num,
-		     void (*recycle)(struct virtqueue *vq, void *buf))
+		     void (*recycle)(struct virtqueue *vq, void *buf),
+		     void (*recycle_done)(struct virtqueue *vq))
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	int err;
@@ -2753,6 +2755,8 @@ int virtqueue_resize(struct virtqueue *_
 	err = virtqueue_disable_and_recycle(_vq, recycle);
 	if (err)
 		return err;
+	if (recycle_done)
+		recycle_done(_vq);
 
 	if (vq->packed_ring)
 		err = virtqueue_resize_packed(_vq, num);
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -100,7 +100,8 @@ dma_addr_t virtqueue_get_avail_addr(cons
 dma_addr_t virtqueue_get_used_addr(const struct virtqueue *vq);
 
 int virtqueue_resize(struct virtqueue *vq, u32 num,
-		     void (*recycle)(struct virtqueue *vq, void *buf));
+		     void (*recycle)(struct virtqueue *vq, void *buf),
+		     void (*recycle_done)(struct virtqueue *vq));
 int virtqueue_reset(struct virtqueue *vq,
 		    void (*recycle)(struct virtqueue *vq, void *buf));
 


