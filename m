Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A439446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C879C433C7;
	Sun, 13 Aug 2023 21:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962732;
	bh=mQ5NRXZvFY+HN6Rd4xPvUZJ1L/QuP3EgdSYFA9qLev8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEQuINmvGTLPmNKAOfpsE6J04aeNblC3A2VCeLnILeqwmVID9ai0J8+XReJZa2CNy
	 eyHrSJNgb70FoUG2Xj00ouTI645aeS3xJafUon7MTZcd1qejJ4jtivU4H3iuT8shIB
	 kcoL0A/qMCFBGgMSU8iro0oMokSBTqDnGcH4T7xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 092/149] tunnels: fix kasan splat when generating ipv4 pmtu error
Date: Sun, 13 Aug 2023 23:18:57 +0200
Message-ID: <20230813211721.544957780@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit 6a7ac3d20593865209dceb554d8b3f094c6bd940 upstream.

If we try to emit an icmp error in response to a nonliner skb, we get

BUG: KASAN: slab-out-of-bounds in ip_compute_csum+0x134/0x220
Read of size 4 at addr ffff88811c50db00 by task iperf3/1691
CPU: 2 PID: 1691 Comm: iperf3 Not tainted 6.5.0-rc3+ #309
[..]
 kasan_report+0x105/0x140
 ip_compute_csum+0x134/0x220
 iptunnel_pmtud_build_icmp+0x554/0x1020
 skb_tunnel_check_pmtu+0x513/0xb80
 vxlan_xmit_one+0x139e/0x2ef0
 vxlan_xmit+0x1867/0x2760
 dev_hard_start_xmit+0x1ee/0x4f0
 br_dev_queue_push_xmit+0x4d1/0x660
 [..]

ip_compute_csum() cannot deal with nonlinear skbs, so avoid it.
After this change, splat is gone and iperf3 is no longer stuck.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20230803152653.29535-2-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -224,7 +224,7 @@ static int iptunnel_pmtud_build_icmp(str
 		.un.frag.__unused	= 0,
 		.un.frag.mtu		= htons(mtu),
 	};
-	icmph->checksum = ip_compute_csum(icmph, len);
+	icmph->checksum = csum_fold(skb_checksum(skb, 0, len, 0));
 	skb_reset_transport_header(skb);
 
 	niph = skb_push(skb, sizeof(*niph));


