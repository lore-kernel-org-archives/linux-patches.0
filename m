Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3DA59;
	Wed, 30 Sep 2026 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791821; cv=none; b=VBK26mK/Syu5uroZVY445eWqFsiCmQLcwmv2VvZjb7BInpRFl+bc+nKiX6Auo7uv2hcZ/Z9EibeGSodKmbApjg6bz0NLzsRpZ/aPvhIXKtXa2s/rOOa0L3myFrZ1jjixvxaCjl9vf3IX4olw0qPnUbPWYTwvY6xfFgACE47+tsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791821; c=relaxed/simple;
	bh=yWG4ooTJMN4w/HI4O1+J9eUOgMypoeYz89kixqdYGLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IePNO6z0FSqygBM87wN70nes8BLasPYHXk93bGrgHUtVrpTx6CxcA4etOH858bpA4moAA5P6PFsXirhtwd9o2EOfixahfgGcJ11P4Ar/EizGoD+04zd09bhy0KsL05cfbsyGVz3G5SGKbxunxnn9aZTi9NGyEHs/pyucQ3mZJfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+xRUnFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+xRUnFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A9E1F00898;
	Wed, 30 Sep 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791820;
	bh=W9QpJmIdnxnVvIIwhcpbK+H5Wq2SUdieSAOL6BFjdiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+xRUnFEY78HeZbm+biwZfNI5AgsPlpzdybpu+oaK4XHxoFMyvSQn8k9lBkjAw+lJ
	 fKRHkfhbYAadd/reajjh6KQL4kAULkBHiXpHQRV2OLRKpLfew2qLHfCoodTfi4K8nc
	 M8qZCrlvf7XuN7GT4z/2hInGBaj1pzlEH25tjku0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/752] xfrm: propagate extack to all netlink doit handlers
Date: Wed, 30 Sep 2026 17:25:07 +0200
Message-ID: <20260930152407.742669333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index cd83ac8f8f562..cd720c6b87949 100644
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
@@ -1305,7 +1305,8 @@ static int build_spdinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrmu_spdhthresh *thresh4 = NULL;
@@ -1350,7 +1351,8 @@ static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1409,7 +1411,8 @@ static int build_sadinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1429,7 +1432,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_id *p = nlmsg_data(nlh);
@@ -1453,7 +1456,8 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1805,7 +1809,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 }
 
 static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_info *p = nlmsg_data(nlh);
@@ -2069,7 +2074,7 @@ static bool xfrm_userpolicy_is_valid(__u8 policy)
 }
 
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
@@ -2090,7 +2095,7 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *r_skb;
 	struct nlmsghdr *r_nlh;
@@ -2120,7 +2125,8 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2203,7 +2209,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			 struct nlattr **attrs,
+			 struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2303,7 +2310,7 @@ static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct
 }
 
 static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2347,7 +2354,7 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2398,7 +2405,8 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			     struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2426,7 +2434,8 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			       struct nlattr **attrs,
+			       struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2492,7 +2501,8 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2526,7 +2536,8 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2631,7 +2642,7 @@ static int copy_from_user_migrate(struct xfrm_migrate *ma,
 }
 
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct xfrm_userpolicy_id *pi = nlmsg_data(nlh);
 	struct xfrm_migrate m[XFRM_MAX_DEPTH];
@@ -2677,7 +2688,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 #else
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	return -ENOPROTOOPT;
 }
@@ -2874,7 +2885,8 @@ static const struct nla_policy xfrma_spd_policy[XFRMA_SPD_MAX+1] = {
 };
 
 static const struct xfrm_link {
-	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **);
+	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **,
+		    struct netlink_ext_ack *);
 	int (*start)(struct netlink_callback *);
 	int (*dump)(struct sk_buff *, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
@@ -2976,7 +2988,7 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err;
 	}
 
-	err = link->doit(skb, nlh, attrs);
+	err = link->doit(skb, nlh, attrs, extack);
 
 	/* We need to free skb allocated in xfrm_alloc_compat() before
 	 * returning from this function, because consume_skb() won't take
-- 
2.53.0



