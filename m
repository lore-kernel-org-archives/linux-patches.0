Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40467134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB57C433EF;
	Mon, 12 Jun 2023 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566621;
	bh=w/eDSo4yjdp+bz1ucfE9I8Lp7Y7KeJEgSWjKkl15tmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuScsNZq4FtqJ+4HqntY1MIMo2tDU95W3piBa0ns5lKC6ukcu7OVVju3HCNDpXih3
	 zTCUIX/Zq9euEH30/MpzthOIdf8iY2xP+aJEmHbVhRjpyxnyLbh0dxOVqWsNsc8vtm
	 GxaU6J0eA3ZEKLPZ0WeBxKiPRs1oghenNZrNdtR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 094/132] virtio_net: use control_buf for coalesce params
Date: Mon, 12 Jun 2023 12:27:08 +0200
Message-ID: <20230612101714.509307698@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brett Creeley <brett.creeley@amd.com>

commit accc1bf23068c1cdc4c2b015320ba856e210dd98 upstream.

Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
support") added coalescing command support for virtio_net. However,
the coalesce commands are using buffers on the stack, which is causing
the device to see DMA errors. There should also be a complaint from
check_for_stack() in debug_dma_map_xyz(). Fix this by adding and using
coalesce params from the control_buf struct, which aligns with other
commands.

Cc: stable@vger.kernel.org
Fixes: 699b045a8e43 ("net: virtio_net: notifications coalescing support")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20230605195925.51625-1-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -200,6 +200,8 @@ struct control_buf {
 	__virtio16 vid;
 	__virtio64 offloads;
 	struct virtio_net_ctrl_rss rss;
+	struct virtio_net_ctrl_coal_tx coal_tx;
+	struct virtio_net_ctrl_coal_rx coal_rx;
 };
 
 struct virtnet_info {
@@ -2786,12 +2788,10 @@ static int virtnet_send_notf_coal_cmds(s
 				       struct ethtool_coalesce *ec)
 {
 	struct scatterlist sgs_tx, sgs_rx;
-	struct virtio_net_ctrl_coal_tx coal_tx;
-	struct virtio_net_ctrl_coal_rx coal_rx;
 
-	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
-	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
-	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
+	vi->ctrl->coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
+	vi->ctrl->coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
+	sg_init_one(&sgs_tx, &vi->ctrl->coal_tx, sizeof(vi->ctrl->coal_tx));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
 				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
@@ -2802,9 +2802,9 @@ static int virtnet_send_notf_coal_cmds(s
 	vi->tx_usecs = ec->tx_coalesce_usecs;
 	vi->tx_max_packets = ec->tx_max_coalesced_frames;
 
-	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
-	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
-	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
+	vi->ctrl->coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
+	vi->ctrl->coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
+	sg_init_one(&sgs_rx, &vi->ctrl->coal_rx, sizeof(vi->ctrl->coal_rx));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
 				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,


