Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18FD41D222;
	Fri,  4 Sep 2026 06:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502826; cv=none; b=j9XN5PbtBkck5EjhEL0XKqw4jixmOC0rbJ0nV6lQtx1upVkBbTFJOOOMHE8VCKA/rMb7e7IhfAr+xzFskmCbcO9xNtEuIL1n7LmQdgwSLH4rLtA6HR1xqJBr+IVUM/kIAjoBI0aanSPFrZ3rUGzCdz0LeSQWfPcFQI8wfN2yhgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502826; c=relaxed/simple;
	bh=k1v5Ktun+bk4dJsJGZicZG4VWsHgE/UfIT75PEglLqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f79N5MDdRULheptz/HkHD6s/Aowr/yM6JyvnKj1RD/JX989/z81cWDER3gp6V3nFcCotoQX0F5rcJmZOhQ8IRXRcaEfT8NmwaX5Wkb1p5qhvCOC9Mh0YBmvEYFAFOpJF7FFZY0ZM7G6+QhyLKxanKRD4BilGqzjI5aHB7mxy0+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR3YKtQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR3YKtQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324521F00A3D;
	Fri,  4 Sep 2026 06:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502824;
	bh=NfN6WlHbEfvuBx/OTo541JNa5+LnWIBfaEtxCDKKQ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR3YKtQK8cUDjXipy03wvB4aAqxbfYMvCCNMrWJgDqTIWtHGqlwUeXDia0SEZt1I9
	 ZPK+eud6fuvP6LEbDlkMITYihFo4mjBPrxx20PrCfYS8iSGqU/Ju+I1zsHHgwxrY/u
	 NDDzHnoPOWpR1AHNk3PcL/0ONvEOMSsHPUPZRnXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 343/403] net: ravb: avoid dereferencing an invalid PTP clock
Date: Fri,  4 Sep 2026 07:02:26 +0200
Message-ID: <20260904045742.617947771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 1f77af0aaf277413ff32f6ff8c2c4282bd64c897 upstream.

The PTP clock is unavailable before the first open, so querying its
index can dereference a NULL pointer. Registration failures can also
leave an error pointer in priv->ptp.clock.

Cache the PHC index separately and report -1 while no clock is
registered. Normalize registration errors to NULL and preserve the
static timestamping capabilities.

Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
Cc: stable@vger.kernel.org
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260811103733.62599-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb.h      |    1 +
 drivers/net/ethernet/renesas/ravb_main.c |    3 ++-
 drivers/net/ethernet/renesas/ravb_ptp.c  |   15 +++++++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1034,6 +1034,7 @@ struct ravb_ptp_perout {
 struct ravb_ptp {
 	struct ptp_clock *clock;
 	struct ptp_clock_info info;
+	int phc_index;
 	u32 default_addend;
 	u32 current_addend;
 	int extts[N_EXT_TS];
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1761,7 +1761,7 @@ static int ravb_get_ts_info(struct net_d
 			(1 << HWTSTAMP_FILTER_NONE) |
 			(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 			(1 << HWTSTAMP_FILTER_ALL);
-		info->phc_index = ptp_clock_index(priv->ptp.clock);
+		info->phc_index = READ_ONCE(priv->ptp.phc_index);
 	}
 
 	return 0;
@@ -2953,6 +2953,7 @@ static int ravb_probe(struct platform_de
 	priv->rstc = rstc;
 	priv->ndev = ndev;
 	priv->pdev = pdev;
+	priv->ptp.phc_index = -1;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
 	priv->num_rx_ring[RAVB_BE] = BE_RX_RING_SIZE;
 	if (info->nc_queues) {
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -325,6 +325,7 @@ void ravb_ptp_interrupt(struct net_devic
 void ravb_ptp_init(struct net_device *ndev, struct platform_device *pdev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	struct ptp_clock *clock;
 	unsigned long flags;
 
 	priv->ptp.info = ravb_ptp_info;
@@ -337,7 +338,15 @@ void ravb_ptp_init(struct net_device *nd
 	ravb_modify(ndev, GCCR, GCCR_TCSS, GCCR_TCSS_ADJGPTP);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	priv->ptp.clock = ptp_clock_register(&priv->ptp.info, &pdev->dev);
+	clock = ptp_clock_register(&priv->ptp.info, &pdev->dev);
+	if (IS_ERR(clock)) {
+		netdev_err(ndev, "failed to register PTP clock: %pe\n", clock);
+		clock = NULL;
+	}
+
+	priv->ptp.clock = clock;
+	if (clock)
+		WRITE_ONCE(priv->ptp.phc_index, ptp_clock_index(clock));
 }
 
 void ravb_ptp_stop(struct net_device *ndev)
@@ -347,5 +356,7 @@ void ravb_ptp_stop(struct net_device *nd
 	ravb_write(ndev, 0, GIC);
 	ravb_write(ndev, 0, GIS);
 
-	ptp_clock_unregister(priv->ptp.clock);
+	WRITE_ONCE(priv->ptp.phc_index, -1);
+	if (priv->ptp.clock)
+		ptp_clock_unregister(priv->ptp.clock);
 }


