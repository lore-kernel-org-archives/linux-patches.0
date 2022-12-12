Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBB028ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EDAC433D2;
	Mon, 12 Dec 2022 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851419;
	bh=CnRkUS4S95xPAzuq73j9vWu4RVwIL80gu1eQlJViyyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+gU7slHYaSik8++eP52lKAD236WWN/80tvX7m8OYwwJbwX+tPgbn4nw4FhDrSXJY
	 dwK0O2tWlq4SANB3StZddEjmJgUiAkVirviNVEi0zOqrZn5efJUvLtlyoj0vI3Kdu0
	 5gW5IdP/bkxUQ7wOmkI6BTN4l3yi1Xi4msvErE9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 58/67] net: hisilicon: Fix potential use-after-free in hix5hd2_rx()
Date: Mon, 12 Dec 2022 14:17:33 +0100
Message-Id: <20221212130920.386025659@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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
index c41b19c760f8..645cae590dc4 100644
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



