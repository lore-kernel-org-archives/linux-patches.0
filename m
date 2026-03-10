Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEF82BF3E2;
	Tue, 10 Mar 2026 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141136; cv=none; b=OJkSmmxB9OkaHFy65D/tZ4+JR4a28unFdcGH61mrHh1X0xklvybs96k8ArWF13fPncibnc6NUTJoUr8p7ptFZNO4lAsB7iSP/YQQTJmgiv5jYY+JIVGo0a05t0IeqZTJjbsUMpbxTs9f6L9FEySXYdDlB/Qilta02XfElPQl3iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141136; c=relaxed/simple;
	bh=D04gyKncWJXdTmniCOb0pnOvLSwwqEg8ZYUall3iS54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2NaOGBcHL1lx49uX9E4xjYeIlm9IRfZdT01UZe62AIkfUPKeiV8cBPIRIdpBheKxlJq1QoOEEFPwPD3KHrdV7N1EcUwWK0KLm4u/JttI/+9TsPbm6PqKikSFA0aYzwwG5zW8SgQlFxT2H/OrRXqskQ0ObCoGGRp6x2GohVmFEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j36k539b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j36k539b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF91C19423;
	Tue, 10 Mar 2026 11:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141135;
	bh=D04gyKncWJXdTmniCOb0pnOvLSwwqEg8ZYUall3iS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j36k539bgzAlJmMwfzpwDLkldbq9JU+lYT0IC64v02kqHuncfWaqFDZMJLAsmNWt5
	 UUqMYtsc3jy0mybfRla2wNgSb9npSYlwXL7oBGMzRAwoxd9k90tnlVSjtLgpR4l35P
	 gGHgk3A7tAc41wYWIKFuNMV14vGtnNZ88kWM3azg/DAJvWr0nuca6WMH0nqCNcCtXj
	 1Li4B4JZXeBPDCRbTDrTiHIUVZSde8/yby5O50OSrPM4hDouWz0hNJe9+RQm7JT3j7
	 1v3m+9GTtNezY1+lq/8D4MaWCx2MQ/K+qIZgeQ8WOYjS8VhQYKsms9OVzg6v8Prg/f
	 ihJCE0yTALsCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>,
	Shiji Yang <yangshiji66@outlook.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 139/311] net: phy: register phy led_triggers during probe to avoid AB-BA deadlock
Date: Tue, 10 Mar 2026 07:03:06 -0400
Message-ID: <c35d7c039450def2a241217ee11063ae1ece6691.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andrew Lunn <andrew@lunn.ch>

commit c8dbdc6e380e7e96a51706db3e4b7870d8a9402d upstream.

There is an AB-BA deadlock when both LEDS_TRIGGER_NETDEV and
LED_TRIGGER_PHY are enabled:

[ 1362.049207] [<8054e4b8>] led_trigger_register+0x5c/0x1fc             <-- Trying to get lock "triggers_list_lock" via down_write(&triggers_list_lock);
[ 1362.054536] [<80662830>] phy_led_triggers_register+0xd0/0x234
[ 1362.060329] [<8065e200>] phy_attach_direct+0x33c/0x40c
[ 1362.065489] [<80651fc4>] phylink_fwnode_phy_connect+0x15c/0x23c
[ 1362.071480] [<8066ee18>] mtk_open+0x7c/0xba0
[ 1362.075849] [<806d714c>] __dev_open+0x280/0x2b0
[ 1362.080384] [<806d7668>] __dev_change_flags+0x244/0x24c
[ 1362.085598] [<806d7698>] dev_change_flags+0x28/0x78
[ 1362.090528] [<807150e4>] dev_ioctl+0x4c0/0x654                       <-- Hold lock "rtnl_mutex" by calling rtnl_lock();
[ 1362.094985] [<80694360>] sock_ioctl+0x2f4/0x4e0
[ 1362.099567] [<802e9c4c>] sys_ioctl+0x32c/0xd8c
[ 1362.104022] [<80014504>] syscall_common+0x34/0x58

Here LED_TRIGGER_PHY is registering LED triggers during phy_attach
while holding RTNL and then taking triggers_list_lock.

[ 1362.191101] [<806c2640>] register_netdevice_notifier+0x60/0x168      <-- Trying to get lock "rtnl_mutex" via rtnl_lock();
[ 1362.197073] [<805504ac>] netdev_trig_activate+0x194/0x1e4
[ 1362.202490] [<8054e28c>] led_trigger_set+0x1d4/0x360                 <-- Hold lock "triggers_list_lock" by down_read(&triggers_list_lock);
[ 1362.207511] [<8054eb38>] led_trigger_write+0xd8/0x14c
[ 1362.212566] [<80381d98>] sysfs_kf_bin_write+0x80/0xbc
[ 1362.217688] [<8037fcd8>] kernfs_fop_write_iter+0x17c/0x28c
[ 1362.223174] [<802cbd70>] vfs_write+0x21c/0x3c4
[ 1362.227712] [<802cc0c4>] ksys_write+0x78/0x12c
[ 1362.232164] [<80014504>] syscall_common+0x34/0x58

Here LEDS_TRIGGER_NETDEV is being enabled on an LED. It first takes
triggers_list_lock and then RTNL. A classical AB-BA deadlock.

phy_led_triggers_registers() does not require the RTNL, it does not
make any calls into the network stack which require protection. There
is also no requirement the PHY has been attached to a MAC, the
triggers only make use of phydev state. This allows the call to
phy_led_triggers_registers() to be placed elsewhere. PHY probe() and
release() don't hold RTNL, so solving the AB-BA deadlock.

Reported-by: Shiji Yang <yangshiji66@outlook.com>
Closes: https://lore.kernel.org/all/OS7PR01MB13602B128BA1AD3FA38B6D1FFBC69A@OS7PR01MB13602.jpnprd01.prod.outlook.com/
Fixes: 06f502f57d0d ("leds: trigger: Introduce a NETDEV trigger")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Shiji Yang <yangshiji66@outlook.com>
Link: https://patch.msgid.link/20260222152601.1978655-1-andrew@lunn.ch
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 81984d4ebb7cb..a1ed7ed938ac5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1763,8 +1763,6 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		goto error;
 
 	phy_resume(phydev);
-	if (!phydev->is_on_sfp_module)
-		phy_led_triggers_register(phydev);
 
 	/**
 	 * If the external phy used by current mac interface is managed by
@@ -1879,9 +1877,6 @@ void phy_detach(struct phy_device *phydev)
 	phydev->phy_link_change = NULL;
 	phydev->phylink = NULL;
 
-	if (!phydev->is_on_sfp_module)
-		phy_led_triggers_unregister(phydev);
-
 	if (phydev->mdio.dev.driver)
 		module_put(phydev->mdio.dev.driver->owner);
 
@@ -3512,16 +3507,27 @@ static int phy_probe(struct device *dev)
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
+	/* Register the PHY LED triggers */
+	if (!phydev->is_on_sfp_module)
+		phy_led_triggers_register(phydev);
+
 	/* Get the LEDs from the device tree, and instantiate standard
 	 * LEDs for them.
 	 */
-	if (IS_ENABLED(CONFIG_PHYLIB_LEDS) && !phy_driver_is_genphy(phydev))
+	if (IS_ENABLED(CONFIG_PHYLIB_LEDS) && !phy_driver_is_genphy(phydev)) {
 		err = of_phy_leds(phydev);
+		if (err)
+			goto out;
+	}
+
+	return 0;
 
 out:
+	if (!phydev->is_on_sfp_module)
+		phy_led_triggers_unregister(phydev);
+
 	/* Re-assert the reset signal on error */
-	if (err)
-		phy_device_reset(phydev, 1);
+	phy_device_reset(phydev, 1);
 
 	return err;
 }
@@ -3535,6 +3541,9 @@ static int phy_remove(struct device *dev)
 	if (IS_ENABLED(CONFIG_PHYLIB_LEDS) && !phy_driver_is_genphy(phydev))
 		phy_leds_unregister(phydev);
 
+	if (!phydev->is_on_sfp_module)
+		phy_led_triggers_unregister(phydev);
+
 	phydev->state = PHY_DOWN;
 
 	sfp_bus_del_upstream(phydev->sfp_bus);
-- 
2.51.0

