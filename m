Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB336143C5F;
	Tue, 23 Apr 2024 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908772; cv=none; b=oUdv4iV07jm06NqKu8Ijon9uVdFMFhJBUPdY+nOT2WLxxonUkF0NVF/vQnPJwZnhYLyvf157APpxhuJKWVrFmhgl6fMmtTNTCmafjqD98UqLHj/5VWmBzY2z9m+ufY01eg1dLseHn/K+v2vXK8yI++vpYUeV4V5AxBZpWf3L6ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908772; c=relaxed/simple;
	bh=if+bOVbHuK4VIidfWsYabxUBx0GHCS3a3un9gUOBMp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwcQYYmcCK7X/oaM2EuP8U59HEXMbNzzyxVN9P0/BF93d0IZj3jlxDSukE3/VqUicjX4eDYtnyn2679SW9ZWjXXYf2gCppB2B3W3zBwifq2O8eV4zkE8RDYt5WtjhKip85CRiTIQKXjN85jEf90qqGmdnQb/DvfHozJWR7Ys+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foB7HUtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foB7HUtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0518C3277B;
	Tue, 23 Apr 2024 21:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908771;
	bh=if+bOVbHuK4VIidfWsYabxUBx0GHCS3a3un9gUOBMp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foB7HUtuyBfgDprxnmttNs5cGCYwsKpKbIqDVTcsck0BtCDt1z3VsHBfKoKqLSBPR
	 QJ8HqJjGpM6pfRgKcc33/+glPLtYrbvwMZlrq6nAhM+rq+2JrrPBeg87uI91PHacOr
	 ngT8epVOGiwup1ic8AQq/+DmdXfHpK2ECmyH7FrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/71] netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()
Date: Tue, 23 Apr 2024 14:39:28 -0700
Message-ID: <20240423213844.646362225@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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
index 113c1ebe4a5be..d0712553d2b06 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2821,7 +2821,7 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 {
 	const struct nft_expr_type *type, *candidate = NULL;
 
-	list_for_each_entry(type, &nf_tables_expressions, list) {
+	list_for_each_entry_rcu(type, &nf_tables_expressions, list) {
 		if (!nla_strcmp(nla, type->name)) {
 			if (!type->family && !candidate)
 				candidate = type;
@@ -2853,9 +2853,13 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
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



