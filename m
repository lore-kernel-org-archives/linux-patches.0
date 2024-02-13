Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5347D5F54E;
	Tue, 13 Feb 2024 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845449; cv=none; b=MoRBCkbipgvVgIWtpM7hQcl06A/hFNKxLR6QNwatueSfOG4qXsk6gkeOsaCtNnMw7GB/vw+nsJsNbexIU5VQ7bffZ+M1daA09KvF5sfyPzzeLUFqSNbrQfPT/xhoHlAHAscIe3VsmZbIk+n08bZDuyO+V6S1J0u83uSpzRPFiVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845449; c=relaxed/simple;
	bh=kE98pQ5ztQamhDjpJSMmRqd+HvD0OYpH3DBrpyI6BuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRvXv+ZaS7DSYfgwHxdXAdoQIOUlTIxj3J7x4satHP3FnleKGLRAmOF6UVkqm/l4qFO+R97PsSFDSYKdhyNzL4PbGNMjGQpeeWLxcKrfh9VFAKIpz+XMn8p47Xl019YnxnKQRVjH1qRLg8FtDcDvFzR07k2vyZzTdUtXA4SgcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koHUJR8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koHUJR8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D20C433F1;
	Tue, 13 Feb 2024 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845448;
	bh=kE98pQ5ztQamhDjpJSMmRqd+HvD0OYpH3DBrpyI6BuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koHUJR8Oa8hScFDH4nZvQ1w1XX5i+kvS19sDHxEE5c4Bg3tqOyZ7VZJVZNyr4AMA5
	 uezU52EkrrhDF/tO/EL5t8pJ+YH9qAYnB2rSo2oeZgq7iksxO5gUWOM1YgzoEGItcS
	 tiAQ1Gu3rE2W4nxdpDfZqJxfbD/MfznkmpREZO48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/121] netfilter: nft_compat: narrow down revision to unsigned 8-bits
Date: Tue, 13 Feb 2024 18:21:23 +0100
Message-ID: <20240213171855.153704032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 36fa8d697132b4bed2312d700310e8a78b000c84 ]

xt_find_revision() expects u8, restrict it to this datatype.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f0eeda97bfcd..001b6841a4b6 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -135,7 +135,7 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 
 static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
 	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_TARGET_REV]	= { .type = NLA_U32 },
+	[NFTA_TARGET_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TARGET_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -419,7 +419,7 @@ static void nft_match_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
 	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_MATCH_REV]	= { .type = NLA_U32 },
+	[NFTA_MATCH_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_MATCH_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -724,7 +724,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
 	[NFTA_COMPAT_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_COMPAT_NAME_MAX-1 },
-	[NFTA_COMPAT_REV]	= { .type = NLA_U32 },
+	[NFTA_COMPAT_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_COMPAT_TYPE]	= { .type = NLA_U32 },
 };
 
-- 
2.43.0



