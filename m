Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD8614B959;
	Wed,  5 Feb 2025 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765545; cv=none; b=K0zVKhU1vhzBINk1d9BJ5AmMsYV1/XbH6+r2NW1a1QGIOdQjYRaLaDMHRa2Y6jTpVrcFxepl0Va7kZlz9hpcC9RCv2nV6TtSFy/2yvBlfTXgn6CyAVL6Apcx2Qb39yNoS/UcE6U+r7cuqe3tNfh2AhyCX8nu3BNViM5orfykw6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765545; c=relaxed/simple;
	bh=pufWx3gwtEmd3TIM9ILS5TIGIZ8s+TObGPwpKGDo/Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIQ92IXLaGLeVRB3qgTAf5yLoHbJ63Dycre0UVMVEMzbosNvJgPSZplgSP0mNALwoKWB74YqmNtcaEX2990NQFZ2V/+PzKiQQ9VstY6wZHMQ6el+u1pFOot/JbNiTX7C9ddf301niqHD+SLLAxH2Nt/khtE/2bhfE6/LNfYGSb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki442TSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki442TSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7104BC4CEDD;
	Wed,  5 Feb 2025 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765544;
	bh=pufWx3gwtEmd3TIM9ILS5TIGIZ8s+TObGPwpKGDo/Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki442TSzQ591hzzlsx57C8dOtgIYhXkPZ9CKzllJo3tz/XNagGDvjkYehWyqG6Fv6
	 kGJFEOGsjXkg2RgSRN8AHSK/KrQ4lmWJvbhCko2pSjL+wSYTJJbk3vYMtBq1SSJje+
	 c+aeddV9ieXL4a53DEUUjewm0OMa9dY6zVrIyofo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/590] netfilter: nft_flow_offload: update tcp state flags under lock
Date: Wed,  5 Feb 2025 14:39:44 +0100
Message-ID: <20250205134504.042811222@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f732fae5a831..da9ebd00b1989 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -289,6 +289,15 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
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
@@ -356,11 +365,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto err_flow_alloc;
 
 	flow_offload_route_init(flow, &route);
-
-	if (tcph) {
-		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-	}
+	if (tcph)
+		flow_offload_ct_tcp(ct);
 
 	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
-- 
2.39.5



