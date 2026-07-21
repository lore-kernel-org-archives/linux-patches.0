Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC0343FD1E;
	Tue, 21 Jul 2026 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672138; cv=none; b=Hf43pljCRTILKBaEfdXBN15RsfwgXZGFzZQlwEyTVCVrU4P+BdH3FLuQhx39u9/KZFg2IxvmZC+zUoIsipnNavJPG0g1v4VsiEkPnVWZ7jaPl+jE6xZN1oMKMXx79rU3PBN75gJLa9iCO0xFNlwEzdJG8SdPupXyW5vjoKmxKP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672138; c=relaxed/simple;
	bh=m+kzAbtxkk+JtllfhyMm4Xmh9oSdud8o0+i9LV/unpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMP5J9JJcNrVQanduJoDPtQx5D+4D+DnhdLATJwlnYidv5EIJk3Odcgx5NkpGLYmbrsb0HYy2GraobUHOeeWliPDUsOMArwlRQLwtFF65oekLpqfDLwnlX3a/erOoD9usBMWhq4IZEN0MYKyCMgnSXZlZDLZDdBoWgpVXxKCuHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY5HF3+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY5HF3+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9385B1F000E9;
	Tue, 21 Jul 2026 22:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672137;
	bh=B9e5YBSjSpx6Xpz6R57f11FpCxdiBOd6afWAPQYraqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PY5HF3+DLI5hpCqqGU56DR/vR54Kf4ZPoFzJXhsPlGbeFnLxe9kOPha84akZ1enL2
	 m4lss5WngWqKcx6y6LCypPFuUoDfQbo9e0/QeW4fCN3OqafEhSmuQ3Vlgufh+BNMf6
	 0bWO76/qolD1udcBa5jh+28TVr6NYYVFVcZifMKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 494/843] inet: allow ip_valid_fib_dump_req() to be called with RTNL or RCU
Date: Tue, 21 Jul 2026 17:22:09 +0200
Message-ID: <20260721152417.146311260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 22e36ea9f5d7707ae3d64c497d172f4ef735c353 ]

Add a new field into struct fib_dump_filter, to let callers
tell if they use RTNL locking or RCU.

This is used in the following patch, when inet_dump_fib()
no longer holds RTNL.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9facb861dc6b ("ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h    |  1 +
 net/ipv4/fib_frontend.c | 15 +++++++++++----
 net/ipv4/ipmr.c         |  4 +++-
 net/ipv6/ip6_fib.c      |  7 +++++--
 net/ipv6/ip6mr.c        |  4 +++-
 net/mpls/af_mpls.c      |  4 +++-
 6 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 718b9799d77d78..9bfb6c59a75d19 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -261,6 +261,7 @@ struct fib_dump_filter {
 	bool			filter_set;
 	bool			dump_routes;
 	bool			dump_exceptions;
+	bool			rtnl_held;
 	unsigned char		protocol;
 	unsigned char		rt_type;
 	unsigned int		flags;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index ced6bd48bb4168..09814e2acc03a1 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -918,7 +918,8 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 	struct rtmsg *rtm;
 	int err, i;
 
-	ASSERT_RTNL();
+	if (filter->rtnl_held)
+		ASSERT_RTNL();
 
 	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm))) {
 		NL_SET_ERR_MSG(extack, "Invalid header for FIB dump request");
@@ -963,7 +964,10 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 			break;
 		case RTA_OIF:
 			ifindex = nla_get_u32(tb[i]);
-			filter->dev = __dev_get_by_index(net, ifindex);
+			if (filter->rtnl_held)
+				filter->dev = __dev_get_by_index(net, ifindex);
+			else
+				filter->dev = dev_get_by_index_rcu(net, ifindex);
 			if (!filter->dev)
 				return -ENODEV;
 			break;
@@ -985,8 +989,11 @@ EXPORT_SYMBOL_GPL(ip_valid_fib_dump_req);
 
 static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct fib_dump_filter filter = { .dump_routes = true,
-					  .dump_exceptions = true };
+	struct fib_dump_filter filter = {
+		.dump_routes = true,
+		.dump_exceptions = true,
+		.rtnl_held = true,
+	};
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
 	unsigned int h, s_h;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c9a633559258ce..5e582eab1ea190 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2576,7 +2576,9 @@ static int ipmr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct fib_dump_filter filter = {};
+	struct fib_dump_filter filter = {
+		.rtnl_held = true,
+	};
 	int err;
 
 	if (cb->strict_check) {
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7d09193c144453..ba8fc26b86142f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -617,8 +617,11 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 
 static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct rt6_rtnl_dump_arg arg = { .filter.dump_exceptions = true,
-					 .filter.dump_routes = true };
+	struct rt6_rtnl_dump_arg arg = {
+		.filter.dump_exceptions = true,
+		.filter.dump_routes = true,
+		.filter.rtnl_held = true,
+	};
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
 	unsigned int h, s_h;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index ee094645c7ceae..909a2bc2a020d8 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2490,7 +2490,9 @@ static void mrt6msg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
 static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = cb->nlh;
-	struct fib_dump_filter filter = {};
+	struct fib_dump_filter filter = {
+		.rtnl_held = true,
+	};
 	int err;
 
 	if (cb->strict_check) {
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 2de9fb785c394b..b111778bcc3547 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2187,7 +2187,9 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
 	struct mpls_route __rcu **platform_label;
-	struct fib_dump_filter filter = {};
+	struct fib_dump_filter filter = {
+		.rtnl_held = true,
+	};
 	unsigned int flags = NLM_F_MULTI;
 	size_t platform_labels;
 	unsigned int index;
-- 
2.53.0



