Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD02F1922EF;
	Wed,  6 Nov 2024 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897121; cv=none; b=NuafecMMteo4u2NejBedK9vfhBNmrK0dUbCVOjyBNHIr0WHoBoHRpQlvS0a/zqaU01GrJFDRSKj8mL5yCyUHeh1nUC5kJvpC4jexuyg+yo/baG1YIQSI58u4P7x2JQLQjrHo1aSZ185/sVZSfQWDFXvKbHWCmGelkrzwRs7g2ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897121; c=relaxed/simple;
	bh=j0XWWilpk3sgH/cwQiHKlZDVcF8orHqEHQtDXSOSvs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9jWzp4rH9KJU06taMN3g5jg1D+NCjVCnSRuTpFytBXPMwCCJYqPZvBTDGJS1yFn2WYKEJLq+8UHJv3/Gu1SoId0ah90F5Qhw84pBmiZUF40dgIKRhLtpZuDEYQZ7cEzftkI8j5Z89H34paPuDPkYyD+lSFEiGwgBPvC66HW6fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5ZDMLkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5ZDMLkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65887C4CECD;
	Wed,  6 Nov 2024 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897120;
	bh=j0XWWilpk3sgH/cwQiHKlZDVcF8orHqEHQtDXSOSvs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5ZDMLkGQVDtiZeHAr7JQufig+bhnx0Ky5aTv8BK6GfTImpD2Y+W0dBIYvYJqCHJV
	 k0ubfaMN8rKZqEEFYSNwJZo+mTtBxz/HQwLT0aWGBubl3811cgYm5P5MP0Ic65SNxe
	 ZvdfNf4dGkxoqDNMN0/saK1ZePRivqoeITbu88Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin-ayu@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/126] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Wed,  6 Nov 2024 13:03:58 +0100
Message-ID: <20241106120307.112170307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1b001dd2bc9ad..ae3277424b839 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -777,6 +777,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
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



