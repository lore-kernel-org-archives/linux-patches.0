Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D31132B99F;
	Wed,  3 Dec 2025 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778222; cv=none; b=ehDYT1bySLkqNJ0YjkJL6r/KPJSgkILDLSngIUpeVioggPInUQcjjXnUhKK355SK/5A1hIqITk/dTFCdAUevP/JLt23T5B90Ca3gypk9SRUAGkbqBDxr5L/PBTl1VvohJpgzxpBBxm6nWMwOwP3OpbzKGCOSrUfAysNk9ymrQh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778222; c=relaxed/simple;
	bh=IIiHJEfwog4+3a8x08KaKkOXeiNxsAWy+rJtl2SBCGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKsJVzvOX4HKTsmjbnqQFKZsrj47XDeY/uqS0l/NI0MDuJl6tNkMLDFiYx86hhHdzK4OxFUZ37j8K//g1q1/zw01H9mOawWA1292NPPDTbI8C4oRJoR4F1y9C7kJysjPxlk1kSNXwLPtHdG7erfot6dKGB+bkQ/8yvWAq7k2zYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spwwI6q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spwwI6q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7029FC4CEF5;
	Wed,  3 Dec 2025 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778221;
	bh=IIiHJEfwog4+3a8x08KaKkOXeiNxsAWy+rJtl2SBCGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spwwI6q+giQ4mqNEbOPVaRylMKm3Sute6J2FGwQ3rWm0fM92Z2oK1AAiOJHCC5wzQ
	 /j7CYSX2ebKV2CEFmamb6Zy7V/5Y21OfWyHejGT1Nf/dKzBzKMF4UYsHeW1gcSH2tB
	 NM2LIFixWE1KBjWzImi7CTNMn1a5xlsykoIim/7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/392] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Wed,  3 Dec 2025 16:26:27 +0100
Message-ID: <20251203152422.898551335@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit ad17e7e92a7c52ce70bb764813fcf99464f96903 ]

Two additional bytes in front of each frame received into the RX FIFO if
SHIFT16 is set, so we need to subtract the extra two bytes from pkt_len
to correct the statistic of rx_bytes.

Fixes: 3ac72b7b63d5 ("net: fec: align IP header in hardware")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251106021421.2096585-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d457af64f8357..263e3755f5c3a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1566,6 +1566,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		skb = rxq->rx_skbuff[index];
-- 
2.51.0



