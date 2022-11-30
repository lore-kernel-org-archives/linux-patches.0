Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A1B79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E787EC433D6;
	Wed, 30 Nov 2022 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833522;
	bh=jG0XedHarOoE4DAkfdYrxyVLMBof5krotME9ffIJRGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqFuZ4DUX3gEMl9fw8UCuyKJdJwBZ2bY7xavGgerHfmYm99D+MflHVG2U/9EJ+F1r
	 z4ZoTyJYSJMJzEnuU8RfJL4N09AgftoRFMMcdzdmwbgkRPeLCstuglS+9fQ/GkodWO
	 JKeDFj/qEte2PGSsbsgUGJKovZspeNEMLuvrl3vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/206] net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
Date: Wed, 30 Nov 2022 19:22:59 +0100
Message-Id: <20221130180536.276866674@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 32bf8e1f6fb9f6dc334b2b98dffc2e5dcd51e513 ]

Future work in this driver would like to look at priv->active_offloads &
ENETC_F_QBV to determine whether a tc-taprio qdisc offload was
installed, but this does not produce the intended effect.

All the other flags in priv->active_offloads are managed dynamically,
except ENETC_F_QBV which is set statically based on the probed SI capability.

This change makes priv->active_offloads & ENETC_F_QBV really track the
presence of a tc-taprio schedule on the port.

Some existing users, like the enetc_sched_speed_set() call from
phylink_mac_link_up(), are best kept using the old logic: the tc-taprio
offload does not re-trigger another link mode resolve, so the scheduler
needs to be functional from the get go, as long as Qbv is supported at
all on the port. So to preserve functionality there, look at the static
station interface capability from pf->si->hw_features instead.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 290b5fe096e7 ("net: enetc: preserve TX ring priority across reconfiguration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  | 6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 3615357cc60f..5efb079ef25f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -800,9 +800,6 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (si->hw_features & ENETC_SI_F_QBV)
-		priv->active_offloads |= ENETC_F_QBV;
-
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
@@ -1053,7 +1050,8 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	int idx;
 
 	priv = netdev_priv(pf->si->ndev);
-	if (priv->active_offloads & ENETC_F_QBV)
+
+	if (pf->si->hw_features & ENETC_SI_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
 	if (!phylink_autoneg_inband(mode) &&
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6b236e0fd806..9fd9abad34f8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -71,6 +71,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		enetc_wr(&priv->si->hw,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
+
+		priv->active_offloads &= ~ENETC_F_QBV;
+
 		return 0;
 	}
 
@@ -136,6 +139,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
 			  tmp, dma);
 
+	if (!err)
+		priv->active_offloads |= ENETC_F_QBV;
+
 	return err;
 }
 
-- 
2.35.1



