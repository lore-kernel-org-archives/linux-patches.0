Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE01A15FCE0;
	Mon, 27 May 2024 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836361; cv=none; b=f/F8iaDscpnWtjmMX6+OU9I4WLW3Bf03JVeC1FfhckP02duLgT9kDTKp2PuUbAoTgtsRMEMkJE98z8xW38Mi6Z1BcU+qZ219vVVng4g5/CR8n4bF7yaWQ7SEykWfZ4I14KnnVPoHdwq/3pGJYDmEmSGnyKHzzRSfkTRA/NnTF3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836361; c=relaxed/simple;
	bh=/y3RnYwZtMWmrHzJbHsCoxL7GI0/8X3xQPsZHsdAX8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbZijYIt+47QnGt9AgFh2fXdI1L/4bR8hdWZBd1xFzHE1kGEJrq/5swKGjbazAgJ2YCThUAkVx8X8rU48K/AISl8MRBWvEL1NpaRUsKOSmdRpFToV8aBEKiIl8Y0+ExZeDuTYZ1M66Q7azIeGUj83M9l+m0vT72D0uuZD86k61c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqBlcpnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqBlcpnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E889AC2BBFC;
	Mon, 27 May 2024 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836360;
	bh=/y3RnYwZtMWmrHzJbHsCoxL7GI0/8X3xQPsZHsdAX8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqBlcpnI84hFwrq1ID1qzFETFWxExvW8YVrWGdVprGc9RgPanIrEnK0zOHaSgQDWm
	 KJAYUwSW4Q+MSHGfqG/vaSngXWXOlhaQpdVhJrwEYISMf1TVcjIIeB80ogUJfIWnCC
	 21mK70lwJHaa7iz1zlCxdrXeLG3/vdvnZpUmqrD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Gantois <romain.gantois@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.9 023/427] net: ti: icssg_prueth: Fix NULL pointer dereference in prueth_probe()
Date: Mon, 27 May 2024 20:51:10 +0200
Message-ID: <20240527185603.893310280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Gantois <romain.gantois@bootlin.com>

commit b31c7e78086127a7fcaa761e8d336ee855a920c6 upstream.

In the prueth_probe() function, if one of the calls to emac_phy_connect()
fails due to of_phy_connect() returning NULL, then the subsequent call to
phy_attached_info() will dereference a NULL pointer.

Check the return code of emac_phy_connect and fail cleanly if there is an
error.

Fixes: 128d5874c082 ("net: ti: icssg-prueth: Add ICSSG ethernet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://lore.kernel.org/r/20240521-icssg-prueth-fix-v1-1-b4b17b1433e9@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -2152,7 +2152,12 @@ static int prueth_probe(struct platform_
 
 		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
 
-		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
+		ret = emac_phy_connect(prueth->emac[PRUETH_MAC0]);
+		if (ret) {
+			dev_err(dev,
+				"can't connect to MII0 PHY, error -%d", ret);
+			goto netdev_unregister;
+		}
 		phy_attached_info(prueth->emac[PRUETH_MAC0]->ndev->phydev);
 	}
 
@@ -2164,7 +2169,12 @@ static int prueth_probe(struct platform_
 		}
 
 		prueth->registered_netdevs[PRUETH_MAC1] = prueth->emac[PRUETH_MAC1]->ndev;
-		emac_phy_connect(prueth->emac[PRUETH_MAC1]);
+		ret = emac_phy_connect(prueth->emac[PRUETH_MAC1]);
+		if (ret) {
+			dev_err(dev,
+				"can't connect to MII1 PHY, error %d", ret);
+			goto netdev_unregister;
+		}
 		phy_attached_info(prueth->emac[PRUETH_MAC1]->ndev->phydev);
 	}
 


