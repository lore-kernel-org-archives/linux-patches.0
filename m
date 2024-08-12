Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95349183CD9;
	Mon, 12 Aug 2024 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479904; cv=none; b=COtBXK+Uy+Bx2MyuZPWMkdHi0KLyvg5wE6flQA9t8czIyDg8oulkoD8e2QSHRfNktBqVsmeQgyjGQND9/NacAoK+1Fq6IRY8+kFBJGI43yXh+JBL9B2x1hZdnxUpt6vt1wJpE5t3Gs5prGrMqqhozHwI3+Qbt/k3OJ7NH8dHECI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479904; c=relaxed/simple;
	bh=oyMqCvXtz5FhN1RE1/A9XI898gnP3oAA0g/T4/HNeEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5nRxBywpfx06uYWw01ep8yfS4ivt5h1+gte7hrn9Gk64A62uM2iQ7LPtg0Ed5wMgNvUIvVo1gMhqvXPtngYGTfy1bEjRzNVWiZXvtwnU2lGFSVgxPSQQ77Rs+Cht76OkaYC7iEHsYlMdKLMS/d1ZY7kst/0ZJlcaCUJ7PCOpUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deL6mfJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deL6mfJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03762C32782;
	Mon, 12 Aug 2024 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479904;
	bh=oyMqCvXtz5FhN1RE1/A9XI898gnP3oAA0g/T4/HNeEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deL6mfJw/bTzAnmXWkijBMxxrQ38uPcaJoZ9aL7KNdRyDlGAI17Sc5W6WeaLEv/yA
	 cL6FbnsUx05N8Ng7Kxrmy/C/AnlsgYQUtY76JjtiXoT1GqYOE0AcSJnrm4sXxtAN/R
	 d8uNdOMswk8lb4+HMwaltYXsl7PiWP8HZJGgMKIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 036/263] net: bcmgenet: Properly overlay PHY and MAC Wake-on-LAN capabilities
Date: Mon, 12 Aug 2024 18:00:37 +0200
Message-ID: <20240812160147.924923660@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



