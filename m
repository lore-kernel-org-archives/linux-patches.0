Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90955248881;
	Wed, 25 Feb 2026 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983563; cv=none; b=TrRiodX7bpDwvDoaRnV0X/y8W8kTDM8hZvYlDAn/w68FEwfkeoiL5Yv4Q2W+Jqd0OePOCoqNJLRE3ZtmvayoBtW4jvutEcSAm9J+7yX7FLk27BjD9nJHy2MT13k99ljKg92mFjsN5L/7c6n0D3BS5ZsHY2CN/l+6letXYHKGYqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983563; c=relaxed/simple;
	bh=oXKMBsWeH/VtZdyvpSkz+p3EcToWvc8ziks1aPAMmsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsqhTpCfemMm2xYDW2e5X55V+LrkUo7/1BXMePGS3eH/oJ6Roz6nhhAiQZNXJJQeUOfIjFe6y5LD6eHJ2Wiz+Fs2QFAvOsW3+Blw9h/1+B+v7l1csohcSI0adqXzXhihedqODY0zepZmKiledIunMjEknsRiZELhy0HHn9e8aMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WInDHdB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WInDHdB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B00FC116D0;
	Wed, 25 Feb 2026 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983563;
	bh=oXKMBsWeH/VtZdyvpSkz+p3EcToWvc8ziks1aPAMmsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WInDHdB674s23k3mPLpc6/PBVQTPzMihHWSGKODPOtWnNDUG1WJKMc/KdjS8vsg6w
	 vLgz/NQqo+OBH+1ah8SjjIcyarBFWCEMuov6kQMQn7jzknXWaaDDhAS8vNUJfOwe6j
	 sH47KO57iI9mJ6jFA4T8LGpEKfa6Fnd9iVTHy3tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Brian Witte <brianwitte@mailfence.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 662/781] netfilter: nft_quota: use atomic64_xchg for reset
Date: Tue, 24 Feb 2026 17:22:51 -0800
Message-ID: <20260225012416.024413239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index df0798da2329b..cb6c0e04ff675 100644
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
2.51.0



