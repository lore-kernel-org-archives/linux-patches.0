Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F4C38A9D9;
	Wed, 21 Jan 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020380; cv=none; b=MgeEqskI8ksd0VaWgApqBWda8hORkFzvD/xAvQCEtJGfccV//TZeVGDIl2YdO44LPtNG50Ps606IS533MtOqN8/JoRpPNlWZAF6+h4+i6gOEbr9JhB8+vuUgZpILKCU41nwaYNmPYkATKIWA7B3T/EwuuUFnIJqeICGDlMw/Ias=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020380; c=relaxed/simple;
	bh=V6RwI8uhsYIit/B7CvStqZ22g0E6Gh7/COYE9B766E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iio4ztaqXs7GwQBd7rdvadbbZ+wVpXC7rEHJg9XbiREniahYesUHUJB48hvrmGPPNPAHmaThGomtMe7L4UAX0AolNHk1J3SjNfXeVKSSe3ECVVnpHM9zMkkdwhD4HZ9xJa93gu+r18Y2HCB+bULa0oJOXyKFcWDVX09pNBmsYdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNi3c8s+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNi3c8s+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B272EC4CEF1;
	Wed, 21 Jan 2026 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020380;
	bh=V6RwI8uhsYIit/B7CvStqZ22g0E6Gh7/COYE9B766E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNi3c8s+8dahjlXSIgMdVrNGGXf/ovz7ElGSpSBfGLDbtvVlkn71K3M+NzXYysOAk
	 +2IS62evbNk3Tf+TGsLmVrsHjwX6ECVr3jtc6mdsMqgPNDuRnK5lGt/2wdolbkqmjw
	 ZnBunPXzWc4Yq/fAfgrbXdI4Syo8uPGEOKUinzBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 107/198] virtio-net: dont schedule delayed refill worker
Date: Wed, 21 Jan 2026 19:15:35 +0100
Message-ID: <20260121181422.403532917@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit fcdef3bcbb2c04e06ae89f8faff2cd6416b3a467 upstream.

When we fail to refill the receive buffers, we schedule a delayed worker
to retry later. However, this worker creates some concurrency issues.
For example, when the worker runs concurrently with virtnet_xdp_set,
both need to temporarily disable queue's NAPI before enabling again.
Without proper synchronization, a deadlock can happen when
napi_disable() is called on an already disabled NAPI. That
napi_disable() call will be stuck and so will the subsequent
napi_enable() call.

To simplify the logic and avoid further problems, we will instead retry
refilling in the next NAPI poll.

Fixes: 4bc12818b363 ("virtio-net: disable delayed refill when pausing rx")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Closes: https://lore.kernel.org/526b5396-459d-4d02-8635-a222d07b46d7@redhat.com
Cc: stable@vger.kernel.org
Suggested-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260106150438.7425-2-minhquangbui99@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3037,16 +3037,16 @@ static int virtnet_receive(struct receiv
 	else
 		packets = virtnet_receive_packets(vi, rq, budget, xdp_xmit, &stats);
 
+	u64_stats_set(&stats.packets, packets);
 	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
-		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
-			spin_lock(&vi->refill_lock);
-			if (vi->refill_enabled)
-				schedule_delayed_work(&vi->refill, 0);
-			spin_unlock(&vi->refill_lock);
-		}
+		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
+			/* We need to retry refilling in the next NAPI poll so
+			 * we must return budget to make sure the NAPI is
+			 * repolled.
+			 */
+			packets = budget;
 	}
 
-	u64_stats_set(&stats.packets, packets);
 	u64_stats_update_begin(&rq->stats.syncp);
 	for (i = 0; i < ARRAY_SIZE(virtnet_rq_stats_desc); i++) {
 		size_t offset = virtnet_rq_stats_desc[i].offset;
@@ -3226,9 +3226,10 @@ static int virtnet_open(struct net_devic
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (i < vi->curr_queue_pairs)
-			/* Make sure we have some buffers: if oom use wq. */
-			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
-				schedule_delayed_work(&vi->refill, 0);
+			/* Pre-fill rq agressively, to make sure we are ready to
+			 * get packets immediately.
+			 */
+			try_fill_recv(vi, &vi->rq[i], GFP_KERNEL);
 
 		err = virtnet_enable_queue_pair(vi, i);
 		if (err < 0)
@@ -3473,16 +3474,15 @@ static void __virtnet_rx_resume(struct v
 				struct receive_queue *rq,
 				bool refill)
 {
-	bool running = netif_running(vi->dev);
-	bool schedule_refill = false;
+	if (netif_running(vi->dev)) {
+		/* Pre-fill rq agressively, to make sure we are ready to get
+		 * packets immediately.
+		 */
+		if (refill)
+			try_fill_recv(vi, rq, GFP_KERNEL);
 
-	if (refill && !try_fill_recv(vi, rq, GFP_KERNEL))
-		schedule_refill = true;
-	if (running)
 		virtnet_napi_enable(rq);
-
-	if (schedule_refill)
-		schedule_delayed_work(&vi->refill, 0);
+	}
 }
 
 static void virtnet_rx_resume_all(struct virtnet_info *vi)
@@ -3827,11 +3827,12 @@ static int virtnet_set_queues(struct vir
 	}
 succ:
 	vi->curr_queue_pairs = queue_pairs;
-	/* virtnet_open() will refill when device is going to up. */
-	spin_lock_bh(&vi->refill_lock);
-	if (dev->flags & IFF_UP && vi->refill_enabled)
-		schedule_delayed_work(&vi->refill, 0);
-	spin_unlock_bh(&vi->refill_lock);
+	if (dev->flags & IFF_UP) {
+		local_bh_disable();
+		for (int i = 0; i < vi->curr_queue_pairs; ++i)
+			virtqueue_napi_schedule(&vi->rq[i].napi, vi->rq[i].vq);
+		local_bh_enable();
+	}
 
 	return 0;
 }


