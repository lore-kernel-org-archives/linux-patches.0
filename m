Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462E01E1A05;
	Mon, 12 May 2025 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072671; cv=none; b=okCVvzsxruANZmUoeUp4tUn7EFf8GUaKzdgPM+fj1/TE+7A6T0wXU+QSqRsc/NyWbGL2fMEHb6XjKqYKcfSLmKfXnjegVNnzRGpWoGEocKOFYlEzmFHxbqcQPAwrI+cz7ipHpQ/ErvIqWxA4OGXLrZ9ljaxrDp+NqmLaE+nviEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072671; c=relaxed/simple;
	bh=BRW7r9GrzoamJrKj/FJVLQuGA/e3Sf9AJ1bVJbwaC2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVjv/WJnOq3fO+7TAtaWfrLdL4nk+uGZhrQFq5xrRb1c7APm2jqsP7z4xHMfh1FQaj0g3L6/NuDA1lPAiQ3Q/dTlZqO7NCZdPpAVueshNjw1qzLdsq2jy1fcFlahp6jjr4f3zELL703z/Nl6criSVr9lFf2Blonr/cFFOojo4/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUFjGjz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUFjGjz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C9DC4CEE7;
	Mon, 12 May 2025 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072671;
	bh=BRW7r9GrzoamJrKj/FJVLQuGA/e3Sf9AJ1bVJbwaC2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUFjGjz4wPOKE07kG5bRGt3hWBzU7T8PJiPP5UOFNm28GvZoji9LnfTtxplRFM1K/
	 7h5XhopfTnwNhnKPEl/7f5ES2lCA1wbmL151BKUFZEnGDJUIbERz8fs2s7vfMIQitT
	 4sXkOiBMDFdXRJBdUCiBQh/UfGfk0LE8H5KuTOk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/184] virtio_net: xsk: bind/unbind xsk for tx
Date: Mon, 12 May 2025 19:43:41 +0200
Message-ID: <20250512172042.509704401@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 21a4e3ce6dc7b0a3bc882ebe1cb921a40235ddb0 ]

This patch implement the logic of bind/unbind xsk pool to sq and rq.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20241112012928.102478-10-xuanzhuo@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4397684a292a ("virtio-net: free xsk_buffs on error in virtnet_xsk_pool_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 53 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 60027b439021b..476c8a9cc494a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -298,6 +298,10 @@ struct send_queue {
 
 	/* Record whether sq is in reset state. */
 	bool reset;
+
+	struct xsk_buff_pool *xsk_pool;
+
+	dma_addr_t xsk_hdr_dma_addr;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -501,6 +505,8 @@ struct virtio_net_common_hdr {
 	};
 };
 
+static struct virtio_net_common_hdr xsk_hdr;
+
 static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
 static void virtnet_sq_free_unused_buf_done(struct virtqueue *vq);
 static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
@@ -5556,6 +5562,29 @@ static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queu
 	return err;
 }
 
+static int virtnet_sq_bind_xsk_pool(struct virtnet_info *vi,
+				    struct send_queue *sq,
+				    struct xsk_buff_pool *pool)
+{
+	int err, qindex;
+
+	qindex = sq - vi->sq;
+
+	virtnet_tx_pause(vi, sq);
+
+	err = virtqueue_reset(sq->vq, virtnet_sq_free_unused_buf);
+	if (err) {
+		netdev_err(vi->dev, "reset tx fail: tx queue index: %d err: %d\n", qindex, err);
+		pool = NULL;
+	}
+
+	sq->xsk_pool = pool;
+
+	virtnet_tx_resume(vi, sq);
+
+	return err;
+}
+
 static int virtnet_xsk_pool_enable(struct net_device *dev,
 				   struct xsk_buff_pool *pool,
 				   u16 qid)
@@ -5564,6 +5593,7 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 	struct receive_queue *rq;
 	struct device *dma_dev;
 	struct send_queue *sq;
+	dma_addr_t hdr_dma;
 	int err, size;
 
 	if (vi->hdr_len > xsk_pool_get_headroom(pool))
@@ -5601,6 +5631,11 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 	if (!rq->xsk_buffs)
 		return -ENOMEM;
 
+	hdr_dma = virtqueue_dma_map_single_attrs(sq->vq, &xsk_hdr, vi->hdr_len,
+						 DMA_TO_DEVICE, 0);
+	if (virtqueue_dma_mapping_error(sq->vq, hdr_dma))
+		return -ENOMEM;
+
 	err = xsk_pool_dma_map(pool, dma_dev, 0);
 	if (err)
 		goto err_xsk_map;
@@ -5609,11 +5644,24 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 	if (err)
 		goto err_rq;
 
+	err = virtnet_sq_bind_xsk_pool(vi, sq, pool);
+	if (err)
+		goto err_sq;
+
+	/* Now, we do not support tx offload(such as tx csum), so all the tx
+	 * virtnet hdr is zero. So all the tx packets can share a single hdr.
+	 */
+	sq->xsk_hdr_dma_addr = hdr_dma;
+
 	return 0;
 
+err_sq:
+	virtnet_rq_bind_xsk_pool(vi, rq, NULL);
 err_rq:
 	xsk_pool_dma_unmap(pool, 0);
 err_xsk_map:
+	virtqueue_dma_unmap_single_attrs(rq->vq, hdr_dma, vi->hdr_len,
+					 DMA_TO_DEVICE, 0);
 	return err;
 }
 
@@ -5622,19 +5670,24 @@ static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
 	struct virtnet_info *vi = netdev_priv(dev);
 	struct xsk_buff_pool *pool;
 	struct receive_queue *rq;
+	struct send_queue *sq;
 	int err;
 
 	if (qid >= vi->curr_queue_pairs)
 		return -EINVAL;
 
+	sq = &vi->sq[qid];
 	rq = &vi->rq[qid];
 
 	pool = rq->xsk_pool;
 
 	err = virtnet_rq_bind_xsk_pool(vi, rq, NULL);
+	err |= virtnet_sq_bind_xsk_pool(vi, sq, NULL);
 
 	xsk_pool_dma_unmap(pool, 0);
 
+	virtqueue_dma_unmap_single_attrs(sq->vq, sq->xsk_hdr_dma_addr,
+					 vi->hdr_len, DMA_TO_DEVICE, 0);
 	kvfree(rq->xsk_buffs);
 
 	return err;
-- 
2.39.5



