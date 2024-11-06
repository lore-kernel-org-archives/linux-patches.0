Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC311F12F9;
	Wed,  6 Nov 2024 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896782; cv=none; b=MAhuTKN3JBQpOIiehQac2EH2gKW/KlTv2oDTDTHeAQBgwDq9S4Uhkmlbfl2gIf2kPx1vee/ssVaVhYpdW9MiZpnHM0Q4SYyovu9gSdOuX9TKKIstVoXoQz2adQSOpl5prA+EWqtSFa08+wYyR+4yMFNrja4NlS8avkWkPsDafUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896782; c=relaxed/simple;
	bh=Xam2e1OuaPDrj2Qm3fzINC17Qob+kmQj+Iqvc+7P+9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWEAQRSyAZzV4UqJ8H0msJcj0l6arjmsvrV4+yoLy/yAjfiPqBcatoqwiFx5G8bPWj8/wmNawb0hEED6vxlcWEaDHkmKWFn3PWfZM94u7GT/aq+CpPsyO30a/s+Yf+2p+YgAW2qr5N1vQ1RoBSn6MqkbeY66KndW0cy0b+blHrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HcvZvM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HcvZvM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C71C4CEDA;
	Wed,  6 Nov 2024 12:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896782;
	bh=Xam2e1OuaPDrj2Qm3fzINC17Qob+kmQj+Iqvc+7P+9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HcvZvM8bJRVXLhIbjE6ikm1yNZQtQXlddXErbdN4cxIqUOyakV0lrysStW4VsM1J
	 7rh36vjcdskzcSxriF5p6S6fPmJ957UExQZOEYVGVEJURYhy1HVjxP6yWsKfvmggPC
	 poVQ6Un80bmvcivqzMtRR/6ZK2S8S+9SO9djXta8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/110] xfrm: respect ip protocols rules criteria when performing dst lookups
Date: Wed,  6 Nov 2024 13:04:00 +0100
Message-ID: <20241106120304.134361448@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 142967e456b18..798df30c2d253 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -328,6 +328,8 @@ struct xfrm_dst_lookup_params {
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
index a7f8da5241ae5..a1a662a55c2ae 100644
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



