Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8012472BC;
	Tue, 29 Apr 2025 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945905; cv=none; b=ijsEEjyxWUEvoL0APAQRb9dWHPvgbDNGxIqnlOEUwxdfiNMAPpvYKdsKHMFIZff5r6Y5mKDz6xV9DDUWJx8HXPavkv65shNdX0lhXpvmmWnzjihoymCTyBUfiegrJN/0aRL1vIXrZ6ZpC4eqODUBWRk9ig1fhqbdo6tmtiO1ROA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945905; c=relaxed/simple;
	bh=yjs88DAZtbz7hZ+JcZ60FSyoQkqXoz2l97retabuaS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6QA3V8DdY5hvJYwKlOwYhlrYJmLJMR+vT7Xd9yon03n0qPQ0dCucWrov1U0q3FJfTvaJR3GY7LfDt1mmmR99dQdf6MmG3SmSm2jsgYtNIK7QXVlepep7s0OXV5h02UC3Vs0a5BVzRxBj4je7Is2RwVgTe90Ye/DJQpls4ISPfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH3fuRZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH3fuRZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7854CC4CEE9;
	Tue, 29 Apr 2025 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945904;
	bh=yjs88DAZtbz7hZ+JcZ60FSyoQkqXoz2l97retabuaS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH3fuRZNJyppaE7KL7V/BIBiT65IN9UlkHZHsmCKT5NX2ATqsVRcgZE1lHN++Bg5a
	 X/S9FWuTnX/CTrOkkVmz29B0t3rgCHPtHu4Jh6YeRihJfJxbYjmu7BbmrDX1sJXfx4
	 i0gROAxSB9BaT9xouQg4Wr+CTpcw+kJdwW4/UDnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 059/311] net: phylink: force link down on major_config failure
Date: Tue, 29 Apr 2025 18:38:16 +0200
Message-ID: <20250429161123.460641019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit f1ae32a709e0b525d7963207eb3a4747626f4818 ]

If we fail to configure the MAC or PCS according to the desired mode,
do not allow the network link to come up until we have successfully
configured the MAC and PCS. This improves phylink's behaviour when an
error occurs.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1twkqO-0006FI-Gm@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4c8925cb9db1 ("net: phylink: fix suspend/resume with WoL enabled and link down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 42 +++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b00a315de0601..b74b1c3365000 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -82,6 +82,7 @@ struct phylink {
 	unsigned int pcs_state;
 
 	bool link_failed;
+	bool major_config_failed;
 	bool mac_supports_eee_ops;
 	bool mac_supports_eee;
 	bool phy_enable_tx_lpi;
@@ -1360,12 +1361,16 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		    phylink_an_mode_str(pl->req_link_an_mode),
 		    phy_modes(state->interface));
 
+	pl->major_config_failed = false;
+
 	if (pl->mac_ops->mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs)) {
 			phylink_err(pl,
 				    "mac_select_pcs unexpectedly failed: %pe\n",
 				    pcs);
+
+			pl->major_config_failed = true;
 			return;
 		}
 
@@ -1387,6 +1392,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		if (err < 0) {
 			phylink_err(pl, "mac_prepare failed: %pe\n",
 				    ERR_PTR(err));
+			pl->major_config_failed = true;
 			return;
 		}
 	}
@@ -1410,8 +1416,15 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	phylink_mac_config(pl, state);
 
-	if (pl->pcs)
-		phylink_pcs_post_config(pl->pcs, state->interface);
+	if (pl->pcs) {
+		err = phylink_pcs_post_config(pl->pcs, state->interface);
+		if (err < 0) {
+			phylink_err(pl, "pcs_post_config failed: %pe\n",
+				    ERR_PTR(err));
+
+			pl->major_config_failed = true;
+		}
+	}
 
 	if (pl->pcs_state == PCS_STATE_STARTING || pcs_changed)
 		phylink_pcs_enable(pl->pcs);
@@ -1422,11 +1435,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	err = phylink_pcs_config(pl->pcs, neg_mode, state,
 				 !!(pl->link_config.pause & MLO_PAUSE_AN));
-	if (err < 0)
-		phylink_err(pl, "pcs_config failed: %pe\n",
-			    ERR_PTR(err));
-	else if (err > 0)
+	if (err < 0) {
+		phylink_err(pl, "pcs_config failed: %pe\n", ERR_PTR(err));
+		pl->major_config_failed = true;
+	} else if (err > 0) {
 		restart = true;
+	}
 
 	if (restart)
 		phylink_pcs_an_restart(pl);
@@ -1434,16 +1448,22 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	if (pl->mac_ops->mac_finish) {
 		err = pl->mac_ops->mac_finish(pl->config, pl->act_link_an_mode,
 					      state->interface);
-		if (err < 0)
+		if (err < 0) {
 			phylink_err(pl, "mac_finish failed: %pe\n",
 				    ERR_PTR(err));
+
+			pl->major_config_failed = true;
+		}
 	}
 
 	if (pl->phydev && pl->phy_ib_mode) {
 		err = phy_config_inband(pl->phydev, pl->phy_ib_mode);
-		if (err < 0)
+		if (err < 0) {
 			phylink_err(pl, "phy_config_inband: %pe\n",
 				    ERR_PTR(err));
+
+			pl->major_config_failed = true;
+		}
 	}
 
 	if (pl->sfp_bus) {
@@ -1795,6 +1815,12 @@ static void phylink_resolve(struct work_struct *w)
 		}
 	}
 
+	/* If configuration of the interface failed, force the link down
+	 * until we get a successful configuration.
+	 */
+	if (pl->major_config_failed)
+		link_state.link = false;
+
 	if (link_state.link != cur_link_state) {
 		pl->old_link_state = link_state.link;
 		if (!link_state.link)
-- 
2.39.5



