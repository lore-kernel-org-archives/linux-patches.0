Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6188D1DF740;
	Wed,  6 Nov 2024 12:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895783; cv=none; b=uQZekBmgvqFN1VvssV3chWmsurz49ofaKp3KOLZjdDoZ7Ac+JnTaxgW6wBc5VSBOIHQ5HWodlJep6tcdoN4TTLceurHmKe8n9sKGYORbxjd9iRSL/NLhkx+Ei0G4/aA3ZsS8MV5xPcZl6t/80DFJuikUMio/JTiFebfmqul8jF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895783; c=relaxed/simple;
	bh=n83JAOG2MJo+YCCI4CFxVTgwN5QUaoLZgYRRA3U3wpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGv/9JGBUQFYtOjYuQKWpn8TAh3FM5jozyT+d+z+jMcWAUHXOPX06ivlJ73fYfBEMhQVoZ5jLoKBlzLY+sSdbAFQCbYkWNx4FxQxtA/t209ICtHX7jSyikgie2AYCT/c3iOQgBiPPqJxCJHJpgBGU3vDvaY4JwEz1/jRwst4AOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkWCzdSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkWCzdSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB93C4CECD;
	Wed,  6 Nov 2024 12:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895783;
	bh=n83JAOG2MJo+YCCI4CFxVTgwN5QUaoLZgYRRA3U3wpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkWCzdSomw7eR2ge6ISaQF+qvpx/1wrOm8DzNK2EsYg4Lh2bk99NiDNe/Hlm37OEL
	 gFOAUh4NFMJgApEca2+PuSeetFDt60F3VRMl7EOIiqrqZ9DxNPiqy7DJwEjRgdAxQe
	 ZV33fdSYNTvpjuhd967tXVM7V4wLB/jEaF/Dh6qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin-ayu@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 335/350] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Wed,  6 Nov 2024 13:04:23 +0100
Message-ID: <20241106120328.988060978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d5953d680f7e96208c29ce4139a0e38de87a57fe ]

If access to offset + length is larger than the skbuff length, then
skb_checksum() triggers BUG_ON().

skb_checksum() internally subtracts the length parameter while iterating
over skbuff, BUG_ON(len) at the end of it checks that the expected
length to be included in the checksum calculation is fully consumed.

Fixes: 7ec3f7b47b8d ("netfilter: nft_payload: add packet mangling support")
Reported-by: Slavin Liu <slavin-ayu@qq.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0ef51c81ec94c..128195a7ea5ed 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -306,6 +306,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	if ((priv->csum_type == NFT_PAYLOAD_CSUM_INET || priv->csum_flags) &&
 	    (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER ||
 	     skb->ip_summed != CHECKSUM_PARTIAL)) {
+		if (offset + priv->len > skb->len)
+			goto err;
+
 		fsum = skb_checksum(skb, offset, priv->len, 0);
 		tsum = csum_partial(src, priv->len, 0);
 
-- 
2.43.0



