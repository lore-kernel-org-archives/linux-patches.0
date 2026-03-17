Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBF8375F99;
	Tue, 17 Mar 2026 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765610; cv=none; b=lWIeJ273bSfjWeEKPEej9RhcDl0gd5BU0T2FBoUUorj7x/J30FJlXB5IaXvGLlNqHXLVJlSJG+FHKFDWpooZABECqs7Ei+DZUGl5do6zxwdyC/n8n7w0UHfi28nfZfh5QGwE+oARTayzQ6doA6PA6aYhs0Peg3QqdDHXWJYJFkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765610; c=relaxed/simple;
	bh=jZFnXPnpNKO47OhtpozJkSu6JaYI2SDtd0jMOyKGF3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYBHu06z1NoN1Q6auYFrzZfIOhm+P1tT5gn4XLFOdnO0CegNJEzSTNcAAAk3Zk5ucEZoPwlOsFGmwt5E4gAtlRgM4ABY5tUF3eTHMVY5cweX64uCz2ePT2DMbF9FG946+agxMPqyU6RM+rnZb1A56VNyk8OzoccJex6tEaSPKf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUaePgV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUaePgV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676E9C19424;
	Tue, 17 Mar 2026 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765610;
	bh=jZFnXPnpNKO47OhtpozJkSu6JaYI2SDtd0jMOyKGF3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUaePgV8VBJDDCS9QRBTgxa0na8EqPQZn4GCvcdbaI5AYWsLVOTL5hZP+WzEkjIc4
	 Uq3v3hsHO8XWErC7AUyzT4y49MC/i9uL55Ys3CdzQvJgdcDeMMaIHMkbMvXw94wuPD
	 lZ4xXYKWZNOLxjB700Wwjs0xuPVUr/P9ueRJStTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 049/378] net/sched: teql: fix NULL pointer dereference in iptunnel_xmit on TEQL slave xmit
Date: Tue, 17 Mar 2026 17:30:06 +0100
Message-ID: <20260317163008.792170542@linuxfoundation.org>
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

[ Upstream commit 0cc0c2e661af418bbf7074179ea5cfffc0a5c466 ]

teql_master_xmit() calls netdev_start_xmit(skb, slave) to transmit
through slave devices, but does not update skb->dev to the slave device
beforehand.

When a gretap tunnel is a TEQL slave, the transmit path reaches
iptunnel_xmit() which saves dev = skb->dev (still pointing to teql0
master) and later calls iptunnel_xmit_stats(dev, pkt_len). This
function does:

    get_cpu_ptr(dev->tstats)

Since teql_master_setup() does not set dev->pcpu_stat_type to
NETDEV_PCPU_STAT_TSTATS, the core network stack never allocates tstats
for teql0, so dev->tstats is NULL. get_cpu_ptr(NULL) computes
NULL + __per_cpu_offset[cpu], resulting in a page fault.

 BUG: unable to handle page fault for address: ffff8880e6659018
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 68bc067 P4D 68bc067 PUD 0
 Oops: Oops: 0002 [#1] SMP KASAN PTI
 RIP: 0010:iptunnel_xmit (./include/net/ip_tunnels.h:664 net/ipv4/ip_tunnel_core.c:89)
 Call Trace:
  <TASK>
  ip_tunnel_xmit (net/ipv4/ip_tunnel.c:847)
  __gre_xmit (net/ipv4/ip_gre.c:478)
  gre_tap_xmit (net/ipv4/ip_gre.c:779)
  teql_master_xmit (net/sched/sch_teql.c:319)
  dev_hard_start_xmit (net/core/dev.c:3887)
  sch_direct_xmit (net/sched/sch_generic.c:347)
  __dev_queue_xmit (net/core/dev.c:4802)
  neigh_direct_output (net/core/neighbour.c:1660)
  ip_finish_output2 (net/ipv4/ip_output.c:237)
  __ip_finish_output.part.0 (net/ipv4/ip_output.c:315)
  ip_mc_output (net/ipv4/ip_output.c:369)
  ip_send_skb (net/ipv4/ip_output.c:1508)
  udp_send_skb (net/ipv4/udp.c:1195)
  udp_sendmsg (net/ipv4/udp.c:1485)
  inet_sendmsg (net/ipv4/af_inet.c:859)
  __sys_sendto (net/socket.c:2206)

Fix this by setting skb->dev = slave before calling
netdev_start_xmit(), so that tunnel xmit functions see the correct
slave device with properly allocated tstats.

Fixes: 039f50629b7f ("ip_tunnel: Move stats update to iptunnel_xmit()")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260304044216.3517851-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_teql.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 6e4bdaa876ed6..783300d8b0197 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -315,6 +315,7 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (__netif_tx_trylock(slave_txq)) {
 				unsigned int length = qdisc_pkt_len(skb);
 
+				skb->dev = slave;
 				if (!netif_xmit_frozen_or_stopped(slave_txq) &&
 				    netdev_start_xmit(skb, slave, slave_txq, false) ==
 				    NETDEV_TX_OK) {
-- 
2.51.0



