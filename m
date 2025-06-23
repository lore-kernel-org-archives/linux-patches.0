Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7664C7F;
	Mon, 23 Jun 2025 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685662; cv=none; b=hhGwTMbzaOG25d8cRQ6XoSN2mCJvZCfBXVbMuHAOQPAsLklZxAPsDZ4fJBQwpcGTx1gnmIT/7jtpaAuj2xIUEuG9eNZ3PXbKmqWLcpPOZRaprVLiumiFxHdCtUOPwP5hX0GgeVL/eyGzkSqS/hc+Fz8aXtRSF/kU75dWK7UWUZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685662; c=relaxed/simple;
	bh=6BDss7qZtM7Nt0WLcAdXEuSSjzEQT07QBa6Lu8vZOlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAwi1mBPTh1xlxeP2iItHgH53/7D7/Z+h+BtsmCuy4flumNqZz7cCwi8aXJOmO1jzj3sRka1J59iYwimxCeZuFdBT4efiIcblCsblKoCXcA2oHy/yZRdkBUoPsToe/T1hYZ/8SCz5TjV2/RuhWOMqG/o2zyaX2elyJrOWZlZVc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpnwG6un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpnwG6un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F295C4CEEA;
	Mon, 23 Jun 2025 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685661;
	bh=6BDss7qZtM7Nt0WLcAdXEuSSjzEQT07QBa6Lu8vZOlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpnwG6unPAdPXZwNpwEGHtr2vXa6M1d4OgXr0efgbKX8afu8hS6u4cInp3MYK2v+B
	 BTTollx0seLNggO+hZe0eikjfMmUgR9sU3AqTOU1j+6/6sR6G+EnGE5ZsIKT34geeD
	 u52FFQ57bI3wJxvxZvvgIXGo/B9RyLPogcnXEuXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/411] netfilter: nft_quota: match correctly when the quota just depleted
Date: Mon, 23 Jun 2025 15:03:14 +0200
Message-ID: <20250623130634.497027370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>

[ Upstream commit bfe7cfb65c753952735c3eed703eba9a8b96a18d ]

The xt_quota compares skb length with remaining quota, but the nft_quota
compares it with consumed bytes.

The xt_quota can match consumed bytes up to quota at maximum. But the
nft_quota break match when consumed bytes equal to quota.

i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].

Fixes: 795595f68d6c ("netfilter: nft_quota: dump consumed quota")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_quota.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 586a6df645bcb..c2b5bcc7ac056 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -19,10 +19,16 @@ struct nft_quota {
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
-				 const struct sk_buff *skb)
+				 const struct sk_buff *skb,
+				 bool *report)
 {
-	return atomic64_add_return(skb->len, priv->consumed) >=
-	       atomic64_read(&priv->quota);
+	u64 consumed = atomic64_add_return(skb->len, priv->consumed);
+	u64 quota = atomic64_read(&priv->quota);
+
+	if (report)
+		*report = consumed >= quota;
+
+	return consumed > quota;
 }
 
 static inline bool nft_quota_invert(struct nft_quota *priv)
@@ -34,7 +40,7 @@ static inline void nft_quota_do_eval(struct nft_quota *priv,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	if (nft_overquota(priv, pkt->skb) ^ nft_quota_invert(priv))
+	if (nft_overquota(priv, pkt->skb, NULL) ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 }
 
@@ -51,13 +57,13 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
-	bool overquota;
+	bool overquota, report;
 
-	overquota = nft_overquota(priv, pkt->skb);
+	overquota = nft_overquota(priv, pkt->skb, &report);
 	if (overquota ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 
-	if (overquota &&
+	if (report &&
 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
 		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
 			       NFT_MSG_NEWOBJ, 0, nft_pf(pkt), 0, GFP_ATOMIC);
-- 
2.39.5



