Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE420B3E;
	Tue, 23 Apr 2024 21:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908486; cv=none; b=GkmiMkCF9zQfhYEyFia6W+29R1ogGkwJWIGd7Y7KhQiTd9OdMHKIVYK4hZHosLDvDUUdHKmXDCYsoOu8vCyOx4+F1mki9W4vJqWbGdrviOxaooBgew1/HO13cRTFRy8wwzmdxXxdhULv3UdBPep57oPw+U3pDUH58PuWTWN02kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908486; c=relaxed/simple;
	bh=kR1K/5EMF7T2dHJ7047eKQMAPCvgo+KjdNx4HX3+6lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un88+Q0Y25+XKjuU4xykg5oUwxzHRP383lCCOuowZgo8E3TwcjNVXjV9vK7MXpvVFGa723Yt4gxbRFY6q3qgmfr9YiN26Ytw83UWjOp7BT49VpxJXJiHWOil5sPk5hK5Mk5f6LOBp7JEnjnPxiCKOn/cPSAhsmI2EpfZ7qq7ZTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y73Nge7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y73Nge7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33429C32782;
	Tue, 23 Apr 2024 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908486;
	bh=kR1K/5EMF7T2dHJ7047eKQMAPCvgo+KjdNx4HX3+6lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y73Nge7DeL3Rou6YTH3WOsxBiQR/F9BlyWoOkKB2yrcxo7szVhreUGWm89Ac6Lwjb
	 G380MQuJAqLU1lAvUa5fQa5DfgW3/usnmW+lxd6ZmwykkWIMBjBzDNoTbZUELKg0ou
	 bZP8fRlX2gA0NFQK2QQZzyhaia+yjNNd82jgKnuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 035/158] net: stmmac: Fix max-speed being ignored on queue re-init
Date: Tue, 23 Apr 2024 14:37:37 -0700
Message-ID: <20240423213857.043051488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 59c3d6ca6cbded6c6599e975b42a9d6a27fcbaf2 ]

It's possible to have the maximum link speed being artificially limited on
the platform-specific basis. It's done either by setting up the
plat_stmmacenet_data::max_speed field or by specifying the "max-speed"
DT-property. In such cases it's required that any specific
MAC-capabilities re-initializations would take the limit into account. In
particular the link speed capabilities may change during the number of
active Tx/Rx queues re-initialization. But the currently implemented
procedure doesn't take the speed limit into account.

Fix that by calling phylink_limit_mac_speed() in the
stmmac_reinit_queues() method if the speed limitation was required in the
same way as it's done in the stmmac_phy_setup() function.

Fixes: 95201f36f395 ("net: stmmac: update MAC capabilities when tx queues are updated")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cbb00ca23a7c3..2a48277ed614f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7272,6 +7272,7 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret = 0, i;
+	int max_speed;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -7287,6 +7288,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	stmmac_mac_phylink_get_caps(priv);
 
+	max_speed = priv->plat->max_speed;
+	if (max_speed)
+		phylink_limit_mac_speed(&priv->phylink_config, max_speed);
+
 	stmmac_napi_add(dev);
 
 	if (netif_running(dev))
-- 
2.43.0



