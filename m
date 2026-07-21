Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26012404BE9;
	Tue, 21 Jul 2026 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654980; cv=none; b=bfmADWR79qvJDGi0BFtReIisLl4W2il/vdZKMb5Peq0t6cJxPV43kPMoYaArl3A8ShlB9r9PkQQsI2TolpleYznZG20suPNzcgWKT0bF2/uwDIVwGS9Pcjfi4b7NDiSdtVtMXxjBHiJMPz8hFEUNBZBJNSHOGxlgzHjgl1hnC8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654980; c=relaxed/simple;
	bh=WOu4j2Gs81zRsOcQzFVy59wO3pCBoRMNhub81HtYLio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TStuBXpmoF8q0rLCofYKTxNhc7XEu26OuE92IFHpzwhFDEtf4ZqshIxkQvdZFo0L7a0/jefo73hcEDceUU+g8M9Thu86YhYKkgtM53akp0wrVI8iM/PTIyJofhZlLSdNkYEyKrZR4QbHfZRRnPvOOsWiCI8FtOjDVfyhzQG+FLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSNUkT5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSNUkT5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909591F000E9;
	Tue, 21 Jul 2026 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654979;
	bh=ojhH45kSlka9EmBXx1vUXO9dVaEwECckzyuYnwLlZSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSNUkT5Sz8GPkSgEQH/CNXrpA99qkQ4bsHcOWyGXNCfiwXTEPQKzhfSnBDX9unHVb
	 1yG4zMrAx3eZk8ZnwopNhNwWlWQzdncVVo+PsYQE+Mfr0/fRIfmGYoqR/shZHIEmU8
	 Yvu5oLO3biPM0EJeaJhMg2NZM69S9vqmm2JkBRrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Schenker <philippe.schenker@impulsing.ch>,
	Simon Horman <horms@kernel.org>,
	danishanwar@ti.com,
	rogerq@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1910/2077] net: ethernet: ti: icssg: guard PA stat lookups
Date: Tue, 21 Jul 2026 17:26:23 +0200
Message-ID: <20260721152637.769243690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philippe Schenker <philippe.schenker@impulsing.ch>

commit 27b9daba50609335db6ca81e4cccf50ded21ec76 upstream.

icssg_ndo_get_stats64() unconditionally calls emac_get_stat_by_name()
with FW PA stat names regardless of whether the PA stats block is
present on the hardware.  emac_get_stat_by_name() already guards the
PA stats lookup with `if (emac->prueth->pa_stats)`; when that pointer
is NULL the lookup falls through to netdev_err() and returns -EINVAL.
Because ndo_get_stats64 is polled regularly by the networking stack
this produces thousands of log entries of the form:

  icssg-prueth icssg1-eth end0: Invalid stats FW_RX_ERROR

A secondary consequence is that the int(-EINVAL) return value is
implicitly widened to a near-ULLONG_MAX unsigned value when accumulated
into the __u64 fields of rtnl_link_stats64, silently corrupting the
rx_errors, rx_dropped and tx_dropped counters reported by `ip -s link`.

Every other PA-aware code path in the driver is already guarded with
the same `if (emac->prueth->pa_stats)` check.  Apply the same guard
here.

Fixes: 0d15a26b247d ("net: ti: icssg-prueth: Add ICSSG FW Stats")
Signed-off-by: Philippe Schenker <philippe.schenker@impulsing.ch>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cc: danishanwar@ti.com
Cc: rogerq@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260618093037.3448858-1-dev@pschenker.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c |   49 +++++++++++++++------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -1651,28 +1651,35 @@ void icssg_ndo_get_stats64(struct net_de
 	stats->rx_over_errors = emac_get_stat_by_name(emac, "rx_over_errors");
 	stats->multicast      = emac_get_stat_by_name(emac, "rx_multicast_frames");
 
-	stats->rx_errors  = ndev->stats.rx_errors +
-			    emac_get_stat_by_name(emac, "FW_RX_ERROR") +
-			    emac_get_stat_by_name(emac, "FW_RX_EOF_SHORT_FRMERR") +
-			    emac_get_stat_by_name(emac, "FW_RX_B0_DROP_EARLY_EOF") +
-			    emac_get_stat_by_name(emac, "FW_RX_EXP_FRAG_Q_DROP") +
-			    emac_get_stat_by_name(emac, "FW_RX_FIFO_OVERRUN");
-	stats->rx_dropped = ndev->stats.rx_dropped +
-			    emac_get_stat_by_name(emac, "FW_DROPPED_PKT") +
-			    emac_get_stat_by_name(emac, "FW_INF_PORT_DISABLED") +
-			    emac_get_stat_by_name(emac, "FW_INF_SAV") +
-			    emac_get_stat_by_name(emac, "FW_INF_SA_DL") +
-			    emac_get_stat_by_name(emac, "FW_INF_PORT_BLOCKED") +
-			    emac_get_stat_by_name(emac, "FW_INF_DROP_TAGGED") +
-			    emac_get_stat_by_name(emac, "FW_INF_DROP_PRIOTAGGED") +
-			    emac_get_stat_by_name(emac, "FW_INF_DROP_NOTAG") +
-			    emac_get_stat_by_name(emac, "FW_INF_DROP_NOTMEMBER");
+	stats->rx_errors  = ndev->stats.rx_errors;
+	stats->rx_dropped = ndev->stats.rx_dropped;
 	stats->tx_errors  = ndev->stats.tx_errors;
-	stats->tx_dropped = ndev->stats.tx_dropped +
-			    emac_get_stat_by_name(emac, "FW_RTU_PKT_DROP") +
-			    emac_get_stat_by_name(emac, "FW_TX_DROPPED_PACKET") +
-			    emac_get_stat_by_name(emac, "FW_TX_TS_DROPPED_PACKET") +
-			    emac_get_stat_by_name(emac, "FW_TX_JUMBO_FRM_CUTOFF");
+	stats->tx_dropped = ndev->stats.tx_dropped;
+
+	if (!emac->prueth->pa_stats)
+		return;
+
+	stats->rx_errors  +=
+			emac_get_stat_by_name(emac, "FW_RX_ERROR") +
+			emac_get_stat_by_name(emac, "FW_RX_EOF_SHORT_FRMERR") +
+			emac_get_stat_by_name(emac, "FW_RX_B0_DROP_EARLY_EOF") +
+			emac_get_stat_by_name(emac, "FW_RX_EXP_FRAG_Q_DROP") +
+			emac_get_stat_by_name(emac, "FW_RX_FIFO_OVERRUN");
+	stats->rx_dropped +=
+			emac_get_stat_by_name(emac, "FW_DROPPED_PKT") +
+			emac_get_stat_by_name(emac, "FW_INF_PORT_DISABLED") +
+			emac_get_stat_by_name(emac, "FW_INF_SAV") +
+			emac_get_stat_by_name(emac, "FW_INF_SA_DL") +
+			emac_get_stat_by_name(emac, "FW_INF_PORT_BLOCKED") +
+			emac_get_stat_by_name(emac, "FW_INF_DROP_TAGGED") +
+			emac_get_stat_by_name(emac, "FW_INF_DROP_PRIOTAGGED") +
+			emac_get_stat_by_name(emac, "FW_INF_DROP_NOTAG") +
+			emac_get_stat_by_name(emac, "FW_INF_DROP_NOTMEMBER");
+	stats->tx_dropped +=
+			emac_get_stat_by_name(emac, "FW_RTU_PKT_DROP") +
+			emac_get_stat_by_name(emac, "FW_TX_DROPPED_PACKET") +
+			emac_get_stat_by_name(emac, "FW_TX_TS_DROPPED_PACKET") +
+			emac_get_stat_by_name(emac, "FW_TX_JUMBO_FRM_CUTOFF");
 }
 EXPORT_SYMBOL_GPL(icssg_ndo_get_stats64);
 


