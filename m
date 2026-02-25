Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D4A18DB2A;
	Wed, 25 Feb 2026 01:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983217; cv=none; b=nMqYIjeo2erl5SvZjBjSIITSN/MtKHxQ/or1PWYcvZZ3Cdmor1uy2aHUotQPhM0nrlDDKtqPleverLr7ncvqP9i+WCLgnOaNq+Pxm997kWa9dlsEOYO637ndiet9hCc0Q+IyQDd8cuxcz7cOAkbJVJCAX5Qh/jLqkQJ3Ak2RSi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983217; c=relaxed/simple;
	bh=LxsQyi/XeSCVI88IE8+Pmf5D2X3ur3Dw9yQTb5NdBU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgMbyHFU0wjKzdoJyw4ctHeUrn7kv3062k9729LB4lsFF74ApllyZE5PM7jAz7yur/qhbbFJEz8fDDfMDx+gsTZx8kJTAg1rUXRtmhk+4CwJI2/B9kbYHIK4ocj5D2vRkLLgiMfnt4F3WBcpeoHuSAZiyJXe5MmLKv+sAmv8oXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJtqBvUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJtqBvUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FFDC116D0;
	Wed, 25 Feb 2026 01:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983217;
	bh=LxsQyi/XeSCVI88IE8+Pmf5D2X3ur3Dw9yQTb5NdBU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJtqBvUAv7PMy2jZfJwJEZh5KMfdB651p2Hyo9SSSYJoVnMgskTmjbowPdF8Bemlq
	 y/kSPZnF/CkeyNzGDSYdr/wnHVE6yixIK3Qvmt6jP3+cnowoiU5m4xhZh26vDvv73O
	 NNwnaCv7nwCvDq8GE1yiBrxIrVbDYxXCxV9G3o18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 347/781] netfilter: nft_compat: add more restrictions on netlink attributes
Date: Tue, 24 Feb 2026 17:17:36 -0800
Message-ID: <20260225012408.200851218@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



