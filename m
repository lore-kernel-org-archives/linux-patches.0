Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C451E450;
	Wed, 30 Sep 2026 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793190; cv=none; b=H9C9RbuaqH/gEHAnGHSceEgKoe0dCb0rcv7jkIVR6bRe8uNiK26SOKTfvROcsLPv+7Dcc6AG4F0Hr2aFsq0EjAZMmlNrpNR9N5w2tAWLWb9Z5L/klSQBXcDbgd8JxLpgwxBDYGbBMHmer8lq9tf5/aetgrvLkaWQPGeK9rxR1V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793190; c=relaxed/simple;
	bh=ZkY7rS9KZtI7L3lTZn8Q9JKCl01SHzKFjiIcQPWBnxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrjnCB1kG9AzP2ESJ7IHVmIDLKLUlf+5R9cr4mLwQ9d/s0PoursqCdJo57IY0DkSzaxwpGabxyOEZuWQYGIgb8N9YkGNdGpItJVSEzsI80EowuqR791squdReF5VhQq32o4Z7J0NZeEIDgY0lTnYfd1p8IbSIV6JGw0vdAyiMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAYPpMi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAYPpMi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EE71F000FF;
	Wed, 30 Sep 2026 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793189;
	bh=+RUgK/IzMQqNZwDXx8NsSsP4zWtJhjm6uqTG2iqyF6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAYPpMi0WcM8pBCYxz0vea9Pz53PzWC7dGGP68tkqjX7ST4nai5eTBAFYBoaRbjUV
	 +VbdwduURg4Ejnxp2+C6wVAeUYgnPS+RuWrE41bpZ305F5BYsmiuDaPS5IjthAjLGg
	 OGCUMtvd81bHsSGTBksTIEDD2gOHAEwK6Toguteo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/395] net: bcmgenet: initialize u64 stats seq counter for all queues
Date: Wed, 30 Sep 2026 17:27:07 +0200
Message-ID: <20260930152344.228600055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0e6c89988d1c1..5050712166aa9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4140,10 +4140,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
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



