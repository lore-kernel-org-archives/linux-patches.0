Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4A635E1C0;
	Tue, 13 Oct 2026 12:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894915; cv=none; b=GSWSybNV8jA0nyBv5ur/PYCfm37Hv6ebk2t4SrVZdzg190GCoVoYMFXyLIaPXVwOSH7cL1AWYHSNM3s2PuOvsVNueKYxuEfmZTqGScHngWWrmtSZjUS+nW/jPqblbbX6El5wWIvdTReW1IhWkUG1H9j3uxc41OSWt7Uc8XqqHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894915; c=relaxed/simple;
	bh=B3Xf9iPVXBDBqeD0ZisUV+KpZlv+hlNu7URpTmT6QQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxqRT/nGU7d6zdzxfAS1Po+0+5hiAJ1/i424r7MmRqVPYJd7G4t9PLENVRb2uraPSZ3niYZ06nNBSXFYzNCE3OA86sxkNpXjBq7vbODWKTm8NtxKv817W6K+H3ykpfxOL7YmrT/cOtTJr0d8VCbMHx/UD9MYQxElGVJFqVYcpmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teDhKTXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teDhKTXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7882D1F000FF;
	Tue, 13 Oct 2026 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894914;
	bh=v4AQu5ZX7pBakFekCe70pmBzm7BOl9omJZNtCWI3un8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teDhKTXfuVhF0yPLxjmIdLtsRhsWNzOk8r0bUz4Np9GX58dUtIwVVLa3yr9JX+YaH
	 HNyiwBOSCDe0rZBLTx9dURXre8fEpRSDlOXDCB7HETcXPHkfIdAi2cLboLAYFSc5rb
	 03xX1iWH/vyrhSBxeBdp2hpO7yE8fbnCXfa3M3x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/497] netfilter: conntrack: rework offload nf_conn timeout extension logic
Date: Tue, 13 Oct 2026 13:34:27 +0200
Message-ID: <20261013112910.263917480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 03428ca5cee9f0792edc996c06ce4514816af1fb ]

Offload nf_conn entries may not see traffic for a very long time.

To prevent incorrect 'ct is stale' checks during nf_conntrack table
lookup, the gc worker extends the timeout nf_conn entries marked for
offload to a large value.

The existing logic suffers from a few problems.

Garbage collection runs without locks, its unlikely but possible
that @ct is removed right after the 'offload' bit test.

In that case, the timeout of a new/reallocated nf_conn entry will
be increased.

Prevent this by obtaining a reference count on the ct object and
re-check of the confirmed and offload bits.

If those are not set, the ct is being removed, skip the timeout
extension in this case.

Parallel teardown is also problematic:
 cpu1                                cpu2
 gc_worker
                                     calls flow_offload_teardown()
 tests OFFLOAD bit, set
                                     clear OFFLOAD bit
                                     ct->timeout is repaired (e.g. set to timeout[UDP_CT_REPLIED])
 nf_ct_offload_timeout() called
 expire value is fetched
 <INTERRUPT>
-> NF_CT_DAY timeout for flow that isn't offloaded
(and might not see any further packets).

Use cmpxchg: if ct->timeout was repaired after the 2nd 'offload bit' test
passed, then ct->timeout will only be updated of ct->timeout was not
altered in between.

As we already have a gc worker for flowtable entries, ct->timeout repair
can be handled from the flowtable gc worker.

This avoids having flowtable specific logic in the conntrack core
and avoids checking entries that were never offloaded.

This allows to remove the nf_ct_offload_timeout helper.
Its safe to use in the add case, but not on teardown.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack.h |  10 ---
 net/netfilter/nf_conntrack_core.c    |   6 --
 net/netfilter/nf_flow_table_core.c   | 105 ++++++++++++++++++++++++++-
 3 files changed, 103 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 91599d3ecc8a8..77a09bc88611e 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -328,16 +328,6 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 
 #define	NF_CT_DAY	(86400 * HZ)
 
-/* Set an arbitrary timeout large enough not to ever expire, this save
- * us a check for the IPS_OFFLOAD_BIT from the packet path via
- * nf_ct_is_expired().
- */
-static inline void nf_ct_offload_timeout(struct nf_conn *ct)
-{
-	if (nf_ct_expires(ct) < NF_CT_DAY / 2)
-		WRITE_ONCE(ct->timeout, nfct_time_stamp + NF_CT_DAY);
-}
-
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index da9367047baf4..f9a60576d119f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1515,12 +1515,6 @@ static void gc_worker(struct work_struct *work)
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
-			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
-				nf_ct_offload_timeout(tmp);
-				if (!nf_conntrack_max95)
-					continue;
-			}
-
 			if (expired_count > GC_SCAN_EXPIRED_MAX) {
 				rcu_read_unlock();
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b00f1c68a8e76..0b02b8a2e0dcb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -302,7 +302,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	nf_ct_offload_timeout(flow->ct);
+	nf_ct_refresh(flow->ct, NF_CT_DAY);
 
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
@@ -422,15 +422,116 @@ static bool nf_flow_custom_gc(struct nf_flowtable *flow_table,
 	return flow_table->type->gc && flow_table->type->gc(flow);
 }
 
+/**
+ * nf_flow_table_tcp_timeout() - new timeout of offloaded tcp entry
+ * @ct:		Flowtable offloaded tcp ct
+ *
+ * Return: number of seconds when ct entry should expire.
+ */
+static u32 nf_flow_table_tcp_timeout(const struct nf_conn *ct)
+{
+	u8 state = READ_ONCE(ct->proto.tcp.state);
+
+	switch (state) {
+	case TCP_CONNTRACK_SYN_SENT:
+	case TCP_CONNTRACK_SYN_RECV:
+		return 0;
+	case TCP_CONNTRACK_ESTABLISHED:
+		return NF_CT_DAY;
+	case TCP_CONNTRACK_FIN_WAIT:
+	case TCP_CONNTRACK_CLOSE_WAIT:
+	case TCP_CONNTRACK_LAST_ACK:
+	case TCP_CONNTRACK_TIME_WAIT:
+		return 5 * 60 * HZ;
+	case TCP_CONNTRACK_CLOSE:
+		return 0;
+	}
+
+	return 0;
+}
+
+/**
+ * nf_flow_table_extend_ct_timeout() - Extend ct timeout of offloaded conntrack entry
+ * @ct:		Flowtable offloaded ct
+ *
+ * Datapath lookups in the conntrack table will evict nf_conn entries
+ * if they have expired.
+ *
+ * Once nf_conn entries have been offloaded, nf_conntrack might not see any
+ * packets anymore.  Thus ct->timeout is no longer refreshed and ct can
+ * be evicted.
+ *
+ * To avoid the need for an additional check on the offload bit for every
+ * packet processed via nf_conntrack_in(), set an arbitrary timeout large
+ * enough not to ever expire, this save us a check for the IPS_OFFLOAD_BIT
+ * from the packet path via nf_ct_is_expired().
+ */
+static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
+{
+	static const u32 min_timeout = 5 * 60 * HZ;
+	u32 expires = nf_ct_expires(ct);
+
+	/* normal case: large enough timeout, nothing to do. */
+	if (likely(expires >= min_timeout))
+		return;
+
+	/* must check offload bit after this, we do not hold any locks.
+	 * flowtable and ct entries could have been removed on another CPU.
+	 */
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
+		return;
+
+	/* load ct->status after refcount increase */
+	smp_acquire__after_ctrl_dep();
+
+	if (nf_ct_is_confirmed(ct) &&
+	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
+		u8 l4proto = nf_ct_protonum(ct);
+		u32 new_timeout = true;
+
+		switch (l4proto) {
+		case IPPROTO_UDP:
+			new_timeout = NF_CT_DAY;
+			break;
+		case IPPROTO_TCP:
+			new_timeout = nf_flow_table_tcp_timeout(ct);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
+
+		/* Update to ct->timeout from nf_conntrack happens
+		 * without holding ct->lock.
+		 *
+		 * Use cmpxchg to ensure timeout extension doesn't
+		 * happen when we race with conntrack datapath.
+		 *
+		 * The inverse -- datapath updating ->timeout right
+		 * after this -- is fine, datapath is authoritative.
+		 */
+		if (new_timeout) {
+			new_timeout += nfct_time_stamp;
+			cmpxchg(&ct->timeout, expires, new_timeout);
+		}
+	}
+
+	nf_ct_put(ct);
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
+	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_custom_gc(flow_table, flow))
 		flow_offload_teardown(flow);
+	else if (!teardown)
+		nf_flow_table_extend_ct_timeout(flow->ct);
 
-	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
 				nf_flow_offload_del(flow_table, flow);
-- 
2.53.0



