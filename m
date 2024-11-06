Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9352E1DFDB1;
	Wed,  6 Nov 2024 12:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895995; cv=none; b=V1fNtscwewWL8euFm6bfA//ZjMDDeuVMGbt1BZDJLW8g5MTcwBuMSUEAUr9VZt493aBjTkiS6T1Kr2xaYYYayAaIeYubdL3R96AqJflrZ9RGOkyidDM8oJ7gv8BlXHpfB07dIv1bMpcYhkRqq3Uw9Yugxccs/kTxnLhVfO76zMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895995; c=relaxed/simple;
	bh=8Xx0bz5aGTG9cykFWC4B62DQHTRD/H2hNwNoiG1xDgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGGg5Qm0JpKzCTXsG2H9LgL82D/NPkhK90xHYt0CplDtrhweO3cb8mOK95lqQl6baiQrS3h6XX1wGrxJmAuRwUNkzVLkICyyTl2VwJhNd4foQa+ig/B30kYz2JoNgd5/VRLVO22BVty/TYHdZVz670jCcNXqPixgqsQ/ijJGxck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8UL9YwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8UL9YwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BF4C4CECD;
	Wed,  6 Nov 2024 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895995;
	bh=8Xx0bz5aGTG9cykFWC4B62DQHTRD/H2hNwNoiG1xDgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8UL9YwV5AGowInNJ4qo/4nLaGXtu+XpPsLbUI3np6V+DaK6vw2Hkjak2X3ltthMC
	 5eRQF2NHOJBOUbxFX6W89hJ8kJL6PaxDm0xrovWGY5NcgJTOejcwOSIrX24wO5zjlp
	 xHTENT10LjqEX1rIA+RK27LaciStSuo/IGOc50CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin-ayu@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 055/245] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Wed,  6 Nov 2024 13:01:48 +0100
Message-ID: <20241106120320.570177488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 50429cbd42da4..2db38c06bedeb 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -904,6 +904,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	    ((priv->base != NFT_PAYLOAD_TRANSPORT_HEADER &&
 	      priv->base != NFT_PAYLOAD_INNER_HEADER) ||
 	     skb->ip_summed != CHECKSUM_PARTIAL)) {
+		if (offset + priv->len > skb->len)
+			goto err;
+
 		fsum = skb_checksum(skb, offset, priv->len, 0);
 		tsum = csum_partial(src, priv->len, 0);
 
-- 
2.43.0



