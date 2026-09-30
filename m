Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B8C51357E;
	Wed, 30 Sep 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787341; cv=none; b=V1O9Rhq2Qwj93+Nuu/K+UKxJWh940/Rkap/muyEghENYuEGt1MHyIs3mLIby5R1I79CoeelikaCveV0yOyk2M/t5jnWfBtGyxIfDb1dCKlixArQOnhM26IsNVyYiEEaPA/N4rHqQqLrw7vVizghnD2+re4IsBY05tJnuiHbpixA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787341; c=relaxed/simple;
	bh=S5I5HDiCouUD58TSsfQ4zsDkQ52sHNX6rtqLaF5hfpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlcwrvk2nXDSsAJ8I9e9zqn5xkD7zZCVzfHyUjch7W3AlyX5gBdssEC+vxjclMX0GeUQOZMTFhCqV0r5htK+UiM46Q4NcfdivH5TnwqV2UV2ueXRMziLMlYa/QuUT/kQI0ZVSvYdVwA6DVBKEaFQkvNe1nlbMdNnnt8aE4n/PmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gE3HV4jx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gE3HV4jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A381F00898;
	Wed, 30 Sep 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787339;
	bh=yyLTVBwDV6YSsqMt3Hx8OizKJQWxElXIaPbt7tTyz6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gE3HV4jxdG5ZBq+wkVEe27m26CdFKuvHq8Vyj2H0Bu/JBUfT0QcZ3D4b/RcU7zyXr
	 4DLNMFPpVhv4Sn6OWvJSK4tD6mHSOPU7UODyKsyfhHH5OU7OCwwyV1DA2Hn7EzsfDa
	 PqeE4v1DgeFBOSuA7O6Axko+CDKFNnOroP/mCzyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 194/457] net: bcmgenet: initialize u64 stats seq counter for all queues
Date: Wed, 30 Sep 2026 17:24:59 +0200
Message-ID: <20260930152350.242673933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 3aeaa609fda19c09d5298c9fedaaa3b6229601b5 ]

bcmgenet_gstrings_stats statically defines ethtool statistics for queues
0 through GENET_MAX_MQ_CNT (4). However, bcmgenet_probe() only initialized
the u64_stats_sync seq counter up to priv->hw_params->rx_queues and
priv->hw_params->tx_queues.

Since priv->hw_params->rx_queues is 0 across all hardware versions (and
priv->hw_params->tx_queues is 0 on GENET V1), rings 1..4 have uninitialized
u64_stats_sync structures. When ethtool -S is run on 32-bit kernels,
bcmgenet_get_ethtool_stats() reads stats from rx_rings[1..4], causing
lockdep warnings due to the uninitialized sequence counters.

Initialize the sequence counters for all GENET_MAX_MQ_CNT + 1 queues.

Fixes: ffc2c8c4a714 ("net: bcmgenet: Initialize u64 stats seq counter")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260921220021.281418-3-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 47a6c073c8d94..2ab37bb031ed2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4135,10 +4135,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		priv->rx_rings[i].rx_max_coalesced_frames = 1;
 
 	/* Initialize u64 stats seq counter for 32bit machines */
-	for (i = 0; i <= priv->hw_params->rx_queues; i++)
+	for (i = 0; i <= GENET_MAX_MQ_CNT; i++) {
 		u64_stats_init(&priv->rx_rings[i].stats64.syncp);
-	for (i = 0; i <= priv->hw_params->tx_queues; i++)
 		u64_stats_init(&priv->tx_rings[i].stats64.syncp);
+	}
 
 	/* libphy will determine the link state */
 	netif_carrier_off(dev);
-- 
2.53.0



