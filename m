Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D013DBBF;
	Tue, 27 Feb 2024 13:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041517; cv=none; b=et82oWKfrXMK5wX3mrejdsUpBuPLxWbG+CbHNv68Q3SvU4IZ0/0oIGsHYvd4H1oXNU8TdfUYY2pLHpbIZoKYEgGloI/QmnJ5lbvCziXNLTzfexpxCBqGXTd+li0AAxOwfareSx/+B/V3YlwJPgUQsNquB6pMESYoOPx/2Cvx/t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041517; c=relaxed/simple;
	bh=mMgN0pdeyztAazltMhpIHv6h9ZEOFLUtmAe+xGwYtsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKPPtfCVEqKgeCHm8IhOqKim7LtDMkXumFH1HbHxovZ/VOSXjOjkKRhq1yaBiheUl1t0FGdspQ6gnJ0lnfnOrVpazqUJEV6/sFIVYw79H771ndPUkDQef7+tq3cZMelh4b7Z6mcHWBqUpEBCylBR8xsF8D0NBTkR4xfppo5E2iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8yULE3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8yULE3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66204C433C7;
	Tue, 27 Feb 2024 13:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041517;
	bh=mMgN0pdeyztAazltMhpIHv6h9ZEOFLUtmAe+xGwYtsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8yULE3Og9hAI0HzGm8HxuQDmKiqN9gFLnh8V0EE8SooSlXE1ldOav7554NoHuV2R
	 XClAMhOPHbbVEVl+tdp7+aivI1uFwAjRnbdOUYBBG/UtGO9z7XKidpVnCKvY6k8kxN
	 /Q7orfKOgORHTffryXsWCQVI/lll2f+S2Qo1MzS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@nokia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 05/52] net: stmmac: fix notifier registration
Date: Tue, 27 Feb 2024 14:25:52 +0100
Message-ID: <20240227131548.701928211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@nokia.com>

commit 474a31e13a4e9749fb3ee55794d69d0f17ee0998 upstream.

We cannot register the same netdev notifier multiple times when probing
stmmac devices. Register the notifier only once in module init, and also
make debugfs creation/deletion safe against simultaneous notifier call.

Fixes: 481a7d154cbb ("stmmac: debugfs entry name is not be changed when udev rename device name.")
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4067,6 +4067,8 @@ static void stmmac_init_fs(struct net_de
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	rtnl_lock();
+
 	/* Create per netdev entries */
 	priv->dbgfs_dir = debugfs_create_dir(dev->name, stmmac_fs_dir);
 
@@ -4078,14 +4080,13 @@ static void stmmac_init_fs(struct net_de
 	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
 			    &stmmac_dma_cap_fops);
 
-	register_netdevice_notifier(&stmmac_notifier);
+	rtnl_unlock();
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(priv->dbgfs_dir);
 }
 #endif /* CONFIG_DEBUG_FS */
@@ -4455,14 +4456,14 @@ int stmmac_dvr_remove(struct device *dev
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
-#ifdef CONFIG_DEBUG_FS
-	stmmac_exit_fs(ndev);
-#endif
 	stmmac_stop_all_dma(priv);
 
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
+#ifdef CONFIG_DEBUG_FS
+	stmmac_exit_fs(ndev);
+#endif
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
 	clk_disable_unprepare(priv->plat->pclk);
@@ -4679,6 +4680,7 @@ static int __init stmmac_init(void)
 	/* Create debugfs main directory if it doesn't exist yet */
 	if (!stmmac_fs_dir)
 		stmmac_fs_dir = debugfs_create_dir(STMMAC_RESOURCE_NAME, NULL);
+	register_netdevice_notifier(&stmmac_notifier);
 #endif
 
 	return 0;
@@ -4687,6 +4689,7 @@ static int __init stmmac_init(void)
 static void __exit stmmac_exit(void)
 {
 #ifdef CONFIG_DEBUG_FS
+	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(stmmac_fs_dir);
 #endif
 }


