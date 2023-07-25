Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E8C1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F7EC433C7;
	Tue, 25 Jul 2023 11:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283464;
	bh=J1PTcIokG27FjcpogXJghJvm511ydhg3gwmC6H6Kk4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBab0jaHSmDbioXNuR0db6xG6LvzBRiSc7dMVb6hHj+oZDc9aRQjplTQYUr/ocSiI
	 dmlQ1JFFQTNAvuOnrGIjI2XNEndDM/3UkeFlwGygJuSVEMZZoX0oFt8C86DGNVGtZP
	 FCB3vmmdB+wRLOUlrRFG1cIuYf6vkWElvS15HbCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 64/78] netfilter: nf_tables: skip bound chain on rule flush
Date: Tue, 25 Jul 2023 12:46:55 +0200
Message-ID: <20230725104453.754046875@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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

[ Upstream commit 6eaf41e87a223ae6f8e7a28d6e78384ad7e407f8 ]

Skip bound chain when flushing table rules, the rule that owns this
chain releases these objects.

Otherwise, the following warning is triggered:

  WARNING: CPU: 2 PID: 1217 at net/netfilter/nf_tables_api.c:2013 nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]
  CPU: 2 PID: 1217 Comm: chain-flush Not tainted 6.1.39 #1
  RIP: 0010:nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1cf075a4269a4..e0e675313d8e1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3795,6 +3795,8 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_active_next(net, chain))
 				continue;
+			if (nft_chain_is_bound(chain))
+				continue;
 
 			ctx.chain = chain;
 			err = nft_delrule_by_chain(&ctx);
-- 
2.39.2



