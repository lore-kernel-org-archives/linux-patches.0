Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC150EBEC;
	Wed, 30 Sep 2026 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785706; cv=none; b=I98eSjMI9hk2AqjmdQEQuSXucNPV6wTPahfNmfmaog4xXV4EML4yo+po3H5TQFoAJFCEEK0qGkSdA9TT6ZuXyt4GECDTvV8Ehi/T3Z46cX1cJRQjLCfaIl2nDogWzlLu2S7L6t2w9fmIk7cvgaGjT46EMSM5cEBhOt8ufks0NQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785706; c=relaxed/simple;
	bh=9IJZudIbZB6ksCWkvpUdzYq/tdrqvS9nLXtSxnX5BWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXqg1JmZMIJhbs03qdoGbH9wvBwNvwRc1+C1+TbyaSOJPiXGnKPB7NoOP2Vpe/mk9+yCgJ5dllzpXEYtL0YK3YTsJkG1UH1hVwHVduy6wY8jxKsvPr8oZUhQqc/1IM9srZvwdl2GIapn+uA6yw/qE51ibZSpw2txQUx+n/diWFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSqQV+Zu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSqQV+Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52B91F00899;
	Wed, 30 Sep 2026 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785699;
	bh=ln9840LRCZpksEfXlYX6V3p/+VX36OOYh5TEogqdcGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSqQV+ZuhkjCqLVF8OFCwNsegp72+riOTbjLbyngc39y8wTPNpGT5zi5jpy2JE9Hs
	 cJ0Roqg+K/hbJMYsQqa++WKeY1BWQT9NqfHyOHPoWyXVvYAP4JP3CiYsHIGsuxvjBU
	 KIVOZJsETI3IAzum4TreTsfK9VenwbBx0GQ9I3IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 602/982] net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
Date: Wed, 30 Sep 2026 17:22:18 +0200
Message-ID: <20260930152429.712330538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 45791e0d00c445936bb19535fe847083b1edd26d ]

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_netdev_checks() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ef9fbe1b93f3 ("RDMA/core: Reject unregistering netdevs in ib_get_eth_speed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/leftover.c | 63 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index ab9a8534904ce..6f79af84d1a3a 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9983,33 +9983,6 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
-static void __devlink_port_type_set(struct devlink_port *devlink_port,
-				    enum devlink_port_type type,
-				    void *type_dev)
-{
-	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
-
-	if (type == DEVLINK_PORT_TYPE_NOTSET)
-		devlink_port_type_warn_schedule(devlink_port);
-	else
-		devlink_port_type_warn_cancel(devlink_port);
-
-	spin_lock_bh(&devlink_port->type_lock);
-	devlink_port->type = type;
-	switch (type) {
-	case DEVLINK_PORT_TYPE_ETH:
-		devlink_port->type_eth.netdev = type_dev;
-		break;
-	case DEVLINK_PORT_TYPE_IB:
-		devlink_port->type_ib.ibdev = type_dev;
-		break;
-	default:
-		break;
-	}
-	spin_unlock_bh(&devlink_port->type_lock);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-}
-
 static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 					    struct net_device *netdev)
 {
@@ -10047,6 +10020,38 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 	}
 }
 
+static void __devlink_port_type_set(struct devlink_port *devlink_port,
+				    enum devlink_port_type type,
+				    void *type_dev)
+{
+	struct net_device *netdev = type_dev;
+
+	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
+
+	if (type == DEVLINK_PORT_TYPE_NOTSET) {
+		devlink_port_type_warn_schedule(devlink_port);
+	} else {
+		devlink_port_type_warn_cancel(devlink_port);
+		if (type == DEVLINK_PORT_TYPE_ETH && netdev)
+			devlink_port_type_netdev_checks(devlink_port, netdev);
+	}
+
+	spin_lock_bh(&devlink_port->type_lock);
+	devlink_port->type = type;
+	switch (type) {
+	case DEVLINK_PORT_TYPE_ETH:
+		devlink_port->type_eth.netdev = netdev;
+		break;
+	case DEVLINK_PORT_TYPE_IB:
+		devlink_port->type_ib.ibdev = type_dev;
+		break;
+	default:
+		break;
+	}
+	spin_unlock_bh(&devlink_port->type_lock);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+}
+
 /**
  *	devlink_port_type_eth_set - Set port type to Ethernet
  *
@@ -10056,9 +10061,7 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev)
 {
-	if (netdev)
-		devlink_port_type_netdev_checks(devlink_port, netdev);
-	else
+	if (!netdev)
 		dev_warn(devlink_port->devlink->dev,
 			 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
 			 devlink_port->index);
-- 
2.53.0



