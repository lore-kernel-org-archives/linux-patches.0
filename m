Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4B227F4C7;
	Mon, 18 Aug 2025 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525530; cv=none; b=nKEsBW2Nuy7wfvVXkGbuoeF8Ix79xXUjpY0cW/NDxy/ZebMpRim25qUSt80IvspBo2IER10hYV1SCFqtWyHukD00UwAL//M2oArWy8RkFbR9rP0hoAbwWYtwgTAnT+A0vCqKfx6Xj8uPgm2jD/JXcOSHgiJ9N0Z4AVLUFhotx6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525530; c=relaxed/simple;
	bh=IbG9LtWLRcKhnlDTBjMaoa/Wbp/Tou++ziugwNK53Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gg8JkBTgjeOZyAuIebqAKM/QjuGLiTv/Ura0veTQj4vrarqvIYFYThgPUEIo257nXdk8hfIBTfWY/5EfcRjp6RRkM91AiVERcnRIuEFnoOU2KA9iixOL69Rc//Kh5hVDKP6JjeTJdzD6K2EldsA6iK57MoMP/W6k203ubFWX4go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/Db/7AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/Db/7AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA44CC4CEEB;
	Mon, 18 Aug 2025 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525530;
	bh=IbG9LtWLRcKhnlDTBjMaoa/Wbp/Tou++ziugwNK53Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/Db/7ABx9Eswj0BsvsSMnyFnES13PKEzklCIRxWZ1tmh9yTAqKmdDVgnR3Ot+EZ+
	 HCSYq3V9Z5s4j7ykMxq+YiKb7BI29bO1BlQyfJo1PIamd/Kmx89Jvztth4++xqutQ8
	 ZpB6YhKEBTW4lYuwFZClNpNT8hL90B0brZMFsPkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Rebmann <jre@pengutronix.de>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 290/570] net: fec: allow disable coalescing
Date: Mon, 18 Aug 2025 14:44:37 +0200
Message-ID: <20250818124517.013334515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Rebmann <jre@pengutronix.de>

[ Upstream commit b7ad21258f9e9a7f58b19595d5ceed2cde3bed68 ]

In the current implementation, IP coalescing is always enabled and
cannot be disabled.

As setting maximum frames to 0 or 1, or setting delay to zero implies
immediate delivery of single packets/IRQs, disable coalescing in
hardware in these cases.

This also guarantees that coalescing is never enabled with ICFT or ICTT
set to zero, a configuration that could lead to unpredictable behaviour
according to i.MX8MP reference manual.

Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250626-fec_deactivate_coalescing-v2-1-0b217f2e80da@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 34 +++++++++++------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 17e9bddb9ddd..651b73163b6e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3124,27 +3124,25 @@ static int fec_enet_us_to_itr_clock(struct net_device *ndev, int us)
 static void fec_enet_itr_coal_set(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	int rx_itr, tx_itr;
+	u32 rx_itr = 0, tx_itr = 0;
+	int rx_ictt, tx_ictt;
 
-	/* Must be greater than zero to avoid unpredictable behavior */
-	if (!fep->rx_time_itr || !fep->rx_pkts_itr ||
-	    !fep->tx_time_itr || !fep->tx_pkts_itr)
-		return;
-
-	/* Select enet system clock as Interrupt Coalescing
-	 * timer Clock Source
-	 */
-	rx_itr = FEC_ITR_CLK_SEL;
-	tx_itr = FEC_ITR_CLK_SEL;
+	rx_ictt = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
+	tx_ictt = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
 
-	/* set ICFT and ICTT */
-	rx_itr |= FEC_ITR_ICFT(fep->rx_pkts_itr);
-	rx_itr |= FEC_ITR_ICTT(fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr));
-	tx_itr |= FEC_ITR_ICFT(fep->tx_pkts_itr);
-	tx_itr |= FEC_ITR_ICTT(fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr));
+	if (rx_ictt > 0 && fep->rx_pkts_itr > 1) {
+		/* Enable with enet system clock as Interrupt Coalescing timer Clock Source */
+		rx_itr = FEC_ITR_EN | FEC_ITR_CLK_SEL;
+		rx_itr |= FEC_ITR_ICFT(fep->rx_pkts_itr);
+		rx_itr |= FEC_ITR_ICTT(rx_ictt);
+	}
 
-	rx_itr |= FEC_ITR_EN;
-	tx_itr |= FEC_ITR_EN;
+	if (tx_ictt > 0 && fep->tx_pkts_itr > 1) {
+		/* Enable with enet system clock as Interrupt Coalescing timer Clock Source */
+		tx_itr = FEC_ITR_EN | FEC_ITR_CLK_SEL;
+		tx_itr |= FEC_ITR_ICFT(fep->tx_pkts_itr);
+		tx_itr |= FEC_ITR_ICTT(tx_ictt);
+	}
 
 	writel(tx_itr, fep->hwp + FEC_TXIC0);
 	writel(rx_itr, fep->hwp + FEC_RXIC0);
-- 
2.39.5



