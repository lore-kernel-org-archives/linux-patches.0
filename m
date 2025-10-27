Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA8D309F1E;
	Mon, 27 Oct 2025 19:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592232; cv=none; b=PKWCMPZXiXBeGNnL4shCZfON+WzLOtH1IzkMJm3JrIb1TgM4a/3p65N30DtBtB1g/+tzOBFltZ0rvFkcwPkZnJ73+D1uYnJOvfOxnTS1cUCtMWT7Hlt6MjRAUEs16TMA2vrvPbAVZh+aIbfVgVostjv9NDgRPB/G4w0jLS80OvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592232; c=relaxed/simple;
	bh=3qMZkSNCINONjM1bTFIxweh81EFMNYmG2/Uxzczi7pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAk9Lj1Vv2jZkf6TGkPA7QcMKvctyB0at/9UvGPlhSwsh2aHcZnLvG+nTqwM1vvPahQ0AOC1b8OwwnR3FVLcXtpEeGpIcZGfN6rhUdZ7m5cdKYG6XVtU3x5z4o6tq4wTd4fKBzOtJiRLylejqYiiz9ds7TXXzSmYNdupJn2Pezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h31wTqu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h31wTqu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71085C4CEF1;
	Mon, 27 Oct 2025 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592231;
	bh=3qMZkSNCINONjM1bTFIxweh81EFMNYmG2/Uxzczi7pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h31wTqu2dNgO/d5Q1ZoqQpPQQVa6x+wC46Mr5+BffQT0SX0teKdqiLvTX0c65viQq
	 yWU/6Y/ZnhcrDeB5hSY4tEcCLEJ/U2pF5dxGIb1RPxbVgSGXfcZcYNPVzoKW/yGenb
	 DG2t7opotW8lz/gQvXYe1nlxFb/mhrzUb1rptiM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/157] amd-xgbe: Avoid spurious link down messages during interface toggle
Date: Mon, 27 Oct 2025 19:35:03 +0100
Message-ID: <20251027183502.425866811@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 34d45cebefb5d..b4d57da71de2a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1172,7 +1172,6 @@ static void xgbe_free_rx_data(struct xgbe_prv_data *pdata)
 
 static int xgbe_phy_reset(struct xgbe_prv_data *pdata)
 {
-	pdata->phy_link = -1;
 	pdata->phy_speed = SPEED_UNKNOWN;
 
 	return pdata->phy_if.phy_reset(pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 19fed56b6ee3f..ebb8b3e5b9a88 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1636,6 +1636,7 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		pdata->phy.duplex = DUPLEX_FULL;
 	}
 
+	pdata->phy_link = 0;
 	pdata->phy.link = 0;
 
 	pdata->phy.pause_autoneg = pdata->pause_autoneg;
-- 
2.51.0



