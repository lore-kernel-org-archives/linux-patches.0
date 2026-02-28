Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5048E342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301782; cv=none; b=ocf7/+uPxoWH8x3hgPFVLpFfzNX21IxwpOk9qshn1eeC54cgET43qgySWSLwuiW1PTu+O8KG+0+jERDU863289aLkO5HExAnQ5dCfSMiDCsBTvDJKAserU6wFopWQoPGvXzu2bh004ar3WMWyI98YcdmBu1NVYRi6UEN85Ap1ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301782; c=relaxed/simple;
	bh=oxrT9OsxMwaHeAFB9Bq1PgiVEIL0F4r7hnD3dNHar1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHKGymqfiGaTA3O/qRoFsG/wSPH7BpFHSrG1/ib49Qx6Zkxnz+NVAta1AsFC3YV0VYBS8i+b+/1Svf9IWdA0FyqlKz/XQBSb3BXvYwvIGxhJ8T48aDGQBefYCnHoTkApsTUdEVZio2UDKgpKLoGyTm8OR5AQ9FpdsqCnHYXnC7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReAQOCkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReAQOCkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED3EC116D0;
	Sat, 28 Feb 2026 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301782;
	bh=oxrT9OsxMwaHeAFB9Bq1PgiVEIL0F4r7hnD3dNHar1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReAQOCkAhq6GK08J70hQyz5ZgMuwhFjlbElWrUA83rWRahwgrNggvXobUbo9j6TdM
	 JEIJiNJHQU2XEIBkE3JBvzv1QglXPHTD/uXFj6zBdrc2mWz8ABlC1R0nRNCpIZcbTR
	 aOqt5rzeBO1QR6/2tTqgSYDaBoWIhXlLucg09FzQLZSo9CzutYBRtvepV5j4Bua65D
	 Sc7/vWpYN+VF8rRA1ibJYEv1AXUJRG6TeRvVExUJnhrP7lNjMgCv9SJmrG5oG9Uw7P
	 iZnJ/p5IINsrmgBrEwUhB08XHMsUwXowoliW8o/lFQdP3IPx+uxWm5IO5qXxDC5yia
	 azPSk7A7I5UYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/385] netfilter: nft_compat: add more restrictions on netlink attributes
Date: Sat, 28 Feb 2026 12:56:54 -0500
Message-ID: <20260228180011.1568201-192-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 72711d62fddfa..08f620311b03f 100644
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
@@ -693,7 +695,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 
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

