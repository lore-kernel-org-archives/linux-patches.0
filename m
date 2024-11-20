Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686481A4F1B;
	Wed, 20 Nov 2024 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107500; cv=none; b=T6S4A4dKqMeG45gSTI+TGxS/uolFqdOIsFdDUieQs314l2uj1dZvQuenlyl+wBItAUbvoK7IpkwXydNDKwNKzl3uNnh9mUxSkpZTP6fMO0lZsZZHue0tgUZVe6FdtuooW4C6f2eAVSOKmHMhzOZx/t+f5+1YbVD9gzU+tnzEVlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107500; c=relaxed/simple;
	bh=PkmnAeRKd2QD8xZaOpS8iRJhiKaNbPMWNsVii1AAb2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxoHqgtpM7ZvWPkNf05oNPEMVAyL7FWAQoKQqTv4KcmmT2DqSIwOvLnKFNICoK4E1vaNj2IGnC1tWETs0lLZa2LuAVQbRU4oirPrUsGajABmuCauo9VprS9q/csNANwsn35p9BKvQ+7g0Qi63HQaGe3zs6/NwUL6TXOpJG23lrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9N7JaXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9N7JaXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFBCC4CED1;
	Wed, 20 Nov 2024 12:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107500;
	bh=PkmnAeRKd2QD8xZaOpS8iRJhiKaNbPMWNsVii1AAb2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9N7JaXS6qivmrDxm7Az49B3pD0wSmAuhxDt9dLPc1myZTFzrqHzhw/A0R8UrGA04
	 C8RermQnF6VtZQlMSy6KQZZMqthAR9ou60VQNG1UsM0lMHyL8+F6Im+D3c+iEwlEn0
	 cNEvKwY5EOa+6IGiA4WIRmfblGwto5peveq4pWtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 024/107] net: phylink: ensure PHY momentary link-fails are handled
Date: Wed, 20 Nov 2024 13:55:59 +0100
Message-ID: <20241120125630.222045890@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 671154f174e0e7f242507cd074497661deb41bfd ]

Normally, phylib won't notify changes in quick succession. However, as
a result of commit 3e43b903da04 ("net: phy: Immediately call
adjust_link if only tx_lpi_enabled changes") this is no longer true -
it is now possible that phy_link_down() and phy_link_up() will both
complete before phylink's resolver has run, which means it'll miss that
pl->phy_state.link momentarily became false.

Rename "mac_link_dropped" to be more generic "link_failed" since it will
cover more than the MAC/PCS end of the link failing, and arrange to set
this in phylink_phy_change() if we notice that the PHY reports that the
link is down.

This will ensure that we capture an EEE reconfiguration event.

Fixes: 3e43b903da04 ("net: phy: Immediately call adjust_link if only tx_lpi_enabled changes")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/E1tAtcW-002RBS-LB@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 51c526d227fab..ed60836180b78 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -78,7 +78,7 @@ struct phylink {
 	unsigned int pcs_neg_mode;
 	unsigned int pcs_state;
 
-	bool mac_link_dropped;
+	bool link_failed;
 	bool using_mac_select_pcs;
 
 	struct sfp_bus *sfp_bus;
@@ -1475,9 +1475,9 @@ static void phylink_resolve(struct work_struct *w)
 		cur_link_state = pl->old_link_state;
 
 	if (pl->phylink_disable_state) {
-		pl->mac_link_dropped = false;
+		pl->link_failed = false;
 		link_state.link = false;
-	} else if (pl->mac_link_dropped) {
+	} else if (pl->link_failed) {
 		link_state.link = false;
 		retrigger = true;
 	} else {
@@ -1572,7 +1572,7 @@ static void phylink_resolve(struct work_struct *w)
 			phylink_link_up(pl, link_state);
 	}
 	if (!link_state.link && retrigger) {
-		pl->mac_link_dropped = false;
+		pl->link_failed = false;
 		queue_work(system_power_efficient_wq, &pl->resolve);
 	}
 	mutex_unlock(&pl->state_mutex);
@@ -1793,6 +1793,8 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 		pl->phy_state.pause |= MLO_PAUSE_RX;
 	pl->phy_state.interface = phydev->interface;
 	pl->phy_state.link = up;
+	if (!up)
+		pl->link_failed = true;
 	mutex_unlock(&pl->state_mutex);
 
 	phylink_run_resolve(pl);
@@ -2116,7 +2118,7 @@ EXPORT_SYMBOL_GPL(phylink_disconnect_phy);
 static void phylink_link_changed(struct phylink *pl, bool up, const char *what)
 {
 	if (!up)
-		pl->mac_link_dropped = true;
+		pl->link_failed = true;
 	phylink_run_resolve(pl);
 	phylink_dbg(pl, "%s link %s\n", what, up ? "up" : "down");
 }
@@ -2750,7 +2752,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	 * link will cycle.
 	 */
 	if (manual_changed) {
-		pl->mac_link_dropped = true;
+		pl->link_failed = true;
 		phylink_run_resolve(pl);
 	}
 
-- 
2.43.0



