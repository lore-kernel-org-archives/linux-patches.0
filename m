Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F6F510;
	Wed,  5 Feb 2025 14:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764207; cv=none; b=ohtUXZ+Z7otWkS678J10nyYjh/sqE1/tCGe262tZFUdLmH81gz4enxjWSbZG1wx2xbrd18D4/t0peHrAIX1l+Dg8dxT0VZC6NI7JcjLMD/IX0RdEt6PyhxAivtHwsucFxtlkBc2bcWhOccua2ANNB1vYZkm4NEtf59W8lXQf02o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764207; c=relaxed/simple;
	bh=EecEOO7JDUG0i326G63NVdgJGRJ2kj+TirL3azTdglQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1qG30fdXj6nqNQ/woSdKWPaDRt1YdgWafru05iWGm5l3UHuWOUHqxjjanHN0ArtmmH5GycTWj7UuvF7JCXVDE/ihy1n7T2AKyyLlg3Bcay4UUzsqFQsR8zD3J6I+s+bIWijDG/HCxVVgBXoUGSiZ3U4WpJrKA3b8g0DR3BRXdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwJ6dVrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwJ6dVrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFB6C4CED6;
	Wed,  5 Feb 2025 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764206;
	bh=EecEOO7JDUG0i326G63NVdgJGRJ2kj+TirL3azTdglQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwJ6dVrMKgg/WzjQ35deqklHtzIYgZ6iL11kq5JZTgqmhWih4gdphUMCrVb8kr9rN
	 pysXV8gmM7J0CCJz//7/U6sq50z2OariVh2h+sqgw07kboSdqy+nnFRGv/UkaLam28
	 FZl8RHUpnpakpQTYhpMyw7cJYNNeVXRIIl9/j3O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/393] netfilter: nft_flow_offload: update tcp state flags under lock
Date: Wed,  5 Feb 2025 14:41:08 +0100
Message-ID: <20250205134426.004088712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7a4b61406395291ffb7220a10e8951a9a8684819 ]

The conntrack entry is already public, there is a small chance that another
CPU is handling a packet in reply direction and racing with the tcp state
update.

Move this under ct spinlock.

This is done once, when ct is about to be offloaded, so this should
not result in a noticeable performance hit.

Fixes: 8437a6209f76 ("netfilter: nft_flow_offload: set liberal tracking mode for tcp")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 397351fa4d5f8..5a3d685420420 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -288,6 +288,15 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 	return false;
 }
 
+static void flow_offload_ct_tcp(struct nf_conn *ct)
+{
+	/* conntrack will not see all packets, disable tcp window validation. */
+	spin_lock_bh(&ct->lock);
+	ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	spin_unlock_bh(&ct->lock);
+}
+
 static void nft_flow_offload_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -355,11 +364,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto err_flow_alloc;
 
 	flow_offload_route_init(flow, &route);
-
-	if (tcph) {
-		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-	}
+	if (tcph)
+		flow_offload_ct_tcp(ct);
 
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
-- 
2.39.5



