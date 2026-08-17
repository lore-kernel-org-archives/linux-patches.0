Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B444483AA;
	Mon, 17 Aug 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980318; cv=none; b=Jc2rIHIrj6/GAAd9xlrrnDm/OUlrYNfsfZVLuBBck4CRijDy8Ry2qWreXtZFp9uawq7WmoJP7y4YAReqKaYH7wuj5tQaR/TgL1uZOOee2425NJjtLJGKnomgPlaYaTtu+iBxoqjW4bCldfDjCWDxG2x8w4pbUx/+EDGZN0A3pU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980318; c=relaxed/simple;
	bh=FIO5cAqXYCwBq9IxZ/cU6w44IVFXC74w1pzo45FV5v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUOmEzBShfsEwUz/3vD0+vH/59yNhRGraxqFfM6nGNsiweJMSsnBh1tEcwMuS0O7xYIQFFPs+qHLZ/Dl/tUGVXl2GbBjl8/8U9NRUeKGu3hon0emNdIdCifaZm4hrB7KKiaj1q7misUOiKRI+LXc0PwwVb1K9LmgYsaFPLF4pH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGfA6STv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGfA6STv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825C81F000E9;
	Mon, 17 Aug 2026 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980317;
	bh=rz34kr6OWl3PEPkq5vK3QxEIWp95KtwE4oenlxE1Jr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGfA6STvjAYNL/EItcztUNVdaGA6aawyGCVonbpncDajMhnaPRJeddz9XEtRD3HQT
	 r0q1998OAqnX+ui3o+iANZVMmBCKkX6U+AUdUqk7nyqhhaNrH7wWSyc3N5xBlYluuT
	 3i8KPNp1DLJn+FVFaMpNsfgmVSqkniaUIRD8XRRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 492/609] netfilter: ipset: switch ext_size to atomic64_t
Date: Mon, 17 Aug 2026 15:33:08 +0200
Message-ID: <20260817132600.375537364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 712a6f545c359b427daa9a5a782e30d2f8331e25 ]

The hash types do not acquire set->lock, they use 'region locking' where
only part of the hash table is locked. Parallel inserts and deletes are
possible and CPUs can race on ->ext_size update.  Switch to atomic64_t.

This leaves another bug unresolved: there still can be a race on
comment extension re-init.  This will be handled in a later commit
when converting to rhashtable backend.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/ipset/ip_set.h  | 2 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h | 4 ++--
 net/netfilter/ipset/ip_set_core.c       | 6 +++---
 net/netfilter/ipset/ip_set_hash_gen.h   | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index d82413e6098a7..b2ee80b4b0d39 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -273,7 +273,7 @@ struct ip_set {
 	/* Number of elements (vs timeout) */
 	u32 elements;
 	/* Size of the dynamic extensions (vs timeout) */
-	size_t ext_size;
+	atomic64_t ext_size;
 	/* Element data size */
 	size_t dsize;
 	/* Offsets to extensions in elements */
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 9523104a90da4..40f0383883f9d 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -75,7 +75,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	set->ext_size = 0;
+	atomic64_set(&set->ext_size, 0);
 }
 
 /* Calculate the actual memory size of the set data */
@@ -91,7 +91,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
+	size_t memsize = mtype_memsize(map, set->dsize) + atomic64_read(&set->ext_size);
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 1d6579358f9ba..7601e4ca02775 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -350,7 +350,7 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
 	if (unlikely(c)) {
-		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+		atomic64_sub(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
 		rcu_assign_pointer(comment->c, NULL);
 		kfree_rcu(c, rcu);
 	}
@@ -362,7 +362,7 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	if (unlikely(!c))
 		return;
 	strscpy(c->str, ext->comment, len + 1);
-	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
+	atomic64_add(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
 	rcu_assign_pointer(comment->c, c);
 }
 EXPORT_SYMBOL_GPL(ip_set_init_comment);
@@ -392,7 +392,7 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	c = rcu_dereference_protected(comment->c, 1);
 	if (unlikely(!c))
 		return;
-	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+	atomic64_sub(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
 	rcu_assign_pointer(comment->c, NULL);
 	kfree_rcu(c, rcu);
 }
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index de9f291ff8c28..6588571648ead 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1276,7 +1276,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	mtype_ext_size(set, &elements, &ext_size);
-	memsize = mtype_ahash_memsize(h, t) + ext_size + set->ext_size;
+	memsize = mtype_ahash_memsize(h, t) + ext_size + atomic64_read(&set->ext_size);
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 7d1ba6ad514f5..bc37bc59e2828 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -421,7 +421,7 @@ list_set_flush(struct ip_set *set)
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
 	set->elements = 0;
-	set->ext_size = 0;
+	atomic64_set(&set->ext_size, 0);
 }
 
 static void
@@ -455,7 +455,7 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct list_set *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = list_set_memsize(map, set->dsize) + set->ext_size;
+	size_t memsize = list_set_memsize(map, set->dsize) + atomic64_read(&set->ext_size);
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
-- 
2.53.0



