Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DEB1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0556C433C8;
	Tue,  1 Aug 2023 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882444;
	bh=3MCRaZ2ro62yTZdIbEfzhF3TO7F3/AbZpBCiurAclbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vnHMAVupXTTWafIpfxmzo3ewHGjQMVWWT7I3yVh7ZIY9c2Ld3kHLiaCu1BKswFcX
	 SnM2cT/12piuVZR//BZ+vPpgR4mRLtu1Tpi79DJ3umu/1YEfPmawji5Nd9DLkf+XYi
	 T+h1iik2MNxpq8sk/AZs3dndph63OEIw0X/3ujj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/228] netfilter: nf_tables: disallow rule addition to bound chain via NFTA_RULE_CHAIN_ID
Date: Tue,  1 Aug 2023 11:19:25 +0200
Message-ID: <20230801091926.660211517@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0ebc1064e4874d5987722a2ddbc18f94aa53b211 ]

Bail out with EOPNOTSUPP when adding rule to bound chain via
NFTA_RULE_CHAIN_ID. The following warning splat is shown when
adding a rule to a deleted bound chain:

 WARNING: CPU: 2 PID: 13692 at net/netfilter/nf_tables_api.c:2013 nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]
 CPU: 2 PID: 13692 Comm: chain-bound-rul Not tainted 6.1.39 #1
 RIP: 0010:nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e2e5ff6acd2bf..dd57a9ebe113d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3626,8 +3626,6 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 			return PTR_ERR(chain);
 		}
-		if (nft_chain_is_bound(chain))
-			return -EOPNOTSUPP;
 
 	} else if (nla[NFTA_RULE_CHAIN_ID]) {
 		chain = nft_chain_lookup_byid(net, table, nla[NFTA_RULE_CHAIN_ID],
@@ -3640,6 +3638,9 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EINVAL;
 	}
 
+	if (nft_chain_is_bound(chain))
+		return -EOPNOTSUPP;
+
 	if (nla[NFTA_RULE_HANDLE]) {
 		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
 		rule = __nft_rule_lookup(chain, handle);
-- 
2.39.2



