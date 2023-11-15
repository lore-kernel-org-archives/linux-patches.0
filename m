Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64604433AF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MW2dpYk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE3C433C8;
	Wed, 15 Nov 2023 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077087;
	bh=tjWQXNx05cGKHG4pOQKR7Yb2JnhfZxMKU0vIXhaFhHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MW2dpYk7bogBnxowUyqxZswhFL9pSCy4kBzsZE5ID4Rz+sBeY42Tuun7hm2qiwbhh
	 4SVSi7Dy8sOUkE2e1TsRBhKQ3LuE3ApnpxYcQaY5N6DloQbQBioyx281wReZUVvYNg
	 eVDb3HZlVVE0wMy13Bxx9WoLeEGbkN/jqG5DGDKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/603] virtio-net: fix the vq coalescing setting for vq resize
Date: Wed, 15 Nov 2023 14:11:05 -0500
Message-ID: <20231115191621.542379867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heng Qi <hengqi@linux.alibaba.com>

[ Upstream commit f61fe5f081cf40de08d0a4c89659baf23c900f0c ]

According to the definition of virtqueue coalescing spec[1]:

  Upon disabling and re-enabling a transmit virtqueue, the device MUST set
  the coalescing parameters of the virtqueue to those configured through the
  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET command, or, if the driver did not set
  any TX coalescing parameters, to 0.

  Upon disabling and re-enabling a receive virtqueue, the device MUST set
  the coalescing parameters of the virtqueue to those configured through the
  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET command, or, if the driver did not set
  any RX coalescing parameters, to 0.

We need to add this setting for vq resize (ethtool -G) where vq_reset happens.

[1] https://lists.oasis-open.org/archives/virtio-dev/202303/msg00415.html

Fixes: 394bd87764b6 ("virtio_net: support per queue interrupt coalesce command")
Cc: Gavin Li <gavinl@nvidia.com>
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4211f28c59dc8..cd1e9e87eaa35 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2855,6 +2855,9 @@ static void virtnet_get_ringparam(struct net_device *dev,
 	ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
 }
 
+static int virtnet_send_ctrl_coal_vq_cmd(struct virtnet_info *vi,
+					 u16 vqn, u32 max_usecs, u32 max_packets);
+
 static int virtnet_set_ringparam(struct net_device *dev,
 				 struct ethtool_ringparam *ring,
 				 struct kernel_ethtool_ringparam *kernel_ring,
@@ -2890,12 +2893,36 @@ static int virtnet_set_ringparam(struct net_device *dev,
 			err = virtnet_tx_resize(vi, sq, ring->tx_pending);
 			if (err)
 				return err;
+
+			/* Upon disabling and re-enabling a transmit virtqueue, the device must
+			 * set the coalescing parameters of the virtqueue to those configured
+			 * through the VIRTIO_NET_CTRL_NOTF_COAL_TX_SET command, or, if the driver
+			 * did not set any TX coalescing parameters, to 0.
+			 */
+			err = virtnet_send_ctrl_coal_vq_cmd(vi, txq2vq(i),
+							    vi->intr_coal_tx.max_usecs,
+							    vi->intr_coal_tx.max_packets);
+			if (err)
+				return err;
+
+			vi->sq[i].intr_coal.max_usecs = vi->intr_coal_tx.max_usecs;
+			vi->sq[i].intr_coal.max_packets = vi->intr_coal_tx.max_packets;
 		}
 
 		if (ring->rx_pending != rx_pending) {
 			err = virtnet_rx_resize(vi, rq, ring->rx_pending);
 			if (err)
 				return err;
+
+			/* The reason is same as the transmit virtqueue reset */
+			err = virtnet_send_ctrl_coal_vq_cmd(vi, rxq2vq(i),
+							    vi->intr_coal_rx.max_usecs,
+							    vi->intr_coal_rx.max_packets);
+			if (err)
+				return err;
+
+			vi->rq[i].intr_coal.max_usecs = vi->intr_coal_rx.max_usecs;
+			vi->rq[i].intr_coal.max_packets = vi->intr_coal_rx.max_packets;
 		}
 	}
 
-- 
2.42.0



