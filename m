Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12301292DF;
	Tue, 23 Jan 2024 00:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970987; cv=none; b=imQVhXibjimBhDedxZPI2pEcToXTq9BfiIL9aDBqGMG78ZZe0PQ9PldiQ8xfyXk4iCXNbFj2t4MolBCRXpbPneHDNffv0NsW7J6HBS4S45cqbSa/rhC8TnD2dZyeo4ExbqZtkcHl4ocwh8OXOJrLJ+5NK9+4jmevBK4KYz8h95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970987; c=relaxed/simple;
	bh=WKPHLUj4ruepIQWI9pGntahS7rF6cey2iLITZS/DL5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHSnz6F4LN8OKEes6jsrLGOKIiXCpd15gocdgILuDIdNx5a5aUZQSy7Sor6nsUVeNmFNwD6NVoxeLT9Yh77eSie06C+SddXtW3vI0lO9i5glAFO3VpCLC6A5HrSB9j2ZQ4aN0xsdQWBem0Dp77cHwRAGbtDJN3MWfPR0sVCqHas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swsgEUaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swsgEUaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92560C43390;
	Tue, 23 Jan 2024 00:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970987;
	bh=WKPHLUj4ruepIQWI9pGntahS7rF6cey2iLITZS/DL5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swsgEUaJJV/Z5QF6izGT7Ct5EoiTV8FSqyR7sUEVKRHZ9oestrUOllmSfQv3Uw/qq
	 AWRGmwMsi30jX+hmRmHHk5tN5jicZm+vdFJ2v2sg4RRuunXFcTO1hAHPUQIPuVcyGM
	 km2vD3PzE/VwTSEb2uKF5+ffcnFi9jVxiAHPKdTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/417] netfilter: nf_tables: mark newset as dead on transaction abort
Date: Mon, 22 Jan 2024 15:55:11 -0800
Message-ID: <20240122235756.790809358@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 08e4c8c5919fd405a4d709b4ba43d836894a26eb ]

If a transaction is aborted, we should mark the to-be-released NEWSET dead,
just like commit path does for DEL and DESTROYSET commands.

In both cases all remaining elements will be released via
set->ops->destroy().

The existing abort code does NOT post the actual release to the work queue.
Also the entire __nf_tables_abort() function is wrapped in gc_seq
begin/end pair.

Therefore, async gc worker will never try to release the pending set
elements, as gc sequence is always stale.

It might be possible to speed up transaction aborts via work queue too,
this would result in a race and a possible use-after-free.

So fix this before it becomes an issue.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3d6ebb9877a4..db987388cb5d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9937,6 +9937,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
+			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
-- 
2.43.0



