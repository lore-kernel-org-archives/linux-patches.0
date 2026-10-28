Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209122;
	b=yRM49VLtnx5S3zNCXYkDwu/G++ZQpWYo7LcNDrkqqG2dAaIDiZvQpdYku7mQg/xM9tFh
	 tzzNhrptOsu9HKBb3EZA0Ru259H1gg2Ofri2ZdImBpoYNRsy4YLayPue6cI0l5EsE9BLG
	 xn0WRpYWBobTnDwB4ZEQqJqN4sLDMJ86w6G12w72U3g/+SP9UddCFfjFkXtD3cBQx7cMG
	 biJS01uV0FPCxE1vZjUagjDHjMVxmWAS65QlK0P2hpFUhHamd1/FbI/6wqUrBGgJBbDsg
	 EWzZYp2R17mi+WRlJImCSz+iPfT9tdx0KFKPzWmMdXlVuTlC6342/KYxbLgwdOhKqGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PjsRP9vTWzuEnExeZleIU2OjmpkdXmlnrmimKWxlFwk=;
	b=BdTKqlzrYkFFn0KEq6PNaTmonghdGvCZpW5yG+HB5EQ0qXqClL0BK3rbDqbtBPilM+8/
	 LlO45Iy32qmTHNjMIZgaBrwMAFQ8vIcBG2WkaWa+V9eey5YnqH6nvJ02mxn6Ss/vR5WK7
	 cpJfw2E+Lk/tYeUZxnXEI6dhlr+TR9sk15i/V5dp7OMeYDV+QrdR+HEJazuj9HLmxBI6f
	 3oZg+MEkm8XQUkveHC+xUcv6WTexEnpw3HHFtwsVq/2vXoNbiMLOjp/hV8qGuWDrIMdbx
	 hQa5almhBfWFxn9nAL/KAZODnUgMkDjNTf64F7z4+ncaVAWH8Hf3GDJ25pX6f22Koqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHDo16G6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D406606A31F;
	Wed, 28 Oct 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHDo16G6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAED81F01825;
	Wed, 28 Oct 2026 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209122;
	bh=PjsRP9vTWzuEnExeZleIU2OjmpkdXmlnrmimKWxlFwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHDo16G6poW5NhYvo8R1MdBqE5iyGNue1MZSUC/dARBMO87x0DihD10StZdABcSdd
	 s5zxXzueCYrNmxtkcr98ltzb3AQTLB9X5O2IePLQ0hLJVfgUZEsjyk5q5F8dnp/BQi
	 DL8MCcHHUYRY09dLoLU91d6uQN5Zq713DlYzB9DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/516] flow_dissector: avoid u16 truncation of skb->len when computing thoff
Date: Wed, 28 Oct 2026 17:58:31 +0100
Message-ID: <20261028170011.991691508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 99bda1ecbd56905f8bd934b9cdccd3bd251192b1 ]

__skb_flow_dissect() computes key_control->thoff using:

  key_control->thoff = min_t(u16, nhoff, skb ? skb->len : hlen);

min_t(u16, ...) casts both arguments to u16 before comparing them.
Whenever skb->len (or hlen) modulo 65536 is smaller than nhoff, the
truncated length wins and thoff is set to a bogus small value, even
when the dissection succeeded. For example, an IPv4/TCP frame with
skb->len == 65540 and nhoff == 34 gets thoff == 4, so callers such as
skb_probe_transport_header() point the transport header inside the
Ethernet header.

Such skbs are not exotic:
- At the time of commit d0c081b49137 ("flow_dissector: properly cap
  thoff field"), AF_PACKET with PACKET_VNET_HDR could already build GSO
  skbs larger than 64KB (MTU checks are skipped for GSO, and
  alloc_skb_with_frags() accepted up to MAX_SKB_FRAGS (17) order-0
  pages on top of the linear part).
- BIG TCP now makes skbs larger than 64KB common.
- The following patch makes tun_get_user() dissect IFF_TAP frames
  before eth_type_trans() pulls the Ethernet header, so a GSO frame
  carrying a 65522..65535 byte L3 packet will be dissected with
  skb->len in [65536, 65549].

Compare as u32 instead. If the resulting offset cannot be represented
in the u16 key_control->thoff, cap it to U16_MAX and report the
dissection as failed rather than silently returning a wrong transport
offset. thoff is still set on failure, as some callers (such as
eth_get_headlen()) use it regardless of the return value.

Fixes: d0c081b49137 ("flow_dissector: properly cap thoff field")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261001191140.2818991-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 93810d894b1bb..e93b674d4afef 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -933,6 +933,7 @@ bool __skb_flow_dissect(const struct net *net,
 	int mpls_lse = 0;
 	int num_hdrs = 0;
 	u8 ip_proto = 0;
+	u32 thoff;
 	bool ret;
 
 	if (!data) {
@@ -1475,7 +1476,13 @@ bool __skb_flow_dissect(const struct net *net,
 	ret = true;
 
 out:
-	key_control->thoff = min_t(u16, nhoff, skb ? skb->len : hlen);
+	thoff = min_t(u32, nhoff, skb ? skb->len : hlen);
+	if (unlikely(thoff > U16_MAX)) {
+		/* Cannot be represented in key_control->thoff. */
+		thoff = U16_MAX;
+		ret = false;
+	}
+	key_control->thoff = thoff;
 	key_basic->n_proto = proto;
 	key_basic->ip_proto = ip_proto;
 
-- 
2.53.0



