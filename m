Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01CE13AA4C;
	Tue, 27 Feb 2024 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043154; cv=none; b=Itc8Ks3tlDL/VIB8ghw78TeNpG8Ss/mNk9gbXw4loH4dfbSrG7gV2O4YrpVEVK7wQAfxRB7s1f885bg85DSlrLzpaG4mpjcQQK6wEHxleLiK25YNPgDEsO0ogpwKb1VxZTVe2sGwnPxmK8F0rksQIf8USzLf/YoSMovI5yvArM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043154; c=relaxed/simple;
	bh=gKmlo/GrqZPSkFlGOWt8xh3XYD7B+usj5NyCvU+xXBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOFa1tghzI5isSx6mnGwA7Ypw/Dx6R3hwDxy2S8saTIuVNjrL5i/hxQegjN0+7hIqe86Otrc+XjO3ke1JnkmShzmKVc5JulywmG6zo7BJ45lNDWbg7+LW50TCXi9rxkqveTuyvRZlzyJagipGHqs15pz8bz6Q6BM3t9eK46Lxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYt+PFb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYt+PFb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1179FC433F1;
	Tue, 27 Feb 2024 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043154;
	bh=gKmlo/GrqZPSkFlGOWt8xh3XYD7B+usj5NyCvU+xXBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYt+PFb9LfwHo+y1UcawDLFF374J68XycRcphOi9Y1zklb4/zBX9XazjW0B8+ITmf
	 jyPv3V7cfpaJewFxV0qFNYLYh6GNgfd6CIhrWa1pNTVUjU2H6ZFZxW1+aYEbaAKBX/
	 gu6MpgBs7kMSAH9AhvYiwPkIvx7KHcux1/V0k3g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 242/245] netfilter: nf_tables: fix scheduling-while-atomic splat
Date: Tue, 27 Feb 2024 14:27:10 +0100
Message-ID: <20240227131623.023559872@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 2024439bd5ceb145eeeb428b2a59e9b905153ac3 upstream.

nf_tables_check_loops() can be called from rhashtable list
walk so cond_resched() cannot be used here.

Fixes: 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10044,13 +10044,9 @@ static int nf_tables_check_loops(const s
 				break;
 			}
 		}
-
-		cond_resched();
 	}
 
 	list_for_each_entry(set, &ctx->table->sets, list) {
-		cond_resched();
-
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 		if (!(set->flags & NFT_SET_MAP) ||


