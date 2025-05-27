Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3649B194A67;
	Tue, 27 May 2025 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364419; cv=none; b=BhGp6stga0Y6LaiPF42sScNTUEGSGOaH4nKEKpX7hLYpfgYnT8bRAxOqtBLgcwL03HTzTGRjSEgtLckSza1dLnmByw3bKAgsHpO7dq7SZDyH/5SqkpZ53aTFoWUhrsg+ezmzWPMPhaZBpAsk4CPoDht3cagitSiYCZGI6lXPWMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364419; c=relaxed/simple;
	bh=CAiIUK5DhdUH3HT1+0hEqDNuIzVhp0XJrBcWFBQRIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq9oHssFw97zK5UjEZ7Z1lkA2o7jvO575Du2oX1A7iF5R5GtKaDrNMphzso0BO+dvv2WjIGgFLYFYuK5v3VF+PP1eJiZ9Q8MxvOYzKSrg1J3ZFqC/J2OjvoZbYRBbLfhisIpl6QpoxOFZObSgY+8Aoy11L6aqgY5rP6qARqzDYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyIdtVwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyIdtVwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF95C4CEEB;
	Tue, 27 May 2025 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364419;
	bh=CAiIUK5DhdUH3HT1+0hEqDNuIzVhp0XJrBcWFBQRIdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyIdtVwO7gW6i9+MY5hDBBRiR7ehyStUrbf/+Jjb+51JkbU5tZkruLq/LSkXgi+V2
	 unBNvfdFTnP7dZxgTt9A62XWsOorrIZN54EjFVZpHLrcGFIRGWoxxWVzTv/5KUyVtf
	 AJm/sSGibqH8knSYLmNazpN+0+rhh1xj2r2HN8tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+efe683d57990864b8c8e@syzkaller.appspotmail.com,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/626] virtio_ring: Fix data race by tagging event_triggered as racy for KCSAN
Date: Tue, 27 May 2025 18:18:32 +0200
Message-ID: <20250527162445.841090634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 2e2f925fe737576df2373931c95e1a2b66efdfef ]

syzbot reports a data-race when accessing the event_triggered, here is the
simplified stack when the issue occurred:

==================================================================
BUG: KCSAN: data-race in virtqueue_disable_cb / virtqueue_enable_cb_delayed

write to 0xffff8881025bc452 of 1 bytes by task 3288 on cpu 0:
 virtqueue_enable_cb_delayed+0x42/0x3c0 drivers/virtio/virtio_ring.c:2653
 start_xmit+0x230/0x1310 drivers/net/virtio_net.c:3264
 __netdev_start_xmit include/linux/netdevice.h:5151 [inline]
 netdev_start_xmit include/linux/netdevice.h:5160 [inline]
 xmit_one net/core/dev.c:3800 [inline]

read to 0xffff8881025bc452 of 1 bytes by interrupt on cpu 1:
 virtqueue_disable_cb_split drivers/virtio/virtio_ring.c:880 [inline]
 virtqueue_disable_cb+0x92/0x180 drivers/virtio/virtio_ring.c:2566
 skb_xmit_done+0x5f/0x140 drivers/net/virtio_net.c:777
 vring_interrupt+0x161/0x190 drivers/virtio/virtio_ring.c:2715
 __handle_irq_event_percpu+0x95/0x490 kernel/irq/handle.c:158
 handle_irq_event_percpu kernel/irq/handle.c:193 [inline]

value changed: 0x01 -> 0x00
==================================================================

When the data race occurs, the function virtqueue_enable_cb_delayed() sets
event_triggered to false, and virtqueue_disable_cb_split/packed() reads it
as false due to the race condition. Since event_triggered is an unreliable
hint used for optimization, this should only cause the driver temporarily
suggest that the device not send an interrupt notification when the event
index is used.

Fix this KCSAN reported data-race issue by explicitly tagging the access as
data_racy.

Reported-by: syzbot+efe683d57990864b8c8e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67c7761a.050a0220.15b4b9.0018.GAE@google.com/
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Message-Id: <20250312130412.3516307-1-quic_zhonhan@quicinc.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1f8a322eb00be..147926c8bae09 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2530,7 +2530,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
 	if (vq->event_triggered)
-		vq->event_triggered = false;
+		data_race(vq->event_triggered = false);
 
 	return vq->packed_ring ? virtqueue_enable_cb_delayed_packed(_vq) :
 				 virtqueue_enable_cb_delayed_split(_vq);
-- 
2.39.5



