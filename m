Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B6E52F86;
	Mon,  8 Jan 2024 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2E/jyXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94371C433CA;
	Mon,  8 Jan 2024 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728654;
	bh=Y/fCQ32omP6gbpJvoj7GNgl2UJOwcgO5V/hWSRQYlvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2E/jyXgGl/4IgJqZoOcxfOhM49oWvVlMV0kkdZC6QLWqRtkNpR2UPLh/YY10fr9+
	 qlEbEkjDB4wOD934/pMmCs/ZLLi+Lr6EMDU4w5F38U5kqmo9SQxN6RUbX5yeesVEiq
	 2JwBn0ndmUEFxuuCKoL+WbNklpNcnKpF/jxOIeeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 145/150] net/sched: act_ct: Always fill offloading tuple iifidx
Date: Mon,  8 Jan 2024 16:36:36 +0100
Message-ID: <20240108153517.891554132@linuxfoundation.org>
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

commit 9bc64bd0cd765f696fcd40fc98909b1f7c73b2ba upstream.

Referenced commit doesn't always set iifidx when offloading the flow to
hardware. Fix the following cases:

- nf_conn_act_ct_ext_fill() is called before extension is created with
nf_conn_act_ct_ext_add() in tcf_ct_act(). This can cause rule offload with
unspecified iifidx when connection is offloaded after only single
original-direction packet has been processed by tc data path. Always fill
the new nf_conn_act_ct_ext instance after creating it in
nf_conn_act_ct_ext_add().

- Offloading of unidirectional UDP NEW connections is now supported, but ct
flow iifidx field is not updated when connection is promoted to
bidirectional which can result reply-direction iifidx to be zero when
refreshing the connection. Fill in the extension and update flow iifidx
before calling flow_offload_refresh().

Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tuple iifidx")
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 6a9bad0069cf ("net/sched: act_ct: offload UDP NEW connections")
Link: https://lore.kernel.org/r/20231103151410.764271-1-vladbu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack_act_ct.h |   30 +++++++++++++++-------------
 net/openvswitch/conntrack.c                 |    2 -
 net/sched/act_ct.c                          |   15 +++++++++++++-
 3 files changed, 32 insertions(+), 15 deletions(-)

--- a/include/net/netfilter/nf_conntrack_act_ct.h
+++ b/include/net/netfilter/nf_conntrack_act_ct.h
@@ -20,7 +20,22 @@ static inline struct nf_conn_act_ct_ext
 #endif
 }
 
-static inline struct nf_conn_act_ct_ext *nf_conn_act_ct_ext_add(struct nf_conn *ct)
+static inline void nf_conn_act_ct_ext_fill(struct sk_buff *skb, struct nf_conn *ct,
+					   enum ip_conntrack_info ctinfo)
+{
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+	struct nf_conn_act_ct_ext *act_ct_ext;
+
+	act_ct_ext = nf_conn_act_ct_ext_find(ct);
+	if (dev_net(skb->dev) == &init_net && act_ct_ext)
+		act_ct_ext->ifindex[CTINFO2DIR(ctinfo)] = skb->dev->ifindex;
+#endif
+}
+
+static inline struct
+nf_conn_act_ct_ext *nf_conn_act_ct_ext_add(struct sk_buff *skb,
+					   struct nf_conn *ct,
+					   enum ip_conntrack_info ctinfo)
 {
 #if IS_ENABLED(CONFIG_NET_ACT_CT)
 	struct nf_conn_act_ct_ext *act_ct = nf_ct_ext_find(ct, NF_CT_EXT_ACT_CT);
@@ -29,22 +44,11 @@ static inline struct nf_conn_act_ct_ext
 		return act_ct;
 
 	act_ct = nf_ct_ext_add(ct, NF_CT_EXT_ACT_CT, GFP_ATOMIC);
+	nf_conn_act_ct_ext_fill(skb, ct, ctinfo);
 	return act_ct;
 #else
 	return NULL;
 #endif
 }
 
-static inline void nf_conn_act_ct_ext_fill(struct sk_buff *skb, struct nf_conn *ct,
-					   enum ip_conntrack_info ctinfo)
-{
-#if IS_ENABLED(CONFIG_NET_ACT_CT)
-	struct nf_conn_act_ct_ext *act_ct_ext;
-
-	act_ct_ext = nf_conn_act_ct_ext_find(ct);
-	if (dev_net(skb->dev) == &init_net && act_ct_ext)
-		act_ct_ext->ifindex[CTINFO2DIR(ctinfo)] = skb->dev->ifindex;
-#endif
-}
-
 #endif /* _NF_CONNTRACK_ACT_CT_H */
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1252,7 +1252,7 @@ static int ovs_ct_commit(struct net *net
 		if (err)
 			return err;
 
-		nf_conn_act_ct_ext_add(ct);
+		nf_conn_act_ct_ext_add(skb, ct, ctinfo);
 	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
 		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -394,6 +394,17 @@ static void tcf_ct_flow_tc_ifidx(struct
 	entry->tuplehash[dir].tuple.tc.iifidx = act_ct_ext->ifindex[dir];
 }
 
+static void tcf_ct_flow_ct_ext_ifidx_update(struct flow_offload *entry)
+{
+	struct nf_conn_act_ct_ext *act_ct_ext;
+
+	act_ct_ext = nf_conn_act_ct_ext_find(entry->ct);
+	if (act_ct_ext) {
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_ORIGINAL);
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_REPLY);
+	}
+}
+
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
 				  bool tcp, bool bidirectional)
@@ -689,6 +700,8 @@ static bool tcf_ct_flow_table_lookup(str
 	else
 		ctinfo = IP_CT_ESTABLISHED_REPLY;
 
+	nf_conn_act_ct_ext_fill(skb, ct, ctinfo);
+	tcf_ct_flow_ct_ext_ifidx_update(flow);
 	flow_offload_refresh(nf_ft, flow, force_refresh);
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status)) {
 		/* Process this flow in SW to allow promoting to ASSURED */
@@ -1191,7 +1204,7 @@ do_nat:
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
 
 		if (!nf_ct_is_confirmed(ct))
-			nf_conn_act_ct_ext_add(ct);
+			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
 
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.


