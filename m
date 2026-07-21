Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800ED3E49C8;
	Tue, 21 Jul 2026 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654196; cv=none; b=iFwF/bbvPHswWNv3wVCR6NxnLuoDb/y30QBovLm2Kd1RSfhDfZgF5/VHU8YToDji0aHoF+Sig2hRTYoUbOxsd8OCnD+K4wbwYds5kC8aOie6gEdAQ5j+R4wH+vZOL10gPTBCJBT08HnN7pJosTAR2RMG/9abJXczU3H0/rsmZcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654196; c=relaxed/simple;
	bh=ltRoHoLZRa5dCO/xAhqrgcVONfHn/V7tLZJ+cZjxqhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUY/meSd0tQ/uOTrc/W8wz+y1D0L4Q6Dhf735VAuON3bXHyjCisS6b7Xp9qkGODPXNbHFbNjsu+BQO5lYHfKfY+Dg8Tv9qJNo6amCiXqwkMSrAIQO8odTEFaaKqsqiKaDREjX9sEQlcnfsB+jp+NP17Ti7N33C0bDVc/D5hMs4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0rMnTfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0rMnTfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAA21F000E9;
	Tue, 21 Jul 2026 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654195;
	bh=U9T8UWo240Jc9iKUUjwkg9kccm/4Qo8IFgHiC5zJsyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0rMnTfb3pHaTysYMpK2QSiCmhzZQLDfLLbYlSWF3jvL3Tmmz+GmOmJKFne6ISAX2
	 XPdIkj6sfNyLZnsFjzPx02teaK/ntd7yiZy1G0meyOZjeiv1kdgW4l6G5W/OZX9noS
	 F3JEGfbLm06VmKDlQW4EQriFHUFDoJ50xg8TgDuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengyang Chen <chzhengyang2023@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1611/2077] netfilter: flowtable: support IPIP tunnel with direct xmit
Date: Tue, 21 Jul 2026 17:21:24 +0200
Message-ID: <20260721152630.763233994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit fa7395c02d95e51bad2952325d2d6503bfbad437 upstream.

The combination of IPIP tunnel with direct xmit, eg. bridge device,
breaks because no dst_entry is provided to check the skb headroom and to
set the iph->frag_off field. This leads to invalid dst usage and can
trigger a crash in the tunnel transmit path.

Fix this by moving dst_cache and dst_cookie out of the runtime union so
that they can be shared by neighbour, xfrm, and direct tunnel flows.
For FLOW_OFFLOAD_XMIT_DIRECT tuples carrying tunnel metadata, preserve
route state in these shared fields and release it through the common
dst release path.

Since dst_entry is now available to the three supported xmit modes and
dst_release() already deals with NULL dst, remove the xmit type check
in nft_flow_dst_release(). Moreover, skip the check if the dst entry
is NULL in nf_flow_dst_check() which is now the case for the direct
xmit case.

Based on patch from Rein Wei <n05ec@lzu.edu.cn>.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_flow_table.h |    5 +++--
 net/netfilter/nf_flow_table_core.c    |   12 ++++++++----
 net/netfilter/nf_flow_table_ip.c      |    3 +--
 3 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -155,11 +155,12 @@ struct flow_offload_tuple {
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
+	u32				dst_cookie;
+	struct dst_entry		*dst_cache;
+
 	union {
 		struct {
-			struct dst_entry *dst_cache;
 			u32		ifidx;
-			u32		dst_cookie;
 		};
 		struct {
 			u32		ifidx;
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,12 +127,18 @@ static int flow_offload_fill_route(struc
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		if (flow_tuple->tun_num) {
+			flow_tuple->dst_cache = dst;
+			flow_tuple->dst_cookie =
+				flow_offload_dst_cookie(flow_tuple);
+		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		dst_release(dst);
+		if (!flow_tuple->tun_num)
+			dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
@@ -152,9 +158,7 @@ static int flow_offload_fill_route(struc
 static void nft_flow_dst_release(struct flow_offload *flow,
 				 enum flow_offload_tuple_dir dir)
 {
-	if (flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)
-		dst_release(flow->tuplehash[dir].tuple.dst_cache);
+	dst_release(flow->tuplehash[dir].tuple.dst_cache);
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -299,8 +299,7 @@ static bool nf_flow_exceeds_mtu(const st
 
 static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
 {
-	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
-	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
+	if (!tuple->dst_cache)
 		return true;
 
 	return dst_check(tuple->dst_cache, tuple->dst_cookie);


