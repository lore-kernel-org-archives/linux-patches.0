Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4015436342;
	Mon, 17 Aug 2026 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974088; cv=none; b=Y9lXEZEajZnWUqnc990KVveO7rjk9d9TBeKVO4KO/GiHpjvf894JhE9AXtNaz9wK9ut672eaY51CCArRvUySpPwhPrUfz7/hTMUluZcfd2BPNpThl0ShTp5CYyF8uPDU7FHILmikLqW5L4T9fjwBUKSBlriEQvF3uMER1x5LSJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974088; c=relaxed/simple;
	bh=tmfe5ZpujwC90oK3G7zVbSvrZMBCAHA844fv0Dh9gHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMcrz2GZbyf3AoSRENXs80tqh4mXOZ39CNFyL2OguIRsthQXtw+AM03lW7z+i/qpgttrDa7Uia1OhgKrX20C5Ke1ifuru76ylLorA3Bp035VuYdIk5moy4FWzsOzEogVMfWijkZhdt4Fq1Qg6xirwJMDEhJjWRLBq/pOo8iYcTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXbw4owg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXbw4owg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6821F00ACA;
	Mon, 17 Aug 2026 13:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974083;
	bh=2MwlCA7ViS/hI6MQYyF3pOz8p6CPksKPVPpct4huigo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXbw4owgT0igXi5cJl9pMVpOTu4yT38lsu+UFdEo67jmPS0DcsEYzkPQjpbuYXSf0
	 r4GMEe1WlP3KsMZC4mvZ+yEAkO/guqwShPANXW4EaQL0QFeOx9cOAsUsxxcmB6XFjg
	 EAimy5oMC5ZifCpdBNmYdKO6nsQo4m7uWYcOyyXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 043/271] netfilter: ipset: switch ext_size to atomic64_t
Date: Mon, 17 Aug 2026 15:29:28 +0200
Message-ID: <20260817132538.511664967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b98331572ad29..cadae9b2578f1 100644
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
index bb9b5bed10e19..226fdf17b6832 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	set->ext_size = 0;
+	atomic64_set(&set->ext_size, 0);
 }
 
 /* Calculate the actual memory size of the set data */
@@ -93,7 +93,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
+	size_t memsize = mtype_memsize(map, set->dsize) + atomic64_read(&set->ext_size);
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6cfad152d7d1b..822a53a7f502a 100644
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
index a3ed683cc47e7..3072b4e288537 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1288,7 +1288,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	mtype_ext_size(set, &elements, &ext_size);
-	memsize = mtype_ahash_memsize(h, t) + ext_size + set->ext_size;
+	memsize = mtype_ahash_memsize(h, t) + ext_size + atomic64_read(&set->ext_size);
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 1cef84f15e8c7..ca3ef9479e838 100644
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



