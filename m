Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23AB471252;
	Tue, 21 Jul 2026 19:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660938; cv=none; b=e8xX1jZm6U3umSd6iY1qro0Hi6sPLeTwa19nenAEnk2fS1GOiTl0Q5/UfSo7YZ+b46PmgeyMZW6VONvAQo7xQ/Rb30gWywd2aruNEeGJ8CBvP/hX+OZA7qaZ8tihrGAmIPieP6QWVxkxUqEV3mahuwUgP+Ofq/LrgX8alLodw4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660938; c=relaxed/simple;
	bh=lfJvCGZGpJ7lXvvauKvMTdwvNH88Bc1ORM65vFZkZZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0LTposGAE68jMnHl2Rj0LAinZbddCKmRV+ZHmsAOC0YcIm8hxcBBnTRE08WUSID+1KdWVxfJrZlVAXMRRA5ukF2NVPy0N0joEKf4zYCpjloWys395RVjHe5VxH1z1IIZhtqQtgpj+qWzLH8UaiBGKG0fSeANzFsSIDDKq416Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HF0us/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HF0us/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232D01F000E9;
	Tue, 21 Jul 2026 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660936;
	bh=mC96A4OIV7VQgtCiaAIsQwON/bYPKwmTOMRNFfmi8/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HF0us/QX52XIRqotjr6lYIPj5E3XSyxE/OBtGxqLBP+NtTHMTjTCngIpI+B2Z/py
	 lDTkMjh3dLiZu52Eyd3U1bbZIDCVXeduIi32hvhM+VYIk9bs/PSvh6qzdq8qT8cOAl
	 jY4yiiGntEGBzrn4rS5aOG5fNq1fMldlXi0prVto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1152/2077] netfilter: nft_flow_offload: zero device address for non-ether case
Date: Tue, 21 Jul 2026 17:13:45 +0200
Message-ID: <20260721152619.996791916@linuxfoundation.org>
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
index a3e6b82f2f8e95..14e8a3e4a6f87f 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -53,8 +53,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
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



