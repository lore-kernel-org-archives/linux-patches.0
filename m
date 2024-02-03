Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F11107B4;
	Sat,  3 Feb 2024 04:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933959; cv=none; b=bhQ37rqtxLOoDguzsJMKDB7p3qc/hGmSgzLn6OtO88BlC7QJce1SVQpHlUUEKiKtxsUxg3+9o7izWIWaF4h6+mR2Bz5Jim9Z1H4EH1H1X5jh3Q2+KRZMMtnCc7l5p/j4qgv5Kr+2Bs3TgmaBpTbQ9yDzeqgmr/0tfjsTplztHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933959; c=relaxed/simple;
	bh=fMc5wp5GyuqaXJAKVzaUay0Gf+R0ZQC0rCXowPhD1jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPS3B0YTrfpyMPPJK7IrgKnH+JOgEx89QRbV5QKefPGTY4PJLivUxAQ+0tuF4/VGtiHPbeQdX+qPgG0Dgn9oUwqX2rgxlLRLIIGRVU60/5v5uh7sOeq9vQX6vS2YXUkOrjEBxmOXXZra2AeC1KA1d56gPx8KgmMwuUuDSsKOsaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOaFWPTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOaFWPTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5131FC433C7;
	Sat,  3 Feb 2024 04:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933959;
	bh=fMc5wp5GyuqaXJAKVzaUay0Gf+R0ZQC0rCXowPhD1jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOaFWPTnJvfqs/97t+jyLY29vv6Rjs9cYcM/5ehIab+6Hg4OvP5FQSthWJxi4iNcf
	 f6H/y2xUAxk1B1m7hxRvWYYgilsWUwZX6HWnrnOLghaPrGJyXlG6eS/fILnKNQWCLI
	 kl2biPNBx0bUeXufoy4sMw6WfO9aQgTr2rUkwdIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 328/353] netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations
Date: Fri,  2 Feb 2024 20:07:26 -0800
Message-ID: <20240203035414.179647116@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 86bb9d7797d9..aac98a3c966e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1250,7 +1250,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
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



