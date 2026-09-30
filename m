Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF5515989;
	Wed, 30 Sep 2026 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788278; cv=none; b=NPuZa385grrOxSyOihR8Z1qqxneJMuCBwaC7O88VpmLvtD5eAzESCnBNNhEGiVDpJexyLZ+QSjAVQwJ6IbWE4TaWALN1Qec0HSZYpZAKtMsfNgDIwz6bohvI4sd249nM9MHnC51kWGI7COptzd4yT46c6epAc30JT4YzLVdEQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788278; c=relaxed/simple;
	bh=icO/J7owmbREgGlcUS14vWrT2iLHjJLu30nMsyClfEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1eAQURLezkeVRbzSLVsQHvTx/Z4hQefSIzI2CB5Or1d4PxG5G9DIjpP7dmdeO4Ln7hdi0TEIq2HaKcyKv6IYbmgXXmABk8hLl/6HWuPOsY7GRzCHcLFXqyHibZ2jzcNF0vlho+RCdFQnZq1Da80eGBY4ornXytfzam3MMfLy7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGrjY6Th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGrjY6Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAA71F000FF;
	Wed, 30 Sep 2026 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788277;
	bh=G21W6zyW6Xwo5uQBWzm3oj3uQbCTUMxpJdU8AAh3gdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGrjY6Thb7w6noyNwwLYaxaHlqPCUotHgqoEb6kD0RgXavoZLl2B+7pWRuTJ8XMfq
	 SiWXSToxEt7+du3+UN4n7ooaoMD6eLutXVeaq5U1LZ9sFBI+AtHHAncuNSNkgOFjHg
	 jMfTrVO+BNg5yT6y6i6s/zvvPmUUVHm39bWCmIbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/877] xfrm: avoid RCU warnings around the per-netns netlink socket
Date: Wed, 30 Sep 2026 17:15:34 +0200
Message-ID: <20260930152415.244305115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit d87f8bc47fbf012a7f115e311d0603d97e47c34c ]

net->xfrm.nlsk is used in 2 types of contexts:
 - fully under RCU, with rcu_read_lock + rcu_dereference and a NULL check
 - in the netlink handlers, with requests coming from a userspace socket

In the 2nd case, net->xfrm.nlsk is guaranteed to stay non-NULL and the
object is alive, since we can't enter the netns destruction path while
the user socket holds a reference on the netns.

After adding the __rcu annotation to netns_xfrm.nlsk (which silences
sparse warnings in the RCU users and __net_init code), we need to tell
sparse that the 2nd case is safe. Add a helper for that.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: d1ebd9081879 ("xfrm: fix compat ALLOCSPI request use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/xfrm.h |  2 +-
 net/xfrm/xfrm_user.c     | 25 +++++++++++++++++--------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 23dd647fe0248..b73983a17e088 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -59,7 +59,7 @@ struct netns_xfrm {
 	struct list_head	inexact_bins;
 
 
-	struct sock		*nlsk;
+	struct sock		__rcu *nlsk;
 	struct sock		*nlsk_stash;
 
 	u32			sysctl_aevent_etime;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 904c9328852f0..c37f8e518f1e3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -35,6 +35,15 @@
 #endif
 #include <linux/unaligned.h>
 
+static struct sock *xfrm_net_nlsk(const struct net *net, const struct sk_buff *skb)
+{
+	/* get the source of this request, see netlink_unicast_kernel */
+	const struct sock *sk = NETLINK_CB(skb).sk;
+
+	/* sk is refcounted, the netns stays alive and nlsk with it */
+	return rcu_dereference_protected(net->xfrm.nlsk, sk->sk_net_refcnt);
+}
+
 static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type,
 			  struct netlink_ext_ack *extack)
 {
@@ -1662,7 +1671,7 @@ static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = build_spdinfo(r_skb, net, sportid, seq, *flags);
 	BUG_ON(err < 0);
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid);
+	return nlmsg_unicast(xfrm_net_nlsk(net, skb), r_skb, sportid);
 }
 
 static inline unsigned int xfrm_sadinfo_msgsize(void)
@@ -1722,7 +1731,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = build_sadinfo(r_skb, net, sportid, seq, *flags);
 	BUG_ON(err < 0);
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid);
+	return nlmsg_unicast(xfrm_net_nlsk(net, skb), r_skb, sportid);
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -1742,7 +1751,7 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (IS_ERR(resp_skb)) {
 		err = PTR_ERR(resp_skb);
 	} else {
-		err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
+		err = nlmsg_unicast(xfrm_net_nlsk(net, skb), resp_skb, NETLINK_CB(skb).portid);
 	}
 	xfrm_state_put(x);
 out_noput:
@@ -1833,7 +1842,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
+	err = nlmsg_unicast(xfrm_net_nlsk(net, skb), resp_skb, NETLINK_CB(skb).portid);
 
 out:
 	xfrm_state_put(x);
@@ -2476,7 +2485,7 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 	r_up->out = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_OUT]);
 	nlmsg_end(r_skb, r_nlh);
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, portid);
+	return nlmsg_unicast(xfrm_net_nlsk(net, skb), r_skb, portid);
 }
 
 static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -2542,7 +2551,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (IS_ERR(resp_skb)) {
 			err = PTR_ERR(resp_skb);
 		} else {
-			err = nlmsg_unicast(net->xfrm.nlsk, resp_skb,
+			err = nlmsg_unicast(xfrm_net_nlsk(net, skb), resp_skb,
 					    NETLINK_CB(skb).portid);
 		}
 	} else {
@@ -2721,7 +2730,7 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 	}
 
-	err = nlmsg_unicast(net->xfrm.nlsk, r_skb, NETLINK_CB(skb).portid);
+	err = nlmsg_unicast(xfrm_net_nlsk(net, skb), r_skb, NETLINK_CB(skb).portid);
 	spin_unlock_bh(&x->lock);
 	xfrm_state_put(x);
 	return err;
@@ -3393,7 +3402,7 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto err;
 		}
 
-		err = netlink_dump_start(net->xfrm.nlsk, skb, nlh, &c);
+		err = netlink_dump_start(xfrm_net_nlsk(net, skb), skb, nlh, &c);
 		goto err;
 	}
 
-- 
2.53.0



