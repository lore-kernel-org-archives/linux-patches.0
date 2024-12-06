Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF85E2E859;
	Fri,  6 Dec 2024 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497220; cv=none; b=lwU/Tj/zxpFfMXQrYhCgiRXwTXYVCXfGS9+p9ytawaNY+3SzMDx3PEtQTYafZBm88+0se118zhwfKVy1n0+KmmkfifTccNJvgjW3C+x2B1fjXABrDsyPwrKK8C5dMqm8WZCzOOivlPBhgBi39K+PccT6nm+ScBsR4MF50De4+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497220; c=relaxed/simple;
	bh=McKrHZHUqCD44CMG6KVYCI4se5HG/Zg9AisYFfPz2JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rchEN9IWM5E/T/m2phgD/byqMn0Uzsl6/GVOh4kawA7/imhQXbowYQtRG3JSQUCSNmAozXTLF8vskDtX1OfxcmML84qgxsTdBPGrShlfDE9dEU8X5+4aHpIPZrfIpXWItGP310dmkmXu8WPC3OEi84iC1ww7WPHFZcfoFwM5UCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bflJnem/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bflJnem/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFC7C4CED1;
	Fri,  6 Dec 2024 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497219;
	bh=McKrHZHUqCD44CMG6KVYCI4se5HG/Zg9AisYFfPz2JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bflJnem/bW/CfLFB9iDlE/4aChiJoRX+1apQUZ9HLFOzYjxUOTybdzU6ZniHQuB6v
	 X6NSSsEX1uneSXB9m+m/q6LjRRUlhELmpDGSe+b1B+v+VAUienz5jHXujCbzWKwoad
	 Z0Rwnja4lpHE4hnicJqxAZSxnSm4EEG7zFcfercQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/676] netfilter: nf_tables: must hold rcu read lock while iterating expression type list
Date: Fri,  6 Dec 2024 15:30:48 +0100
Message-ID: <20241206143702.279884983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ee666a541ed957937454d50afa4757924508cd74 ]

nft shell tests trigger:
 WARNING: suspicious RCU usage
 net/netfilter/nf_tables_api.c:3125 RCU-list traversed in non-reader section!!
 1 lock held by nft/2068:
  #0: ffff888106c6f8c8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x3c/0xf0

But the transaction mutex doesn't protect this list, the nfnl subsystem
mutex would, but we can't acquire it here without risk of ABBA
deadlocks.

Acquire the rcu read lock to avoid this issue.

v3: add a comment that explains the ->inner_ops check implies
expression is builtin and lack of a module owner reference is ok.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 11fe424d9c93a..5c4cd9646e71c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3231,25 +3231,37 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 	if (!tb[NFTA_EXPR_DATA] || !tb[NFTA_EXPR_NAME])
 		return -EINVAL;
 
+	rcu_read_lock();
+
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-	if (!type)
-		return -ENOENT;
+	if (!type) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
 
-	if (!type->inner_ops)
-		return -EOPNOTSUPP;
+	if (!type->inner_ops) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
 
 	err = nla_parse_nested_deprecated(info->tb, type->maxattr,
 					  tb[NFTA_EXPR_DATA],
 					  type->policy, NULL);
 	if (err < 0)
-		goto err_nla_parse;
+		goto out_unlock;
 
 	info->attr = nla;
 	info->ops = type->inner_ops;
 
+	/* No module reference will be taken on type->owner.
+	 * Presence of type->inner_ops implies that the expression
+	 * is builtin, so it cannot go away.
+	 */
+	rcu_read_unlock();
 	return 0;
 
-err_nla_parse:
+out_unlock:
+	rcu_read_unlock();
 	return err;
 }
 
-- 
2.43.0



