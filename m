Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8DD1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16B9C433C8;
	Tue, 25 Jul 2023 11:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284819;
	bh=pFdr8y0W5BbIKwuj68ECZ0nMa6piaOSLfm2ci2Aec6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDnSR8usPiKhTdbq5MNd9gw1pu9WvgJJsIiIhrzV5kGMoHj1OzzcmIsEMMLMpnB9D
	 zd35BqAjpg1VCIhgR3kXFkcI7Kb+wGYjizaroQSnoGMbaN6NLG6kaPRWuHhHtMsQ3U
	 w40/Taq1GQkq1Ivx2/TDIregMb8sJiL4vYb4s/XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 492/509] netfilter: nf_tables: skip bound chain on rule flush
Date: Tue, 25 Jul 2023 12:47:11 +0200
Message-ID: <20230725104616.278723261@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index 40ed4dd530c5a..356416564d9f4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3611,6 +3611,8 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_active_next(net, chain))
 				continue;
+			if (nft_chain_is_bound(chain))
+				continue;
 
 			ctx.chain = chain;
 			err = nft_delrule_by_chain(&ctx);
-- 
2.39.2



