Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2D3CF663;
	Wed,  8 Apr 2026 13:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655079; cv=none; b=gtlcNlj1jkXiUE9f2dmkhQaFPU8cCHjVHZHfidJ86ApWIIeLrHBRgrCkDDx4LpHrGBRF4fHNm54LDjHkB/9ya45PMVGEnyCsNKfCTOh4FbNlMtMSdr/ZKoEhRuZjmqRXNTiBkPkp+PWMxoFG+wpIPbOT9+ShHmmWWjhpAa4IA3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655079; c=relaxed/simple;
	bh=gNdIRjFYWG73OgbhMtf6BKFhRXtdJgL8eg+uCm94fMc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=jfHr8+VP7XZqcSgOB4En2H1Cq3ffXM1BXN827cGF9mznsmGUoRoc8HO31llM7LcGAH1LBWHnbWHS3Uj1YueHHzJFxMLKpAMtQjB81raK8H72aLExNVL28jWSyQD//J8IbVK+sb3x1bvcM3ZAOBaNsoH1jxpLvAdwN71GlRBLNHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7P1i72y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7P1i72y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50400C19421;
	Wed,  8 Apr 2026 13:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775655079;
	bh=gNdIRjFYWG73OgbhMtf6BKFhRXtdJgL8eg+uCm94fMc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=w7P1i72ywrgPijI9mpVO3Sj6Ehg8/UwqYpQPNaamMhZu3QNmIhS83jXcgx9ejVkAU
	 t9Bi1R/sFNF9UP1OqZQuF2ydOfjS6N2UcxpQ1NnN5jzWbJ6N4LMT7n7z+bc6QZ9JsG
	 WqmT2nLWJfcWqhq3KKV3v+OpyrcDPNaEpTplGNbw=
Subject: Patch "net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()" has been added to the 6.1-stable tree
To: 681739313@139.com,andrew@lunn.ch,davem@davemloft.net,edumazet@google.com,gregkh@linuxfoundation.org,hkallweit1@gmail.com,kuba@kernel.org,linux@armlinux.org.uk,pabeni@redhat.com,patches@lists.linux.dev,rmk+kernel@armlinux.org.uk,vladimir.oltean@nxp.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 08 Apr 2026 15:30:52 +0200
In-Reply-To: <20260327015120.1712759-1-681739313@139.com>
Message-ID: <2026040852-rewind-flannels-f4c9@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-phy-move-phy_link_change-prior-to-mdio_bus_phy_may_suspend.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 681739313@139.com Fri Mar 27 02:51:43 2026
From: Rajani Kantha <681739313@139.com>
Date: Fri, 27 Mar 2026 09:51:20 +0800
Subject: net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, vladimir.oltean@nxp.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk
Message-ID: <20260327015120.1712759-1-681739313@139.com>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f40a673d6b4a128fe95dd9b8c3ed02da50a6a862 ]

In an upcoming change, mdio_bus_phy_may_suspend() will need to
distinguish a phylib-based PHY client from a phylink PHY client.
For that, it will need to compare the phydev->phy_link_change() function
pointer with the eponymous phy_link_change() provided by phylib.

To avoid forward function declarations, the default PHY link state
change method should be moved upwards. There is no functional change
associated with this patch, it is only to reduce the noise from a real
bug fix.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250407093900.2155112-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Minor context change fixed ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -234,6 +234,19 @@ static struct phy_driver genphy_driver;
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
+static void phy_link_change(struct phy_device *phydev, bool up)
+{
+	struct net_device *netdev = phydev->attached_dev;
+
+	if (up)
+		netif_carrier_on(netdev);
+	else
+		netif_carrier_off(netdev);
+	phydev->adjust_link(netdev);
+	if (phydev->mii_ts && phydev->mii_ts->link_state)
+		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
+}
+
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
@@ -1036,19 +1049,6 @@ struct phy_device *phy_find_first(struct
 }
 EXPORT_SYMBOL(phy_find_first);
 
-static void phy_link_change(struct phy_device *phydev, bool up)
-{
-	struct net_device *netdev = phydev->attached_dev;
-
-	if (up)
-		netif_carrier_on(netdev);
-	else
-		netif_carrier_off(netdev);
-	phydev->adjust_link(netdev);
-	if (phydev->mii_ts && phydev->mii_ts->link_state)
-		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
-}
-
 /**
  * phy_prepare_link - prepares the PHY layer to monitor link status
  * @phydev: target phy_device struct


Patches currently in stable-queue which might be from 681739313@139.com are

queue-6.1/net-phy-move-phy_link_change-prior-to-mdio_bus_phy_may_suspend.patch
queue-6.1/net-phy-fix-phy_uses_state_machine.patch
queue-6.1/net-phy-allow-mdio-bus-pm-ops-to-start-stop-state-machine-for-phylink-controlled-phy.patch
