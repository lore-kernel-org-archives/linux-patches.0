Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0393D3D06;
	Wed,  8 Apr 2026 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672434; cv=none; b=tBuTQTQ2hB9qV3yowgkDoEDvoCMvlZNAf7LI7XXuIKNklxmUxR0N3f/tke+WF7WsWGeWqv8dWo7K1t6tmlH3MXSSZo6cYB9eBtxu8D4gWKMQUhNR0sCNhgPJBx037ay4ZkpSZj0oq6GsftY5FjLcBfU1xez7PYXXPUrYEzMiyJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672434; c=relaxed/simple;
	bh=vP4tSGiM7SusYeCawu572V1IPd5BkIfF+9xHuWNl+eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo8PzThaL/6QRNJDxf1MhjVh5FVGUWPhqG0+OPxUTFrbfGQEEOyqo3cdmWGab09HfG62RqYlDPzONgmVsjZ4ukz+4IOf1+ae+F2R/d1Mbvj1yzkNFHVynvzZtIJGHxLRRDX9ZvGtE/nDXNzyGoNGRveO+bytjR3F9RxwdR77VF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnyOLi+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnyOLi+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F3DC19421;
	Wed,  8 Apr 2026 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672434;
	bh=vP4tSGiM7SusYeCawu572V1IPd5BkIfF+9xHuWNl+eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnyOLi+PVT3axfEICm/Zt5m6I2815AhHlVEHePNd/HbY8JpoWaHo2vva80LJWI6MF
	 P63QILUmZ9Ypdysp+xExaYkAz2a0w6C3a7EHfq+0LS+vAKpKiNphe0hwLpmUUkmPdn
	 s2AL7vKQRh1j7wkwp4vOkpGiwhUAuwRVznro3vgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.1 304/312] net: phy: fix phy_uses_state_machine()
Date: Wed,  8 Apr 2026 20:03:41 +0200
Message-ID: <20260408175945.128007403@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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


