Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2C604C6;
	Tue, 13 Feb 2024 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845902; cv=none; b=ruhcnaFX8ReHdyeBemYMVICpgbDJ7tyjmGZsX5xOSSObsm716Oi6tYza+QwlvX5RnMDFvkc6JCKdglCETEweljl+b/mQeBI1jYkn92IfwpV8r9DGEfRgwLcy+wJVSXs7aiYGgfpNR7o+MvNDwdo2qZFS+DFlGbslfUczESQ9cEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845902; c=relaxed/simple;
	bh=RSocL0YsfRu9ekn6CdXfQvucoEA2zpXmmg9CXiYf6yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvK+G/B4KZaXwYiYeod2ejoDSUmR2c8hLr6PWSv531bkbp4o7X/fqL3FFGIb/NgUcAHRprT0SFGlRrktJPBjY3vC+WS9Pw+tKrTIrb+G6ApIpXzumjl92gMPc7pNncmG32bpSPViJkWKQ/yX3DA5UCp+zBGl+0ipBXJPSjnvBPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+AWTYbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+AWTYbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0969AC43399;
	Tue, 13 Feb 2024 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845901;
	bh=RSocL0YsfRu9ekn6CdXfQvucoEA2zpXmmg9CXiYf6yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+AWTYbQdyoU2+lU9adKMvOSgnR10Y/cQw9JfuWhAIRCyqlzqJKtbx2gvHeKNwntM
	 ltdRILboc3nVmz6FZbAtFtKkcTeMdAQqXLgyuK/UqZ0cZqjzmWWH+7Ak1uSYzvyQms
	 Q27ty3QRkXc2dSuIz1wkJnQ/WQCPndDJTYnqsNMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 061/124] netfilter: nft_compat: restrict match/target protocol to u16
Date: Tue, 13 Feb 2024 18:21:23 +0100
Message-ID: <20240213171855.519828603@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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
index ed71d5ecbe0a..1f9474fefe84 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -200,6 +200,7 @@ static const struct nla_policy nft_rule_compat_policy[NFTA_RULE_COMPAT_MAX + 1]
 static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 {
 	struct nlattr *tb[NFTA_RULE_COMPAT_MAX+1];
+	u32 l4proto;
 	u32 flags;
 	int err;
 
@@ -218,7 +219,12 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
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



