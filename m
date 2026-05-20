Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A3C2F363F;
	Wed, 20 May 2026 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299451; cv=none; b=hR4crZAKrLZu1wcm1BHX5NGSf60rfS44vDuWhdAHhh4SyvE9Sgfe3nQBrFuGjpqXj5jnTzTJeAfW7UTgTgbTTxRWbB5uq/0++tjkkioHzydSaE4TyrHZdJTFjsttzbstPE3L2/8XFGp3DHyRq37Nyig3+bvdxL6YyXVWsYfpWNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299451; c=relaxed/simple;
	bh=ghO5dY0je5G4abV07GLxyN1CYAPojMWFecYeX/3lp7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGQGmgY+ig7RtF/uOz82MdS/Y7vvL7HJhXJUU2JS2iPnFeMF2IIhbWiJr0f10eiphRDqZl1Me/2id7xggsQ6bwrWcImy/bBkOeR+4EVjxdS7oRNmUSyEyoO/+/1YnMJ5Q4uh09mkzjjra7Jvf2Qmq1RYuHZ2vDv5i9bJyfjeYqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUL/vQYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUL/vQYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFEA1F000E9;
	Wed, 20 May 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299450;
	bh=Bx+mP6ybNf6/zISk8Fy2dVm8+IwPgPU0fsK6OjCLPos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUL/vQYxNCjVMYtJ+rZ/ZmB8nXIQJRBHjtWOVIczkHlL/mv/ku+ae8yMyj0wq2I2P
	 FEkJFRTdXl5N441nhvNeN5sPody7JuPcJPWqoSZvvH03fPOboyz2oV3KozfieGfyGJ
	 LSfvP45DmAOe6Jq8JwliuOSlQNDqHokaCQL60baw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoze Xie <royenheart@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 777/957] vrf: Fix a potential NPD when removing a port from a VRF
Date: Wed, 20 May 2026 18:21:00 +0200
Message-ID: <20260520162151.411364298@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 2674d603a9e6970463b2b9ebcf8e31e90beae169 ]

RCU readers that identified a net device as a VRF port using
netif_is_l3_slave() assume that a subsequent call to
netdev_master_upper_dev_get_rcu() will return a VRF device. They then
continue to dereference its l3mdev operations.

This assumption is not always correct and can result in a NPD [1]. There
is no RCU synchronization when removing a port from a VRF, so it is
possible for an RCU reader to see a new master device (e.g., a bridge)
that does not have l3mdev operations.

Fix by adding RCU synchronization after clearing the IFF_L3MDEV_SLAVE
flag. Skip this synchronization when a net device is removed from a VRF
as part of its deletion and when the VRF device itself is deleted. In
the latter case an RCU grace period will pass by the time RTNL is
released.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
RIP: 0010:l3mdev_fib_table_rcu (net/l3mdev/l3mdev.c:181)
[...]
Call Trace:
<TASK>
l3mdev_fib_table_by_index (net/l3mdev/l3mdev.c:201 net/l3mdev/l3mdev.c:189)
__inet_bind (net/ipv4/af_inet.c:499 (discriminator 3))
inet_bind_sk (net/ipv4/af_inet.c:469)
__sys_bind (./include/linux/file.h:62 (discriminator 1) ./include/linux/file.h:83 (discriminator 1) net/socket.c:1951 (discriminator 1))
__x64_sys_bind (net/socket.c:1969 (discriminator 1) net/socket.c:1967 (discriminator 1) net/socket.c:1967 (discriminator 1))
do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1) arch/x86/entry/syscall_64.c:94 (discriminator 1))
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Fixes: fdeea7be88b1 ("net: vrf: Set slave's private flag before linking")
Reported-by: Haoze Xie <royenheart@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Closes: https://lore.kernel.org/netdev/20260419145332.3988923-1-n05ec@lzu.edu.cn/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260423063607.1208202-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 571847a7f86d7..4b62b167650ea 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1084,6 +1084,7 @@ static int do_vrf_add_slave(struct net_device *dev, struct net_device *port_dev,
 
 err:
 	port_dev->priv_flags &= ~IFF_L3MDEV_SLAVE;
+	synchronize_net();
 	return ret;
 }
 
@@ -1103,10 +1104,16 @@ static int vrf_add_slave(struct net_device *dev, struct net_device *port_dev,
 }
 
 /* inverse of do_vrf_add_slave */
-static int do_vrf_del_slave(struct net_device *dev, struct net_device *port_dev)
+static int do_vrf_del_slave(struct net_device *dev, struct net_device *port_dev,
+			    bool needs_sync)
 {
 	netdev_upper_dev_unlink(port_dev, dev);
 	port_dev->priv_flags &= ~IFF_L3MDEV_SLAVE;
+	/* Make sure that concurrent RCU readers that identified the device
+	 * as a VRF port see a VRF master or no master at all.
+	 */
+	if (needs_sync)
+		synchronize_net();
 
 	cycle_netdev(port_dev, NULL);
 
@@ -1115,7 +1122,7 @@ static int do_vrf_del_slave(struct net_device *dev, struct net_device *port_dev)
 
 static int vrf_del_slave(struct net_device *dev, struct net_device *port_dev)
 {
-	return do_vrf_del_slave(dev, port_dev);
+	return do_vrf_del_slave(dev, port_dev, true);
 }
 
 static void vrf_dev_uninit(struct net_device *dev)
@@ -1669,7 +1676,7 @@ static void vrf_dellink(struct net_device *dev, struct list_head *head)
 	struct list_head *iter;
 
 	netdev_for_each_lower_dev(dev, port_dev, iter)
-		vrf_del_slave(dev, port_dev);
+		do_vrf_del_slave(dev, port_dev, false);
 
 	vrf_map_unregister_dev(dev);
 
@@ -1801,7 +1808,7 @@ static int vrf_device_event(struct notifier_block *unused,
 			goto out;
 
 		vrf_dev = netdev_master_upper_dev_get(dev);
-		vrf_del_slave(vrf_dev, dev);
+		do_vrf_del_slave(vrf_dev, dev, false);
 	}
 out:
 	return NOTIFY_DONE;
-- 
2.53.0



