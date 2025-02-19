Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DB1C3C00;
	Wed, 19 Feb 2025 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957570; cv=none; b=gE8f6THxYy++YrNYBjVvimDD/zJeEKJIopnrjLcBYiJ9ml7vPaARVcX8npLc0vnSJ4SbX6I0AOq2eyyRRZlvfXQg7gSkFsHoIWOj23OnFlvS6eP6XE5SG1Gx9Z6/CfVT8Q5rcpp4exY286vGYgdEa0UV/OPAMOIn6sjr1d3w0nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957570; c=relaxed/simple;
	bh=83K1DLjff5dI37jqN2PlKgXw0ubTaBMnHIlOQHhwwcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qejwPX7MzemZX/n+3LpROWPm24Y7Bm65s7iRLBHbpHXJjO47TrJ0+EOEwBvUXwuws2qKz5rGYF2x+bvNuSTSYp6eOCUwqCl+cOMoh7VbPQ6Wa4S2RXkqphQOGmqtmbEvbQf4sDoooFu/iqYRIa6edxOy70JDeViSao/tX/YZ+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbMxnbQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbMxnbQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8B0C4CED1;
	Wed, 19 Feb 2025 09:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957569;
	bh=83K1DLjff5dI37jqN2PlKgXw0ubTaBMnHIlOQHhwwcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbMxnbQdxPA0vWSt9JBHRzqYx0LHeTGv67aV8VKj06n0ZUdyrv0+vlJjFfiJZR18B
	 7EeyK4qkYF5ZjpoO02ygT0V1abPwlObE7D9A+GfkPIA4wyNah9m32CRl0g6IlQOCO5
	 mQa38XYyqKSq8C6u8FDIT0fC8TbvpObD67LsaI9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	syzbot+d81bcd883824180500c8@syzkaller.appspotmail.com
Subject: [PATCH 6.1 572/578] net: dsa: fix netdev_priv() dereference before check on non-DSA netdevice events
Date: Wed, 19 Feb 2025 09:29:36 +0100
Message-ID: <20250219082715.455088501@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 844f104790bd69c2e4dbb9ee3eba46fde1fcea7b upstream.

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
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/slave.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2592,13 +2592,14 @@ EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
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
@@ -2652,11 +2653,13 @@ static int dsa_slave_changeupper(struct
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


