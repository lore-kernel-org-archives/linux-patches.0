Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E8F17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA3C433C8;
	Wed,  9 Aug 2023 11:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581089;
	bh=S96WK/iD2nnxKmyXykIWQ6R0KPzXAWpu4o24+YrMX5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJ3sUW6e0L5ob+MRZwEE87YuX68f01XtVRRby4Sh2HiiGJHLuQ1elIhmmSk4n6kSP
	 kZ0KEmk6Yk+vT0BUABrB6fIaAhIY1TaRPUQO8z8jQ3pRIk0luuvPYC9mpsskXkW5Q5
	 Pxlsto8ZC3jeSV2qyCrZbEBFMUazgNSKUFQ+hVZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 101/201] virtio-net: fix race between set queues and probe
Date: Wed,  9 Aug 2023 12:41:43 +0200
Message-ID: <20230809103647.200462281@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

commit 25266128fe16d5632d43ada34c847d7b8daba539 upstream.

A race were found where set_channels could be called after registering
but before virtnet_set_queues() in virtnet_probe(). Fixing this by
moving the virtnet_set_queues() before netdevice registering. While at
it, use _virtnet_set_queues() to avoid holding rtnl as the device is
not even registered at that time.

Cc: stable@vger.kernel.org
Fixes: a220871be66f ("virtio-net: correctly enable multiqueue")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230725072049.617289-1-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3220,6 +3220,8 @@ static int virtnet_probe(struct virtio_d
 		}
 	}
 
+	_virtnet_set_queues(vi, vi->curr_queue_pairs);
+
 	/* serialize netdev register + virtio_device_ready() with ndo_open() */
 	rtnl_lock();
 
@@ -3240,8 +3242,6 @@ static int virtnet_probe(struct virtio_d
 		goto free_unregister_netdev;
 	}
 
-	virtnet_set_queues(vi, vi->curr_queue_pairs);
-
 	/* Assume link up if device can't report link status,
 	   otherwise get link status from config. */
 	netif_carrier_off(dev);


