Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D6214205;
	Tue,  8 Apr 2025 11:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110256; cv=none; b=KRO4YJZcZoMm1FTzhwFMBQElOoL+zAA2zaOqKIYXsJhQlEcI++Z1hbnrp/+BSFn5f8zZk6ZibxNo4uSAZ68B9crVW1bW9lbwt59E5jrsMO6bVQy2QtAuSvr9/nQtnCxudR+cLRL5bX4ZW9UWwuXSCYazf+oCTpwGjqlY64jEAMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110256; c=relaxed/simple;
	bh=QYxNCley2mj/SW7v5k1Aa/JXQOM3e9F46XeDshPO1Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKmje8YlLTflDRVi6+5nm5+3G1X94nwtOzLymFDjHzsfXdPkKnonWCErEW7SV/9A3vdra/9OO6BHHeix/wOUKZRGN/IPSZYUSKPx3yIirIZZeyxOwTe+gb73tOmVCIp72qpB5fmsVxilra6n5Zo44f5JqQRbNEnURzRuA+tqxmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Daov4xgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Daov4xgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67747C4CEE5;
	Tue,  8 Apr 2025 11:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110256;
	bh=QYxNCley2mj/SW7v5k1Aa/JXQOM3e9F46XeDshPO1Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Daov4xguA0ZCqI1X9xdmtEbJffSyjTjRUy7nyaklK1YU9Q7wcHFtu4snLOR/1twOr
	 nCvrz8DjFaqlf9Fwip3+mJ50e0CQYaG106pJ6Hpu/XIarQWKGDGYP6V2RjvY/TYy4c
	 EPpQzaGobTUJbdvf9etJGc7TUp7p2nt/ra1ycjCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Kajetan Puchalski <kajetan.puchalski@arm.com>,
	Florian Westphal <fw@strlen.de>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 226/227] netfilter: conntrack: fix crash due to confirmed bit load reordering
Date: Tue,  8 Apr 2025 12:50:04 +0200
Message-ID: <20250408104827.057373779@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Florian Westphal <fw@strlen.de>

commit 0ed8f619b412b52360ccdfaf997223ccd9319569 upstream.

Kajetan Puchalski reports crash on ARM, with backtrace of:

__nf_ct_delete_from_lists
nf_ct_delete
early_drop
__nf_conntrack_alloc

Unlike atomic_inc_not_zero, refcount_inc_not_zero is not a full barrier.
conntrack uses SLAB_TYPESAFE_BY_RCU, i.e. it is possible that a 'newly'
allocated object is still in use on another CPU:

CPU1						CPU2
						encounter 'ct' during hlist walk
 delete_from_lists
 refcount drops to 0
 kmem_cache_free(ct);
 __nf_conntrack_alloc() // returns same object
						refcount_inc_not_zero(ct); /* might fail */

						/* If set, ct is public/in the hash table */
						test_bit(IPS_CONFIRMED_BIT, &ct->status);

In case CPU1 already set refcount back to 1, refcount_inc_not_zero()
will succeed.

The expected possibilities for a CPU that obtained the object 'ct'
(but no reference so far) are:

1. refcount_inc_not_zero() fails.  CPU2 ignores the object and moves to
   the next entry in the list.  This happens for objects that are about
   to be free'd, that have been free'd, or that have been reallocated
   by __nf_conntrack_alloc(), but where the refcount has not been
   increased back to 1 yet.

2. refcount_inc_not_zero() succeeds. CPU2 checks the CONFIRMED bit
   in ct->status.  If set, the object is public/in the table.

   If not, the object must be skipped; CPU2 calls nf_ct_put() to
   un-do the refcount increment and moves to the next object.

Parallel deletion from the hlists is prevented by a
'test_and_set_bit(IPS_DYING_BIT, &ct->status);' check, i.e. only one
cpu will do the unlink, the other one will only drop its reference count.

Because refcount_inc_not_zero is not a full barrier, CPU2 may try to
delete an object that is not on any list:

1. refcount_inc_not_zero() successful (refcount inited to 1 on other CPU)
2. CONFIRMED test also successful (load was reordered or zeroing
   of ct->status not yet visible)
3. delete_from_lists unlinks entry not on the hlist, because
   IPS_DYING_BIT is 0 (already cleared).

2) is already wrong: CPU2 will handle a partially initited object
that is supposed to be private to CPU1.

Add needed barriers when refcount_inc_not_zero() is successful.

It also inserts a smp_wmb() before the refcount is set to 1 during
allocation.

Because other CPU might still see the object, refcount_set(1)
"resurrects" it, so we need to make sure that other CPUs will also observe
the right content.  In particular, the CONFIRMED bit test must only pass
once the object is fully initialised and either in the hash or about to be
inserted (with locks held to delay possible unlink from early_drop or
gc worker).

I did not change flow_offload_alloc(), as far as I can see it should call
refcount_inc(), not refcount_inc_not_zero(): the ct object is attached to
the skb so its refcount should be >= 1 in all cases.

v2: prefer smp_acquire__after_ctrl_dep to smp_rmb (Will Deacon).
v3: keep smp_acquire__after_ctrl_dep close to refcount_inc_not_zero call
    add comment in nf_conntrack_netlink, no control dependency there
    due to locks.

Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/all/Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com/
Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
Diagnosed-by: Will Deacon <will@kernel.org>
Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_core.c       |   22 ++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c    |    1 +
 net/netfilter/nf_conntrack_standalone.c |    3 +++
 3 files changed, 26 insertions(+)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -719,6 +719,9 @@ static void nf_ct_gc_expired(struct nf_c
 	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
+	/* load ->status after refcount increase */
+	smp_acquire__after_ctrl_dep();
+
 	if (nf_ct_should_gc(ct))
 		nf_ct_kill(ct);
 
@@ -785,6 +788,9 @@ __nf_conntrack_find_get(struct net *net,
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
+			/* re-check key after refcount */
+			smp_acquire__after_ctrl_dep();
+
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -1284,6 +1290,9 @@ static unsigned int early_drop_list(stru
 		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
+		/* load ->ct_net and ->status after refcount increase */
+		smp_acquire__after_ctrl_dep();
+
 		/* kill only if still in same netns -- might have moved due to
 		 * SLAB_TYPESAFE_BY_RCU rules.
 		 *
@@ -1400,6 +1409,9 @@ static void gc_worker(struct work_struct
 			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
+			/* load ->status after refcount increase */
+			smp_acquire__after_ctrl_dep();
+
 			if (gc_worker_skip_ct(tmp)) {
 				nf_ct_put(tmp);
 				continue;
@@ -1610,6 +1622,16 @@ init_conntrack(struct net *net, struct n
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
+	/* Other CPU might have obtained a pointer to this object before it was
+	 * released.  Because refcount is 0, refcount_inc_not_zero() will fail.
+	 *
+	 * After refcount_set(1) it will succeed; ensure that zeroing of
+	 * ct->status and the correct ct->net pointer are visible; else other
+	 * core might observe CONFIRMED bit which means the entry is valid and
+	 * in the hash table, but its not (anymore).
+	 */
+	smp_wmb();
+
 	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
 	nf_ct_add_to_unconfirmed_list(ct);
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1149,6 +1149,7 @@ restart:
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
+				/* need to defer nf_ct_kill() until lock is released */
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
 				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -303,6 +303,9 @@ static int ct_seq_show(struct seq_file *
 	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
+	/* load ->status after refcount increase */
+	smp_acquire__after_ctrl_dep();
+
 	if (nf_ct_should_gc(ct)) {
 		nf_ct_kill(ct);
 		goto release;


