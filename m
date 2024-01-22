Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2877636;
	Tue, 23 Jan 2024 02:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975538; cv=none; b=rldSTuWeXWuKDVWDefg8jHr7ySfkNtJuQTbDMRFwe+spcD+pvH334NQDso3se/EStNYWctVH9ohh6sv51YHrGj+SzYMCo/nV1U3YcDmpcFwZfpjwkFAAK/qDHzCtjV2uuBaK3uzTkElAJCWDUAfnMLMIzoF6R9Se547aam12e/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975538; c=relaxed/simple;
	bh=Kue3JzZ7Eo714S8mJK4yO5Ub2vJciOrmCt/TzDoVCrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuTPW2r+RaWih4MdYmf5eIkcMFei5aJPMsfMTM5pWv4i0j0FKUBNH1/e0NLhkY2Xo0ZYqnV43W9k9/m3v4cgWc0NDg9YXKA4C1lB2yFJjpuhTY029WalZu4nXJLXbSVkWfXy2C0RxqdVRgo0Mh7BM5ohliqe3xHc+5Tx4g2Jmj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWtxksdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWtxksdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D67DC433C7;
	Tue, 23 Jan 2024 02:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975538;
	bh=Kue3JzZ7Eo714S8mJK4yO5Ub2vJciOrmCt/TzDoVCrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWtxksdqDt/aXW/LyVSFluIwr2lvzZw1Du4HkXZY1QzY3pOlrtRcNFlfZnzhLWiii
	 w3tvf3q8r0zO1SquO1mQ5gmZ76tIyJ1pKKn4XVIG10Y9CaMHJjfFpShTF6JNUxjkkY
	 7XI2B/7TeKnBGNPCyIZTdyCG3vz3ZWZDrUzpf2CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 489/583] bus: mhi: ep: Use slab allocator where applicable
Date: Mon, 22 Jan 2024 15:59:00 -0800
Message-ID: <20240122235826.980765287@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

[ Upstream commit 62210a26cd4f8ad52683a71c0226dfe85de1144d ]

Use slab allocator for allocating the memory for objects used frequently
and are of fixed size. This reduces the overheard associated with
kmalloc().

Suggested-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20231018122812.47261-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: 327ec5f70609 ("PCI: epf-mhi: Fix the DMA data direction of dma_unmap_single()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 66 +++++++++++++++++++++++++++++----------
 include/linux/mhi_ep.h    |  3 ++
 2 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index e2513f5f47a6..517279600645 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -74,7 +74,7 @@ static int mhi_ep_send_completion_event(struct mhi_ep_cntrl *mhi_cntrl, struct m
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
 	if (!event)
 		return -ENOMEM;
 
@@ -83,7 +83,7 @@ static int mhi_ep_send_completion_event(struct mhi_ep_cntrl *mhi_cntrl, struct m
 	event->dword[1] = MHI_TRE_EV_DWORD1(ring->ch_id, MHI_PKT_TYPE_TX_EVENT);
 
 	ret = mhi_ep_send_event(mhi_cntrl, ring->er_index, event, MHI_TRE_DATA_GET_BEI(tre));
-	kfree(event);
+	kmem_cache_free(mhi_cntrl->ev_ring_el_cache, event);
 
 	return ret;
 }
@@ -93,7 +93,7 @@ int mhi_ep_send_state_change_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_stat
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
 	if (!event)
 		return -ENOMEM;
 
@@ -101,7 +101,7 @@ int mhi_ep_send_state_change_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_stat
 	event->dword[1] = MHI_SC_EV_DWORD1(MHI_PKT_TYPE_STATE_CHANGE_EVENT);
 
 	ret = mhi_ep_send_event(mhi_cntrl, 0, event, 0);
-	kfree(event);
+	kmem_cache_free(mhi_cntrl->ev_ring_el_cache, event);
 
 	return ret;
 }
@@ -111,7 +111,7 @@ int mhi_ep_send_ee_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_ee_type exec_e
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
 	if (!event)
 		return -ENOMEM;
 
@@ -119,7 +119,7 @@ int mhi_ep_send_ee_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_ee_type exec_e
 	event->dword[1] = MHI_SC_EV_DWORD1(MHI_PKT_TYPE_EE_EVENT);
 
 	ret = mhi_ep_send_event(mhi_cntrl, 0, event, 0);
-	kfree(event);
+	kmem_cache_free(mhi_cntrl->ev_ring_el_cache, event);
 
 	return ret;
 }
@@ -130,7 +130,7 @@ static int mhi_ep_send_cmd_comp_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_e
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
 	if (!event)
 		return -ENOMEM;
 
@@ -139,7 +139,7 @@ static int mhi_ep_send_cmd_comp_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_e
 	event->dword[1] = MHI_CC_EV_DWORD1(MHI_PKT_TYPE_CMD_COMPLETION_EVENT);
 
 	ret = mhi_ep_send_event(mhi_cntrl, 0, event, 0);
-	kfree(event);
+	kmem_cache_free(mhi_cntrl->ev_ring_el_cache, event);
 
 	return ret;
 }
@@ -451,7 +451,7 @@ static int mhi_ep_process_ch_ring(struct mhi_ep_ring *ring, struct mhi_ring_elem
 		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
 	} else {
 		/* UL channel */
-		result.buf_addr = kzalloc(len, GFP_KERNEL);
+		result.buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL | GFP_DMA);
 		if (!result.buf_addr)
 			return -ENOMEM;
 
@@ -459,7 +459,7 @@ static int mhi_ep_process_ch_ring(struct mhi_ep_ring *ring, struct mhi_ring_elem
 			ret = mhi_ep_read_channel(mhi_cntrl, ring, &result, len);
 			if (ret < 0) {
 				dev_err(&mhi_chan->mhi_dev->dev, "Failed to read channel\n");
-				kfree(result.buf_addr);
+				kmem_cache_free(mhi_cntrl->tre_buf_cache, result.buf_addr);
 				return ret;
 			}
 
@@ -471,7 +471,7 @@ static int mhi_ep_process_ch_ring(struct mhi_ep_ring *ring, struct mhi_ring_elem
 			/* Read until the ring becomes empty */
 		} while (!mhi_ep_queue_is_empty(mhi_chan->mhi_dev, DMA_TO_DEVICE));
 
-		kfree(result.buf_addr);
+		kmem_cache_free(mhi_cntrl->tre_buf_cache, result.buf_addr);
 	}
 
 	return 0;
@@ -780,14 +780,14 @@ static void mhi_ep_ch_ring_worker(struct work_struct *work)
 		if (ret) {
 			dev_err(dev, "Error updating write offset for ring\n");
 			mutex_unlock(&chan->lock);
-			kfree(itr);
+			kmem_cache_free(mhi_cntrl->ring_item_cache, itr);
 			continue;
 		}
 
 		/* Sanity check to make sure there are elements in the ring */
 		if (ring->rd_offset == ring->wr_offset) {
 			mutex_unlock(&chan->lock);
-			kfree(itr);
+			kmem_cache_free(mhi_cntrl->ring_item_cache, itr);
 			continue;
 		}
 
@@ -799,12 +799,12 @@ static void mhi_ep_ch_ring_worker(struct work_struct *work)
 			dev_err(dev, "Error processing ring for channel (%u): %d\n",
 				ring->ch_id, ret);
 			mutex_unlock(&chan->lock);
-			kfree(itr);
+			kmem_cache_free(mhi_cntrl->ring_item_cache, itr);
 			continue;
 		}
 
 		mutex_unlock(&chan->lock);
-		kfree(itr);
+		kmem_cache_free(mhi_cntrl->ring_item_cache, itr);
 	}
 }
 
@@ -860,7 +860,7 @@ static void mhi_ep_queue_channel_db(struct mhi_ep_cntrl *mhi_cntrl, unsigned lon
 		u32 ch_id = ch_idx + i;
 
 		ring = &mhi_cntrl->mhi_chan[ch_id].ring;
-		item = kzalloc(sizeof(*item), GFP_ATOMIC);
+		item = kmem_cache_zalloc(mhi_cntrl->ring_item_cache, GFP_ATOMIC);
 		if (!item)
 			return;
 
@@ -1407,6 +1407,29 @@ int mhi_ep_register_controller(struct mhi_ep_cntrl *mhi_cntrl,
 		goto err_free_ch;
 	}
 
+	mhi_cntrl->ev_ring_el_cache = kmem_cache_create("mhi_ep_event_ring_el",
+							sizeof(struct mhi_ring_element), 0,
+							SLAB_CACHE_DMA, NULL);
+	if (!mhi_cntrl->ev_ring_el_cache) {
+		ret = -ENOMEM;
+		goto err_free_cmd;
+	}
+
+	mhi_cntrl->tre_buf_cache = kmem_cache_create("mhi_ep_tre_buf", MHI_EP_DEFAULT_MTU, 0,
+						      SLAB_CACHE_DMA, NULL);
+	if (!mhi_cntrl->tre_buf_cache) {
+		ret = -ENOMEM;
+		goto err_destroy_ev_ring_el_cache;
+	}
+
+	mhi_cntrl->ring_item_cache = kmem_cache_create("mhi_ep_ring_item",
+							sizeof(struct mhi_ep_ring_item), 0,
+							0, NULL);
+	if (!mhi_cntrl->ev_ring_el_cache) {
+		ret = -ENOMEM;
+		goto err_destroy_tre_buf_cache;
+	}
+
 	INIT_WORK(&mhi_cntrl->state_work, mhi_ep_state_worker);
 	INIT_WORK(&mhi_cntrl->reset_work, mhi_ep_reset_worker);
 	INIT_WORK(&mhi_cntrl->cmd_ring_work, mhi_ep_cmd_ring_worker);
@@ -1415,7 +1438,7 @@ int mhi_ep_register_controller(struct mhi_ep_cntrl *mhi_cntrl,
 	mhi_cntrl->wq = alloc_workqueue("mhi_ep_wq", 0, 0);
 	if (!mhi_cntrl->wq) {
 		ret = -ENOMEM;
-		goto err_free_cmd;
+		goto err_destroy_ring_item_cache;
 	}
 
 	INIT_LIST_HEAD(&mhi_cntrl->st_transition_list);
@@ -1474,6 +1497,12 @@ int mhi_ep_register_controller(struct mhi_ep_cntrl *mhi_cntrl,
 	ida_free(&mhi_ep_cntrl_ida, mhi_cntrl->index);
 err_destroy_wq:
 	destroy_workqueue(mhi_cntrl->wq);
+err_destroy_ring_item_cache:
+	kmem_cache_destroy(mhi_cntrl->ring_item_cache);
+err_destroy_ev_ring_el_cache:
+	kmem_cache_destroy(mhi_cntrl->ev_ring_el_cache);
+err_destroy_tre_buf_cache:
+	kmem_cache_destroy(mhi_cntrl->tre_buf_cache);
 err_free_cmd:
 	kfree(mhi_cntrl->mhi_cmd);
 err_free_ch:
@@ -1495,6 +1524,9 @@ void mhi_ep_unregister_controller(struct mhi_ep_cntrl *mhi_cntrl)
 
 	free_irq(mhi_cntrl->irq, mhi_cntrl);
 
+	kmem_cache_destroy(mhi_cntrl->tre_buf_cache);
+	kmem_cache_destroy(mhi_cntrl->ev_ring_el_cache);
+	kmem_cache_destroy(mhi_cntrl->ring_item_cache);
 	kfree(mhi_cntrl->mhi_cmd);
 	kfree(mhi_cntrl->mhi_chan);
 
diff --git a/include/linux/mhi_ep.h b/include/linux/mhi_ep.h
index f198a8ac7ee7..ce85d42b685d 100644
--- a/include/linux/mhi_ep.h
+++ b/include/linux/mhi_ep.h
@@ -128,6 +128,9 @@ struct mhi_ep_cntrl {
 	struct work_struct reset_work;
 	struct work_struct cmd_ring_work;
 	struct work_struct ch_ring_work;
+	struct kmem_cache *ring_item_cache;
+	struct kmem_cache *ev_ring_el_cache;
+	struct kmem_cache *tre_buf_cache;
 
 	void (*raise_irq)(struct mhi_ep_cntrl *mhi_cntrl, u32 vector);
 	int (*alloc_map)(struct mhi_ep_cntrl *mhi_cntrl, u64 pci_addr, phys_addr_t *phys_ptr,
-- 
2.43.0



