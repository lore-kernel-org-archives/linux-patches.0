Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D57B3A1D01;
	Sat, 17 Oct 2026 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256408; cv=none; b=rPxIqQSgRsa8XcSXKdz9fkpVRmfGhVsk1EHnl0GJ/1XPTRZth8mNAa2F7vcjwAsVEL6BG37/8m0PdJMdNLdWy4LxmFwOKYci7ghThKvn0kwTA1IEcRN9nNjd3bJvqoYLlL8BONNsvQ6bPEnQpPaNAQmjNpGGTXyccG/o+pmwmBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256408; c=relaxed/simple;
	bh=M7UmTP9PgVkkM6cKipkY1zIIX4KXgB94/ocmmIfPPPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUdM6NWXtFb1TLlK8XI43sCAPYtUjlbOmqI/y/atiVliGhNcJ++7J1yhBZvXrRbClz8z5ebgHWdF6kDvaZwRjbdyD7llz+JEDGlwv2VWxPZjOVtShc3WL0fl2I9kaWsVKex8s4L0JfkVyJyCNMq6lImZFr+Y/zaMXSX9UDobsU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxiPZm0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxiPZm0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BEB1F000C5;
	Sat, 17 Oct 2026 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256407;
	bh=ql4Wxyah0cnvzNxrcMHsWwWhLqzTrlCDhFtblcuyP4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxiPZm0P4iadVwtN4DJTYnP4kjbXqqsHitM0m07JVolCKAmt/wNXvQUX2uMVuTaVp
	 NSoZ8dgdWoYldNMRPPsvCNow5Zsly4VCxA8iLaL6VFmJH8sNWfZTnYYAUkN22RW914
	 3AqCxue9Bqgp5s1i1y1fYgpiFaIpUlVRZlGP9sj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0226/1674] netfilter: flowtable: generalize pending status bit
Date: Sat, 17 Oct 2026 17:41:38 +0200
Message-ID: <20261017160436.943297998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7c549fb7eecd01fdba7c0d12c01da876ef8a3214 ]

Rename NF_FLOW_HW_PENDING to NF_FLOW_PENDING and use it to inhibit the
flowtable GC worker until pending hw offload work has been completed.

Apparently, nf_flow_offload_stats() can schedule work to retrieve stats
while the flow is being removed by GC.

And this bit can also be used in a follow up patch to disable GC until
the flow has been fully added in both directions.

Revert the reordering done in commit d644b23afe1e ("netfilter:
flowtable: publish HW_DEAD after worker is done") to prevent a race
between GC and hw offload handler.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    |  7 ++++++-
 net/netfilter/nf_flow_table_offload.c | 14 +++++---------
 net/sched/act_ct.c                    |  2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 0097791e1eede..f07234df1d03a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -163,10 +163,10 @@ enum nf_flow_flags {
 	NF_FLOW_SNAT,
 	NF_FLOW_DNAT,
 	NF_FLOW_TEARDOWN,
+	NF_FLOW_PENDING,
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
 	NF_FLOW_HW_ESTABLISHED,
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f52e6fd46d8d3..20aab5c6e95bf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -522,7 +522,12 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
-	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	bool teardown;
+
+	if (test_bit(NF_FLOW_PENDING, &flow->flags))
+		return;
+
+	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 0a49a6d72dcd5..1f3469d452674 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -993,6 +993,7 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
 		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -1054,13 +1055,8 @@ static void flow_offload_work_handler(struct work_struct *work)
 		default:
 			WARN_ON_ONCE(1);
 	}
-
-	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
-	if (offload->cmd == FLOW_CLS_DESTROY) {
-		/* Publish after the worker's last flow access. */
-		smp_mb__before_atomic();
-		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
-	}
+	smp_mb__before_atomic();
+	clear_bit(NF_FLOW_PENDING, &offload->flow->flags);
 
 	kfree(offload);
 }
@@ -1087,12 +1083,12 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
-	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
+	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;
 
 	offload = kmalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
 	if (!offload) {
-		clear_bit(NF_FLOW_HW_PENDING, &flow->flags);
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
 		return NULL;
 	}
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 3393c8b174c0f..d0fd701067672 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -289,7 +289,7 @@ static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
 {
 	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
 	       test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
-	       !test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
+	       !test_bit(NF_FLOW_PENDING, &flow->flags) &&
 	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 }
 
-- 
2.53.0



