Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648D91D0164;
	Wed,  2 Oct 2024 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876571; cv=none; b=A7AWWh+Z8G8LbBUplTQ7SYzon/KzYH7ynATZAp73X/1YeS34/n/MOkb0ihhZw3BHxpkkFBLFPAQo1D056L/IzwPKT2Brezv/A/5YHOz38Rn6MbmlHU78GAUuM32CD0re3COX69tcIsZHP1vO/wMJHGTao9ZemDDWb9iRFN9AKv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876571; c=relaxed/simple;
	bh=MdzNeRMdahOq/ZHtp6GMIcH9MCQaWcOXdJ0cdzEI3WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZhYPGoPEjD/iLeisHNSR4UjA6W991RUhDs8cf42EKq6qh1gSykqSCI0lAMnXHj/HZ+TqLicmgPYJPzNRVi1mf0swMesnLuWZqohXrwZj4wtaHFuboj2IWtzoiYrMnMysFSr7QjrWshbzCr5htTyqeGlJro+akJ2gKrXZsuapoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEf4Cb6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEf4Cb6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B34C4CEC5;
	Wed,  2 Oct 2024 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876571;
	bh=MdzNeRMdahOq/ZHtp6GMIcH9MCQaWcOXdJ0cdzEI3WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEf4Cb6gpr4EytAI7gDC8R6BYPnEeekQybLooCq7qPZyjGtz6ckwB9Vumvfm/1V7f
	 gB/6J7Ycm+MaOfDF1KC6M7BGjorgG/PDuZ8bMDg3fMi2NnUYZst0Vh8JiHh23i6NSc
	 ceo40sdayDJW0DJShYS7XfGrX5OHyHrXuLkmn+0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbo Li <liwenbo.martin@bytedance.com>,
	Jiahui Cen <cenjiahui@bytedance.com>,
	Ying Fang <fangying.tommy@bytedance.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 488/695] virtio_net: Fix mismatched buf address when unmapping for small packets
Date: Wed,  2 Oct 2024 14:58:06 +0200
Message-ID: <20241002125841.948344486@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenbo Li <liwenbo.martin@bytedance.com>

[ Upstream commit c11a49d58ad229a1be1ebe08a2b68fedf83db6c8 ]

Currently, the virtio-net driver will perform a pre-dma-mapping for
small or mergeable RX buffer. But for small packets, a mismatched address
without VIRTNET_RX_PAD and xdp_headroom is used for unmapping.

That will result in unsynchronized buffers when SWIOTLB is enabled, for
example, when running as a TDX guest.

This patch unifies the address passed to the virtio core as the address of
the virtnet header and fixes the mismatched buffer address.

Changes from v2: unify the buf that passed to the virtio core in small
and merge mode.
Changes from v1: Use ctx to get xdp_headroom.

Fixes: 295525e29a5b ("virtio_net: merge dma operations when filling mergeable buffers")
Signed-off-by: Wenbo Li <liwenbo.martin@bytedance.com>
Signed-off-by: Jiahui Cen <cenjiahui@bytedance.com>
Signed-off-by: Ying Fang <fangying.tommy@bytedance.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://patch.msgid.link/20240919081351.51772-1-liwenbo.martin@bytedance.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6f4781ec2b369..f8131f92a3928 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1807,6 +1807,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	struct page *page = virt_to_head_page(buf);
 	struct sk_buff *skb;
 
+	/* We passed the address of virtnet header to virtio-core,
+	 * so truncate the padding.
+	 */
+	buf -= VIRTNET_RX_PAD + xdp_headroom;
+
 	len -= vi->hdr_len;
 	u64_stats_add(&stats->bytes, len);
 
@@ -2422,8 +2427,9 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	virtnet_rq_init_one_sg(rq, buf + VIRTNET_RX_PAD + xdp_headroom,
-			       vi->hdr_len + GOOD_PACKET_LEN);
+	buf += VIRTNET_RX_PAD + xdp_headroom;
+
+	virtnet_rq_init_one_sg(rq, buf, vi->hdr_len + GOOD_PACKET_LEN);
 
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0) {
-- 
2.43.0



