Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8A7137C54;
	Tue, 23 Jan 2024 00:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970170; cv=none; b=mdzPZgLOZpmQMtCr/JFhBKBAjrcPHefpkojk4vl4J2qhAPbTtl5gPGBI4muNaBKReu9GHuDuI4+s1YBnbV+akMvAXdkcY9ZnLMYB8CSBMVvF/vJoADV/nTwB8vbhoi3cVto+sqceHU9NboACQUrGtaxWN6b0PwEc7vLk2H4p4cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970170; c=relaxed/simple;
	bh=QxfyFBH40O1u02K1Dm0kYJ2/hSPkkXtn4N3xaiglyxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQmYF3xq44Lrmul03gmgDyALXmN6hFhHQUCntlwdyrSS14qFZ3POabv7uiUzjAnDLgKxdyK7ZfAl/wJ2kVtQQhVDWSARa2OcD47vMvypKW5hVlfv0qRvB6iMeCKnKSpUlMUGnrUuFweHOGn+cJ7RtfiRuHp1nqzYuTAfdNzfgjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k85NqKjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k85NqKjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD4FC43394;
	Tue, 23 Jan 2024 00:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970169;
	bh=QxfyFBH40O1u02K1Dm0kYJ2/hSPkkXtn4N3xaiglyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k85NqKjBcShbRfMStuj+R3RIwO8Md+JC8A6Evbj8cLyl+hBkIKqCNfGuXC9cGd3SL
	 aD8icnrj1RdSK2dOJdPlAJ0ePiIHNnEJ30otNY7Z44VhFLo1GJgIyufIaVDy3uv0ke
	 2Rj3dA9UJpaNZm04hRNuyZ1KXOlQYSyoeUH6tzAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+d81bcd883824180500c8@syzkaller.appspotmail.com
Subject: [PATCH 6.7 582/641] net: dsa: fix netdev_priv() dereference before check on non-DSA netdevice events
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235836.397757504@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/user.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/dsa/user.c b/net/dsa/user.c
index d438884a4eb0..a82c7f5a1a12 100644
--- a/net/dsa/user.c
+++ b/net/dsa/user.c
@@ -2829,13 +2829,14 @@ EXPORT_SYMBOL_GPL(dsa_user_dev_check);
 static int dsa_user_changeupper(struct net_device *dev,
 				struct netdev_notifier_changeupper_info *info)
 {
-	struct dsa_port *dp = dsa_user_to_port(dev);
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
+	struct dsa_port *dp;
 
 	if (!dsa_user_dev_check(dev))
 		return err;
 
+	dp = dsa_user_to_port(dev);
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2888,11 +2889,13 @@ static int dsa_user_changeupper(struct net_device *dev,
 static int dsa_user_prechangeupper(struct net_device *dev,
 				   struct netdev_notifier_changeupper_info *info)
 {
-	struct dsa_port *dp = dsa_user_to_port(dev);
+	struct dsa_port *dp;
 
 	if (!dsa_user_dev_check(dev))
 		return NOTIFY_DONE;
 
+	dp = dsa_user_to_port(dev);
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
-- 
2.43.0



