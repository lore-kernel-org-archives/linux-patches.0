Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C322E1CCB5F;
	Wed,  6 Nov 2024 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899183; cv=none; b=tkzvEvBM9Ho44AwX3H3KmlrPSxKaUJoYBPB7JI8zMLODrrADDs4QfAxMYfU1eUcKn9W8FO2gTkw5u9kPyB38sURdNW/R/3TTTMb+AreUZD8nKCpXW+041Ec/0gJDgGX9kaA8FDQ/oswQ0tTDDsOAHxDGTUeGoYX/jzgRzEYu954=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899183; c=relaxed/simple;
	bh=6ISEkHdkZMWRGz4q8aF1a6aDlVt46VLcIEGPk6r8n4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W37BeZatDJxva8xIsgRV4d5O0E4bQMul5/h9UXrsHfW3t31qXFQQZqmdlUA+JvtEFm+JHakJ8HpHFquC6Oa0Ny5EFwWeJOvBFf1IVezPvrVNh9GRlHrkxOX6WfHgVetB1vjVfOrlKORbNwizjZNO5AVKnDlSOFoNGQsklWuYa40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzHAzNJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzHAzNJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45487C4CECD;
	Wed,  6 Nov 2024 13:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899183;
	bh=6ISEkHdkZMWRGz4q8aF1a6aDlVt46VLcIEGPk6r8n4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzHAzNJjmy5Q9B/WwEBa2IJ90Y9GIdsV2rngmU1YrHDczhGvTNN0Ybk1uSg9DIxAQ
	 dnDW/QsMWb1JH0wJXuyr7/Kl4ndIqTxfAZd+gWCMdRCfp2xDBkh9H9FnlKYI6UQXME
	 3pdM0DBeCvP64Bou0i+/pGlPwYiq3dtrGZ81mjTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin-ayu@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/73] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Wed,  6 Nov 2024 13:05:31 +0100
Message-ID: <20241106120300.776266927@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 55237d8a3d882..49a1cf53064fe 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -749,6 +749,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
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



