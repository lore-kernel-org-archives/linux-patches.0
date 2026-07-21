Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462AB435A98;
	Tue, 21 Jul 2026 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672940; cv=none; b=WSplw8HK6wtJIZlNxP1QKLxr7vVvCzU493rhmhAvvDdUGNJzDGXbhLwGQQiQy1Qwdlfykyyljo0u2Fatl/qYQpPIKCvEW+MuvHvTtTVFYLMaGaEfZyhyzSvPXApQbrpq2hq1/GgkG2URvQy5pL/LaKoi75kH2DVDvG6PJiFruQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672940; c=relaxed/simple;
	bh=R0SVzCZ5ETviweyiNddqGWUrggJk165jVDEKM+D3NkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rjv5Cuo40GSFku1kaX0qtTG2agUqcCPtPZJVA/uPVeeWyN3w4lVzZr8C8gLwNP8jtPx+IK9cQgJcsTUhUpZM0WOZK9cxnrEKTpW1VUyUuUWUJ50LYKN5pMuIPwbatmhQG1kbKdcjhJfkAx9ZEN7c+nYDVHWSoopii73j3PQ4c/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/QxSMXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/QxSMXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6105A1F000E9;
	Tue, 21 Jul 2026 22:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672938;
	bh=9J8NUK6o1WhK+E4yd4Fo/poxR4S7zKka7bJ6Cv956LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/QxSMXC+0hKH9coMIzvJWgx0/1P0EE8wMvsTBMV3DjnRbQhlgPN/fDo9qr3Tb6gR
	 oUUXYpFPMThpxCybQ91R2DU/0oWx90LMzAp78Mjm6gaJi53gJIErTGotc05EpLkp9i
	 EvRDG3noR9oRtwpQk+EkpTdCOJQ70CzeQhgNaTkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Poenaru <vlad.wing@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 812/843] bpf: Allow LPM map access from sleepable BPF programs
Date: Tue, 21 Jul 2026 17:27:27 +0200
Message-ID: <20260721152424.339667481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Poenaru <vlad.wing@gmail.com>

[ Upstream commit 2f884d371fafea137afea504d49ee4a7c8d7985b ]

trie_lookup_elem() annotates its rcu_dereference_check() walks with
only rcu_read_lock_bh_held().  Because rcu_dereference_check(p, c)
resolves to "c || rcu_read_lock_held()", this passes for XDP/NAPI and
classic RCU readers but fails for sleepable BPF programs, which enter
via __bpf_prog_enter_sleepable() and hold only rcu_read_lock_trace().

trie_update_elem() and trie_delete_elem() have the same problem in a
different form: they walk the trie with plain rcu_dereference(), which
asserts rcu_read_lock_held() unconditionally.  Both are reachable from
sleepable BPF programs via the bpf_map_update_elem / bpf_map_delete_elem
helpers, and from the syscall path under classic rcu_read_lock().  In
the writer paths the trie is actually protected by trie->lock (an
rqspinlock taken across the walk); we never relied on the RCU read-side
lock to keep nodes alive there.

A sleepable LSM hook that ends up touching an LPM trie therefore
triggers lockdep on debug kernels:

  =============================
  WARNING: suspicious RCU usage
  7.1.0-... Tainted: G            E
  -----------------------------
  kernel/bpf/lpm_trie.c:249 suspicious rcu_dereference_check() usage!
  1 lock held by net_tests/540:
   #0: (rcu_tasks_trace_srcu_struct){....}-{0:0},
       at: __bpf_prog_enter_sleepable+0x26/0x280
  Call Trace:
   dump_stack_lvl
   lockdep_rcu_suspicious
   trie_lookup_elem
   bpf_prog_..._enforce_security_socket_connect
   bpf_trampoline_...
   security_socket_connect
   __sys_connect
   do_syscall_64

This is lockdep-only -- no UAF, since Tasks Trace RCU does serialize
against the trie's reclaim path -- but it spams the console once per
distinct callsite on every debug kernel running a sleepable BPF LSM
that touches an LPM trie, which is increasingly common.

For the lookup path, switch the rcu_dereference_check() annotation
from rcu_read_lock_bh_held() to bpf_rcu_lock_held(), which accepts all
three contexts (classic, BH, Tasks Trace).  Other map types already
follow this convention.

For trie_update_elem() and trie_delete_elem(), annotate the walks as
rcu_dereference_protected(*p, 1) -- matching trie_free() in the same
file -- since trie->lock is held across the walk.  rqspinlock has no
lockdep_map, so the predicate degenerates to '1' rather than
lockdep_is_held(&trie->lock); the protection is real but not
machine-verifiable.  trie_get_next_key() also uses bare
rcu_dereference() but is reachable only from the BPF syscall, which
holds classic rcu_read_lock() before dispatching, so it is left
untouched.

Fixes: 694cea395fde ("bpf: Allow RCU-protected lookups to happen from bh context")
Cc: stable@vger.kernel.org
Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260609135558.193287-2-vlad.wing@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/lpm_trie.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -235,7 +235,7 @@ static void *trie_lookup_elem(struct bpf
 
 	/* Start walking the trie from the root node ... */
 
-	for (node = rcu_dereference_check(trie->root, rcu_read_lock_bh_held());
+	for (node = rcu_dereference_check(trie->root, bpf_rcu_lock_held());
 	     node;) {
 		unsigned int next_bit;
 		size_t matchlen;
@@ -269,7 +269,7 @@ static void *trie_lookup_elem(struct bpf
 		 */
 		next_bit = extract_bit(key->data, node->prefixlen);
 		node = rcu_dereference_check(node->child[next_bit],
-					     rcu_read_lock_bh_held());
+					     bpf_rcu_lock_held());
 	}
 
 	if (!found)
@@ -349,7 +349,7 @@ static int trie_update_elem(struct bpf_m
 	 */
 	slot = &trie->root;
 
-	while ((node = rcu_dereference(*slot))) {
+	while ((node = rcu_dereference_protected(*slot, 1))) {
 		matchlen = longest_prefix_match(trie, node, key);
 
 		if (node->prefixlen != matchlen ||
@@ -474,7 +474,7 @@ static int trie_delete_elem(struct bpf_m
 	trim = &trie->root;
 	trim2 = trim;
 	parent = NULL;
-	while ((node = rcu_dereference(*trim))) {
+	while ((node = rcu_dereference_protected(*trim, 1))) {
 		matchlen = longest_prefix_match(trie, node, key);
 
 		if (node->prefixlen != matchlen ||


