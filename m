Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21A62773DA;
	Tue, 21 Oct 2025 20:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077348; cv=none; b=L7LQnkQ07Ntn5xKPhF5EMImTQh42ABkax1nLN9w7xsLba60dFuHAXOMQXtybHl07b9DKP4GYQnNTWTcKsTtWVyrLCtNfis0T72BeYtOpscYWa4+iwf5RL/pGPe1Z+NxIb0YuLJ9/m40tMPBcjB7oXfrxsbjLlRsmBj4AM+qwAa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077348; c=relaxed/simple;
	bh=qEyGeTRcofAe7xBwrDlRLQ76a2UwsK0s7Lf2z1RPwi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxyCbPMgIlHH2Qw4lrNz0nFSr/BbvPdGk69apJiO6AUU2YoiI0AQK6pZHmvg+FTJ3sPln+jfx/cLKHyQPzFGbwv6v7DcUE1XgtZuncoNIi4c87XuwjBT/3QrqcOhDw/ej4GOgB+Qu/LNEKSqpkEZVYi2bommr4roI7m3ulGwZeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plcWJ3Q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plcWJ3Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6173DC4CEF1;
	Tue, 21 Oct 2025 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077347;
	bh=qEyGeTRcofAe7xBwrDlRLQ76a2UwsK0s7Lf2z1RPwi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plcWJ3Q0r6Uf+B/4+ADDMpwCF+vNB6ZKw90njXCFxAFuKAWZoLQDi2ynS+kv3bBb1
	 bJbryd/DLamK0NaN2HglYDbqnRzkMJQLDxMQXzNCshXMS8SnCx7ahVFw/d9x0+BZ/4
	 0M17d7KuDdkWmy3lVr1U3owPDbioC4daa8I0Mf1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 076/159] amd-xgbe: Avoid spurious link down messages during interface toggle
Date: Tue, 21 Oct 2025 21:50:53 +0200
Message-ID: <20251021195045.026899733@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 2616222e423398bb374ffcb5d23dea4ba2c3e524 ]

During interface toggle operations (ifdown/ifup), the driver currently
resets the local helper variable 'phy_link' to -1. This causes the link
state machine to incorrectly interpret the state as a link change event,
resulting in spurious "Link is down" messages being logged when the
interface is brought back up.

Preserve the phy_link state across interface toggles to avoid treating
the -1 sentinel value as a legitimate link state transition.

Fixes: 88131a812b16 ("amd-xgbe: Perform phy connect/disconnect at dev open/stop")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Link: https://patch.msgid.link/20251010065142.1189310-1-Raju.Rangoju@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2e9b95a94f89f..2ad672c17eec6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1065,7 +1065,6 @@ static void xgbe_free_rx_data(struct xgbe_prv_data *pdata)
 
 static int xgbe_phy_reset(struct xgbe_prv_data *pdata)
 {
-	pdata->phy_link = -1;
 	pdata->phy_speed = SPEED_UNKNOWN;
 
 	return pdata->phy_if.phy_reset(pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 1a37ec45e6502..7675bb98f0295 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1555,6 +1555,7 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		pdata->phy.duplex = DUPLEX_FULL;
 	}
 
+	pdata->phy_link = 0;
 	pdata->phy.link = 0;
 
 	pdata->phy.pause_autoneg = pdata->pause_autoneg;
-- 
2.51.0



