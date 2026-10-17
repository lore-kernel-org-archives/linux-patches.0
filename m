Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471F12D3225;
	Sat, 17 Oct 2026 17:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258366; cv=none; b=mupo2uV0OLySin5VLKaYOppV+PpOXr1kAfJ4RG3VtixbKGPj6tW+Iy/roPK/rY/lxEBow7/HAiO2ahxA5KaZ3bRfzxbYYobJYorcBNpXd5unREdtDN0fmF9EDtzFiu3gzUoPtsitUeX1BtsF5ySHbT8TC/ZlAaVSjDtISQtZEgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258366; c=relaxed/simple;
	bh=XSKs6lk0GY71Md5+g5YyFHsk5PQJ8EUhXcBxl1KQKtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TixK7Q4lLy7Op5JPPBwsHtQj6wV1Y4oHl3QXmHxJf+G+YU/f+b2BlcW1dzCd4hh3l3qDnIhFtAuJSn8wnBbLeeVZJ/2IfEs3Lhd/L+oRAdo0QpTSTVuNxCuO0xRmScA7VNj2gK87izlX9E0YUSzlZA4YfvwgSP0J2Cj+J7mwQSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAi85AKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAi85AKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A222A1F000C4;
	Sat, 17 Oct 2026 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258365;
	bh=mlQxHRXJN0X7VgfUUhT6gJNz83rXu+jHJ5KNclEepLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAi85AKFrmdJnxmJ5dkz3S+D9JB2Q3C9pjuqELsitSNAGeAvq/LuppvPsRby/pV/L
	 mx07yirpcLZCy7lztFFnq/ZDXDlvkIsmdJykt/dSPaqyYOqM93aVHJDUWwGtfipp+s
	 Idcal1RDl90nUt4ADTotWPFD/7vs6AoaqfyKCHWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0860/1674] net: add xmit recursion limit to tunnel xmit functions
Date: Sat, 17 Oct 2026 17:52:12 +0200
Message-ID: <20261017160453.193526501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/ip6_tunnel.h  | 12 ++++++++++++
 include/net/ip_tunnels.h  |  7 +++++++
 net/ipv4/ip_tunnel_core.c | 13 +++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 74b369bddf49e..b3453ee4523a4 100644
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
 	pkt_len = skb->len - skb_inner_network_offset(skb);
 	err = ip6_local_out(dev_net(skb_dst(skb)->dev), sk, skb);
@@ -165,6 +175,8 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 			pkt_len = -1;
 		iptunnel_xmit_stats(dev, pkt_len);
 	}
+
+	dev_xmit_recursion_dec();
 }
 #endif
 #endif
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 1243ec414bcd9..e32e7cbe99167 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -24,6 +24,13 @@
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
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 3a1ab7ab171c3..87933ed7d9041 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -57,6 +57,17 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
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
@@ -86,6 +97,8 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 			pkt_len = 0;
 		iptunnel_xmit_stats(dev, pkt_len);
 	}
+
+	dev_xmit_recursion_dec();
 }
 EXPORT_SYMBOL_GPL(iptunnel_xmit);
 
-- 
2.53.0



