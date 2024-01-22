Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2989DF500;
	Tue, 23 Jan 2024 00:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969805; cv=none; b=K0YVPLIXpZFyqHeYwUokdC/mOF7xUaZ8+XsTtYcQWRR6fDAacT1EIXhemRmZ4T1jlkBU6B08hUMjagIUQxYaY6+w4ENQRGaKfklOVhXwZPliCa+SeKgcGFGQ0kwtzA1ZvZbR1hD4IFJRZl+jbIcfjX7YPGiDNgZWCL93X2GMhik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969805; c=relaxed/simple;
	bh=1pxkO+18f/uIl3jYZRtfMF4dFxYyDzQKrY4yXgi3RRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgAzADOxijivcps8ufqUgU8v+Nn3e8LCckPS9sWsI2ENgdA1bWQTd28PUB2/Y3eBQn+ot9geLNBZzvKfx+QgT8I4tn/p4DGRQUhAsjJu1N1nteIVVFiFeFTF4K900xawSBA8DYlDUcvZIdgDDRtrMaaYcS+cIGNLKoxXNZGWPwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaPhSgPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaPhSgPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD583C433F1;
	Tue, 23 Jan 2024 00:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969805;
	bh=1pxkO+18f/uIl3jYZRtfMF4dFxYyDzQKrY4yXgi3RRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaPhSgPu6MFpIQhDOIsMxBRYc7aqazkbw9DsOi1WDSBAaI5U3k764FO7Hw4pgWqk1
	 U3iCffvCRRVTkaiGjRwkXURZJKbbN9GRs8RGS0VEE6hQE/d86vrn/5TNOE03KqBiSQ
	 dU37h61s6Xj/Zcl/tcE28breNGDFSVgUf27vWT4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Jisheng Zhang <jszhang@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 460/641] net: stmmac: fix ethtool per-queue statistics
Date: Mon, 22 Jan 2024 15:56:04 -0800
Message-ID: <20240122235832.432293129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Tesarik <petr@tesarici.cz>

commit 61921bdaa132b580b6db6858e6d7dcdb870df5fe upstream.

Fix per-queue statistics for devices with more than one queue.

The output data pointer is currently reset in each loop iteration,
effectively summing all queue statistics in the first four u64 values.

The summary values are not even labeled correctly. For example, if eth0 has
2 queues, ethtool -S eth0 shows:

     q0_tx_pkt_n: 374 (actually tx_pkt_n over all queues)
     q0_tx_irq_n: 23  (actually tx_normal_irq_n over all queues)
     q1_tx_pkt_n: 462 (actually rx_pkt_n over all queues)
     q1_tx_irq_n: 446 (actually rx_normal_irq_n over all queues)
     q0_rx_pkt_n: 0
     q0_rx_irq_n: 0
     q1_rx_pkt_n: 0
     q1_rx_irq_n: 0

Fixes: 133466c3bbe1 ("net: stmmac: use per-queue 64 bit statistics where necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Tesarik <petr@tesarici.cz>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -543,15 +543,12 @@ static void stmmac_get_per_qstats(struct
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
 	unsigned int start;
 	int q, stat;
-	u64 *pos;
 	char *p;
 
-	pos = data;
 	for (q = 0; q < tx_cnt; q++) {
 		struct stmmac_txq_stats *txq_stats = &priv->xstats.txq_stats[q];
 		struct stmmac_txq_stats snapshot;
 
-		data = pos;
 		do {
 			start = u64_stats_fetch_begin(&txq_stats->syncp);
 			snapshot = *txq_stats;
@@ -559,17 +556,15 @@ static void stmmac_get_per_qstats(struct
 
 		p = (char *)&snapshot + offsetof(struct stmmac_txq_stats, tx_pkt_n);
 		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
-			*data++ += (*(u64 *)p);
+			*data++ = (*(u64 *)p);
 			p += sizeof(u64);
 		}
 	}
 
-	pos = data;
 	for (q = 0; q < rx_cnt; q++) {
 		struct stmmac_rxq_stats *rxq_stats = &priv->xstats.rxq_stats[q];
 		struct stmmac_rxq_stats snapshot;
 
-		data = pos;
 		do {
 			start = u64_stats_fetch_begin(&rxq_stats->syncp);
 			snapshot = *rxq_stats;
@@ -577,7 +572,7 @@ static void stmmac_get_per_qstats(struct
 
 		p = (char *)&snapshot + offsetof(struct stmmac_rxq_stats, rx_pkt_n);
 		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ += (*(u64 *)p);
+			*data++ = (*(u64 *)p);
 			p += sizeof(u64);
 		}
 	}


