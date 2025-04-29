Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375FC247298;
	Tue, 29 Apr 2025 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945826; cv=none; b=gR0WtvRMSvfiIulyrYvw3FkDEWRf5KfTdW8uiba2lTnnhi0vPM1P5MSwP/VXALVdHJZb/V//zUdwV/U5pdjMjYcmzLhpeurUc96yYwOFmdaVbwaNieWWEKNxpbypru77OH5H31LGfdvOjonhC3GFHwRhOVu00cyIadjekIAgILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945826; c=relaxed/simple;
	bh=x1hTQZuvCxwzQz8MHhkFjerI+mDv+sLyFQnM5u/UBJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpBA15nHHQB6CZLMfkGtwfSPvC9m/Ww/Zl/WPDw+Dh8tqRkVyFW1dAH/T2kcHuRa91TewA4iY09FoT+B1MypCjuxa9Yo7RzkBxuXdou8U/QTKAEKpADcnLzN5Ua7G2iYIWfMwPoyG9x4S+itrU8EYoJVWZWV67wyhEpd/KvR9R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8lIR850; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8lIR850"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B676FC4CEE3;
	Tue, 29 Apr 2025 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945826;
	bh=x1hTQZuvCxwzQz8MHhkFjerI+mDv+sLyFQnM5u/UBJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8lIR850WgQBh5AGxa05HaZP/x7lfKottECmjOlAwEm5Eg1XKRljkkDJd5lHIBG4J
	 O1VAJW2NUGw9mU0fe8RM5H9YoFt8ZXGghMzIm2UvGtJLMFcXBdBROWHiU6N4u/WVsH
	 kS5NNfM+R7ljWyzjSN3rlUQIfqTNSXM/BkSJMUw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 063/311] virtio-net: Refactor napi_disable paths
Date: Tue, 29 Apr 2025 18:38:20 +0200
Message-ID: <20250429161123.621862608@linuxfoundation.org>
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

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 986a93045183ae2f13e6d99d990ae8be36f6d6b0 ]

Create virtnet_napi_disable helper and refactor virtnet_napi_tx_disable
to take a struct send_queue.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://patch.msgid.link/20250307011215.266806-3-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4bc12818b363 ("virtio-net: disable delayed refill when pausing rx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d25f68004f97e..44dbb991787ed 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2827,12 +2827,21 @@ static void virtnet_napi_tx_enable(struct send_queue *sq)
 	virtnet_napi_do_enable(sq->vq, napi);
 }
 
-static void virtnet_napi_tx_disable(struct napi_struct *napi)
+static void virtnet_napi_tx_disable(struct send_queue *sq)
 {
+	struct napi_struct *napi = &sq->napi;
+
 	if (napi->weight)
 		napi_disable(napi);
 }
 
+static void virtnet_napi_disable(struct receive_queue *rq)
+{
+	struct napi_struct *napi = &rq->napi;
+
+	napi_disable(napi);
+}
+
 static void refill_work(struct work_struct *work)
 {
 	struct virtnet_info *vi =
@@ -2843,7 +2852,7 @@ static void refill_work(struct work_struct *work)
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
 		struct receive_queue *rq = &vi->rq[i];
 
-		napi_disable(&rq->napi);
+		virtnet_napi_disable(rq);
 		still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
 		virtnet_napi_enable(rq);
 
@@ -3042,8 +3051,8 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 
 static void virtnet_disable_queue_pair(struct virtnet_info *vi, int qp_index)
 {
-	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
-	napi_disable(&vi->rq[qp_index].napi);
+	virtnet_napi_tx_disable(&vi->sq[qp_index]);
+	virtnet_napi_disable(&vi->rq[qp_index]);
 	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
 }
 
@@ -3314,7 +3323,7 @@ static void virtnet_rx_pause(struct virtnet_info *vi, struct receive_queue *rq)
 	bool running = netif_running(vi->dev);
 
 	if (running) {
-		napi_disable(&rq->napi);
+		virtnet_napi_disable(rq);
 		virtnet_cancel_dim(vi, &rq->dim);
 	}
 }
@@ -3356,7 +3365,7 @@ static void virtnet_tx_pause(struct virtnet_info *vi, struct send_queue *sq)
 	qindex = sq - vi->sq;
 
 	if (running)
-		virtnet_napi_tx_disable(&sq->napi);
+		virtnet_napi_tx_disable(sq);
 
 	txq = netdev_get_tx_queue(vi->dev, qindex);
 
@@ -5933,8 +5942,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	/* Make sure NAPI is not using any XDP TX queues for RX. */
 	if (netif_running(dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
-			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
+			virtnet_napi_disable(&vi->rq[i]);
+			virtnet_napi_tx_disable(&vi->sq[i]);
 		}
 	}
 
-- 
2.39.5



