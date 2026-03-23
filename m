Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC644235C01;
	Mon, 23 Mar 2026 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277980; cv=none; b=nfPocLubMQDZ6142tFzILMAWgbIiVLrvtBioeU3FnwkztyEJQZfgpwiO9922hynf2QuGhfKU3lgM4l7TaaSz1YWwxJ8x5M3JkDUVbaRvWVO5kMnmFOslDvR4s8cCP1y2qsVAraxxiUZTb3zoMcacCo7w4puQjZf+NaBKQ7VbCDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277980; c=relaxed/simple;
	bh=KPP0gk6ht9AHwK5wgvZJmrcBlAUtL39WMa4nfD8wy3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbQD6xorxs6f79bvKncDChwW3MyOOkrDnBo8GlMV+3sHo+MYPPXQVGdhcitISVp14dA3cL0dQ4qndL/Ama1W1Rkt74bwsLnsdI+AKPOCxeiALVMxIJVyKJ+AhhxS+NrNu2Z0UxW8pCYJaXqOw4/NeWYRDNtxTpSFgA454+ii3Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpxxbvTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpxxbvTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9239C4CEF7;
	Mon, 23 Mar 2026 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277980;
	bh=KPP0gk6ht9AHwK5wgvZJmrcBlAUtL39WMa4nfD8wy3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpxxbvTHaJ9RlLPkA3kX5X+8mnpr4kQwqw24YMWZlBj0KYQvRX5DBoQEylmaItoun
	 o7uRMlQ03I7HVQpbzFb86xlaQ0qcQMuX1LXInOJsNTpCeREFbpGTebztIYn0+LBTwq
	 BRQ1az1AqQVpPGdotzOCSEC23DRBcIB6PhHYHfYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/567] amd-xgbe: fix sleep while atomic on suspend/resume
Date: Mon, 23 Mar 2026 14:41:23 +0100
Message-ID: <20260323134537.855995140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 3d6f8f3a83366..256969ac2cb9e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1181,7 +1181,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	unsigned long flags;
 
 	DBGPR("-->xgbe_powerdown\n");
 
@@ -1192,8 +1191,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pdata->lock, flags);
-
 	if (caller == XGMAC_DRIVER_CONTEXT)
 		netif_device_detach(netdev);
 
@@ -1209,8 +1206,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 
 	pdata->power_down = 1;
 
-	spin_unlock_irqrestore(&pdata->lock, flags);
-
 	DBGPR("<--xgbe_powerdown\n");
 
 	return 0;
@@ -1220,7 +1215,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	unsigned long flags;
 
 	DBGPR("-->xgbe_powerup\n");
 
@@ -1231,8 +1225,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pdata->lock, flags);
-
 	pdata->power_down = 0;
 
 	xgbe_napi_enable(pdata, 0);
@@ -1247,8 +1239,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 
 	xgbe_start_timers(pdata);
 
-	spin_unlock_irqrestore(&pdata->lock, flags);
-
 	DBGPR("<--xgbe_powerup\n");
 
 	return 0;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 0e8698928e4d7..6e8fafb2acbaa 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -185,7 +185,6 @@ struct xgbe_prv_data *xgbe_alloc_pdata(struct device *dev)
 	pdata->netdev = netdev;
 	pdata->dev = dev;
 
-	spin_lock_init(&pdata->lock);
 	spin_lock_init(&pdata->xpcs_lock);
 	mutex_init(&pdata->rss_mutex);
 	spin_lock_init(&pdata->tstamp_lock);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index a596cd08124fa..82a88d0c15e31 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1083,9 +1083,6 @@ struct xgbe_prv_data {
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



