Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C445828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454A2C433EF;
	Mon, 30 Jan 2023 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087153;
	bh=ftIiClFAUTLDcmTt34WBL/krIogvBV75kHPEyeUqWwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0oLfJ6cgmt6Vi1hCLb1k+W5P71djoBOtGjOWkh3qmAnyhvHuLCfjqonLtETyKUlX
	 TnX9Fx8s+JXUy/O/OdI5WzLvEnhTViu5xHincJf9R1/9ZPL29/j8pZ2JYPbV7SQfOT
	 c/pIA23WX3xFi8lo8BJV+4+zyhiObFjgeJyW1FW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/313] virtio-net: correctly enable callback during start_xmit
Date: Mon, 30 Jan 2023 14:49:10 +0100
Message-Id: <20230130134342.017792919@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit d71ebe8114b4bf622804b810f5e274069060a174 ]

Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
virtqueue callback via the following statement:

        do {
		if (use_napi)
			virtqueue_disable_cb(sq->vq);

		free_old_xmit_skbs(sq, false);

	} while (use_napi && kick &&
               unlikely(!virtqueue_enable_cb_delayed(sq->vq)));

When NAPI is used and kick is false, the callback won't be enabled
here. And when the virtqueue is about to be full, the tx will be
disabled, but we still don't enable tx interrupt which will cause a TX
hang. This could be observed when using pktgen with burst enabled.

TO be consistent with the logic that tries to disable cb only for
NAPI, fixing this by trying to enable delayed callback only when NAPI
is enabled when the queue is about to be full.

Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Tested-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 86e52454b5b5..3cd15f16090f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1873,8 +1873,10 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
 		netif_stop_subqueue(dev, qnum);
-		if (!use_napi &&
-		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
+		if (use_napi) {
+			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
+				virtqueue_napi_schedule(&sq->napi, sq->vq);
+		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
 			free_old_xmit_skbs(sq, false);
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
-- 
2.39.0



