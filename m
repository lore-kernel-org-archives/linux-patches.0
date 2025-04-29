Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80A3FFD;
	Tue, 29 Apr 2025 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949649; cv=none; b=JeZM7zVnSR4mk2cBoEW3OeHia11hfw/TajAoPFQVtILhFW0OENgI94MV6b+yXI/jOuuQliLhfy+6XaBNb8mDP51VnQlAHe703fPJDTwH1vWSoBZexB+05ynKpSF3zE61PljTGHgzfTwktt2GusgHv1Uqq7vYEJtSS2chidSagFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949649; c=relaxed/simple;
	bh=la7WDOD7vvPzUNDk4jNXuFEONQlFx40s+1Dod6MdQYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNgIIUuqMQ4mgpvujCgucK1yTj93u7wp2NUQIje/HoKGcC38FxsF0DIBjAzy4QPgiY7yqzNuNK4ewGedFm+N4xQrZQRECqRAnd62R9omXMUuA4YOJp15coJGww6Y2u2AWoInBFIn+d53wVdLb7rPtc///rtgrY6ay55QHcqJ/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRAxHEXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRAxHEXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91399C4CEE3;
	Tue, 29 Apr 2025 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949649;
	bh=la7WDOD7vvPzUNDk4jNXuFEONQlFx40s+1Dod6MdQYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRAxHEXN5liO3apcQA40l0LAyf24JyzrRI7/AOkzWONquEKg7BWh+puAhxd/mtBIm
	 UUBH/SxCV9HurVlfUh4bpbcT+Wmx0j+wCisB7d8CbvUX4s56Dqc+8dIQtQrorZxs9M
	 PO6qRRTQD8oD/kVOnrJNzUKBK56mjTEfpBubIhxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/167] net: dsa: mv88e6xxx: move link forcing to mac_prepare/mac_finish
Date: Tue, 29 Apr 2025 18:42:00 +0200
Message-ID: <20250429161052.246916948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 267d7692f6cd5c9b8796324cdd54db594ca8d3e4 ]

Move the link forcing out of mac_config() and into the mac_prepare()
and mac_finish() methods. This results in no change to the order in
which these operations are performed, but does mean when we convert
mv88e6xxx to phylink_pcs support, we will continue to preserve this
ordering.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 52fdc41c3278 ("net: dsa: mv88e6xxx: fix internal PHYs for 6320 family")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 65 ++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4c60f79ce2697..b3744f2ea0f48 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -848,29 +848,38 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static int mv88e6xxx_mac_prepare(struct dsa_switch *ds, int port,
+				 unsigned int mode, phy_interface_t interface)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err = 0;
+
+	/* In inband mode, the link may come up at any time while the link
+	 * is not forced down. Force the link down while we reconfigure the
+	 * interface mode.
+	 */
+	if (mode == MLO_AN_INBAND &&
+	    chip->ports[port].interface != interface &&
+	    chip->info->ops->port_set_link) {
+		mv88e6xxx_reg_lock(chip);
+		err = chip->info->ops->port_set_link(chip, port,
+						     LINK_FORCED_DOWN);
+		mv88e6xxx_reg_unlock(chip);
+	}
+
+	return err;
+}
+
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 unsigned int mode,
 				 const struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	struct mv88e6xxx_port *p;
 	int err = 0;
 
-	p = &chip->ports[port];
-
 	mv88e6xxx_reg_lock(chip);
 
 	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
-		/* In inband mode, the link may come up at any time while the
-		 * link is not forced down. Force the link down while we
-		 * reconfigure the interface mode.
-		 */
-		if (mode == MLO_AN_INBAND &&
-		    p->interface != state->interface &&
-		    chip->info->ops->port_set_link)
-			chip->info->ops->port_set_link(chip, port,
-						       LINK_FORCED_DOWN);
-
 		err = mv88e6xxx_port_config_interface(chip, port,
 						      state->interface);
 		if (err && err != -EOPNOTSUPP)
@@ -887,24 +896,38 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 			err = 0;
 	}
 
+err_unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err && err != -EOPNOTSUPP)
+		dev_err(ds->dev, "p%d: failed to configure MAC/PCS\n", port);
+}
+
+static int mv88e6xxx_mac_finish(struct dsa_switch *ds, int port,
+				unsigned int mode, phy_interface_t interface)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err = 0;
+
 	/* Undo the forced down state above after completing configuration
 	 * irrespective of its state on entry, which allows the link to come
 	 * up in the in-band case where there is no separate SERDES. Also
 	 * ensure that the link can come up if the PPU is in use and we are
 	 * in PHY mode (we treat the PPU as an effective in-band mechanism.)
 	 */
+	mv88e6xxx_reg_lock(chip);
+
 	if (chip->info->ops->port_set_link &&
-	    ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
+	    ((mode == MLO_AN_INBAND &&
+	      chip->ports[port].interface != interface) ||
 	     (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
-		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
+		err = chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
 
-	p->interface = state->interface;
-
-err_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
-	if (err && err != -EOPNOTSUPP)
-		dev_err(ds->dev, "p%d: failed to configure MAC/PCS\n", port);
+	chip->ports[port].interface = interface;
+
+	return err;
 }
 
 static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
@@ -7024,7 +7047,9 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_get_caps	= mv88e6xxx_get_caps,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
+	.phylink_mac_prepare	= mv88e6xxx_mac_prepare,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
+	.phylink_mac_finish	= mv88e6xxx_mac_finish,
 	.phylink_mac_an_restart	= mv88e6xxx_serdes_pcs_an_restart,
 	.phylink_mac_link_down	= mv88e6xxx_mac_link_down,
 	.phylink_mac_link_up	= mv88e6xxx_mac_link_up,
-- 
2.39.5



