Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211584;
	b=2daTCYk1fVBDp5bCeoK1T1RUnRg4Ergwt0P0r9QfPcdfwsWiRkhGORsv6svnSdJYux77
	 9Yq7ldEQzDHCkGhwNdOxNkWIL1+HDxS5Rud2vuFsL856WKolLHD0h44wp8PdVWPY2LY2Z
	 WmVJ1Pvr0Ndb/1Yz5xFzWTG4xo/WcL+eUnGPuUbSXXaARKhsQ8iC7r6lWmESwhZd9R661
	 cC67J9EKxnylM64uq+LnMuSj3I814YvZnbr370+HXGZyXBi3G2uhb3MAMMltkh5en+TOV
	 7mAUr+jUg4XaXNezBkqwmUHA6IzulZFeCg7n1Q4meuKBvF9elQupJfyLHuB6qBxAnZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z9ZPl95TAwz4KzOofIJEvvF9MSFan7c+fhKn4+tIRw8=;
	b=NvHUwa9DCGu3aPIK49hsYwzWeeT6ESn8PKIUeOhMbT30ppr0EKUPnMo2M9VG4S6hqRKB
	 pp+1nCCNWW1hdkWnvJJi2s9oPxRDUymfUh/oYGgFw3YFcSeAes4Aicm+3iV5Eimx1PS3l
	 VGIrA3S4UNrOZfxX5OzzkvqQXw39IGrFPTvII8Pi/gIdDAIGj9L7MfKcuwwTjNwKm0NzB
	 tj29ziTObFF8nDfclfiWzfn8LkH2peJ+5r4Z1oPTRsFYoNnZGXFoCh+90xOxxUVsBL6aS
	 qa4c9cSmlsZm+F7VNHfn9/MsK90VYCquOq6Raj4A8O82UhrD7zBvhdllXdiY7qAYkOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E51s9fQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C88606A31A;
	Wed, 28 Oct 2026 18:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E51s9fQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C3C1F01825;
	Wed, 28 Oct 2026 18:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211584;
	bh=Z9ZPl95TAwz4KzOofIJEvvF9MSFan7c+fhKn4+tIRw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E51s9fQLIhTEDHbKPTw599odlJDAOUtaJeQ70P4/dvxC4435j/KVb2eOf3OHo3lyY
	 N/34rSWFdX7xFhHkJpGm8Vh2AQqlotTfl/PNtI+eLSuDFUwixPtbfcB0GxEnt2RsW2
	 Hurm8ar+RnIU6k+kTam9VGQCOz+9OwrXjKVXNN3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/571] netfilter: nf_tables: fix bidirectional offload regression
Date: Wed, 28 Oct 2026 17:59:37 +0100
Message-ID: <20261028170018.221943868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 84443741faab9045d53f022a9ac6a6633067a481 ]

Commit 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
made unidirectional flow offload possible, while completely ignoring (and
breaking) bidirectional flow offload for nftables.
Add the missing flag that was left out as an exercise for the reader :)

Cc: Vlad Buslov <vladbu@nvidia.com>
Fixes: 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f1c6442e7d601..9101971dfb2b4 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -351,6 +351,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
+	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.53.0



