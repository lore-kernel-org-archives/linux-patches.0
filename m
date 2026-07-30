Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23442445AF7;
	Thu, 30 Jul 2026 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423380; cv=none; b=NO1MIgITpexSHy17yMmMIuu0XvJ8sevvwuxwnXG4DuckyExGbuuAm3x9in262lgRVq64p0bF6vJ8Ls+RvNkEVKw8VA0Jd31+t5R8aMLYp4hT2bHGQxtHjQjHAz4VjURdYJ86dFs2f+C5VNciJviHEdzOgbcLtKVje2JJ9Ik2UbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423380; c=relaxed/simple;
	bh=L9jg0FBpRpLm8LR4nNV7XuPhVP3xn++FImYB+Rbyo8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx46VIDp90Kly3ylnX8xpvpMQ9O50F6MFhNckoyCQc/mGOWwv71M5BnSwgucL7p4dp56TjVE3Xt6OvL19j7+GN4H7Vw4oDov6asBgqNq0YEGOjsZquVQ243UJsHW1AJ/UZDV2m/aIX/1bwrvoCNjSV6QlrH59eoTryGz2IBslhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY/qMSLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY/qMSLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7722D1F000E9;
	Thu, 30 Jul 2026 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423379;
	bh=k44xzHBVTkdC+I+RHAPJkYEkCxer2nEUpHE1xC7GKYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY/qMSLGLR/OZ4OrUE6VKd6rQe9a3GMtMXzGxOdiW3jpXDgSItF9llDbPbkFeydFs
	 E/tYPuRxpz27ACTNWbwLKSs52ViUOxjD3uGwb17dizge2dY4vxwXmG2PHbF31HqVhC
	 2gix0dEAXX6VQXTlmWQdloNxX5HNueIFSJdhcJsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/675] netfilter: nf_tables: revert commit_mutex usage in reset path
Date: Thu, 30 Jul 2026 16:05:36 +0200
Message-ID: <20260730141445.251442197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Brian Witte <brianwitte@mailfence.com>

[ Upstream commit 7f261bb906bf527c4a6e2a646e2d5f3679f2a8bc ]

It causes circular lock dependency between commit_mutex, nfnl_subsys_ipset
and nlk_cb_mutex when nft reset, ipset list, and iptables-nft with '-m set'
rule run at the same time.

Previous patches made it safe to run individual reset handlers concurrently
so commit_mutex is no longer required to prevent this.

Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Link: https://lore.kernel.org/all/aUh_3mVRV8OrGsVo@strlen.de/
Reported-by: <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 248 ++++++----------------------------
 1 file changed, 42 insertions(+), 206 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0842916c19f503..c82c16bd4257e4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3908,23 +3908,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	return skb->len;
 }
 
-static int nf_tables_dumpreset_rules(struct sk_buff *skb,
-				     struct netlink_callback *cb)
-{
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	int ret;
-
-	/* Mutex is held is to prevent that two concurrent dump-and-reset calls
-	 * do not underrun counters and quotas. The commit_mutex is used for
-	 * the lack a better lock, this is not transaction path.
-	 */
-	mutex_lock(&nft_net->commit_mutex);
-	ret = nf_tables_dump_rules(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
-}
-
 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 {
 	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
@@ -3944,16 +3927,10 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 			return -ENOMEM;
 		}
 	}
-	return 0;
-}
-
-static int nf_tables_dumpreset_rules_start(struct netlink_callback *cb)
-{
-	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
-
-	ctx->reset = true;
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		ctx->reset = true;
 
-	return nf_tables_dump_rules_start(cb);
+	return 0;
 }
 
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
@@ -4019,6 +3996,8 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
+	bool reset = false;
+	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -4032,47 +4011,16 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	skb2 = nf_tables_getrule_single(portid, info, nla, false);
-	if (IS_ERR(skb2))
-		return PTR_ERR(skb2);
-
-	return nfnetlink_unicast(skb2, net, portid);
-}
-
-static int nf_tables_getrule_reset(struct sk_buff *skb,
-				   const struct nfnl_info *info,
-				   const struct nlattr * const nla[])
-{
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	u32 portid = NETLINK_CB(skb).portid;
-	struct net *net = info->net;
-	struct sk_buff *skb2;
-	char *buf;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start= nf_tables_dumpreset_rules_start,
-			.dump = nf_tables_dumpreset_rules,
-			.done = nf_tables_dump_rules_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	skb2 = nf_tables_getrule_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
 
+	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, portid);
+
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_RULE_TABLE]),
 			(char *)nla_data(nla[NFTA_RULE_TABLE]),
@@ -6332,6 +6280,10 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
+	if (dump_ctx->reset && args.iter.count > args.iter.skip)
+		audit_log_nft_set_reset(table, cb->seq,
+					args.iter.count - args.iter.skip);
+
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -6347,26 +6299,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return -ENOSPC;
 }
 
-static int nf_tables_dumpreset_set(struct sk_buff *skb,
-				   struct netlink_callback *cb)
-{
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	struct nft_set_dump_ctx *dump_ctx = cb->data;
-	int ret, skip = cb->args[0];
-
-	mutex_lock(&nft_net->commit_mutex);
-
-	ret = nf_tables_dump_set(skb, cb);
-
-	if (cb->args[0] > skip)
-		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
-					cb->args[0] - skip);
-
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
-}
-
 static int nf_tables_dump_set_start(struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -6613,8 +6545,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_set_dump_ctx dump_ctx;
+	int rem, err = 0, nelems = 0;
+	struct net *net = info->net;
 	struct nlattr *attr;
-	int rem, err = 0;
+	bool reset = false;
+
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
+		reset = true;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -6624,7 +6561,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.module = THIS_MODULE,
 		};
 
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
 		if (err)
 			return err;
 
@@ -6635,75 +6572,21 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
+	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
 	if (err)
 		return err;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, false);
-		if (err < 0) {
-			NL_SET_BAD_ATTR(extack, attr);
-			break;
-		}
-	}
-
-	return err;
-}
-
-static int nf_tables_getsetelem_reset(struct sk_buff *skb,
-				      const struct nfnl_info *info,
-				      const struct nlattr * const nla[])
-{
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	struct netlink_ext_ack *extack = info->extack;
-	struct nft_set_dump_ctx dump_ctx;
-	int rem, err = 0, nelems = 0;
-	struct nlattr *attr;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_set_start,
-			.dump = nf_tables_dumpreset_set,
-			.done = nf_tables_dump_set_done,
-			.module = THIS_MODULE,
-		};
-
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
-		if (err)
-			return err;
-
-		c.data = &dump_ctx;
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
-	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
-		return -EINVAL;
-
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	rcu_read_lock();
-
-	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
-	if (err)
-		goto out_unlock;
-
-	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, true);
+		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
 		nelems++;
 	}
-	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net), nelems);
-
-out_unlock:
-	rcu_read_unlock();
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	if (reset)
+		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(net),
+					nelems);
 
 	return err;
 }
@@ -8567,19 +8450,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static int nf_tables_dumpreset_obj(struct sk_buff *skb,
-				   struct netlink_callback *cb)
-{
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	int ret;
-
-	mutex_lock(&nft_net->commit_mutex);
-	ret = nf_tables_dump_obj(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
-}
-
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -8596,16 +8466,10 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	return 0;
-}
-
-static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
-{
-	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
-
-	ctx->reset = true;
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
 
-	return nf_tables_dump_obj_start(cb);
+	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
@@ -8667,42 +8531,16 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	u32 portid = NETLINK_CB(skb).portid;
-	struct sk_buff *skb2;
-
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
-			.done = nf_tables_dump_obj_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
-	skb2 = nf_tables_getobj_single(portid, info, nla, false);
-	if (IS_ERR(skb2))
-		return PTR_ERR(skb2);
-
-	return nfnetlink_unicast(skb2, info->net, portid);
-}
-
-static int nf_tables_getobj_reset(struct sk_buff *skb,
-				  const struct nfnl_info *info,
-				  const struct nlattr * const nla[])
-{
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
+	bool reset = false;
 	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start = nf_tables_dumpreset_obj_start,
-			.dump = nf_tables_dumpreset_obj,
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -8711,18 +8549,16 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	skb2 = nf_tables_getobj_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		reset = true;
 
+	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_OBJ_TABLE]),
 			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
@@ -10030,7 +9866,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule_reset,
+		.call		= nf_tables_getrule,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
@@ -10084,7 +9920,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem_reset,
+		.call		= nf_tables_getsetelem,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
@@ -10130,7 +9966,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj_reset,
+		.call		= nf_tables_getobj,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.53.0



