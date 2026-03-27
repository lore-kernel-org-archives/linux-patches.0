Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0328640F
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 01:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774576405; cv=none; b=RL8vS9SDxWPlZzPjzgXXgv5kqZlcx7Vv3/A1bMFWJIMbl/je2L3Gx4i1+ZreG1fXzKGf3V8LTrmF8SO4LFEFxtG8qogROD0f504YcCBPxvquoCxxeESKvd5jQ15UzsJimzjYq6pKQU7oyRgvGLhKGsfl76jUnfM8Mg05fb4v7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774576405; c=relaxed/simple;
	bh=/eB1/rf/CU2pvZVuVrWldNffSXGURHHOo9QBNHEohe0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QQf1YdiekRWfIGyXFmVpL/gvzgTIe/L+aPQF7MTgkQp8WTWehEjNZ5nvWgH4eKuHSeLeHq4KsuqHOv+fyZJ94Oqv0tQ1FAL0iqUluGJsaqbH5ZgylVjw9dcujjd8URzZpFjHfDJvpSoxN6wTj50e7LlprO/y9nykURWMWNRilIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=JVoBqhgB; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="JVoBqhgB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=JVoBqhgBWEtkybUwaYzrDk2dTYsUbfYBp95J5ZDNnBZly69MW0GGAF273QckNAfPOdAyijUp04tsB
	 yJHl/YdQNpTk2DNZ/T58k8PLd/IFp6/cjV3QolSJkM4fJwaAVKoyjjTs3GIbtOpjeYbKdQVJDRD+7U
	 puc7nsaHdHrrvRWw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-08-12086 (RichMail) with SMTP id 2f3669c5e305cda-01cff;
	Fri, 27 Mar 2026 09:53:14 +0800 (CST)
X-RM-TRANSID:2f3669c5e305cda-01cff
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	rmk+kernel@armlinux.org.uk
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladimir.oltean@nxp.com,
	netdev@vger.kernel.org,
	xu.yang_2@nxp.com
Subject: [PATCH 6.1.y 3/3] net: phy: fix phy_uses_state_machine()
Date: Fri, 27 Mar 2026 09:53:16 +0800
Message-Id: <20260327015316.1713133-1-681739313@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 drivers/net/phy/phy_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index fd49616c6608..9b0c88c19795 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -270,8 +270,7 @@ static bool phy_uses_state_machine(struct phy_device *phydev)
 	if (phydev->phy_link_change == phy_link_change)
 		return phydev->attached_dev && phydev->adjust_link;
 
-	/* phydev->phy_link_change is implicitly phylink_phy_change() */
-	return true;
+	return !!phydev->phy_link_change;
 }
 
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
@@ -1791,6 +1790,8 @@ void phy_detach(struct phy_device *phydev)
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
+
+	phydev->phy_link_change = NULL;
 	phydev->phylink = NULL;
 
 	if (phydev->mdio.dev.driver)
-- 
2.34.1


