Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66269962;
	Wed, 21 Feb 2024 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525559; cv=none; b=KLLad7zODDbFCK1jIvadtVr/7QWEvUGIPGmjc7CIlJGYNa6RM0nZKXvuJ1/rJbYImdKT7G1wT2RE5wm/k13tEI2qnj9dGJNB2kv9kbP8UAaQgmD28c5NwqwWpIAy8pqzLZNrdCV978ZO6SWSjmqROkSDnqKzLi5A661c1MjzujQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525559; c=relaxed/simple;
	bh=kV6L4zFPo6ftjJpC3XNtjgw/OmyUatiZP7c3S6WaoIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6H44QCT/j/lJNFVkxXyzXr5t1iBqYbQCqEqHWm2fdixDMYBHnPWHLBedmahDA6GWt/sEUbutqMtAqJ3EH0+rJBjrywCu/Ig2KIWd5fj0p/1bZOIkA8m+12Yg6CK9OCECUuryYoUteTAEDAZ0J2RINmw+h8AWZ3t1WEp9XPQ98g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+ZpcQkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+ZpcQkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2186BC433C7;
	Wed, 21 Feb 2024 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525559;
	bh=kV6L4zFPo6ftjJpC3XNtjgw/OmyUatiZP7c3S6WaoIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+ZpcQkNSO62gsnCNxBLwTCW1Jcvd38WRyZMAoD+ggC/BONrk478YA7cykhfLKEGw
	 EnktE4xRft/1WmvYkJPrLc3g1Qkcj0jKQYe6GsND7jZYukwHnK4Qcge01qzmjzyNLU
	 CbERVGGFpB9JHVjy5ZTCPWzigLa/VF9CgGGIY2Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/267] netfilter: nft_compat: restrict match/target protocol to u16
Date: Wed, 21 Feb 2024 14:08:53 +0100
Message-ID: <20240221125946.162703338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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
index 44583da6ec6b..2372f0bbb133 100644
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



