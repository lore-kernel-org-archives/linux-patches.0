Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05993876A6;
	Tue, 10 Mar 2026 11:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141256; cv=none; b=Smr1XiH6Wv0p3CB/mjSE+yryPyELWHvjvYr2lX72OJSxLEcdqGAVzUkDA9wN+pbs56VxY6A2yyhUKA5Mp86/xLWqDkBIjBDnY184ntMQ51mNtAUJ6cmwLP/93hCbeI5ZsSvPJsmmcvOVZb9HzTPTuwRwFj7uxz1M+hBvJ95bGr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141256; c=relaxed/simple;
	bh=ozqAq+j+NT/idGhBdAzLWFU+VqPI7yGGa2oRy5MqMNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ukvk86buPfBhlq4n07SzT2ho0Y5Jrax2fUxFNoOeel0jpjdumvaVLoImmGcNAM7aorBuagtRJ8frZ5xUGbfzBVJtpYv8/TUgczX/MAZlMNoc5TQ926x8tG8ONoZL1DqbnUyJCQ86ZUDv10rSycLbnw/e2Aw6Pc4vHW9yZbIH3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NclMTqfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NclMTqfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AFDC2BC86;
	Tue, 10 Mar 2026 11:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141255;
	bh=ozqAq+j+NT/idGhBdAzLWFU+VqPI7yGGa2oRy5MqMNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NclMTqfE/2Q2ra3el4TXQ+vCp4M43dK7oSzN99FR/0XrPjuDWEYlMTzV4hXhpN/MQ
	 hcl46gM3wkc7Cs59sW/D+ANqW6fSzHE6Gt0q1YuMdu2yyu19oa3L8h2FX1aJCyYeCU
	 OFsSweNhgmyUCB5F65rU9he0hIGQBcQ7yOpB6DsyU+pUSUjB+CIT404sMzBlNlwL/B
	 gGEsD7ECl8Z8FeYa2e4MW1rzBkuVR+pewWBhJKcqeeYGLmGMR7H21+6olZsgGx/+Q+
	 4ALc+l+JdHQnn6nh0sblR0KyyCzf9/qD6oHtQEkBVZLl4OMo3kfvSOq7QSXy5/Ke7k
	 akDBrS/UE1Cnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raju Rangoju <Raju.Rangoju@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 258/311] amd-xgbe: fix sleep while atomic on suspend/resume
Date: Tue, 10 Mar 2026 07:05:05 -0400
Message-ID: <9f4fe75fe872fa3239d5627110a361ad652ef690.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index b5a60a0488967..20ce2ed4cd9f7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1120,7 +1120,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	unsigned long flags;
 
 	DBGPR("-->xgbe_powerdown\n");
 
@@ -1131,8 +1130,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pdata->lock, flags);
-
 	if (caller == XGMAC_DRIVER_CONTEXT)
 		netif_device_detach(netdev);
 
@@ -1148,8 +1145,6 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 
 	pdata->power_down = 1;
 
-	spin_unlock_irqrestore(&pdata->lock, flags);
-
 	DBGPR("<--xgbe_powerdown\n");
 
 	return 0;
@@ -1159,7 +1154,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	unsigned long flags;
 
 	DBGPR("-->xgbe_powerup\n");
 
@@ -1170,8 +1164,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pdata->lock, flags);
-
 	pdata->power_down = 0;
 
 	xgbe_napi_enable(pdata, 0);
@@ -1186,8 +1178,6 @@ int xgbe_powerup(struct net_device *netdev, unsigned int caller)
 
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
index 03ef0f5484830..4ba23779b2b7e 100644
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

