Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA8837BE64;
	Sat, 17 Oct 2026 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254943; cv=none; b=j1u2/mbrXgF+WtF0/PsIG8laaqybph++tDJFN4IHV+T2aTixPTBdfAm7avKkfZGkh02spPUj9kf4MzGeTy+WW12HGxL167j0LxIVOduE9nqp37Uw1pTdLNfaFzLT6CwV3F6Zxl/JB2DLk/wtiGYgcwqeWWDTQ2BTQL22EvCGOx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254943; c=relaxed/simple;
	bh=4anEhKvVIqJIbqqsi76/5+7uW5m0HScPRAwcm+tfPB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpNGtoKdLksqJkK3XyN2ie/y2DvBWmKE8H4OLVh9Wf40c43hKNt5Srp5dPJETcDBJ/0mKG1thccic8PmSfZ4t4P2615+mQHUuoi/P2E3np5LUUrQqDXYm8bB5Hu48ObUfLPyLi9GGj0ZL9BYTehtdfO5kl8o0J2uFr6SNz0xKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKI9p8cW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKI9p8cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56201F000C4;
	Sat, 17 Oct 2026 16:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254942;
	bh=EAT6356LK6+eCHe6FPQcV+pug0jaom3ToYWQ3DeoAgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKI9p8cWUTDjwQfDZ18HjkNUoOqltWXBeWq2NEJfWWhfjoh7DNSK6ibP2ZUMMXZUb
	 CJJfagtrNQkMGJtYfwkk11o5UxGs1qB2CXuwE9w/6Z6wCxLqDDPTz1CLLOo7eMpM3P
	 Qnmb1Dl1EOVb/+qax0ylobAWyEmVstdtTO2LUhI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 614/869] virtio_net: Fix resize of the RX ring
Date: Sat, 17 Oct 2026 17:57:35 +0200
Message-ID: <20261017160052.776857868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 851defa105e04..2c62371666cd5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3220,17 +3220,31 @@ static void virtnet_rx_resume(struct virtnet_info *vi, struct receive_queue *rq)
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
 
 	virtnet_rx_resume(vi, rq);
+	kvfree(tmp_xsk_buffs);
 	return err;
 }
 
-- 
2.53.0



