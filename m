Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AEA13B2B4;
	Tue, 27 Feb 2024 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042906; cv=none; b=MSsFv5mJZ3adsFY1jRavdqJAl60dZ3ZjNDyZ3gnPu0l/NI+GyFU0Xqk2xpw1vN/0q+ALzFwkVL0tLwdGC+LnoxRLBIEIQfr598+99DYTK0aaFTH47UMElJlCD9oU9IeWAC1+RkDIivWxv+DLJPaRjsbRGYEtScbJABTxkbma9R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042906; c=relaxed/simple;
	bh=L5QqCxSD5UH6gi0FW8Npju3pXUrXosHCBl4vkqalEi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZP0CIEPz/vG5q6gsHuHzXdaKEO3WteBsEbv1vESMiYPz1lPN0QB0uA+kW35lBwvtgrC5oP7CMY9CADKEHTojcPHWqqv5i+3R4pNgTaFIpE0cevFXIiBnMUDToSra4bhHOA9aHLacIExIjQ7xevRvfj0JRR8A7hSQlwLeFIANzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L11BXfQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L11BXfQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2028CC433C7;
	Tue, 27 Feb 2024 14:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042906;
	bh=L5QqCxSD5UH6gi0FW8Npju3pXUrXosHCBl4vkqalEi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L11BXfQgu5pQwflmzguu87b52qKE1H8WWcWAz1QBO/lASwoQFnDL8OL6HxWt/0Ykr
	 RZH/JWqIkzEsPCjIy2pm2o8o+FJuDHhcfD3MpiSmkwsM7YDEng2R1SXUN1OpQlJL9H
	 Rt6wAaIKcg2Y1bMPy+zxuI11N71rjGLVzuP4gn1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/245] netfilter: nf_tables: add rescheduling points during loop detection walks
Date: Tue, 27 Feb 2024 14:25:52 +0100
Message-ID: <20240227131620.542424002@linuxfoundation.org>
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

[ Upstream commit 81ea010667417ef3f218dfd99b69769fe66c2b67 ]

Add explicit rescheduling points during ruleset walk.

Switching to a faster algorithm is possible but this is a much
smaller change, suitable for nf tree.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1460
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3ad2b22886ff0..361fbbd430ad8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3442,6 +3442,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			if (err < 0)
 				return err;
 		}
+
+		cond_resched();
 	}
 
 	return 0;
@@ -10041,9 +10043,13 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				break;
 			}
 		}
+
+		cond_resched();
 	}
 
 	list_for_each_entry(set, &ctx->table->sets, list) {
+		cond_resched();
+
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 		if (!(set->flags & NFT_SET_MAP) ||
-- 
2.43.0



