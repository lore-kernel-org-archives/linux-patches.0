Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704343;
	b=lbiYmDmbCC/mxOPNKOwRrNnftNWY+m+qqCBtANcecumXL850oX+T5aTGCl0XEMnKeMID
	 TMSHLh2GRqryzhEHQQXlIidfeFMSskl+cegGXOFR6OK4kQGJTNQV2sVbiBDJDorTvwTKK
	 2YSiNjWHvd7X2fzYPSHvRa0o1F3BFFXnabzdwB55ILAPHdTYw57oDQYk+3CIU1mbkMdnN
	 fv/IV+FYbYbTfwqndQmnfVwmFtGvE8asnwQeDNhUbSX3Rxa6xJ22UQmirYhGV1Fmjnu5F
	 c6pqwtZPwfYGflwFSftv3kmr7LpcDGdbfaFnGvvG5BISYXQvtg1TUQIUr0VsX0lQUkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pcTf4sCJLJoDGYmhNNCiVDJR86odqIF+L2R+dpQPKmo=;
	b=ysO97dMun06H8JWync/8Uuvt9HaCIoHB4XPdWHBxA8yGfrJXpC1IdD96R/cVgoKrhGdP
	 ZkwyCSHhCF8xuZrdpIsey3N9NXCSn/MWkd3qvTUKsIEULbICPmZb8bLd3UtXZUuAEf2dL
	 xJ1JHgDi+6sGLJ84M2/U4iSU30QoNh5rsM3vTN5k0Nz/TXauN3JHxWcII9Zd6ICv6erNC
	 SbxlqLAEPDhrbi2DDEiWvv7HXLYETG92X4cJPvHigPuuxw540jmRaB875VPQoUQzJedeb
	 JsaPAzk71CIWIHWDEkoK2+hpVOCr1yGpUOd/cjWh153tVaSrRmVEw9OwzualAz/TaEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bANg03Os;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C449B606A329;
	Thu, 26 Nov 2026 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bANg03Os
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3317E1F000C0;
	Thu, 26 Nov 2026 14:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704343;
	bh=pcTf4sCJLJoDGYmhNNCiVDJR86odqIF+L2R+dpQPKmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bANg03OsNtD246rdWgQ8mbV52mfH0dJ//T9vpTq67F1wwojMD6ld4+ndxRMp5nml6
	 NAcMkIEa7Gl4+2A5OT6mqQCtPbqZ52RYl36aKyXPc0+jwiIUF+UiQIjU7kfUDIklyn
	 ne8kk79sBAP0d+ZRV7QaDoUbjnq+XQVFtB8bvgEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/265] netfilter: nat: zero newrange before filling it in
Date: Thu, 26 Nov 2026 15:36:59 +0100
Message-ID: <20261126143611.257490553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d1bb235aa409a4e5aeba6c748d953d948625b1e9 ]

nf_nat_masquerade_ipv4(), nf_nat_masquerade_ipv6(), netmap_tg4() and
netmap_tg6() each build a stack-local struct nf_nat_range2 from the
caller-supplied range, inheriting range->flags unmodified. Two of them
only memset() the min_addr/max_addr members, the other two don't
memset() anything at all, so newrange.base_proto is left as stack
garbage.

If the inherited flags include NF_NAT_RANGE_PROTO_OFFSET,
nf_nat_l4proto_unique_tuple() reads range->base_proto.all to compute
the NAT port offset. Neither the NETMAP nor the MASQUERADE targets
mask the flags field in their checkentry callback, so this
uninitialized stack value can end up feeding the NAT port selection.

The per-member memset()s are not enough: they have to enumerate every
field that must be cleared, and base_proto was missed when
NF_NAT_RANGE_PROTO_OFFSET/base_proto was added to the struct. memset()
the whole struct instead, so every member is covered regardless of
which ones get explicitly assigned afterwards.

There are other places that miss this, but those hardcode .flags so
nat core won't read from the uninitialized fields.

C99 initializers would be preferrable, but this is a more intrusive
change.  Lets followup in nf-next and convert others as well.

This is an LLM finding.

Fixes: 2eb0f624b709 ("netfilter: add NAT support for shifted portmap ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_masquerade.c | 4 ++--
 net/netfilter/xt_NETMAP.c         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index acd73f717a088..1cd5341ad1ce0 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -61,8 +61,7 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 		nat->masq_index = out->ifindex;
 
 	/* Transfer from original range. */
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip = newsrc;
 	newrange.max_addr.ip = newsrc;
@@ -254,6 +253,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	if (nat)
 		nat->masq_index = out->ifindex;
 
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.in6	= src;
 	newrange.max_addr.in6	= src;
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index cb2ee80d84fa8..591a6af6c61fa 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -42,6 +42,7 @@ netmap_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 				   netmask.ip6[i];
 	}
 
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags	= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr	= new_addr;
 	newrange.max_addr	= new_addr;
@@ -89,8 +90,7 @@ netmap_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 		new_ip = ip_hdr(skb)->saddr & ~netmask;
 	new_ip |= mr->range[0].min_ip & netmask;
 
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags	     = mr->range[0].flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip = new_ip;
 	newrange.max_addr.ip = new_ip;
-- 
2.53.0



