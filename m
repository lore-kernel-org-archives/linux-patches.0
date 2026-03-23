Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636D9237707;
	Mon, 23 Mar 2026 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278019; cv=none; b=IxtCi7DtvU3RYmkH9LFn5k34kH50m1l6JfVU71k5/OrXM8Y7K/AyUF1vgUwE1uxZqLRIPKig9dQf8B9kAuSHSDHAshXMXQeKedkR8EnjtujYIewLFV7kxuNE3/y1sk6cO5DgAekMBbfzaOstoHZsxGV5GkbSLvoTJnPIVol1KDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278019; c=relaxed/simple;
	bh=VPP6WI0exGG98Qi9wQ3chRkc1E3smq/Yh5TW78XJeLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9kXJhqVIgUltnRit501GSDRzOn/qEIu4JuRpedCUmIybRqWivXDKPWVTZHFBuMToQhP41scvYqaauc8791G4BfNwNpzKBsLF0w1I4r0Sydx3sBsofgDySx0kwQs+nG3MHM4Hz0mO7aJZW81CGwjHlv3vQ9Y16fqSWu/OGivHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhG2JJfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhG2JJfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20C3C4CEF7;
	Mon, 23 Mar 2026 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278019;
	bh=VPP6WI0exGG98Qi9wQ3chRkc1E3smq/Yh5TW78XJeLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhG2JJfMF1h9YhRAf16tiHe44jvN16ypI6wBnlcext+fRehlTK0r2JuV2nOQX6gqQ
	 y+Kp/Px6IDUk5zy0dLG5LO7u9M3QY09bGny7aQj5enRV7rYbEUXgA5KtOKTBFeYRDq
	 nN1tHk+mbna9TQWMnszda3I1PRNc2leyGMFPBqqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guruprasad C P <gurucp2005@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/567] net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Mon, 23 Mar 2026 14:41:34 +0100
Message-ID: <20260323134538.141346519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 42d4c3727bf76..4af3e4c67038d 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -72,7 +72,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	     eth_hdr(skb)->h_proto == htons(ETH_P_RARP)) &&
 	    br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED)) {
 		br_do_proxy_suppress_arp(skb, br, vid, NULL);
-	} else if (IS_ENABLED(CONFIG_IPV6) &&
+	} else if (ipv6_mod_enabled() &&
 		   skb->protocol == htons(ETH_P_IPV6) &&
 		   br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED) &&
 		   pskb_may_pull(skb, sizeof(struct ipv6hdr) +
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 847fe03a08ee8..46d2b20afd5ff 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -165,7 +165,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
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



