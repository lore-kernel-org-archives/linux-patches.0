Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C301442FC8;
	Thu, 30 Jul 2026 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425311; cv=none; b=eJ2VXkGiKDnp4f2LRBFdNix7dRrWK8JsIbMJW4Es1FtTIJQPLTRHIYk70VgiwbMk61O1xa75CoxllM7BilRU52QmZm6QNBpTMf5h8V4xErV8pY5HdGUAtFE1uhugDp2WFwb7k2zGPkDuw3u5kktTE4Ic1yhSSvKlmL2G7AEMHHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425311; c=relaxed/simple;
	bh=4P0/3ywWMV4TGk4ncxx26NExmvy22PqYsKQLafKa1Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC0AZVjjrcP8xHxh1SzAsHDTSNakURLGwIjzWVG4Z4UBJDkew2HG9NyoPU1c3oAY5qLkCAqCdLspVyEIqyyfR199m0yblpI8Y5qw1S/rI4AN1o2s7QEXbKc1XoX5NVLZvYg+rnuL+/CO5J/P4YqxYJ7ArCT3nRp2p/BNEEafiEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGIuHk1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGIuHk1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4861F000E9;
	Thu, 30 Jul 2026 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425309;
	bh=yZHZBBsdxxvPe9SKgzk3TX4EmFcF+zDP0gc31hwfmcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGIuHk1ns0y25uNgOzTZB4aR15xVQ/nWGOQvkb9LYj/xUn6xz1Fgr7dlOq7TdnS8w
	 ABlKRjdQCvQdcqhcmrr733ExZLdZcX0rI7o+bxMnb9f+8lk50MD8lwOZzhTMcVauye
	 g6JCcYKOqh/D7p3bzrzKIRmIm56UVMCPSLqPCNcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Brian Witte <brianwitte@mailfence.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/602] netfilter: nft_quota: use atomic64_xchg for reset
Date: Thu, 30 Jul 2026 16:06:39 +0200
Message-ID: <20260730141436.145636892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Witte <brianwitte@mailfence.com>

[ Upstream commit 30c4d7fb59ac4c8d7fa7937df11eed10b368fa11 ]

Use atomic64_xchg() to atomically read and zero the consumed value
on reset, which is simpler than the previous read+sub pattern and
doesn't require lock serialization.

Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_quota.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index df0798da2329b9..cb6c0e04ff6755 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -140,11 +140,16 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	u64 consumed, consumed_cap, quota;
 	u32 flags = priv->flags;
 
-	/* Since we inconditionally increment consumed quota for each packet
+	/* Since we unconditionally increment consumed quota for each packet
 	 * that we see, don't go over the quota boundary in what we send to
 	 * userspace.
 	 */
-	consumed = atomic64_read(priv->consumed);
+	if (reset) {
+		consumed = atomic64_xchg(priv->consumed, 0);
+		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
+	} else {
+		consumed = atomic64_read(priv->consumed);
+	}
 	quota = atomic64_read(&priv->quota);
 	if (consumed >= quota) {
 		consumed_cap = quota;
@@ -160,10 +165,6 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	    nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 
-	if (reset) {
-		atomic64_sub(consumed, priv->consumed);
-		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
-	}
 	return 0;
 
 nla_put_failure:
-- 
2.53.0



