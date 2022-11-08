Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABF615CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6874C433D6;
	Tue,  8 Nov 2022 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915583;
	bh=heT/kxS3wWkKoed9oVLLIB1ZBRTax2IyroCOLDpfBOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FG2dZdwIAKQ2LjoG0tAsPRrfwr2K6p275kqbEZHWm1Y10VK5oZFDY+KAvcPOt3Tyy
	 fG3xJqs0eSbzAFIr8gIkCvvvT6dKzAXwcVzzc1XXuYMLZ2MDEOchx9nK9Ro56IjRS+
	 5vxCAgYbn3ouFg7B1/nsg/fLuZFjwTHLLp6eipIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/118] netfilter: nf_tables: release flow rule object from commit path
Date: Tue,  8 Nov 2022 14:38:30 +0100
Message-Id: <20221108133342.053890198@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

[ Upstream commit 26b5934ff4194e13196bedcba373cd4915071d0e ]

No need to postpone this to the commit release path, since no packets
are walking over this object, this is accessed from control plane only.
This helped uncovered UAF triggered by races with the netlink notifier.

Fixes: 9dd732e0bdf5 ("netfilter: nf_tables: memleak flow rule from commit path")
Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 810995d712ac..2143edafba77 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7527,9 +7527,6 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
-		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
-			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
-
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
@@ -7973,6 +7970,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_rule_expr_deactivate(&trans->ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_COMMIT);
+
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
 			nft_clear(net, nft_trans_set(trans));
-- 
2.35.1



