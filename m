Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1943FE37B;
	Wed, 20 May 2026 18:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302805; cv=none; b=i8U3si1+ePIsWgjDRH/FSFC0HVgsca3MoeCuGRPUgH/nOTtRA+buUPw+6hj++ZjuFRF4lIRTQ6w5pR0QxMco3GCEsvyxZDSwdUrGRcfLUL7frQpgHK6Emek8IQbXAotEBMPHOde9MJ0GdPaoEmLpfVcBE9aHaqP+Xe14jGYMijg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302805; c=relaxed/simple;
	bh=e4CnuSpunnfVGnJb6Ucdw61F/HgQeYXb00XgzlDEXMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbW68q5CckuA+Ce9qDsoD0z4/KShVJMa/Vifot1JQtN3TpNzLhqBxD9txR5dcuncfFyaKTEwa9RKPWowgyEwCby4bk2fTW/JD1iWXtzoyYQQZ7J6Dz7A1/6ZgDiVlinf7nNuE+9cO19w1dWl/2K4gh8wfTszmf6VKWuucm4LRHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AW2UelXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AW2UelXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A0C1F000E9;
	Wed, 20 May 2026 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302804;
	bh=WcsX+tSHzZFBVSfcqxDIwXsPZLq0copPxytoE5/JX2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AW2UelXyIPvhb+DnuJ0ObQ9XYfCckVdZ257wIyrBBUy4OmX49hsAy0OkSWqJn1FiK
	 dpz1v+lX3mLCzyVObMu0PQNd83mNcX4/WHDRIhybJQSpsn5r+jumt43zD+9BAj3RTm
	 3kTUaCwPh9bcWjo7eMgWSEqEC6R602r9qfmrSEdE=
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
Subject: [PATCH 6.6 389/508] vrf: Fix a potential NPD when removing a port from a VRF
Date: Wed, 20 May 2026 18:23:32 +0200
Message-ID: <20260520162107.046089973@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 64114e98d75d0..9f7b05a010519 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1126,6 +1126,7 @@ static int do_vrf_add_slave(struct net_device *dev, struct net_device *port_dev,
 
 err:
 	port_dev->priv_flags &= ~IFF_L3MDEV_SLAVE;
+	synchronize_net();
 	return ret;
 }
 
@@ -1145,10 +1146,16 @@ static int vrf_add_slave(struct net_device *dev, struct net_device *port_dev,
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
 
@@ -1157,7 +1164,7 @@ static int do_vrf_del_slave(struct net_device *dev, struct net_device *port_dev)
 
 static int vrf_del_slave(struct net_device *dev, struct net_device *port_dev)
 {
-	return do_vrf_del_slave(dev, port_dev);
+	return do_vrf_del_slave(dev, port_dev, true);
 }
 
 static void vrf_dev_uninit(struct net_device *dev)
@@ -1714,7 +1721,7 @@ static void vrf_dellink(struct net_device *dev, struct list_head *head)
 	struct list_head *iter;
 
 	netdev_for_each_lower_dev(dev, port_dev, iter)
-		vrf_del_slave(dev, port_dev);
+		do_vrf_del_slave(dev, port_dev, false);
 
 	vrf_map_unregister_dev(dev);
 
@@ -1845,7 +1852,7 @@ static int vrf_device_event(struct notifier_block *unused,
 			goto out;
 
 		vrf_dev = netdev_master_upper_dev_get(dev);
-		vrf_del_slave(vrf_dev, dev);
+		do_vrf_del_slave(vrf_dev, dev, false);
 	}
 out:
 	return NOTIFY_DONE;
-- 
2.53.0



