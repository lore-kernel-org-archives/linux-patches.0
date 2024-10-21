Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1001E7C05;
	Mon, 21 Oct 2024 10:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506908; cv=none; b=mgvGd3o6b6lK3kKVI+87KNVqtkGr1oALdynfwGl6O0Bq+pxb+8fGjL5bWLAQg0nU+gYQHedD6k3vMTL9N6rXWGQ9UBI/IOaZ8DyzJRjLCfMWjgJAzk8HIqp970vrW94x3Nn48lXZ+rPrk/M56kjCRkaDX5k8XBhpuz54giFPJhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506908; c=relaxed/simple;
	bh=jgkvAzLBqPhJGVRmAYmcUrk4EVipogZdHdohwje+Sxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgXtHPlIa/5Hglr87BYi9u4gleNZtcSUkcnUSV5pDZmwVir6BQauyDNRa0zxd8jzDW6hg9yQc+NlYcnSGkchmG+Gi7puDhsiffuT3Kl9leuIMpCkClApcS2dS4sgATbmkh0Pt0ZVGR8H1UhunM9O45lqhky6I0roYfX+ZbTmmfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjW2TJp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjW2TJp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF637C4CEC3;
	Mon, 21 Oct 2024 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506908;
	bh=jgkvAzLBqPhJGVRmAYmcUrk4EVipogZdHdohwje+Sxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjW2TJp/xfaRvEt94lS0tW8PcW0cxGSUWoYaPTxhl83m5tP+2qEUlCSzhsF1LSc9c
	 ipPtpIW5UfRSE2JONJYrYdY/zB+D6OsiVWO3NPpqExXNItGKROXH9AhhYaCXDlxDiR
	 GtrtlZU8twfboG1hjBxEDWW22i/594BP4I3x+ty0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 008/124] net: enetc: disable Tx BD rings after they are empty
Date: Mon, 21 Oct 2024 12:23:32 +0200
Message-ID: <20241021102257.041209489@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 0a93f2ca4be6c4616d371f18a3fabad2df7f8d55 upstream.

The Tx BD rings are disabled first in enetc_stop() and the driver
waits for them to become empty. This operation is not safe while
the ring is actively transmitting frames, and will cause the ring
to not be empty and hardware exception. As described in the NETC
block guide, software should only disable an active Tx ring after
all pending ring entries have been consumed (i.e. when PI = CI).
Disabling a transmit ring that is actively processing BDs risks
a HW-SW race hazard whereby a hardware resource becomes assigned
to work on one or more ring entries only to have those entries be
removed due to the ring becoming disabled.

When testing XDP_REDIRECT feautre, although all frames were blocked
from being put into Tx rings during ring reconfiguration, the similar
warning log was still encountered:

fsl_enetc 0000:00:00.2 eno2: timeout for tx ring #6 clear
fsl_enetc 0000:00:00.2 eno2: timeout for tx ring #7 clear

The reason is that when there are still unsent frames in the Tx ring,
disabling the Tx ring causes the remaining frames to be unable to be
sent out. And the Tx ring cannot be restored, which means that even
if the xdp program is uninstalled, the Tx frames cannot be sent out
anymore. Therefore, correct the operation order in enect_start() and
enect_stop().

Fixes: ff58fda09096 ("net: enetc: prioritize ability to go down over packet processing")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241010092056.298128-4-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   36 +++++++++++++++++++--------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2236,18 +2236,24 @@ static void enetc_enable_rxbdr(struct en
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
 }
 
-static void enetc_enable_bdrs(struct enetc_ndev_priv *priv)
+static void enetc_enable_rx_bdrs(struct enetc_ndev_priv *priv)
 {
 	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_enable_txbdr(hw, priv->tx_ring[i]);
-
 	for (i = 0; i < priv->num_rx_rings; i++)
 		enetc_enable_rxbdr(hw, priv->rx_ring[i]);
 }
 
+static void enetc_enable_tx_bdrs(struct enetc_ndev_priv *priv)
+{
+	struct enetc_hw *hw = &priv->si->hw;
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		enetc_enable_txbdr(hw, priv->tx_ring[i]);
+}
+
 static void enetc_disable_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 {
 	int idx = rx_ring->index;
@@ -2264,18 +2270,24 @@ static void enetc_disable_txbdr(struct e
 	enetc_txbdr_wr(hw, idx, ENETC_TBMR, 0);
 }
 
-static void enetc_disable_bdrs(struct enetc_ndev_priv *priv)
+static void enetc_disable_rx_bdrs(struct enetc_ndev_priv *priv)
 {
 	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_disable_txbdr(hw, priv->tx_ring[i]);
-
 	for (i = 0; i < priv->num_rx_rings; i++)
 		enetc_disable_rxbdr(hw, priv->rx_ring[i]);
 }
 
+static void enetc_disable_tx_bdrs(struct enetc_ndev_priv *priv)
+{
+	struct enetc_hw *hw = &priv->si->hw;
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		enetc_disable_txbdr(hw, priv->tx_ring[i]);
+}
+
 static void enetc_wait_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 {
 	int delay = 8, timeout = 100;
@@ -2465,6 +2477,8 @@ void enetc_start(struct net_device *ndev
 
 	enetc_setup_interrupts(priv);
 
+	enetc_enable_tx_bdrs(priv);
+
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(priv->si->pdev,
 					 ENETC_BDR_INT_BASE_IDX + i);
@@ -2473,7 +2487,7 @@ void enetc_start(struct net_device *ndev
 		enable_irq(irq);
 	}
 
-	enetc_enable_bdrs(priv);
+	enetc_enable_rx_bdrs(priv);
 
 	netif_tx_start_all_queues(ndev);
 
@@ -2539,7 +2553,7 @@ void enetc_stop(struct net_device *ndev)
 
 	netif_tx_stop_all_queues(ndev);
 
-	enetc_disable_bdrs(priv);
+	enetc_disable_rx_bdrs(priv);
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(priv->si->pdev,
@@ -2552,6 +2566,8 @@ void enetc_stop(struct net_device *ndev)
 
 	enetc_wait_bdrs(priv);
 
+	enetc_disable_tx_bdrs(priv);
+
 	enetc_clear_interrupts(priv);
 }
 EXPORT_SYMBOL_GPL(enetc_stop);


