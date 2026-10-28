Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209293;
	b=dw7PCgrQld7Ss+d+s+uZMNM9jUetKP3NDx1o/v7zIoMGQUPetUkJy+Z10DlMaloOCkD3
	 Hyn48CYeoW5RniQ2XGXk333uKXE6aKpmTxso949a+WwDzAm7h8L6AC8r0CK3y//efYPIY
	 v6PYEyEKIZtaK2cL4gMYnAW1921ilKEKvyY5KcxQ507q6tl2sT1/26QH/7tNDU3i4lbBN
	 zzdmrz66Qth8gU0i0NKcnI36C+yQIJeD+d+X0MAHyrxmLrIv6iRjETLO/h3TSdM52XHGN
	 GeJ7YlxabW1mGurtIomHIUdImmm4rS6RkAEv7SOl2w8rQnw89hJycY9ih5mVuz5PBdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djTqyRwueCHQlNLEeoxpIrkz3zb95qIRI63lIsfYKCY=;
	b=xlofWTqX9lt27/CI0xQr2xhOdmYEn7g0KajxP6DROZN6D11XfmYxAVzrA1/mF10IOt8r
	 ac88W6UvMY/XyvYivs0K68Edz/lKeWOFfjhVH7Tp6vbONJEQiq15I9Dhngs4Pw9ym59n8
	 /hoadwO2t8ZkIYn66l8EY+pTlwXQ3+vtyy1piQJug/1ki/SYnXtsYUhcGPuzrgsBoZgFe
	 w2NJ8AmApe7zgb21NwbHRavde8ETfu3xExEA7cKrB79Dv3NBApJmCg2ksAmRzhs8e6mpq
	 NzZykRW7lkfBGG2htWY42VBsMeFS3O3SjFg37XMVauSIIVy1xVIFhn93Z17o7cmJhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+UM+GyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E1606A31E;
	Wed, 28 Oct 2026 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+UM+GyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375811F01825;
	Wed, 28 Oct 2026 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209292;
	bh=djTqyRwueCHQlNLEeoxpIrkz3zb95qIRI63lIsfYKCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+UM+GyBbnKM31W3xRdJFJhzejkhQrIRasZZt+P56tpiP5JSpvahdYYqM3vYPFKXo
	 UKaU/LEe5GW84Uf04bkaZV2Nr6+bDLLeOnen/NUjgZmeM00avGzBZMLibFEWjftmFl
	 iXnk0PKdrgVINmmdezXXwZAJsVYn3nMsQnlGve8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 377/516] netfilter: nf_tables: fix bidirectional offload regression
Date: Wed, 28 Oct 2026 17:58:49 +0100
Message-ID: <20261028170012.414812998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index fd3788d655356..570f235f802f8 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -127,6 +127,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
 
+	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.53.0



