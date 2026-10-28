Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211504;
	b=0ANopFxQNWM/ZCTUKjBda2zspY86nSE0zuFhUXkB6FtK0ahrNTcdHfuzq3xHQ7DQl4Td
	 +D6rVwduRfCUGBQ2ecU7tlnxn8O/SA+svBncxXPA61Y0l5irbnOF24M61Glo9ZwTW0k00
	 H3uLA4dB2a3L1Oe8EB4cVmrJ9OaKyCGoX1BKnLhQ/vv73Gxjku1eeIU92G6NWesUbeT8e
	 EXvG3R1Vj1/QIHh7OE/TmF7qNUDWfRyHM5ynqn7Ldg0+hUUPHczQjA5VUJV8X6IAakVwe
	 PsM8JgSINzRYq7MLusA1fMQZ+e1VFu1Eda7AGTcnOsce4OpSSeMDov2G7aVnSOPYnZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ESJpf0ghBtQiAncCKoscBXqrEdWoj7hNXSiGGHEX1VE=;
	b=d2pw6BVqZQg6PFQdTPcrgXWYlJV2UP0y99VXUHLuY/7HPPiKC0mhUFAzMMu4YV2u4x8K
	 xzfPA9V/uDQKEzK6Kfh6IMqKbD8La05yAUZqmfH4dJNhY/FGPRO1vGe3GywKm2OToDd2y
	 nXYzWRpY/tUbfhRDdZBLT4Q0SBo6AhGMX0vuWFuze/RfVX5hlKR/9O/52ZizjU9dC9pz1
	 VVmmEj35UDvuN5cU/7FxpXZQHECz67xfwb20YgrhnoRzIywjfnNk19RSZFr20vlkj1Pbn
	 StQ3ABSJ+gqiUfshzjJjKqmH00WMxhoXMtytvDYD3J6e7gMSWj1hC3j1wJwNmXAfOQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lmkEpVI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EBF606A321;
	Wed, 28 Oct 2026 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmkEpVI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDAE1F01825;
	Wed, 28 Oct 2026 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211504;
	bh=ESJpf0ghBtQiAncCKoscBXqrEdWoj7hNXSiGGHEX1VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmkEpVI/kldohZSOYPqWzlUjCuHCoxykJ0nsrwZ8zTw+uYYGtd6Qsa9jiEdGNtG+L
	 1oqGHBrMwvdN3xyGTWZPEhd83il8OKJsBaDoJ6iXZlJLtEbhLQU+ZKSmYlS+9us/Lk
	 8cSN2u8kd4PG2WE8lasG7p3hrJU8jxIs3MtllLXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/571] flow_dissector: avoid u16 truncation of skb->len when computing thoff
Date: Wed, 28 Oct 2026 17:59:07 +0100
Message-ID: <20261028170017.504330299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b02348f5a4f82..b23f37aea1fb5 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -943,6 +943,7 @@ bool __skb_flow_dissect(const struct net *net,
 	int mpls_lse = 0;
 	int num_hdrs = 0;
 	u8 ip_proto = 0;
+	u32 thoff;
 	bool ret;
 
 	if (!data) {
@@ -1500,7 +1501,13 @@ bool __skb_flow_dissect(const struct net *net,
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



