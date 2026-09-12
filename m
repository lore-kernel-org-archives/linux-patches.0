Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851836167B;
	Sat, 12 Sep 2026 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227943; cv=none; b=pYBxxM/xCfzhMlhm+kailA2+AP+7IQDmFogq4GtYTZamdyV/bQIV6aONZ796S76I3xMysh+O7YBgq2pBCyjdXvN2IuPQ/jEinWPnCPXGJ3SXIN8eoA3+hP8Jhh5Asu+Wlx+JL0xKIKRvEzYmmKFcVwWTQZRoi4SwLjdMgnQh//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227943; c=relaxed/simple;
	bh=BjofPpQhj3u7LP57w8n1lqoz8v6qhKXrSIy6dRUGbLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI9kgMqMRMYl8DNQ4dsf2Z43d1MWkyuS0P9RFBnxj10JoSSexf7hUyOwGP/JDE0m47dULs+YkesMw9NTDeboBCqRLHuusftZ5OEDBzxaW0c8AJIf5J0xcUQ85kwa+FrK0wZAqUkw2jw02mh+KBzMoCK3U7H426XvgD96tg3Roz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOh6TpEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOh6TpEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781381F000FF;
	Sat, 12 Sep 2026 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227941;
	bh=QrYznAaCm5q3Kx9OV8mTqRkesmS6z5YfmCpSZlkv83U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOh6TpELRZhlRRpDyRtFddFjqLl6zJRXJosdULxjZJHOoqi4UwVRhTONFlEcgNxk7
	 metltRaJK2iiejx/CzmJEc3Q8RKolzbtTHe+bZtve4hAW2F/DQivsg3SUbKBf69KT0
	 FW3TJQU1JjpxjsFw9gdumSWwxe38OS8K9zTmbXyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0242/1191] vsock/virtio: flush works in dependency order
Date: Sat, 12 Sep 2026 08:49:30 +0200
Message-ID: <20260912065553.649345134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 728836ebca239810f164262b10211ef59182f811 upstream.

virtio_vsock_remove() stops the virtqueues and then flushes each work
item before freeing the enclosing virtio_vsock.  The current order does
not account for dependencies between those items: tx_work may queue
send_pkt_work, and send_pkt_work may queue rx_work.

In particular, send_pkt_work can set restart_rx and release tx_lock.
The remove path can then stop the queues and flush rx_work before
send_pkt_work queues it.  Although the later send_pkt_work flush waits
for that producer to finish, nothing waits for the newly queued rx_work,
so kfree(vsock) can race with it.

KASAN reported:

  BUG: KASAN: slab-use-after-free in
  virtio_transport_rx_work+0x487/0x4b0
  Read of size 8 at addr ffff888114c2b008 by task kworker/1:1/47
  Workqueue: virtio_vsock virtio_transport_rx_work
  Call Trace:
   virtio_transport_rx_work+0x487/0x4b0
   process_one_work+0x688/0x1120
   worker_thread+0x45b/0xd10
  Allocated by task 1:
   virtio_vsock_probe+0xef/0x6b0
  Freed by task 84:
   kfree+0x131/0x3c0
   virtio_vsock_remove+0xd1/0x100

Flush the works in producer-to-consumer order.  virtio_vsock_vqs_del()
has already disabled the queue callbacks and cleared the run flags, so
after tx_work and send_pkt_work are drained, no source remains that can
queue rx_work after its flush.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://patch.msgid.link/20260822164556.3750959-1-nicoyip.dev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -714,10 +714,10 @@ static void virtio_vsock_remove(struct v
 	/* Other works can be queued before 'config->del_vqs()', so we flush
 	 * all works before to free the vsock object to avoid use after free.
 	 */
-	flush_work(&vsock->rx_work);
 	flush_work(&vsock->tx_work);
 	flush_work(&vsock->event_work);
 	flush_work(&vsock->send_pkt_work);
+	flush_work(&vsock->rx_work);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 


