Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC471AF0AD;
	Tue, 15 Oct 2024 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996875; cv=none; b=g9KAqyVflBdXt1Er6cFkGAZ4JrePPwnpX/A6doN5ofGfHkJa4eZUqwqYLviSdgKtznkbwrnkv9smz9qrT5v8dGCqLCjIeiXb2w/WEwis+gvLSG5vGqPF9R/Y+Eakn8UGlFTWSDtc2JXhwSeK1cwGWks7yRruafd24rmdakV3neo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996875; c=relaxed/simple;
	bh=sHHAf61EY0euac4ymZO70Zd1EBo2SgmKftgYK5To2RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnL2XH57ufw79Tj4K6UNkohXgQbWuJG9ycOutB5RcduydpGz6bjDrfHM372cKJ+7rC512S9LK8SZzKSfuT64wb12A/v6dY2mMHYklj1WAZVR2hjwpPXf7Y1ebXTFaUGDDEDnTTT/HkfGq8VXkxSrRxl61K9ixfOn/Fdf5oOUNqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExhXXw4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExhXXw4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C3C4CEC6;
	Tue, 15 Oct 2024 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996875;
	bh=sHHAf61EY0euac4ymZO70Zd1EBo2SgmKftgYK5To2RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExhXXw4sLmsD1pWupHjbvT6MI2uwqYgD0gTm0/4IsWYF5JdWKJrpt1Q+YHJWm39IH
	 bPZp5T8paSAiZ4RpxwN40UrMg9uVc05xrdLQayR+rSW9fKqj+vOMp3GH2sQZ9V/O/9
	 oLk26VPt94GiUuZDULOMFIPv/QiQR7od006SN4Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/518] net: dpaa: Pad packets to ETH_ZLEN
Date: Tue, 15 Oct 2024 14:38:48 +0200
Message-ID: <20241015123917.932651527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 90bd5583ac34..cf7e9b26a0e3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2155,12 +2155,12 @@ static netdev_tx_t
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
 
@@ -2170,6 +2170,13 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 
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



