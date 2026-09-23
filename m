Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA654A2A72;
	Wed, 23 Sep 2026 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173367; cv=none; b=XsuSRFTBz5IeHKeahy7G2mJ1MfalwnQiQSzRv5DROgW3TOpAU6ns61XMXsGOnvuXylObDsX4xXCM+MjBvLyrcrd2N53c4ZxMnX2QW+BbM/qrnW9l6BUoMwTrf5kvNC+Krg2t5gzMzLezoCx4IrUnF+7ja6JL4ztqPjn/n/Rw4TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173367; c=relaxed/simple;
	bh=5nRPEhqokzYIppsJFi8HA/IOglcGvVvR4r8ZEgIoo1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvfY9BFfJU5ff7Y2A1EA8v3Ri+K1fiTdygHNxuxu0/XdD9vtNCu+RFnZM/4GRW4WAeF3wAJQudPzb+fA9q5GPtbWA2NcDZL8hszyFeqClHQN3V1DcvUDPKBpk84Tg81Q9k4JhERpAgEoVAyK5saimYju/1pX9REZwxxqdo6c9Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBDrgJt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBDrgJt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C246D1F000FF;
	Wed, 23 Sep 2026 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173365;
	bh=Q49QPGI+Y1CpIR/zCsC9zg1OW998pK5a5/tyW8uRNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBDrgJt+w12gvKCzwxvmdgHAUZHBTJImL2G9xrpJKyGNjdDB5KegMyJobiGIpyQ9x
	 emJaBfTgsJFhQuC8lwgqGnQvEypiO8mlfIu7RPGU1O+n5IuPgKTblS0yUHkPpCEu1o
	 Gk5pY+uawLa17/U6gwN9ELbCGrUbObxSgYmSG4IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Burton <jamesburton@meta.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 189/438] netlink: do not free nlk->groups while lockless readers can use it
Date: Wed, 23 Sep 2026 16:03:30 +0200
Message-ID: <20260923140649.662776606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ceac0de741bfb47ca255eee075257b3bb31f0651 ]

netlink_realloc_groups() uses krealloc() under netlink_table_grab().
Whenever NLGRPSZ(groups) lands in a different kmalloc bucket, the old
bitmap is freed immediately.

Two readers of nlk->groups / nlk->ngroups do not hold the netlink
table lock:

1) sk_diag_dump_groups(). Hashed (bound) sockets are dumped from the
   rhashtable walk in __netlink_diag_dump(), which only holds RCU.
   Only the mc_list part of the dump takes nl_table_lock.

2) netlink_native_seq_show() (/proc/net/netlink), whose walk has been
   lockless since commit 21e4902aea80 ("netlink: Lockless lookup with
   RCU grace period in socket release").

Both can read a freed buffer, and sk_diag_dump_groups() can also read
past the end of the old (smaller) buffer if it happens to load the old
@groups pointer together with the new @ngroups value, copying the
result into a NETLINK_DIAG_GROUPS attribute.

This is the same class of bug that commit f773608026ee ("netlink:
access nlk groups safely in netlink bind and getname") fixed for bind()
and getname(); these two readers were missed. Simply grabbing the table
lock in sk_diag_dump_groups() is not an option, because it is also
called with nl_table_lock already held from the mc_list section of the
dump.

Make the lockless readers safe instead:

- Allocate a new bitmap and free the old one after an RCU grace period,
  instead of relying on the implicit kfree() done by krealloc().

- Publish @groups before @ngroups, both with release semantics, and have
  the lockless readers load @ngroups first. A reader can then never pair
  the new (bigger) size with the old (smaller) buffer, and a reader
  picking up the new pointer while still seeing the old size is
  guaranteed to see the initialized bitmap.

netlink_realloc_groups() is called from process context (bind() and
setsockopt()), so kfree_rcu_mightsleep() can be used, once the table
has been released.

Fixes: 21e4902aea80 ("netlink: Lockless lookup with RCU grace period in socket release")
Fixes: ad202074320c ("netlink: Use rhashtable walk interface in diag dump")
Reported-by: James Burton <jamesburton@meta.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260911160804.917099-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 42 ++++++++++++++++++++++++++++++++--------
 net/netlink/diag.c       | 20 +++++++++++++++----
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5202fe0b08671..7288de715341a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -922,9 +922,9 @@ netlink_update_subscriptions(struct sock *sk, unsigned int subscriptions)
 
 static int netlink_realloc_groups(struct sock *sk)
 {
+	unsigned long *new_groups, *old_groups = NULL;
 	struct netlink_sock *nlk = nlk_sk(sk);
 	unsigned int groups;
-	unsigned long *new_groups;
 	int err = 0;
 
 	netlink_table_grab();
@@ -938,18 +938,37 @@ static int netlink_realloc_groups(struct sock *sk)
 	if (nlk->ngroups >= groups)
 		goto out_unlock;
 
-	new_groups = krealloc(nlk->groups, NLGRPSZ(groups), GFP_ATOMIC);
-	if (new_groups == NULL) {
+	/* Can not use krealloc(), because the old buffer might be freed
+	 * immediately, while lockless readers (netlink diag dump and
+	 * /proc/net/netlink) can still be looking at it.
+	 */
+	new_groups = kzalloc(NLGRPSZ(groups), GFP_ATOMIC);
+	if (!new_groups) {
 		err = -ENOMEM;
 		goto out_unlock;
 	}
-	memset((char *)new_groups + NLGRPSZ(nlk->ngroups), 0,
-	       NLGRPSZ(groups) - NLGRPSZ(nlk->ngroups));
+	old_groups = nlk->groups;
+	if (old_groups)
+		memcpy(new_groups, old_groups, NLGRPSZ(nlk->ngroups));
+
+	/* Publish the new bitmap and its content: pairs with the address
+	 * dependency in lockless readers, which can pick up the new pointer
+	 * while still seeing the old (smaller) nlk->ngroups.
+	 */
+	smp_store_release(&nlk->groups, new_groups);
+
+	/* Then publish the new size: pairs with smp_load_acquire() from
+	 * lockless readers, so that they can not read NLGRPSZ(new ngroups)
+	 * bytes from the old buffer.
+	 */
+	smp_store_release(&nlk->ngroups, groups);
 
-	nlk->groups = new_groups;
-	nlk->ngroups = groups;
  out_unlock:
 	netlink_table_ungrab();
+
+	if (old_groups)
+		kfree_rcu_mightsleep(old_groups);
+
 	return err;
 }
 
@@ -2705,12 +2724,19 @@ static int netlink_native_seq_show(struct seq_file *seq, void *v)
 	} else {
 		struct sock *s = v;
 		struct netlink_sock *nlk = nlk_sk(s);
+		const unsigned long *groups;
+
+		/* Lockless read : netlink_realloc_groups() can change
+		 * nlk->groups under us. The old buffer is freed after an
+		 * RCU grace period, and this walk is RCU protected.
+		 */
+		groups = READ_ONCE(nlk->groups);
 
 		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8llu\n",
 			   s,
 			   s->sk_protocol,
 			   nlk->portid,
-			   nlk->groups ? (u32)nlk->groups[0] : 0,
+			   groups ? (u32)groups[0] : 0,
 			   sk_rmem_alloc_get(s),
 			   sk_wmem_alloc_get(s),
 			   READ_ONCE(nlk->cb_running),
diff --git a/net/netlink/diag.c b/net/netlink/diag.c
index 0b3e021bd0ed2..7979bd9b26060 100644
--- a/net/netlink/diag.c
+++ b/net/netlink/diag.c
@@ -12,12 +12,24 @@
 static int sk_diag_dump_groups(struct sock *sk, struct sk_buff *nlskb)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
-
-	if (nlk->groups == NULL)
+	unsigned long *groups;
+	unsigned int ngroups;
+
+	/* Hashed sockets are dumped from the rhashtable walk, which only
+	 * holds rcu_read_lock(), while netlink_realloc_groups() can replace
+	 * nlk->groups and nlk->ngroups at any time.
+	 *
+	 * Read nlk->ngroups first : this pairs with smp_store_release()
+	 * from netlink_realloc_groups(), so that we can not use the new
+	 * (bigger) size with the old (smaller) buffer. The old buffer is
+	 * freed after an RCU grace period.
+	 */
+	ngroups = smp_load_acquire(&nlk->ngroups);
+	groups = READ_ONCE(nlk->groups);
+	if (!groups)
 		return 0;
 
-	return nla_put(nlskb, NETLINK_DIAG_GROUPS, NLGRPSZ(nlk->ngroups),
-		       nlk->groups);
+	return nla_put(nlskb, NETLINK_DIAG_GROUPS, NLGRPSZ(ngroups), groups);
 }
 
 static int sk_diag_put_flags(struct sock *sk, struct sk_buff *skb)
-- 
2.53.0



