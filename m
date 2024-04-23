Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C6F14533C;
	Tue, 23 Apr 2024 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908579; cv=none; b=oHmkxIPAHCeu1tESiAS2T9vZkJJyTcAVE70Fuia53LCBQVCMazxuB1lXUzI2Q1uj18coFKFYhTXy0zCdgQy112gjHqKr2QAJvqrr+rEsbN66X7hYwYXDexq8INl4JZ9CbFyZdRQPswOe4F5yYRWKLFSkCuPyGxXO8pMA2Dg0P20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908579; c=relaxed/simple;
	bh=uq7Jb30LJHbtl8fzz/1kVD38e/xjU98Y28YrTK14Oo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4rGIkNU+DmqMgMaYKWAyx6M1KUBGrFVkW31AQgedgWyt1OCVYxr5537ytKSGlL/bqw4cbPcLEdNUAxkW0oc+n3FNUM7w9ulGoIc9cpk0LIr9evkHP4O1qcVdjFOSSMtYYA4O9x2hdHZhxHrjeOImC5Z6NMf4e5OgJ6tFXUryx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rtncezi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rtncezi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D62C32782;
	Tue, 23 Apr 2024 21:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908578;
	bh=uq7Jb30LJHbtl8fzz/1kVD38e/xjU98Y28YrTK14Oo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rtncezi8z57xKkDlOLrTwDQkmqvcvLa/vZHQu9eXZCb0bpRiacTlDFyeS3XutWVs
	 FCnxMAwTZ+YjgonpFvIT/C7lWsT+BHg3qEbYxm9yxA+NRxnVz/TtQBgJVsMpY/7lTZ
	 sKrjL59NP6h0q43siv6TvtPqNCDT/QIdFaDHVfyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/158] netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()
Date: Tue, 23 Apr 2024 14:37:50 -0700
Message-ID: <20240423213856.821763538@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit f969eb84ce482331a991079ab7a5c4dc3b7f89bf ]

nft_unregister_expr() can concurrent with __nft_expr_type_get(),
and there is not any protection when iterate over nf_tables_expressions
list in __nft_expr_type_get(). Therefore, there is potential data-race
of nf_tables_expressions list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_expressions
list in __nft_expr_type_get(), and use rcu_read_lock() in the caller
nft_expr_type_get() to protect the entire type query process.

Fixes: ef1f7df9170d ("netfilter: nf_tables: expression ops overloading")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2a4649df8f086..fe6ee16e2dbf4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3047,7 +3047,7 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 {
 	const struct nft_expr_type *type, *candidate = NULL;
 
-	list_for_each_entry(type, &nf_tables_expressions, list) {
+	list_for_each_entry_rcu(type, &nf_tables_expressions, list) {
 		if (!nla_strcmp(nla, type->name)) {
 			if (!type->family && !candidate)
 				candidate = type;
@@ -3079,9 +3079,13 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
+	rcu_read_lock();
 	type = __nft_expr_type_get(family, nla);
-	if (type != NULL && try_module_get(type->owner))
+	if (type != NULL && try_module_get(type->owner)) {
+		rcu_read_unlock();
 		return type;
+	}
+	rcu_read_unlock();
 
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
-- 
2.43.0



