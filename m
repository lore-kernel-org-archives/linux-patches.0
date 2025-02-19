Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060511E0B7F;
	Wed, 19 Feb 2025 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956569; cv=none; b=qSsyj8TIBWaaP8+srNjqYcO6nDDl6wkWOQdEaNbXvNPUNJBL5Dph/P2ZeuWXjMQN7LwIM9LfZ94ITIOakTw1nGiBY1h/clYrDVXn2WBJUxSyV74Klc03nmu5I/CRG49o7wkCSMFzF5SPMaew8iUk397HOVB4OWe/wHh1zek04tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956569; c=relaxed/simple;
	bh=gl4dI+QXthUiA50FLqCfhOP2yJZPXeS8uYutnyS+Dzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaVGmTHOcR9b+99v/rZLfXC3uIcGEXjPwvIUfpQZHDx0uESitzB8rzjyjssPZD+6g69bPlsVThq8boaTEl5/17KFXsn3Q0Ho2E+EOGy6A9u2EjQCJppX6L+s9ha64U5lLxmFmicR6CRCsbEJrqDYs/SOnuYkqugCsc3VuKM7w6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuUVJfAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuUVJfAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8185BC4CEE6;
	Wed, 19 Feb 2025 09:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956568;
	bh=gl4dI+QXthUiA50FLqCfhOP2yJZPXeS8uYutnyS+Dzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuUVJfAq7zu/yzhxX7ceFEUs99Z6+u9rNKREVtQ627HXTElLi+xZFSQaCXs8gtLhE
	 JqHrgYBzHU+PuTNJQ5rDEaboqvobZSEH0Ktyyvyau2+yzRjzcCaW9osu1hgsmwMmc0
	 XOubwMcAtlN9GTIeiGRZ+zZRf0nGhYslsyfFWde4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e5de9e3ab986b71d2bf@syzkaller.appspotmail.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/578] net: netdevsim: try to close UDP port harness races
Date: Wed, 19 Feb 2025 09:23:48 +0100
Message-ID: <20250219082701.865381569@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 50bf398e1ceacb9a7f85bd3bdca065ebe5cb6159 ]

syzbot discovered that we remove the debugfs files after we free
the netdev. Try to clean up the relevant dir while the device
is still around.

Reported-by: syzbot+2e5de9e3ab986b71d2bf@syzkaller.appspotmail.com
Fixes: 424be63ad831 ("netdevsim: add UDP tunnel port offload support")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250122224503.762705-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdevsim.h             |  1 +
 drivers/net/netdevsim/udp_tunnels.c           | 23 +++++++++++--------
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 16 ++++++-------
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7d8ed8d8df5c9..02e3518e9a7e2 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -98,6 +98,7 @@ struct netdevsim {
 		u32 sleep;
 		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
 		u32 (*ports)[NSIM_UDP_TUNNEL_N_PORTS];
+		struct dentry *ddir;
 		struct debugfs_u32_array dfs_ports[2];
 	} udp_ports;
 
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 02dc3123eb6c1..640b4983a9a0d 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -112,9 +112,11 @@ nsim_udp_tunnels_info_reset_write(struct file *file, const char __user *data,
 	struct net_device *dev = file->private_data;
 	struct netdevsim *ns = netdev_priv(dev);
 
-	memset(ns->udp_ports.ports, 0, sizeof(ns->udp_ports.__ports));
 	rtnl_lock();
-	udp_tunnel_nic_reset_ntf(dev);
+	if (dev->reg_state == NETREG_REGISTERED) {
+		memset(ns->udp_ports.ports, 0, sizeof(ns->udp_ports.__ports));
+		udp_tunnel_nic_reset_ntf(dev);
+	}
 	rtnl_unlock();
 
 	return count;
@@ -144,23 +146,23 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 	else
 		ns->udp_ports.ports = nsim_dev->udp_ports.__ports;
 
-	debugfs_create_u32("udp_ports_inject_error", 0600,
-			   ns->nsim_dev_port->ddir,
+	ns->udp_ports.ddir = debugfs_create_dir("udp_ports",
+						ns->nsim_dev_port->ddir);
+
+	debugfs_create_u32("inject_error", 0600, ns->udp_ports.ddir,
 			   &ns->udp_ports.inject_error);
 
 	ns->udp_ports.dfs_ports[0].array = ns->udp_ports.ports[0];
 	ns->udp_ports.dfs_ports[0].n_elements = NSIM_UDP_TUNNEL_N_PORTS;
-	debugfs_create_u32_array("udp_ports_table0", 0400,
-				 ns->nsim_dev_port->ddir,
+	debugfs_create_u32_array("table0", 0400, ns->udp_ports.ddir,
 				 &ns->udp_ports.dfs_ports[0]);
 
 	ns->udp_ports.dfs_ports[1].array = ns->udp_ports.ports[1];
 	ns->udp_ports.dfs_ports[1].n_elements = NSIM_UDP_TUNNEL_N_PORTS;
-	debugfs_create_u32_array("udp_ports_table1", 0400,
-				 ns->nsim_dev_port->ddir,
+	debugfs_create_u32_array("table1", 0400, ns->udp_ports.ddir,
 				 &ns->udp_ports.dfs_ports[1]);
 
-	debugfs_create_file("udp_ports_reset", 0200, ns->nsim_dev_port->ddir,
+	debugfs_create_file("reset", 0200, ns->udp_ports.ddir,
 			    dev, &nsim_udp_tunnels_info_reset_fops);
 
 	/* Note: it's not normal to allocate the info struct like this!
@@ -196,6 +198,9 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 
 void nsim_udp_tunnels_info_destroy(struct net_device *dev)
 {
+	struct netdevsim *ns = netdev_priv(dev);
+
+	debugfs_remove_recursive(ns->udp_ports.ddir);
 	kfree(dev->udp_tunnel_nic_info);
 	dev->udp_tunnel_nic_info = NULL;
 }
diff --git a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
index 185b02d2d4cd1..7af78990b5bb6 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
@@ -142,7 +142,7 @@ function pre_ethtool {
 }
 
 function check_table {
-    local path=$NSIM_DEV_DFS/ports/$port/udp_ports_table$1
+    local path=$NSIM_DEV_DFS/ports/$port/udp_ports/table$1
     local -n expected=$2
     local last=$3
 
@@ -212,7 +212,7 @@ function check_tables {
 }
 
 function print_table {
-    local path=$NSIM_DEV_DFS/ports/$port/udp_ports_table$1
+    local path=$NSIM_DEV_DFS/ports/$port/udp_ports/table$1
     read -a have < $path
 
     tree $NSIM_DEV_DFS/
@@ -640,7 +640,7 @@ for port in 0 1; do
     NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
-    echo 110 > $NSIM_DEV_DFS/ports/$port/udp_ports_inject_error
+    echo 110 > $NSIM_DEV_DFS/ports/$port/udp_ports/inject_error
 
     msg="1 - create VxLANs v6"
     exp0=( 0 0 0 0 )
@@ -662,7 +662,7 @@ for port in 0 1; do
     new_geneve gnv0 20000
 
     msg="2 - destroy GENEVE"
-    echo 2 > $NSIM_DEV_DFS/ports/$port/udp_ports_inject_error
+    echo 2 > $NSIM_DEV_DFS/ports/$port/udp_ports/inject_error
     exp1=( `mke 20000 2` 0 0 0 )
     del_dev gnv0
 
@@ -763,7 +763,7 @@ for port in 0 1; do
     msg="create VxLANs v4"
     new_vxlan vxlan0 10000 $NSIM_NETDEV
 
-    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports/reset
     check_tables
 
     msg="NIC device goes down"
@@ -774,7 +774,7 @@ for port in 0 1; do
     fi
     check_tables
 
-    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports/reset
     check_tables
 
     msg="NIC device goes up again"
@@ -788,7 +788,7 @@ for port in 0 1; do
     del_dev vxlan0
     check_tables
 
-    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports/reset
     check_tables
 
     msg="destroy NIC"
@@ -895,7 +895,7 @@ msg="vacate VxLAN in overflow table"
 exp0=( `mke 10000 1` `mke 10004 1` 0 `mke 10003 1` )
 del_dev vxlan2
 
-echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports/reset
 check_tables
 
 msg="tunnels destroyed 2"
-- 
2.39.5



