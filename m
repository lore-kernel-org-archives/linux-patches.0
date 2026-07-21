Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35B046EC63;
	Tue, 21 Jul 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656335; cv=none; b=F2xClRNpZPzZsFluxbpZ5R8Z9UlaW0l2u2si1ORriCgCZf+m51BLT5VkaO10LbhG+AjxBHLz1zt0RrCOpa5BYmIq2j3i2AoML3LGQPcYM0iKGZ4GIWG+5j45hS2bdT9m6qbQ0o1hrxTciFW8+FnWL6BGNlJp1OEY7fzKAadswgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656335; c=relaxed/simple;
	bh=v/Vc8SsfmmpWlAe+lLc8q5WI4onSJv/SlSjEgLfFly8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPzZ/Khf5GwFQbdHLE0pwnGp3avQi2osbGyGbFZjdh3pO7CKJhXYDeVbmWiAmknrPtLOVV9cWh0O8+be1Vq8neQTiqeRebirqDRCWK79FeMVZv4cd9f+vCcQpPiIf1lniyWq641BQGSXzXnXj6GmsJ050YFde3CmIPx6RgtTfU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck0QvCsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck0QvCsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648D61F000E9;
	Tue, 21 Jul 2026 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656333;
	bh=c7n7cfg7X9iO+lDyp6skj1Y7ofWAvHxxawAXQXhjZG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ck0QvCsZUuGcVPm4odgUblttHQH50cTxzZ2foCDjck7jD4cdvWhhsM34UGLN69Q/J
	 LnA/OpkGiRHeBrTkepOcrUqUj4WT2QSwcAnbdd40hpQre99kV3zCdACHMoVnrD0z3j
	 gQ7FGVZwVUYmpR/fZ2Ii7Ta3CtMnrPrU6h0a/qYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0348/1611] netfilter: conntrack: revert ct extension genid infrastructure
Date: Tue, 21 Jul 2026 17:07:44 +0200
Message-ID: <20260721152522.955156148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 35e21a4dccc5c255ba59ccfbfeb4629ed21da972 ]

This infrastructure is not used anymore after moving ct timeout and
helper to use datapath refcount to track object use.

Revert commit c56716c69ce1 ("netfilter: extensions: introduce extension
genid count") this patch disables all ct extensions (leading to NULL)
for unconfirmed conntracks, when this is only targeted at ct helper and
ct timeout. There is also codebase that dereferences the ct extension
without checking for NULL which could lead to crash.

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_extend.h | 12 ----
 net/netfilter/nf_conntrack_core.c           | 61 +--------------------
 net/netfilter/nf_conntrack_extend.c         | 32 +----------
 3 files changed, 2 insertions(+), 103 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 0b247248b03239..fd5c4dbf72caf7 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -38,7 +38,6 @@ enum nf_ct_ext_id {
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
-	unsigned int gen_id;
 	char data[] __aligned(8);
 };
 
@@ -52,8 +51,6 @@ static inline bool nf_ct_ext_exist(const struct nf_conn *ct, u8 id)
 	return (ct->ext && __nf_ct_ext_exist(ct->ext, id));
 }
 
-void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id);
-
 static inline void *nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 {
 	struct nf_ct_ext *ext = ct->ext;
@@ -61,19 +58,10 @@ static inline void *nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 	if (!ext || !__nf_ct_ext_exist(ext, id))
 		return NULL;
 
-	if (unlikely(ext->gen_id))
-		return __nf_ct_ext_find(ext, id);
-
 	return (void *)ct->ext + ct->ext->offset[id];
 }
 
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
-/* ext genid.  if ext->id != ext_genid, extensions cannot be used
- * anymore unless conntrack has CONFIRMED bit set.
- */
-extern atomic_t nf_conntrack_ext_genid;
-void nf_ct_ext_bump_genid(void);
-
 #endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 18e52dcd22990e..3bb08880f3a4de 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -836,33 +836,6 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 			   &nf_conntrack_hash[reply_hash]);
 }
 
-static bool nf_ct_ext_valid_pre(const struct nf_ct_ext *ext)
-{
-	/* if ext->gen_id is not equal to nf_conntrack_ext_genid, some extensions
-	 * may contain stale pointers to e.g. helper that has been removed.
-	 *
-	 * The helper can't clear this because the nf_conn object isn't in
-	 * any hash and synchronize_rcu() isn't enough because associated skb
-	 * might sit in a queue.
-	 */
-	return !ext || ext->gen_id == atomic_read(&nf_conntrack_ext_genid);
-}
-
-static bool nf_ct_ext_valid_post(struct nf_ct_ext *ext)
-{
-	if (!ext)
-		return true;
-
-	if (ext->gen_id != atomic_read(&nf_conntrack_ext_genid))
-		return false;
-
-	/* inserted into conntrack table, nf_ct_iterate_cleanup()
-	 * will find it.  Disable nf_ct_ext_find() id check.
-	 */
-	WRITE_ONCE(ext->gen_id, 0);
-	return true;
-}
-
 int
 nf_conntrack_hash_check_insert(struct nf_conn *ct)
 {
@@ -878,9 +851,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext))
-		return -EAGAIN;
-
 	local_bh_disable();
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
@@ -914,18 +884,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 			goto chaintoolong;
 	}
 
-	/* If genid has changed, we can't insert anymore because ct
-	 * extensions could have stale pointers and nf_ct_iterate_destroy
-	 * might have completed its table scan already.
-	 *
-	 * Increment of the ext genid right after this check is fine:
-	 * nf_ct_iterate_destroy blocks until locks are released.
-	 */
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		err = -EAGAIN;
-		goto out;
-	}
-
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
@@ -1253,11 +1211,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		return NF_DROP;
 	}
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC(net, insert_failed);
-		goto dying;
-	}
-
 	/* We have to check the DYING flag after unlink to prevent
 	 * a race against nf_ct_get_next_corpse() possibly called from
 	 * user context, else we insert an already 'dead' hash, blocking
@@ -1320,16 +1273,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
 
-	/* ext area is still valid (rcu read lock is held,
-	 * but will go out of scope soon, we need to remove
-	 * this conntrack again.
-	 */
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		nf_ct_kill(ct);
-		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return NF_DROP;
-	}
-
 	help = nfct_help(ct);
 	if (help && help->helper)
 		nf_conntrack_event_cache(IPCT_HELPER, ct);
@@ -2436,13 +2379,11 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	 */
 	synchronize_net();
 
-	nf_ct_ext_bump_genid();
 	iter_data.data = data;
 	nf_ct_iterate_cleanup(iter, &iter_data);
 
 	/* Another cpu might be in a rcu read section with
-	 * rcu protected pointer cleared in iter callback
-	 * or hidden via nf_ct_ext_bump_genid() above.
+	 * rcu protected pointer cleared in iter callback.
 	 *
 	 * Wait until those are done.
 	 */
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index dd62cc12e77507..0da105e1ded939 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -27,8 +27,6 @@
 
 #define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
-atomic_t nf_conntrack_ext_genid __read_mostly = ATOMIC_INIT(1);
-
 static const u8 nf_ct_ext_type_len[NF_CT_EXT_NUM] = {
 	[NF_CT_EXT_HELPER] = sizeof(struct nf_conn_help),
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -118,10 +116,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!new)
 		return NULL;
 
-	if (!ct->ext) {
+	if (!ct->ext)
 		memset(new->offset, 0, sizeof(new->offset));
-		new->gen_id = atomic_read(&nf_conntrack_ext_genid);
-	}
 
 	new->offset[id] = newoff;
 	new->len = newlen;
@@ -131,29 +127,3 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
-
-/* Use nf_ct_ext_find wrapper. This is only useful for unconfirmed entries. */
-void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id)
-{
-	unsigned int gen_id = atomic_read(&nf_conntrack_ext_genid);
-	unsigned int this_id = READ_ONCE(ext->gen_id);
-
-	if (!__nf_ct_ext_exist(ext, id))
-		return NULL;
-
-	if (this_id == 0 || ext->gen_id == gen_id)
-		return (void *)ext + ext->offset[id];
-
-	return NULL;
-}
-EXPORT_SYMBOL(__nf_ct_ext_find);
-
-void nf_ct_ext_bump_genid(void)
-{
-	unsigned int value = atomic_inc_return(&nf_conntrack_ext_genid);
-
-	if (value == UINT_MAX)
-		atomic_set(&nf_conntrack_ext_genid, 1);
-
-	msleep(HZ);
-}
-- 
2.53.0



