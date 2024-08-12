Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677DD134AC;
	Mon, 12 Aug 2024 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479956; cv=none; b=eTxjGzZlyMKbrrHFOEuNmAKyxPv8nBj9ZU6yWgABM73eyHGETcmEvezz3FSDU2BFOYYTrGsiYjRCdBX5ykVKjhxnwQfq09C4Pru8PYS0yJJ8RgrFGvPl6yWxmGGnfWVv0ojmio10V1Dzn60mQTUcMqgQhTN7dtuxBngGMd/ZnWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479956; c=relaxed/simple;
	bh=vG8XqwvG+ilAnfGqkjGkrzyMzRgjUp0Gma/ve4DHbHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZIFMMfsfJS/sZAg/2Qvp6y0OfrtpucUDGCxXnFkJ8BBqSQy6wrMwzzX0IJCaczGQQSX1Uy5iLJS+OJzxEsB0cMR4Bcrk0clFFbzka3p7JYcXTPKABzls/q0HKYvRUYuZGdwJXG+e5tWXVZDRZElxgtbdlN489vtDTVLOX1x9ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyCKWZXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyCKWZXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54D2C32782;
	Mon, 12 Aug 2024 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479956;
	bh=vG8XqwvG+ilAnfGqkjGkrzyMzRgjUp0Gma/ve4DHbHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyCKWZXhT/TPuolIRnKx1jBrr+sgOnxsHAIxpLLxIgaAbfJGe2hTolgCaALPhfUp5
	 6zsxUqCOGtVJNWstVGd1Ogsc3Za5mpVfiJWIIbZFT6CeT83DruYryK4jDoWHohBJC7
	 rkPYBkZUovFLd9OB/FLCZn9vAkEmUPjVWh/bGBu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/263] gve: Fix use of netif_carrier_ok()
Date: Mon, 12 Aug 2024 18:00:22 +0200
Message-ID: <20240812160147.353506575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Kaligineedi <pkaligineedi@google.com>

[ Upstream commit fba917b169bea5f8f2ee300e19d5f7a6341a5251 ]

GVE driver wrongly relies on netif_carrier_ok() to check the
interface administrative state when resources are being
allocated/deallocated for queue(s). netif_carrier_ok() needs
to be replaced with netif_running() for all such cases.

Administrative state is the result of "ip link set dev <dev>
up/down". It reflects whether the administrator wants to use
the device for traffic and the corresponding resources have
been allocated.

Fixes: 5f08cd3d6423 ("gve: Alloc before freeing when adjusting queues")
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Shailend Chand <shailend@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240801205619.987396-1-pkaligineedi@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c    | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index fe1741d482b4a..cf816ede05f69 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -492,7 +492,7 @@ static int gve_set_channels(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	if (!netif_carrier_ok(netdev)) {
+	if (!netif_running(netdev)) {
 		priv->tx_cfg.num_queues = new_tx;
 		priv->rx_cfg.num_queues = new_rx;
 		return 0;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index cabf7d4bcecb8..8b14efd14a505 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1511,7 +1511,7 @@ static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
 	u32 status;
 
 	old_prog = READ_ONCE(priv->xdp_prog);
-	if (!netif_carrier_ok(priv->dev)) {
+	if (!netif_running(priv->dev)) {
 		WRITE_ONCE(priv->xdp_prog, prog);
 		if (old_prog)
 			bpf_prog_put(old_prog);
@@ -1784,7 +1784,7 @@ int gve_adjust_queues(struct gve_priv *priv,
 	rx_alloc_cfg.qcfg = &new_rx_config;
 	tx_alloc_cfg.num_rings = new_tx_config.num_queues;
 
-	if (netif_carrier_ok(priv->dev)) {
+	if (netif_running(priv->dev)) {
 		err = gve_adjust_config(priv, &tx_alloc_cfg, &rx_alloc_cfg);
 		return err;
 	}
@@ -2001,7 +2001,7 @@ static int gve_set_features(struct net_device *netdev,
 
 	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
 		netdev->features ^= NETIF_F_LRO;
-		if (netif_carrier_ok(netdev)) {
+		if (netif_running(netdev)) {
 			err = gve_adjust_config(priv, &tx_alloc_cfg, &rx_alloc_cfg);
 			if (err) {
 				/* Revert the change on error. */
@@ -2290,7 +2290,7 @@ static int gve_reset_recovery(struct gve_priv *priv, bool was_up)
 
 int gve_reset(struct gve_priv *priv, bool attempt_teardown)
 {
-	bool was_up = netif_carrier_ok(priv->dev);
+	bool was_up = netif_running(priv->dev);
 	int err;
 
 	dev_info(&priv->pdev->dev, "Performing reset\n");
@@ -2631,7 +2631,7 @@ static void gve_shutdown(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct gve_priv *priv = netdev_priv(netdev);
-	bool was_up = netif_carrier_ok(priv->dev);
+	bool was_up = netif_running(priv->dev);
 
 	rtnl_lock();
 	if (was_up && gve_close(priv->dev)) {
@@ -2649,7 +2649,7 @@ static int gve_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct gve_priv *priv = netdev_priv(netdev);
-	bool was_up = netif_carrier_ok(priv->dev);
+	bool was_up = netif_running(priv->dev);
 
 	priv->suspend_cnt++;
 	rtnl_lock();
-- 
2.43.0



