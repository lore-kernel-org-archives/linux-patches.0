Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B93B46444;
	Tue, 10 Sep 2024 09:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960983; cv=none; b=nYJtYDWKC71L/0x38Kj1JbvlRcnRcdbj7d1+oEjNl4S8m3uO9OvMvKcU3hApg31yCrmguOR8Xy0b6xncCd1CWQCz9RzaixDsszLlXXoIhO6tKKQ7rfaItduXyEO3oeml+u/aXwNHuQqBRpP9P3jgLRr4i6UK902gi8HQaeJEFys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960983; c=relaxed/simple;
	bh=vR86I937CbA2+ZZLY0J4MJbSb0qKNBrNEg5Y9TyY3Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iG6yuik4cJF6zjSxIo6nIl0pjJI70kdky2NwgXVOibzeEC3P+9+uiDg/JCCWWyUURIyRN6LB/E40UlzIFIzC/NEkxfPW1brnxdSAoSF+J5O4tv6cGwpiYt5HWo2APxAcZ5VspxX4D5IaEOKKQCpq94doxxcWwy2s/ywjBLsvcSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrRL9Elk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrRL9Elk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8BEC4CEC3;
	Tue, 10 Sep 2024 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725960983;
	bh=vR86I937CbA2+ZZLY0J4MJbSb0qKNBrNEg5Y9TyY3Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrRL9ElkOfgx1Vrd+bi7tuwY+P6GoHOWLqNy0FQh9OrNeSrsnNfwcJXaPdk82ZljG
	 Y6V244Q0f5Trb4ci+qnrql9TRYUkrOSoSqkoXBv3jh6zWKb52dfzL+cCb+DMS1BCLV
	 3koV6c6FghpRRuolswj/Pmt+riy4ni18e/g1BOIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 4.19 14/96] virtio_net: Fix napi_skb_cache_put warning
Date: Tue, 10 Sep 2024 11:31:16 +0200
Message-ID: <20240910092542.050513879@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit f8321fa75102246d7415a6af441872f6637c93ab upstream.

After the commit bdacf3e34945 ("net: Use nested-BH locking for
napi_alloc_cache.") was merged, the following warning began to appear:

	 WARNING: CPU: 5 PID: 1 at net/core/skbuff.c:1451 napi_skb_cache_put+0x82/0x4b0

	  __warn+0x12f/0x340
	  napi_skb_cache_put+0x82/0x4b0
	  napi_skb_cache_put+0x82/0x4b0
	  report_bug+0x165/0x370
	  handle_bug+0x3d/0x80
	  exc_invalid_op+0x1a/0x50
	  asm_exc_invalid_op+0x1a/0x20
	  __free_old_xmit+0x1c8/0x510
	  napi_skb_cache_put+0x82/0x4b0
	  __free_old_xmit+0x1c8/0x510
	  __free_old_xmit+0x1c8/0x510
	  __pfx___free_old_xmit+0x10/0x10

The issue arises because virtio is assuming it's running in NAPI context
even when it's not, such as in the netpoll case.

To resolve this, modify virtnet_poll_tx() to only set NAPI when budget
is available. Same for virtnet_poll_cleantx(), which always assumed that
it was in a NAPI context.

Fixes: df133f3f9625 ("virtio_net: bulk free tx skbs")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Link: https://patch.msgid.link/20240712115325.54175-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Shivani: Modified to apply on v4.19.y-v5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1428,7 +1428,7 @@ static bool is_xdp_raw_buffer_queue(stru
 		return false;
 }
 
-static void virtnet_poll_cleantx(struct receive_queue *rq)
+static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
 	unsigned int index = vq2rxq(rq->vq);
@@ -1439,7 +1439,7 @@ static void virtnet_poll_cleantx(struct
 		return;
 
 	if (__netif_tx_trylock(txq)) {
-		free_old_xmit_skbs(sq, true);
+		free_old_xmit_skbs(sq, !!budget);
 		__netif_tx_unlock(txq);
 	}
 
@@ -1456,7 +1456,7 @@ static int virtnet_poll(struct napi_stru
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
-	virtnet_poll_cleantx(rq);
+	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
 
@@ -1526,7 +1526,7 @@ static int virtnet_poll_tx(struct napi_s
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit_skbs(sq, true);
+	free_old_xmit_skbs(sq, !!budget);
 
 	opaque = virtqueue_enable_cb_prepare(sq->vq);
 


