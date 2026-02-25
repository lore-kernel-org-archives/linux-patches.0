Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365D20C012;
	Wed, 25 Feb 2026 01:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984008; cv=none; b=hZNNe7Ue+6hzyb0XzITG5jfFggKtz1NFwiSK4vdMSGw+jaR9TFYeWu/GLsrLpKBshU2tak0eSnUrg1FFanP3lQR1WNUtantibsQW1TbMVzdzuK5XDqBSqRo7Fou2ptBTSO3ifTa4cofgeRrlXuv0gSyf1Qe+LD62kazyfXyeTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984008; c=relaxed/simple;
	bh=wrJ5kRupEg7811yJ8+3RAzV2bLPuzUDyyS6LkK4L7JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU3cTNjOEZRsRjrk6jyctO5bV3L+2my97C04YaHABtkI2iJ7hLpQ2ZXrux9tWy8G9Mh1Fi+4GjLeM8+3TWbMyqA54RJJ9QtVBpFR10mZ61sMQz54eSQEhWgif4PDH/lJw6ABgzMpCweh3/y3oxrHzUcnO7pEFxuTcR615ZrHU2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpM9q3H4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpM9q3H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ED4C116D0;
	Wed, 25 Feb 2026 01:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984008;
	bh=wrJ5kRupEg7811yJ8+3RAzV2bLPuzUDyyS6LkK4L7JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpM9q3H40SJRM2/3UCMfKV1R4aaYmou20qvGNlKGheM//BDIXuujKPp+Qe0uR8RFu
	 Zke6z1IlslBfqRvI/diSyd4e1/Aomk2SR/naTLkcZ2zX+475SgmY0e64nSumaPI5rw
	 3xpDIau0lK3QArPphAR0WOsncGYs+4fHj/1JgzQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/641] netfilter: nft_compat: add more restrictions on netlink attributes
Date: Tue, 24 Feb 2026 17:19:45 -0800
Message-ID: <20260225012355.103448869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



