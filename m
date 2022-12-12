Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC3228ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B3BC433A1;
	Mon, 12 Dec 2022 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852724;
	bh=MuJAwSJfvrhU9lo6p0DTqbkZyCIKxRlXbRZAP+ibNqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rlv249ZIyqat791pdqRjvb+7XCCTBQFD/qiU9EkX910/btR7ycYdSwfmphUzG+NFC
	 AZHdCOrO1An2M+feJA3KuE+NT19RT1ElWzsfvEHOO4JBmref9ZEnUUROrNxikeas22
	 315M9lN4Uqf/zVJ4s1gxhckUEQcAPUkv8Kz8Rj+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 139/157] net: hisilicon: Fix potential use-after-free in hix5hd2_rx()
Date: Mon, 12 Dec 2022 14:18:07 +0100
Message-Id: <20221212130940.676735808@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 433c07a13f59856e4585e89e86b7d4cc59348fab ]

The skb is delivered to napi_gro_receive() which may free it, after
calling this, dereferencing skb may trigger use-after-free.

Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://lore.kernel.org/r/20221203094240.1240211-2-liujian56@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index d7e62eca050f..b981b6cbe6ff 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -550,7 +550,7 @@ static int hix5hd2_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = dma_ring_incr(pos, RX_DESC_NUM);
 	}
-- 
2.35.1



