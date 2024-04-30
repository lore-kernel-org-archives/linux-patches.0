Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DEC1E50A;
	Tue, 30 Apr 2024 11:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475411; cv=none; b=UcbvAGbsuDaqoYq9aU0tz1+t0lGNC+8aGCvwoQktBEi1OIDp9Z5CZL1SNGBxcmV1cB/FawV3oZ0LYm1LGerbafOkPlpcM3a2VDPsBlPY3kj9/TGl02i4kByFqkoIwTvD2ZYxY2+RE20W7h3HRqrf3V4PDRSsfZKujvVpqJTjEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475411; c=relaxed/simple;
	bh=ruFcnDPBcK9qXr5wSPzOCISlrudimcnwMaurYehdjco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHaU2ukva7EVTqj2CRBSRPbhua4MW9c6Id7saP9e/ghDRw0ezkABP5SksD9EWRStTa+1/fS+wnX+qwhosCOMxF0QxV3WPGm6FoOxVTO4h4tUYaACBM4xZKPzYk7DSUpBaIdpXcNyrD8Diu3d7j66S+i6WNI3JsoUSGRuHU9qapU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbOpp5R1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbOpp5R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928D6C2BBFC;
	Tue, 30 Apr 2024 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475411;
	bh=ruFcnDPBcK9qXr5wSPzOCISlrudimcnwMaurYehdjco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbOpp5R1gh+a0B68F1NOA+3WJqtuZzE/GJwWnu5gWKqgJ2iwiNo9frNUtx1YLCni+
	 PGDJVko1luBCwAiESOHSxnY1WKXe1P6nZnAqEBCTeUWqTMYYHEismH8FAe21qOt2EM
	 mAfGCzoVVu3jFPflbS545OS7XbAm1dAExuz9puUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/186] net: phy: dp83869: Fix MII mode failure
Date: Tue, 30 Apr 2024 12:38:59 +0200
Message-ID: <20240430103100.559513024@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 6c9cd59dbcb09a2122b5ce0dfc07c74e6fc00dc0 ]

The DP83869 driver sets the MII bit (needed for PHY to work in MII mode)
only if the op-mode is either DP83869_100M_MEDIA_CONVERT or
DP83869_RGMII_100_BASE.

Some drivers i.e. ICSSG support MII mode with op-mode as
DP83869_RGMII_COPPER_ETHERNET for which the MII bit is not set in dp83869
driver. As a result MII mode on ICSSG doesn't work and below log is seen.

TI DP83869 300b2400.mdio:0f: selected op-mode is not valid with MII mode
icssg-prueth icssg1-eth: couldn't connect to phy ethernet-phy@0
icssg-prueth icssg1-eth: can't phy connect port MII0

Fix this by setting MII bit for DP83869_RGMII_COPPER_ETHERNET op-mode as
well.

Fixes: 94e86ef1b801 ("net: phy: dp83869: support mii mode when rgmii strap cfg is used")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83869.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index fa8c6fdcf3018..d7aaefb5226b6 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -695,7 +695,8 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 	phy_ctrl_val = dp83869->mode;
 	if (phydev->interface == PHY_INTERFACE_MODE_MII) {
 		if (dp83869->mode == DP83869_100M_MEDIA_CONVERT ||
-		    dp83869->mode == DP83869_RGMII_100_BASE) {
+		    dp83869->mode == DP83869_RGMII_100_BASE ||
+		    dp83869->mode == DP83869_RGMII_COPPER_ETHERNET) {
 			phy_ctrl_val |= DP83869_OP_MODE_MII;
 		} else {
 			phydev_err(phydev, "selected op-mode is not valid with MII mode\n");
-- 
2.43.0



