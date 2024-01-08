Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FF04B5AB;
	Mon,  8 Jan 2024 15:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyNBp4mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E594C433BD;
	Mon,  8 Jan 2024 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726764;
	bh=sKAQQDYlqAayRQkNqpzzReaHrqaF4dAL/jMTEXNTlKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyNBp4muyQvBUynN9T8q9qX0wyS7K/v4SmvGtDNDrbZQ0tQzn5mM51x0TMJPu4izD
	 yt9RtmOW5GZ3OJbdzjpNR7Zn1ovT1YqNQGGFBfBgrNiPkVVD5soE8xo+7uXLnnmN9M
	 PO742scpfoi3MDIhGmgUR8yCHVPMLXMoOwcX4MHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/124] virtio_net: avoid data-races on dev->stats fields
Date: Mon,  8 Jan 2024 16:07:59 +0100
Message-ID: <20240108150605.403478904@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d12a26b74fb77434b73fe39022266c4b00907219 ]

Use DEV_STATS_INC() and DEV_STATS_READ() which provide
atomicity on paths that can be used concurrently.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2311e06b9bf3 ("virtio_net: fix missing dma unmap for resize")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0c0be6b872c6a..c1c634782672f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1258,7 +1258,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	if (unlikely(len > GOOD_PACKET_LEN)) {
 		pr_debug("%s: rx error: len %u exceeds max size %d\n",
 			 dev->name, len, GOOD_PACKET_LEN);
-		dev->stats.rx_length_errors++;
+		DEV_STATS_INC(dev, rx_length_errors);
 		goto err;
 	}
 
@@ -1323,7 +1323,7 @@ static void mergeable_buf_free(struct receive_queue *rq, int num_buf,
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers missing\n",
 				 dev->name, num_buf);
-			dev->stats.rx_length_errors++;
+			DEV_STATS_INC(dev, rx_length_errors);
 			break;
 		}
 		u64_stats_add(&stats->bytes, len);
@@ -1432,7 +1432,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 			pr_debug("%s: rx error: %d buffers out of %d missing\n",
 				 dev->name, *num_buf,
 				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
-			dev->stats.rx_length_errors++;
+			DEV_STATS_INC(dev, rx_length_errors);
 			goto err;
 		}
 
@@ -1451,7 +1451,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 			put_page(page);
 			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
 				 dev->name, len, (unsigned long)(truesize - room));
-			dev->stats.rx_length_errors++;
+			DEV_STATS_INC(dev, rx_length_errors);
 			goto err;
 		}
 
@@ -1630,7 +1630,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	if (unlikely(len > truesize - room)) {
 		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
 			 dev->name, len, (unsigned long)(truesize - room));
-		dev->stats.rx_length_errors++;
+		DEV_STATS_INC(dev, rx_length_errors);
 		goto err_skb;
 	}
 
@@ -1662,7 +1662,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				 dev->name, num_buf,
 				 virtio16_to_cpu(vi->vdev,
 						 hdr->num_buffers));
-			dev->stats.rx_length_errors++;
+			DEV_STATS_INC(dev, rx_length_errors);
 			goto err_buf;
 		}
 
@@ -1676,7 +1676,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (unlikely(len > truesize - room)) {
 			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
 				 dev->name, len, (unsigned long)(truesize - room));
-			dev->stats.rx_length_errors++;
+			DEV_STATS_INC(dev, rx_length_errors);
 			goto err_skb;
 		}
 
@@ -1763,7 +1763,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 
 	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
-		dev->stats.rx_length_errors++;
+		DEV_STATS_INC(dev, rx_length_errors);
 		virtnet_rq_free_unused_buf(rq->vq, buf);
 		return;
 	}
@@ -1803,7 +1803,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	return;
 
 frame_err:
-	dev->stats.rx_frame_errors++;
+	DEV_STATS_INC(dev, rx_frame_errors);
 	dev_kfree_skb(skb);
 }
 
@@ -2352,12 +2352,12 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* This should not happen! */
 	if (unlikely(err)) {
-		dev->stats.tx_fifo_errors++;
+		DEV_STATS_INC(dev, tx_fifo_errors);
 		if (net_ratelimit())
 			dev_warn(&dev->dev,
 				 "Unexpected TXQ (%d) queue failure: %d\n",
 				 qnum, err);
-		dev->stats.tx_dropped++;
+		DEV_STATS_INC(dev, tx_dropped);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
@@ -2576,10 +2576,10 @@ static void virtnet_stats(struct net_device *dev,
 		tot->tx_errors  += terrors;
 	}
 
-	tot->tx_dropped = dev->stats.tx_dropped;
-	tot->tx_fifo_errors = dev->stats.tx_fifo_errors;
-	tot->rx_length_errors = dev->stats.rx_length_errors;
-	tot->rx_frame_errors = dev->stats.rx_frame_errors;
+	tot->tx_dropped = DEV_STATS_READ(dev, tx_dropped);
+	tot->tx_fifo_errors = DEV_STATS_READ(dev, tx_fifo_errors);
+	tot->rx_length_errors = DEV_STATS_READ(dev, rx_length_errors);
+	tot->rx_frame_errors = DEV_STATS_READ(dev, rx_frame_errors);
 }
 
 static void virtnet_ack_link_announce(struct virtnet_info *vi)
-- 
2.43.0



