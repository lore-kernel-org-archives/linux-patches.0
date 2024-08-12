Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8311862B4;
	Mon, 12 Aug 2024 16:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479231; cv=none; b=mCGHtK3QSPS3BgEMxqj6jDuDeNpPzb0hia6QED1Wjef3smGd4BVOQWoGR343Ch0uJaALdHvkpfItWgeyQLhlMZ3SEqzI/lRX4N3aSPtymd+UGJhuXqcU7oUagrFrwHvnbdNryx1exh6MT66wCNz/G1gTpi8rMHSAQf+w76muLa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479231; c=relaxed/simple;
	bh=hosxNisfAjYW4ZVdVwG4DdcKcIx1yqycuyJeEw6LOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKlmznw7wNtjt5A70lTiDaMEv5sQVY5DVGocy7GyYUrUbqR7NkwPv/6b5RBPE1Sptc2bX9TQtmpicCxAAwJpA3tYeJq6H/+cjkVJ25xboFVQPHhB8o6j8JPrL6lK8JMmmNgXG3YLMxuztEjgvNB83+q5XAkhOP8PypWM05bnnOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwuwoBEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwuwoBEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF06C32782;
	Mon, 12 Aug 2024 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479231;
	bh=hosxNisfAjYW4ZVdVwG4DdcKcIx1yqycuyJeEw6LOrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwuwoBEehiF4cbaDEHXsIUoPuUAzYcrr3jySniBM6TN0W1aRv8wV8mfW9AoerjYep
	 NW9I7XFbNb2DPHHmXPhQJ2AoowfWGkEupapvhTjz6K7p958L2qD7uIub7eWqOa8bwx
	 4KM+8iQmM/US7+W2ul/51V/IiWccgjuSnlEZW1A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/189] net: bcmgenet: Properly overlay PHY and MAC Wake-on-LAN capabilities
Date: Mon, 12 Aug 2024 18:01:18 +0200
Message-ID: <20240812160132.998302999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 9ee09edc05f20422e7ced84b1f8a5d3359926ac8 ]

Some Wake-on-LAN modes such as WAKE_FILTER may only be supported by the MAC,
while others might be only supported by the PHY. Make sure that the .get_wol()
returns the union of both rather than only that of the PHY if the PHY supports
Wake-on-LAN.

Fixes: 7e400ff35cbe ("net: bcmgenet: Add support for PHY-based Wake-on-LAN")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240806175659.3232204-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 1248792d7fd4d..0715ea5bf13ed 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -42,19 +42,15 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
 
-	if (dev->phydev) {
+	if (dev->phydev)
 		phy_ethtool_get_wol(dev->phydev, wol);
-		if (wol->supported)
-			return;
-	}
 
-	if (!device_can_wakeup(kdev)) {
-		wol->supported = 0;
-		wol->wolopts = 0;
+	/* MAC is not wake-up capable, return what the PHY does */
+	if (!device_can_wakeup(kdev))
 		return;
-	}
 
-	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
+	/* Overlay MAC capabilities with that of the PHY queried before */
+	wol->supported |= WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
 	wol->wolopts = priv->wolopts;
 	memset(wol->sopass, 0, sizeof(wol->sopass));
 
-- 
2.43.0



