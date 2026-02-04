Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C65D27F163;
	Wed,  4 Feb 2026 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218935; cv=none; b=ooVu4OKk95SaH06h3lH31r2Keo63FUV20tHBPI927IZDX5FjO/HuLEpC71c64BXwqAfVjFbFSgfD1fFx5fMwO6UYgqHdcc/8RKgfJorEyCN1aHKBulmBXRKTcmMDzjHAjiCttlCc3+5sdFO+q/kWcCL6Wnv9m1UUAAkDapDXTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218935; c=relaxed/simple;
	bh=k0yY5ZAQbzF+ht4D5bwzTMGPKxj5eBfygvZYVjUp8q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuG8A8p2dYbcHZw1IRr6Jbyn1StoVkBlZBp4uKSXqNx09DvswiiNizRLfzFCIgsN2Tnf3lvZ5e10cmFk0rBUYjJWWN6VKAOopQm4OrEI1Xe/vvyj7R/zaCgIU8mIolXRXPMZ9u9BxrngiMkq2iI5QrFsSGWjGe/uAP9W3tLouNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o92nHtav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o92nHtav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2DFC4CEF7;
	Wed,  4 Feb 2026 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218935;
	bh=k0yY5ZAQbzF+ht4D5bwzTMGPKxj5eBfygvZYVjUp8q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o92nHtavfVm0Q9HlcVEhgw+zqlg5UetAX3BXW/w52V2LxYJ3C+q6ji4a/U7WnhdU5
	 mHSCpZEa+RAWZ1kn9V0ZXcqVYqRy6fQSX6lkzBU0kYjC9Xbt1BeO9M0NjSrcMgDN+0
	 6Yav+TNvPAwZ4SJ1JB8g/6BxEKX0WprcW3VE35t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/122] net: spacemit: Check for netif_carrier_ok() in emac_stats_update()
Date: Wed,  4 Feb 2026 15:40:00 +0100
Message-ID: <20260204143852.522778230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

[ Upstream commit 2c84959167d6493dbdac88965c7389b8ab88bf4e ]

Some PHYs stop the refclk for power saving, usually while link down.
This causes reading stats to time out.

Therefore, in emac_stats_update(), also don't update and reschedule if
!netif_carrier_ok(). But that means we could be missing later updates if
the link comes back up, so also reschedule when link up is detected in
emac_adjust_link().

While we're at it, improve the comments and error message prints around
this to reflect the better understanding of how this could happen.
Hopefully if this happens again on new hardware, these comments will
direct towards a solution.

Closes: https://lore.kernel.org/r/20260119141620.1318102-1-amadeus@jmu.edu.cn/
Fixes: bfec6d7f2001 ("net: spacemit: Add K1 Ethernet MAC")
Co-developed-by: Chukun Pan <amadeus@jmu.edu.cn>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://patch.msgid.link/20260123-k1-ethernet-clarify-stat-timeout-v3-1-93b9df627e87@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/spacemit/k1_emac.c | 34 ++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/spacemit/k1_emac.c b/drivers/net/ethernet/spacemit/k1_emac.c
index 220eb5ce75833..88e9424d2d51a 100644
--- a/drivers/net/ethernet/spacemit/k1_emac.c
+++ b/drivers/net/ethernet/spacemit/k1_emac.c
@@ -1099,7 +1099,13 @@ static int emac_read_stat_cnt(struct emac_priv *priv, u8 cnt, u32 *res,
 					100, 10000);
 
 	if (ret) {
-		netdev_err(priv->ndev, "Read stat timeout\n");
+		/*
+		 * This could be caused by the PHY stopping its refclk even when
+		 * the link is up, for power saving. See also comments in
+		 * emac_stats_update().
+		 */
+		dev_err_ratelimited(&priv->ndev->dev,
+				    "Read stat timeout. PHY clock stopped?\n");
 		return ret;
 	}
 
@@ -1147,17 +1153,25 @@ static void emac_stats_update(struct emac_priv *priv)
 
 	assert_spin_locked(&priv->stats_lock);
 
-	if (!netif_running(priv->ndev) || !netif_device_present(priv->ndev)) {
-		/* Not up, don't try to update */
+	/*
+	 * We can't read statistics if the interface is not up. Also, some PHYs
+	 * stop their reference clocks for link down power saving, which also
+	 * causes reading statistics to time out. Don't update and don't
+	 * reschedule in these cases.
+	 */
+	if (!netif_running(priv->ndev) ||
+	    !netif_carrier_ok(priv->ndev) ||
+	    !netif_device_present(priv->ndev)) {
 		return;
 	}
 
 	for (i = 0; i < sizeof(priv->tx_stats) / sizeof(*tx_stats); i++) {
 		/*
-		 * If reading stats times out, everything is broken and there's
-		 * nothing we can do. Reading statistics also can't return an
-		 * error, so just return without updating and without
-		 * rescheduling.
+		 * If reading stats times out anyway, the stat registers will be
+		 * stuck, and we can't really recover from that.
+		 *
+		 * Reading statistics also can't return an error, so just return
+		 * without updating and without rescheduling.
 		 */
 		if (emac_tx_read_stat_cnt(priv, i, &res))
 			return;
@@ -1636,6 +1650,12 @@ static void emac_adjust_link(struct net_device *dev)
 		emac_wr(priv, MAC_GLOBAL_CONTROL, ctrl);
 
 		emac_set_fc_autoneg(priv);
+
+		/*
+		 * Reschedule stats updates now that link is up. See comments in
+		 * emac_stats_update().
+		 */
+		mod_timer(&priv->stats_timer, jiffies);
 	}
 
 	phy_print_status(phydev);
-- 
2.51.0



