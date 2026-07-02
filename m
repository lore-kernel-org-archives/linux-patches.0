Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995E83ACA54;
	Thu,  2 Jul 2026 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009793; cv=none; b=O0O5T4gIxOlK+tHgu3FIpqNSDb21ILEhV90FL54ieOyEt5RIjQBgJMvm25QAgUZcl5OXHV+3a/pi+3LcTgVsg5yP0k1wrmyG5BiaTWQwGyRt3zXUYEwX7JsvuFY75ww+PQVVRXxYLS4jwztDV9cGcu54kWzQrkwbbHJ/Wvv2F8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009793; c=relaxed/simple;
	bh=a9Ur+Sy9SgFnm4qcnCxz2kSWDx2oW7hPa90DokyCxm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pg09j8pBpwaKAmAXfHvQWw5TuRpFbDUbzjlEo51o47EfPXV5e6J0pT29/GsNr9Tfm4z3mQL+swcYg1J8ic4YejIaBjPcfXS5Z0RKeenJYkRJOyXVX4z6pfQhQ2wsnhABTJa4phXEw6WDEXG7/ChkFf7qZ2L2IYH8XR6kK11ZW4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycsRLo7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycsRLo7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89971F00AC4;
	Thu,  2 Jul 2026 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009791;
	bh=XmWqtqNtDvgaayky5hefvM+lhhePM/wO+erTyuzIlO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycsRLo7bPadd7IL+dFZ21G8tQlu22YWM0xDRFSvcKsMWObiFMg3qVNx8sfo9v2Syd
	 pS6yn0HT20N9+BBze7U/IGhr9ovnSD8Cf6W1Nvt8fnUcVZAsC4s56GWETpQmIH1jEO
	 EGQUtP3JefeOhW/8c5WS/8fnMqrdTGL1eIco31bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 87/95] phonet: Pass net and ifindex to phonet_address_notify().
Date: Thu,  2 Jul 2026 18:20:30 +0200
Message-ID: <20260702155111.038574272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 68ed5c38b512b734caf3da1f87db4a99fcfe3002 ]

Currently, phonet_address_notify() fetches netns and ifindex from dev.

Once addr_doit() is converted to RCU, phonet_address_notify() will be
called outside of RCU due to GFP_KERNEL, and dev will be unavailable
there.

Let's pass net and ifindex to phonet_address_notify().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 71de0177b28d ("net: phonet: free phonet_device after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/phonet/pn_dev.h |    2 +-
 net/phonet/pn_dev.c         |   10 +++++++---
 net/phonet/pn_netlink.c     |   12 ++++++------
 3 files changed, 14 insertions(+), 10 deletions(-)

--- a/include/net/phonet/pn_dev.h
+++ b/include/net/phonet/pn_dev.h
@@ -33,7 +33,7 @@ int phonet_address_add(struct net_device
 int phonet_address_del(struct net_device *dev, u8 addr);
 u8 phonet_address_get(struct net_device *dev, u8 addr);
 int phonet_address_lookup(struct net *net, u8 addr);
-void phonet_address_notify(int event, struct net_device *dev, u8 addr);
+void phonet_address_notify(struct net *net, int event, u32 ifindex, u8 addr);
 
 int phonet_route_add(struct net_device *dev, u8 daddr);
 int phonet_route_del(struct net_device *dev, u8 daddr);
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -98,10 +98,13 @@ static void phonet_device_destroy(struct
 	mutex_unlock(&pndevs->lock);
 
 	if (pnd) {
+		struct net *net = dev_net(dev);
+		u32 ifindex = dev->ifindex;
 		u8 addr;
 
 		for_each_set_bit(addr, pnd->addrs, 64)
-			phonet_address_notify(RTM_DELADDR, dev, addr);
+			phonet_address_notify(net, RTM_DELADDR, ifindex, addr);
+
 		kfree(pnd);
 	}
 }
@@ -244,8 +247,9 @@ static int phonet_device_autoconf(struct
 	ret = phonet_address_add(dev, req.ifr_phonet_autoconf.device);
 	if (ret)
 		return ret;
-	phonet_address_notify(RTM_NEWADDR, dev,
-				req.ifr_phonet_autoconf.device);
+
+	phonet_address_notify(dev_net(dev), RTM_NEWADDR, dev->ifindex,
+			      req.ifr_phonet_autoconf.device);
 	return 0;
 }
 
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -22,7 +22,7 @@
 static int fill_addr(struct sk_buff *skb, u32 ifindex, u8 addr,
 		     u32 portid, u32 seq, int event);
 
-void phonet_address_notify(int event, struct net_device *dev, u8 addr)
+void phonet_address_notify(struct net *net, int event, u32 ifindex, u8 addr)
 {
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
@@ -32,17 +32,17 @@ void phonet_address_notify(int event, st
 	if (skb == NULL)
 		goto errout;
 
-	err = fill_addr(skb, dev->ifindex, addr, 0, 0, event);
+	err = fill_addr(skb, ifindex, addr, 0, 0, event);
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, dev_net(dev), 0,
-		    RTNLGRP_PHONET_IFADDR, NULL, GFP_KERNEL);
+
+	rtnl_notify(skb, net, 0, RTNLGRP_PHONET_IFADDR, NULL, GFP_KERNEL);
 	return;
 errout:
-	rtnl_set_sk_err(dev_net(dev), RTNLGRP_PHONET_IFADDR, err);
+	rtnl_set_sk_err(net, RTNLGRP_PHONET_IFADDR, err);
 }
 
 static const struct nla_policy ifa_phonet_policy[IFA_MAX+1] = {
@@ -89,7 +89,7 @@ static int addr_doit(struct sk_buff *skb
 	else
 		err = phonet_address_del(dev, pnaddr);
 	if (!err)
-		phonet_address_notify(nlh->nlmsg_type, dev, pnaddr);
+		phonet_address_notify(net, nlh->nlmsg_type, ifm->ifa_index, pnaddr);
 	return err;
 }
 


