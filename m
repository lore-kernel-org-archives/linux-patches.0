Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82243B3C03;
	Wed, 30 Sep 2026 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793236; cv=none; b=XH1YiuU6h7Bh7vYkqXA2U2meImPR4V3BEj5Mbk7FupLBzrQJiyyr8l2Lo4aVJxDrkdHH1J7IpJw3nKAaOF9Ks0TSpPsJSB1CIiuZ5rQL4XAJ46yua/Hi3t8M2Ei/UbescGk5OjlHRlvDV0U9bN2JFaCP0+j85FTwFuU/v0F7Yhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793236; c=relaxed/simple;
	bh=VMpt0EgWgaWqDnYPfDcMu1dVaDiuCK2c56qnE+bTf18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7jnyTGgGe+mM8evqRbuk0gM82GCwKVS+kAGvAl71po1worgQxQQ5btR7/Y+wj27GDKHkmp7UO04isx/LSlR7g0jx3Er8m/LPilyMw0ghIfuDI8ikrR6Se9aogTnak7bXEApcqaAx8tfB7ThxSWzbhWHOm7Nouhb272a4E9+Oo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE6sUaA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE6sUaA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545841F000FF;
	Wed, 30 Sep 2026 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793234;
	bh=nyPYC2cOOvRDDBlw6EEeyo+5W4vXBH4qS14j6UnH0vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TE6sUaA0T+ytm4UotqwFtGf8zdZOT8l4c44r+UhW2bx/q3mDjrcZcy3mqvINCw5O4
	 MEY0q9BOLgOUi1HEuIj3MaBUK2bq1mBFfB9I+VBzGArlZmna3Z3Smzy91H5pH4QT8b
	 vTuVcg2K8Um+TIvoRMJyWnfVbGvRNEwzvUzmpux4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/395] gve: Use extack to log xdp config verification errors
Date: Wed, 30 Sep 2026 17:27:26 +0200
Message-ID: <20260930152344.643221383@linuxfoundation.org>
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit 091a3b6ff2b98354270cb9278faad6d17d5aa27d ]

Plumb extack as it allows us to send more detailed error messages back
and append 'gve' suffix to method name per convention.

NL_SET_ERR_MSG_FMT_MOD doesn't support format string longer than 80
chars so keeping netdev warning with actual queue count details.

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20251106192746.243525-3-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3b430ea62340 ("gve: fix TX drop when GSO MSS is too small for hw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 24 ++++++++++++++--------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 78e72a1e71824..2f7d6fa82b374 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1707,18 +1707,21 @@ static int gve_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	return 0;
 }
 
-static int verify_xdp_configuration(struct net_device *dev)
+static int gve_verify_xdp_configuration(struct net_device *dev,
+					struct netlink_ext_ack *extack)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	u16 max_xdp_mtu;
 
 	if (dev->features & NETIF_F_LRO) {
-		netdev_warn(dev, "XDP is not supported when LRO is on.\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "XDP is not supported when LRO is on.");
 		return -EOPNOTSUPP;
 	}
 
 	if (priv->header_split_enabled) {
-		netdev_warn(dev, "XDP is not supported when header-data split is enabled.\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "XDP is not supported when header-data split is enabled.");
 		return -EOPNOTSUPP;
 	}
 
@@ -1727,17 +1730,20 @@ static int verify_xdp_configuration(struct net_device *dev)
 		max_xdp_mtu -= GVE_RX_PAD;
 
 	if (dev->mtu > max_xdp_mtu) {
-		netdev_warn(dev, "XDP is not supported for mtu %d.\n",
-			    dev->mtu);
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "XDP is not supported for mtu %d.",
+				       dev->mtu);
 		return -EOPNOTSUPP;
 	}
 
 	if (priv->rx_cfg.num_queues != priv->tx_cfg.num_queues ||
 	    (2 * priv->tx_cfg.num_queues > priv->tx_cfg.max_queues)) {
-		netdev_warn(dev, "XDP load failed: The number of configured RX queues %d should be equal to the number of configured TX queues %d and the number of configured RX/TX queues should be less than or equal to half the maximum number of RX/TX queues %d",
-			    priv->rx_cfg.num_queues,
-			    priv->tx_cfg.num_queues,
+		netdev_warn(dev,
+			    "XDP load failed: The number of configured RX queues %d should be equal to the number of configured TX queues %d and the number of configured RX/TX queues should be less than or equal to half the maximum number of RX/TX queues %d.",
+			    priv->rx_cfg.num_queues, priv->tx_cfg.num_queues,
 			    priv->tx_cfg.max_queues);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "XDP load failed: The number of configured RX queues should be equal to the number of configured TX queues and the number of configured RX/TX queues should be less than or equal to half the maximum number of RX/TX queues");
 		return -EINVAL;
 	}
 	return 0;
@@ -1748,7 +1754,7 @@ static int gve_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	struct gve_priv *priv = netdev_priv(dev);
 	int err;
 
-	err = verify_xdp_configuration(dev);
+	err = gve_verify_xdp_configuration(dev, xdp->extack);
 	if (err)
 		return err;
 	switch (xdp->command) {
-- 
2.53.0



