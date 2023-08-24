Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D695125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C3AC433C8;
	Thu, 24 Aug 2023 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889386;
	bh=ijZPhSiu9xwE8Nz8twZXX4P/hWJE9ckA84NXuEdf33U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlpoF6H09LmhZ9MXMucH1EtEiFE7IWR5mLhY9l+sOlvInIPEBgCfgN84YRahIkjmI
	 WmEgQDGP2cFIBg/dkcGPMirjqEAo4GE7UES9xr3t8xbQTTPNI9O/KLgQy8nQu/rI35
	 BhRfXjtwL6+0ih4t9WjLtTkiKlKGWRKA2GI2Q6TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 116/135] virtio-net: set queues after driver_ok
Date: Thu, 24 Aug 2023 16:50:59 +0200
Message-ID: <20230824145031.986299399@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
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

commit 51b813176f098ff61bd2833f627f5319ead098a5 upstream.

Commit 25266128fe16 ("virtio-net: fix race between set queues and
probe") tries to fix the race between set queues and probe by calling
_virtnet_set_queues() before DRIVER_OK is set. This violates virtio
spec. Fixing this by setting queues after virtio_device_ready().

Note that rtnl needs to be held for userspace requests to change the
number of queues. So we are serialized in this way.

Fixes: 25266128fe16 ("virtio-net: fix race between set queues and probe")
Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3220,8 +3220,6 @@ static int virtnet_probe(struct virtio_d
 		}
 	}
 
-	_virtnet_set_queues(vi, vi->curr_queue_pairs);
-
 	/* serialize netdev register + virtio_device_ready() with ndo_open() */
 	rtnl_lock();
 
@@ -3234,6 +3232,8 @@ static int virtnet_probe(struct virtio_d
 
 	virtio_device_ready(vdev);
 
+	_virtnet_set_queues(vi, vi->curr_queue_pairs);
+
 	rtnl_unlock();
 
 	err = virtnet_cpu_notif_add(vi);


