Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774556;
	b=DhozZQ39bIy8hU6lT7TIYfxFpPOHvkvzm3uL7uyDx4kHi6PBmh6Pl3Vjl89UfKZLachR
	 RyrykD59PI2MCFIvSH5YsERsAtznzQ1EWNKFRw0tvxYOxaHFNYnB0YelEC3z8LcyxpwEE
	 zgINqL3HQxKCiaTFa89ZWv6yB7/BLg3jiwYUkWL8OEuT33N28Xk63s3f7dmzryGBQ8/J8
	 /lGawyaRz0IDPVVBdd0TRydPNBBzkZzz5e0t1pccma2MDLBHQMBjjwnzaEx0O2YzuUxzN
	 Yj8qA7dj2JIH3/UYttblr+/tHyC1JZpcU7dsHQxd6f0thnBHClIo6Jiym0Kbs+ur0WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUcY/2akcbQLWP/MgbgnUPfDPJeBbch+QLRbuq3L2bY=;
	b=WQSkBXi+FRuBo5/aPWvq+cJshPnXvrvx4xIUcwfGdsLNW3uJ2SSqHtAXC0BH9VYGpsZS
	 ilVju1J/V6fohnKlDseCShYamTQvp7oPiwa2LJX9sMYjrVlP3gvRgZgsXDmHXHwHjCVIJ
	 pNpo49z5DFGdBrpsT22LC5guTY3LHoa25lNBP+F39l6qurt2p26EYFxfLqq/Uh18LJ2Nf
	 tmhUrF9iHVHafp1T1BZsskf5zR2alu3IdADFOIvd6VAKVlG33Ks6TmGDPu1XAxwTR7PJX
	 WJcU+1RVLCIJfY+WQA+neLPb963IC/+AxQgY8usUaHwc+8oPFi5STQILh0xiNDm+5OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdS4nrbz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0465C606A31B;
	Fri, 23 Oct 2026 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdS4nrbz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509881F01825;
	Fri, 23 Oct 2026 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774555;
	bh=JUcY/2akcbQLWP/MgbgnUPfDPJeBbch+QLRbuq3L2bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdS4nrbzB4Wjk/fsZ68gdlWyRtgAV2gwCldnhh9BVb5bhnOMc2fxFOhJ4O85bF8XY
	 7PHyCzbx8ztRLPGt3VGdy5OI410ljlTD5aBeP9fv4uMhSLh2y52Qy69D6HPGw56UZm
	 CJFCnO4wYjFP9aEKWve71ukrRAkUm8CjC8AibxD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 079/242] net: au1000: move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:41 +0200
Message-ID: <20261023163715.648234587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit beabbafdd0f6779813a7656baa1b412b19bda911 ]

au1000_probe() calls au1000_mii_probe(), which connects the PHY,
before dev->netdev_ops is assigned. phy_attach_direct() ->
phy_link_topo_add_phy() reads dev->netdev_ops through
netdev_need_ops_lock() since the commit in question, so probing crashes
with a NULL pointer dereference when CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261008022656.3592191-7-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/au1000_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 5a04056e38fa3..8682323d693f8 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1225,6 +1225,8 @@ static int au1000_probe(struct platform_device *pdev)
 		goto err_mdiobus_reg;
 	}
 
+	dev->netdev_ops = &au1000_netdev_ops;
+
 	err = au1000_mii_probe(dev);
 	if (err != 0)
 		goto err_out;
@@ -1263,7 +1265,6 @@ static int au1000_probe(struct platform_device *pdev)
 
 	dev->base_addr = base->start;
 	dev->irq = irq;
-	dev->netdev_ops = &au1000_netdev_ops;
 	dev->ethtool_ops = &au1000_ethtool_ops;
 	dev->watchdog_timeo = ETH_TX_TIMEOUT;
 
-- 
2.53.0



