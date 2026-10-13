Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F0364929;
	Tue, 13 Oct 2026 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894918; cv=none; b=HgpNop8r0w02F91XGOm2Fw5IyZ5+czW8M3uCoiAeiBaM0ffmB4NNJKxDM+Bx9RibfVydJcxc+G3lvvf1hZdrtcX/PE8KY/gHl1w7P+l+HFVVfahYheZ5aU0H706Q14keCFO0mNUTSG72GCxZm7VC5UunmOTvnwt0hF8hCHCHZcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894918; c=relaxed/simple;
	bh=oDugP1zwODjJ16eqmZq9EXr8dfwQ8jjrSvtWMX9Mfkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPw7CDnWt7EPvh44s+gAeFXoYXCyo7EQynThigoQS/ZMwcgxbHbJv28cLs5sL+leYlrhd2yEAoR2yR6o7Ji1gHJ7qLz5qHYLONv5bmcCnjy2khm1wPZCENQvbySG2z/h9OVzxwJgFukL+1tDcqKrG7gl3fm4+bXm6m8wRU4cOZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjZ/ALso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjZ/ALso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7AB1F000FF;
	Tue, 13 Oct 2026 12:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894917;
	bh=bM95CvBCUY59q4xXbWZ31wFza7o+vFGfyiqQ1EidL/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjZ/ALsodEOHp0GOsxGHmxGkZP49P4SYE8QKv86myxLB0Vq1b6+jeLzV+lA6LKN58
	 KavbzQ1jZI3JKBgdlHnOdzb3293PQn7ftqKJw9eqX/ZUDsLK8LrzHYpNRguqiw43hX
	 HZeWXUSl1RBQgaKgIM+OIIYUuO0vO5aTXL+APEhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/497] netfilter: flowtable: generalize pending status bit
Date: Tue, 13 Oct 2026 13:34:28 +0200
Message-ID: <20261013112910.288672492@linuxfoundation.org>
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
index 1a6fca0131653..714330cf9ca76 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,10 +164,10 @@ enum nf_flow_flags {
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
index 0b02b8a2e0dcb..87399eecbbc35 100644
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
index 8e3edc7c37b38..2af7d64696044 100644
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
index 154be631b038a..9c7e089f55d39 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -287,7 +287,7 @@ static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
 {
 	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
 	       test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
-	       !test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
+	       !test_bit(NF_FLOW_PENDING, &flow->flags) &&
 	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 }
 
-- 
2.53.0



