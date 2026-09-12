Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EDC356742;
	Sat, 12 Sep 2026 09:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205244; cv=none; b=NNuhEZj4CxQZdbTigFak3OcKVTwaRfCTXU6q5rLeE0DiivACCiis4vvpsmor9fCIsh6QEsnjUdSbKP55+QVkeVz2ixwHWy0lIL2vfPmnHcs4f7VLRUMQcp9i+Z5WoYEPo71UOsbdNaHZqauQjhS7AJ7qJFLJiTbXKG4LK6dr2j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205244; c=relaxed/simple;
	bh=2phsZRMNJ1HMhy9HTIuor+g1bf+AgZ0rt12cynQLThw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stI+g6sRU0k8gAY6AEMJqWfHfCYCkT+NUPYjDNpp5ANTWf7KgGU3r8c2eCtMo9qrhrXLUc2HEjXnqaJ2pXWRy6qRvZoVdBFmC4oPmSeOYheFD8iVCPAzOzdsgWjtXhrpHPwFwbKxZSidhL+srtfU8M+ER7j+petOrH2QDTxNwtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhcTdFBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhcTdFBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6611F000FF;
	Sat, 12 Sep 2026 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205243;
	bh=2PXMhcgC7xjHI0ZDQ3Q/ymkZTpOu9haq1LK+Oy8orN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhcTdFBjjmnQhIA0Z/GE7ZXvTKD3CH62RH8FRa+qgI3J0rkxUn7I8IkMXTWlqqOKE
	 wHfFMKUuqBN7R4s3A3YMYFeJTiaWymn+gxZ0CEya1IyB/0IiO9ttALfknjsM1QdryK
	 bJTQBWkpCKVzhgyHr8IyYQSDiuXzPez1l9SmRfZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1741/1815] net: enetc: restore RX ring congestion mode for ENETC v4
Date: Sat, 12 Sep 2026 08:58:11 +0200
Message-ID: <20260912065729.853486345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit fa1a8457b8581725ae237efefb2358eddd7e05c9 ]

ENETC v4 has the same problem as ENETC v1: the RX BD ring congestion
mode (CM) is only configured in the phylink .mac_link_up() callback, so
it is cleared when enetc_reconfigure() rebuilds the RX BD rings at
runtime (for example when enabling or disabling PTP RX hardware
timestamping) without a link status change, and it is never restored.
As a result, the MAC can no longer generate PAUSE frames on ingress
congestion and flow control stops working.

Fix it in the same way as ENETC v1. Track the desired CM state in the
software flag ENETC_RXBDR_CM. Route enetc4_set_tx_pause() through the
shared helper enetc_set_congestion_mode(), which sets or clears the flag
according to tx_pause and updates the ENETC_RBMR_CM bit under si->gen_lock.
When the RX BD rings are (re)enabled, enetc_enable_rxbdr() consults this
flag and restores the CM bit accordingly, so flow control survives ring
reconfiguration even when the link status does not change.

Fixes: f5b9a1cde0a2 ("net: enetc: add PTP synchronization support for ENETC v4")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260821064140.1315611-3-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
index 056c976663fa0..65d3c24510e87 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -708,22 +708,14 @@ static void enetc4_set_rx_pause(struct enetc_pf *pf, bool rx_pause)
 	enetc_port_mac_wr(si, ENETC4_PM_CMD_CFG(0), val);
 }
 
-static void enetc4_set_tx_pause(struct enetc_pf *pf, int num_rxbdr, bool tx_pause)
+static void enetc4_set_tx_pause(struct enetc_pf *pf, bool tx_pause)
 {
+	struct enetc_ndev_priv *priv = netdev_priv(pf->si->ndev);
 	u32 pause_off_thresh = 0, pause_on_thresh = 0;
 	u32 init_quanta = 0, refresh_quanta = 0;
 	struct enetc_hw *hw = &pf->si->hw;
-	u32 rbmr, old_rbmr;
-	int i;
 
-	for (i = 0; i < num_rxbdr; i++) {
-		old_rbmr = enetc_rxbdr_rd(hw, i, ENETC_RBMR);
-		rbmr = u32_replace_bits(old_rbmr, tx_pause ? 1 : 0, ENETC_RBMR_CM);
-		if (rbmr == old_rbmr)
-			continue;
-
-		enetc_rxbdr_wr(hw, i, ENETC_RBMR, rbmr);
-	}
+	enetc_set_congestion_mode(priv, tx_pause);
 
 	if (tx_pause) {
 		/* When the port first enters congestion, send a PAUSE request
@@ -888,7 +880,7 @@ static void enetc4_pl_mac_link_up(struct phylink_config *config,
 			tx_pause = false;
 	}
 
-	enetc4_set_tx_pause(pf, priv->num_rx_rings, tx_pause);
+	enetc4_set_tx_pause(pf, tx_pause);
 	enetc4_set_rx_pause(pf, rx_pause);
 	enetc4_mac_tx_enable(pf);
 	enetc4_mac_rx_enable(pf);
-- 
2.53.0



