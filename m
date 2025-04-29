Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A042472B9;
	Tue, 29 Apr 2025 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945829; cv=none; b=H23ueVmkFGDF5ynXVRTFaQOz0dI66xH4exBQaKjQfI1QBqI6bnFFHIxEPD3IoVI5dIfKTGX/tq/fG9Kxuax+uGzM1AI5mawNMTHtunrP8rgf5MZSK6Ww1/dwGM+tDB+1qEWrm/0PLuRtudq4zbVyDE/JUs54g3P/fT2sNJM5tHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945829; c=relaxed/simple;
	bh=7hJqpmhpyD8boIXLfd5J4pBMCuoV0vxS4A9ebKX3f14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uX7QzeX4tPE+H5lCxlyVjmr2bH9RTrzO0r2lNFk5iLJDTn/IIFoS8WqHqZ5ChZmA+RO3f1irsg0hZx7m3DtdDAC86oYlJ+H7A88Pff1+f/Efww/w70+xSdc5Wm06Ar9EwE9ZlikYde73XP8YSd6uf+X9+x3jahbYcutpJ57aGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo2g5tCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo2g5tCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ABBC4CEE3;
	Tue, 29 Apr 2025 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945828;
	bh=7hJqpmhpyD8boIXLfd5J4pBMCuoV0vxS4A9ebKX3f14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo2g5tCwoxHJyDVdxbBLw4HtqDSwVytb8Kc6S1p8anDC85rWtj1hneAz7zsvp9gmu
	 hu8xy/xepNYvAVz8TQHPRWbf3gKnzHSskwWREsQEfU7Q+LlCYt6//cPpC2lkiIdKDY
	 f+WGIVZqUsduuEEJzLzyoSPgtDYnhZzTothPrQ78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 064/311] virtio-net: disable delayed refill when pausing rx
Date: Tue, 29 Apr 2025 18:38:21 +0200
Message-ID: <20250429161123.661836655@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 4bc12818b363bd30f0f7348dd9ab077290a637ae ]

When pausing rx (e.g. set up xdp, xsk pool, rx resize), we call
napi_disable() on the receive queue's napi. In delayed refill_work, it
also calls napi_disable() on the receive queue's napi.  When
napi_disable() is called on an already disabled napi, it will sleep in
napi_disable_locked while still holding the netdev_lock. As a result,
later napi_enable gets stuck too as it cannot acquire the netdev_lock.
This leads to refill_work and the pause-then-resume tx are stuck
altogether.

This scenario can be reproducible by binding a XDP socket to virtio-net
interface without setting up the fill ring. As a result, try_fill_recv
will fail until the fill ring is set up and refill_work is scheduled.

This commit adds virtnet_rx_(pause/resume)_all helpers and fixes up the
virtnet_rx_resume to disable future and cancel all inflights delayed
refill_work before calling napi_disable() to pause the rx.

Fixes: 413f0271f396 ("net: protect NAPI enablement with netdev_lock()")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250417072806.18660-2-minhquangbui99@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 69 +++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 44dbb991787ed..3e4896d9537ee 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3318,7 +3318,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static void virtnet_rx_pause(struct virtnet_info *vi, struct receive_queue *rq)
+static void __virtnet_rx_pause(struct virtnet_info *vi,
+			       struct receive_queue *rq)
 {
 	bool running = netif_running(vi->dev);
 
@@ -3328,17 +3329,63 @@ static void virtnet_rx_pause(struct virtnet_info *vi, struct receive_queue *rq)
 	}
 }
 
-static void virtnet_rx_resume(struct virtnet_info *vi, struct receive_queue *rq)
+static void virtnet_rx_pause_all(struct virtnet_info *vi)
+{
+	int i;
+
+	/*
+	 * Make sure refill_work does not run concurrently to
+	 * avoid napi_disable race which leads to deadlock.
+	 */
+	disable_delayed_refill(vi);
+	cancel_delayed_work_sync(&vi->refill);
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		__virtnet_rx_pause(vi, &vi->rq[i]);
+}
+
+static void virtnet_rx_pause(struct virtnet_info *vi, struct receive_queue *rq)
+{
+	/*
+	 * Make sure refill_work does not run concurrently to
+	 * avoid napi_disable race which leads to deadlock.
+	 */
+	disable_delayed_refill(vi);
+	cancel_delayed_work_sync(&vi->refill);
+	__virtnet_rx_pause(vi, rq);
+}
+
+static void __virtnet_rx_resume(struct virtnet_info *vi,
+				struct receive_queue *rq,
+				bool refill)
 {
 	bool running = netif_running(vi->dev);
 
-	if (!try_fill_recv(vi, rq, GFP_KERNEL))
+	if (refill && !try_fill_recv(vi, rq, GFP_KERNEL))
 		schedule_delayed_work(&vi->refill, 0);
 
 	if (running)
 		virtnet_napi_enable(rq);
 }
 
+static void virtnet_rx_resume_all(struct virtnet_info *vi)
+{
+	int i;
+
+	enable_delayed_refill(vi);
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		if (i < vi->curr_queue_pairs)
+			__virtnet_rx_resume(vi, &vi->rq[i], true);
+		else
+			__virtnet_rx_resume(vi, &vi->rq[i], false);
+	}
+}
+
+static void virtnet_rx_resume(struct virtnet_info *vi, struct receive_queue *rq)
+{
+	enable_delayed_refill(vi);
+	__virtnet_rx_resume(vi, rq, true);
+}
+
 static int virtnet_rx_resize(struct virtnet_info *vi,
 			     struct receive_queue *rq, u32 ring_num)
 {
@@ -5939,12 +5986,12 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	if (prog)
 		bpf_prog_add(prog, vi->max_queue_pairs - 1);
 
+	virtnet_rx_pause_all(vi);
+
 	/* Make sure NAPI is not using any XDP TX queues for RX. */
 	if (netif_running(dev)) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtnet_napi_disable(&vi->rq[i]);
+		for (i = 0; i < vi->max_queue_pairs; i++)
 			virtnet_napi_tx_disable(&vi->sq[i]);
-		}
 	}
 
 	if (!prog) {
@@ -5976,13 +6023,12 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		vi->xdp_enabled = false;
 	}
 
+	virtnet_rx_resume_all(vi);
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (old_prog)
 			bpf_prog_put(old_prog);
-		if (netif_running(dev)) {
-			virtnet_napi_enable(&vi->rq[i]);
+		if (netif_running(dev))
 			virtnet_napi_tx_enable(&vi->sq[i]);
-		}
 	}
 
 	return 0;
@@ -5994,11 +6040,10 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			rcu_assign_pointer(vi->rq[i].xdp_prog, old_prog);
 	}
 
+	virtnet_rx_resume_all(vi);
 	if (netif_running(dev)) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtnet_napi_enable(&vi->rq[i]);
+		for (i = 0; i < vi->max_queue_pairs; i++)
 			virtnet_napi_tx_enable(&vi->sq[i]);
-		}
 	}
 	if (prog)
 		bpf_prog_sub(prog, vi->max_queue_pairs - 1);
-- 
2.39.5



