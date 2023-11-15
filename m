Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEAA3BB42
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLl26eXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB9CC433CA;
	Wed, 15 Nov 2023 19:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078023;
	bh=9+W/bPmjj9k5bcUtHrsjAg7TgCpo1007UP3EObJQ878=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLl26eXRFlxUj8h1WNTsX6a46MbzbBtB1dyk1X0UmGoI0vl8egUziHoDI0y5NBSdr
	 sLeKCNzupx6qDdVYA81KTiE/Eq+tDoEQ4OOd/R568GhUQSF8WDkXDIGRe9dGbwj2Mq
	 W+5lkYNrzQ+J2l+ss+lo3Fubmojx+ZZm/Dxn1tMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/379] can: dev: can_restart(): fix race condition between controller restart and netif_carrier_on()
Date: Wed, 15 Nov 2023 14:22:10 -0500
Message-ID: <20231115192648.414473951@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 6841cab8c4504835e4011689cbdb3351dec693fd ]

This race condition was discovered while updating the at91_can driver
to use can_bus_off(). The following scenario describes how the
converted at91_can driver would behave.

When a CAN device goes into BUS-OFF state, the driver usually
stops/resets the CAN device and calls can_bus_off().

This function sets the netif carrier to off, and (if configured by
user space) schedules a delayed work that calls can_restart() to
restart the CAN device.

The can_restart() function first checks if the carrier is off and
triggers an error message if the carrier is OK.

Then it calls the driver's do_set_mode() function to restart the
device, then it sets the netif carrier to on. There is a race window
between these two calls.

The at91 CAN controller (observed on the sama5d3, a single core 32 bit
ARM CPU) has a hardware limitation. If the device goes into bus-off
while sending a CAN frame, there is no way to abort the sending of
this frame. After the controller is enabled again, another attempt is
made to send it.

If the bus is still faulty, the device immediately goes back to the
bus-off state. The driver calls can_bus_off(), the netif carrier is
switched off and another can_restart is scheduled. This occurs within
the race window before the original can_restart() handler marks the
netif carrier as OK. This would cause the 2nd can_restart() to be
called with an OK netif carrier, resulting in an error message.

The flow of the 1st can_restart() looks like this:

can_restart()
    // bail out if netif_carrier is OK

    netif_carrier_ok(dev)
    priv->do_set_mode(dev, CAN_MODE_START)
        // enable CAN controller
        // sama5d3 restarts sending old message

        // CAN devices goes into BUS_OFF, triggers IRQ

// IRQ handler start
    at91_irq()
        at91_irq_err_line()
            can_bus_off()
                netif_carrier_off()
                schedule_delayed_work()
// IRQ handler end

    netif_carrier_on()

The 2nd can_restart() will be called with an OK netif carrier and the
error message will be printed.

To close the race window, first set the netif carrier to on, then
restart the controller. In case the restart fails with an error code,
roll back the netif carrier to off.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Link: https://lore.kernel.org/all/20231005-can-dev-fix-can-restart-v2-2-91b5c1fd922c@pengutronix.de
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index f36bd9bd98517..f685479eda1be 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -154,11 +154,12 @@ static void can_restart(struct net_device *dev)
 	priv->can_stats.restarts++;
 
 	/* Now restart the device */
-	err = priv->do_set_mode(dev, CAN_MODE_START);
-
 	netif_carrier_on(dev);
-	if (err)
+	err = priv->do_set_mode(dev, CAN_MODE_START);
+	if (err) {
 		netdev_err(dev, "Error %d during restart", err);
+		netif_carrier_off(dev);
+	}
 }
 
 static void can_restart_work(struct work_struct *work)
-- 
2.42.0



