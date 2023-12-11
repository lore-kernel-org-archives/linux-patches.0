Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1965C8C8;
	Mon, 11 Dec 2023 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJAL/C3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D0AC433C7;
	Mon, 11 Dec 2023 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320422;
	bh=aMoNcS5UhYua3mkC447VUfTsjr7uyB9iMOG11m7GqLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJAL/C3QFx6uNr91h2qRy40Bm5LXKmf91leFGPE8JojlvMBzFWSUXoSerZFS6uts7
	 UAeeFI8/bgOnT6pf9BcMIDTSFPjXLMuDiEGh8R2s3OAvRWfIBcfRanvuntSgMet849
	 TKQ8K3mUKg6JMeeUKyO8NIpVcZ8YaGnfkiZM08lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/194] netfilter: nf_tables: validate family when identifying table via handle
Date: Mon, 11 Dec 2023 19:20:46 +0100
Message-ID: <20231211182039.046694656@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f6e1532a2697b81da00bfb184e99d15e01e9d98c ]

Validate table family when looking up for it via NFTA_TABLE_HANDLE.

Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 421211eba838b..05fa5141af516 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -805,7 +805,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 
 static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 						   const struct nlattr *nla,
-						   u8 genmask, u32 nlpid)
+						   int family, u8 genmask, u32 nlpid)
 {
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
@@ -813,6 +813,7 @@ static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 	nft_net = nft_pernet(net);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
+		    table->family == family &&
 		    nft_active_genmask(table, genmask)) {
 			if (nft_table_has_owner(table) &&
 			    nlpid && table->nlpid != nlpid)
@@ -1537,7 +1538,7 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (nla[NFTA_TABLE_HANDLE]) {
 		attr = nla[NFTA_TABLE_HANDLE];
-		table = nft_table_lookup_byhandle(net, attr, genmask,
+		table = nft_table_lookup_byhandle(net, attr, family, genmask,
 						  NETLINK_CB(skb).portid);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
-- 
2.42.0



