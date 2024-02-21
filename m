Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B497FBBA;
	Wed, 21 Feb 2024 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524591; cv=none; b=aEUgcrz6yJvCMfne4ie9HnADgYyXTo6SNdwgxWaU+4LDqFKbOnr1YSq50F1+JlRTasuM4h7Zel40UW+ZC9094bqWdGA+TUom/SVqD/GtWurLI4Tp4urOrPUUs3WF7PUQnupSDVPIS552ty1CqWAdC/Q0tgzHP98x6JXOCUHuBFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524591; c=relaxed/simple;
	bh=Eq95fz+wgfgvQMkKi1SEE+GxZj9XBvyRqFL9ZbWLvEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkqYxBGBdXEWowyt/iEl0ni5PNidvhLk1OdU69OKSaY/T8376t5gU2r70csuhTdKj0h2vrbakD38HnNLf2eePNoQv1UKHkQz2WseU2Np8N06mk9c4n8/FN+f4eBEeNeqgyj71MHlXq+m9qZbL8sf8w7QPqMXC9zteBsbdtF5No8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xJR8YdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xJR8YdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC64C433C7;
	Wed, 21 Feb 2024 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524590;
	bh=Eq95fz+wgfgvQMkKi1SEE+GxZj9XBvyRqFL9ZbWLvEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xJR8YdG0FlO0lhFjqqCIAWUGJd4BvRekqcgn2dfURzXKyaWixB7V4zeSp8KAZYae
	 plI8bEMqN16XY46/A/A6i2Mp6Pwr9kfj1OEGARL4eZh66KXNTKtOS5TfHsWx8HAbuQ
	 JUqyeePovI0wqlTTcPAzM/QJi9Zdeppk/zrn9PHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Conole <aconole@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/379] net: openvswitch: limit the number of recursions from action sets
Date: Wed, 21 Feb 2024 14:07:50 +0100
Message-ID: <20240221130003.517206236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 293a798e89f4..cff18a5bbf38 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -47,6 +47,7 @@ struct ovs_len_tbl {
 
 #define OVS_ATTR_NESTED -1
 #define OVS_ATTR_VARIABLE -2
+#define OVS_COPY_ACTIONS_MAX_DEPTH 16
 
 static bool actions_may_change_flow(const struct nlattr *actions)
 {
@@ -2514,13 +2515,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
@@ -2571,7 +2574,8 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 		return err;
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 
 	if (err)
 		return err;
@@ -2586,7 +2590,8 @@ static int validate_and_copy_dec_ttl(struct net *net,
 				     const struct sw_flow_key *key,
 				     struct sw_flow_actions **sfa,
 				     __be16 eth_type, __be16 vlan_tci,
-				     u32 mpls_label_count, bool log)
+				     u32 mpls_label_count, bool log,
+				     u32 depth)
 {
 	const struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1];
 	int start, action_start, err, rem;
@@ -2619,7 +2624,8 @@ static int validate_and_copy_dec_ttl(struct net *net,
 		return action_start;
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
-				     vlan_tci, mpls_label_count, log);
+				     vlan_tci, mpls_label_count, log,
+				     depth + 1);
 	if (err)
 		return err;
 
@@ -2633,7 +2639,8 @@ static int validate_and_copy_clone(struct net *net,
 				   const struct sw_flow_key *key,
 				   struct sw_flow_actions **sfa,
 				   __be16 eth_type, __be16 vlan_tci,
-				   u32 mpls_label_count, bool log, bool last)
+				   u32 mpls_label_count, bool log, bool last,
+				   u32 depth)
 {
 	int start, err;
 	u32 exec;
@@ -2653,7 +2660,8 @@ static int validate_and_copy_clone(struct net *net,
 		return err;
 
 	err = __ovs_nla_copy_actions(net, attr, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 	if (err)
 		return err;
 
@@ -3022,7 +3030,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 					   struct sw_flow_actions **sfa,
 					   __be16 eth_type, __be16 vlan_tci,
 					   u32 mpls_label_count,
-					   bool log, bool last)
+					   bool log, bool last, u32 depth)
 {
 	const struct nlattr *acts_if_greater, *acts_if_lesser_eq;
 	struct nlattr *a[OVS_CHECK_PKT_LEN_ATTR_MAX + 1];
@@ -3070,7 +3078,8 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 		return nested_acts_start;
 
 	err = __ovs_nla_copy_actions(net, acts_if_lesser_eq, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 
 	if (err)
 		return err;
@@ -3083,7 +3092,8 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 		return nested_acts_start;
 
 	err = __ovs_nla_copy_actions(net, acts_if_greater, key, sfa,
-				     eth_type, vlan_tci, mpls_label_count, log);
+				     eth_type, vlan_tci, mpls_label_count, log,
+				     depth + 1);
 
 	if (err)
 		return err;
@@ -3111,12 +3121,16 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
@@ -3311,7 +3325,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			err = validate_and_copy_sample(net, a, key, sfa,
 						       eth_type, vlan_tci,
 						       mpls_label_count,
-						       log, last);
+						       log, last, depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3382,7 +3396,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			err = validate_and_copy_clone(net, a, key, sfa,
 						      eth_type, vlan_tci,
 						      mpls_label_count,
-						      log, last);
+						      log, last, depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3396,7 +3410,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 							      eth_type,
 							      vlan_tci,
 							      mpls_label_count,
-							      log, last);
+							      log, last,
+							      depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3406,7 +3421,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_DEC_TTL:
 			err = validate_and_copy_dec_ttl(net, a, key, sfa,
 							eth_type, vlan_tci,
-							mpls_label_count, log);
+							mpls_label_count, log,
+							depth);
 			if (err)
 				return err;
 			skip_copy = true;
@@ -3446,7 +3462,8 @@ int ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 	(*sfa)->orig_len = nla_len(attr);
 	err = __ovs_nla_copy_actions(net, attr, key, sfa, key->eth.type,
-				     key->eth.vlan.tci, mpls_label_count, log);
+				     key->eth.vlan.tci, mpls_label_count, log,
+				     0);
 	if (err)
 		ovs_nla_free_flow_actions(*sfa);
 
-- 
2.43.0



