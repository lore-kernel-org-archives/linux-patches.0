Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22111537E3;
	Mon,  8 Jan 2024 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvzpmsGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EBDC433C7;
	Mon,  8 Jan 2024 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728670;
	bh=JXPMbjN82ScDwLMyB4couM3pn+4slg1Pdrv/ULQzMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvzpmsGZKjwmj6prPsuQ4G4BjYkIjv9Uffghn5qywfGu9d4cim7/gCr2MncoOYcTN
	 wmP47k/dy1ewZ5gF2kBy80/8lN4i0sPMIp1LbAxC5OTSC3b6sllaZN2JDZcF4dfQvX
	 zM1O4XFnOl8EYyK/loSADJj1KuMB491M7BCp4Mao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/150] netfilter: flowtable: cache info of last offload
Date: Mon,  8 Jan 2024 16:36:13 +0100
Message-ID: <20240108153516.820414538@linuxfoundation.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 1a441a9b8be8849957a01413a144f84932c324cb ]

Modify flow table offload to cache the last ct info status that was passed
to the driver offload callbacks by extending enum nf_flow_flags with new
"NF_FLOW_HW_ESTABLISHED" flag. Set the flag if ctinfo was 'established'
during last act_ct meta actions fill call. This infrastructure change is
necessary to optimize promoting of UDP connections from 'new' to
'established' in following patches in this series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 125f1c7f26ff ("net/sched: act_ct: Take per-cb reference to tcf_ct_flow_table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  7 ++++---
 net/netfilter/nf_flow_table_inet.c    |  2 +-
 net/netfilter/nf_flow_table_offload.c |  6 +++---
 net/sched/act_ct.c                    | 12 +++++++-----
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 88ab98ab41d9f..ebb28ec5b6faf 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -57,7 +57,7 @@ struct nf_flowtable_type {
 						 struct net_device *dev,
 						 enum flow_block_command cmd);
 	int				(*action)(struct net *net,
-						  const struct flow_offload *flow,
+						  struct flow_offload *flow,
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
 	void				(*free)(struct nf_flowtable *ft);
@@ -165,6 +165,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
+	NF_FLOW_HW_ESTABLISHED,
 };
 
 enum flow_offload_type {
@@ -313,10 +314,10 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
-int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
 
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 0ccabf3fa6aa3..9505f9d188ff2 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -39,7 +39,7 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 }
 
 static int nf_flow_rule_route_inet(struct net *net,
-				   const struct flow_offload *flow,
+				   struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
 				   struct nf_flow_rule *flow_rule)
 {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8b852f10fab4b..1c26f03fc6617 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,7 +679,7 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
@@ -704,7 +704,7 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv4);
 
-int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
@@ -735,7 +735,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 {
 	const struct nf_flowtable *flowtable = offload->flowtable;
 	const struct flow_offload_tuple *tuple, *other_tuple;
-	const struct flow_offload *flow = offload->flow;
+	struct flow_offload *flow = offload->flow;
 	struct dst_entry *other_dst = NULL;
 	struct nf_flow_rule *flow_rule;
 	int err = -ENOMEM;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 478cedc29b737..86d269724485a 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -168,11 +168,11 @@ tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
 
 static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 					      enum ip_conntrack_dir dir,
+					      enum ip_conntrack_info ctinfo,
 					      struct flow_action *action)
 {
 	struct nf_conn_labels *ct_labels;
 	struct flow_action_entry *entry;
-	enum ip_conntrack_info ctinfo;
 	u32 *act_ct_labels;
 
 	entry = tcf_ct_flow_table_flow_action_get_next(action);
@@ -180,8 +180,6 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
-	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-					     IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
@@ -235,22 +233,26 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
 }
 
 static int tcf_ct_flow_table_fill_actions(struct net *net,
-					  const struct flow_offload *flow,
+					  struct flow_offload *flow,
 					  enum flow_offload_tuple_dir tdir,
 					  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action *action = &flow_rule->rule->action;
 	int num_entries = action->num_entries;
 	struct nf_conn *ct = flow->ct;
+	enum ip_conntrack_info ctinfo;
 	enum ip_conntrack_dir dir;
 	int i, err;
 
 	switch (tdir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		dir = IP_CT_DIR_ORIGINAL;
+		ctinfo = IP_CT_ESTABLISHED;
+		set_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
 		dir = IP_CT_DIR_REPLY;
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -260,7 +262,7 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	if (err)
 		goto err_nat;
 
-	tcf_ct_flow_table_add_action_meta(ct, dir, action);
+	tcf_ct_flow_table_add_action_meta(ct, dir, ctinfo, action);
 	return 0;
 
 err_nat:
-- 
2.43.0



