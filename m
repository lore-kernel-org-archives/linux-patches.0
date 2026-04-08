Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018D3D8912;
	Wed,  8 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674423; cv=none; b=CriKVtgKZ6/OTxS6i+rON4DhPUmLq6uFG/m0wgMZMm8dCcBLpJK3YxulGEZDn+ZdXpiOVGOUlgZhw3G4TUAWrdMRNxFH/gV/tJcORWc+nKveLnB+6QGdXtHZFI0JmViLTCji3jVKec0Putwj0/8KLF3lHTj9pAoYLJD89qaOLbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674423; c=relaxed/simple;
	bh=RfEe1PSMcBejff4YQRMKF+94q63CDTtp3O9uqAFA/4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpysMj7Cgwhe05X1Ns/gPakDAKnTlst0ippIusFOb3uNRkiCTwBdUYEAoMlrN8xDGCWb6d9mklxRe5fpauyfrFtXUdnaxHSduCwmeDYAOCT4onvio8evu1uobA46E1vvb0631aJcbQpmy1TWwtN7WlF0eEST1Q6oSOpMM7Nocvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMk3raXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMk3raXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894D1C19421;
	Wed,  8 Apr 2026 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674422;
	bh=RfEe1PSMcBejff4YQRMKF+94q63CDTtp3O9uqAFA/4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMk3raXy5I/hv2RyoSqTba1yGsJlCC4CDwpzDuTQ3uv6POcGBdyX+mSKWtaimKfK8
	 QbNCZwvGKoxWj2evLyXPrtUDu+MXmw07dGTOiC61XY2QwbFTab2HzVr81Tn2mZrFjI
	 2ZoB/6yMlaSfRwnbK9GzwId6vxs7wivpDASpavNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 091/311] netfilter: nf_conntrack_expect: store netns and zone in expectation
Date: Wed,  8 Apr 2026 20:01:31 +0200
Message-ID: <20260408175942.811263177@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 02a3231b6d82efe750da6554ebf280e4a6f78756 ]

__nf_ct_expect_find() and nf_ct_expect_find_get() are called under
rcu_read_lock() but they dereference the master conntrack via
exp->master.

Since the expectation does not hold a reference on the master conntrack,
this could be dying conntrack or different recycled conntrack than the
real master due to SLAB_TYPESAFE_RCU.

Store the netns, the master_tuple and the zone in struct
nf_conntrack_expect as a safety measure.

This patch is required by the follow up fix not to dump expectations
that do not belong to this netns.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++++++++++-
 net/netfilter/nf_conntrack_broadcast.c      |  6 +++++-
 net/netfilter/nf_conntrack_expect.c         |  9 +++++++--
 net/netfilter/nf_conntrack_netlink.c        |  5 +++++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 1b01400b10bdb..e9a8350e7ccfb 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -22,10 +22,16 @@ struct nf_conntrack_expect {
 	/* Hash member */
 	struct hlist_node hnode;
 
+	/* Network namespace */
+	possible_net_t net;
+
 	/* We expect this tuple, with the following mask */
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	struct nf_conntrack_zone zone;
+#endif
 	/* Usage count. */
 	refcount_t use;
 
@@ -62,7 +68,17 @@ struct nf_conntrack_expect {
 
 static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
 {
-	return nf_ct_net(exp->master);
+	return read_pnet(&exp->net);
+}
+
+static inline bool nf_ct_exp_zone_equal_any(const struct nf_conntrack_expect *a,
+					    const struct nf_conntrack_zone *b)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	return a->zone.id == b->id;
+#else
+	return true;
+#endif
 }
 
 #define NF_CT_EXP_POLICY_NAME_LEN	16
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 1964c596c6468..4f39bf7c843f2 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -21,6 +21,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 				unsigned int timeout)
 {
 	const struct nf_conntrack_helper *helper;
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_expect *exp;
 	struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt = skb_rtable(skb);
@@ -71,7 +72,10 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	rcu_assign_pointer(exp->helper, helper);
-
+	write_pnet(&exp->net, net);
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	exp->zone = ct->zone;
+#endif
 	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index b37ff73efb3e2..2234c444a320e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -112,8 +112,8 @@ nf_ct_exp_equal(const struct nf_conntrack_tuple *tuple,
 		const struct net *net)
 {
 	return nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
-	       net_eq(net, nf_ct_net(i->master)) &&
-	       nf_ct_zone_equal_any(i->master, zone);
+	       net_eq(net, read_pnet(&i->net)) &&
+	       nf_ct_exp_zone_equal_any(i, zone);
 }
 
 bool nf_ct_remove_expect(struct nf_conntrack_expect *exp)
@@ -321,6 +321,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 {
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn *ct = exp->master;
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conn_help *help;
 	int len;
 
@@ -338,6 +339,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		helper = rcu_dereference(help->helper);
 
 	rcu_assign_pointer(exp->helper, helper);
+	write_pnet(&exp->net, net);
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	exp->zone = ct->zone;
+#endif
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 66a87b0ed46c4..f5db3c6c485ae 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3521,6 +3521,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
 	u32 class = 0;
@@ -3560,6 +3561,10 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
+	write_pnet(&exp->net, net);
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	exp->zone = ct->zone;
+#endif
 	if (!helper)
 		helper = rcu_dereference(help->helper);
 	rcu_assign_pointer(exp->helper, helper);
-- 
2.53.0



