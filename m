Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18670265621;
	Mon,  1 Dec 2025 11:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588667; cv=none; b=hfEyxfMpmh/HPJ24YXNpYtKWBJ39rOmfbUQRfG2OCSggST+DzaPtc1KS65xYPPsQm+5bn8GqMNitg9ZTzPshX2V/9l0UMUTcgx26+ZlsbLWKiuA5IXAnAqLIo6UmimBDsKGPba1egOaYEsygOSAs/YVHNhiq17g8+/dbsuUf7s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588667; c=relaxed/simple;
	bh=tB0O6qBfGrwyn6O7gLKQL9klDDqTllPXekaQ6nM4YiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P81cjB5NjnIM+58mQBGZvnojO+WJz5kRl0j9MGHS8pLuzH11YbyACsDAOorQunJ85qsbrT+OlitoC88uHfjyCpCMiEycYmBZDimS+dK+YXoY5FHKBlFDtvy5k0I16lC/m74g+KXKRb9t1ChTKb8O6HRq6OxcAeLRL0/k3a/+tAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOnSwv/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOnSwv/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F2CC19421;
	Mon,  1 Dec 2025 11:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588666;
	bh=tB0O6qBfGrwyn6O7gLKQL9klDDqTllPXekaQ6nM4YiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOnSwv/TLSkPg49QOkMJhFNvqA8cDgA3dtGpQGJBOpI5XHnjhOIxi8Fl3DvCpTvGe
	 8VcN/emA3xz9IrCQafyoMzrNlGRupV0dPrQv0H074KcYPQl5k3noDvHvs7etDpnkpP
	 hzXArH1Pkat2TMQS1T4zY2LjC74K+bAmHPsJ4P4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/187] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Mon,  1 Dec 2025 12:23:57 +0100
Message-ID: <20251201112245.887395546@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7b2ab0cc562cc..cd2fd2926f2f5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1530,6 +1530,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		skb = rxq->rx_skbuff[index];
-- 
2.51.0



