Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA42C423A91;
	Tue, 10 Mar 2026 11:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142181; cv=none; b=mUWppiMnw4CNqESXDrDMrmZeM5otpLZdstRKlgq1xpofoexfR3+c3KWaUu2RIiR61e+fuvBCdRwcVSs7lxtlhjrUTMbRmljLtM+vLl6det/Rxdv7VV72jkHcBzBXh+XKDjvsVg4m+/iFOliZ+sTfCMq+szqWu9kzffPo+UQ3svg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142181; c=relaxed/simple;
	bh=DOcHOucg+H3NTKFtwLKj/6BCClA419754tRWZe64FL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra4PSoJJKgDlMfWSJgBYlxUYN9xfIyI+AEuMLKVQDIa70LhY7uGi+lCtPhTXpqsNyxY3B7laooGYFevh/HVRO0E4zQcUgtQH0UxOPX966oAb7KlPmysBQyN+YS7wNXP+i7nz9HmgJd8OwhSNaAlrscrs9pIBsbwikzPWBCkoAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m93LtbQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m93LtbQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F136EC19423;
	Tue, 10 Mar 2026 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142181;
	bh=DOcHOucg+H3NTKFtwLKj/6BCClA419754tRWZe64FL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m93LtbQ+QLvyy2hC1saoy/vqEPYAM1XvWNsvfb78RFZlfcbZrn/MnxeOr4re0L8Cl
	 n9Gaan1jSds6jsiB52CK1RNV1zBkuDJL+Ync00CO1hHl3VybVnnxc931r8JyMwVZnu
	 jiaF4pok7pzobd+Rs+xknRZLVWT3JRwm9N3Ut0FexvWvZtpYhP6dxEa6x1NTtyXFTL
	 gqOjrQJfhrNpGZMw7AMrOGA1qBUdAx2+9clfVYG63QmjezTcZp8wQk6bXTcOM7uvus
	 Ke/ISodBzcOEthzkURIJHfGwbFj/zIDJzhGrcKMCq/uo7qv22MlY8yC2n1TKD7Cmrf
	 RD+B2GCX+7JsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raju Rangoju <Raju.Rangoju@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/314] amd-xgbe: fix sleep while atomic on suspend/resume
Date: Tue, 10 Mar 2026 07:18:49 -0400
Message-ID: <355822532adb1aba935416f17ad3de1944b950a5.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit e2f27363aa6d983504c6836dd0975535e2e9dba0 ]

The xgbe_powerdown() and xgbe_powerup() functions use spinlocks
(spin_lock_irqsave) while calling functions that may sleep:
- napi_disable() can sleep waiting for NAPI polling to complete
- flush_workqueue() can sleep waiting for pending work items

This causes a "BUG: scheduling while atomic" error during suspend/resume
cycles on systems using the AMD XGBE Ethernet controller.

The spinlock protection in these functions is unnecessary as these
functions are called from suspend/resume paths which are already serialized
by the PM core

Fix this by removing the spinlock. Since only code that takes this lock
is xgbe_powerdown() and xgbe_powerup(), remove it completely.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20260302042124.1386445-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 10 ----------
 drivers/net/ethernet/amd/xgbe/xgbe-main.c |  1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h      |  3 ---
 3 files changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index ba5e728ae6308..89ece3dbd773a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1089,7 +1089,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	unsigned long flags;
 
 	DBGPR("-->xgbe_powerdown\n");
 
@@ -1100,8 +1099,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pdata->lock, flags);
-
 	if (caller == XGMAC_DRIVER_CONTEXT)
 		netif_device_detach(netdev);
 
@@ -1117,8 +1114,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 
 	pdata->power_down = 1;
 
-	spin_unlock_irqrestore(&pdata->lock, flags);
-
 	DBGPR("<--xgbe_powerdown\n");
 
 	return 0;
@@ -1128,7 +1123,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	unsigned long flags;
 
 	DBGPR("-->xgbe_powerup\n");
 
@@ -1139,8 +1133,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pdata->lock, flags);
-
 	pdata->power_down = 0;
 
 	xgbe_napi_enable(pdata, 0);
@@ -1155,8 +1147,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 
 	xgbe_start_timers(pdata);
 
-	spin_unlock_irqrestore(&pdata->lock, flags);
-
 	DBGPR("<--xgbe_powerup\n");
 
 	return 0;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index d1f0419edb234..7d45ea22a02e2 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -76,7 +76,6 @@ struct xgbe_prv_data *xgbe_alloc_pdata(struct device *dev)
 	pdata->netdev = netdev;
 	pdata->dev = dev;
 
-	spin_lock_init(&pdata->lock);
 	spin_lock_init(&pdata->xpcs_lock);
 	mutex_init(&pdata->rss_mutex);
 	spin_lock_init(&pdata->tstamp_lock);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index e8bbb68059013..6fec51a065e22 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1003,9 +1003,6 @@ struct xgbe_prv_data {
 	unsigned int pp3;
 	unsigned int pp4;
 
-	/* Overall device lock */
-	spinlock_t lock;
-
 	/* XPCS indirect addressing lock */
 	spinlock_t xpcs_lock;
 	unsigned int xpcs_window_def_reg;
-- 
2.51.0

