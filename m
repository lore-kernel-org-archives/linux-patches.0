Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E5B2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D17C433EF;
	Mon, 24 Apr 2023 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343450;
	bh=REqJYWlMCIS7fJnM1DMlkQaOUiZrzC1luppUoq9mQr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYUtld9ujZm8pLbLP0jn+tNvkRHGasjooIhFE6y8Jdt2xNR3M4Msm4r8t8T385UcP
	 CMIWRXE36oA/3f0ppHRsknjmL4XGrQf7y1V0rx83nUg3Eq0qj+lHMTWsYppzNVskpy
	 oWNZkMdMVkJ2fqoMGCKPuJSnkTY1v2+eOLRjTOI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/28] virtio_net: bugfix overflow inside xdp_linearize_page()
Date: Mon, 24 Apr 2023 15:18:24 +0200
Message-Id: <20230424131121.434414819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 853618d5886bf94812f31228091cd37d308230f7 ]

Here we copy the data from the original buf to the new page. But we
not check that it may be overflow.

As long as the size received(including vnethdr) is greater than 3840
(PAGE_SIZE -VIRTIO_XDP_HEADROOM). Then the memcpy will overflow.

And this is completely possible, as long as the MTU is large, such
as 4096. In our test environment, this will cause crash. Since crash is
caused by the written memory, it is meaningless, so I do not include it.

Fixes: 72979a6c3590 ("virtio_net: xdp, add slowpath case for non contiguous buffers")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9e18389309cf4..067ebdd0d5898 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -452,8 +452,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       int page_off,
 				       unsigned int *len)
 {
-	struct page *page = alloc_page(GFP_ATOMIC);
+	int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	struct page *page;
 
+	if (page_off + *len + tailroom > PAGE_SIZE)
+		return NULL;
+
+	page = alloc_page(GFP_ATOMIC);
 	if (!page)
 		return NULL;
 
-- 
2.39.2



