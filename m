Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6341E5705;
	Mon, 21 Oct 2024 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506875; cv=none; b=OZd+nhEy+DIQoiG4+8kPGHiQbKGpBZlMAa/P5Gc+TEkgrtanHxi8J1nVWcrLo/xvOj9jhrX1IKiLOIRBT5O1ERvYgDTfPE8LcYAA+WccPCdQpPsD8RBChSv2X6lELLaf14kMnAdDAyoveSdhk2uDNGLDfGLgFzAmZrY4zdUlGpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506875; c=relaxed/simple;
	bh=/gDQq5Ap8fIvaZvY4/xDghFze65mvXwXN/Eywj99QDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxm5Bz8NH5G/5txyjsEIeVnsgn+K9PNtGQ3oGZUu0eWzUBYaYZx4m1pDYahTACaOByfObxy1PL7/plOsiD3ADMQjlixW4fQ116D72yHhw/85Z+M7oN+mga8zRjk6rKt8O74M5WPwWfxNylj4TQYKZi7TSKdj+yNdUEY/32PgjVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnc9eYBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnc9eYBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA46C4CEC3;
	Mon, 21 Oct 2024 10:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506875;
	bh=/gDQq5Ap8fIvaZvY4/xDghFze65mvXwXN/Eywj99QDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnc9eYBuzOehI44upzdMvjrs7j8GEnkwThiM0lciBpgVy70g18tNUmPy1tV8jrtUj
	 fsw2qp5+HHw18giKIqlsw480UVZ1Xz22xZHXYNMXCwT088Dmal87laKK0Z/tVS+m22
	 Tmy4QRzWvwWXuLIhN04DsSdAvpkory/gtGyHSJEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 015/124] net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY
Date: Mon, 21 Oct 2024 12:23:39 +0200
Message-ID: <20241021102257.312650825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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
@@ -930,9 +930,6 @@ static int macb_mdiobus_register(struct
 		return ret;
 	}
 
-	if (of_phy_is_fixed_link(np))
-		return mdiobus_register(bp->mii_bus);
-
 	/* Only create the PHY from the device tree if at least one PHY is
 	 * described. Otherwise scan the entire MDIO bus. We do this to support
 	 * old device tree that did not follow the best practices and did not
@@ -953,8 +950,19 @@ static int macb_mdiobus_register(struct
 
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
 


