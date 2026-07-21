Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70273B47DF;
	Tue, 21 Jul 2026 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667625; cv=none; b=tsRza3UXKowk9gUQWcP35+Eifm4SoJYmZRQsZqK+U8/Dwq7Tax3Dt89FbjuHvGl9deKI2jSLOqWsXIa7ird+vovoDh+VH8j8qBsK1ZDEdTY3JtDAvF/GGlClBZQDAAKUiGagzimR1GSS6+QfNEr99wOw60idx2ykWThYm88Zbrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667625; c=relaxed/simple;
	bh=6rYPX8DiHiKCxsstDzF1GxDvz88QJaja0OagfbSh67A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnsj60fNJD0XWzzeav4jGypy99IF6owgBZeFy5Dxk6lBTeT5kDYLWTJotyI9C4iuV375Sz0ZlF7HiBwQtpvieAt2uiTfG9e/gmSRMwqmQbV2rvW7V9wGSaUum/BBg8nVWTRYrQs5NVN07GnD+NKumUVE0jJL1GQ7Mcc+hARAWGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EusR+Trp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EusR+Trp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DF41F000E9;
	Tue, 21 Jul 2026 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667623;
	bh=P+GJcSQC8LDf1hYtxC6Cze/q8hXMslpImwLIphr/i4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EusR+TrpHlAR8VhDlfl65SGrL7FxP6FO9owRnPDJhTANOvcNuWUx8Ed/02yp4eaGJ
	 4CReR8LpCf0ZawcnXf6EJpDMImKJQg8PF2os+FkZV23Kd3Mtcqr062D3dgO0xbBnGm
	 euAbhQ85zOxkmsB0gf9xaWkQ0QQQSL60X8LC7rok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1131/1266] net: openvswitch: reject oversized nested action attrs
Date: Tue, 21 Jul 2026 17:26:08 +0200
Message-ID: <20260721152507.105536032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -2483,13 +2483,56 @@ static inline int add_nested_action_star
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
@@ -2509,6 +2552,7 @@ static int validate_and_copy_sample(stru
 	const struct nlattr *attrs[OVS_SAMPLE_ATTR_MAX + 1];
 	const struct nlattr *probability, *actions;
 	const struct nlattr *a;
+	int actions_start;
 	int rem, start, err;
 	struct sample_arg arg;
 
@@ -2552,18 +2596,27 @@ static int validate_and_copy_sample(stru
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
@@ -2611,18 +2664,31 @@ static int validate_and_copy_dec_ttl(str
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
@@ -2633,6 +2699,7 @@ static int validate_and_copy_clone(struc
 				   u32 mpls_label_count, bool log, bool last,
 				   u32 depth)
 {
+	int actions_start;
 	int start, err;
 	u32 exec;
 
@@ -2648,17 +2715,26 @@ static int validate_and_copy_clone(struc
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
@@ -2749,20 +2825,20 @@ static int validate_and_copy_set_tun(con
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
@@ -2783,8 +2859,16 @@ static int validate_and_copy_set_tun(con
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
 
@@ -2957,7 +3041,7 @@ static int validate_set(const struct nla
 
 	/* Convert non-masked non-tunnel set actions to masked set actions. */
 	if (!masked && key_type != OVS_KEY_ATTR_TUNNEL) {
-		int start, len = key_len * 2;
+		int err, start, len = key_len * 2;
 		struct nlattr *at;
 
 		*skip_copy = true;
@@ -2969,8 +3053,11 @@ static int validate_set(const struct nla
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
@@ -2980,7 +3067,11 @@ static int validate_set(const struct nla
 
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
@@ -3025,7 +3116,8 @@ static int validate_and_copy_check_pkt_l
 	const struct nlattr *acts_if_greater, *acts_if_lesser_eq;
 	struct nlattr *a[OVS_CHECK_PKT_LEN_ATTR_MAX + 1];
 	struct check_pkt_len_arg arg;
-	int nested_acts_start;
+	int greater_acts_start = -1;
+	int lesser_acts_start = -1;
 	int start, err;
 
 	err = nla_parse_deprecated_strict(a, OVS_CHECK_PKT_LEN_ATTR_MAX,
@@ -3060,37 +3152,58 @@ static int validate_and_copy_check_pkt_l
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
 
 static int copy_action(const struct nlattr *from,


