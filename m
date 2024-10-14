Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D4A1A28C;
	Mon, 14 Oct 2024 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916625; cv=none; b=QcSqpHAh3bOYXm/XoTw/hu2lWhwlWBmHhWgdNASc4XtY+u88kbFTJTFQetfWZ5eeNq9JvN10symI+rUETObuySDTCuILQDQfWpegv+lkU7U7gXzKz5leVuTicb7kT3ZmW8kKUfxVjBrOB5FvIWfHpfl6r2PLaUBFnqo6MTZs/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916625; c=relaxed/simple;
	bh=R2lhpZeuJPWfq5mrSNv+1fUFdaUIZlUp7F9VTFrzt70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+evaEAIGyRZggN4pIE8gpmyBgYuZBTFL2J6EI3D782X2K7l2p1WKUp8U2yXwUUcxR2mVXZbvDqpOWv1Z7k8OXauN94dTy6m3JQN32z0eyK73f/RmZ0iAO/YuKb4oWWeDHbj82XPV2HJNExsqA/WGPXLhvURu4UK6rGcPJLnDh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0F5L6s5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0F5L6s5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6573C4CEC3;
	Mon, 14 Oct 2024 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916625;
	bh=R2lhpZeuJPWfq5mrSNv+1fUFdaUIZlUp7F9VTFrzt70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0F5L6s5VruSvy7PlxQisEfXvt69mdLYrtqvdWxtEGgMHFWHlLt+V84D18Kj6/9ulh
	 V9qxvT29UlV6K4Patl/mP1bAANA1ueSOGiyowTQR/cpd4o8k+eO2DsFnKUqaFDhBfb
	 HEKM3HaYYiC6p4c1xiD78eD2XUdxEhedIjV0Y2gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/213] bus: mhi: ep: Add support for async DMA read operation
Date: Mon, 14 Oct 2024 16:18:46 +0200
Message-ID: <20241014141043.774413374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 2547beb00ddb40e55b773970622421d978f71473 ]

As like the async DMA write operation, let's add support for async DMA read
operation. In the async path, the data will be read from the transfer ring
continuously and when the controller driver notifies the stack using the
completion callback (mhi_ep_read_completion), then the client driver will
be notified with the read data and the completion event will be sent to the
host for the respective ring element (if requested by the host).

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c7d0b2db5bc5 ("bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 162 +++++++++++++++++++++-----------------
 1 file changed, 89 insertions(+), 73 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 8765a7fb3d2c0..2cb7e21ad3b74 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -318,17 +318,81 @@ bool mhi_ep_queue_is_empty(struct mhi_ep_device *mhi_dev, enum dma_data_directio
 }
 EXPORT_SYMBOL_GPL(mhi_ep_queue_is_empty);
 
+static void mhi_ep_read_completion(struct mhi_ep_buf_info *buf_info)
+{
+	struct mhi_ep_device *mhi_dev = buf_info->mhi_dev;
+	struct mhi_ep_cntrl *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_ep_chan *mhi_chan = mhi_dev->ul_chan;
+	struct mhi_ep_ring *ring = &mhi_cntrl->mhi_chan[mhi_chan->chan].ring;
+	struct mhi_ring_element *el = &ring->ring_cache[ring->rd_offset];
+	struct mhi_result result = {};
+	int ret;
+
+	if (mhi_chan->xfer_cb) {
+		result.buf_addr = buf_info->cb_buf;
+		result.dir = mhi_chan->dir;
+		result.bytes_xferd = buf_info->size;
+
+		mhi_chan->xfer_cb(mhi_dev, &result);
+	}
+
+	/*
+	 * The host will split the data packet into multiple TREs if it can't fit
+	 * the packet in a single TRE. In that case, CHAIN flag will be set by the
+	 * host for all TREs except the last one.
+	 */
+	if (buf_info->code != MHI_EV_CC_OVERFLOW) {
+		if (MHI_TRE_DATA_GET_CHAIN(el)) {
+			/*
+			 * IEOB (Interrupt on End of Block) flag will be set by the host if
+			 * it expects the completion event for all TREs of a TD.
+			 */
+			if (MHI_TRE_DATA_GET_IEOB(el)) {
+				ret = mhi_ep_send_completion_event(mhi_cntrl, ring, el,
+							     MHI_TRE_DATA_GET_LEN(el),
+							     MHI_EV_CC_EOB);
+				if (ret < 0) {
+					dev_err(&mhi_chan->mhi_dev->dev,
+						"Error sending transfer compl. event\n");
+					goto err_free_tre_buf;
+				}
+			}
+		} else {
+			/*
+			 * IEOT (Interrupt on End of Transfer) flag will be set by the host
+			 * for the last TRE of the TD and expects the completion event for
+			 * the same.
+			 */
+			if (MHI_TRE_DATA_GET_IEOT(el)) {
+				ret = mhi_ep_send_completion_event(mhi_cntrl, ring, el,
+							     MHI_TRE_DATA_GET_LEN(el),
+							     MHI_EV_CC_EOT);
+				if (ret < 0) {
+					dev_err(&mhi_chan->mhi_dev->dev,
+						"Error sending transfer compl. event\n");
+					goto err_free_tre_buf;
+				}
+			}
+		}
+	}
+
+	mhi_ep_ring_inc_index(ring);
+
+err_free_tre_buf:
+	kmem_cache_free(mhi_cntrl->tre_buf_cache, buf_info->cb_buf);
+}
+
 static int mhi_ep_read_channel(struct mhi_ep_cntrl *mhi_cntrl,
-				struct mhi_ep_ring *ring,
-				struct mhi_result *result,
-				u32 len)
+			       struct mhi_ep_ring *ring)
 {
 	struct mhi_ep_chan *mhi_chan = &mhi_cntrl->mhi_chan[ring->ch_id];
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	size_t tr_len, read_offset, write_offset;
 	struct mhi_ep_buf_info buf_info = {};
+	u32 len = MHI_EP_DEFAULT_MTU;
 	struct mhi_ring_element *el;
 	bool tr_done = false;
+	void *buf_addr;
 	u32 buf_left;
 	int ret;
 
@@ -358,83 +422,50 @@ static int mhi_ep_read_channel(struct mhi_ep_cntrl *mhi_cntrl,
 		read_offset = mhi_chan->tre_size - mhi_chan->tre_bytes_left;
 		write_offset = len - buf_left;
 
+		buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL | GFP_DMA);
+		if (!buf_addr)
+			return -ENOMEM;
+
 		buf_info.host_addr = mhi_chan->tre_loc + read_offset;
-		buf_info.dev_addr = result->buf_addr + write_offset;
+		buf_info.dev_addr = buf_addr + write_offset;
 		buf_info.size = tr_len;
+		buf_info.cb = mhi_ep_read_completion;
+		buf_info.cb_buf = buf_addr;
+		buf_info.mhi_dev = mhi_chan->mhi_dev;
+
+		if (mhi_chan->tre_bytes_left - tr_len)
+			buf_info.code = MHI_EV_CC_OVERFLOW;
 
 		dev_dbg(dev, "Reading %zd bytes from channel (%u)\n", tr_len, ring->ch_id);
-		ret = mhi_cntrl->read_sync(mhi_cntrl, &buf_info);
+		ret = mhi_cntrl->read_async(mhi_cntrl, &buf_info);
 		if (ret < 0) {
 			dev_err(&mhi_chan->mhi_dev->dev, "Error reading from channel\n");
-			return ret;
+			goto err_free_buf_addr;
 		}
 
 		buf_left -= tr_len;
 		mhi_chan->tre_bytes_left -= tr_len;
 
-		/*
-		 * Once the TRE (Transfer Ring Element) of a TD (Transfer Descriptor) has been
-		 * read completely:
-		 *
-		 * 1. Send completion event to the host based on the flags set in TRE.
-		 * 2. Increment the local read offset of the transfer ring.
-		 */
 		if (!mhi_chan->tre_bytes_left) {
-			/*
-			 * The host will split the data packet into multiple TREs if it can't fit
-			 * the packet in a single TRE. In that case, CHAIN flag will be set by the
-			 * host for all TREs except the last one.
-			 */
-			if (MHI_TRE_DATA_GET_CHAIN(el)) {
-				/*
-				 * IEOB (Interrupt on End of Block) flag will be set by the host if
-				 * it expects the completion event for all TREs of a TD.
-				 */
-				if (MHI_TRE_DATA_GET_IEOB(el)) {
-					ret = mhi_ep_send_completion_event(mhi_cntrl, ring, el,
-								     MHI_TRE_DATA_GET_LEN(el),
-								     MHI_EV_CC_EOB);
-					if (ret < 0) {
-						dev_err(&mhi_chan->mhi_dev->dev,
-							"Error sending transfer compl. event\n");
-						return ret;
-					}
-				}
-			} else {
-				/*
-				 * IEOT (Interrupt on End of Transfer) flag will be set by the host
-				 * for the last TRE of the TD and expects the completion event for
-				 * the same.
-				 */
-				if (MHI_TRE_DATA_GET_IEOT(el)) {
-					ret = mhi_ep_send_completion_event(mhi_cntrl, ring, el,
-								     MHI_TRE_DATA_GET_LEN(el),
-								     MHI_EV_CC_EOT);
-					if (ret < 0) {
-						dev_err(&mhi_chan->mhi_dev->dev,
-							"Error sending transfer compl. event\n");
-						return ret;
-					}
-				}
-
+			if (MHI_TRE_DATA_GET_IEOT(el))
 				tr_done = true;
-			}
 
 			mhi_chan->rd_offset = (mhi_chan->rd_offset + 1) % ring->ring_size;
-			mhi_ep_ring_inc_index(ring);
 		}
-
-		result->bytes_xferd += tr_len;
 	} while (buf_left && !tr_done);
 
 	return 0;
+
+err_free_buf_addr:
+	kmem_cache_free(mhi_cntrl->tre_buf_cache, buf_addr);
+
+	return ret;
 }
 
-static int mhi_ep_process_ch_ring(struct mhi_ep_ring *ring, struct mhi_ring_element *el)
+static int mhi_ep_process_ch_ring(struct mhi_ep_ring *ring)
 {
 	struct mhi_ep_cntrl *mhi_cntrl = ring->mhi_cntrl;
 	struct mhi_result result = {};
-	u32 len = MHI_EP_DEFAULT_MTU;
 	struct mhi_ep_chan *mhi_chan;
 	int ret;
 
@@ -455,27 +486,15 @@ static int mhi_ep_process_ch_ring(struct mhi_ep_ring *ring, struct mhi_ring_elem
 		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
 	} else {
 		/* UL channel */
-		result.buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL | GFP_DMA);
-		if (!result.buf_addr)
-			return -ENOMEM;
-
 		do {
-			ret = mhi_ep_read_channel(mhi_cntrl, ring, &result, len);
+			ret = mhi_ep_read_channel(mhi_cntrl, ring);
 			if (ret < 0) {
 				dev_err(&mhi_chan->mhi_dev->dev, "Failed to read channel\n");
-				kmem_cache_free(mhi_cntrl->tre_buf_cache, result.buf_addr);
 				return ret;
 			}
 
-			result.dir = mhi_chan->dir;
-			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
-			result.bytes_xferd = 0;
-			memset(result.buf_addr, 0, len);
-
 			/* Read until the ring becomes empty */
 		} while (!mhi_ep_queue_is_empty(mhi_chan->mhi_dev, DMA_TO_DEVICE));
-
-		kmem_cache_free(mhi_cntrl->tre_buf_cache, result.buf_addr);
 	}
 
 	return 0;
@@ -781,7 +800,6 @@ static void mhi_ep_ch_ring_worker(struct work_struct *work)
 	struct mhi_ep_cntrl *mhi_cntrl = container_of(work, struct mhi_ep_cntrl, ch_ring_work);
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	struct mhi_ep_ring_item *itr, *tmp;
-	struct mhi_ring_element *el;
 	struct mhi_ep_ring *ring;
 	struct mhi_ep_chan *chan;
 	unsigned long flags;
@@ -826,10 +844,8 @@ static void mhi_ep_ch_ring_worker(struct work_struct *work)
 			continue;
 		}
 
-		el = &ring->ring_cache[ring->rd_offset];
-
 		dev_dbg(dev, "Processing the ring for channel (%u)\n", ring->ch_id);
-		ret = mhi_ep_process_ch_ring(ring, el);
+		ret = mhi_ep_process_ch_ring(ring);
 		if (ret) {
 			dev_err(dev, "Error processing ring for channel (%u): %d\n",
 				ring->ch_id, ret);
-- 
2.43.0



