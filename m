Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B3217AE00;
	Tue, 10 Sep 2024 10:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962407; cv=none; b=pSS+ACtgQD+g0suKgByvKi4mLKaSN0JFfr9MG8ntJDoDdX5Ut9MIoqRQ1aoxqFDa5cMoWP5+PmQ+zZN7fYfVXyxqO4nfMFl1yIn3BYDUfzqH9N1gWe6ZlTqWWIk8um2gRaOaJreRKNyre3xdkwGPJ2CRHCVKYWmvR2cmPp8v6TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962407; c=relaxed/simple;
	bh=TpdSuptpqqDTm4klHbghUFTJpZ5GtUqmZz2xYCQVOBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZtTi8sczSCMygEA0brjCHPnGB3uHa1BQXg0J3Zb4LwG4JojqWVslzXGX9eRVwr4ViKNeW2FmrTjgZTasQMC4Uo4B1l/7pB+Iz/lQWs3QrLFtX/WEDdlkk4LB8N/ht4yprov+QqtlmgHHC+Zl8DoVt1UFDAJgU8fzBoBsLGyXso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=symlzPOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="symlzPOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC54C4CEC3;
	Tue, 10 Sep 2024 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962407;
	bh=TpdSuptpqqDTm4klHbghUFTJpZ5GtUqmZz2xYCQVOBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=symlzPOhvt5oZz3x/+H112UzInuCo4g+b7tZIN0aU6QQ3XEyDXRC0BJ6IFfnrVpaO
	 YrCaTrGgO7tYvFI3DcbmGlaR67vRuDibsSWXDt2bfelmqgBHFbfomkDk4+nZtaOamy
	 ChUjNgPG2WdhdhId6gqDvOqapm3GO2eXbLaf/TwI=
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
Subject: [PATCH 5.4 023/121] virtio_net: Fix napi_skb_cache_put warning
Date: Tue, 10 Sep 2024 11:31:38 +0200
Message-ID: <20240910092546.813146598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1479,7 +1479,7 @@ static bool is_xdp_raw_buffer_queue(stru
 		return false;
 }
 
-static void virtnet_poll_cleantx(struct receive_queue *rq)
+static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
 	unsigned int index = vq2rxq(rq->vq);
@@ -1490,7 +1490,7 @@ static void virtnet_poll_cleantx(struct
 		return;
 
 	if (__netif_tx_trylock(txq)) {
-		free_old_xmit_skbs(sq, true);
+		free_old_xmit_skbs(sq, !!budget);
 		__netif_tx_unlock(txq);
 	}
 
@@ -1507,7 +1507,7 @@ static int virtnet_poll(struct napi_stru
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
-	virtnet_poll_cleantx(rq);
+	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
 
@@ -1580,7 +1580,7 @@ static int virtnet_poll_tx(struct napi_s
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit_skbs(sq, true);
+	free_old_xmit_skbs(sq, !!budget);
 
 	opaque = virtqueue_enable_cb_prepare(sq->vq);
 


