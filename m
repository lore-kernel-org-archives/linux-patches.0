Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622636;
	b=S9Vh4dJqCH7NbPWUrAxcinQxKJIhPhj7pgoZXHGeXR0ddqgb121kZX4zWSNdSK+XvPv0
	 bakXk7TZYaFehODbii0X+KO251b8sucp1V17TuXzpStTv0VXs6jd3aANOJtXVx2UC/BGE
	 IQ+kvGeG776MXA8TYZlxwlgjaIlgYbV/Y/N0C99qGKD8edQsQlGvtySmEz1k5C2itlfKG
	 g4i9fUhFPPvt4ll8Fud5dIgWVAwkYVbC/gBXiqprBhBw+C2JHIUOIUls6PN63em0NdTLy
	 kSgkKPGCvY4H9h4wMeKRkXBslbs3clNRfRGJs5I6a7w7SzsLhCVXwwG6Lbde0d+k+rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dSRFAmy9OdN9/sY8Hz2tnmmSlCIcZs9Esli17dJBPJU=;
	b=ATW8djTtOAOAUB8k7e7FB6wCK0623U/oQV0IudZz/4Q0owITXRj/Vx7lB6FmUIRfmuO7
	 N23s//YqUxMs64ogfedEe1kF3vXR89976XJCtdJlKQ+JfnWVkwsR0qnzIN30PHV1DsUCp
	 Bo2xXlh83sL7z1pHwMhPXA2pVbZufvyYErToHNgu/w//f+xz61gjo9OrQNP0acYkNaR4P
	 SgdOWJWwSKgkK8c+l47cN7BJ/SbocacucsqXqagKgL31mqjhXUGKtBxU/E6pI+vwB75+u
	 nFqfGhxUL97xeNQnr+YMpG+iwWvVeGnm8gMMeLt5CfmSRrfzHlGpIWa7F+izFeuy+1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+9ri22v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E60E606A31E;
	Wed, 25 Nov 2026 16:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+9ri22v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577DE1F000C6;
	Wed, 25 Nov 2026 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622635;
	bh=dSRFAmy9OdN9/sY8Hz2tnmmSlCIcZs9Esli17dJBPJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+9ri22v8i/qtr9FQcJcwb0ticDJxVabNqAFLpbScgp9A/SI29CesmdwjxO8GGvox
	 5D1QcPFZzSmLmhVN8geVxfGyNdHRapat679u5F6L1Lk53fymZ+1s1g9NUasIwCjfNg
	 x3ssnWBbeETpGdKFyhfPivUab8Q/bfHs6I8RLBME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 601/990] bpf: Dont hand out a linked element as extra element
Date: Wed, 25 Nov 2026 15:32:48 +0100
Message-ID: <20261125143836.171048561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ccb88db8dac8fabde58656d5d4a33711e89c480a ]

When htab_map_update_elem() replaces an element of a preallocated map,
alloc_htab_elem() takes the spare element of this cpu and puts the old
element into the per-cpu slot right away, long before the old element is
unlinked from its bucket.  The bucket lock disables interrupts, but it
does not keep out an NMI, or a tracing program on the return of
alloc_htab_elem().  bpf_prog_active only helps if both programs are
kprobe, tracepoint or perf_event programs.  A program that updates an
existing key in another bucket of the same map gets to use the slot:

  htab_map_update_elem(k1)              tc, xdp, fentry, raw_tp, ...
    alloc_htab_elem()
      l_new = *pl_new
      *pl_new = l_old                   still linked in bucket 1
      <NMI>
        htab_map_update_elem(k2)        perf_event program
          l_new = *pl_new               the l_old of the outer update
          hlist_nulls_add_head_rcu(l_new, bucket 2)
          hlist_nulls_del_rcu(k2's old element)
      </NMI>
    hlist_nulls_add_head_rcu(l_new, bucket 1)
    hlist_nulls_del_rcu(l_old)

If l_old was the first element of bucket 1, the outer add points its pprev
at l_new, and the delete takes it out of bucket 1 only.  l_new->next now
leads into bucket 2, where l_old stays with a poisoned pprev, on which a
delete of k2 crashes.  If it was not the first, the delete takes it out of
bucket 2: k2 is gone from the map, and the chain of bucket 1 still contains
l_old, whose next pointer leads into bucket 2.

Either way a walk of bucket 1 ends on the nulls value of bucket 2.
lookup_nulls_elem_raw() restarts whenever that happens, so every lookup in
bucket 1 which does not find its key spins forever:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
   __htab_map_lookup_elem+0x354/0x4d0

  BUG: KASAN: wild-memory-access in htab_map_delete_elem+0x30c/0x670
  Write of size 8 at addr dead000000000122 by task extra/102

An NMI between the load and the store of the slot makes both updates use
the same element, with much the same result.

Empty the slot when the spare element is taken, in a way that is atomic
on this cpu, and put the old element in only after it has been unlinked
and its timers and the like have been cancelled.  A nested update that
finds the slot empty, which is the case that corrupted the map, fails with
-EBUSY.

Fixes: 8c290e60fa2a ("bpf: fix hashmap extra_elems logic")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-5-alexei.starovoitov@gmail.com
[ sashal: Replaced check_and_cancel_fields() with the older check_and_free_fields() helper in htab_map_update_elem(), since the cancel helper does not exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index ffc534384f84d..95e9a760a7be3 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1085,11 +1085,17 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 	if (prealloc) {
 		if (old_elem) {
 			/* if we're updating the existing element,
-			 * use per-cpu extra elems to avoid freelist_pop/push
+			 * use per-cpu extra elems to avoid freelist_pop/push.
+			 * The caller puts old_elem into the slot once it is
+			 * unlinked. Until then the slot is empty for an NMI
+			 * or a kprobe that updates this map on this cpu.
 			 */
 			pl_new = this_cpu_ptr(htab->extra_elems);
-			l_new = *pl_new;
-			*pl_new = old_elem;
+			l_new = READ_ONCE(*pl_new);
+			do {
+				if (!l_new)
+					return ERR_PTR(-EBUSY);
+			} while (!try_cmpxchg_local(pl_new, &l_new, NULL));
 		} else {
 			struct pcpu_freelist_node *l;
 
@@ -1251,11 +1257,15 @@ static long htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	if (l_old) {
 		hlist_nulls_del_rcu(&l_old->hash_node);
 
-		/* l_old has already been stashed in htab->extra_elems, free
-		 * its special fields before it is available for reuse.
+		/*
+		 * l_old replaces the extra element that alloc_htab_elem() took.
+		 * Free its special fields first: once it is in the
+		 * slot, the next update on this cpu can reuse it.
 		 */
-		if (htab_is_prealloc(htab))
+		if (htab_is_prealloc(htab)) {
 			check_and_free_fields(htab, l_old);
+			WRITE_ONCE(*this_cpu_ptr(htab->extra_elems), l_old);
+		}
 	}
 	htab_unlock_bucket(b, flags);
 	if (l_old && !htab_is_prealloc(htab))
-- 
2.53.0



