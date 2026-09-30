Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B521A50EBFC;
	Wed, 30 Sep 2026 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785703; cv=none; b=kiJZWjyfFaP2bRS8BGjM+JCFxBQcEHzF+mqYv7n4tOOXb4rGnoPdcQgTUc2zspnwRL/TjHvtyp7wRfIbS2aSoOYI9keisgF5JDTUUcfD5hRDpliAe2mbbbvp+SZygdHfLme5w65K2afwP73pco/N2XrdBu2SkcJeYr26K25JBEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785703; c=relaxed/simple;
	bh=3meccgZDxt30Tal470TMBo/t5zLqeCOI0VGAb1Bgu9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKErqop18q4lJtUtPFzq7vNFJRcEf+2CVLUyTUei44kOv3W/9fZj8g0h+akm+8830lu1p+WgO72andgYBRtKNmtQFp91eMJPJjHkKb8BK6YLwaK9OgB/DkpTFQkaysL9sTqqxvuHudWiLY32jWtr8ip8XN1cy5U3qgYRt30Jt+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VamKr9qI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VamKr9qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A27E1F00893;
	Wed, 30 Sep 2026 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785693;
	bh=2X3zn4zLU9nSMTyrDqYKL6yttekZ6swINSErB74UAdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VamKr9qIAZWWoBtE/QLNr0l3+47ckYp0wKtpqfjUWOSgIlOT4UZQ0wALgJD3Ir56H
	 ktU57HZb8Xk5mmZoRkTyp44D7w4Auhjk5Uk/JY1cuvvmASGYnAckeqdcuhQpBDw3zN
	 yt8c1WzF6viyRlZPRSMxRRB1Mia/5YpikpwNL+go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 600/982] net: devlink: convert devlink port type-specific pointers to union
Date: Wed, 30 Sep 2026 17:22:16 +0200
Message-ID: <20260930152429.668838556@linuxfoundation.org>
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

[ Upstream commit 3830c5719af66fac9849cf5fb04b03d4e4bb46ff ]

Instead of storing type_dev as a void pointer, convert it to union and
use it to store either struct net_device or struct ib_device pointer.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ef9fbe1b93f3 ("RDMA/core: Reject unregistering netdevs in ib_get_eth_speed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/devlink.h  | 13 ++++++++++---
 net/devlink/leftover.c | 17 +++++++++++++----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ba6b8b0949432..6c55aabaedf19 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -121,12 +121,19 @@ struct devlink_port {
 	struct list_head region_list;
 	struct devlink *devlink;
 	unsigned int index;
-	spinlock_t type_lock; /* Protects type and type_dev
-			       * pointer consistency.
+	spinlock_t type_lock; /* Protects type and type_eth/ib
+			       * structures consistency.
 			       */
 	enum devlink_port_type type;
 	enum devlink_port_type desired_type;
-	void *type_dev;
+	union {
+		struct {
+			struct net_device *netdev;
+		} type_eth;
+		struct {
+			struct ib_device *ibdev;
+		} type_ib;
+	};
 	struct devlink_port_attrs attrs;
 	u8 attrs_set:1,
 	   switch_port:1,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1ea84c5ffa9f1..d9e13f1836bb6 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1283,7 +1283,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
 		struct net *net = devlink_net(devlink_port->devlink);
-		struct net_device *netdev = devlink_port->type_dev;
+		struct net_device *netdev = devlink_port->type_eth.netdev;
 
 		if (netdev && net_eq(net, dev_net(netdev)) &&
 		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
@@ -1293,7 +1293,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 			goto nla_put_failure_type_locked;
 	}
 	if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
-		struct ib_device *ibdev = devlink_port->type_dev;
+		struct ib_device *ibdev = devlink_port->type_ib.ibdev;
 
 		if (ibdev &&
 		    nla_put_string(msg, DEVLINK_ATTR_PORT_IBDEV_NAME,
@@ -9992,7 +9992,16 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
-	devlink_port->type_dev = type_dev;
+	switch (type) {
+	case DEVLINK_PORT_TYPE_ETH:
+		devlink_port->type_eth.netdev = type_dev;
+		break;
+	case DEVLINK_PORT_TYPE_IB:
+		devlink_port->type_ib.ibdev = type_dev;
+		break;
+	default:
+		break;
+	}
 	spin_unlock_bh(&devlink_port->type_lock);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 }
@@ -12009,7 +12018,7 @@ devlink_trap_report_metadata_set(struct devlink_trap_metadata *metadata,
 
 	spin_lock(&in_devlink_port->type_lock);
 	if (in_devlink_port->type == DEVLINK_PORT_TYPE_ETH)
-		metadata->input_dev = in_devlink_port->type_dev;
+		metadata->input_dev = in_devlink_port->type_eth.netdev;
 	spin_unlock(&in_devlink_port->type_lock);
 }
 
-- 
2.53.0



