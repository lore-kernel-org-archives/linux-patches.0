Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1E36EA89;
	Tue, 10 Mar 2026 11:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141289; cv=none; b=N6k8qf9oSM2YMJIjjPaMYOG2PKHuW+OW+vh++Vj1OpskdfY01wE9xeEQNzwIerVaRhRacUev4XBU8bYMhDkcgu51yNZT36XWMzH/8ilAbGPOlkq8WGRV/uGhAaDZFIsli60Ip+NM5VkHscUZZqO4qQk5mOFahqNUVdpHmS4L93M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141289; c=relaxed/simple;
	bh=aLEMm0Rq/81Dh6zMm+iMZGW8k/RC/DiIor1jU73C0Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2dUVYpCEEiUX6HUyUcFCjMzK0NlLDkIqtRrHmDU7LlhiEhIkDHOZ8uKxgzVl4iyYuWMzV9ZpvWTnwJGCr/k+JP+ljx4bKUwt9SrAV4G87vVXXzbV7Yhn4ixAapTP9qcAXjKO01mGG8eLDHu8L1NnhyueMyuwI+auESPH4abrMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnSxxg1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnSxxg1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8130FC2BC9E;
	Tue, 10 Mar 2026 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141289;
	bh=aLEMm0Rq/81Dh6zMm+iMZGW8k/RC/DiIor1jU73C0Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnSxxg1O962EN8CTZ2rH8s6O+t73xDJE/u9rFCL3/rHolEYM49OzT09N120GxU51U
	 Gf2W8BhKW9mHLIUgKCjBHMZPKj2lRZyE6pYsbYbSGsHhIhz00BbMmPnTsLNBxnS1H3
	 rWJP5PKV37ty/FsVszIDtsQkfnjRivoTxaK1AW0iL0/j5JPGEKUErI3UbkDGGoQdOa
	 BxnP7xaxLyRwA70+8vpmyLIJ6F0YXwCpTzT+GwTqOu5jop8KDPbIlvB9CtcvmnlZH0
	 mcrVMncfolaI6pMy4rIK8khzlD9Vwgh1n/O6A91eOUJRoFKETM/4PeKlrVxDPzRwIe
	 /k9w/LwPTHhgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Guruprasad C P <gurucp2005@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 293/311] net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Tue, 10 Mar 2026 07:05:40 -0400
Message-ID: <c16bfbced2f0a538011acd25f2547b6d73eed3ef.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit e5e890630533bdc15b26a34bb8e7ef539bdf1322 ]

When booting with the 'ipv6.disable=1' parameter, the nd_tbl is never
initialized because inet6_init() exits before ndisc_init() is called
which initializes it. Then, if neigh_suppress is enabled and an ICMPv6
Neighbor Discovery packet reaches the bridge, br_do_suppress_nd() will
dereference ipv6_stub->nd_tbl which is NULL, passing it to
neigh_lookup(). This causes a kernel NULL pointer dereference.

 BUG: kernel NULL pointer dereference, address: 0000000000000268
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 [...]
 RIP: 0010:neigh_lookup+0x16/0xe0
 [...]
 Call Trace:
  <IRQ>
  ? neigh_lookup+0x16/0xe0
  br_do_suppress_nd+0x160/0x290 [bridge]
  br_handle_frame_finish+0x500/0x620 [bridge]
  br_handle_frame+0x353/0x440 [bridge]
  __netif_receive_skb_core.constprop.0+0x298/0x1110
  __netif_receive_skb_one_core+0x3d/0xa0
  process_backlog+0xa0/0x140
  __napi_poll+0x2c/0x170
  net_rx_action+0x2c4/0x3a0
  handle_softirqs+0xd0/0x270
  do_softirq+0x3f/0x60

Fix this by replacing IS_ENABLED(IPV6) call with ipv6_mod_enabled() in
the callers. This is in essence disabling NS/NA suppression when IPv6 is
disabled.

Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Reported-by: Guruprasad C P <gurucp2005@gmail.com>
Closes: https://lore.kernel.org/netdev/CAHXs0ORzd62QOG-Fttqa2Cx_A_VFp=utE2H2VTX5nqfgs7LDxQ@mail.gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260304120357.9778-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_device.c | 2 +-
 net/bridge/br_input.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a818fdc22da9a..525d4eccd194a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -74,7 +74,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	     eth_hdr(skb)->h_proto == htons(ETH_P_RARP)) &&
 	    br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED)) {
 		br_do_proxy_suppress_arp(skb, br, vid, NULL);
-	} else if (IS_ENABLED(CONFIG_IPV6) &&
+	} else if (ipv6_mod_enabled() &&
 		   skb->protocol == htons(ETH_P_IPV6) &&
 		   br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED) &&
 		   pskb_may_pull(skb, sizeof(struct ipv6hdr) +
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 1405f1061a549..2cbae0f9ae1f0 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -170,7 +170,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	    (skb->protocol == htons(ETH_P_ARP) ||
 	     skb->protocol == htons(ETH_P_RARP))) {
 		br_do_proxy_suppress_arp(skb, br, vid, p);
-	} else if (IS_ENABLED(CONFIG_IPV6) &&
+	} else if (ipv6_mod_enabled() &&
 		   skb->protocol == htons(ETH_P_IPV6) &&
 		   br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED) &&
 		   pskb_may_pull(skb, sizeof(struct ipv6hdr) +
-- 
2.51.0

