Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B1D1F4298;
	Mon, 21 Oct 2024 10:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507813; cv=none; b=Nm2fQuy/oH8cCInKSsJOZrSDrNbc7Nj699gWtKFRcwRCMOFtxK7/xZdKiN60Tc6MPPY9sp+BBKgGdq9vdjcdplO3zlDvzOiyljJFW0IBQSh8ZdzdXwF9oTSCVcV8T/+N+s8KClQ5ysWHeIqrCIg3uQwy4GiSxaxipRsn24Oq3Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507813; c=relaxed/simple;
	bh=pyQoAlLqFfltAbeo5dYHQe87by4nvH/kJeX8CHNNdNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7sFtyztMkpfX6e+rbzuiHI2ZR008X4N2UNRYBApurzjKYoJUTnni2FouOdA+IimDz6/OA6lSOheJ2XgCEAPo7VhG8KBJ/FVvOQrxW7EG/1d1ilU6tQn++08SMOSE2pGWRQEBVeFmmZHpCDOB+JC1lGvSPOx6XXrO4hNC8EPQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvhJMYY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvhJMYY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F66EC4CEC7;
	Mon, 21 Oct 2024 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507813;
	bh=pyQoAlLqFfltAbeo5dYHQe87by4nvH/kJeX8CHNNdNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvhJMYY5nqcRKD2fK0dvMpidq4Jyvdxx1KuTXWGlD0JMLHBkEF0XQDA4+AUPAfs9t
	 J85szCMo1GS9LqAa39yN2Qcidx9ocudEpjZ4qK6oqLQFJDrXHa7vTF1Ht+gl/7bQZX
	 ldfzMfD69JncYQQogzZVhek4Bm2JPFb33Z6JTdxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 06/52] net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY
Date: Mon, 21 Oct 2024 12:25:27 +0200
Message-ID: <20241021102241.875841073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -742,9 +742,6 @@ static int macb_mdiobus_register(struct
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
 
-	if (of_phy_is_fixed_link(np))
-		return mdiobus_register(bp->mii_bus);
-
 	/* Only create the PHY from the device tree if at least one PHY is
 	 * described. Otherwise scan the entire MDIO bus. We do this to support
 	 * old device tree that did not follow the best practices and did not
@@ -765,8 +762,19 @@ static int macb_mdiobus_register(struct
 
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
 


