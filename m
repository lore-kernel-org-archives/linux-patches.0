Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044314DD3B7;
	Wed, 30 Sep 2026 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783295; cv=none; b=o1fzi5FUZ8i/ZWosUpQJshhYLKXMuc5L1vUl/Oa6qccZHEtNZZ2ozBGn9etx+ySO7u1Vs3LfTyXOHZhLDlsnnZssmY0O+3LKFWjgt5ygPXYUtkcvdM5WBwaF75yZJEm3Wtna12MGB6dETpx3abb/IrBMLvUcx57E4iDngn+k1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783295; c=relaxed/simple;
	bh=SRw30D4b/H8yenp3NfRrrNE1O1rekcL8nIJ+xzQKx5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BivkGNJc+D5DgbmbrTz/yVZsETYlzTqKDcAJgOF6UxyA1YhKujE7067KD4VTAw9z6OQp0sEZd+v9PpmMSbP5Lpz7LHr0p0BNHcjNQc4uB72iJt2DM0nln2aTtgkOjTVaFy2XhuXUKyy1v5a3u7krs6dejdzPBygR+ID0gAGinjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kURh4+9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kURh4+9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DED21F00898;
	Wed, 30 Sep 2026 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783290;
	bh=p1ZZ8jKXEbhA0Aa8l3aZgAYO664uckrTa9MFG+f6TC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kURh4+9iZM0yWd644PFheaGQeiKZgqBwsrH3kYqeitt/cCIu1rI0YIWaprB9VOKqR
	 IpN/UPeHOp22Ai2O6LUdczDyxc1YJ3wuxTuEa1Znlg7nc8KbZRAtBVsImwYKDKHWAt
	 TTDhCM1+d/kBnpQXDc4NANzQFSQYHB7cQbolUflU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 345/595] xfrm: propagate extack to all netlink doit handlers
Date: Wed, 30 Sep 2026 17:23:58 +0200
Message-ID: <20260930152355.099326238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 3bec6c3e83b5c125ff35e3dae3127c8d62046a1d ]

xfrm_user_rcv_msg() already handles extack, we just need to pass it down.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: d1ebd9081879 ("xfrm: fix compat ALLOCSPI request use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 56 +++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 27c5ad0e3d6c8..ecc3926ed8f65 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -681,7 +681,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 }
 
 static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_info *p = nlmsg_data(nlh);
@@ -760,7 +760,7 @@ static struct xfrm_state *xfrm_user_state_lookup(struct net *net,
 }
 
 static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1206,7 +1206,8 @@ static int build_spdinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrmu_spdhthresh *thresh4 = NULL;
@@ -1251,7 +1252,8 @@ static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1310,7 +1312,8 @@ static int build_sadinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1330,7 +1333,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_id *p = nlmsg_data(nlh);
@@ -1354,7 +1357,8 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1706,7 +1710,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 }
 
 static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_info *p = nlmsg_data(nlh);
@@ -1970,7 +1975,7 @@ static bool xfrm_userpolicy_is_valid(__u8 policy)
 }
 
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
@@ -1991,7 +1996,7 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *r_skb;
 	struct nlmsghdr *r_nlh;
@@ -2021,7 +2026,8 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2104,7 +2110,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			 struct nlattr **attrs,
+			 struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2204,7 +2211,7 @@ static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct
 }
 
 static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2248,7 +2255,7 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2299,7 +2306,8 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			     struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2327,7 +2335,8 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			       struct nlattr **attrs,
+			       struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2393,7 +2402,8 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2427,7 +2437,8 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2532,7 +2543,7 @@ static int copy_from_user_migrate(struct xfrm_migrate *ma,
 }
 
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct xfrm_userpolicy_id *pi = nlmsg_data(nlh);
 	struct xfrm_migrate m[XFRM_MAX_DEPTH];
@@ -2578,7 +2589,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 #else
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	return -ENOPROTOOPT;
 }
@@ -2775,7 +2786,8 @@ static const struct nla_policy xfrma_spd_policy[XFRMA_SPD_MAX+1] = {
 };
 
 static const struct xfrm_link {
-	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **);
+	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **,
+		    struct netlink_ext_ack *);
 	int (*start)(struct netlink_callback *);
 	int (*dump)(struct sk_buff *, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
@@ -2877,7 +2889,7 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err;
 	}
 
-	err = link->doit(skb, nlh, attrs);
+	err = link->doit(skb, nlh, attrs, extack);
 
 	/* We need to free skb allocated in xfrm_alloc_compat() before
 	 * returning from this function, because consume_skb() won't take
-- 
2.53.0



