Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83510373BF3;
	Sat, 12 Sep 2026 09:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204228; cv=none; b=Z6jjRdbIa9zVDAI3lSFxCv+swk/G5bwNtm6qyXpvdSMDoqVXiMYUo2QWCvViit5Es8vQ7g9PKTvH0hF6Bc/iqclxwHxiUt5E8F6C+zeLG0WaukEqS/tLjrLbbLtjzDJTSj+XTRTcn7CmAEW3pzEao+n7X3h+8I/Bz4MCA9Xb+/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204228; c=relaxed/simple;
	bh=oDaESbAeZg+zmrhN7giQbBj4MliUu88V2118Z+KM5Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXQUpU3cItWp7V7/m/NvuNQUBLD6igWxBmS6LSmX+KhVrHJfkvnHB6kd7kebs4c9W+o1Jyp9HwRBCzIq+KHiGd3H2HG2hD34K+s1bbLKZw8BgjOMn1CoHCIoPoeRU/N/JvghCLMjuRSKyeNaPqXLYpiDrrV7Mz0rGx2RlP12rS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oa2ZkNfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oa2ZkNfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA281F000FF;
	Sat, 12 Sep 2026 09:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204227;
	bh=dHMCSL3f6NEiawENI/a7arbcTbSq4sCpQCR9kNN5BZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oa2ZkNfP7JPwcdMHSnDAjGTnyvkEgB6OVLV34WqYiGd0rTDbC4+YHH1LDkYljlA73
	 Y9XfjeRMjr6qcKATJF7CjWD2CwIiSPP1n0N86KrZ9GN5QyjgbTm4DwFQbKMA8LUpJW
	 3AV7WwK8jyUyisfq1olIZGs0bRbzjUhNO3LN0tVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1570/1815] virtio_net: Fix resize of the RX ring
Date: Sat, 12 Sep 2026 08:55:20 +0200
Message-ID: <20260912065725.850846584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit d09c98a6da215bce2173a292e4b95c8de6ea5d51 ]

When a AF_XDP socket is attached, the virtnet_rx_resize
should resize the rq->xsk_buffs XSK buffer array. Otherwise,
when the size grows, the virtnet_rx_resume() causes a write
past the end of the array. This is easily reproducable with

    ethtool -G ens3 rx 32
    ./xdpsock -i eth0 -q 0 -r -z &
    ethtool -G eth0 rx 256

Fixes: e9f3962441c0 ("virtio_net: xsk: rx: support fill with xsk buffer")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://patch.msgid.link/20260810120728.47445-1-a.s.protopopov@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3e2a5876c6c8c..e34c52d059d39 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3444,17 +3444,31 @@ static void virtnet_rx_resume_all(struct virtnet_info *vi)
 static int virtnet_rx_resize(struct virtnet_info *vi,
 			     struct receive_queue *rq, u32 ring_num)
 {
+	unsigned int old_ring_num = virtqueue_get_vring_size(rq->vq);
+	struct xdp_buff **tmp_xsk_buffs = NULL;
 	int err, qindex;
 
 	qindex = rq - vi->rq;
 
+	if (rq->xsk_pool && ring_num > old_ring_num) {
+		tmp_xsk_buffs = kvzalloc_objs(*tmp_xsk_buffs, ring_num);
+		if (!tmp_xsk_buffs)
+			return -ENOMEM;
+	}
+
 	virtnet_rx_pause(vi, rq);
 
 	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_unmap_free_buf, NULL);
+
+	/* virtqueue_resize may have changed the size even if err != 0 */
+	if (tmp_xsk_buffs && virtqueue_get_vring_size(rq->vq) > old_ring_num)
+		swap(rq->xsk_buffs, tmp_xsk_buffs);
+
 	if (err)
 		netdev_err(vi->dev, "resize rx fail: rx queue index: %d err: %d\n", qindex, err);
 
 	virtnet_rx_resume(vi, rq, true);
+	kvfree(tmp_xsk_buffs);
 	return err;
 }
 
-- 
2.53.0



