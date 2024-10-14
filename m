Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203931A0724;
	Mon, 14 Oct 2024 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916135; cv=none; b=ZZKBWAb6uqrIaKHZDGns2HJfXnj31uv9RgVtwrtCq4yRqMbgs7dRntxsIvLB3HmLf5gcTQ1Ai+bwWVbd+tSaZY8vL96cUMcal9PYXlDjkfoKrRXwQCOs7IhElxQ96zxBA55UCEgAjhUv/VM21kWM8NQL4MmQbzCQCafWw65PzRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916135; c=relaxed/simple;
	bh=V6Kjctt1UK6BAvQfJQDeMz+geZO3n8HJvLFLeE+enUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knCTTgiQj3Uos1xoPZ5FZRTpNHS82dBfJZiSjuejD6EdKBRlUy7kscGGjxwXeUFZLPsGmLShLFr8F/Fz650NtHZBj7pfPZnq2YduyUxifyKQHwI1YAKJkrMl7vYN5xwiAPvJvy39gfyzTUR+h8wcqw2ZI6erBdypXCKSzs1/IuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xt7nGIIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xt7nGIIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1D2C4CEC3;
	Mon, 14 Oct 2024 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916135;
	bh=V6Kjctt1UK6BAvQfJQDeMz+geZO3n8HJvLFLeE+enUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xt7nGIIosszgEt5B9pz5f4ysBo5eyK9lL22Tv0mGDAoGDm0ZTuZdqzpxn8f+Zb6rN
	 r3NNu1bbbpRg1mFP0DZP+/x87cSz5UfJKqUzfR+4mXQfx3agrUJmu048jsHINV69b8
	 HHGSXsJpkr/D39/2Bx5YsDdk4Gc/Aay2AEQtSUho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 063/214] netfilter: nf_nat: dont try nat source port reallocation for reverse dir clash
Date: Mon, 14 Oct 2024 16:18:46 +0200
Message-ID: <20241014141047.448595623@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d8f84a9bc7c4e07fdc4edc00f9e868b8db974ccb ]

A conntrack entry can be inserted to the connection tracking table if there
is no existing entry with an identical tuple in either direction.

Example:
INITIATOR -> NAT/PAT -> RESPONDER

Initiator passes through NAT/PAT ("us") and SNAT is done (saddr rewrite).
Then, later, NAT/PAT machine itself also wants to connect to RESPONDER.

This will not work if the SNAT done earlier has same IP:PORT source pair.

Conntrack table has:
ORIGINAL: $IP_INITATOR:$SPORT -> $IP_RESPONDER:$DPORT
REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT

and new locally originating connection wants:
ORIGINAL: $IP_NAT:$SPORT -> $IP_RESPONDER:$DPORT
REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT

This is handled by the NAT engine which will do a source port reallocation
for the locally originating connection that is colliding with an existing
tuple by attempting a source port rewrite.

This is done even if this new connection attempt did not go through a
masquerade/snat rule.

There is a rare race condition with connection-less protocols like UDP,
where we do the port reallocation even though its not needed.

This happens when new packets from the same, pre-existing flow are received
in both directions at the exact same time on different CPUs after the
conntrack table was flushed (or conntrack becomes active for first time).

With strict ordering/single cpu, the first packet creates new ct entry and
second packet is resolved as established reply packet.

With parallel processing, both packets are picked up as new and both get
their own ct entry.

In this case, the 'reply' packet (picked up as ORIGINAL) can be mangled by
NAT engine because a port collision is detected.

This change isn't enough to prevent a packet drop later during
nf_conntrack_confirm(), the existing clash resolution strategy will not
detect such reverse clash case.  This is resolved by a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c | 120 +++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 016c816d91cbc..c212b1b137222 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -183,7 +183,35 @@ hash_by_src(const struct net *net,
 	return reciprocal_scale(hash, nf_nat_htable_size);
 }
 
-/* Is this tuple already taken? (not by us) */
+/**
+ * nf_nat_used_tuple - check if proposed nat tuple clashes with existing entry
+ * @tuple: proposed NAT binding
+ * @ignored_conntrack: our (unconfirmed) conntrack entry
+ *
+ * A conntrack entry can be inserted to the connection tracking table
+ * if there is no existing entry with an identical tuple in either direction.
+ *
+ * Example:
+ * INITIATOR -> NAT/PAT -> RESPONDER
+ *
+ * INITIATOR passes through NAT/PAT ("us") and SNAT is done (saddr rewrite).
+ * Then, later, NAT/PAT itself also connects to RESPONDER.
+ *
+ * This will not work if the SNAT done earlier has same IP:PORT source pair.
+ *
+ * Conntrack table has:
+ * ORIGINAL: $IP_INITIATOR:$SPORT -> $IP_RESPONDER:$DPORT
+ * REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT
+ *
+ * and new locally originating connection wants:
+ * ORIGINAL: $IP_NAT:$SPORT -> $IP_RESPONDER:$DPORT
+ * REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT
+ *
+ * ... which would mean incoming packets cannot be distinguished between
+ * the existing and the newly added entry (identical IP_CT_DIR_REPLY tuple).
+ *
+ * @return: true if the proposed NAT mapping collides with an existing entry.
+ */
 static int
 nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 		  const struct nf_conn *ignored_conntrack)
@@ -200,6 +228,94 @@ nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 	return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 
+static bool nf_nat_allow_clash(const struct nf_conn *ct)
+{
+	return nf_ct_l4proto_find(nf_ct_protonum(ct))->allow_clash;
+}
+
+/**
+ * nf_nat_used_tuple_new - check if to-be-inserted conntrack collides with existing entry
+ * @tuple: proposed NAT binding
+ * @ignored_ct: our (unconfirmed) conntrack entry
+ *
+ * Same as nf_nat_used_tuple, but also check for rare clash in reverse
+ * direction. Should be called only when @tuple has not been altered, i.e.
+ * @ignored_conntrack will not be subject to NAT.
+ *
+ * @return: true if the proposed NAT mapping collides with existing entry.
+ */
+static noinline bool
+nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
+		      const struct nf_conn *ignored_ct)
+{
+	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST_BIT;
+	const struct nf_conntrack_tuple_hash *thash;
+	const struct nf_conntrack_zone *zone;
+	struct nf_conn *ct;
+	bool taken = true;
+	struct net *net;
+
+	if (!nf_nat_used_tuple(tuple, ignored_ct))
+		return false;
+
+	if (!nf_nat_allow_clash(ignored_ct))
+		return true;
+
+	/* Initial choice clashes with existing conntrack.
+	 * Check for (rare) reverse collision.
+	 *
+	 * This can happen when new packets are received in both directions
+	 * at the exact same time on different CPUs.
+	 *
+	 * Without SMP, first packet creates new conntrack entry and second
+	 * packet is resolved as established reply packet.
+	 *
+	 * With parallel processing, both packets could be picked up as
+	 * new and both get their own ct entry allocated.
+	 *
+	 * If ignored_conntrack and colliding ct are not subject to NAT then
+	 * pretend the tuple is available and let later clash resolution
+	 * handle this at insertion time.
+	 *
+	 * Without it, the 'reply' packet has its source port rewritten
+	 * by nat engine.
+	 */
+	if (READ_ONCE(ignored_ct->status) & uses_nat)
+		return true;
+
+	net = nf_ct_net(ignored_ct);
+	zone = nf_ct_zone(ignored_ct);
+
+	thash = nf_conntrack_find_get(net, zone, tuple);
+	if (unlikely(!thash)) /* clashing entry went away */
+		return false;
+
+	ct = nf_ct_tuplehash_to_ctrack(thash);
+
+	/* NB: IP_CT_DIR_ORIGINAL should be impossible because
+	 * nf_nat_used_tuple() handles origin collisions.
+	 *
+	 * Handle remote chance other CPU confirmed its ct right after.
+	 */
+	if (thash->tuple.dst.dir != IP_CT_DIR_REPLY)
+		goto out;
+
+	/* clashing connection subject to NAT? Retry with new tuple. */
+	if (READ_ONCE(ct->status) & uses_nat)
+		goto out;
+
+	if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+			      &ignored_ct->tuplehash[IP_CT_DIR_REPLY].tuple) &&
+	    nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+			      &ignored_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)) {
+		taken = false;
+		goto out;
+	}
+out:
+	nf_ct_put(ct);
+	return taken;
+}
+
 static bool nf_nat_may_kill(struct nf_conn *ct, unsigned long flags)
 {
 	static const unsigned long flags_refuse = IPS_FIXED_TIMEOUT |
@@ -611,7 +727,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
 		if (nf_in_range(orig_tuple, range)) {
-			if (!nf_nat_used_tuple(orig_tuple, ct)) {
+			if (!nf_nat_used_tuple_new(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
 			}
-- 
2.43.0



