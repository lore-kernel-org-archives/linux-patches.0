Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BEC11707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80C7C433C7;
	Mon, 21 Aug 2023 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647555;
	bh=kOV8X/1pUNLPG6/JsJglTS8HZWoVyfmvhamuRIRx/ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIVPc8j/62xCeCIq7wGzUZn2ulncU8of0j1zk22/HGVye/NjRSg8/T4ZB6gfVRdKa
	 2iTny9fZfsv9azJJfGdVBQVwQ6gpSrGeUVUbc8lD7hqZ86Ixs9CwAVW/ixmALE0rlU
	 CW6NMzqKPHHBCuZGaZ6u1VWuxvG8oQI4iL4bBJ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/194] firewire: net: fix use after free in fwnet_finish_incoming_packet()
Date: Mon, 21 Aug 2023 21:40:34 +0200
Message-ID: <20230821194125.197999854@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 3ff256751a2853e1ffaa36958ff933ccc98c6cb5 ]

The netif_rx() function frees the skb so we can't dereference it to
save the skb->len.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Link: https://lore.kernel.org/r/tencent_3B3D24B66ED66A6BB73CC0E63C6A14E45109@qq.com
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index af22be84034bb..a53eacebca339 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -479,7 +479,7 @@ static int fwnet_finish_incoming_packet(struct net_device *net,
 					struct sk_buff *skb, u16 source_node_id,
 					bool is_broadcast, u16 ether_type)
 {
-	int status;
+	int status, len;
 
 	switch (ether_type) {
 	case ETH_P_ARP:
@@ -533,13 +533,15 @@ static int fwnet_finish_incoming_packet(struct net_device *net,
 		}
 		skb->protocol = protocol;
 	}
+
+	len = skb->len;
 	status = netif_rx(skb);
 	if (status == NET_RX_DROP) {
 		net->stats.rx_errors++;
 		net->stats.rx_dropped++;
 	} else {
 		net->stats.rx_packets++;
-		net->stats.rx_bytes += skb->len;
+		net->stats.rx_bytes += len;
 	}
 
 	return 0;
-- 
2.40.1



