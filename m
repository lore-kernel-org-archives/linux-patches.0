Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E5A1F76AD;
	Tue,  3 Dec 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241008; cv=none; b=FfIKaaSLzQiUh/l11tUjLbj8+PoDe+zQp5yI+RCCpZ0/ATb9vsHU5LM6t+OBQnTmEWVmlPPBmVhv317wZ5bRllk1qnhuPAgWWlkC+iHLhNbJ3FYXWbk1D6+bGP1ec0yl1PEzbXttGACAID3s0rtF3YBW/XdABChCrUEsd6TgfVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241008; c=relaxed/simple;
	bh=Lo1OjfQGflfCl5E/LfGUki7VnnzVlQigi/DVSADHk7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQScipywh/JishCrF5u2HzaD8XY50SPpTjuiixcYd5CFjwCyI+9EJd9xLmXTyjgfzRIVs/zWCWdwH2aMggrPYXdByj1An3760id9pZf18HOV8yDcsjJEvhbIobQKbBH9+liwS82cXBG4xxzLF+s5d3xLws9oojT0Dx0fMvp4Thk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n41a6CK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n41a6CK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8779C4CECF;
	Tue,  3 Dec 2024 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241008;
	bh=Lo1OjfQGflfCl5E/LfGUki7VnnzVlQigi/DVSADHk7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n41a6CK5yIRyNTYemOeJmg3s2FycA08Kklie1E1LOeL57io5NjKd4Xb2+BuHnlUBD
	 La9F4m4ghv9ZAq8rntl3iSUmkd4k3RorQ/pknwaK2dM+ktdEyD6z11toUdjS48t+zt
	 gthRZdPDoMraGOwMH5SL3JLvXPa6Mm5GIXAcoiig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/826] netfilter: nf_tables: must hold rcu read lock while iterating expression type list
Date: Tue,  3 Dec 2024 15:40:26 +0100
Message-ID: <20241203144755.429690406@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index deb4a91808598..895e23d0dc36d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3295,25 +3295,37 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
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



