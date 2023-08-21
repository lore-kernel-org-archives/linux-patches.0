Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC3A1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E922C433C7;
	Mon, 21 Aug 2023 20:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648531;
	bh=p7MNHl+6ZNFj+Yi07wmhbn7bihov60Aj0FXa/pLjxvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAyt8hIpVKwniVv+zHdpNPyynJOXWxIxjl6Kk4JWVpxFrKLFiqa4YxeGWGWLcvntm
	 7WX8/ZNicp50KQFpZBY8F5uNZd9PEafrtMd1jWjfa+XU1v5EI8530L6msjrDvw4583
	 90kp4aXbivhKJXIxTHR0JA1iwRhF+ictERIZ81wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Melnychenko <andrew@daynix.com>,
	Hawkins Jiawei <yin31149@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH 6.4 208/234] virtio-net: Zero max_tx_vq field for VIRTIO_NET_CTRL_MQ_HASH_CONFIG case
Date: Mon, 21 Aug 2023 21:42:51 +0200
Message-ID: <20230821194138.056010169@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hawkins Jiawei <yin31149@gmail.com>

commit 2c507ce90e02cd78d00fd4b0fe26c8641873c13f upstream.

Kernel uses `struct virtio_net_ctrl_rss` to save command-specific-data
for both the VIRTIO_NET_CTRL_MQ_HASH_CONFIG and
VIRTIO_NET_CTRL_MQ_RSS_CONFIG commands.

According to the VirtIO standard, "Field reserved MUST contain zeroes.
It is defined to make the structure to match the layout of
virtio_net_rss_config structure, defined in 5.1.6.5.7.".

Yet for the VIRTIO_NET_CTRL_MQ_HASH_CONFIG command case, the `max_tx_vq`
field in struct virtio_net_ctrl_rss, which corresponds to the
`reserved` field in struct virtio_net_hash_config, is not zeroed,
thereby violating the VirtIO standard.

This patch solves this problem by zeroing this field in
virtnet_init_default_rss().

Cc: Andrew Melnychenko <andrew@daynix.com>
Cc: stable@vger.kernel.org
Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20230810110405.25558-1-yin31149@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2652,7 +2652,7 @@ static void virtnet_init_default_rss(str
 		vi->ctrl->rss.indirection_table[i] = indir_val;
 	}
 
-	vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
+	vi->ctrl->rss.max_tx_vq = vi->has_rss ? vi->curr_queue_pairs : 0;
 	vi->ctrl->rss.hash_key_length = vi->rss_key_size;
 
 	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);


