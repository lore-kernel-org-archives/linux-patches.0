Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131002638B2;
	Wed, 17 Sep 2025 12:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112964; cv=none; b=l3mc3yHWkepw1HeD+EAS9Lgm5T33g6ZiObudgfYlczt7P5OOtus2MX6W6MCW68SqegeVto8JOE5ZA7E9SXlrH3E+I6F3myeVNy/uVCW5A0wrjIda04OiAAGUBYvw0A5OGKi5TWsEMHUcnttqlTxOfqLQ36OIPFhN2SdmvtCj4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112964; c=relaxed/simple;
	bh=cddpF56Hc/D+ienmDNEoPW8ijN1rXQjH+pm/pomxal0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+31DiueA7bImJT+Ug7Wn0ousHf+kcQ3YLT6gCm2sLhgkVGsrsNrJAl0+3nwll+Br3HmzJWFqDTAa9fE7+qN0Utru8fnf/7U7mHK2B+msosx+RVc/3NaVx2yzSKvwN/YF40GeEYmGz/TGyfn7POKhHgBbOSZ7jAHK09+xkK6iz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr7vH6BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr7vH6BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0D5C4CEF0;
	Wed, 17 Sep 2025 12:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112963;
	bh=cddpF56Hc/D+ienmDNEoPW8ijN1rXQjH+pm/pomxal0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr7vH6BH9XBo6aittN1HPl6PEZIXykN05WJaf31fYFuZPylqKIb8BEW1OFgeNdvqR
	 ll8E0Wt4VzZpcS1+VXuuQvDXBog9Mq6gqbBqpvy11H9sYg16zAbdCsJXPl5JuvRZ5x
	 AmL0vd2zaLlIb8V5eVun0CeOTdNXPifVOHBdhsZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 129/189] net: phy: transfer phy_config_inband() locking responsibility to phylink
Date: Wed, 17 Sep 2025 14:33:59 +0200
Message-ID: <20250917123355.010945795@linuxfoundation.org>
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

[ Upstream commit e2a10daba84968f6b5777d150985fd7d6abc9c84 ]

Problem description
===================

Lockdep reports a possible circular locking dependency (AB/BA) between
&pl->state_mutex and &phy->lock, as follows.

phylink_resolve() // acquires &pl->state_mutex
-> phylink_major_config()
   -> phy_config_inband() // acquires &pl->phydev->lock

whereas all the other call sites where &pl->state_mutex and
&pl->phydev->lock have the locking scheme reversed. Everywhere else,
&pl->phydev->lock is acquired at the top level, and &pl->state_mutex at
the lower level. A clear example is phylink_bringup_phy().

The outlier is the newly introduced phy_config_inband() and the existing
lock order is the correct one. To understand why it cannot be the other
way around, it is sufficient to consider phylink_phy_change(), phylink's
callback from the PHY device's phy->phy_link_change() virtual method,
invoked by the PHY state machine.

phy_link_up() and phy_link_down(), the (indirect) callers of
phylink_phy_change(), are called with &phydev->lock acquired.
Then phylink_phy_change() acquires its own &pl->state_mutex, to
serialize changes made to its pl->phy_state and pl->link_config.
So all other instances of &pl->state_mutex and &phydev->lock must be
consistent with this order.

Problem impact
==============

I think the kernel runs a serious deadlock risk if an existing
phylink_resolve() thread, which results in a phy_config_inband() call,
is concurrent with a phy_link_up() or phy_link_down() call, which will
deadlock on &pl->state_mutex in phylink_phy_change(). Practically
speaking, the impact may be limited by the slow speed of the medium
auto-negotiation protocol, which makes it unlikely for the current state
to still be unresolved when a new one is detected, but I think the
problem is there. Nonetheless, the problem was discovered using lockdep.

Proposed solution
=================

Practically speaking, the phy_config_inband() requirement of having
phydev->lock acquired must transfer to the caller (phylink is the only
caller). There, it must bubble up until immediately before
&pl->state_mutex is acquired, for the cases where that takes place.

Solution details, considerations, notes
=======================================

This is the phy_config_inband() call graph:

                          sfp_upstream_ops :: connect_phy()
                          |
                          v
                          phylink_sfp_connect_phy()
                          |
                          v
                          phylink_sfp_config_phy()
                          |
                          |   sfp_upstream_ops :: module_insert()
                          |   |
                          |   v
                          |   phylink_sfp_module_insert()
                          |   |
                          |   |   sfp_upstream_ops :: module_start()
                          |   |   |
                          |   |   v
                          |   |   phylink_sfp_module_start()
                          |   |   |
                          |   v   v
                          |   phylink_sfp_config_optical()
 phylink_start()          |   |
   |   phylink_resume()   v   v
   |   |  phylink_sfp_set_config()
   |   |  |
   v   v  v
 phylink_mac_initial_config()
   |   phylink_resolve()
   |   |  phylink_ethtool_ksettings_set()
   v   v  v
   phylink_major_config()
            |
            v
    phy_config_inband()

phylink_major_config() caller #1, phylink_mac_initial_config(), does not
acquire &pl->state_mutex nor do its callers. It must acquire
&pl->phydev->lock prior to calling phylink_major_config().

phylink_major_config() caller #2, phylink_resolve() acquires
&pl->state_mutex, thus also needs to acquire &pl->phydev->lock.

phylink_major_config() caller #3, phylink_ethtool_ksettings_set(), is
completely uninteresting, because it only calls phylink_major_config()
if pl->phydev is NULL (otherwise it calls phy_ethtool_ksettings_set()).
We need to change nothing there.

Other solutions
===============

The lock inversion between &pl->state_mutex and &pl->phydev->lock has
occurred at least once before, as seen in commit c718af2d00a3 ("net:
phylink: fix ethtool -A with attached PHYs"). The solution there was to
simply not call phy_set_asym_pause() under the &pl->state_mutex. That
cannot be extended to our case though, where the phy_config_inband()
call is much deeper inside the &pl->state_mutex section.

Fixes: 5fd0f1a02e75 ("net: phylink: add negotiation of in-band capabilities")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250904125238.193990-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c     | 12 ++++--------
 drivers/net/phy/phylink.c |  9 +++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 13df28445f020..c02da57a4da5e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1065,23 +1065,19 @@ EXPORT_SYMBOL_GPL(phy_inband_caps);
  */
 int phy_config_inband(struct phy_device *phydev, unsigned int modes)
 {
-	int err;
+	lockdep_assert_held(&phydev->lock);
 
 	if (!!(modes & LINK_INBAND_DISABLE) +
 	    !!(modes & LINK_INBAND_ENABLE) +
 	    !!(modes & LINK_INBAND_BYPASS) != 1)
 		return -EINVAL;
 
-	mutex_lock(&phydev->lock);
 	if (!phydev->drv)
-		err = -EIO;
+		return -EIO;
 	else if (!phydev->drv->config_inband)
-		err = -EOPNOTSUPP;
-	else
-		err = phydev->drv->config_inband(phydev, modes);
-	mutex_unlock(&phydev->lock);
+		return -EOPNOTSUPP;
 
-	return err;
+	return phydev->drv->config_inband(phydev, modes);
 }
 EXPORT_SYMBOL(phy_config_inband);
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 08cbb31e6dbc1..229a503d601ee 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1411,6 +1411,7 @@ static void phylink_get_fixed_state(struct phylink *pl,
 static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
 {
 	struct phylink_link_state link_state;
+	struct phy_device *phy = pl->phydev;
 
 	switch (pl->req_link_an_mode) {
 	case MLO_AN_PHY:
@@ -1434,7 +1435,11 @@ static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
 	link_state.link = false;
 
 	phylink_apply_manual_flow(pl, &link_state);
+	if (phy)
+		mutex_lock(&phy->lock);
 	phylink_major_config(pl, force_restart, &link_state);
+	if (phy)
+		mutex_unlock(&phy->lock);
 }
 
 static const char *phylink_pause_to_str(int pause)
@@ -1575,6 +1580,8 @@ static void phylink_resolve(struct work_struct *w)
 
 	mutex_lock(&pl->phydev_mutex);
 	phy = pl->phydev;
+	if (phy)
+		mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
 	cur_link_state = phylink_link_is_up(pl);
 
@@ -1676,6 +1683,8 @@ static void phylink_resolve(struct work_struct *w)
 		queue_work(system_power_efficient_wq, &pl->resolve);
 	}
 	mutex_unlock(&pl->state_mutex);
+	if (phy)
+		mutex_unlock(&phy->lock);
 	mutex_unlock(&pl->phydev_mutex);
 }
 
-- 
2.51.0



