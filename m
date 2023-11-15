Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200DD433AE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQArH6qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74DCC433CA;
	Wed, 15 Nov 2023 19:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077081;
	bh=EXifiSZNtICbUqTh1YWnjsyN8ND3Zbu3NCQn76ehdTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQArH6qWUDlmOxvH59vqycaqTLaOBzy9DFI7f5qWd54oL646YtjbPXv7VUk2dQsKo
	 BWGY5ocIuXtlaZY8DiCGh7pC2PrkFBQhYj/0dNcNateYn+pCdr/1Dp3yNb+ow/Dv8v
	 JyyQtGU+7LIGXGGWpZQXioBtv/P2hSq2Sifef5a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/603] virtio-net: consistently save parameters for per-queue
Date: Wed, 15 Nov 2023 14:11:03 -0500
Message-ID: <20231115191621.406475835@linuxfoundation.org>
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

[ Upstream commit e9420838ab4ffb82850095549e94dcee3f7fe0cb ]

When using .set_coalesce interface to set all queue coalescing
parameters, we need to update both per-queue and global save values.

Fixes: 394bd87764b6 ("virtio_net: support per queue interrupt coalesce command")
Cc: Gavin Li <gavinl@nvidia.com>
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b218c2bafddcc..d3b976a591c84 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3233,6 +3233,7 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 				       struct ethtool_coalesce *ec)
 {
 	struct scatterlist sgs_tx, sgs_rx;
+	int i;
 
 	vi->ctrl->coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
 	vi->ctrl->coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
@@ -3246,6 +3247,10 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 	/* Save parameters */
 	vi->intr_coal_tx.max_usecs = ec->tx_coalesce_usecs;
 	vi->intr_coal_tx.max_packets = ec->tx_max_coalesced_frames;
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		vi->sq[i].intr_coal.max_usecs = ec->tx_coalesce_usecs;
+		vi->sq[i].intr_coal.max_packets = ec->tx_max_coalesced_frames;
+	}
 
 	vi->ctrl->coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
 	vi->ctrl->coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
@@ -3259,6 +3264,10 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 	/* Save parameters */
 	vi->intr_coal_rx.max_usecs = ec->rx_coalesce_usecs;
 	vi->intr_coal_rx.max_packets = ec->rx_max_coalesced_frames;
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		vi->rq[i].intr_coal.max_usecs = ec->rx_coalesce_usecs;
+		vi->rq[i].intr_coal.max_packets = ec->rx_max_coalesced_frames;
+	}
 
 	return 0;
 }
-- 
2.42.0



