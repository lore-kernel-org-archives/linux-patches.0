Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CDF1B6D0A;
	Wed, 19 Feb 2025 09:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956199; cv=none; b=L09RUy3OARVRiEVuQ6NBX2OZBKnPuaDJP7UVlPg7dmq9f9JZr59linGAA267OyqQ51qf5e6YNn+Tj0QAycJVYS+ze1uWe9kQ8vUJDbVUeBTTgFPl+IOUc5HjCH286AlCdadZQYiOjBn/WfJScvMELLyCzI79TAdUX8iYRBae3kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956199; c=relaxed/simple;
	bh=VO3oee+X4aLSuvgZ2TF/90Gm5j4kky+ZN+bhdBNNTAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy9kfQho2MEIRyZwDgXcXDN8gJUIzDWB3WWCu0iBB3JpCpJIGvpALaSDb2LP/S9r7EjZeSk9WAcYmM/zRFrH8jKwMuKX2Do9iLCT8HWi9wg1jcimZBDe7LHi1Kd6pnx/AQwbKIL/q+e9+3Tsyt59N2O2f4HETRNXBsl0BcTdx2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wB8bqQcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wB8bqQcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165F7C4CEE8;
	Wed, 19 Feb 2025 09:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956198;
	bh=VO3oee+X4aLSuvgZ2TF/90Gm5j4kky+ZN+bhdBNNTAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wB8bqQcjRRMHYR1KEVrQSxqMxk6oP9Y9hMCjg6GAFHDKUqc2xG1GPGIQCpFfAgf+c
	 3E8K94IjUdXktk1KPIT3d39B3Pnmv23HQGRL+Fa2zQ7LtnthNhbXs5YksjKV/maEsN
	 IZLeR8ca553aDM3Oi2Tx+6cJMstKpYvLwt/jZadc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/578] netfilter: nft_flow_offload: update tcp state flags under lock
Date: Wed, 19 Feb 2025 09:21:42 +0100
Message-ID: <20250219082656.813126812@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a8707632a815..9d335aa58907d 100644
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



