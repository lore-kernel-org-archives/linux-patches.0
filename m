Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB911DED7D;
	Tue,  8 Oct 2024 13:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394179; cv=none; b=gBFdr9syR0qIjvIsq8skTQHJ+cBCmiywE7ohE1bUX6J5n43PN79/iWNReAlhFSQlOHTj//yq79aOlehg3gOPIqgpu8MU3lvBCjuhafVy4a5qz5dZ3YQ9lpz0ZZx/YtWEIVDQTmVdCGAUThiu9Uy8Adi3S802FEJ1FATCCEf85Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394179; c=relaxed/simple;
	bh=6Ys82iFwp4Lil7aUmTNxuMQwKkS29xfK4D4vtvZ8HuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W51LJn2WkbGIx3hsvpjcjHXAUW54cpx0PCJQyrLYaYpu8Edg9cw1h/AyCIJEeZaMgioVng3dXCIHXXuYJnFX8eIp6Ts2gZREiLPNP1E0fSSfJgudEHzsi9dAnLRKp7zX9gs/yu2+z9vPpfjmKu723w6QJGeJPZcdZyHScABRXoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNfmWXSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNfmWXSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989B0C4CEC7;
	Tue,  8 Oct 2024 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394179;
	bh=6Ys82iFwp4Lil7aUmTNxuMQwKkS29xfK4D4vtvZ8HuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNfmWXSzjiNRnIYidHUai7Esd6eJ0z5W3TvyY0vLn2zNUn3HM3DBpt24a7SYUHPOb
	 b8CdVrMNGbd46SQaH30EO1QX7RC8yJfzFwu4NQz273RXCT6DLEV+Xj9c2i9lfOD6Gl
	 iOEIY6mi6LSs0MMY2BW+fq6W8GPXbBXRM5JCDnRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	syzbot+d81bcd883824180500c8@syzkaller.appspotmail.com
Subject: [PATCH 6.6 371/386] net: dsa: fix netdev_priv() dereference before check on non-DSA netdevice events
Date: Tue,  8 Oct 2024 14:10:16 +0200
Message-ID: <20241008115643.985391161@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 844f104790bd69c2e4dbb9ee3eba46fde1fcea7b ]

After the blamed commit, we started doing this dereference for every
NETDEV_CHANGEUPPER and NETDEV_PRECHANGEUPPER event in the system.

static inline struct dsa_port *dsa_user_to_port(const struct net_device *dev)
{
	struct dsa_user_priv *p = netdev_priv(dev);

	return p->dp;
}

Which is obviously bogus, because not all net_devices have a netdev_priv()
of type struct dsa_user_priv. But struct dsa_user_priv is fairly small,
and p->dp means dereferencing 8 bytes starting with offset 16. Most
drivers allocate that much private memory anyway, making our access not
fault, and we discard the bogus data quickly afterwards, so this wasn't
caught.

But the dummy interface is somewhat special in that it calls
alloc_netdev() with a priv size of 0. So every netdev_priv() dereference
is invalid, and we get this when we emit a NETDEV_PRECHANGEUPPER event
with a VLAN as its new upper:

$ ip link add dummy1 type dummy
$ ip link add link dummy1 name dummy1.100 type vlan id 100
[   43.309174] ==================================================================
[   43.316456] BUG: KASAN: slab-out-of-bounds in dsa_user_prechangeupper+0x30/0xe8
[   43.323835] Read of size 8 at addr ffff3f86481d2990 by task ip/374
[   43.330058]
[   43.342436] Call trace:
[   43.366542]  dsa_user_prechangeupper+0x30/0xe8
[   43.371024]  dsa_user_netdevice_event+0xb38/0xee8
[   43.375768]  notifier_call_chain+0xa4/0x210
[   43.379985]  raw_notifier_call_chain+0x24/0x38
[   43.384464]  __netdev_upper_dev_link+0x3ec/0x5d8
[   43.389120]  netdev_upper_dev_link+0x70/0xa8
[   43.393424]  register_vlan_dev+0x1bc/0x310
[   43.397554]  vlan_newlink+0x210/0x248
[   43.401247]  rtnl_newlink+0x9fc/0xe30
[   43.404942]  rtnetlink_rcv_msg+0x378/0x580

Avoid the kernel oops by dereferencing after the type check, as customary.

Fixes: 4c3f80d22b2e ("net: dsa: walk through all changeupper notifier functions")
Reported-and-tested-by: syzbot+d81bcd883824180500c8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/0000000000001d4255060e87545c@google.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240110003354.2796778-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 844f104790bd69c2e4dbb9ee3eba46fde1fcea7b)
[Harshit: CVE-2024-26596; Resolve conflicts due to missing commit: 6ca80638b90c
 ("net: dsa: Use conduit and user terms") in 6.6.y, used dsa_slave_to_port()
 instead of dsa_user_to_port()]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/slave.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2822,13 +2822,14 @@ EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
+	struct dsa_port *dp;
 
 	if (!dsa_slave_dev_check(dev))
 		return err;
 
+	dp = dsa_slave_to_port(dev);
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2881,11 +2882,13 @@ static int dsa_slave_changeupper(struct
 static int dsa_slave_prechangeupper(struct net_device *dev,
 				    struct netdev_notifier_changeupper_info *info)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp;
 
 	if (!dsa_slave_dev_check(dev))
 		return NOTIFY_DONE;
 
+	dp = dsa_slave_to_port(dev);
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)


