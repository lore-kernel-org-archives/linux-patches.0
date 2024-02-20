Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F361151CE1;
	Tue, 20 Feb 2024 21:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464503; cv=none; b=e8R6uRq6WpEOsDJXRaFZ+3wKC1PSXeVTSgiTKa2udq73oNBxNBbLL/KAMoX0Rzd+mBsgOiYcKe7T1+lKEbGv6aKbgc+xMzVabpQDh0XmOVW9RCM0p10xpP7bM9yD1u0UJCwaE5ZQV2brjc/66SM2/YO7ccTKKARRQ4MTmeLfV1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464503; c=relaxed/simple;
	bh=vhqfVl1QigxQ9daV1j8ZpmoxHJzkxAfVEyKB3BBZrzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eruISKXsiLFFbkutvYZT70KJEMr5tkXIzvkBXrPibP5JZi89LRK4l6fjCX49eWuCVfgm9sRwRyH9ndHUE1iX50b9kn4BRoD/oXzY1s5WLVeNx1Scwa+TI7XpfUplqsZA+dm31CnazCWEmZztz1B1hDBhZoqRSuYR4Wy1Ob6EtPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cy+8ZHPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cy+8ZHPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E90C433C7;
	Tue, 20 Feb 2024 21:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464503;
	bh=vhqfVl1QigxQ9daV1j8ZpmoxHJzkxAfVEyKB3BBZrzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cy+8ZHPMOolhGiVEMTWGNgJ/YyKY7acu4NsINf8o870MpaoKVEA7rjfSsi7hsjZZ8
	 r1eJdgXd7C4SgIIyuh9WXiBXcBTs7e+W/AKX7ti5AEvjVgqMDZEEfkHdENgTzbgzJM
	 sdefg0JiLBHT/99sAhyK0v1H0qSTuxwXx9JCimkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Conole <aconole@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 045/309] net: openvswitch: limit the number of recursions from action sets
Date: Tue, 20 Feb 2024 21:53:24 +0100
Message-ID: <20240220205634.596522698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit 6e2f90d31fe09f2b852de25125ca875aabd81367 ]

The ovs module allows for some actions to recursively contain an action
list for complex scenarios, such as sampling, checking lengths, etc.
When these actions are copied into the internal flow table, they are
evaluated to validate that such actions make sense, and these calls
happen recursively.

The ovs-vswitchd userspace won't emit more than 16 recursion levels
deep.  However, the module has no such limit and will happily accept
limits larger than 16 levels nested.  Prevent this by tracking the
number of recursions happening and manually limiting it to 16 levels
nested.

The initial implementation of the sample action would track this depth
and prevent more than 3 levels of recursion, but this was removed to
support the clone use case, rather than limited at the current userspace
limit.

Fixes: 798c166173ff ("openvswitch: Optimize sample action for the clone use cases")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240207132416.1488485-2-aconole@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow_netlink.c | 49 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 88965e2068ac..ebc5728aab4e 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -48,6 +48,7 @@ struct ovs_len_tbl {
 
 #define OVS_ATTR_NESTED -1
 #define OVS_ATTR_VARIABLE -2
+#define OVS_COPY_ACTIONS_MAX_DEPTH 16
 
 static bool actions_may_change_flow(const struct nlattr *actions)
 {
@@ -2545,13 +2546,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 				  const struct sw_flow_key *key,
 				  struct sw_flow_actions **sfa,
 				  __be16 eth_type, __be16 vlan_tci,
-				  u32 mpls_label_count, bool log);
+				  u32 mpls_label_count, bool log,
+				  u32 depth);
 
 static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 				    const struct sw_flow_key *key,
 				    struct sw_flow_actions **sfa,
 				    __be16 eth_type, __be16 vlan_tci,
-				    u32 mpls_label_count, bool log, bool last)
+				    u32 mpls_label_count, bool log, bool last,
+				    u32 depth)
 {
 	const struct nlattr *attrs[OVS_SAMPLE_ATTR_MAX + 1];
 	const struct nlattr *probability, *actions;
@@ -2602,7 +2605,8 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 		return err;
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 
 	if (err)
 		return err;
@@ -2617,7 +2621,8 @@ static int validate_and_copy_dec_ttl(struct net *net,
 				     const struct sw_flow_key *key,
 				     struct sw_flow_actions **sfa,
 				     __be16 eth_type, __be16 vlan_tci,
-				     u32 mpls_label_count, bool log)
+				     u32 mpls_label_count, bool log,
+				     u32 depth)
 {
 	const struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1];
 	int start, action_start, err, rem;
@@ -2660,7 +2665,8 @@ static int validate_and_copy_dec_ttl(struct net *net,
 		return action_start;
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
-				     vlan_tci, mpls_label_count, log);
+				     vlan_tci, mpls_label_count, log,
+				     depth + 1);
 	if (err)
 		return err;
 
@@ -2674,7 +2680,8 @@ static int validate_and_copy_clone(struct net *net,
 				   const struct sw_flow_key *key,
 				   struct sw_flow_actions **sfa,
 				   __be16 eth_type, __be16 vlan_tci,
-				   u32 mpls_label_count, bool log, bool last)
+				   u32 mpls_label_count, bool log, bool last,
+				   u32 depth)
 {
 	int start, err;
 	u32 exec;
@@ -2694,7 +2701,8 @@ static int validate_and_copy_clone(struct net *net,
 		return err;
 
 	err = __ovs_nla_copy_actions(net, attr, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 	if (err)
 		return err;
 
@@ -3063,7 +3071,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 					   struct sw_flow_actions **sfa,
 					   __be16 eth_type, __be16 vlan_tci,
 					   u32 mpls_label_count,
-					   bool log, bool last)
+					   bool log, bool last, u32 depth)
 {
 	const struct nlattr *acts_if_greater, *acts_if_lesser_eq;
 	struct nlattr *a[OVS_CHECK_PKT_LEN_ATTR_MAX + 1];
@@ -3111,7 +3119,8 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 		return nested_acts_start;
 
 	err = __ovs_nla_copy_actions(net, acts_if_lesser_eq, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 
 	if (err)
 		return err;
@@ -3124,7 +3133,8 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 		return nested_acts_start;
 
 	err = __ovs_nla_copy_actions(net, acts_if_greater, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 
 	if (err)
 		return err;
@@ -3152,12 +3162,16 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 				  const struct sw_flow_key *key,
 				  struct sw_flow_actions **sfa,
 				  __be16 eth_type, __be16 vlan_tci,
-				  u32 mpls_label_count, bool log)
+				  u32 mpls_label_count, bool log,
+				  u32 depth)
 {
 	u8 mac_proto = ovs_key_mac_proto(key);
 	const struct nlattr *a;
 	int rem, err;
 
+	if (depth > OVS_COPY_ACTIONS_MAX_DEPTH)
+		return -EOVERFLOW;
+
 	nla_for_each_nested(a, attr, rem) {
 		/* Expected argument lengths, (u32)-1 for variable length. */
 		static const u32 action_lens[OVS_ACTION_ATTR_MAX + 1] = {
@@ -3355,7 +3369,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			err = validate_and_copy_sample(net, a, key, sfa,
 						       eth_type, vlan_tci,
 						       mpls_label_count,
-						       log, last);
+						       log, last, depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3426,7 +3440,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			err = validate_and_copy_clone(net, a, key, sfa,
 						      eth_type, vlan_tci,
 						      mpls_label_count,
-						      log, last);
+						      log, last, depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3440,7 +3454,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 							      eth_type,
 							      vlan_tci,
 							      mpls_label_count,
-							      log, last);
+							      log, last,
+							      depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3450,7 +3465,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_DEC_TTL:
 			err = validate_and_copy_dec_ttl(net, a, key, sfa,
 							eth_type, vlan_tci,
-							mpls_label_count, log);
+							mpls_label_count, log,
+							depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3495,7 +3511,8 @@ int ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 	(*sfa)->orig_len = nla_len(attr);
 	err = __ovs_nla_copy_actions(net, attr, key, sfa, key->eth.type,
-				     key->eth.vlan.tci, mpls_label_count, log);
+				     key->eth.vlan.tci, mpls_label_count, log,
+				     0);
 	if (err)
 		ovs_nla_free_flow_actions(*sfa);
 
-- 
2.43.0



