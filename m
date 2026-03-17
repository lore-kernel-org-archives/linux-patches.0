Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6423ED106;
	Tue, 17 Mar 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765696; cv=none; b=Rj89sxj1uvxoRIVhqHc0BjLDGaZOMW9LD/iOaN3Py4ZBfb0Z058UfwEJZocgAo3SfyI7t88wbsWECdqdDud4tdIIzlHaCYuhoI57eI6gbyNzGw/Wx3d4I/kl/hykAzTetSQP1r1q/zjEKTRUQhknfiX6vJHMrKUmbEnZxX+mW0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765696; c=relaxed/simple;
	bh=Xlab0s5tPzG4yxiGgdfUPTEvbRgyEkD1Rp3OU9RkbpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2jqa3C/AyyF9nEE5JRTeKAOtywMXz7GUjnRyYFrHLiyWunevRFtszsNM1zczl/ZA/moe2bQazoNJEd6s8IwAUApZ7RMxYpdJ5UICfyyJh986LIHkpTSomJ3UXXruKX2rLx8MLlBu63YdgDe9WoZLC0fTWyDlGWJKsJIJB2z6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG5yp5Un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG5yp5Un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8489C4CEF7;
	Tue, 17 Mar 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765696;
	bh=Xlab0s5tPzG4yxiGgdfUPTEvbRgyEkD1Rp3OU9RkbpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG5yp5UnfDGCwrIaSpWrwQP6aiNPLITxDoFM9WlTiPWA9BxwqUIV+1ix/1gI75X7O
	 oY37hbhxZ9OanCy2bSTeUYvqyAefD5STweU4hjH9k+yumUn9TU1Z9kQa7SidaWqSgL
	 AMj7KFEn7isiDQu71BDtSj02sqqlKyjm0F/291dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 073/378] net: add xmit recursion limit to tunnel xmit functions
Date: Tue, 17 Mar 2026 17:30:30 +0100
Message-ID: <20260317163009.702600978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 6f1a9140ecda3baba3d945b9a6155af4268aafc4 ]

Tunnel xmit functions (iptunnel_xmit, ip6tunnel_xmit) lack their own
recursion limit. When a bond device in broadcast mode has GRE tap
interfaces as slaves, and those GRE tunnels route back through the
bond, multicast/broadcast traffic triggers infinite recursion between
bond_xmit_broadcast() and ip_tunnel_xmit()/ip6_tnl_xmit(), causing
kernel stack overflow.

The existing XMIT_RECURSION_LIMIT (8) in the no-qdisc path is not
sufficient because tunnel recursion involves route lookups and full IP
output, consuming much more stack per level. Use a lower limit of 4
(IP_TUNNEL_RECURSION_LIMIT) to prevent overflow.

Add recursion detection using dev_xmit_recursion helpers directly in
iptunnel_xmit() and ip6tunnel_xmit() to cover all IPv4/IPv6 tunnel
paths including UDP encapsulated tunnels (VXLAN, Geneve, etc.).

Move dev_xmit_recursion helpers from net/core/dev.h to public header
include/linux/netdevice.h so they can be used by tunnel code.

 BUG: KASAN: stack-out-of-bounds in blake2s.constprop.0+0xe7/0x160
 Write of size 32 at addr ffff88810033fed0 by task kworker/0:1/11
 Workqueue: mld mld_ifc_work
 Call Trace:
  <TASK>
  __build_flow_key.constprop.0 (net/ipv4/route.c:515)
  ip_rt_update_pmtu (net/ipv4/route.c:1073)
  iptunnel_xmit (net/ipv4/ip_tunnel_core.c:84)
  ip_tunnel_xmit (net/ipv4/ip_tunnel.c:847)
  gre_tap_xmit (net/ipv4/ip_gre.c:779)
  dev_hard_start_xmit (net/core/dev.c:3887)
  sch_direct_xmit (net/sched/sch_generic.c:347)
  __dev_queue_xmit (net/core/dev.c:4802)
  bond_dev_queue_xmit (drivers/net/bonding/bond_main.c:312)
  bond_xmit_broadcast (drivers/net/bonding/bond_main.c:5279)
  bond_start_xmit (drivers/net/bonding/bond_main.c:5530)
  dev_hard_start_xmit (net/core/dev.c:3887)
  __dev_queue_xmit (net/core/dev.c:4841)
  ip_finish_output2 (net/ipv4/ip_output.c:237)
  ip_output (net/ipv4/ip_output.c:438)
  iptunnel_xmit (net/ipv4/ip_tunnel_core.c:86)
  gre_tap_xmit (net/ipv4/ip_gre.c:779)
  dev_hard_start_xmit (net/core/dev.c:3887)
  sch_direct_xmit (net/sched/sch_generic.c:347)
  __dev_queue_xmit (net/core/dev.c:4802)
  bond_dev_queue_xmit (drivers/net/bonding/bond_main.c:312)
  bond_xmit_broadcast (drivers/net/bonding/bond_main.c:5279)
  bond_start_xmit (drivers/net/bonding/bond_main.c:5530)
  dev_hard_start_xmit (net/core/dev.c:3887)
  __dev_queue_xmit (net/core/dev.c:4841)
  ip_finish_output2 (net/ipv4/ip_output.c:237)
  ip_output (net/ipv4/ip_output.c:438)
  iptunnel_xmit (net/ipv4/ip_tunnel_core.c:86)
  ip_tunnel_xmit (net/ipv4/ip_tunnel.c:847)
  gre_tap_xmit (net/ipv4/ip_gre.c:779)
  dev_hard_start_xmit (net/core/dev.c:3887)
  sch_direct_xmit (net/sched/sch_generic.c:347)
  __dev_queue_xmit (net/core/dev.c:4802)
  bond_dev_queue_xmit (drivers/net/bonding/bond_main.c:312)
  bond_xmit_broadcast (drivers/net/bonding/bond_main.c:5279)
  bond_start_xmit (drivers/net/bonding/bond_main.c:5530)
  dev_hard_start_xmit (net/core/dev.c:3887)
  __dev_queue_xmit (net/core/dev.c:4841)
  mld_sendpack
  mld_ifc_work
  process_one_work
  worker_thread
  </TASK>

Fixes: 745e20f1b626 ("net: add a recursion limit in xmit path")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260306160133.3852900-2-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 32 ++++++++++++++++++++++++++++++++
 include/net/ip6_tunnel.h  | 12 ++++++++++++
 include/net/ip_tunnels.h  |  7 +++++++
 net/core/dev.h            | 35 -----------------------------------
 net/ipv4/ip_tunnel_core.c | 13 +++++++++++++
 5 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6655b0c6e42b4..65d85dc9c8f05 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3573,17 +3573,49 @@ struct page_pool_bh {
 };
 DECLARE_PER_CPU(struct page_pool_bh, system_page_pool);
 
+#define XMIT_RECURSION_LIMIT	8
+
 #ifndef CONFIG_PREEMPT_RT
 static inline int dev_recursion_level(void)
 {
 	return this_cpu_read(softnet_data.xmit.recursion);
 }
+
+static inline bool dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.recursion) >
+			XMIT_RECURSION_LIMIT);
+}
+
+static inline void dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.recursion);
+}
+
+static inline void dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.recursion);
+}
 #else
 static inline int dev_recursion_level(void)
 {
 	return current->net_xmit.recursion;
 }
 
+static inline bool dev_xmit_recursion(void)
+{
+	return unlikely(current->net_xmit.recursion > XMIT_RECURSION_LIMIT);
+}
+
+static inline void dev_xmit_recursion_inc(void)
+{
+	current->net_xmit.recursion++;
+}
+
+static inline void dev_xmit_recursion_dec(void)
+{
+	current->net_xmit.recursion--;
+}
 #endif
 
 void __netif_schedule(struct Qdisc *q);
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 120db28658112..1253cbb4b0a45 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -156,6 +156,16 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 {
 	int pkt_len, err;
 
+	if (dev_recursion_level() > IP_TUNNEL_RECURSION_LIMIT) {
+		net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
+				     dev->name);
+		DEV_STATS_INC(dev, tx_errors);
+		kfree_skb(skb);
+		return;
+	}
+
+	dev_xmit_recursion_inc();
+
 	memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 	IP6CB(skb)->flags = ip6cb_flags;
 	pkt_len = skb->len - skb_inner_network_offset(skb);
@@ -166,6 +176,8 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 			pkt_len = -1;
 		iptunnel_xmit_stats(dev, pkt_len);
 	}
+
+	dev_xmit_recursion_dec();
 }
 #endif
 #endif
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 4021e6a73e32b..80662f8120803 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -27,6 +27,13 @@
 #include <net/ip6_route.h>
 #endif
 
+/* Recursion limit for tunnel xmit to detect routing loops.
+ * Unlike XMIT_RECURSION_LIMIT (8) used in the no-qdisc path, tunnel
+ * recursion involves route lookups and full IP output, consuming much
+ * more stack per level, so a lower limit is needed.
+ */
+#define IP_TUNNEL_RECURSION_LIMIT	4
+
 /* Keep error state on tunnel for 30 sec */
 #define IPTUNNEL_ERR_TIMEO	(30*HZ)
 
diff --git a/net/core/dev.h b/net/core/dev.h
index da18536cbd357..49173702e15e1 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -361,41 +361,6 @@ static inline void napi_assert_will_not_race(const struct napi_struct *napi)
 
 void kick_defer_list_purge(unsigned int cpu);
 
-#define XMIT_RECURSION_LIMIT	8
-
-#ifndef CONFIG_PREEMPT_RT
-static inline bool dev_xmit_recursion(void)
-{
-	return unlikely(__this_cpu_read(softnet_data.xmit.recursion) >
-			XMIT_RECURSION_LIMIT);
-}
-
-static inline void dev_xmit_recursion_inc(void)
-{
-	__this_cpu_inc(softnet_data.xmit.recursion);
-}
-
-static inline void dev_xmit_recursion_dec(void)
-{
-	__this_cpu_dec(softnet_data.xmit.recursion);
-}
-#else
-static inline bool dev_xmit_recursion(void)
-{
-	return unlikely(current->net_xmit.recursion > XMIT_RECURSION_LIMIT);
-}
-
-static inline void dev_xmit_recursion_inc(void)
-{
-	current->net_xmit.recursion++;
-}
-
-static inline void dev_xmit_recursion_dec(void)
-{
-	current->net_xmit.recursion--;
-}
-#endif
-
 int dev_set_hwtstamp_phylib(struct net_device *dev,
 			    struct kernel_hwtstamp_config *cfg,
 			    struct netlink_ext_ack *extack);
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 2e61ac1371289..b1b6bf949f65a 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -58,6 +58,17 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 	struct iphdr *iph;
 	int err;
 
+	if (dev_recursion_level() > IP_TUNNEL_RECURSION_LIMIT) {
+		net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
+				     dev->name);
+		DEV_STATS_INC(dev, tx_errors);
+		ip_rt_put(rt);
+		kfree_skb(skb);
+		return;
+	}
+
+	dev_xmit_recursion_inc();
+
 	skb_scrub_packet(skb, xnet);
 
 	skb_clear_hash_if_not_l4(skb);
@@ -88,6 +99,8 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 			pkt_len = 0;
 		iptunnel_xmit_stats(dev, pkt_len);
 	}
+
+	dev_xmit_recursion_dec();
 }
 EXPORT_SYMBOL_GPL(iptunnel_xmit);
 
-- 
2.51.0



