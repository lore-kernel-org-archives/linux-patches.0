Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B4A143899;
	Tue, 23 Apr 2024 21:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908456; cv=none; b=CVyM733Wh1427EIGtKBvoKEDfwqn1PYeamUCGvEGzH6zigUsLvA6qTwAQ6D7bFDydCsWeNHUCFM6dU5u6vZ0uZ+zKmmOjniuNI/al4Hicvs8ceZN/ETz/z2gWAecvDC3gLwa4dFk1RV9oKima6AKc/Ck0HnkIJXx1XnryZijaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908456; c=relaxed/simple;
	bh=6NnAVk92qdWyqR5FL2LMa1ksbZaiE/vZ6O3zWmpbHUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Acr5Yf9xnFv3WI2aXNpTXUgeuTLRjTkUIMuC2zSuG3ul10AmXFjsWvkw3ne2g6PdrlLfmFQ6AaOAaptNWtdPHG0GU4dl5hVwOE90z4YhlhWW/1YceTJKY2YAjcDJddAMGMsnEAR4NBIeljRDNX7t/9zx13r9COXjw7vwqNdG+rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtTgAPtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtTgAPtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EE5C3277B;
	Tue, 23 Apr 2024 21:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908456;
	bh=6NnAVk92qdWyqR5FL2LMa1ksbZaiE/vZ6O3zWmpbHUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtTgAPtKlSu5HJqmhLmdvi/+vlhmZC9ip5jFkuhy9O3hzdwjWgwRmYuoAvQ1Kz+tC
	 ok5Z1hQ+Y9vImzwGjtPJnbimTIk3G1oLajILb6XhJCk3pN1YVbmwkqR3t+oJPs2kBG
	 qNVSYgdKHLx+Qok7kObKTRNFgkCtQTX74MSgPdo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 015/158] netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()
Date: Tue, 23 Apr 2024 14:37:17 -0700
Message-ID: <20240423213856.343400316@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index a1cf875e5d35f..ad9fb019684b3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7607,7 +7607,7 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
-	list_for_each_entry(type, &nf_tables_objects, list) {
+	list_for_each_entry_rcu(type, &nf_tables_objects, list) {
 		if (type->family != NFPROTO_UNSPEC &&
 		    type->family != family)
 			continue;
@@ -7623,9 +7623,13 @@ nft_obj_type_get(struct net *net, u32 objtype, u8 family)
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



