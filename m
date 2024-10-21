Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B001EF95E;
	Mon, 21 Oct 2024 10:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507391; cv=none; b=PrhnYCFktCfEE0jif0FSyh/RPSMbbNmFln9L4dixLGf96IiA1SKligRlfYDh/bcxo2QP13qJ69TdFpRjlW37RcaHz0uI7ABJKyXIzEPya6XUTDg3oPtysfsaT3m0JQQ92X80q/wYt7as6jv9X7+TRp1X6AEb2ygkB+YrzeS+QbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507391; c=relaxed/simple;
	bh=ZPl3GwxPNCYzrXA5cQROJAkeuUxRhkX/yRVXwHcgqg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyy1tcSuqAIV2RjQIxuZztNX+l1FlPZ6xLkSYksr7IMp3v5PUbEhAtmNkpMV68BK7YrkBEhlF7TK4cTMkxIdPmQi9Allv8kFVxp01z4Vo/wAPdnMDS6tZi7LYN5pds6Q/Xq6uvCXZU9l3v4SBrnjwTedp23ITZ6xrECW2ggTtJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EJCKiG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EJCKiG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D3DC4CEC3;
	Mon, 21 Oct 2024 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507391;
	bh=ZPl3GwxPNCYzrXA5cQROJAkeuUxRhkX/yRVXwHcgqg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EJCKiG1+oqVbhFaVnfiaLJaBiUzQp3AbEgn+neo9mbGiV80uzk36iCSSWtkXj0ax
	 NlctTie+0QQXkvDk1kQSyr01rYMHhwHPAbmrptWhCpZN31s/JDRopM8SKkMmfH6l8u
	 qkaL0Zp2CchP8I2LWS1eUtzQImRVhZr/AhkK24wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 30/91] net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY
Date: Mon, 21 Oct 2024 12:24:44 +0200
Message-ID: <20241021102251.000687298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit d0c3601f2c4e12e7689b0f46ebc17525250ea8c3 upstream.

A boot delay was introduced by commit 79540d133ed6 ("net: macb: Fix
handling of fixed-link node"). This delay was caused by the call to
`mdiobus_register()` in cases where a fixed-link PHY was present. The
MDIO bus registration triggered unnecessary PHY address scans, leading
to a 20-second delay due to attempts to detect Clause 45 (C45)
compatible PHYs, despite no MDIO bus being attached.

The commit 79540d133ed6 ("net: macb: Fix handling of fixed-link node")
was originally introduced to fix a regression caused by commit
7897b071ac3b4 ("net: macb: convert to phylink"), which caused the driver
to misinterpret fixed-link nodes as PHY nodes. This resulted in warnings
like:
mdio_bus f0028000.ethernet-ffffffff: fixed-link has invalid PHY address
mdio_bus f0028000.ethernet-ffffffff: scan phy fixed-link at address 0
...
mdio_bus f0028000.ethernet-ffffffff: scan phy fixed-link at address 31

This patch reworks the logic to avoid registering and allocation of the
MDIO bus when:
  - The device tree contains a fixed-link node.
  - There is no "mdio" child node in the device tree.

If a child node named "mdio" exists, the MDIO bus will be registered to
support PHYs  attached to the MACB's MDIO bus. Otherwise, with only a
fixed-link, the MDIO bus is skipped.

Tested on a sama5d35 based system with a ksz8863 switch attached to
macb0.

Fixes: 79540d133ed6 ("net: macb: Fix handling of fixed-link node")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241013052916.3115142-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -878,9 +878,6 @@ static int macb_mdiobus_register(struct
 		return ret;
 	}
 
-	if (of_phy_is_fixed_link(np))
-		return mdiobus_register(bp->mii_bus);
-
 	/* Only create the PHY from the device tree if at least one PHY is
 	 * described. Otherwise scan the entire MDIO bus. We do this to support
 	 * old device tree that did not follow the best practices and did not
@@ -901,8 +898,19 @@ static int macb_mdiobus_register(struct
 
 static int macb_mii_init(struct macb *bp)
 {
+	struct device_node *child, *np = bp->pdev->dev.of_node;
 	int err = -ENXIO;
 
+	/* With fixed-link, we don't need to register the MDIO bus,
+	 * except if we have a child named "mdio" in the device tree.
+	 * In that case, some devices may be attached to the MACB's MDIO bus.
+	 */
+	child = of_get_child_by_name(np, "mdio");
+	if (child)
+		of_node_put(child);
+	else if (of_phy_is_fixed_link(np))
+		return macb_mii_probe(bp->dev);
+
 	/* Enable management port */
 	macb_writel(bp, NCR, MACB_BIT(MPE));
 


