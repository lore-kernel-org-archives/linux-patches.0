Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A172FC010;
	Wed,  3 Dec 2025 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776420; cv=none; b=vArQ3mIUQJuy59EQd/ZxQJr4qN77J+qFeZEet2OKGDZlrirD+P79mS0W5IxcKcegogRjUwaXFtA4SQaqOYNqls8w2WULPqfuXI25tf5c2+ONZ71MBFl0dCF7Uhy/t/Qjlsn9AMk723bVwgn9wfJTfGISrKsm1gGXtbm6KDzRu6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776420; c=relaxed/simple;
	bh=gRpoa8Gvx1f1uVl8AWLR6ZcYET/bSzdvMxIbeTIiWkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaBBMa3I6ToLFkjQ12nkgnYMnRDevxMydivHd3cjgVdfKF8KhXjp4M0hspZYR5GK39ljNn5QvzG01pDuKsktbP8JQvkS5r31yJeVSLPjygKPDfRjv69yM0SnORho/yx8ggPQjWENKyaz4bXyzcnMBRQhBAttw7zm+4ETheeetCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xza6yDxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xza6yDxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307C3C116B1;
	Wed,  3 Dec 2025 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776420;
	bh=gRpoa8Gvx1f1uVl8AWLR6ZcYET/bSzdvMxIbeTIiWkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xza6yDxxclBmsUnzpTeJ+nEgH8hoILYbwMhshMk1aaNsFqoNy3WUQX4DEgkvmixBj
	 7QMNfnznXp9iqhMOGsWjztp+p/92xyzeoM99OApEe4YvntcTPS3r5RGiAP4YhPu1Di
	 rq1TjQX1ylnwO6CRgmJahLiPgM+FAFrIop4KANi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/300] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Wed,  3 Dec 2025 16:26:22 +0100
Message-ID: <20251203152407.221828460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9905e65621004..dfe3e7b1fae51 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1525,6 +1525,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		skb = rxq->rx_skbuff[index];
-- 
2.51.0



