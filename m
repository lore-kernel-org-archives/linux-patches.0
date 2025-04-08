Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE29264FA0;
	Tue,  8 Apr 2025 11:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110884; cv=none; b=PHSMM65S0LXCavzu0O8B7iWVlagL7Wg1ETDm0fUj/afgRIzK7ldxr6ZDJ4Ykw2tWx7EJyyIyf4vw/DPhEltfbwsCulIqG+R0WlvG14+hqFikGjg/HXkTVrbW1sDcDz9XswwuTRo+0okooCK+ejxumDxv1SpYHAZJU9Fg4CZiG48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110884; c=relaxed/simple;
	bh=yrKNJzlKwgRkhAgNz5KTh8BBFzIicNl2iui1gmXcQjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5qi+TCve1HqrM/apu96l9N9aITrEUaZInQXx8X9TKSylkESlHdoWKdk0M8R4Ce8G6x4dEMuYLJSV46ltFd7A6YQaJV0tOHRZSAGXqbsORcIQ21OzGHqb/kx1xBrVcUKK07TwHtbttfEwp1Vw1RSOpGoEIbz5PHt08EtRfJy/GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfJBqcCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfJBqcCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED844C4CEE5;
	Tue,  8 Apr 2025 11:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110884;
	bh=yrKNJzlKwgRkhAgNz5KTh8BBFzIicNl2iui1gmXcQjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfJBqcCW9ABurMoPSA4rHRWX/ZbKi/2O5s6qajxNdwAdwWmC+a8QNfPzDdnyJ6NaX
	 kMGs7N6dt2Zwf6Vr5aV9o+Px78/8llCGuIES7IHmXbyEpsOdBWEqoFhJZsnhbyFokF
	 h4Wp1+SzbgyVUwi1el8lcF8soGdw3VODy+WyVfwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	yan kang <kangyan91@outlook.com>,
	yue sun <samsun1006219@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 230/731] net: Remove RTNL dance for SIOCBRADDIF and SIOCBRDELIF.
Date: Tue,  8 Apr 2025 12:42:07 +0200
Message-ID: <20250408104919.630859431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit ed3ba9b6e280e14cc3148c1b226ba453f02fa76c ]

SIOCBRDELIF is passed to dev_ioctl() first and later forwarded to
br_ioctl_call(), which causes unnecessary RTNL dance and the splat
below [0] under RTNL pressure.

Let's say Thread A is trying to detach a device from a bridge and
Thread B is trying to remove the bridge.

In dev_ioctl(), Thread A bumps the bridge device's refcnt by
netdev_hold() and releases RTNL because the following br_ioctl_call()
also re-acquires RTNL.

In the race window, Thread B could acquire RTNL and try to remove
the bridge device.  Then, rtnl_unlock() by Thread B will release RTNL
and wait for netdev_put() by Thread A.

Thread A, however, must hold RTNL after the unlock in dev_ifsioc(),
which may take long under RTNL pressure, resulting in the splat by
Thread B.

  Thread A (SIOCBRDELIF)           Thread B (SIOCBRDELBR)
  ----------------------           ----------------------
  sock_ioctl                       sock_ioctl
  `- sock_do_ioctl                 `- br_ioctl_call
     `- dev_ioctl                     `- br_ioctl_stub
        |- rtnl_lock                     |
        |- dev_ifsioc                    '
        '  |- dev = __dev_get_by_name(...)
           |- netdev_hold(dev, ...)      .
       /   |- rtnl_unlock  ------.       |
       |   |- br_ioctl_call       `--->  |- rtnl_lock
  Race |   |  `- br_ioctl_stub           |- br_del_bridge
  Window   |     |                       |  |- dev = __dev_get_by_name(...)
       |   |     |  May take long        |  `- br_dev_delete(dev, ...)
       |   |     |  under RTNL pressure  |     `- unregister_netdevice_queue(dev, ...)
       |   |     |               |       `- rtnl_unlock
       \   |     |- rtnl_lock  <-'          `- netdev_run_todo
           |     |- ...                        `- netdev_run_todo
           |     `- rtnl_unlock                   |- __rtnl_unlock
           |                                      |- netdev_wait_allrefs_any
           |- netdev_put(dev, ...)  <----------------'
                                                Wait refcnt decrement
                                                and log splat below

To avoid blocking SIOCBRDELBR unnecessarily, let's not call
dev_ioctl() for SIOCBRADDIF and SIOCBRDELIF.

In the dev_ioctl() path, we do the following:

  1. Copy struct ifreq by get_user_ifreq in sock_do_ioctl()
  2. Check CAP_NET_ADMIN in dev_ioctl()
  3. Call dev_load() in dev_ioctl()
  4. Fetch the master dev from ifr.ifr_name in dev_ifsioc()

3. can be done by request_module() in br_ioctl_call(), so we move
1., 2., and 4. to br_ioctl_stub().

Note that 2. is also checked later in add_del_if(), but it's better
performed before RTNL.

SIOCBRADDIF and SIOCBRDELIF have been processed in dev_ioctl() since
the pre-git era, and there seems to be no specific reason to process
them there.

[0]:
unregister_netdevice: waiting for wpan3 to become free. Usage count = 2
ref_tracker: wpan3@ffff8880662d8608 has 1/1 users at
     __netdev_tracker_alloc include/linux/netdevice.h:4282 [inline]
     netdev_hold include/linux/netdevice.h:4311 [inline]
     dev_ifsioc+0xc6a/0x1160 net/core/dev_ioctl.c:624
     dev_ioctl+0x255/0x10c0 net/core/dev_ioctl.c:826
     sock_do_ioctl+0x1ca/0x260 net/socket.c:1213
     sock_ioctl+0x23a/0x6c0 net/socket.c:1318
     vfs_ioctl fs/ioctl.c:51 [inline]
     __do_sys_ioctl fs/ioctl.c:906 [inline]
     __se_sys_ioctl fs/ioctl.c:892 [inline]
     __x64_sys_ioctl+0x1a4/0x210 fs/ioctl.c:892
     do_syscall_x64 arch/x86/entry/common.c:52 [inline]
     do_syscall_64+0xcb/0x250 arch/x86/entry/common.c:83
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 893b19587534 ("net: bridge: fix ioctl locking")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Reported-by: yan kang <kangyan91@outlook.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/netdev/SY8P300MB0421225D54EB92762AE8F0F2A1D32@SY8P300MB0421.AUSP300.PROD.OUTLOOK.COM/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250316192851.19781-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_bridge.h |  6 ++----
 net/bridge/br_ioctl.c     | 36 +++++++++++++++++++++++++++++++++---
 net/bridge/br_private.h   |  3 +--
 net/core/dev_ioctl.c      | 19 -------------------
 net/socket.c              | 19 +++++++++----------
 5 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 3ff96ae31bf6d..c5fe3b2a53e82 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -65,11 +65,9 @@ struct br_ip_list {
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
 struct net_bridge;
-void brioctl_set(int (*hook)(struct net *net, struct net_bridge *br,
-			     unsigned int cmd, struct ifreq *ifr,
+void brioctl_set(int (*hook)(struct net *net, unsigned int cmd,
 			     void __user *uarg));
-int br_ioctl_call(struct net *net, struct net_bridge *br, unsigned int cmd,
-		  struct ifreq *ifr, void __user *uarg);
+int br_ioctl_call(struct net *net, unsigned int cmd, void __user *uarg);
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)
 int br_multicast_list_adjacent(struct net_device *dev,
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index f213ed1083618..6bc0a11f2ed3e 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -394,10 +394,26 @@ static int old_deviceless(struct net *net, void __user *data)
 	return -EOPNOTSUPP;
 }
 
-int br_ioctl_stub(struct net *net, struct net_bridge *br, unsigned int cmd,
-		  struct ifreq *ifr, void __user *uarg)
+int br_ioctl_stub(struct net *net, unsigned int cmd, void __user *uarg)
 {
 	int ret = -EOPNOTSUPP;
+	struct ifreq ifr;
+
+	if (cmd == SIOCBRADDIF || cmd == SIOCBRDELIF) {
+		void __user *data;
+		char *colon;
+
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+			return -EPERM;
+
+		if (get_user_ifreq(&ifr, &data, uarg))
+			return -EFAULT;
+
+		ifr.ifr_name[IFNAMSIZ - 1] = 0;
+		colon = strchr(ifr.ifr_name, ':');
+		if (colon)
+			*colon = 0;
+	}
 
 	rtnl_lock();
 
@@ -430,7 +446,21 @@ int br_ioctl_stub(struct net *net, struct net_bridge *br, unsigned int cmd,
 		break;
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
-		ret = add_del_if(br, ifr->ifr_ifindex, cmd == SIOCBRADDIF);
+	{
+		struct net_device *dev;
+
+		dev = __dev_get_by_name(net, ifr.ifr_name);
+		if (!dev || !netif_device_present(dev)) {
+			ret = -ENODEV;
+			break;
+		}
+		if (!netif_is_bridge_master(dev)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = add_del_if(netdev_priv(dev), ifr.ifr_ifindex, cmd == SIOCBRADDIF);
+	}
 		break;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1054b8a88edc4..d5b3c5936a79e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -949,8 +949,7 @@ br_port_get_check_rtnl(const struct net_device *dev)
 /* br_ioctl.c */
 int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq,
 			  void __user *data, int cmd);
-int br_ioctl_stub(struct net *net, struct net_bridge *br, unsigned int cmd,
-		  struct ifreq *ifr, void __user *uarg);
+int br_ioctl_stub(struct net *net, unsigned int cmd, void __user *uarg);
 
 /* br_multicast.c */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 4c2098ac9d724..57f79f8e84665 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -551,7 +551,6 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 	int err;
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
 	const struct net_device_ops *ops;
-	netdevice_tracker dev_tracker;
 
 	if (!dev)
 		return -ENODEV;
@@ -614,22 +613,6 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 	case SIOCWANDEV:
 		return dev_siocwandev(dev, &ifr->ifr_settings);
 
-	case SIOCBRADDIF:
-	case SIOCBRDELIF:
-		if (!netif_device_present(dev))
-			return -ENODEV;
-		if (!netif_is_bridge_master(dev))
-			return -EOPNOTSUPP;
-
-		netdev_hold(dev, &dev_tracker, GFP_KERNEL);
-		rtnl_net_unlock(net);
-
-		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
-
-		netdev_put(dev, &dev_tracker);
-		rtnl_net_lock(net);
-		return err;
-
 	case SIOCDEVPRIVATE ... SIOCDEVPRIVATE + 15:
 		return dev_siocdevprivate(dev, ifr, data, cmd);
 
@@ -812,8 +795,6 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 	case SIOCBONDRELEASE:
 	case SIOCBONDSETHWADDR:
 	case SIOCBONDCHANGEACTIVE:
-	case SIOCBRADDIF:
-	case SIOCBRDELIF:
 	case SIOCSHWTSTAMP:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
diff --git a/net/socket.c b/net/socket.c
index 28bae5a942341..38227d00d1987 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1145,12 +1145,10 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
  */
 
 static DEFINE_MUTEX(br_ioctl_mutex);
-static int (*br_ioctl_hook)(struct net *net, struct net_bridge *br,
-			    unsigned int cmd, struct ifreq *ifr,
+static int (*br_ioctl_hook)(struct net *net, unsigned int cmd,
 			    void __user *uarg);
 
-void brioctl_set(int (*hook)(struct net *net, struct net_bridge *br,
-			     unsigned int cmd, struct ifreq *ifr,
+void brioctl_set(int (*hook)(struct net *net, unsigned int cmd,
 			     void __user *uarg))
 {
 	mutex_lock(&br_ioctl_mutex);
@@ -1159,8 +1157,7 @@ void brioctl_set(int (*hook)(struct net *net, struct net_bridge *br,
 }
 EXPORT_SYMBOL(brioctl_set);
 
-int br_ioctl_call(struct net *net, struct net_bridge *br, unsigned int cmd,
-		  struct ifreq *ifr, void __user *uarg)
+int br_ioctl_call(struct net *net, unsigned int cmd, void __user *uarg)
 {
 	int err = -ENOPKG;
 
@@ -1169,7 +1166,7 @@ int br_ioctl_call(struct net *net, struct net_bridge *br, unsigned int cmd,
 
 	mutex_lock(&br_ioctl_mutex);
 	if (br_ioctl_hook)
-		err = br_ioctl_hook(net, br, cmd, ifr, uarg);
+		err = br_ioctl_hook(net, cmd, uarg);
 	mutex_unlock(&br_ioctl_mutex);
 
 	return err;
@@ -1269,7 +1266,9 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		case SIOCSIFBR:
 		case SIOCBRADDBR:
 		case SIOCBRDELBR:
-			err = br_ioctl_call(net, NULL, cmd, NULL, argp);
+		case SIOCBRADDIF:
+		case SIOCBRDELIF:
+			err = br_ioctl_call(net, cmd, argp);
 			break;
 		case SIOCGIFVLAN:
 		case SIOCSIFVLAN:
@@ -3429,6 +3428,8 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGPGRP:
 	case SIOCBRADDBR:
 	case SIOCBRDELBR:
+	case SIOCBRADDIF:
+	case SIOCBRDELIF:
 	case SIOCGIFVLAN:
 	case SIOCSIFVLAN:
 	case SIOCGSKNS:
@@ -3468,8 +3469,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGIFPFLAGS:
 	case SIOCGIFTXQLEN:
 	case SIOCSIFTXQLEN:
-	case SIOCBRADDIF:
-	case SIOCBRDELIF:
 	case SIOCGIFNAME:
 	case SIOCSIFNAME:
 	case SIOCGMIIPHY:
-- 
2.39.5



