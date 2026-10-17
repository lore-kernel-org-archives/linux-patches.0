Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1312E357D0A;
	Sat, 17 Oct 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257411; cv=none; b=AzFTElOPNA0kA04pGGu86i4VGjtxueODVht6EjSG3fmH3ylxJ8/4Pm1R2f+Le3hCFtFRopXyk3Xjo5UHRsh46ADxmj7GuAnhtc4U93AixOk1cHSKRk+EsP9D9/ekCtMslJPi3nH/6h6b7hl0LbPR2POPFTNXdcDEdpTtlQKQP08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257411; c=relaxed/simple;
	bh=rbzaHqdfu8ipyNWoTBDe41z+zpeIGSf8Yt/8I58hpE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LH+qlS7+BS6FTztoUDA4UQdrlgww4JOsatzLVz5oyu64ca/h3/tIrxvpTA71YgpCi2dnQB6xMNqm8JBnLQCYqN2BD6RKpJ0ZFJBYunMtPS9G8i0lcUv4isDWWnGFBS8apWbZ2NqByxA26sC3nrYMxTT14GcLljyvD9DIjzIFTOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbry/UNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbry/UNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EC1F000C4;
	Sat, 17 Oct 2026 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257409;
	bh=RoAzhtVZDW+bWALz0GR9lqBGH/zLP53QRcS+XoepHHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbry/UNX9mErb029XazTUj008n1binLHadJgGKoYxnBBJwheup/eiJ/zKa/s4yM+U
	 6VyI9UdFcwiAhmNkObBBcJmPyFqtXiRfBJcsLybZp/g8qmvsmIjLSBd/ZtLZNQ+cwO
	 WBA2X35FH4+yioE3HUsLKxsc7pDWkCHIhJ97y8Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0550/1674] flow_dissector: avoid u16 truncation of skb->len when computing thoff
Date: Sat, 17 Oct 2026 17:47:02 +0200
Message-ID: <20261017160445.213869799@linuxfoundation.org>
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
index 00364d07ff6b1..37864578e8687 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1047,6 +1047,7 @@ bool __skb_flow_dissect(const struct net *net,
 	int mpls_lse = 0;
 	int num_hdrs = 0;
 	u8 ip_proto = 0;
+	u32 thoff;
 	bool ret;
 
 	if (!data) {
@@ -1668,7 +1669,13 @@ bool __skb_flow_dissect(const struct net *net,
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



