Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93724142903;
	Mon, 16 Sep 2024 12:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488746; cv=none; b=MeWD8WJ+GM0OTmFexk/6M30qYmk+/Uszg0Wgw+C8MR+5y0vuOGZTtvqVeBcEYp2CIRCYJ0KFi2Wqu6hrvEhpoA5vvAMWiwcFRb5n6PZ5JPvJV9LKTi85UBB2r5Y0YqYQIA8pTurGSPtM+bZuFteieNpwCrCjpNSahWP3LBwq7OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488746; c=relaxed/simple;
	bh=1vNq0UqHhXFbvgLAXpZJOEqW9PnZPnMzF0dnbyHXHuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2fTV9SXEwSgOx4h8XZC88nhKTYhZquDBJWNENJz6VH9n4PQXrYcnEftOVVG+XTMg0Cqp75zoKpICH6m039UFRm+lmxDp9Pe/d+uLiPedUbPtAh6Ft8w+A2pp0FWqTGjXTSFGagrYboLmfQGkgR7bOtMJCeyZt0j7elvtcvdSPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLgEQJiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLgEQJiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9D3C4CEC4;
	Mon, 16 Sep 2024 12:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488746;
	bh=1vNq0UqHhXFbvgLAXpZJOEqW9PnZPnMzF0dnbyHXHuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLgEQJiZWTwDG0OttbNkoMmwO2AM3p2suSlBFmNLcd0abbUEvJMLeTmYdu24m60DP
	 DpsewcyPm7/+r2YpCV0clQyb/wtwRQJjrRLeVDaDywdoH0ySTQ7UviBBnx8/hkdl4R
	 sXMLyj8WRtkOxAdbbwI1na6aLVGgKeF2eWcU+kbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 75/91] net: dpaa: Pad packets to ETH_ZLEN
Date: Mon, 16 Sep 2024 13:44:51 +0200
Message-ID: <20240916114226.948858791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit cbd7ec083413c6a2e0c326d49e24ec7d12c7a9e0 ]

When sending packets under 60 bytes, up to three bytes of the buffer
following the data may be leaked. Avoid this by extending all packets to
ETH_ZLEN, ensuring nothing is leaked in the padding. This bug can be
reproduced by running

	$ ping -s 11 destination

Fixes: 9ad1a3749333 ("dpaa_eth: add support for DPAA Ethernet")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240910143144.1439910-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c6a3eefd83bf..e7bf70ac9a4c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2285,12 +2285,12 @@ static netdev_tx_t
 dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 {
 	const int queue_mapping = skb_get_queue_mapping(skb);
-	bool nonlinear = skb_is_nonlinear(skb);
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa_percpu_priv *percpu_priv;
 	struct netdev_queue *txq;
 	struct dpaa_priv *priv;
 	struct qm_fd fd;
+	bool nonlinear;
 	int offset = 0;
 	int err = 0;
 
@@ -2300,6 +2300,13 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 
 	qm_fd_clear_fd(&fd);
 
+	/* Packet data is always read as 32-bit words, so zero out any part of
+	 * the skb which might be sent if we have to pad the packet
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN, false))
+		goto enomem;
+
+	nonlinear = skb_is_nonlinear(skb);
 	if (!nonlinear) {
 		/* We're going to store the skb backpointer at the beginning
 		 * of the data buffer, so we need a privately owned skb
-- 
2.43.0



