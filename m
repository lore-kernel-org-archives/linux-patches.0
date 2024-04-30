Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781EA7464;
	Tue, 30 Apr 2024 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474793; cv=none; b=dKh3+INN6FgxMa/MS6y6rqhV29sFOZmMvJk8kEpUVofR8x5MR1F1iQlsIEA8NES0l+zyHB5zasZ438S/HCSlGfDk1k/zoVnSJf+TcqQoPnFu2/swbYcMYl/epmF8mcpD9y8d3r/pps1DulzmftW/Swisq9k9y7ELbiaXer3AxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474793; c=relaxed/simple;
	bh=QE0ozTjOGAqffMoR7bJCZEq1hXarnmqW90mZxp1nUjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la5eqLmUUAVHiEKWZC3V7zKs8OksgfMBfEjNolhaWyybfMrQwMqPySwO3CpLKkwsZ1n4E8xy72nj1q7IOcRvZh33gIAoaiMBzXI+BqXcHXbJwdhQ0yg+KF/+wDp5t1AKkex1Q1z1YC26PmTNzsdqbo5wfnQX7LoflSuk5n4k0cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7PCsvtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7PCsvtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF22C2BBFC;
	Tue, 30 Apr 2024 10:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474793;
	bh=QE0ozTjOGAqffMoR7bJCZEq1hXarnmqW90mZxp1nUjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7PCsvtOJrmMws18u1kuf6OX25JOLHfTY/fYy26O4U+84Mf71Wq8poRe9SnivBr5b
	 prCWONTUgZNXTHgraxJuQxYneIgeLIsVEvDoZhJYhIbNDpmHmcjDjtk0HwZeropRlA
	 DDqE5OtfHywDQoD8kNR+Sl9ww2oxQuNpnrF395OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/138] netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()
Date: Tue, 30 Apr 2024 12:38:41 +0200
Message-ID: <20240430103050.495694063@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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
index ab7f7e45b9846..858d09b54eaa4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2739,7 +2739,7 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 {
 	const struct nft_expr_type *type, *candidate = NULL;
 
-	list_for_each_entry(type, &nf_tables_expressions, list) {
+	list_for_each_entry_rcu(type, &nf_tables_expressions, list) {
 		if (!nla_strcmp(nla, type->name)) {
 			if (!type->family && !candidate)
 				candidate = type;
@@ -2771,9 +2771,13 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
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



