Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321FD8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A795DC433C7;
	Sun, 16 Jul 2023 20:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539773;
	bh=iT23Ctd0nba/HiDdY3L3PKr1kFinLpxwvcVBFbTuD5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciY6kNdF9p0LDPCTjyVHleWJrZNLwx3vSeMHXfPNqmCUWjV59sLG2CB24GPZOGnnP
	 iGhypQyFDGu0XGbmkTWYO7gPByHmmWPnN4yGt5qARET/Tv8kMEM2pojwhWChdhjosp
	 z2/kgDvUO+xEQAPeg9EBJVKI0j/vof+3MuTGATpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Junxiao Chang <junxiao.chang@intel.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/591] net: stmmac: fix double serdes powerdown
Date: Sun, 16 Jul 2023 21:44:25 +0200
Message-ID: <20230716194927.135878275@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit c4fc88ad2a765224a648db8ab35f125e120fe41b ]

Commit 49725ffc15fc ("net: stmmac: power up/down serdes in
stmmac_open/release") correctly added a call to the serdes_powerdown()
callback to stmmac_release() but did not remove the one from
stmmac_remove() which leads to a doubled call to serdes_powerdown().

This can lead to all kinds of problems: in the case of the qcom ethqos
driver, it caused an unbalanced regulator disable splat.

Fixes: 49725ffc15fc ("net: stmmac: power up/down serdes in stmmac_open/release")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Junxiao Chang <junxiao.chang@intel.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20230621135537.376649-1-brgl@bgdev.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 30ce073055785..a07bcb2f5d2e2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7388,12 +7388,6 @@ int stmmac_dvr_remove(struct device *dev)
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
 
-	/* Serdes power down needs to happen after VLAN filter
-	 * is deleted that is triggered by unregister_netdev().
-	 */
-	if (priv->plat->serdes_powerdown)
-		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
-
 #ifdef CONFIG_DEBUG_FS
 	stmmac_exit_fs(ndev);
 #endif
-- 
2.39.2



