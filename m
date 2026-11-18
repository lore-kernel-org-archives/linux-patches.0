Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032274;
	b=yJr4dFZPkbHWSFRoWPlGwtROcc2y95dFP93AXde9kOwsAnaRBtR7w5kicuUvX4vXbXYS
	 uxgjE7eXFrQ3zgyUyI+HXkRFhnf8tMYJaiZ7NIX4Zmeg/CWyTVMl37lxav5CpbmpkKCyz
	 I9igRJ4ONgNYsumha0hySggaPBXJrulv+luUU/b5oUhU+Uovo6Eb4j/OnvuLPh22nGvul
	 kWl6hXl5oiznzfYVGrp0AbjULW77RvTnM83IGho6En87Y5V6wzjaGyHQ0DibmOOnvmKRl
	 LC9gm8sEav0LiAM+pr9KjJD2PQ5IOBOTf3zVL4MMqhkzpCVdFkRAmUL/esxL44yVFSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qwYxMHbq2gRI01lT8LvbXaaT8Nsz1yK+5R3123kceLc=;
	b=SuakCFjKHb6BUrappBgV/7R8l8I0cksZfCDkARpmBnCF9ELi582L192q+WTETZGjt9aa
	 frpZc2E+zuuQKOEtuKhLLIy8zljVnkykg+b3brKHWDPHUI4vZN19w7uh7f9xN+jKy7V3M
	 6wnHL0mXDZym6rwhhfElzuGfP3O4qpyV4vpPYY4VZdXupxl4oZa8DJEVSfYAZ98iLGOr9
	 +n3RcLaeOpt2KDo0DmfNLYPoJWlH42zdWOFwc/39Vukw1F0l+BJ/5n8w1i1CCqCsId5ke
	 smnul/KxdWCLLPNAwtTVqcCpPG/lA+EHOP3hRpmd/IKRa1gm715luFnsHnqhGGphjmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEhGeMvA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38D7606A31C;
	Wed, 18 Nov 2026 20:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEhGeMvA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E13E1F000C6;
	Wed, 18 Nov 2026 20:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032274;
	bh=qwYxMHbq2gRI01lT8LvbXaaT8Nsz1yK+5R3123kceLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEhGeMvAwj8KZx9wQ0Pro1eMoP47PyLXXGXbq87AZf3wrZhWs3Zaaja1r4Sp9n9Ae
	 gK6wxTjreuHBgRHfJ5DiZAv2CU0pUInces1VaxnfanrosE4QqPsvrgiOokTul4+XVL
	 RSq3ujvNmjhRtna986NEt+A9I/xgyiqjYh9/0cJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1327/1756] ipv4: use RCU protection in inet_netconf_get_devconf()
Date: Wed, 18 Nov 2026 15:57:34 +0100
Message-ID: <20261118150102.237915275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit b2039a6dd36b5c89142bfb95bc0205be8abcc600 ]

inet_netconf_get_devconf() runs without RTNL. It uses dev_get_by_index()
and in_dev_get() to pin the device and its in_device while the reply is
allocated and filled.

in_dev_get() is not safe for a lockless caller. Since commit 9d40c84cf5bc
("net: devinet: Reduce refcount before grace period"), inetdev_destroy()
drops the final reference before the RCU grace period. A reader can load
dev->ip_ptr, then call refcount_inc() on a zero refcount after
in_dev_free_rcu() has been queued, and keep using the in_device once it
has been freed.

None of these references are needed. An in_device is freed after an RCU
grace period, ipv4_devconf is embedded in it, and
inet_netconf_fill_devconf() does not sleep.

Allocate the skb first, then perform the lookup and the fill under
rcu_read_lock(), using dev_get_by_index_rcu() and __in_dev_get_rcu(),
like inet_netconf_dump_devconf() already does.

Fixes: bbcf91053bb6 ("inet: do not use RTNL in inet_netconf_get_devconf()")
Reported-by: Baul Lee <baul.lee@xbow.com>
Closes: https://lore.kernel.org/netdev/20260815172032.79740-1-baul.lee@xbow.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Tested-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/CAAVpQUA5FEMWV1R4vy2+uzQc+_iLDaz4m-D6kfKYngGf2sE0Eg@mail.gmail.com
Link: https://patch.msgid.link/20261009074906.729877-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 46fa50576f581..6f81b61bf8878 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2211,8 +2211,8 @@ static int inet_netconf_get_devconf(struct sk_buff *in_skb,
 	struct net *net = sock_net(in_skb->sk);
 	struct nlattr *tb[NETCONFA_MAX + 1];
 	const struct ipv4_devconf *devconf;
-	struct in_device *in_dev = NULL;
-	struct net_device *dev = NULL;
+	struct in_device *in_dev;
+	struct net_device *dev;
 	struct sk_buff *skb;
 	int ifindex;
 	int err;
@@ -2224,7 +2224,13 @@ static int inet_netconf_get_devconf(struct sk_buff *in_skb,
 	if (!tb[NETCONFA_IFINDEX])
 		return -EINVAL;
 
+	skb = nlmsg_new(inet_netconf_msgsize_devconf(NETCONFA_ALL), GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
 	ifindex = nla_get_s32(tb[NETCONFA_IFINDEX]);
+
+	rcu_read_lock();
 	switch (ifindex) {
 	case NETCONFA_IFINDEX_ALL:
 		devconf = net->ipv4.devconf_all;
@@ -2234,36 +2240,29 @@ static int inet_netconf_get_devconf(struct sk_buff *in_skb,
 		break;
 	default:
 		err = -ENODEV;
-		dev = dev_get_by_index(net, ifindex);
-		if (dev)
-			in_dev = in_dev_get(dev);
+		dev = dev_get_by_index_rcu(net, ifindex);
+		if (!dev)
+			goto out_unlock;
+		in_dev = __in_dev_get_rcu(dev);
 		if (!in_dev)
-			goto errout;
+			goto out_unlock;
 		devconf = &in_dev->cnf;
 		break;
 	}
 
-	err = -ENOBUFS;
-	skb = nlmsg_new(inet_netconf_msgsize_devconf(NETCONFA_ALL), GFP_KERNEL);
-	if (!skb)
-		goto errout;
-
 	err = inet_netconf_fill_devconf(skb, ifindex, devconf,
 					NETLINK_CB(in_skb).portid,
 					nlh->nlmsg_seq, RTM_NEWNETCONF, 0,
 					NETCONFA_ALL);
+out_unlock:
+	rcu_read_unlock();
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in inet_netconf_msgsize_devconf() */
 		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
-		goto errout;
+		return err;
 	}
-	err = rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
-errout:
-	if (in_dev)
-		in_dev_put(in_dev);
-	dev_put(dev);
-	return err;
+	return rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
 }
 
 static int inet_netconf_dump_devconf(struct sk_buff *skb,
-- 
2.53.0



