Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0721B95C;
	Sat,  3 Feb 2024 04:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933480; cv=none; b=EQzYtM7v+kC8GXWU59kz0jLUk+W2ppYL0BD/aAbOiBz2lpDpQtCJrjUTgsihwXzq+rJGoTuhv7AVEg1RWZwn56LZc1jlQCAYCWWncqPkLOzE4xhVT7SVJQ8oSLfRK3qAeTvO1iiyQ4yc7IxNSfYw0xYr0TAiVeW7r8/GEtnlp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933480; c=relaxed/simple;
	bh=NHBehaIsxJG4yIc7kXEt2YMCf7CuVuQ01V95LLDbVho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmYMAkCi2mWiwkAIha/PDnwtnHKLjjFNwKBQ1aArLZmX8xjf1dICRNGMhGoC5rEzWBliWN6505FdpAQIcj6iTvOKaqJUK2sAye1P2jPIm70V4GZUF/JhP61zBpdn4+HNQGEh0j/R+/J7f8xfSLpynqoXn7XL5ZaPzK6nPR/C/OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdJFU8+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdJFU8+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6358C433C7;
	Sat,  3 Feb 2024 04:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933479;
	bh=NHBehaIsxJG4yIc7kXEt2YMCf7CuVuQ01V95LLDbVho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdJFU8+4ZjYBAnQJ360IeoFqxmGFbMWTEQCq2Ujxm6zmQz884wHyGtEFiocbLv9A2
	 eJkDYpyio7GtIpG76x3pKg2wA0Z8ICOqju2Tbkpj5rSZwBj28sYtyqfzeWFqmHsJX8
	 Yboa0e53n7Nkxx5gTp+YopKV70NA/cJTyezyxA/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/219] netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations
Date: Fri,  2 Feb 2024 20:06:19 -0800
Message-ID: <20240203035345.896646263@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

[ Upstream commit 8059918a1377f2f1fff06af4f5a4ed3d5acd6bc4 ]

- Disallow families other than NFPROTO_{IPV4,IPV6,INET}.
- Disallow layer 4 protocol with no ports, since destination port is a
  mandatory attribute for this object.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 641dc21f92b4..1101665f5253 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1231,7 +1231,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_CT_EXPECT_L3PROTO])
 		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
 
+	switch (priv->l3num) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		if (priv->l3num != ctx->family)
+			return -EINVAL;
+
+		fallthrough;
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+	switch (priv->l4proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
 	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
-- 
2.43.0



