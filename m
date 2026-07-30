Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB93212FAD;
	Thu, 30 Jul 2026 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423348; cv=none; b=kJfpguxg7zNA5LBaFxRn4xxuq01U4AU79OZGA3XzGpNMy18nysXmlLs2uly/bBF9cyyJ9AYpfGYkGmNed9a7F4ZJoB8StuO7wHxjzvy3WmgaGOdZGss3rtdeuHC+NpGhjvl6heuw2nmevs/pESA5jY1InVM8X7i1OXot0qG9mYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423348; c=relaxed/simple;
	bh=lVqUo9Hz+yu/mygRhl4JPfwq+WJHJjV8aIMElWEP7S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QncxCqb52fr1IwM5LF4sTDaZWHgmFhkwSQrF6WTUojFPED0/ws71cuxZJPlLAPTMMl1zGMAgw2qeRZxIDWMDWio1Gp7CmqYcml1QWtSfl1nDbF+SsS0fhW24Wk3P0VMVSDEmCJwJyaWlWRMy3ETB24QMtuqik8crm/Oc8CkAe68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Sm+sfsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Sm+sfsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDC41F000E9;
	Thu, 30 Jul 2026 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423347;
	bh=MXue4QZ98cGK48YqrjGcCP4Q3gSOytGcUws+ehDZrcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Sm+sfszVKZLIsqZMolcAVmeNilrH9AdaE7V92UV/ltHipSvy6KFwn/O4z+lDy9DH
	 yvuBysMUvBs1tCsPme1VLV3ey6D4etBKIKww3ZlJfLIuS8DaBFZDmN6N3z+Mde5/et
	 K6WWHZq9qmcaB1yevQEHc4wqPhl9IVXZBc2cu8ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Brian Witte <brianwitte@mailfence.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/675] netfilter: nft_quota: use atomic64_xchg for reset
Date: Thu, 30 Jul 2026 16:05:35 +0200
Message-ID: <20260730141445.229912423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



