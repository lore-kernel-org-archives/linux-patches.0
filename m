Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C220436C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302369; cv=none; b=ZRSQF0KC3vjbHqPUVvaEC2M8X55KNMtO0YgTfkVw/5LYy+BRpBnB5IQ7T53Rf4DCgWepDXp6/IeQpoQn5gtuKlwq0BE319W0iLfBaD9ENLynNRq8qlsxQ3Tc2eEloHOLQz3EuamHoL74wHBe2IRvBwGLHfb6kUfplzWtnkF/g1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302369; c=relaxed/simple;
	bh=fFW1/dmWM6sMZOG6ggTMFKIFc+R7+1C0CVzEwJ+L5xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNaRO1ykxnwNfVZiqXobxMEqrln11ctnT7qw83aEVZSoosKfBJ/YI5EcQAsgYVt9ZbR5nbYvCVCIRUNui8eqCjqGLkEgY2osHXAp5mGI+fonM2DW/QqAmhEp6Y/fI1QIxqLlvGFP6AeyKpTIOkuxpfm2hPo3K7zmksM7v7GbyxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIZmeP6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIZmeP6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF73C116D0;
	Sat, 28 Feb 2026 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302369;
	bh=fFW1/dmWM6sMZOG6ggTMFKIFc+R7+1C0CVzEwJ+L5xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIZmeP6L+BUL5z68t3b82CMDyKkuAKOxrjFCGvXUswiKZBVTMbHSTyARh5kTjpisf
	 2rlirLvS1oHJYiUYa4Z/lPN1enLpkrwpZAKXWcHzYnxaueSTORaOUdiy8AnTzkKiAa
	 lg+cLiym+sUksXyykqLgG7dvenNwpb6uoUQnjgBK3W3twoCdszInHxDoNUjlMagOAF
	 eecye2wFLYZZVCVtXPrrk8tExG1jhrrikZl+AaUY+8XbyEYBOX8G3olstvP+RzjCCM
	 PGNXoW+wZW285dGrt3ud2n8Xh3fb9K0S7Uf84EYposleQAs/ZBvet7aDgOlZazzbNP
	 9LT2VR2cLrjQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/232] netfilter: nft_compat: add more restrictions on netlink attributes
Date: Sat, 28 Feb 2026 13:09:11 -0500
Message-ID: <20260228181127.1592657-98-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit cda26c645946b08f070f20c166d4736767e4a805 ]

As far as I can see nothing bad can happen when NFTA_TARGET/MATCH_NAME
are too large because this calls x_tables helpers which check for the
length, but it seems better to already reject it during netlink parsing.

Rest of the changes avoid silent u8/u16 truncations.

For _TYPE, its expected to be only 1 or 0. In x_tables world, this
variable is set by kernel, for IPT_SO_GET_REVISION_TARGET its 1, for
all others its set to 0.

As older versions of nf_tables permitted any value except 1 to mean 'match',
keep this as-is but sanitize the value for consistency.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index e4b8c02c5e6ae..4f674a472bb69 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -134,7 +134,8 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
-	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING },
+	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = XT_EXTENSION_MAXNAMELEN, },
 	[NFTA_TARGET_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TARGET_INFO]	= { .type = NLA_BINARY },
 };
@@ -434,7 +435,8 @@ static void nft_match_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
-	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
+	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = XT_EXTENSION_MAXNAMELEN },
 	[NFTA_MATCH_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_MATCH_INFO]	= { .type = NLA_BINARY },
 };
@@ -692,7 +694,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 
 	name = nla_data(tb[NFTA_COMPAT_NAME]);
 	rev = ntohl(nla_get_be32(tb[NFTA_COMPAT_REV]));
-	target = ntohl(nla_get_be32(tb[NFTA_COMPAT_TYPE]));
+	/* x_tables api checks for 'target == 1' to mean target,
+	 * everything else means 'match'.
+	 * In x_tables world, the number is set by kernel, not
+	 * userspace.
+	 */
+	target = nla_get_be32(tb[NFTA_COMPAT_TYPE]) == htonl(1);
 
 	switch(family) {
 	case AF_INET:
-- 
2.51.0

