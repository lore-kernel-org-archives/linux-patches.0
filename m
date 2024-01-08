Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C84C602;
	Mon,  8 Jan 2024 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIWTIOzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77A6C433C9;
	Mon,  8 Jan 2024 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728677;
	bh=dp1xJT1SZ0VnldwR+ozHzqwiQrF6hDgFyIIG0Gprn+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIWTIOzxEubcpU3PJSO0LDJFOG7AwZ8LdIAql3GVA+2eQj0ooaTo6LpsUzZq2zGDe
	 DANpf8SkcQ3wMg8ThHO271+HtnTV6AXXotlCgWFWgmEpR2kjtx6+VJDM0kibW/RX9A
	 zH1HIwU706f3stsT6qjyJ+2qQ3xoKwx5c742KCYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Paul Blakey <paulb@nvidia.com>,
	Florian Westphal <fw@strlen.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/150] net/sched: act_ct: Fix promotion of offloaded unreplied tuple
Date: Mon,  8 Jan 2024 16:36:15 +0100
Message-ID: <20240108153516.919632274@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 41f2c7c342d3adb1c4dd5f2e3dd831adff16a669 ]

Currently UNREPLIED and UNASSURED connections are added to the nf flow
table. This causes the following connection packets to be processed
by the flow table which then skips conntrack_in(), and thus such the
connections will remain UNREPLIED and UNASSURED even if reply traffic
is then seen. Even still, the unoffloaded reply packets are the ones
triggering hardware update from new to established state, and if
there aren't any to triger an update and/or previous update was
missed, hardware can get out of sync with sw and still mark
packets as new.

Fix the above by:
1) Not skipping conntrack_in() for UNASSURED packets, but still
   refresh for hardware, as before the cited patch.
2) Try and force a refresh by reply-direction packets that update
   the hardware rules from new to established state.
3) Remove any bidirectional flows that didn't failed to update in
   hardware for re-insertion as bidrectional once any new packet
   arrives.

Fixes: 6a9bad0069cf ("net/sched: act_ct: offload UDP NEW connections")
Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/1686313379-117663-1-git-send-email-paulb@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 125f1c7f26ff ("net/sched: act_ct: Take per-cb reference to tcf_ct_flow_table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 13 ++++++++++---
 net/netfilter/nf_flow_table_ip.c      |  4 ++--
 net/sched/act_ct.c                    |  9 ++++++++-
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ebb28ec5b6faf..f37f9f34430c1 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -268,7 +268,7 @@ int flow_offload_route_init(struct flow_offload *flow,
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
-			  struct flow_offload *flow);
+			  struct flow_offload *flow, bool force);
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30bb..baddb93a5e8cf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -314,12 +314,12 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
 void flow_offload_refresh(struct nf_flowtable *flow_table,
-			  struct flow_offload *flow)
+			  struct flow_offload *flow, bool force)
 {
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (timeout - READ_ONCE(flow->timeout) > HZ)
+	if (force || timeout - READ_ONCE(flow->timeout) > HZ)
 		WRITE_ONCE(flow->timeout, timeout);
 	else
 		return;
@@ -331,6 +331,12 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
+static bool nf_flow_is_outdated(const struct flow_offload *flow)
+{
+	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
+		!test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
+}
+
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
 	return nf_flow_timeout_delta(flow->timeout) <= 0;
@@ -420,7 +426,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct))
+	    nf_ct_is_dying(flow->ct) ||
+	    nf_flow_is_outdated(flow))
 		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b350fe9d00b0b..6feaac9ab05c8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -384,7 +384,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-	flow_offload_refresh(flow_table, flow);
+	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
 	thoff -= offset;
@@ -646,7 +646,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-	flow_offload_refresh(flow_table, flow);
+	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 3c063065f125f..b80a58d3bf0f3 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -606,6 +606,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	struct flow_offload_tuple tuple = {};
 	enum ip_conntrack_info ctinfo;
 	struct tcphdr *tcph = NULL;
+	bool force_refresh = false;
 	struct flow_offload *flow;
 	struct nf_conn *ct;
 	u8 dir;
@@ -643,6 +644,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 			 * established state, then don't refresh.
 			 */
 			return false;
+		force_refresh = true;
 	}
 
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
@@ -656,7 +658,12 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	else
 		ctinfo = IP_CT_ESTABLISHED_REPLY;
 
-	flow_offload_refresh(nf_ft, flow);
+	flow_offload_refresh(nf_ft, flow, force_refresh);
+	if (!test_bit(IPS_ASSURED_BIT, &ct->status)) {
+		/* Process this flow in SW to allow promoting to ASSURED */
+		return false;
+	}
+
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
 	if (nf_ft->flags & NF_FLOWTABLE_COUNTER)
-- 
2.43.0



