Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A219446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4C5C433C7;
	Sun, 13 Aug 2023 21:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962601;
	bh=db3rPmon8gVmUXodyZj5rzdTR3LPjG9FuIJHR+2X23o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnrHVuwIlQhssWOsrg4Lx26Q1eq/tlfNcGUT/YeOEIdgSVPjKgWoZh0mtQH+Kf3tA
	 THkghfiNdqXLQyUdEucieAdFwGudSWNJLxRXfjtW0mrB3M6xpSUaOopUebKpCnbbI3
	 9+XLV0sCkCmF6gMGuxL7DvUHbJeK0eBV8C8uNU80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 087/149] macsec: use DEV_STATS_INC()
Date: Sun, 13 Aug 2023 23:18:52 +0200
Message-ID: <20230813211721.391417435@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
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

commit 32d0a49d36a2a306c2e47fe5659361e424f0ed3f upstream.

syzbot/KCSAN reported data-races in macsec whenever dev->stats fields
are updated.

It appears all of these updates can happen from multiple cpus.

Adopt SMP safe DEV_STATS_INC() to update dev->stats fields.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -743,7 +743,7 @@ static bool macsec_post_decrypt(struct s
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsLate++;
 		u64_stats_update_end(&rxsc_stats->syncp);
-		secy->netdev->stats.rx_dropped++;
+		DEV_STATS_INC(secy->netdev, rx_dropped);
 		return false;
 	}
 
@@ -767,7 +767,7 @@ static bool macsec_post_decrypt(struct s
 			rxsc_stats->stats.InPktsNotValid++;
 			u64_stats_update_end(&rxsc_stats->syncp);
 			this_cpu_inc(rx_sa->stats->InPktsNotValid);
-			secy->netdev->stats.rx_errors++;
+			DEV_STATS_INC(secy->netdev, rx_errors);
 			return false;
 		}
 
@@ -1059,7 +1059,7 @@ static enum rx_handler_result handle_not
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoTag++;
 			u64_stats_update_end(&secy_stats->syncp);
-			macsec->secy.netdev->stats.rx_dropped++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 			continue;
 		}
 
@@ -1169,7 +1169,7 @@ static rx_handler_result_t macsec_handle
 		u64_stats_update_begin(&secy_stats->syncp);
 		secy_stats->stats.InPktsBadTag++;
 		u64_stats_update_end(&secy_stats->syncp);
-		secy->netdev->stats.rx_errors++;
+		DEV_STATS_INC(secy->netdev, rx_errors);
 		goto drop_nosa;
 	}
 
@@ -1186,7 +1186,7 @@ static rx_handler_result_t macsec_handle
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsNotUsingSA++;
 			u64_stats_update_end(&rxsc_stats->syncp);
-			secy->netdev->stats.rx_errors++;
+			DEV_STATS_INC(secy->netdev, rx_errors);
 			if (active_rx_sa)
 				this_cpu_inc(active_rx_sa->stats->InPktsNotUsingSA);
 			goto drop_nosa;
@@ -1220,7 +1220,7 @@ static rx_handler_result_t macsec_handle
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsLate++;
 			u64_stats_update_end(&rxsc_stats->syncp);
-			macsec->secy.netdev->stats.rx_dropped++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 			goto drop;
 		}
 	}
@@ -1261,7 +1261,7 @@ deliver:
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, len);
 	else
-		macsec->secy.netdev->stats.rx_dropped++;
+		DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 
 	rcu_read_unlock();
 
@@ -1298,7 +1298,7 @@ nosci:
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoSCI++;
 			u64_stats_update_end(&secy_stats->syncp);
-			macsec->secy.netdev->stats.rx_errors++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_errors);
 			continue;
 		}
 
@@ -1317,7 +1317,7 @@ nosci:
 			secy_stats->stats.InPktsUnknownSCI++;
 			u64_stats_update_end(&secy_stats->syncp);
 		} else {
-			macsec->secy.netdev->stats.rx_dropped++;
+			DEV_STATS_INC(macsec->secy.netdev, rx_dropped);
 		}
 	}
 
@@ -3418,7 +3418,7 @@ static netdev_tx_t macsec_start_xmit(str
 
 	if (!secy->operational) {
 		kfree_skb(skb);
-		dev->stats.tx_dropped++;
+		DEV_STATS_INC(dev, tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -3426,7 +3426,7 @@ static netdev_tx_t macsec_start_xmit(str
 	skb = macsec_encrypt(skb, dev);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EINPROGRESS)
-			dev->stats.tx_dropped++;
+			DEV_STATS_INC(dev, tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -3663,9 +3663,9 @@ static void macsec_get_stats64(struct ne
 
 	dev_fetch_sw_netstats(s, dev->tstats);
 
-	s->rx_dropped = dev->stats.rx_dropped;
-	s->tx_dropped = dev->stats.tx_dropped;
-	s->rx_errors = dev->stats.rx_errors;
+	s->rx_dropped = atomic_long_read(&dev->stats.__rx_dropped);
+	s->tx_dropped = atomic_long_read(&dev->stats.__tx_dropped);
+	s->rx_errors = atomic_long_read(&dev->stats.__rx_errors);
 }
 
 static int macsec_get_iflink(const struct net_device *dev)


