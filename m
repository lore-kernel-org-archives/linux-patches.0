Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5248F83CC8;
	Thu,  5 Sep 2024 09:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530363; cv=none; b=ZJaVoKBnT1ydvPJOD1hvlynX61grrVrpgUQ2OXrJjYBFx2LEFMiX0NSDLU3k73TXCWHtbN5cOPOlhGBWntrGm5JVzZjOoHcq9AMq65RxofxRwPABDBgk0X/tPUUWtKs5HivDeQL/1g3Z8J/e5uA6YKI4KbB2UKxIdbrNuo7BV6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530363; c=relaxed/simple;
	bh=DbosPKtotajUZtpNdHElfG4FNEedoBdrmLPlv6qEJ/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiSbpV5bEHcu1wpb3z1ttoKh794+lusgVuRCvI9JugdqN7aO+AoqKtJdFm/Ijm9shE6wpX/FE0ki+nwUcmJCCrMFfvJLhKWlHO3B0oWkmq/IEKDgbjyd7KuO7geyUruwShL1hLIcd2ASuRCq5M47zU+jlt0t97f12tlpoUhZpXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HJjOPhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HJjOPhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17BEC4CEC3;
	Thu,  5 Sep 2024 09:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530363;
	bh=DbosPKtotajUZtpNdHElfG4FNEedoBdrmLPlv6qEJ/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HJjOPhLopSHOJknDDNQMpdCeUeYzAwQXbdXl+hxO6ediAGcl8ZWBSXE9aWyPudmi
	 1z+nqTc1JYZ7kgMGgtFIzR6IZ4aEba5CwE1dcQB4+qhL9eVEt0Ub3Me0Cq8FrFySDv
	 DSLzUw9QxtEaHHMQi+TE7xq0cgKEmY2v9ORaOG4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/132] net: remove NULL-pointer net parameter in ip_metrics_convert
Date: Thu,  5 Sep 2024 11:41:30 +0200
Message-ID: <20240905093726.243108469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 61e2bbafb00e4b9a5de45e6448a7b6b818658576 ]

When I was doing some experiments, I found that when using the first
parameter, namely, struct net, in ip_metrics_convert() always triggers NULL
pointer crash. Then I digged into this part, realizing that we can remove
this one due to its uselessness.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h         |  3 +--
 include/net/tcp.h        |  2 +-
 net/ipv4/fib_semantics.c |  5 ++---
 net/ipv4/metrics.c       |  8 ++++----
 net/ipv4/tcp_cong.c      | 11 +++++------
 net/ipv6/route.c         |  2 +-
 6 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 162cf2d2f841..6f1ff4846451 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -497,8 +497,7 @@ static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 	return mtu - lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
 }
 
-struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
-					int fc_mx_len,
+struct dst_metrics *ip_fib_metrics_init(struct nlattr *fc_mx, int fc_mx_len,
 					struct netlink_ext_ack *extack);
 static inline void ip_fib_metrics_put(struct dst_metrics *fib_metrics)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index cc3b56bf19e0..c206ffaa8ed7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1140,7 +1140,7 @@ extern struct tcp_congestion_ops tcp_reno;
 
 struct tcp_congestion_ops *tcp_ca_find(const char *name);
 struct tcp_congestion_ops *tcp_ca_find_key(u32 key);
-u32 tcp_ca_get_key_by_name(struct net *net, const char *name, bool *ecn_ca);
+u32 tcp_ca_get_key_by_name(const char *name, bool *ecn_ca);
 #ifdef CONFIG_INET
 char *tcp_ca_get_name_by_key(u32 key, char *buffer);
 #else
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index e3268615a65a..233d9d0437c2 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1030,7 +1030,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 			bool ecn_ca = false;
 
 			nla_strscpy(tmp, nla, sizeof(tmp));
-			val = tcp_ca_get_key_by_name(fi->fib_net, tmp, &ecn_ca);
+			val = tcp_ca_get_key_by_name(tmp, &ecn_ca);
 		} else {
 			if (nla_len(nla) != sizeof(u32))
 				return false;
@@ -1459,8 +1459,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	fi = kzalloc(struct_size(fi, fib_nh, nhs), GFP_KERNEL);
 	if (!fi)
 		goto failure;
-	fi->fib_metrics = ip_fib_metrics_init(fi->fib_net, cfg->fc_mx,
-					      cfg->fc_mx_len, extack);
+	fi->fib_metrics = ip_fib_metrics_init(cfg->fc_mx, cfg->fc_mx_len, extack);
 	if (IS_ERR(fi->fib_metrics)) {
 		err = PTR_ERR(fi->fib_metrics);
 		kfree(fi);
diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 0e3ee1532848..8ddac1f595ed 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -7,7 +7,7 @@
 #include <net/net_namespace.h>
 #include <net/tcp.h>
 
-static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
+static int ip_metrics_convert(struct nlattr *fc_mx,
 			      int fc_mx_len, u32 *metrics,
 			      struct netlink_ext_ack *extack)
 {
@@ -31,7 +31,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 			char tmp[TCP_CA_NAME_MAX];
 
 			nla_strscpy(tmp, nla, sizeof(tmp));
-			val = tcp_ca_get_key_by_name(net, tmp, &ecn_ca);
+			val = tcp_ca_get_key_by_name(tmp, &ecn_ca);
 			if (val == TCP_CA_UNSPEC) {
 				NL_SET_ERR_MSG(extack, "Unknown tcp congestion algorithm");
 				return -EINVAL;
@@ -63,7 +63,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 	return 0;
 }
 
-struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
+struct dst_metrics *ip_fib_metrics_init(struct nlattr *fc_mx,
 					int fc_mx_len,
 					struct netlink_ext_ack *extack)
 {
@@ -77,7 +77,7 @@ struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
 	if (unlikely(!fib_metrics))
 		return ERR_PTR(-ENOMEM);
 
-	err = ip_metrics_convert(net, fc_mx, fc_mx_len, fib_metrics->metrics,
+	err = ip_metrics_convert(fc_mx, fc_mx_len, fib_metrics->metrics,
 				 extack);
 	if (!err) {
 		refcount_set(&fib_metrics->refcnt, 1);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 1b34050a7538..95dbb2799be4 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -46,8 +46,7 @@ void tcp_set_ca_state(struct sock *sk, const u8 ca_state)
 }
 
 /* Must be called with rcu lock held */
-static struct tcp_congestion_ops *tcp_ca_find_autoload(struct net *net,
-						       const char *name)
+static struct tcp_congestion_ops *tcp_ca_find_autoload(const char *name)
 {
 	struct tcp_congestion_ops *ca = tcp_ca_find(name);
 
@@ -182,7 +181,7 @@ int tcp_update_congestion_control(struct tcp_congestion_ops *ca, struct tcp_cong
 	return ret;
 }
 
-u32 tcp_ca_get_key_by_name(struct net *net, const char *name, bool *ecn_ca)
+u32 tcp_ca_get_key_by_name(const char *name, bool *ecn_ca)
 {
 	const struct tcp_congestion_ops *ca;
 	u32 key = TCP_CA_UNSPEC;
@@ -190,7 +189,7 @@ u32 tcp_ca_get_key_by_name(struct net *net, const char *name, bool *ecn_ca)
 	might_sleep();
 
 	rcu_read_lock();
-	ca = tcp_ca_find_autoload(net, name);
+	ca = tcp_ca_find_autoload(name);
 	if (ca) {
 		key = ca->key;
 		*ecn_ca = ca->flags & TCP_CONG_NEEDS_ECN;
@@ -287,7 +286,7 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	int ret;
 
 	rcu_read_lock();
-	ca = tcp_ca_find_autoload(net, name);
+	ca = tcp_ca_find_autoload(name);
 	if (!ca) {
 		ret = -ENOENT;
 	} else if (!bpf_try_module_get(ca, ca->owner)) {
@@ -425,7 +424,7 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 	if (!load)
 		ca = tcp_ca_find(name);
 	else
-		ca = tcp_ca_find_autoload(sock_net(sk), name);
+		ca = tcp_ca_find_autoload(name);
 
 	/* No change asking for existing value */
 	if (ca == icsk->icsk_ca_ops) {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 49ef5623c55e..0299886dbeb9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3754,7 +3754,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	if (!rt)
 		goto out;
 
-	rt->fib6_metrics = ip_fib_metrics_init(net, cfg->fc_mx, cfg->fc_mx_len,
+	rt->fib6_metrics = ip_fib_metrics_init(cfg->fc_mx, cfg->fc_mx_len,
 					       extack);
 	if (IS_ERR(rt->fib6_metrics)) {
 		err = PTR_ERR(rt->fib6_metrics);
-- 
2.43.0



