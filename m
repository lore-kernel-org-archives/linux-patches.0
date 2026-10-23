Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774550;
	b=1aQbkdygvewtMrxCMW/bOqTI8nL7rBlk/VDh4Wv8NPEMuDpnzmewiQ94I1/DtRICosGR
	 KLAkzcaibrBRa+fdwWFWt8njblGJ2NryBWNG/QSOpzrLGCp7BT6U762b/0N23we8bl5f5
	 oW4vxGxaBzbOD+E2GdEDO+lxcY9p8YnbqYHFJ90Lya5a0T2RGb05skjwHO+vIs52eUN6a
	 ozS7oFiiyh8ZrFfUBUu+HOo/8pW5JzY9UOZI8XXFRAqmJRe4BKjjy20cNsdU1VX75C2l9
	 4/odHBu+nqocKFChIQy4nVrSPqJjy0ofQ35pNUz7/PBhGAptERAov+Vc8BDTFPknCdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EEPS5vUtNN4FvqXUlWHB8XDdDa3Iw0aAzINd6LxBgCY=;
	b=P3KOrNPIgmFQsRnMKJb/gEQBErTYV/elWcgTbIMy7hhe7I8qdBEmqOjNWSMK3DJ0jYn/
	 O+JFS9WU1VQI9Etk1txknErCchMHRRuqV1PJCtOtvIIT97micsulFgrmMgUAUIO5fAHY8
	 r6iZkyUnp3XY81ijS7T+reOY+4b6wtcDy7CjM6Z+nnuDPEjI0CE8tW7EE4Wfb1FjQMB+h
	 v6wocBQyrdKHCK3LWkpTlPkl2fGRSd1HWqbQbDZJ343ZSwL/E6+0k6faoPniR3yK6936i
	 hMSwwzaMWpIaed4C8O3wFSOxjmEyw/iikO+hiu1u49NXKl/AYVqRuVX4WVVGtDuPrbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwAhqYjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F58606A31A;
	Fri, 23 Oct 2026 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwAhqYjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588C71F01825;
	Fri, 23 Oct 2026 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774549;
	bh=EEPS5vUtNN4FvqXUlWHB8XDdDa3Iw0aAzINd6LxBgCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwAhqYjlW2m+GnvFmEQdVOY8drpJyaAlqOxBS0oC66J7lGECeGqs5cTsVDlVXWfa2
	 7QZnB5365lrlqpzCQPJKsuS8Hv/dPf6cZjYtOvWiYDvyp7HDRugnG5ycqV40f9SFSY
	 cSl72THHrFCsMC7osZokHTzzdWRV3CvRwX49G6Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 077/242] net: ethernet: actions: Move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:39 +0200
Message-ID: <20261023163715.600609555@linuxfoundation.org>
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

[ Upstream commit c2c4824319850c87e77d26aeb8f860bc310a64d7 ]

owl_emac_probe() calls owl_emac_phy_init(), which connects the PHY,
before netdev->netdev_ops is assigned. phy_attach_direct() ->
phy_link_topo_add_phy() reads dev->netdev_ops through
netdev_need_ops_lock() since the commit in question, so probing crashes
with a NULL pointer dereference when CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261008022656.3592191-4-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/actions/owl-emac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index 0a08da799255b..2538275a1e576 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -1552,6 +1552,8 @@ static int owl_emac_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	netdev->netdev_ops = &owl_emac_netdev_ops;
+
 	ret = owl_emac_phy_init(netdev);
 	if (ret) {
 		dev_err(dev, "failed to initialize PHY\n");
@@ -1563,7 +1565,6 @@ static int owl_emac_probe(struct platform_device *pdev)
 	netdev->min_mtu = OWL_EMAC_MTU_MIN;
 	netdev->max_mtu = OWL_EMAC_MTU_MAX;
 	netdev->watchdog_timeo = OWL_EMAC_TX_TIMEOUT;
-	netdev->netdev_ops = &owl_emac_netdev_ops;
 	netdev->ethtool_ops = &owl_emac_ethtool_ops;
 	netif_napi_add(netdev, &priv->napi, owl_emac_poll);
 
-- 
2.53.0



