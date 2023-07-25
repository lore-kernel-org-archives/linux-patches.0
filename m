Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961C81D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E8EC433C7;
	Tue, 25 Jul 2023 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283116;
	bh=OaUTPOAX2x/OhpRBpO5t1XDmdXBZ+5MSIm3esZoWkKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNkyRmslz9M10ojmsvHYaKH2C+le+VPxusqtdaZPQfk9nz2CfToP9Pq6ZOgXo6KSg
	 552Wwmif3QBq3IIJ9/CMywHAhY6C7K2EgcOMpgf2VyfkzbTZW9EmtaiqQivyqm8Ra4
	 2M2gLX3WFJJAd7/23Ypizmb2KXu3SNsUOCyWdYn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/183] netfilter: nf_tables: cant schedule in nft_chain_validate
Date: Tue, 25 Jul 2023 12:46:12 +0200
Message-ID: <20230725104513.089775254@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 314c82841602a111c04a7210c21dc77e0d560242 ]

Can be called via nft set element list iteration, which may acquire
rcu and/or bh read lock (depends on set type).

BUG: sleeping function called from invalid context at net/netfilter/nf_tables_api.c:3353
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1232, name: nft
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by nft/1232:
 #0: ffff8881180e3ea8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid
 #1: ffffffff83f5f540 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire
Call Trace:
 nft_chain_validate
 nft_lookup_validate_setelem
 nft_pipapo_walk
 nft_lookup_validate
 nft_chain_validate
 nft_immediate_validate
 nft_chain_validate
 nf_tables_validate
 nf_tables_abort

No choice but to move it to nf_tables_validate().

Fixes: 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58f14e4ef63d4..0bb1cc7ed5e99 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3500,8 +3500,6 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			if (err < 0)
 				return err;
 		}
-
-		cond_resched();
 	}
 
 	return 0;
@@ -3525,6 +3523,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
 			return err;
+
+		cond_resched();
 	}
 
 	return 0;
-- 
2.39.2



