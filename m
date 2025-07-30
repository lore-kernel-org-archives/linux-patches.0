Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8ED157E6B;
	Wed, 30 Jul 2025 09:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868673; cv=none; b=u/vPQzxkOkK5l/27Wtu6Gzua96YhBvGxDUgQbqDqASs7MKMwz/Ia7dP5uJDmnhZN/tgjmIdisu4g1vBT0mr/iGTpwtgKoa9wTKkYH8ICSwUcKBDqGSmzDt+qMW8lpv4GwtYq/EqiQw90hj0dWSvR2R+KWvUtk16h+uQfT+IXtXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868673; c=relaxed/simple;
	bh=eCtIvERHBfHdDYGhhzB2oMqgHyL4/Gst/y290dxSYRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guUbMh3o/b22fwLUZTDho6Vm5SEroFkC/pIgqJxANgsRXTrOkVLAP6hbD75u+HHPwT6N968P85F5AJ0zhHkZPBVezU6RPTZzKUqiMXGGs7DaUINFpHYruRlo4JTLaH/T6dsJfN9frOASsDmoUxZ2c81lw3rJs5rFjbqAANgfP8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOJUyJ9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOJUyJ9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AA7C4CEF5;
	Wed, 30 Jul 2025 09:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868673;
	bh=eCtIvERHBfHdDYGhhzB2oMqgHyL4/Gst/y290dxSYRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOJUyJ9oYTBLZvHTO1KTUfnmQ/0hnnoOL6ZV5paKszuch4gV4Q8jRK/RTMFE2Hws9
	 VFdhTUiAjhny4+a99IqfTGv8AFrOKXzu4nIoacH9/r/pJ6SwdEvM0bYAceoAO72dSy
	 71xBS4qGwB+1Kks0OxTpr8dV1C5N84dxjE9uWIso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrey.lalaev@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/117] can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode
Date: Wed, 30 Jul 2025 11:34:59 +0200
Message-ID: <20250730093234.738002245@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c1f3f9797c1f44a762e6f5f72520b2e520537b52 ]

Andrei Lalaev reported a NULL pointer deref when a CAN device is
restarted from Bus Off and the driver does not implement the struct
can_priv::do_set_mode callback.

There are 2 code path that call struct can_priv::do_set_mode:
- directly by a manual restart from the user space, via
  can_changelink()
- delayed automatic restart after bus off (deactivated by default)

To prevent the NULL pointer deference, refuse a manual restart or
configure the automatic restart delay in can_changelink() and report
the error via extack to user space.

As an additional safety measure let can_restart() return an error if
can_priv::do_set_mode is not set instead of dereferencing it
unchecked.

Reported-by: Andrei Lalaev <andrey.lalaev@gmail.com>
Closes: https://lore.kernel.org/all/20250714175520.307467-1-andrey.lalaev@gmail.com
Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Link: https://patch.msgid.link/20250718-fix-nullptr-deref-do_set_mode-v1-1-0b520097bb96@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c     | 12 +++++++++---
 drivers/net/can/dev/netlink.c | 12 ++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 681643ab37804..63e4a495b1371 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -147,13 +147,16 @@ void can_change_state(struct net_device *dev, struct can_frame *cf,
 EXPORT_SYMBOL_GPL(can_change_state);
 
 /* CAN device restart for bus-off recovery */
-static void can_restart(struct net_device *dev)
+static int can_restart(struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
 	struct can_frame *cf;
 	int err;
 
+	if (!priv->do_set_mode)
+		return -EOPNOTSUPP;
+
 	if (netif_carrier_ok(dev))
 		netdev_err(dev, "Attempt to restart for bus-off recovery, but carrier is OK?\n");
 
@@ -175,10 +178,14 @@ static void can_restart(struct net_device *dev)
 	if (err) {
 		netdev_err(dev, "Restart failed, error %pe\n", ERR_PTR(err));
 		netif_carrier_off(dev);
+
+		return err;
 	} else {
 		netdev_dbg(dev, "Restarted\n");
 		priv->can_stats.restarts++;
 	}
+
+	return 0;
 }
 
 static void can_restart_work(struct work_struct *work)
@@ -203,9 +210,8 @@ int can_restart_now(struct net_device *dev)
 		return -EBUSY;
 
 	cancel_delayed_work_sync(&priv->restart_work);
-	can_restart(dev);
 
-	return 0;
+	return can_restart(dev);
 }
 
 /* CAN bus-off
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 01aacdcda2606..abe8dc051d94f 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -285,6 +285,12 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	}
 
 	if (data[IFLA_CAN_RESTART_MS]) {
+		if (!priv->do_set_mode) {
+			NL_SET_ERR_MSG(extack,
+				       "Device doesn't support restart from Bus Off");
+			return -EOPNOTSUPP;
+		}
+
 		/* Do not allow changing restart delay while running */
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
@@ -292,6 +298,12 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	}
 
 	if (data[IFLA_CAN_RESTART]) {
+		if (!priv->do_set_mode) {
+			NL_SET_ERR_MSG(extack,
+				       "Device doesn't support restart from Bus Off");
+			return -EOPNOTSUPP;
+		}
+
 		/* Do not allow a restart while not running */
 		if (!(dev->flags & IFF_UP))
 			return -EINVAL;
-- 
2.39.5



