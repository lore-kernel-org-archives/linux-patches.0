Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6A1A76B2;
	Tue, 30 Jul 2024 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360473; cv=none; b=IGod4oate7/yhybrGpEAGd/GbXgr31pD6jvIt7OgisHAjCGQxyp1sII0jqteic5vrqiwKz+OVPRHEAqkNg8JAA0lOKnfMigRsi3uuOxGvA5X24JpFv26p1fyReZkMiL+BHejX/6ibpBy38wvU2sku6UfpmjPBIn/Dor8+hwSHcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360473; c=relaxed/simple;
	bh=FCDzv6gG2LWcvJQdfAU2jfktIbQbL4j1F76bqDZlvDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhvzXEKdnQbfLnq02C+v/MZ0EXp3SziVT4S0I/sCD4Kb1NNdF57HH5uj36HfeFZNhn4IeosQ5lmQA8iXjPyfq/6CWsuy4fypCbeyp+n0HYLbkwNKR2YfEvdeGGcF9MYU/3y+D8xzh448NDamhNmParbi9lKlQ7wmFcCr0bPpiPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1OZbhgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1OZbhgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BED0C32782;
	Tue, 30 Jul 2024 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360473;
	bh=FCDzv6gG2LWcvJQdfAU2jfktIbQbL4j1F76bqDZlvDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1OZbhgOPiqqu/9wBQcl4UO6VrUN6Ac4yoIrhh5Xl6mrMGew7VNYU5vod+16qSa69
	 Dy6B+GwSE7YTbmPZKJ5+yEYiHtoltoHV2gdXZDF7fV0oO8FdLWbxRUn34VK6rSiZOJ
	 /CDntODCk1FF3cwmAL9SAHJ7RdGIgJqvtUGqvGqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mayank Rana <quic_mrana@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.10 710/809] bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone
Date: Tue, 30 Jul 2024 17:49:46 +0200
Message-ID: <20240730151752.973701826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit c7d0b2db5bc5e8c0fdc67b3c8f463c3dfec92f77 upstream.

MHI endpoint stack accidentally started allocating memory for objects from
DMA zone since commit 62210a26cd4f ("bus: mhi: ep: Use slab allocator
where applicable"). But there is no real need to allocate memory from this
naturally limited DMA zone. This also causes the MHI endpoint stack to run
out of memory while doing high bandwidth transfers.

So let's switch over to normal memory.

Cc: <stable@vger.kernel.org> # 6.8
Fixes: 62210a26cd4f ("bus: mhi: ep: Use slab allocator where applicable")
Reviewed-by: Mayank Rana <quic_mrana@quicinc.com>
Link: https://lore.kernel.org/r/20240603164354.79035-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/main.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -90,7 +90,7 @@ static int mhi_ep_send_completion_event(
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -109,7 +109,7 @@ int mhi_ep_send_state_change_event(struc
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -127,7 +127,7 @@ int mhi_ep_send_ee_event(struct mhi_ep_c
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -146,7 +146,7 @@ static int mhi_ep_send_cmd_comp_event(st
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -438,7 +438,7 @@ static int mhi_ep_read_channel(struct mh
 		read_offset = mhi_chan->tre_size - mhi_chan->tre_bytes_left;
 		write_offset = len - buf_left;
 
-		buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL | GFP_DMA);
+		buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL);
 		if (!buf_addr)
 			return -ENOMEM;
 
@@ -1481,14 +1481,14 @@ int mhi_ep_register_controller(struct mh
 
 	mhi_cntrl->ev_ring_el_cache = kmem_cache_create("mhi_ep_event_ring_el",
 							sizeof(struct mhi_ring_element), 0,
-							SLAB_CACHE_DMA, NULL);
+							0, NULL);
 	if (!mhi_cntrl->ev_ring_el_cache) {
 		ret = -ENOMEM;
 		goto err_free_cmd;
 	}
 
 	mhi_cntrl->tre_buf_cache = kmem_cache_create("mhi_ep_tre_buf", MHI_EP_DEFAULT_MTU, 0,
-						      SLAB_CACHE_DMA, NULL);
+						      0, NULL);
 	if (!mhi_cntrl->tre_buf_cache) {
 		ret = -ENOMEM;
 		goto err_destroy_ev_ring_el_cache;


