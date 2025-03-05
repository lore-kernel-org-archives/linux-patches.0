Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2EB14884C;
	Wed,  5 Mar 2025 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197595; cv=none; b=BtGSb8+a7CDvgvZxvU3pL3Bz2lkQSo4sqtAGeBxFj+c5+G3SES5wZqfpHKKQUQmnNsY2hP5ChRSHXNImbdhD/giiU/QvfqcZgF1BkVfk9X8YUaZnbNiLGb4yFQY1swsjoEgP124brCh7nIHpn6tncJ5tPBjeuAadbb5Q0HbGd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197595; c=relaxed/simple;
	bh=c8mHP7Yk9L5X1kLnRJTs5uv/aB1oZyuajacj6L48ImI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkWm6ENEUZ6IvDnGP4uIbw+f4HavEAgElusbERVBcQf3agG8izlpXs7qV4Ndz9kxrlgBemF27CNStgmvMvBNcKGVOOxHO8gswggjwDOC/PshpNHg9iFJCY0r+WkNfGAAz+z6tjic0yNvd7hR6iQKZFOKe94TZ0zD9WpbC44FnOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We6SlWpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We6SlWpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C00C4CEE9;
	Wed,  5 Mar 2025 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197594;
	bh=c8mHP7Yk9L5X1kLnRJTs5uv/aB1oZyuajacj6L48ImI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=We6SlWpZADntlclTKyDUxSt8NvairebBzoF7iTn519Zlu+YpICYWYDBVnohemhiNM
	 9ubTQoyPdZCPPa8t3iqz8uQwQBRFnqAzDvHtLbm9p/4LmCZaFaY0DdV/GdQWI2dKjc
	 HubvImsjbLlxZ1glKXXj4LJz8pEet73fo1vJ6g+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/142] net: cadence: macb: Synchronize stats calculations
Date: Wed,  5 Mar 2025 18:47:31 +0100
Message-ID: <20250305174501.630033536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit fa52f15c745ce55261b92873676f64f7348cfe82 ]

Stats calculations involve a RMW to add the stat update to the existing
value. This is currently not protected by any synchronization mechanism,
so data races are possible. Add a spinlock to protect the update. The
reader side could be protected using u64_stats, but we would still need
a spinlock for the update side anyway. And we always do an update
immediately before reading the stats anyway.

Fixes: 89e5785fc8a6 ("[PATCH] Atmel MACB ethernet driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20250220162950.95941-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.h      |  2 ++
 drivers/net/ethernet/cadence/macb_main.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 78c972bb1d962..9fb5a18e056d4 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1270,6 +1270,8 @@ struct macb {
 	struct clk		*rx_clk;
 	struct clk		*tsu_clk;
 	struct net_device	*dev;
+	/* Protects hw_stats and ethtool_stats */
+	spinlock_t		stats_lock;
 	union {
 		struct macb_stats	macb;
 		struct gem_stats	gem;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 8f61731e4554b..4325d0ace1f26 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1992,10 +1992,12 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 
 		if (status & MACB_BIT(ISR_ROVR)) {
 			/* We missed at least one packet */
+			spin_lock(&bp->stats_lock);
 			if (macb_is_gem(bp))
 				bp->hw_stats.gem.rx_overruns++;
 			else
 				bp->hw_stats.macb.rx_overruns++;
+			spin_unlock(&bp->stats_lock);
 
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 				queue_writel(queue, ISR, MACB_BIT(ISR_ROVR));
@@ -3084,6 +3086,7 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	if (!netif_running(bp->dev))
 		return nstat;
 
+	spin_lock_irq(&bp->stats_lock);
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
@@ -3113,6 +3116,7 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	nstat->tx_aborted_errors = hwstat->tx_excessive_collisions;
 	nstat->tx_carrier_errors = hwstat->tx_carrier_sense_errors;
 	nstat->tx_fifo_errors = hwstat->tx_underrun;
+	spin_unlock_irq(&bp->stats_lock);
 
 	return nstat;
 }
@@ -3120,12 +3124,13 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 static void gem_get_ethtool_stats(struct net_device *dev,
 				  struct ethtool_stats *stats, u64 *data)
 {
-	struct macb *bp;
+	struct macb *bp = netdev_priv(dev);
 
-	bp = netdev_priv(dev);
+	spin_lock_irq(&bp->stats_lock);
 	gem_update_stats(bp);
 	memcpy(data, &bp->ethtool_stats, sizeof(u64)
 			* (GEM_STATS_LEN + QUEUE_STATS_LEN * MACB_MAX_QUEUES));
+	spin_unlock_irq(&bp->stats_lock);
 }
 
 static int gem_get_sset_count(struct net_device *dev, int sset)
@@ -3175,6 +3180,7 @@ static struct net_device_stats *macb_get_stats(struct net_device *dev)
 		return gem_get_stats(bp);
 
 	/* read stats from hardware */
+	spin_lock_irq(&bp->stats_lock);
 	macb_update_stats(bp);
 
 	/* Convert HW stats into netdevice stats */
@@ -3208,6 +3214,7 @@ static struct net_device_stats *macb_get_stats(struct net_device *dev)
 	nstat->tx_carrier_errors = hwstat->tx_carrier_errors;
 	nstat->tx_fifo_errors = hwstat->tx_underruns;
 	/* Don't know about heartbeat or window errors... */
+	spin_unlock_irq(&bp->stats_lock);
 
 	return nstat;
 }
@@ -5063,6 +5070,7 @@ static int macb_probe(struct platform_device *pdev)
 		}
 	}
 	spin_lock_init(&bp->lock);
+	spin_lock_init(&bp->stats_lock);
 
 	/* setup capabilities */
 	macb_configure_caps(bp, macb_config);
-- 
2.39.5



