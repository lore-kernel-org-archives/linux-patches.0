Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA4438CFFE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302126; cv=none; b=piNO11D4XsjN5ocnWEVwunKyJ4ozx2oA1nGiBXrYq1cg0rfI5I4EgYDJJ2lE1UlByt0bjaDa2ZeVp74HvTf4YjEEUv9G76xT948EaKSMFshOyMoRStQ8Mi3bioAsozoYYIcx7C6sd4nRxdKC89uHhMr1620CuWiJbKC0j8FGGoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302126; c=relaxed/simple;
	bh=IvmcW9dTTFxB7iew8N9xWwTwB6j2CTwDiH3GFYJGa+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdU6SyiwCArCs41yAZ8t8twuU1OaS54uuMfJq8alVM54CEFLhLJj5556Cz00j7jXNw4IfRaQsO3pNu3iQSUk7jl0dCxHkjexduLrWizOpTEeMN0T6y3gz+kzRcglTxHEUhxSPzyc73hBdufKkVAZawRC7PcbiKWcmRb0Zn1e3c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWNnG/ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWNnG/ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CD3C19424;
	Sat, 28 Feb 2026 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302126;
	bh=IvmcW9dTTFxB7iew8N9xWwTwB6j2CTwDiH3GFYJGa+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWNnG/nsAPpSgrdeu5+jPPCD576FkVvPYkM6V6OBas87wZVT6yeKoZiGxDbs26lmS
	 5owI6E4zLx7GgpR71fFX8e2uNxALXJTfo3KGRFPoQTI/LB+pmpavbQLWKLsPnFSEzj
	 V/3MJGpGsYRL04AtgxVLU3TnZDSv3Umg+dSdsj7oV06r4LaoRm36vK32lfFGs3NCzw
	 VsP6GwXFBCSETDkBQIhgbAuI/np2ia9Gl7yzAGUIRns1VpS/9FeDWGC0B4FeujFvoG
	 zdu/xhsWTipPMB1mZsbYtjcatmiqWLSFYiFqNd/uCYxiCdgK8m47+5H02X91Pb551M
	 1Q5AvdUu+iE4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/283] netfilter: nft_compat: add more restrictions on netlink attributes
Date: Sat, 28 Feb 2026 13:04:20 -0500
Message-ID: <20260228180709.1583486-118-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 7ca4f0d21fe2a..1e8142e64e808 100644
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

