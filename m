Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB8315C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B49C433C1;
	Mon,  5 Dec 2022 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268407;
	bh=jgbrhVB6iKZ73bDIKKUWcIDILUAWQr4PlxV75jWpCqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRiJpwocQTsRFboeMt75gPzMGAtgZYrFVokplN2Caf117+OWVKNu8zPQQk9HnETTS
	 hA5kL/lJv4SPL8EbwmGLzDI+k8N74C3Urw0k+6VGx6Hp8nwu0QcWweoMbSALJsmlZ9
	 2cWca7uY0hXUiQLSaHOCHLaTp0VZFPNiq7tnh7Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 063/124] net: hsr: Fix potential use-after-free
Date: Mon,  5 Dec 2022 20:09:29 +0100
Message-Id: <20221205190810.213997828@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7e177d32442b7ed08a9fa61b61724abc548cb248 ]

The skb is delivered to netif_rx() which may free it, after calling this,
dereferencing skb may trigger use-after-free.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20221125075724.27912-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index a50429a62f74..56bb27d67a2e 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -351,17 +351,18 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 			       struct hsr_node *node_src)
 {
 	bool was_multicast_frame;
-	int res;
+	int res, recv_len;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
 	hsr_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
+	recv_len = skb->len;
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
 		dev->stats.rx_dropped++;
 	} else {
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += recv_len;
 		if (was_multicast_frame)
 			dev->stats.multicast++;
 	}
-- 
2.35.1



