Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67633149C4D;
	Tue, 23 Apr 2024 21:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908688; cv=none; b=t6vTwKisJqvVhebLGO88Wdtco6vyY95Fy1pVMUe1NGZoOOrFJiowOGMdbQh8zH3qokxwaeVRjnaQ8rVMnsFgZhMLyqo/K3+dzHcxnU35ZlROUnn5787f3+mzgqrmTR4Btjfe5eI/77xih1CLen+WnmyPoGo0sjJp+EpcQeqek3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908688; c=relaxed/simple;
	bh=GvVJjg+fREEsvivMaLt5Km6B/4u/Nbb4cJyOJjRbZZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi5VopfuqfPUHA9Kan7+k3MuHdjfdi6cqFFQ3Fj5GkzA7YForZU9Ej/dYfwk1axvPuciVCeZHVJoirGwE1NMYuB7MkyuDOyfevP5jH9gudB/rCZcUQpmOpd9t5N+83R62wIsmghhQQKSN6O/OpIxUeSECWoLuFTXjairOsB9rIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQPPIz5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQPPIz5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DBFC3277B;
	Tue, 23 Apr 2024 21:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908688;
	bh=GvVJjg+fREEsvivMaLt5Km6B/4u/Nbb4cJyOJjRbZZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQPPIz5OWN5Lz2lVbt96TTWX6jfhHemKex7R1C5vLNzkREJc4szvyN7bmsztMtAVf
	 CA/w+5AlCwt5ypdDkbm9p92K4sf1JX2Alvc9yMQaJbFquZsWlGKt7y7aBOX8hJKLKn
	 rMZSMZ7BUo1sKDSx/fpttQyCnVbE5FOd2fp62Oa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/141] netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()
Date: Tue, 23 Apr 2024 14:38:23 -0700
Message-ID: <20240423213854.438581428@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit d78d867dcea69c328db30df665be5be7d0148484 ]

nft_unregister_obj() can concurrent with __nft_obj_type_get(),
and there is not any protection when iterate over nf_tables_objects
list in __nft_obj_type_get(). Therefore, there is potential data-race
of nf_tables_objects list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_objects
list in __nft_obj_type_get(), and use rcu_read_lock() in the caller
nft_obj_type_get() to protect the entire type query process.

Fixes: e50092404c1b ("netfilter: nf_tables: add stateful objects")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ba63866914f18..1c4b7a8ec2cc6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7175,7 +7175,7 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
-	list_for_each_entry(type, &nf_tables_objects, list) {
+	list_for_each_entry_rcu(type, &nf_tables_objects, list) {
 		if (type->family != NFPROTO_UNSPEC &&
 		    type->family != family)
 			continue;
@@ -7191,9 +7191,13 @@ nft_obj_type_get(struct net *net, u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
+	rcu_read_lock();
 	type = __nft_obj_type_get(objtype, family);
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



