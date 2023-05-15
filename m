Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B3DFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3006C4339B;
	Mon, 15 May 2023 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169160;
	bh=2R0IC72LIR6W0D47EIvhmqARl4fveDZyScq3LHY8iG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxxODwYkMCsCXVeAV5V82C31I9VMNDfEpJfDrJOSBAFo/HUVsWE8gTS0GL/9JZe+v
	 P/r85AaeUv1oA2c4zm17C0WBNHFJlSGyHG9f08eBXOovKWya1Ag4YYwVuk37NXD3sV
	 +O3rPA0lMPhqFfoG0VT9emzws0s647syBQvoink4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenliang Wang <wangwenliang.1995@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/191] virtio_net: suppress cpu stall when free_unused_bufs
Date: Mon, 15 May 2023 18:26:39 +0200
Message-Id: <20230515161713.314846970@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wenliang Wang <wangwenliang.1995@bytedance.com>

[ Upstream commit f8bb5104394560e29017c25bcade4c6b7aabd108 ]

For multi-queue and large ring-size use case, the following error
occurred when free_unused_bufs:
rcu: INFO: rcu_sched self-detected stall on CPU.

Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9b72b3f0b5bf9..d45e8de79f286 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2685,12 +2685,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
 		struct virtqueue *vq = vi->sq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_sq_free_unused_buf(vq, buf);
+		cond_resched();
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->rq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_rq_free_unused_buf(vq, buf);
+		cond_resched();
 	}
 }
 
-- 
2.39.2



