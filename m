Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BFA14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB899C433C8;
	Thu, 24 Aug 2023 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897657;
	bh=XcBhtirTpIJfbAwhJj9cc/vvzoYGcGjwSWnl/5V2cpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7LM1Tca0DRrFF4jyJlw/dLeje4d/MFUH3RBNZPdwxE873VTvYCEOf33CXEQ4y8Oa
	 dzLy4xyNkSv5c4deuxKMsD/nRPZzszQcF22wYYwfsCxEvE/vlE+qxOW+XnINGjgYqM
	 e195+T2wxyRqXCuDY02HossUkxbZMoF3lR2o3OQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 116/135] virtio-net: set queues after driver_ok
Date: Thu, 24 Aug 2023 19:09:48 +0200
Message-ID: <20230824170622.315944731@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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


