Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C2471253;
	Tue, 21 Jul 2026 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657758; cv=none; b=odHo4VyrzfAwLXQpaMoxeKA8L8/7iEObsTVhx1sZEbeP0rDbgsqUHQdT+zz/ghKbPqcIB+5K2nbfQzQWYi1e8DXi6T3yl+GFavFNimbtM06Dsp6CT82QCWVRGnhDcUmx+i2LEyZuU9bCIzdSfFa/P0bx8oK8WyFRzEM4KgA1DX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657758; c=relaxed/simple;
	bh=Pg9vV+6JkaPmAVmSYRaO+BbqlSLs3xhNWrsBwy2AM/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzQu9BM2TUMikq8fBUm5Y9D/ihOJCCx5Aj3JFfmJNLpvcvHVst/7VlodMkNFw8rRBuYGKZYyBHzVKU/QSidJw/c5S///KgQ+H5+1+2KCTbOY/dgbpvMyt9fsh6va1E+ESlFSJ+9WXptkeZPjXqk3f8xOYkWFqNifRNSj+lleEIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFOKgdAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFOKgdAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C808C1F000E9;
	Tue, 21 Jul 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657757;
	bh=zrQJMqpdHc+t6uQhNVXRhcZxmgNAUMiYvjVxcFTXzL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFOKgdAsayQ/8+LL5AfHOuyDqOjx+9rnI4gzSlKnAhYFaTTJjBTYIwXWX8n2eth8h
	 NKIyn5y9rr2V4a8WtR8iALITD0plRw+isFbhZ1f+jF+FC889/0FZBq5cyMcpOuhgBb
	 oRHnogJgfMBK+vavs5AcNE3wZNZquUOPM7LZldgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0844/1611] netfilter: nft_flow_offload: zero device address for non-ether case
Date: Tue, 21 Jul 2026 17:16:00 +0200
Message-ID: <20260721152534.369280673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e409c23c2d0630f3b95efd12428b2e58800b7645 ]

LLM points out that the skip causes unitialised stack array to
propagate down into dev_fill_forward_path().  Its not clear to me that
there is a guarantee that a later ctx.dev->netdev_ops->ndo_fill_forward_path()
would always fix this up.

Cc: Felix Fietkau <nbd@nbd.name>
Fixes: 45ca3e61999e ("netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_path.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index e525e3745651d8..76d4ff14543986 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -52,8 +52,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	struct neighbour *n;
 	u8 nud_state;
 
-	if (!nft_is_valid_ether_device(dev))
+	if (!nft_is_valid_ether_device(dev)) {
+		eth_zero_addr(ha);
 		goto out;
+	}
 
 	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
-- 
2.53.0



