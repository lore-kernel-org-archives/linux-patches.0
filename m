Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB16746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE015C433C8;
	Sun, 17 Sep 2023 20:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983072;
	bh=ep9o6iEzAwIGsRM8e4QpC2fMicVo/vY4zMvHzTvnsEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmoBVCUkQIc4JIXfqzr/Ysbln+oH6bAhMTODO36wNupKH+3HPhdV7wcPGV3pnPb8k
	 LTQA/6vtlM/b4LwSt+Z+OL2rVZRe7gqwRqWmX91V3/i4q0Gps4gcmzeD3nFRfRMHgZ
	 Qy6aE/LnGocNokB/kUo8VIrRzfOl04squP5nLhCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Chen <liangchen.linux@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/511] veth: Fixing transmit return status for dropped packets
Date: Sun, 17 Sep 2023 21:14:23 +0200
Message-ID: <20230917191124.289090326@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Chen <liangchen.linux@gmail.com>

[ Upstream commit 151e887d8ff97e2e42110ffa1fb1e6a2128fb364 ]

The veth_xmit function returns NETDEV_TX_OK even when packets are dropped.
This behavior leads to incorrect calculations of statistics counts, as
well as things like txq->trans_start updates.

Fixes: e314dbdc1c0d ("[NET]: Virtual ethernet device driver.")
Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 45ee44f66e77d..984a153804096 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -320,6 +320,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
 	struct veth_rq *rq = NULL;
+	int ret = NETDEV_TX_OK;
 	struct net_device *rcv;
 	int length = skb->len;
 	bool use_napi = false;
@@ -352,6 +353,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	} else {
 drop:
 		atomic64_inc(&priv->dropped);
+		ret = NET_XMIT_DROP;
 	}
 
 	if (use_napi)
@@ -359,7 +361,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	rcu_read_unlock();
 
-	return NETDEV_TX_OK;
+	return ret;
 }
 
 static u64 veth_stats_tx(struct net_device *dev, u64 *packets, u64 *bytes)
-- 
2.40.1



