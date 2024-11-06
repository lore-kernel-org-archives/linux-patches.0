Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FA71DED63;
	Wed,  6 Nov 2024 13:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899038; cv=none; b=Y15AIexs7BmbCqmOmas/WElVSZlN+N3/uEYLCP5jU9LvS9AmM3WpmW8K+2N6LLc1R5GB+ZnjblOSkUc0ZPMsYpOHNKVvNBZsWSKaV4sluqOWm9dmpoyGN/Ycy5qMYYOoNayjDVtqze8+/tuLLaNNij65T5PcnG6gQUEfUPXF/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899038; c=relaxed/simple;
	bh=n9yt6dsnqTctP1RY5YNp/K+Uk5rbIBMF666gGtG7nM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBLHF2PK6+QXA6Hl9z2PCaauFC6lQ7zGga3N0VIZdY07yOLpxB4UkLx7AZv2uA71vNfCQyZRiOHi+uGFDSuMnIU3HTJ7SUuUFa3fbw1UXnUgs5k8tPdWylcYS7JXRnQxxOTveVoBZubDpU501TTulc3Z51TCrEL8hpM7iW/dX6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wHvc+aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wHvc+aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BDBC4CED7;
	Wed,  6 Nov 2024 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899038;
	bh=n9yt6dsnqTctP1RY5YNp/K+Uk5rbIBMF666gGtG7nM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wHvc+aUyWRBkk9ddBMoEOFLI/u0R9kstsuJI2lQCGUDFFnEHiGylpbRPIEaNq6Vt
	 wpDTpZM44cjaBMkvaI9ZydnuIK7DkcUQW+T3J2d9ILVfipeBIXc/Jk9iY66vxyaqZI
	 +/cP6RJN/PEPjYRsEl8zM+SuvWROoKLR64WM2Iu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin-ayu@qq.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 441/462] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
Date: Wed,  6 Nov 2024 13:05:34 +0100
Message-ID: <20241106120342.393784134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a4f9a150812a3..e40948b508588 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -532,6 +532,9 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
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



