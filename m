Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA19D1E4B2;
	Wed, 21 Feb 2024 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522891; cv=none; b=eXPa/Dx6kwAHP91Hbw4UfI1rcdNE7cLowAEgQmXUTjou7gtW2mqMduzjyWNc8rs3UMylyZ1ZZjMj7Dtk4C7M7aJQ0/Nvw4iBh/ZMHaz4zWv23HC2uUDJSHCT2MczHPFt9bHpl7iQcOL2omKBtX2u+Mnv6hZxsPf7Cu3hIy7e8Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522891; c=relaxed/simple;
	bh=QZyDI4N+xayeVGIl2RspAAUEDnW+idmOJebXDKslffE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0KENEmHd/aNihtOehHMN+0ggtPidD/wkWiunCMUh21NA5SIu1qn7OgXm+liIGyCaeT6IIuvWwMbDewIH372i1AGb5pho7jfYgSg4+3ytj2aiBWecQGSXq9N5T+glUb3yULKA+9vxixc5iFuMQEF4J5svOxmdikYkfS719opF98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=padQxG4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="padQxG4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DDEC433C7;
	Wed, 21 Feb 2024 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522891;
	bh=QZyDI4N+xayeVGIl2RspAAUEDnW+idmOJebXDKslffE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=padQxG4IZtF4MW/o0r+12CiuzaeUNAMPgzMSgf997MT2LoV6ucf/MHFIWa8Q6U3R6
	 bPkgu/g+aEbrdFBPKDiAHKsdzYXpDam/QAfBBRsmAjKAQ+iGUV1OtDT0ujynxzrh7M
	 N5FLi12OAGlg54Ft769bB7KAkL/lEsQfXlpLiJ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/476] netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations
Date: Wed, 21 Feb 2024 14:05:36 +0100
Message-ID: <20240221130018.531271767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index bd468e955a21..d8fd7e487e47 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1186,7 +1186,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
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



