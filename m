Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9879D3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E45CC433C0;
	Mon, 19 Jun 2023 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171144;
	bh=stPe9b63U5cT0SiAJofv2e8YadX5D58QS4E1dJJg8Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEAFAeF/9GP+dNCskSnZykbJvGLNgVxxQ1MRyQUdC8RsvO8x76YSaLTZIJ5l47UbY
	 8AhHWFHv4HmQ+ji2jW1XNZcGVjOS4tVFtw0UFfG5hmiM+XRqnIiUo1YXsz4fwX2hdH
	 732bTqv5qfUbw0g5xtFQ4oTMuVBK7qzDzna6EeMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Paul Blakey <paulb@nvidia.com>,
	Florian Westphal <fw@strlen.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 164/187] net/sched: act_ct: Fix promotion of offloaded unreplied tuple
Date: Mon, 19 Jun 2023 12:29:42 +0200
Message-ID: <20230619102205.550181130@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 04bd0ed4d2ae7..b0ef48b21dcb4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -317,12 +317,12 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
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
@@ -334,6 +334,12 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
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
@@ -423,7 +429,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct))
+	    nf_ct_is_dying(flow->ct) ||
+	    nf_flow_is_outdated(flow))
 		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19efba1e51ef9..3bbaf9c7ea46a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -384,7 +384,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-	flow_offload_refresh(flow_table, flow);
+	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
 	thoff -= offset;
@@ -650,7 +650,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-	flow_offload_refresh(flow_table, flow);
+	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9cc0bc7c71ed7..abc71a06d634a 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -610,6 +610,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	struct flow_offload_tuple tuple = {};
 	enum ip_conntrack_info ctinfo;
 	struct tcphdr *tcph = NULL;
+	bool force_refresh = false;
 	struct flow_offload *flow;
 	struct nf_conn *ct;
 	u8 dir;
@@ -647,6 +648,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 			 * established state, then don't refresh.
 			 */
 			return false;
+		force_refresh = true;
 	}
 
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
@@ -660,7 +662,12 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
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
2.39.2



