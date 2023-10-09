Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF67D199B7
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2atr6NR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB034C433C8;
	Mon,  9 Oct 2023 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858652;
	bh=8MiXU0SAtopM9SEvBzc8I7IZ5HaQGeanI6u+OZ5/h9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2atr6NR0qA8bC3VjIgwQhf+3kSkzE9X0534sItMnKIn+qA5VHUZrVvK33z/W3GwT
	 aQtQviyrnGw8eIFCZMTXYpUMwEaKwf6u+8sgR6XShORhFy2r7U8OlxFbtT73h3SZhS
	 XqDsJLEwFpDHcj3usF4ZUk8Wof4cNrU+OsaiQ6fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/226] netfilter: nft_set_pipapo: stop GC iteration if GC transaction allocation fails
Date: Mon,  9 Oct 2023 14:59:51 +0200
Message-ID: <20231009130127.554911233@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 6d365eabce3c018a80f6e0379b17df2abb17405e upstream.

nft_trans_gc_queue_sync() enqueues the GC transaction and it allocates a
new one. If this allocation fails, then stop this GC sync run and retry
later.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 80440ac5d44c6..fbfcc3275cadf 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1595,7 +1595,7 @@ static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
 
 			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
 			if (!gc)
-				break;
+				return;
 
 			nft_pipapo_gc_deactivate(net, set, e);
 			pipapo_drop(m, rulemap);
-- 
2.40.1



