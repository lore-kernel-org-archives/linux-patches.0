Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0327D152E1C;
	Mon, 28 Oct 2024 06:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096941; cv=none; b=JHWvkoGh9jXUNJValkT/3nCQ+Yqh43xY33T9Tvhlc8Ov66/jyyHIOfPGhoxHpOKZVJoAHp/6mAgQp0/4UGdL5z0xdqzSKHuvi7iDeootP53aIH5yKeWIaksjqF7Fa5teMownwjUr48KhmYN6woAHj1lpfoIahYgSHZqEPbnnux8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096941; c=relaxed/simple;
	bh=KsbuDAzOZtpg02NxI2rTkfAh+sTpX/6SVVJu0neNVMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFuutppvEz0v52xS3PC6FCPIb+IR6qlLTSHaxAyQGYf9IlBGzlGPoKgUNUquEoXBXA5k6o6r2a2r0JNdRT3ivwMtI0jukBFqD4IzVjKkq4fGlb8SOqR3QVQWeG7suUwwymwx1L2r2QRcZRSBH4wj2H2zc8MQYhL0MIrGY57Y57Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCnIcUJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCnIcUJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948B8C4CEC3;
	Mon, 28 Oct 2024 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096940;
	bh=KsbuDAzOZtpg02NxI2rTkfAh+sTpX/6SVVJu0neNVMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCnIcUJhuWKpzN8prSrmnr13wacv2VV2LjigH1ZxvoB5sPKrI+M3sjjCBI5tete61
	 nf9nlTiQot8JI6ZDrJUNe3BpFvYwJWB4BcuMg1vED1bdPwoSneybpfqTRX1F9qzLEv
	 VtHS8EfrZeWxe0NfoVCjLM5CScyYtCkVzI3Zp+F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/80] xfrm: respect ip protocols rules criteria when performing dst lookups
Date: Mon, 28 Oct 2024 07:25:33 +0100
Message-ID: <20241028062254.090639733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit b8469721034300bbb6dec5b4bf32492c95e16a0c ]

The series in the "fixes" tag added the ability to consider L4 attributes
in routing rules.

The dst lookup on the outer packet of encapsulated traffic in the xfrm
code was not adapted to this change, thus routing behavior that relies
on L4 information is not respected.

Pass the ip protocol information when performing dst lookups.

Fixes: a25724b05af0 ("Merge branch 'fib_rules-support-sport-dport-and-proto-match'")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Tested-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h      |  2 ++
 net/ipv4/xfrm4_policy.c |  2 ++
 net/ipv6/xfrm6_policy.c |  3 +++
 net/xfrm/xfrm_policy.c  | 15 +++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 642e0b60130d8..20ce2e1b3f61e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -322,6 +322,8 @@ struct xfrm_dst_lookup_params {
 	xfrm_address_t *saddr;
 	xfrm_address_t *daddr;
 	u32 mark;
+	__u8 ipproto;
+	union flowi_uli uli;
 };
 
 struct net_device;
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index d1c2619e03740..5d8e38f4ecc07 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -30,6 +30,8 @@ static struct dst_entry *__xfrm4_dst_lookup(struct flowi4 *fl4,
 	fl4->flowi4_mark = params->mark;
 	if (params->saddr)
 		fl4->saddr = params->saddr->a4;
+	fl4->flowi4_proto = params->ipproto;
+	fl4->uli = params->uli;
 
 	rt = __ip_route_output_key(params->net, fl4);
 	if (!IS_ERR(rt))
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 40183fdf7da0e..f5ef5e4c88df1 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -37,6 +37,9 @@ static struct dst_entry *xfrm6_dst_lookup(const struct xfrm_dst_lookup_params *p
 	if (params->saddr)
 		memcpy(&fl6.saddr, params->saddr, sizeof(fl6.saddr));
 
+	fl6.flowi4_proto = params->ipproto;
+	fl6.uli = params->uli;
+
 	dst = ip6_route_output(params->net, NULL, &fl6);
 
 	err = dst->error;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ab6f5955aa9cf..55ef8e8329243 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -296,6 +296,21 @@ static inline struct dst_entry *xfrm_dst_lookup(struct xfrm_state *x,
 	params.tos = tos;
 	params.oif = oif;
 	params.mark = mark;
+	params.ipproto = x->id.proto;
+	if (x->encap) {
+		switch (x->encap->encap_type) {
+		case UDP_ENCAP_ESPINUDP:
+			params.ipproto = IPPROTO_UDP;
+			params.uli.ports.sport = x->encap->encap_sport;
+			params.uli.ports.dport = x->encap->encap_dport;
+			break;
+		case TCP_ENCAP_ESPINTCP:
+			params.ipproto = IPPROTO_TCP;
+			params.uli.ports.sport = x->encap->encap_sport;
+			params.uli.ports.dport = x->encap->encap_dport;
+			break;
+		}
+	}
 
 	dst = __xfrm_dst_lookup(family, &params);
 
-- 
2.43.0



