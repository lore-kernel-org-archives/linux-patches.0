Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF59283FE5;
	Tue, 16 Jun 2026 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623262; cv=none; b=dyckNAk7q0m9SlyAhPG7QIp0G1TSqiaRVcYlppHHV2sp4b9JhQkhCGIs7zVdjhvJiDg71odtf+zdHaaEI+ejl7Yi15IFBBPlkhyuJMRzje5W28l8MX0L0LIt4jSscrTLaKL1PMd8vsDRV1onUOvsuCyKX7Z9NIA+TUMxTtZ9QaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623262; c=relaxed/simple;
	bh=x9+EDesxwjktWTNrJyZpbv6kTOe6G1cNsloBaIxP43A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPnmiG+/UGHXELcfjF8Ve3L3PsEUwuA1AZVX/R3IbIrxL/SfFqwooLF8ZWHb3mUOuz8khRVN53VeYtpLbuaGCA5Ivr104sJLC1pkx7pW2l1LaPGXzZEk4xDq/uTFkYHY509IF9FilxQtqITvPN+fXo3rVNNJ0oXW0twjfeJDTcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7DXDT/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7DXDT/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5856B1F000E9;
	Tue, 16 Jun 2026 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623261;
	bh=1vRoenilc1SU8CPnWadofg+0VnytpMnANDmvgZwHXIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7DXDT/QJys903o3i0VG51AAsiMyG2Nl7ZQwl9WRPOGZ2vi4PL/vFnPgMjSW1FX2F
	 ol9MzbNeV3juvbB19Js6wcM1qb5LiDFcmqBFcLXRWqj4DiNM/5YBUP7JFunMOeB/rZ
	 dwkhPeN2eX29BMKo7GjWExneqt/YtGo/oH4EI9jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 116/378] net: phy: Clean the phy_ports after unregistering the downstream SFP bus
Date: Tue, 16 Jun 2026 20:25:47 +0530
Message-ID: <20260616145116.470435194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 4497f5028675b7e51c4aa59c3f4df01f29424277 ]

As reported by sashiko when looking a other patches, we need to ensure
that the downstream SFP bus gets unregistered prior to destroying the
phy_ports attached to a phy_device, as the SFP code may reference these
ports. Let's make sure we follow that ordering in phy_remove().

Fixes: 589e934d2735 ("net: phy: Introduce PHY ports representation")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260604092819.723505-4-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 111e3f3deb96f4..8b7e2789047694 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3822,11 +3822,11 @@ static int phy_remove(struct device *dev)
 
 	phydev->state = PHY_DOWN;
 
-	phy_cleanup_ports(phydev);
-
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
 
+	phy_cleanup_ports(phydev);
+
 	if (phydev->drv && phydev->drv->remove)
 		phydev->drv->remove(phydev);
 
-- 
2.53.0



