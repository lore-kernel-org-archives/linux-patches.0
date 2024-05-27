Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC00017E90E;
	Mon, 27 May 2024 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836994; cv=none; b=NdzdfH9DH9vAuKGUhPSNOer0E1ufFEnX8p6q6MzLOl/3afyLQ5ZqqOWpqFGhOQFubNUNKeE7tb8fwylcUldXKJebRLo0zZn6Ze9nnHXNFhE52iqxlqU59w2lxd5C51nuWKlyVSKBSPe6L8jFSB1esWCz+NMpKmnFCkCxjxsVgcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836994; c=relaxed/simple;
	bh=nNFcQ1ZF+Rx0eUOKg3T4yoS9wlhHHP1mQyGA7vXdvVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW8dQznEhqoM4ExHa3Zr7ZcsRRG3kFIgMJ3Fxi0UWOGj15chhN9RmLSrX01DXwHdT4skxMP5aaekXd+cAOmiCLiGzVBgkb6Vimk0Vz5Qxd9LGpmxAhZOKVXR64i6hNWubeYEdm8x5HQjRMuyfHb5UkQX6bn+6zz31m07wNzxHK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA7BkKjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA7BkKjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C20C32781;
	Mon, 27 May 2024 19:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836994;
	bh=nNFcQ1ZF+Rx0eUOKg3T4yoS9wlhHHP1mQyGA7vXdvVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA7BkKjXL9VfbpLGzOkFsn8JoEN3VKEPh0TkgmLQyCCJ12JoteW0l0tZ20+jmnI4E
	 wNJ+g5PqLPM6aYpb2tkP1wXPxqi1W226sdSklSq5LMmwFTuNmUTeLyU1lMhJ2/mbfq
	 fs4fAOAQSsHkCHBczfwhtlIHQseQRU/Y7ap/FxRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 267/427] net: micrel: Fix receiving the timestamp in the frame for lan8841
Date: Mon, 27 May 2024 20:55:14 +0200
Message-ID: <20240527185627.386334862@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit aea27a92a41dae14843f92c79e9e42d8f570105c ]

The blamed commit started to use the ptp workqueue to get the second
part of the timestamp. And when the port was set down, then this
workqueue is stopped. But if the config option NETWORK_PHY_TIMESTAMPING
is not enabled, then the ptp_clock is not initialized so then it would
crash when it would try to access the delayed work.
So then basically by setting up and then down the port, it would crash.
The fix consists in checking if the ptp_clock is initialized and only
then cancel the delayed work.

Fixes: cc7554954848 ("net: micrel: Change to receive timestamp in the frame for lan8841")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index ddb50a0e2bc82..87780465cd0d5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4676,7 +4676,8 @@ static int lan8841_suspend(struct phy_device *phydev)
 	struct kszphy_priv *priv = phydev->priv;
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
 
-	ptp_cancel_worker_sync(ptp_priv->ptp_clock);
+	if (ptp_priv->ptp_clock)
+		ptp_cancel_worker_sync(ptp_priv->ptp_clock);
 
 	return genphy_suspend(phydev);
 }
-- 
2.43.0



