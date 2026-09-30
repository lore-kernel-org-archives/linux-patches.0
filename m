Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF154DAF9B;
	Wed, 30 Sep 2026 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782817; cv=none; b=dmxSQk3LRm9TY0phkPhRvbm/7a8kDusFlGhBOI8MV6Ec5sqmRMg6B2WcxEo+OY6Nk/vU+QIDlukEpZtTy7i2yms31cm97Awp7UCQwyb1Q3au/mfFJtnXVJNI82fxMJSqf8S7eVeP/LDaAG/cOYUxVs4OMM6u9pX+buPFc8DeySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782817; c=relaxed/simple;
	bh=MbgR2GyNCRjkhN9XM857g9qWaYajCp+KrX12TabANA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFXbuEIusw+KvngrtpOUQP1+fmxr/nOIsVOrC9ogGnoiNbog8EmXm972d2z4MuhmLeUkWyUzbZj+A6pK3V3bkWGXvjwAEmmIsMH9Nmuqg0+7NeY2/IdKyHiObjGSxed+c1hwW0Zn5TCZ71GAVhbdjRuwomquGmhyNVk1PXj4c38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB77ZTbF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB77ZTbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231B1F0089B;
	Wed, 30 Sep 2026 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782811;
	bh=PxRo33XwHgOhPRxWUSI6ZcjtqCn/MaorpclHtJ2bkgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB77ZTbFEbNh00gSPlFJipem3ufqk61uEfs0dVc/y1FMuCQpLm1YpjR/GYyFsXZWf
	 XaSxgQQVoJpGzAvADCJ10sFS0hk9ER49LBZtD7MGm3rCjK2x0o6aJJFYnRuKHM7S7Q
	 vDR1m2T1hKTCp5y05FQSyS7lILDrbIn5uq2L0Otw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/595] netfilter: ipset: mark the rcu locked areas properly
Date: Wed, 30 Sep 2026 17:20:54 +0200
Message-ID: <20260930152351.198912823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 25550a694edca..6412215e638b3 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -581,9 +581,10 @@ mtype_gc(struct work_struct *work)
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
@@ -592,7 +593,6 @@ mtype_gc(struct work_struct *work)
 	next_run = (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
 	if (next_run < HZ/10)
 		next_run = HZ/10;
-	spin_unlock_bh(&set->lock);
 
 	mtype_gc_do(set, h, t, r);
 
@@ -868,15 +868,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -884,7 +882,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (elements >= maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
-	rcu_read_unlock_bh();
 
 	spin_lock_bh(&t->hregion[r].lock);
 	n = rcu_dereference_bh(hbucket(t, key));
-- 
2.53.0



