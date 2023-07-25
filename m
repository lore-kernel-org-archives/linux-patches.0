Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1415AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C177DC433C8;
	Tue, 25 Jul 2023 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282712;
	bh=jv2yiGx/UsGYx9E9IwKOXGufObKecqox/DlcQw9Jj7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW9TVY8YoXsI/OzLF8LOttf66ho1ZnqG5rLW7usbv5pJAhZ/Ns0jSlh2HzJfTG3Kj
	 0Me+ThX5gxYZg2Y1G0Hz5u/6/KYbFIP2MwZi5roPXmJ97En1iz/XL63OaALL53p4gw
	 +7E56cBW5pThz5kVJ8g/knzPbPvFCvrHhHjh7T7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 198/227] netfilter: nf_tables: skip bound chain in netns release path
Date: Tue, 25 Jul 2023 12:46:05 +0200
Message-ID: <20230725104522.998524873@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
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

[ Upstream commit 751d460ccff3137212f47d876221534bf0490996 ]

Skip bound chain from netns release path, the rule that owns this chain
releases these objects.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3a4aa9054876..e3049c7db9041 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10767,6 +10767,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	ctx.family = table->family;
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {
+		if (nft_chain_is_bound(chain))
+			continue;
+
 		ctx.chain = chain;
 		list_for_each_entry_safe(rule, nr, &chain->rules, list) {
 			list_del(&rule->list);
-- 
2.39.2



