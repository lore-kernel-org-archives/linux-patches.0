Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518B35172EC;
	Wed, 30 Sep 2026 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784863; cv=none; b=oiMup4I45SosHUD9sEjNeqs/HOq90tL+zGkcB3avAHaQHEZqw0OBHUHbkzcWq7WlpxeG/ma8+GISDa5ZwJt0DwwxF7rNkJ38l66cFgr03wNixWd9wmXY9S4Awu63xCEGUrNW0zehqLvIWqjRZPxthfIo4nyL6qPulElKBZf2gSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784863; c=relaxed/simple;
	bh=KKARSUF+BLvnN52yzdx4KgBiNmiqftyja771lJQObow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ddl+HAqRk+jf2sS+l9iht2WuSC9ffofELKgDttVAFf+U/FLA6mFvnoxKWQOgE8HUOqRn08UWPCuz4SqhT/+f7WGhGmJjZT+ch+uXsPaFDt7twCjDUpgnExwNEHwR5djfMFMXUh2CMfaZKO7Rdj0TGHiDGPbLFuGUuJm7VMfsygM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbgt8zuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbgt8zuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394151F00898;
	Wed, 30 Sep 2026 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784855;
	bh=BkDnPDcuaA8L1tNGX6zl1ah9CPs0S1op6pNOzFXpZBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dbgt8zuYPKgsA5A5qrsvSTDctDXvnhbStQp+ID6zYSdvFasr2EoaIEDbhH8/OL4pN
	 rOYnacDBVTYAGufGBa1lM336eVaaWlByNRIu+eaZ1FLP6chPI/iGjoKxui5AmheSmz
	 MwOTp214spyNlftHWzs+3sS2FVVjIWZWc4c5gpZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/982] netfilter: ipset: mark the rcu locked areas properly
Date: Wed, 30 Sep 2026 17:16:34 +0200
Message-ID: <20260930152422.336967013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

[ Upstream commit 5d0c22e73656d050daffad10a2ba8765ce8441c8 ]

When we bump the uref counter, there's no need to keep
the rcu lock because the referred hash table can't
disappear. Also, from the same reason in mtype_gc we
need the rcu lock and not a spinlock.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6588571648ead..a4ec28b223c4d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -556,9 +556,10 @@ mtype_gc(struct work_struct *work)
 	set = gc->set;
 	h = set->data;
 
-	spin_lock_bh(&set->lock);
-	t = ipset_dereference_set(h->table, set);
+	rcu_read_lock_bh();
+	t = rcu_dereference_bh(h->table);
 	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
 	numof_locks = ahash_numof_locks(t->htable_bits);
 	r = gc->region++;
 	if (r >= numof_locks) {
@@ -567,7 +568,6 @@ mtype_gc(struct work_struct *work)
 	next_run = (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
 	if (next_run < HZ/10)
 		next_run = HZ/10;
-	spin_unlock_bh(&set->lock);
 
 	mtype_gc_do(set, h, t, r);
 
@@ -847,15 +847,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	key = HKEY(value, h->initval, t->htable_bits);
 	r = ahash_region(key);
 	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
 	if (elements >= maxelem) {
 		u32 e;
-		if (SET_WITH_TIMEOUT(set)) {
-			rcu_read_unlock_bh();
+		if (SET_WITH_TIMEOUT(set))
 			mtype_gc_do(set, h, t, r);
-			rcu_read_lock_bh();
-		}
 		maxelem = h->maxelem;
 		elements = 0;
 		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
@@ -863,7 +861,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (elements >= maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
-	rcu_read_unlock_bh();
 
 	spin_lock_bh(&t->hregion[r].lock);
 	n = rcu_dereference_bh(hbucket(t, key));
-- 
2.53.0



