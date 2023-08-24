Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AA81119B
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF480C433C8;
	Thu, 24 Aug 2023 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888716;
	bh=kWXTsv7iyrS2Ml3sPeipN7Lr91g9q3u3V3+Q8muoqzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIYgpt4CHOVuqm5KXuXaGS+a4ubL+Oecl96i9+g7Hpx2dBm7hAUUwCau3zkPQavPx
	 f4uKxOXD29ru7XJU7tZ54Zws6MOzXHGePrXC8aUNzMe64PXsYll14inamOgwxhnZQj
	 mCFXY7Dz3UWXAVguqIFZuC+eI8mjLWDJh62+xcDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/139] macsec: use DEV_STATS_INC()
Date: Thu, 24 Aug 2023 16:48:48 +0200
Message-ID: <20230824145023.813418867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 32d0a49d36a2a306c2e47fe5659361e424f0ed3f ]

syzbot/KCSAN reported data-races in macsec whenever dev->stats fields
are updated.

It appears all of these updates can happen from multiple cpus.

Adopt SMP safe DEV_STATS_INC() to update dev->stats fields.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e7af0e7a29678..98ce24422424c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -761,7 +761,7 @@ static bool macsec_post_decrypt(struct sk_buff *skb, struct macsec_secy *secy, u
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsLate++;
 		u64_stats_update_end(&rxsc_stats->syncp);
-		secy->netdev->stats.rx_dropped++;
+		DEV_STATS_INC(secy->netdev, rx_dropped);
 		return false;
 	}
 
@@ -785,7 +785,7 @@ static bool macsec_post_decrypt(struct sk_buff *skb, struct macsec_secy *secy, u
 			rxsc_stats->stats.InPktsNotValid++;
 			u64_stats_update_end(&rxsc_stats->syncp);
 			this_cpu_inc(rx_sa->stats->InPktsNotValid);
-			secy->netdev->stats.rx_errors++;
+			DEV_STATS_INC(secy->netdev, rx_errors);
 			return false;
 		}
 
@@ -1071,7 +1071,7 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoTag++;
 			u64_stats_update_end(&secy_stats->syncp);
-			macsec->secy.netdev->stats.rx_dropped++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 			continue;
 		}
 
@@ -1181,7 +1181,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		u64_stats_update_begin(&secy_stats->syncp);
 		secy_stats->stats.InPktsBadTag++;
 		u64_stats_update_end(&secy_stats->syncp);
-		secy->netdev->stats.rx_errors++;
+		DEV_STATS_INC(secy->netdev, rx_errors);
 		goto drop_nosa;
 	}
 
@@ -1198,7 +1198,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsNotUsingSA++;
 			u64_stats_update_end(&rxsc_stats->syncp);
-			secy->netdev->stats.rx_errors++;
+			DEV_STATS_INC(secy->netdev, rx_errors);
 			if (active_rx_sa)
 				this_cpu_inc(active_rx_sa->stats->InPktsNotUsingSA);
 			goto drop_nosa;
@@ -1232,7 +1232,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsLate++;
 			u64_stats_update_end(&rxsc_stats->syncp);
-			macsec->secy.netdev->stats.rx_dropped++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 			goto drop;
 		}
 	}
@@ -1273,7 +1273,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, len);
 	else
-		macsec->secy.netdev->stats.rx_dropped++;
+		DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 
 	rcu_read_unlock();
 
@@ -1310,7 +1310,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoSCI++;
 			u64_stats_update_end(&secy_stats->syncp);
-			macsec->secy.netdev->stats.rx_errors++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_errors);
 			continue;
 		}
 
@@ -1329,7 +1329,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 			secy_stats->stats.InPktsUnknownSCI++;
 			u64_stats_update_end(&secy_stats->syncp);
 		} else {
-			macsec->secy.netdev->stats.rx_dropped++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 		}
 	}
 
@@ -3438,7 +3438,7 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 
 	if (!secy->operational) {
 		kfree_skb(skb);
-		dev->stats.tx_dropped++;
+		DEV_STATS_INC(dev, tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -3446,7 +3446,7 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	skb = macsec_encrypt(skb, dev);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EINPROGRESS)
-			dev->stats.tx_dropped++;
+			DEV_STATS_INC(dev, tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -3680,9 +3680,9 @@ static void macsec_get_stats64(struct net_device *dev,
 
 	dev_fetch_sw_netstats(s, dev->tstats);
 
-	s->rx_dropped = dev->stats.rx_dropped;
-	s->tx_dropped = dev->stats.tx_dropped;
-	s->rx_errors = dev->stats.rx_errors;
+	s->rx_dropped = atomic_long_read(&dev->stats.__rx_dropped);
+	s->tx_dropped = atomic_long_read(&dev->stats.__tx_dropped);
+	s->rx_errors = atomic_long_read(&dev->stats.__rx_errors);
 }
 
 static int macsec_get_iflink(const struct net_device *dev)
-- 
2.40.1



