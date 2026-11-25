Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622670;
	b=UEiv44WTWNPDsPW5vUbhIrn+LxdJwMojuUBW0bF8sF1KmKiO3eHTiVAEBTEdpEGh2EIM
	 T1YEYc35pYRQSnBqWfYOx2zfhenysBe4s446XvkUT7AOyo95vhrxlaC6nNoOzD971WxJ1
	 lmI1Ce3WNJAhy8r1XOtj7N+n7SlvKyPlJCjaWfz8YvW2KPhzMiUtW+V4cYzCzIPbYklwo
	 FjIJ1neyeRV6NxK7dvyEjY9SQK8FVJiOgEmVfWCWRU+BCnbIwX7zXcVrmuhTqn81rdaW9
	 AkIddV7Up5uwAWHSthRVUWuZOumMJf34lc7cfBl838e+wRaFNtSOcYwUuVx70+FxVdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NOYQeVkbuA2NrTLZBdt9H+RyDDSDS50Tclnf+umhYP4=;
	b=P1MBhzyNW5J03zbQ0aQKmPFn1XU3ZdIdP24eAgWO9E92hu7pkgeeUdl3SVfnjNwjs2vT
	 89gE3XIKos0fnaZ4KpTvmuC5znhN8P/16cDOfFj/6UQ3Bj37Q+7FYxXT5N4HOPDjrSzXk
	 i2PYjcOlyer9UL7NgnYOTnwk8rH0D+EFjQHihzVibouasUeObaJPFHHXpNTMvBlnJxoZI
	 LFG1BEW9yZezQMwRZZ+hHaZx1ekAmjLTvBICHEFtGahDpB8IrxdjTMgYfh4Hx3sH1eXCC
	 EpeZHVjDfltADD4wVr2y2ydVwkJQRKt3cwPEUyYJGECJ/rNYqkRZqi6TVFtFjWU3e5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYbuVvRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BF4606A321;
	Wed, 25 Nov 2026 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYbuVvRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE031F000D1;
	Wed, 25 Nov 2026 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622670;
	bh=NOYQeVkbuA2NrTLZBdt9H+RyDDSDS50Tclnf+umhYP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYbuVvRUV+AJJu8coGDGDdWmv2GXV/99MazpZJnvncfOMPGCFJBfsJX0deJmlJ29q
	 r9mr8fkxGBjh3sgmUNFukbFXfPj0kLeL+qUqhH1/ETJ33lqf6hfEcUsMCeJ1DZAGLo
	 iklk9x7PdQttnlB9nXCwkQLsS1Xfkh6nsiDkE3Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 611/990] netfilter: flowtable: reset transport header after nf_flow_encap_pop()
Date: Wed, 25 Nov 2026 15:32:58 +0100
Message-ID: <20261125143836.404230989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 08f7882637f2db5b98f521498eeaf94770383a6e ]

nf_flow_encap_pop() pulls vlan/pppoe or ip tunnel headers and resets the
network header, but leaves the transport header pointing into the removed
outer header. Reset the transport header to the inner L4 header, otherwise
later consumers (e.g. GSO segmentation) parse a bogus header.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ sashal: adjusted nf_flow_encap_pop() call context to the older two-argument form (skb, tuplehash) in the IPv6 hunk, since this tree's helper lacks the ctx parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 041d928b0bee0..aa22d8fd39fc1 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -410,6 +410,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	nf_flow_encap_pop(skb, tuplehash);
 	thoff -= ctx->offset;
+	skb_set_transport_header(skb, thoff);
 
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
@@ -698,6 +699,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
+	skb_set_transport_header(skb, sizeof(*ip6h));
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
-- 
2.53.0



