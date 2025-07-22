Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFB2EA46A;
	Tue, 22 Jul 2025 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192509; cv=none; b=M2lt7xlnY6bxfAm6lOy0RqgxP8TlYK2vAcFrsV2IvcfHG7S8BTp5e5yz3eYvq93+j4S+81mmVqEqVtnxAct/mArEFY+CWkReBeU+3OHBZUMH979/VzeHtfss432of7POxTaGSE/TFhAINW7t/rfGxbSccCM6+SKQDSl1NcAlNtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192509; c=relaxed/simple;
	bh=6AvkIYBEI2ulemTF3fsOd1Tp/ALlXRJDHM/Nnf22AX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okrgVLrbQghOZBqrzaGPCe6V5R46acL571ja56/7PetMlPmMqr1tAHVbxUP1+kf1moIGiH9Q8ZZZfl0ovYv2LNvIOWY6KVbhT0gqw8hTdOUl6QnHcLEjV1/CkeLD5dgn6kF09crg43RdcIey6fIqq82TOIe+r26+xKheDwanwEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFWG9fU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFWG9fU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9115C4CEEB;
	Tue, 22 Jul 2025 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192509;
	bh=6AvkIYBEI2ulemTF3fsOd1Tp/ALlXRJDHM/Nnf22AX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFWG9fU0/qQVZefYPhLrjlq9nlGLFdbxxP6WiJXRrrqHObtCYcbCo68PEBjtd5Rwa
	 dMX4sERYx+8aHnCYhd62AwKr7NlJAP7PdP3xCygeejifdveWygV/loJpuhiz23h5FW
	 Qa8FpPpy62w/jnu2LexhZ8uZ0nn1duHZBXLv4q5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/111] net: phy: Dont register LEDs for genphy
Date: Tue, 22 Jul 2025 15:44:44 +0200
Message-ID: <20250722134335.949926534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit f0f2b992d8185a0366be951685e08643aae17d6d ]

If a PHY has no driver, the genphy driver is probed/removed directly in
phy_attach/detach. If the PHY's ofnode has an "leds" subnode, then the
LEDs will be (un)registered when probing/removing the genphy driver.
This could occur if the leds are for a non-generic driver that isn't
loaded for whatever reason. Synchronously removing the PHY device in
phy_detach leads to the following deadlock:

rtnl_lock()
ndo_close()
    ...
    phy_detach()
        phy_remove()
            phy_leds_unregister()
                led_classdev_unregister()
                    led_trigger_set()
                        netdev_trigger_deactivate()
                            unregister_netdevice_notifier()
                                rtnl_lock()

There is a corresponding deadlock on the open/register side of things
(and that one is reported by lockdep), but it requires a race while this
one is deterministic.

Generic PHYs do not support LEDs anyway, so don't bother registering
them.

Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20250707195803.666097-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cde0e80474a1d..875788918bcb3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3377,7 +3377,8 @@ static int phy_probe(struct device *dev)
 	/* Get the LEDs from the device tree, and instantiate standard
 	 * LEDs for them.
 	 */
-	if (IS_ENABLED(CONFIG_PHYLIB_LEDS))
+	if (IS_ENABLED(CONFIG_PHYLIB_LEDS) && !phy_driver_is_genphy(phydev) &&
+	    !phy_driver_is_genphy_10g(phydev))
 		err = of_phy_leds(phydev);
 
 out:
@@ -3394,7 +3395,8 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
-	if (IS_ENABLED(CONFIG_PHYLIB_LEDS))
+	if (IS_ENABLED(CONFIG_PHYLIB_LEDS) && !phy_driver_is_genphy(phydev) &&
+	    !phy_driver_is_genphy_10g(phydev))
 		phy_leds_unregister(phydev);
 
 	phydev->state = PHY_DOWN;
-- 
2.39.5



