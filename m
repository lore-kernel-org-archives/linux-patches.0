Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621B201031;
	Wed,  6 Nov 2024 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896800; cv=none; b=UimGw++ZoYquzV02gCB9S16XmovAZ8ja4cLc4SiSxWlurJn7xa6akRCpiiF8Q2qA7w5nTAPEtFkeW531oFCCz7QGVMjACuUXkKiovXv3+1LE6XlbXPpbn4IAUwjESuBlSA2KqDs4v4OXOckb74AggTWyqUUvUv0d6JIySYsXOmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896800; c=relaxed/simple;
	bh=ScG2kMEYtLEdsDxIIPXgUvFkxRQp2dn4H5TDV2uMi4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORlTYQMs+CgNMYFvo+BAYkzLBvyuR2psk/zIM3FbOXri3/PnbkhSDNg7M1xMoMRg+Kg4cHXNm6y89WM1WTkOJAZmG+46V+2kdO8r/dblvTJHxC5cbIQEV4uaFsp+XwMq84cAQ3fvIvbX0idWZRvvtfm53xvqsUeJNOJSrKB5Ud0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dku9qmR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dku9qmR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE2C4CED3;
	Wed,  6 Nov 2024 12:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896800;
	bh=ScG2kMEYtLEdsDxIIPXgUvFkxRQp2dn4H5TDV2uMi4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dku9qmR2mFdx+c6gvcZuRoXtVCbMw3MtNUf0t8MRUsINQSe4KN8BfgakXyLAauAf7
	 wxfiHodYkOnSLmT/tp92IKOotTBtV7tEPHVrxfeVfaQDIpJbpJNDq2bqzMgzWSJXSh
	 vkV1j4TOiuTML36EY71aCAHz/U5b/UkMYsqhpXF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin-ayu@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/110] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Wed,  6 Nov 2024 13:04:43 +0100
Message-ID: <20241106120305.315866897@linuxfoundation.org>
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
index fa64b1b8ae918..f607cd7f203ad 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -618,6 +618,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
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



