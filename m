Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD6147B436;
	Sat, 12 Sep 2026 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237086; cv=none; b=M51g3Nw8pqULtr/f3EsF1mtD6s9bYqCWSla9cgNOosHDAPB/YTUR72/x/2d8f/0F0ERG+ZjbhEm8sMFOd26yiqHyL/oD37DvmDOCjMKyPCHkSWryLf+Xpkjz2lJdstvZ7lH41cuKE5ppTvfBDSJ4WLpK5FuOLwwcjCbinv9ZvpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237086; c=relaxed/simple;
	bh=IZz0gwicJ7Zz6Dwa209aByX6SIGXK7OiYRbCI3xqSAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxLwHD8k7fma3LoPip535Pf2cWBase2qUQXaGc3r/R4lokVbohmM1WXrHjl6naOrCMriijVlQXoIpssQTJR1eNM7HFjoCStrgKvnfUt8mf5VkAUa9MRtQdeRBBZJmYOxf2VoMZM9U1vaJnqeo5rOPfkCZeWZ9dnKTaVYjPjOtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wxvtv9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wxvtv9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C6E1F000FF;
	Sat, 12 Sep 2026 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237084;
	bh=VAS9IgMiVW94p3eyIqpDa0/EHZ+k/mzPxG+xH3dK1m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wxvtv9ihc5QuqXTyR4UfVXWbmHQxXz0EmVtAlnu9L64YlF9VZi6AuqjjMuMTfSEj
	 uyafAXU67UDjKSTxqCRsm4wNpmjkU6nM6XL6z42jOddZYFMwt90x90nVxC4CGUoaPg
	 qTw/tuoEz0jLk1gs+YuoYbmGinUaOeYpHhvWifl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 187/935] seg6: reset IP6CB after IPv6 decapsulation
Date: Sat, 12 Sep 2026 08:53:37 +0200
Message-ID: <20260912065531.104381192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit f967455fb2a5a2079b9eb5823e9ccf359174bf9f upstream.

decap_and_validate() pulls the outer SRv6 headers and makes the inner
packet the skb network header. The IPv6 control block still contains
values collected while parsing the outer packet, including nhoff and
extension-header flags.

End.DX6 and End.DT6 route the inner IPv6 packet directly to the IPv6
input path. An unprivileged user can reach End.DT6 from a user and net
namespace by installing a local SID and injecting an outer packet with
Hop-by-Hop and Destination Options headers followed by an SRH and a
minimal inner IPv6 packet.

The outer extension headers leave a large nhoff in IP6CB. After
decapsulation, ip6_protocol_deliver_rcu() uses that stale offset on the
inner packet and reads beyond the skb head. KASAN reports:

  BUG: KASAN: slab-out-of-bounds in ip6_protocol_deliver_rcu
  ip6_protocol_deliver_rcu+0x1118/0x1450
  ip6_input_finish+0x11b/0x240
  seg6_local_input_core+0xed/0x2e0
  lwtunnel_input+0x1e9/0x4e0
  ipv6_rthdr_rcv+0x525f/0x6c50
  ip6_protocol_deliver_rcu+0xcb7/0x1450

Before clearing IP6CB for an inner IPv6 packet, save its incoming
interface index and L3 slave state. Restore both after the clear and set
nhoff to the inner IPv6 base-header nexthdr field.

Use IP6CB(skb)->iif rather than skb->skb_iif because VRF processing can
replace skb_iif with the L3 master while IP6CB keeps the receiving
interface. Preserve IP6SKB_L3SLAVE for the same reason.

Fixes: d7a669dd2f8b ("ipv6: sr: add helper functions for seg6local")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_local.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -198,6 +198,15 @@ static bool decap_and_validate(struct sk
 
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		IPCB(skb)->iif = iif;
+	} else if (proto == IPPROTO_IPV6) {
+		bool l3slave = ipv6_l3mdev_skb(IP6CB(skb)->flags);
+		int iif = IP6CB(skb)->iif;
+
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		IP6CB(skb)->iif = iif;
+		IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
+		if (l3slave)
+			IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
 	}
 
 	return true;


