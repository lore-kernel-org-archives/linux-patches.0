Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD6446EF8D;
	Tue, 21 Jul 2026 18:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659445; cv=none; b=P1kxnupViGJF1UOwT0lsAxQHsuRN3OUTiK2N2vk+WGTxVwf7KQrjDoeAbHEryrIIGAI6TpyeRxAWJiAh0Y3ymABzouPyh+Vwu2L2D0EJW6GH/0nYdXxd7VzzRVs2UNeCpGULaQ8owRKsnUYknLRt599vDvtSaIHBAqO0uiimJkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659445; c=relaxed/simple;
	bh=hBzE3lDVobJNumWxV5tPijlzjrkDh9lS2hiIv9rxTL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+rcQMia/c3P7w2RfAWXg38MxZ5mJHhy1NVyx0wtVTh4UslAHetwoGJaj/TBx1JkkyT0Y7Ej91kALW5JBzDjyjL+4pnW11PhBxMOMCMUumbRhFN7nKmZH/4MUjYiRl6OhSG7FSYUR8bw7CdjCfgIOhCTl6V3BLYjviGe8CwoHXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk46XXRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk46XXRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723331F000E9;
	Tue, 21 Jul 2026 18:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659443;
	bh=7V3BXF1B2K+8KIgof8lVwyXtbHiJohkbJ69kMHsqVDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk46XXReqVRqRdERmcLx4faRx9tUEdkoxt0AL8brXNZ6IgpBItxv61WbenlO0ytYY
	 FsVWkOZ+Y3/eK2sII5nibbsnY+2d7Wq/Jq/ctm2t7A0vln7kVmMBjGyS7IFUN09Zh+
	 /zGQSMhBVsuzak9sjEUf3VPg5Cyac9z03LIQV/SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1486/1611] net: openvswitch: reject oversized nested action attrs
Date: Tue, 21 Jul 2026 17:26:42 +0200
Message-ID: <20260721152548.869820733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit 3f1f755366687d051174739fb99f7d560202f60b upstream.

Open vSwitch stores generated flow actions as nlattrs, whose nla_len
field is u16. Commit a1e64addf3ff ("net: openvswitch: remove
misbehaving actions length check") allowed the total sw_flow_actions
stream to grow beyond 64 KiB, which is valid, but also removed the last
guard preventing a generated nested action attribute from exceeding
U16_MAX.

An oversized generated container can thus be closed with a truncated
nla_len. A later dump or teardown then walks a structurally different
stream than the one that was validated. In particular, an oversized
nested CLONE/CT action may cause subsequent bytes in the generated
stream to be interpreted as independent actions.

Keep the larger total-action-stream behavior, but make nested action
close reject generated containers that do not fit in nla_len, and return
the error through all callers. For recursive SAMPLE, CLONE, DEC_TTL, and
CHECK_PKT_LEN builders, trim resource-owning action-list tails in reverse
construction order before discarding failed wrappers, so resources copied
into the rejected tails are released before the wrappers are removed.

Most failed outer wrappers are discarded by truncating actions_len after
child resources have been released. CHECK_PKT_LEN also trims its parent
after branch resources are gone. SET/TUNNEL close failures unwind their
known tun_dst ownership directly, and SET_TO_MASKED has no external
ownership and truncates on close failure.

Fixes: a1e64addf3ff ("net: openvswitch: remove misbehaving actions length check")
Cc: stable@vger.kernel.org
Assisted-by: avom-custom-harness:gpt-5.5-qwen3.6-mod-mix
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260706094336.38639-1-manizada@pm.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow_netlink.c |  201 ++++++++++++++++++++++++++++++++---------
 1 file changed, 157 insertions(+), 44 deletions(-)

--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2496,13 +2496,56 @@ static inline int add_nested_action_star
 	return used;
 }
 
-static inline void add_nested_action_end(struct sw_flow_actions *sfa,
-					 int st_offset)
+static inline int add_nested_action_end(struct sw_flow_actions *sfa,
+					int st_offset)
 {
-	struct nlattr *a = (struct nlattr *) ((unsigned char *)sfa->actions +
-							       st_offset);
+	struct nlattr *a;
+	u32 attr_len;
+
+	if (WARN_ON_ONCE(st_offset < 0 ||
+			 (u32)st_offset > sfa->actions_len))
+		return -EINVAL;
+
+	attr_len = sfa->actions_len - (u32)st_offset;
+	if (WARN_ON_ONCE(attr_len < NLA_HDRLEN))
+		return -EINVAL;
+
+	if (attr_len > U16_MAX)
+		return -EMSGSIZE;
+
+	a = (struct nlattr *)((u8 *)sfa->actions + st_offset);
+	a->nla_len = attr_len;
+	return 0;
+}
+
+/* Free the generated action-list tail at @start and truncate it.
+ * If @nested, @start points to its containing nlattr header.
+ */
+static void ovs_nla_trim(struct sw_flow_actions *sfa, int start, bool nested)
+{
+	const struct nlattr *actions;
+	u32 len;
+
+	if (start < 0)
+		return;
+
+	if (WARN_ON_ONCE((u32)start > sfa->actions_len))
+		return;
 
-	a->nla_len = sfa->actions_len - st_offset;
+	actions = (const struct nlattr *)((u8 *)sfa->actions + start);
+	len = sfa->actions_len - (u32)start;
+
+	if (nested) {
+		if (len < NLA_HDRLEN)
+			goto out;
+
+		actions = (const struct nlattr *)((u8 *)actions + NLA_HDRLEN);
+		len -= NLA_HDRLEN;
+	}
+
+	ovs_nla_free_nested_actions(actions, len);
+out:
+	sfa->actions_len = start;
 }
 
 static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
@@ -2522,6 +2565,7 @@ static int validate_and_copy_sample(stru
 	const struct nlattr *attrs[OVS_SAMPLE_ATTR_MAX + 1];
 	const struct nlattr *probability, *actions;
 	const struct nlattr *a;
+	int actions_start;
 	int rem, start, err;
 	struct sample_arg arg;
 
@@ -2565,18 +2609,27 @@ static int validate_and_copy_sample(stru
 	err = ovs_nla_add_action(sfa, OVS_SAMPLE_ATTR_ARG, &arg, sizeof(arg),
 				 log);
 	if (err)
-		return err;
+		goto err;
 
+	actions_start = (*sfa)->actions_len;
 	err = __ovs_nla_copy_actions(net, actions, key, sfa,
 				     eth_type, vlan_tci, mpls_label_count, log,
 				     depth + 1);
 
 	if (err)
-		return err;
+		goto err_free;
 
-	add_nested_action_end(*sfa, start);
+	err = add_nested_action_end(*sfa, start);
+	if (err)
+		goto err_free;
 
 	return 0;
+
+err_free:
+	ovs_nla_trim(*sfa, actions_start, false);
+err:
+	(*sfa)->actions_len = start;
+	return err;
 }
 
 static int validate_and_copy_dec_ttl(struct net *net,
@@ -2624,18 +2677,31 @@ static int validate_and_copy_dec_ttl(str
 		return start;
 
 	action_start = add_nested_action_start(sfa, OVS_DEC_TTL_ATTR_ACTION, log);
-	if (action_start < 0)
-		return action_start;
+	if (action_start < 0) {
+		err = action_start;
+		goto err;
+	}
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
 				     vlan_tci, mpls_label_count, log,
 				     depth + 1);
 	if (err)
-		return err;
+		goto err_free;
 
-	add_nested_action_end(*sfa, action_start);
-	add_nested_action_end(*sfa, start);
+	err = add_nested_action_end(*sfa, action_start);
+	if (err)
+		goto err_free;
+
+	err = add_nested_action_end(*sfa, start);
+	if (err)
+		goto err_free;
 	return 0;
+
+err_free:
+	ovs_nla_trim(*sfa, action_start, true);
+err:
+	(*sfa)->actions_len = start;
+	return err;
 }
 
 static int validate_and_copy_clone(struct net *net,
@@ -2646,6 +2712,7 @@ static int validate_and_copy_clone(struc
 				   u32 mpls_label_count, bool log, bool last,
 				   u32 depth)
 {
+	int actions_start;
 	int start, err;
 	u32 exec;
 
@@ -2661,17 +2728,26 @@ static int validate_and_copy_clone(struc
 	err = ovs_nla_add_action(sfa, OVS_CLONE_ATTR_EXEC, &exec,
 				 sizeof(exec), log);
 	if (err)
-		return err;
+		goto err;
 
+	actions_start = (*sfa)->actions_len;
 	err = __ovs_nla_copy_actions(net, attr, key, sfa,
 				     eth_type, vlan_tci, mpls_label_count, log,
 				     depth + 1);
 	if (err)
-		return err;
+		goto err_free;
 
-	add_nested_action_end(*sfa, start);
+	err = add_nested_action_end(*sfa, start);
+	if (err)
+		goto err_free;
 
 	return 0;
+
+err_free:
+	ovs_nla_trim(*sfa, actions_start, false);
+err:
+	(*sfa)->actions_len = start;
+	return err;
 }
 
 void ovs_match_init(struct sw_flow_match *match,
@@ -2763,20 +2839,20 @@ static int validate_and_copy_set_tun(con
 	tun_dst = metadata_dst_alloc(key.tun_opts_len, METADATA_IP_TUNNEL,
 				     GFP_KERNEL);
 
-	if (!tun_dst)
-		return -ENOMEM;
+	if (!tun_dst) {
+		err = -ENOMEM;
+		goto err;
+	}
 
 	err = dst_cache_init(&tun_dst->u.tun_info.dst_cache, GFP_KERNEL);
-	if (err) {
-		dst_release((struct dst_entry *)tun_dst);
-		return err;
-	}
+	if (err)
+		goto err_free_tun_dst;
 
 	a = __add_action(sfa, OVS_KEY_ATTR_TUNNEL_INFO, NULL,
 			 sizeof(*ovs_tun), log);
 	if (IS_ERR(a)) {
-		dst_release((struct dst_entry *)tun_dst);
-		return PTR_ERR(a);
+		err = PTR_ERR(a);
+		goto err_free_tun_dst;
 	}
 
 	ovs_tun = nla_data(a);
@@ -2797,8 +2873,16 @@ static int validate_and_copy_set_tun(con
 	ip_tunnel_info_opts_set(tun_info,
 				TUN_METADATA_OPTS(&key, key.tun_opts_len),
 				key.tun_opts_len, dst_opt_type);
-	add_nested_action_end(*sfa, start);
+	err = add_nested_action_end(*sfa, start);
+	if (WARN_ON_ONCE(err))
+		goto err_free_tun_dst;
+
+	return 0;
 
+err_free_tun_dst:
+	dst_release((struct dst_entry *)tun_dst);
+err:
+	(*sfa)->actions_len = start;
 	return err;
 }
 
@@ -2971,7 +3055,7 @@ static int validate_set(const struct nla
 
 	/* Convert non-masked non-tunnel set actions to masked set actions. */
 	if (!masked && key_type != OVS_KEY_ATTR_TUNNEL) {
-		int start, len = key_len * 2;
+		int err, start, len = key_len * 2;
 		struct nlattr *at;
 
 		*skip_copy = true;
@@ -2983,8 +3067,11 @@ static int validate_set(const struct nla
 			return start;
 
 		at = __add_action(sfa, key_type, NULL, len, log);
-		if (IS_ERR(at))
-			return PTR_ERR(at);
+		if (IS_ERR(at)) {
+			err = PTR_ERR(at);
+			(*sfa)->actions_len = start;
+			return err;
+		}
 
 		memcpy(nla_data(at), nla_data(ovs_key), key_len); /* Key. */
 		memset(nla_data(at) + key_len, 0xff, key_len);    /* Mask. */
@@ -2994,7 +3081,11 @@ static int validate_set(const struct nla
 
 			mask->ipv6_label &= htonl(0x000FFFFF);
 		}
-		add_nested_action_end(*sfa, start);
+		err = add_nested_action_end(*sfa, start);
+		if (WARN_ON_ONCE(err)) {
+			(*sfa)->actions_len = start;
+			return err;
+		}
 	}
 
 	return 0;
@@ -3040,7 +3131,8 @@ static int validate_and_copy_check_pkt_l
 	const struct nlattr *acts_if_greater, *acts_if_lesser_eq;
 	struct nlattr *a[OVS_CHECK_PKT_LEN_ATTR_MAX + 1];
 	struct check_pkt_len_arg arg;
-	int nested_acts_start;
+	int greater_acts_start = -1;
+	int lesser_acts_start = -1;
 	int start, err;
 
 	err = nla_parse_deprecated_strict(a, OVS_CHECK_PKT_LEN_ATTR_MAX,
@@ -3075,37 +3167,58 @@ static int validate_and_copy_check_pkt_l
 	err = ovs_nla_add_action(sfa, OVS_CHECK_PKT_LEN_ATTR_ARG, &arg,
 				 sizeof(arg), log);
 	if (err)
-		return err;
+		goto err_free;
 
-	nested_acts_start = add_nested_action_start(sfa,
-		OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL, log);
-	if (nested_acts_start < 0)
-		return nested_acts_start;
+	lesser_acts_start =
+		add_nested_action_start(sfa,
+					OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL,
+					log);
+	if (lesser_acts_start < 0) {
+		err = lesser_acts_start;
+		goto err_free;
+	}
 
 	err = __ovs_nla_copy_actions(net, acts_if_lesser_eq, key, sfa,
 				     eth_type, vlan_tci, mpls_label_count, log,
 				     depth + 1);
 
 	if (err)
-		return err;
+		goto err_free;
 
-	add_nested_action_end(*sfa, nested_acts_start);
+	err = add_nested_action_end(*sfa, lesser_acts_start);
+	if (err)
+		goto err_free;
 
-	nested_acts_start = add_nested_action_start(sfa,
-		OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_GREATER, log);
-	if (nested_acts_start < 0)
-		return nested_acts_start;
+	greater_acts_start =
+		add_nested_action_start(sfa,
+					OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_GREATER,
+					log);
+	if (greater_acts_start < 0) {
+		err = greater_acts_start;
+		goto err_free;
+	}
 
 	err = __ovs_nla_copy_actions(net, acts_if_greater, key, sfa,
 				     eth_type, vlan_tci, mpls_label_count, log,
 				     depth + 1);
 
 	if (err)
-		return err;
+		goto err_free;
+
+	err = add_nested_action_end(*sfa, greater_acts_start);
+	if (err)
+		goto err_free;
 
-	add_nested_action_end(*sfa, nested_acts_start);
-	add_nested_action_end(*sfa, start);
+	err = add_nested_action_end(*sfa, start);
+	if (err)
+		goto err_free;
 	return 0;
+
+err_free:
+	ovs_nla_trim(*sfa, greater_acts_start, true);
+	ovs_nla_trim(*sfa, lesser_acts_start, true);
+	ovs_nla_trim(*sfa, start, false);
+	return err;
 }
 
 static int validate_psample(const struct nlattr *attr)


