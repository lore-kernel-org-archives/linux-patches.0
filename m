Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11D7285045;
	Tue, 17 Jun 2025 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177019; cv=none; b=X1fkB4onDmc043we4YZHM4pnHMLz2ZlHXjqreCgkNGZbUBDXxSplhLAvIFyzeic8Ym1FAVr/6LzxRXLv9F1fn1ZMlj9G3NCd+2wxVYf1BZM3vBWhLMuuFv+PA4tKMHrs/PsvMjOZi8GJwX4esthSBSVUvv64TYS/AYLrUh/Ey00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177019; c=relaxed/simple;
	bh=SQRTIeqF5S7Jyn4kyXc1XRZdfrgjHIoZc+fAG5iOJm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+SU57bJs6ISGjesi/BmJfVxkYt/JOHzHwDg1lG6vaEVYo1JFV7z3UyxGXw9pwbkI+K2D1LA6UIQawhsAf9V58y08Fu+AqIvC45m5dklcrXF43mnwrSBR93o9FSISJsUT1HSmPtotHQzzoO2K0sWzjWh6X06hsVbgWfV4PcH7Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikg19snG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikg19snG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40956C4CEE3;
	Tue, 17 Jun 2025 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177019;
	bh=SQRTIeqF5S7Jyn4kyXc1XRZdfrgjHIoZc+fAG5iOJm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikg19snG4B95ANtGMIY8RQYHw6gIOzehNla9ES35Mn1iH4sUIxtAHzFEJuSKGLRiq
	 DErlL+L1CdN4FrqKldiO18BUxpvQLBX+0DgHL4btzHi4Gc5kU2UzVDKAc8yAOjJrya
	 CoI5uYf0tCroYAD0fUsclZ4FMvn+pVP9OIABc09w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 236/780] netfilter: nft_quota: match correctly when the quota just depleted
Date: Tue, 17 Jun 2025 17:19:04 +0200
Message-ID: <20250617152501.070442586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9b2d7463d3d32..df0798da2329b 100644
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



