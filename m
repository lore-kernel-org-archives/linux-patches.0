Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3103478B4B;
	Wed, 21 Feb 2024 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524507; cv=none; b=XmYhi4tujHES6sgnCNOvLsrDA0HFMXs7Wfuh1L0/zQI4EbB7cGmGHHqiGyt+TfNvGz77kLbqjDSGh/nwAYXkmkZ//TfZ+9f74Zgo7lmJV1rB0ytsHmI6P8PtxGUD7ePCoPpZQ1xnYrNc/qSv6NR+o5zrd3PxwefRJtpyNO78AEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524507; c=relaxed/simple;
	bh=7LWXAh/TF6gz8DT7VWGAVxpjsEI2nP8EHWfFuViOJxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxPeFau8Ew+qXr7wCggff4rs7LYMntpj+TajjsMWLN8m8b4bJJXqE34QZKKV4E6hXhc5s6Bq67J5fqDEj6qKBk1iTyyxiSCYrStRKKbLtNNUKK7h7M/EsX45Lh9JcYSdNmT3n/x7Y0a5va6ia00BvzXVlx7APLaVhIdulcjrKvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm9mLf0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm9mLf0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B343C433F1;
	Wed, 21 Feb 2024 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524507;
	bh=7LWXAh/TF6gz8DT7VWGAVxpjsEI2nP8EHWfFuViOJxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm9mLf0eoYp6NsQDsuhXAnTvWhP4NBSc3CtFqJF1zFfrMG/FSSA3mYHF5VAfKaer6
	 JXPMAVlM4aqR6y7j60iCD0Zf9mGwDvcH1Shhi8kunP/DPBJlWT9eMZO4/x78m0++wW
	 D+EMoc2+RzcilDEsEKNfNbf/X2xi/BEStM/yqGs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/379] netfilter: nft_compat: restrict match/target protocol to u16
Date: Wed, 21 Feb 2024 14:07:25 +0100
Message-ID: <20240221130002.780859993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

[ Upstream commit d694b754894c93fb4d71a7f3699439dec111decc ]

xt_check_{match,target} expects u16, but NFTA_RULE_COMPAT_PROTO is u32.

NLA_POLICY_MAX(NLA_BE32, 65535) cannot be used because .max in
nla_policy is s16, see 3e48be05f3c7 ("netlink: add attribute range
validation to policy").

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 025f5189f2ce..77c7362a7db8 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -192,6 +192,7 @@ static const struct nla_policy nft_rule_compat_policy[NFTA_RULE_COMPAT_MAX + 1]
 static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 {
 	struct nlattr *tb[NFTA_RULE_COMPAT_MAX+1];
+	u32 l4proto;
 	u32 flags;
 	int err;
 
@@ -210,7 +211,12 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	if (flags & NFT_RULE_COMPAT_F_INV)
 		*inv = true;
 
-	*proto = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+	l4proto = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+	if (l4proto > U16_MAX)
+		return -EINVAL;
+
+	*proto = l4proto;
+
 	return 0;
 }
 
-- 
2.43.0



