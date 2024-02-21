Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EEB73161;
	Wed, 21 Feb 2024 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523029; cv=none; b=kg5MU0wFYG7me4Fi1euZyBOxNvpMdAymBBdaIyN7ib4sXQuQbhRe7OS0B+P38tGOI8VMiMSPRl6Vu8Vf1MOGPRbHlqWk6Sbo5cRh9khimxc5pH3+8Y47mwno+BoF6ugH2RCOrvPN1Opfu01WT1qLV6eowLNtTYg4D2hiY0TDnz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523029; c=relaxed/simple;
	bh=Y3KJKnCSWR6dF2p/gREpLpBPT+u1xqDM9r1Br/J7nwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqOGp//eIVtSsQCVvtUepMttrHCrUxEOffU1djakEj5KdiJYb2y3K6rvXJjSXfyqzg0Z1QzuXRmAx1bKL+Kfbhd+iDk0z+nRqOumlBfr7rNmsj5B6gwnOD5hFXye11GCBasJNSKngJymz8gv5Z/k6BZAk0m9L0lQgjurTSVE6PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr3bPIk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr3bPIk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C75C43390;
	Wed, 21 Feb 2024 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523029;
	bh=Y3KJKnCSWR6dF2p/gREpLpBPT+u1xqDM9r1Br/J7nwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yr3bPIk7NIHU7ttgy5N0FMQ3NEAK9viCQ3UdAP1Wz4N5AKQ+FXsIQDVHWQMzDrGUZ
	 Zx1PsqKxjj13YL8Q+7ilECsRYiZfJ6Bu2bC46FeNz2y+Pyd4B69RtDoOS/4dr+57hC
	 sHyqsNvS/Z9uvjY84NrmkIu/+xLX/nhDv0PMnK+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/476] netfilter: nft_compat: restrict match/target protocol to u16
Date: Wed, 21 Feb 2024 14:06:10 +0100
Message-ID: <20240221130019.806418139@linuxfoundation.org>
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
index 4ef664a2bbe6..64a2a5f19589 100644
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



