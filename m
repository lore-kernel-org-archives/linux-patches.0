Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104930EF6D;
	Wed, 25 Feb 2026 06:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002713; cv=none; b=WvLsN+Tm14LVDpt7/HufrRxpzPKgfrLWrnSv/4Ic+RPj+KIamOupYIK0uqwS+ak6mC/l3ldzWzWxsMfsYbsGWvUxKCCgvdQmcTqForaq/a/+PNwlBveGCkXE0E5R32pRBleASGN+bNXfO6xt03cjZbyl9gThS1CJCq78TiXbIgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002713; c=relaxed/simple;
	bh=wXwRHI4PNoqXXL7QdZexHPHv4QEkjFJoVB2fqZm5aa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3bzTHqh997kCEvS4Q4DC6NKmu6k7NrS+oQXTQqh5LsoR0T4L6Pow+NzGiOYnyvdKAOoDV5dgY9KXrD/xVv9YHLDvyEHnZ/oAyNW6yuB8nsWCEl6b2JjrVj317Gas7LKrqFDUQAOM9+UWhaUpSMC3f1Vv9ECd//KuZSWbFBMka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuPVm0na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuPVm0na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC86C116D0;
	Wed, 25 Feb 2026 06:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002713;
	bh=wXwRHI4PNoqXXL7QdZexHPHv4QEkjFJoVB2fqZm5aa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuPVm0naajertTwLNMDjlmtamhQ8LXaCeEN5icv86NaPb38D9IMcmkOwXJ5zUzwFY
	 J4IZIYlB+KWVxSHInp2lGm3+Mi9+/Jkt3uBhsSC97yKa3zTVhyV4JIPWp+2KlhvCXu
	 6AFY1r0HCV8yrlcNpckw02JPyVlekvqEXJhkdqKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 520/641] net: mscc: ocelot: split xmit into FDMA and register injection paths
Date: Tue, 24 Feb 2026 17:24:06 -0800
Message-ID: <20260225012401.128610734@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 47f79b20e7fb885aa1623b759a68e8e27401ec4d ]

Split ocelot_port_xmit() into two separate functions:
- ocelot_port_xmit_fdma(): handles the FDMA injection path
- ocelot_port_xmit_inj(): handles the register-based injection path

The top-level ocelot_port_xmit() now dispatches to the appropriate
function based on the ocelot_fdma_enabled static key.

This is a pure refactor with no behavioral change. Separating the two
code paths makes each one simpler and prepares for adding proper locking
to the register injection path without affecting the FDMA path.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260208225602.1339325-3-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 026f6513c588 ("net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 39 ++++++++++++++++++++------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index ef4a6c768de9b..a7966c174b2e2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -571,7 +571,25 @@ static bool ocelot_xmit_timestamp(struct ocelot *ocelot, int port,
 	return true;
 }
 
-static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ocelot_port_xmit_fdma(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->port.index;
+	u32 rew_op = 0;
+
+	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
+		return NETDEV_TX_OK;
+
+	ocelot_fdma_inject_frame(ocelot, port, rew_op, skb, dev);
+
+	return NETDEV_TX_OK;
+}
+
+static netdev_tx_t ocelot_port_xmit_inj(struct sk_buff *skb,
+					struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -579,24 +597,27 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	int port = priv->port.index;
 	u32 rew_op = 0;
 
-	if (!static_branch_unlikely(&ocelot_fdma_enabled) &&
-	    !ocelot_can_inject(ocelot, 0))
+	if (!ocelot_can_inject(ocelot, 0))
 		return NETDEV_TX_BUSY;
 
 	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
 		return NETDEV_TX_OK;
 
-	if (static_branch_unlikely(&ocelot_fdma_enabled)) {
-		ocelot_fdma_inject_frame(ocelot, port, rew_op, skb, dev);
-	} else {
-		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
-		consume_skb(skb);
-	}
+	consume_skb(skb);
 
 	return NETDEV_TX_OK;
 }
 
+static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	if (static_branch_unlikely(&ocelot_fdma_enabled))
+		return ocelot_port_xmit_fdma(skb, dev);
+
+	return ocelot_port_xmit_inj(skb, dev);
+}
+
 enum ocelot_action_type {
 	OCELOT_MACT_LEARN,
 	OCELOT_MACT_FORGET,
-- 
2.51.0



