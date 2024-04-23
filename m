Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454F1143C57;
	Tue, 23 Apr 2024 21:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908607; cv=none; b=Bz8ruUMvMlTE4reJ1Z/hsupZSZJOGbCt/L9AdItUOA08irma0mXOgzWi9HaA2NSUIy4NMUpcBQs1l4pYrUiBtpzkl+PEI457HxRwygG5SfXhmhgukr8OuGI1zhZR4HIJHLb7gMvcftKt37d9y1EwBTYoRTzpdyyMiMCYoCOtGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908607; c=relaxed/simple;
	bh=3wIssquwTqiM+xxrJv1A0ZVICBaFj6PcpDYCT/z8CTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8j6uDbrZy07nDVFZdRVxSj+P9o06TrBSOwgS6lGS6YuHh8LxJyBLZ2blKw5eDKBiE3jqeIizI+DzcfdQ0ewT6N2luLGF984VZcjGF9tsS6DrR8U0eMCmtiDpe/0Fip0YdYtcOFcpnPPY8rnz4eCm5fAkRt9ZA0DWdy5FIKL58I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mqm6c7/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mqm6c7/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A487C32781;
	Tue, 23 Apr 2024 21:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908607;
	bh=3wIssquwTqiM+xxrJv1A0ZVICBaFj6PcpDYCT/z8CTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mqm6c7/iCUac9TMkVyyfcqQdcQQyScm4YkF3D9ZacYcb0/UWryO3LZ11+m6mo0ujg
	 3AK+Cc7BGzqn/aCPVcEGolnBw/qE5hQJN1PPwATApzaqNjXyFX5Y9WL8ha99nHNx/E
	 Xkwbwp+rz9R2HRc3LrlybK6bI+q0/83WDPEA/En0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/158] net: stmmac: Fix max-speed being ignored on queue re-init
Date: Tue, 23 Apr 2024 14:38:04 -0700
Message-ID: <20240423213857.301948064@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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
index f3dbbc900d498..2479e9a5f9d22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7170,6 +7170,7 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret = 0, i;
+	int max_speed;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -7185,6 +7186,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	stmmac_mac_phylink_get_caps(priv);
 
+	max_speed = priv->plat->max_speed;
+	if (max_speed)
+		phylink_limit_mac_speed(&priv->phylink_config, max_speed);
+
 	stmmac_napi_add(dev);
 
 	if (netif_running(dev))
-- 
2.43.0



