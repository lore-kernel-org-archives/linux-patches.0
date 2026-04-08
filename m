Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4985A3CF032;
	Wed,  8 Apr 2026 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655077; cv=none; b=IBYM9/EAVMzz0R0glMxGUha+xhwGVL+s7+EInI/puH76JfOGfPIyBDuY1Rrq6FenzWPcOjVurBfUBJEcVZKMp5KK5N1fy2obAlLM6zYN+YjcXBILOzFqay+bX+DIVJ+k3T97qT2fEr+L7RZrzTHkm8dOu+Bst4MIivzc3juQ/Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655077; c=relaxed/simple;
	bh=yiyUQOaVHlue1a1FwZAqP0l9Qeb5ldcjO8fxXLtDN20=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=XnXeLml3sfAxnDbFKcSgWB22XnMyaxQ/MgzDHULD00DzpJDFhr5zCFayAa2Pzm3ytB5uKk6yN5C3u/6a/p5jfEDysNlfVGmTOwxIiSDyfJfiDjGMcHC2OITD7XA6+kEnQQIUT35d7PaYHY9vWKbY0mOY/xdC1Yz7gqP45NsAov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOs7WU69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOs7WU69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC83CC19421;
	Wed,  8 Apr 2026 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775655077;
	bh=yiyUQOaVHlue1a1FwZAqP0l9Qeb5ldcjO8fxXLtDN20=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ZOs7WU69ELUt4f/7d3K+/M+rVTNjdx6rtk7fUZ7b7v4OyzacygBkhmwNeNwt2gc2t
	 VqkUnc9JDohG6+kBWeT+Gw3avRIuW9PsnPpTQ5vWKsN4X2/MD78SxJoFogmR4400pV
	 9ORJ0f6AdmJVxEJya57PY0z0jFuQOVvQKzcw/V3o=
Subject: Patch "net: phy: fix phy_uses_state_machine()" has been added to the 6.1-stable tree
To: 681739313@139.com,andrew@lunn.ch,davem@davemloft.net,edumazet@google.com,gregkh@linuxfoundation.org,hkallweit1@gmail.com,kuba@kernel.org,linux@armlinux.org.uk,pabeni@redhat.com,patches@lists.linux.dev,rmk+kernel@armlinux.org.uk,vladimir.oltean@nxp.com,xu.yang_2@nxp.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 08 Apr 2026 15:30:52 +0200
In-Reply-To: <20260327015316.1713133-1-681739313@139.com>
Message-ID: <2026040852-shock-fleshed-1272@gregkh>
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

    net: phy: fix phy_uses_state_machine()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-phy-fix-phy_uses_state_machine.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 681739313@139.com Fri Mar 27 02:53:35 2026
From: Rajani Kantha <681739313@139.com>
Date: Fri, 27 Mar 2026 09:53:16 +0800
Subject: net: phy: fix phy_uses_state_machine()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, rmk+kernel@armlinux.org.uk
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com, netdev@vger.kernel.org, xu.yang_2@nxp.com
Message-ID: <20260327015316.1713133-1-681739313@139.com>

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit e0d1c55501d377163eb57feed863777ed1c973ad ]

The blamed commit changed the conditions which phylib uses to stop
and start the state machine in the suspend and resume paths, and
while improving it, has caused two issues.

The original code used this test:

	phydev->attached_dev && phydev->adjust_link

and if true, the paths would handle the PHY state machine. This test
evaluates true for normal drivers that are using phylib directly
while the PHY is attached to the network device, but false in all
other cases, which include the following cases:

- when the PHY has never been attached to a network device.
- when the PHY has been detached from a network device (as phy_detach()
   sets phydev->attached_dev to NULL, phy_disconnect() calls
   phy_detach() and additionally sets phydev->adjust_link NULL.)
- when phylink is using the driver (as phydev->adjust_link is NULL.)

Only the third case was incorrect, and the blamed commit attempted to
fix this by changing this test to (simplified for brevity, see
phy_uses_state_machine()):

	phydev->phy_link_change == phy_link_change ?
		phydev->attached_dev && phydev->adjust_link : true

However, this also incorrectly evaluates true in the first two cases.

Fix the first case by ensuring that phy_uses_state_machine() returns
false when phydev->phy_link_change is NULL.

Fix the second case by ensuring that phydev->phy_link_change is set to
NULL when phy_detach() is called.

Reported-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20250806082931.3289134-1-xu.yang_2@nxp.com
Fixes: fc75ea20ffb4 ("net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/E1uvMEz-00000003Aoe-3qWe@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -270,8 +270,7 @@ static bool phy_uses_state_machine(struc
 	if (phydev->phy_link_change == phy_link_change)
 		return phydev->attached_dev && phydev->adjust_link;
 
-	/* phydev->phy_link_change is implicitly phylink_phy_change() */
-	return true;
+	return !!phydev->phy_link_change;
 }
 
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
@@ -1791,6 +1790,8 @@ void phy_detach(struct phy_device *phyde
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
+
+	phydev->phy_link_change = NULL;
 	phydev->phylink = NULL;
 
 	if (phydev->mdio.dev.driver)


Patches currently in stable-queue which might be from 681739313@139.com are

queue-6.1/net-phy-move-phy_link_change-prior-to-mdio_bus_phy_may_suspend.patch
queue-6.1/net-phy-fix-phy_uses_state_machine.patch
queue-6.1/net-phy-allow-mdio-bus-pm-ops-to-start-stop-state-machine-for-phylink-controlled-phy.patch
