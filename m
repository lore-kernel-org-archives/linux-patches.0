Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C005433AE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFEv7/AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18538C433C8;
	Wed, 15 Nov 2023 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077084;
	bh=1hAv52ARnXmQBL9O2r5lo/zpDZWCqJyJFZh56qKRGs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFEv7/ASwxqaDce786l6cabtQCA5sIuGr8RJ+/guLdfZselGRonhzWeHL3mae0VFc
	 YgvrbKZW+jt8jlERYtytXiYwRFB5KYSCZT/bIyxsu8eFCZS6fFzrIpMOCTFrGBawMB
	 9h01tiie9bpGR5mrP+C9aLesolhKgA84ZX7L6Vws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoming Zhao <zxm377917@alibaba-inc.com>,
	Gavin Li <gavinl@nvidia.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/603] virtio-net: fix per queue coalescing parameter setting
Date: Wed, 15 Nov 2023 14:11:04 -0500
Message-ID: <20231115191621.474307902@linuxfoundation.org>
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

[ Upstream commit bfb2b3609162135625bf96acf5118051cd0d082e ]

When the user sets a non-zero coalescing parameter to 0 for a specific
virtqueue, it does not work as expected, so let's fix this.

Fixes: 394bd87764b6 ("virtio_net: support per queue interrupt coalesce command")
Reported-by: Xiaoming Zhao <zxm377917@alibaba-inc.com>
Cc: Gavin Li <gavinl@nvidia.com>
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d3b976a591c84..4211f28c59dc8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3296,27 +3296,23 @@ static int virtnet_send_notf_coal_vq_cmds(struct virtnet_info *vi,
 {
 	int err;
 
-	if (ec->rx_coalesce_usecs || ec->rx_max_coalesced_frames) {
-		err = virtnet_send_ctrl_coal_vq_cmd(vi, rxq2vq(queue),
-						    ec->rx_coalesce_usecs,
-						    ec->rx_max_coalesced_frames);
-		if (err)
-			return err;
-		/* Save parameters */
-		vi->rq[queue].intr_coal.max_usecs = ec->rx_coalesce_usecs;
-		vi->rq[queue].intr_coal.max_packets = ec->rx_max_coalesced_frames;
-	}
+	err = virtnet_send_ctrl_coal_vq_cmd(vi, rxq2vq(queue),
+					    ec->rx_coalesce_usecs,
+					    ec->rx_max_coalesced_frames);
+	if (err)
+		return err;
 
-	if (ec->tx_coalesce_usecs || ec->tx_max_coalesced_frames) {
-		err = virtnet_send_ctrl_coal_vq_cmd(vi, txq2vq(queue),
-						    ec->tx_coalesce_usecs,
-						    ec->tx_max_coalesced_frames);
-		if (err)
-			return err;
-		/* Save parameters */
-		vi->sq[queue].intr_coal.max_usecs = ec->tx_coalesce_usecs;
-		vi->sq[queue].intr_coal.max_packets = ec->tx_max_coalesced_frames;
-	}
+	vi->rq[queue].intr_coal.max_usecs = ec->rx_coalesce_usecs;
+	vi->rq[queue].intr_coal.max_packets = ec->rx_max_coalesced_frames;
+
+	err = virtnet_send_ctrl_coal_vq_cmd(vi, txq2vq(queue),
+					    ec->tx_coalesce_usecs,
+					    ec->tx_max_coalesced_frames);
+	if (err)
+		return err;
+
+	vi->sq[queue].intr_coal.max_usecs = ec->tx_coalesce_usecs;
+	vi->sq[queue].intr_coal.max_packets = ec->tx_max_coalesced_frames;
 
 	return 0;
 }
-- 
2.42.0



