Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A72196DB3;
	Thu,  6 Jun 2024 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683058; cv=none; b=WkjGU+8u5QiJJvSKkpJRTuK9S+r7yi3TMvvZTtpFoHMW98Z/KTO0aadlv/ltgMp2iiWkYLFxcCS2YoQdfzJ7hX2q6t8/v2c2fZRVJCm/juMiBhk+ixbwmycaSSoeL70BbTG3Y+kBpgqKerdXeK9zD2KRofPv09FM3x2DX2pRsVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683058; c=relaxed/simple;
	bh=eJeog6TsSBucCj2SWzwmZBPCpdWGpNMRqiXAJSXVtdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk1T9m5/WSPR+xojCS1BhwHX100LgbmfSy0eBAV6WjKeiC4mMDTb8YZDX4yPKIZI94kbZAslU18sEB2n/b4xIQzx9icz2cyK5+yA5QJVfdY5POB/ovWccz6l40F15mk3rrDU5rSA8ebRoBEmYP9RMLwUN3wE+17o1J9V3TAja18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNtBLU6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNtBLU6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A31C32781;
	Thu,  6 Jun 2024 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683058;
	bh=eJeog6TsSBucCj2SWzwmZBPCpdWGpNMRqiXAJSXVtdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNtBLU6c/hQFKOeHMRe7w4ycOgYaFf8VuA3coCmN3ZZmqwV5Wb8abSqJJzx8O2J9i
	 bmuWJEREdT4GhfvnzRy/VYwvc25LHISQFPXICppqUZwk8ik0kHQgDWS2HiWdUjoT0T
	 6LtIhc9u73lPwp2cFDKUgxQJV9mSRglaTtykYC64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 305/374] netkit: Fix setting mac address in l2 mode
Date: Thu,  6 Jun 2024 16:04:44 +0200
Message-ID: <20240606131702.070355077@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d6fe532b7499e4575f9647879b7a34625817fe7f ]

When running Cilium connectivity test suite with netkit in L2 mode, we
found that it is expected to be able to specify a custom MAC address for
the devices, in particular, cilium-cni obtains the specified MAC address
by querying the endpoint and sets the MAC address of the interface inside
the Pod. Thus, fix the missing support in netkit for L2 mode.

Fixes: 35dfaad7188c ("netkit, bpf: Add bpf programmable net device")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20240524163619.26001-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netkit.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netkit.c b/drivers/net/netkit.c
index a4d2e76a8d587..272894053e2c4 100644
--- a/drivers/net/netkit.c
+++ b/drivers/net/netkit.c
@@ -155,6 +155,16 @@ static void netkit_set_multicast(struct net_device *dev)
 	/* Nothing to do, we receive whatever gets pushed to us! */
 }
 
+static int netkit_set_macaddr(struct net_device *dev, void *sa)
+{
+	struct netkit *nk = netkit_priv(dev);
+
+	if (nk->mode != NETKIT_L2)
+		return -EOPNOTSUPP;
+
+	return eth_mac_addr(dev, sa);
+}
+
 static void netkit_set_headroom(struct net_device *dev, int headroom)
 {
 	struct netkit *nk = netkit_priv(dev), *nk2;
@@ -198,6 +208,7 @@ static const struct net_device_ops netkit_netdev_ops = {
 	.ndo_start_xmit		= netkit_xmit,
 	.ndo_set_rx_mode	= netkit_set_multicast,
 	.ndo_set_rx_headroom	= netkit_set_headroom,
+	.ndo_set_mac_address	= netkit_set_macaddr,
 	.ndo_get_iflink		= netkit_get_iflink,
 	.ndo_get_peer_dev	= netkit_peer_dev,
 	.ndo_get_stats64	= netkit_get_stats,
@@ -300,9 +311,11 @@ static int netkit_validate(struct nlattr *tb[], struct nlattr *data[],
 
 	if (!attr)
 		return 0;
-	NL_SET_ERR_MSG_ATTR(extack, attr,
-			    "Setting Ethernet address is not supported");
-	return -EOPNOTSUPP;
+	if (nla_len(attr) != ETH_ALEN)
+		return -EINVAL;
+	if (!is_valid_ether_addr(nla_data(attr)))
+		return -EADDRNOTAVAIL;
+	return 0;
 }
 
 static struct rtnl_link_ops netkit_link_ops;
@@ -365,6 +378,9 @@ static int netkit_new_link(struct net *src_net, struct net_device *dev,
 		strscpy(ifname, "nk%d", IFNAMSIZ);
 		ifname_assign_type = NET_NAME_ENUM;
 	}
+	if (mode != NETKIT_L2 &&
+	    (tb[IFLA_ADDRESS] || tbp[IFLA_ADDRESS]))
+		return -EOPNOTSUPP;
 
 	net = rtnl_link_get_net(src_net, tbp);
 	if (IS_ERR(net))
@@ -379,7 +395,7 @@ static int netkit_new_link(struct net *src_net, struct net_device *dev,
 
 	netif_inherit_tso_max(peer, dev);
 
-	if (mode == NETKIT_L2)
+	if (mode == NETKIT_L2 && !(ifmp && tbp[IFLA_ADDRESS]))
 		eth_hw_addr_random(peer);
 	if (ifmp && dev->ifindex)
 		peer->ifindex = ifmp->ifi_index;
@@ -402,7 +418,7 @@ static int netkit_new_link(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		goto err_configure_peer;
 
-	if (mode == NETKIT_L2)
+	if (mode == NETKIT_L2 && !tb[IFLA_ADDRESS])
 		eth_hw_addr_random(dev);
 	if (tb[IFLA_IFNAME])
 		nla_strscpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
-- 
2.43.0



