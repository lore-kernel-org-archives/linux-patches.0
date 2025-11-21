Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67234275B18;
	Fri, 21 Nov 2025 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731650; cv=none; b=Po4FemTw40BmVNVBa397Hf1NbuMsdd+hmErqnxQY9ivDRU0L/fPfm7Qazzli5BURehodKZr4alHEH2/etqKR5Jfb4/paqnPQLkg0v39N4AXWAxgXdz+JkPMQPyByn74ub3nfYYbjOUdhn/mxNHXfK4w/tbnkhTTNQxLVktNUxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731650; c=relaxed/simple;
	bh=F7xyzq2qrkjUSfihRwt1velGLdQDRchPKRq8Ljim3hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4Z0zdQUWy9dXHaNiCQTWcKSNrjiGPHmVeJ/dSDuDMq0yiZmMg5o7pH67vf3q3537hA6xY8QslZ5Ioe80ohCGrmayZyikYfildgBVgImydGM2ZQ2DcUQFD+Gg7N066yXlznW/2Eif7afJF3oFoYFkkV3Ec3jCVlsgcntBu4unzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjPWs2n/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjPWs2n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BA3C4CEF1;
	Fri, 21 Nov 2025 13:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731650;
	bh=F7xyzq2qrkjUSfihRwt1velGLdQDRchPKRq8Ljim3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjPWs2n/D0tnCAEg4cnrNeX30701nhqMxkCU/tsI0Pfxe9sR6OE2bd+c4y9rPdD16
	 yZKK6nvZZRDebF+ZW9Rr0dhuUR/NA/qyhEAxjjnR0YuiNWdFqysUVnHcVH3G03g5nQ
	 GUQZB/8Y+sGyeIXww4Nb5/Ws9VACKyYp3rDfh3o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/185] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Fri, 21 Nov 2025 14:11:00 +0100
Message-ID: <20251121130145.071105488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d144494f97e91..d1800868c2e01 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1799,6 +1799,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		page = rxq->rx_skb_info[index].page;
-- 
2.51.0



