Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C891C07C4;
	Wed, 17 Sep 2025 12:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112960; cv=none; b=ut6aWsppVM2TQRMn2MRmXAkeAC7W8mkPWkImNBjgFXSzwekVdVCdZtZAqVWACLUECWnEEYadv/GUNavKuXKfM1kEKIyHsIsbohmNsVO86AL9iua3Dw4U9LJBNUi02N8gTpat3Cq+/2y8eQ4uMMrRHdRfUe/xnU/9btZTpW8ZMcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112960; c=relaxed/simple;
	bh=olrZzagAvrJhm/FSZOWj9bCa8SgPVkhwU/JQagU1f3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuKoyLyFPSfZ473rSRXhakY3DTGyty3+8gxR+9r3Tm2fzb+MZLB7OsXGqPIqzxdCvakCddlBMhVBwgXAst+GZSe8e/XKiunfLW06fkh0TxOPs9DE4PMgcEmu/o27ZzqX212eC8eN9TTfcXgA6nFz6LB/MJWR+xdsrOLupVIWu0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBSi9Agf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBSi9Agf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5355C4CEF0;
	Wed, 17 Sep 2025 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112960;
	bh=olrZzagAvrJhm/FSZOWj9bCa8SgPVkhwU/JQagU1f3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBSi9AgfXhoglF8cqGPXZSraj5sQLFnBh1suBFEgeBymI/Ve9zLTzq2SG36BczsIC
	 5EuUr7ToDSB9e6UnqGAMnPGNdbZ0aSXkLNEWapPqBSAnWe40Z50MV1nPslEgfdB8T/
	 gLjpP68soYHhIhoQk4o9rOvTLVBAShrC+1oXD6SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 128/189] net: phylink: add lock for serializing concurrent pl->phydev writes with resolver
Date: Wed, 17 Sep 2025 14:33:58 +0200
Message-ID: <20250917123354.987806387@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0ba5b2f2c381dbec9ed9e4ab3ae5d3e667de0dc3 ]

Currently phylink_resolve() protects itself against concurrent
phylink_bringup_phy() or phylink_disconnect_phy() calls which modify
pl->phydev by relying on pl->state_mutex.

The problem is that in phylink_resolve(), pl->state_mutex is in a lock
inversion state with pl->phydev->lock. So pl->phydev->lock needs to be
acquired prior to pl->state_mutex. But that requires dereferencing
pl->phydev in the first place, and without pl->state_mutex, that is
racy.

Hence the reason for the extra lock. Currently it is redundant, but it
will serve a functional purpose once mutex_lock(&phy->lock) will be
moved outside of the mutex_lock(&pl->state_mutex) section.

Another alternative considered would have been to let phylink_resolve()
acquire the rtnl_mutex, which is also held when phylink_bringup_phy()
and phylink_disconnect_phy() are called. But since phylink_disconnect_phy()
runs under rtnl_lock(), it would deadlock with phylink_resolve() when
calling flush_work(&pl->resolve). Additionally, it would have been
undesirable because it would have unnecessarily blocked many other call
paths as well in the entire kernel, so the smaller-scoped lock was
preferred.

Link: https://lore.kernel.org/netdev/aLb6puGVzR29GpPx@shell.armlinux.org.uk/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250904125238.193990-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e2a10daba849 ("net: phy: transfer phy_config_inband() locking responsibility to phylink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0faa3d97e06b9..08cbb31e6dbc1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -67,6 +67,8 @@ struct phylink {
 	struct timer_list link_poll;
 
 	struct mutex state_mutex;
+	/* Serialize updates to pl->phydev with phylink_resolve() */
+	struct mutex phydev_mutex;
 	struct phylink_link_state phy_state;
 	unsigned int phy_ib_mode;
 	struct work_struct resolve;
@@ -1568,8 +1570,11 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink_link_state link_state;
 	bool mac_config = false;
 	bool retrigger = false;
+	struct phy_device *phy;
 	bool cur_link_state;
 
+	mutex_lock(&pl->phydev_mutex);
+	phy = pl->phydev;
 	mutex_lock(&pl->state_mutex);
 	cur_link_state = phylink_link_is_up(pl);
 
@@ -1603,11 +1608,11 @@ static void phylink_resolve(struct work_struct *w)
 		/* If we have a phy, the "up" state is the union of both the
 		 * PHY and the MAC
 		 */
-		if (pl->phydev)
+		if (phy)
 			link_state.link &= pl->phy_state.link;
 
 		/* Only update if the PHY link is up */
-		if (pl->phydev && pl->phy_state.link) {
+		if (phy && pl->phy_state.link) {
 			/* If the interface has changed, force a link down
 			 * event if the link isn't already down, and re-resolve.
 			 */
@@ -1671,6 +1676,7 @@ static void phylink_resolve(struct work_struct *w)
 		queue_work(system_power_efficient_wq, &pl->resolve);
 	}
 	mutex_unlock(&pl->state_mutex);
+	mutex_unlock(&pl->phydev_mutex);
 }
 
 static void phylink_run_resolve(struct phylink *pl)
@@ -1806,6 +1812,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 	if (!pl)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&pl->phydev_mutex);
 	mutex_init(&pl->state_mutex);
 	INIT_WORK(&pl->resolve, phylink_resolve);
 
@@ -2066,6 +2073,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		     dev_name(&phy->mdio.dev), phy->drv->name, irq_str);
 	kfree(irq_str);
 
+	mutex_lock(&pl->phydev_mutex);
 	mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
 	pl->phydev = phy;
@@ -2111,6 +2119,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 
 	mutex_unlock(&pl->state_mutex);
 	mutex_unlock(&phy->lock);
+	mutex_unlock(&pl->phydev_mutex);
 
 	phylink_dbg(pl,
 		    "phy: %s setting supported %*pb advertising %*pb\n",
@@ -2289,6 +2298,7 @@ void phylink_disconnect_phy(struct phylink *pl)
 
 	ASSERT_RTNL();
 
+	mutex_lock(&pl->phydev_mutex);
 	phy = pl->phydev;
 	if (phy) {
 		mutex_lock(&phy->lock);
@@ -2298,8 +2308,11 @@ void phylink_disconnect_phy(struct phylink *pl)
 		pl->mac_tx_clk_stop = false;
 		mutex_unlock(&pl->state_mutex);
 		mutex_unlock(&phy->lock);
-		flush_work(&pl->resolve);
+	}
+	mutex_unlock(&pl->phydev_mutex);
 
+	if (phy) {
+		flush_work(&pl->resolve);
 		phy_disconnect(phy);
 	}
 }
-- 
2.51.0



