Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077383568E7;
	Tue, 26 Aug 2025 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217032; cv=none; b=llk+rh3bJwo+azPgPvXb5Ha4XbWbwb+xjVxkf+1+Q9dmN3+qgNEibne4kP0HVKHyrOJNy/3PXh/DcrlzznCEw02M7uGiTue71LyzDZ314056LxiSbfflqHfg0rf0SN8kVOf6OdyKN/wPmSHnZCet3e2D3WUZb9aeybjxvsNY+WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217032; c=relaxed/simple;
	bh=pcpq0dUwiy/mmFeDzJHn+GcKl3/8qSqpxQMGMPMfytc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1np3aDFjCTSVhN8QeqgdTkaCqbAOeTJ+0jwpLTtGdnLTLqKm7DUEFCxZgvIACpVM+uCi01xpIvp4/Wr+R4q+WWWTxVuETpWuztfzuasukxIV+uSLRSALJ9lANzB78t7USCF6zro5qF47WPEp+dv6kMUuICbHQU6fEEWIYnHwEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voyw55rJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voyw55rJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FF0C4CEF1;
	Tue, 26 Aug 2025 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217031;
	bh=pcpq0dUwiy/mmFeDzJHn+GcKl3/8qSqpxQMGMPMfytc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voyw55rJiyQQPk5v95MbvcCp+QWAWXesKWaiqwjHxuQoPIRw8EGzuFItrH65q9FxZ
	 /syY6HpTJHKRTK2ppWTjyS3E8LNGnL/h72TaBNOLhjBDLeBQj+j2ZGaiKfQV+iPJa0
	 dkQhOwplKKemmxOYJklBikqBaeLCnEQfq9VYdUqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 632/644] net: phy: Use netif_rx().
Date: Tue, 26 Aug 2025 13:12:03 +0200
Message-ID: <20250826111002.220162843@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a3d73e15909bdcf25f341e6623cc165ba7eb5968 ]

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc1a59cff9f7 ("phy: mscc: Fix timestamping for vsc8584")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83640.c         | 6 +++---
 drivers/net/phy/mscc/mscc_ptp.c   | 2 +-
 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 705c16675b80..88d23890f3be 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -886,7 +886,7 @@ static void decode_rxts(struct dp83640_private *dp83640,
 	spin_unlock_irqrestore(&dp83640->rx_lock, flags);
 
 	if (shhwtstamps)
-		netif_rx_ni(skb);
+		netif_rx(skb);
 }
 
 static void decode_txts(struct dp83640_private *dp83640,
@@ -1332,7 +1332,7 @@ static void rx_timestamp_work(struct work_struct *work)
 			break;
 		}
 
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 
 	if (!skb_queue_empty(&dp83640->rx_queue))
@@ -1383,7 +1383,7 @@ static bool dp83640_rxtstamp(struct mii_timestamper *mii_ts,
 		skb_queue_tail(&dp83640->rx_queue, skb);
 		schedule_delayed_work(&dp83640->ts_work, SKB_TIMESTAMP_TIMEOUT);
 	} else {
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 
 	return true;
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 92f59c964409..cf61990ccd37 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1218,7 +1218,7 @@ static bool vsc85xx_rxtstamp(struct mii_timestamper *mii_ts,
 		ts.tv_sec--;
 
 	shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ns);
-	netif_rx_ni(skb);
+	netif_rx(skb);
 
 	return true;
 }
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 13269c4e87dd..e6ac851b217a 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -436,7 +436,7 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		shhwtstamps_rx = skb_hwtstamps(skb);
 		shhwtstamps_rx->hwtstamp = ns_to_ktime(timespec64_to_ns(&ts));
 		NXP_C45_SKB_CB(skb)->header->reserved2 = 0;
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 
 	return reschedule ? 1 : -1;
-- 
2.50.1



