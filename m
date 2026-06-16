Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19345BD4C;
	Tue, 16 Jun 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624711; cv=none; b=e/mWWSkqGierv+dp9SPJQaSq3THo3jxOzp+Iu34Y1oGZeMqrruLBF7xM/FGpQRH9EL5Xc8YiBan0EDJW7JofQ74tZbjx/cB4PtkjjzaMNCCTgFuw6toHZg4ynM4UYAQPf+voImTQrf4jETmRUj84QnKV42gckdRoG9nGbmgT3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624711; c=relaxed/simple;
	bh=8Y/L+bcTV1gyF5H7S3T5U3CoubCJkABy2BnrLFGH/Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TSTRqh95dVq/hbfsGV6i5pYgaFu7RxfOkbLpGSDBYXexUI40O7WnfIAlLmZd7qEVNOhlcR9HiqRCtS+eJFct4HkIyEaCtQxDhuD4HDADzAA6rIbMnMPWRrG/rUWsobXykm6kuHXyOw4MyI14GxkiOYgIJNFQNcv8ec+l+7KChM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAzY0OAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAzY0OAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843A91F000E9;
	Tue, 16 Jun 2026 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624708;
	bh=B7OzYQxyKiuFiTRmLcSI4T0YkKC3Sy91ozU1VNZ6QIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAzY0OAunYIuj7fkhWeeU8JTV/OtxUMWl9iYcImEedir75IEjnVrNXELXWaJpOBd1
	 RoP2LCGNMgddlJ4G7kac1fZ11/XYmymU3gCEEgDojyHUD1fR17EUSzAqQ4vIyOE/zq
	 6CI4gyoglfzzhxhx+R5U2suQ4iBOsfktRTb2nymo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 370/378] vsock/virtio: fix potential unbounded skb queue
Date: Tue, 16 Jun 2026 20:30:01 +0530
Message-ID: <20260616145129.590520706@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 059b7dbd20a6f0c539a45ddff1573cb8946685b5 upstream.

virtio_transport_inc_rx_pkt() checks vvs->rx_bytes + len > vvs->buf_alloc.

virtio_transport_recv_enqueue() skips coalescing for packets
with VIRTIO_VSOCK_SEQ_EOM.

If fed with packets with len == 0 and VIRTIO_VSOCK_SEQ_EOM,
a very large number of packets can be queued
because vvs->rx_bytes stays at 0.

Fix this by estimating the skb metadata size:

	(Number of skbs in the queue) * SKB_TRUESIZE(0)

Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: virtualization@lists.linux.dev
Link: https://patch.msgid.link/20260430122653.554058-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -425,7 +425,9 @@ static int virtio_transport_send_pkt_inf
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
 					u32 len)
 {
-	if (vvs->buf_used + len > vvs->buf_alloc)
+	u64 skb_overhead = (skb_queue_len(&vvs->rx_queue) + 1) * SKB_TRUESIZE(0);
+
+	if (skb_overhead + vvs->buf_used + len > vvs->buf_alloc)
 		return false;
 
 	vvs->rx_bytes += len;


