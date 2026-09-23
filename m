Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD8E379981;
	Wed, 23 Sep 2026 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174490; cv=none; b=no1w5QdgXNdgS0JQ4jDYj55CZITLsDbAIMeakXVx3pCsWjgnlILWxfw2ui3cJypQy8lCUKeKErA8SA+j64tgcJggtmbpI5uVNeoeHQ8BzX43Tkj5oVbgV0CMVtspQFVxEKBTH6/nUjTiPEatwZJH4GYYpZkLALOPHr4UOSaCHz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174490; c=relaxed/simple;
	bh=HSJ+YU0lf5OIk9rav7byW8vH745vUoapGeV0WMyNUTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZuhgmdsSJU3X2q4p3fDOPGc5XUJEEIN0ryQ8+bSwJ6tX5qem9CI5XJsIlurhOIuopFGJuB6yCUbb4ai1qIseXRf7OFSZdaAL/+WzENuu5YDUEHPIxR2WP1k5GGf6qfLl05JWgzXPgOKUJXLsPZpeqwMnUX6d+sMPKIJuHEtUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bN7OpSyA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bN7OpSyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BB11F000FF;
	Wed, 23 Sep 2026 14:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174489;
	bh=1/ofZ28G+qaCdGdOBk20REo0y27Px+LPIB5b2EWybmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bN7OpSyA5tNH2MWmgMnynXyIQcujIa0RGEUzwyTrAX6bDFiaEixB+4nr8MwIvRPyx
	 gUvaydtpfDNuQeDzeuf5KvwFLV2sDBBb3lCgjJ6jWc5V3inUBzfPfuLY0v506+THo6
	 rOOvLl1/q39Z4wLRFk5P4sMQkGwevSAjB02oE7Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/398] net: bcmgenet: restore the hardware filters on open
Date: Wed, 23 Sep 2026 16:03:24 +0200
Message-ID: <20260923140646.807860628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 23ca4ddc4fce2c233a49e9fd34d4b5b02bd7324e ]

bcmgenet_hfb_init() runs INIT_LIST_HEAD() on priv->rxnfc_list, which drops
every rule off the list, and bcmgenet_open() calls it on each ifup. Every
rule the user configured is silently lost:

  # ethtool -N eth0 flow-type ether dst $MAC action 0
  Added rule with ID 0
  # ethtool -n eth0 | grep -c Filter:
  1
  # ip link set eth0 down && ip link set eth0 up
  # ethtool -n eth0 | grep -c Filter:
  0

Initialise the lists once at probe and restore the rules on open, as
bcmgenet_resume() already does.

Fixes: 3e370952287c ("net: bcmgenet: add support for ethtool rxnfc flows")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260913190052.939955-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 7f9d43a75f3bd..41539f9f8061c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -750,8 +750,17 @@ static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
 		INIT_LIST_HEAD(&priv->rxnfc_rules[i].list);
 		priv->rxnfc_rules[i].state = BCMGENET_RXNFC_STATE_UNUSED;
 	}
+}
+
+static void bcmgenet_hfb_restore(struct bcmgenet_priv *priv)
+{
+	struct bcmgenet_rxnfc_rule *rule;
 
 	bcmgenet_hfb_clear(priv);
+
+	list_for_each_entry(rule, &priv->rxnfc_list, list)
+		if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
+			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 }
 
 static int bcmgenet_begin(struct net_device *dev)
@@ -3374,8 +3383,8 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	/* HFB init */
-	bcmgenet_hfb_init(priv);
+	/* Restore the filters, the MAC was reset above */
+	bcmgenet_hfb_restore(priv);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv, true);
@@ -4077,6 +4086,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	/* Mii wait queue */
 	init_waitqueue_head(&priv->wq);
+	bcmgenet_hfb_init(priv);
 	INIT_WORK(&priv->bcmgenet_irq_work, bcmgenet_irq_task);
 
 	priv->clk_wol = devm_clk_get_optional(&priv->pdev->dev, "enet-wol");
@@ -4277,10 +4287,7 @@ static int bcmgenet_resume(struct device *d)
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	/* Restore hardware filters */
-	bcmgenet_hfb_clear(priv);
-	list_for_each_entry(rule, &priv->rxnfc_list, list)
-		if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
-			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
+	bcmgenet_hfb_restore(priv);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv, false);
-- 
2.53.0



