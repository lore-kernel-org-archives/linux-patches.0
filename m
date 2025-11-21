Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B75127B358;
	Fri, 21 Nov 2025 13:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731075; cv=none; b=KvrQH4kTbAu+hjrxw2mVliPyFM36xHUXoM1WiatruLt9Xxoqm1P3Z6cKH5DAtY+oKGnyjmkVcz/ik6m55OAYhnvj5rdwQXQXbhj109kZ/cstevnk5VvRC5GZ/yf3QVYnl7yKVkajIajL4XM01Zz05RjsGfcWKbw8oZ6VBu3P1gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731075; c=relaxed/simple;
	bh=tU13wT/56tw/px2Ecgk/zy2OfsBX0BmSjMnFGFhg1mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTSPTaT1Rbe5agW5HqY4xmR2HWQWmAj+AOkfx6Kn2fc57tzwxJili7fUh7KSoNHfH/3mbvIKDa5E8t62uZEMaqlQ0HlnRLoE6T2yqxVdIbwnesW3AURTzyOwDjbO4Fpz0UW6IyCTlNsYWrO2px1C9aYksV9eeKKpQ43B4a5ErM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMvgD4dN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMvgD4dN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9771C4CEF1;
	Fri, 21 Nov 2025 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731075;
	bh=tU13wT/56tw/px2Ecgk/zy2OfsBX0BmSjMnFGFhg1mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMvgD4dNZoYXUrvUUJLt1kmm14P2YloISS30A0IGrfcgAOp4Ma0prUrfsWD1FPolL
	 /1EOvlu6y0IuYYvZi2bwfxA1OAGaqt72Hy9jfMNfzu8CGL19o2es3ZDoGcG5FNnAj5
	 tiyHnQIVa7zjyH3RJKEg6fi/jPqbV+RirI3kr+xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 049/247] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Fri, 21 Nov 2025 14:09:56 +0100
Message-ID: <20251121130156.361107928@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index adf1f2bbcbb16..c404ca590b73c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1820,6 +1820,8 @@ fec_enet_rx_queue(struct net_device *ndev, u16 queue_id, int budget)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		page = rxq->rx_skb_info[index].page;
-- 
2.51.0



