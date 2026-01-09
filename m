Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA7C35A947;
	Fri,  9 Jan 2026 12:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963217; cv=none; b=bm2h61/iNmjBDHrcFOh24e2OnWxYClDyMxogFe/7wQdL2/nq0D72UfXy/DC6Tml+xP7RVqsNKrnSGvelW5N46Aq5jRQ/bXX36o7kcal29evZ+v8tn0RsxKxYYVR0NvuWs1jE8ppjbMkDtrfJumHzvMnHBBh90a+O7rF2qhcgcqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963217; c=relaxed/simple;
	bh=8Fr+3J2WE8BETLWJYAYJFF/8KILJwIuixtVxVVitT9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az+o1aoa8bWA4/RdjOCzTANttb1zXUGgS1l0uugw+2u6VW5GOe3pOguhBWDsUgIKz4OCVi9h3KUkTTHbcm20JHWMwL2mqvbw55ZEn5++9t2xWAm6f8g8pX0NVmK2ufBNl1bujnZxynR6pHKSpUDI+rFDUKNA0xYe6OLe/JGVyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xL502fEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xL502fEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F47BC4CEF1;
	Fri,  9 Jan 2026 12:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963217;
	bh=8Fr+3J2WE8BETLWJYAYJFF/8KILJwIuixtVxVVitT9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xL502fEEmt4QolIC24j40wRKG5aztHqiBJALy/5DwL7GW38ncj1qPMl/kVYNxg/mv
	 mpHITVhEC3l7wm1jGk2ew4RyQmAlHqDnddvkGwt6U1JMqG1acxrU61WP4es3YTZ3Nm
	 v19HbObF+DCwsfFqUppT1VxYDs1I5Ra87F4ddcO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Jisheng Zhang <jszhang@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 631/634] net: stmmac: fix ethtool per-queue statistics
Date: Fri,  9 Jan 2026 12:45:09 +0100
Message-ID: <20260109112141.377915235@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -552,15 +552,12 @@ static void stmmac_get_per_qstats(struct
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
@@ -568,17 +565,15 @@ static void stmmac_get_per_qstats(struct
 
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
@@ -586,7 +581,7 @@ static void stmmac_get_per_qstats(struct
 
 		p = (char *)&snapshot + offsetof(struct stmmac_rxq_stats, rx_pkt_n);
 		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ += (*(u64 *)p);
+			*data++ = (*(u64 *)p);
 			p += sizeof(u64);
 		}
 	}


