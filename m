Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CC2248881;
	Wed, 25 Feb 2026 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983564; cv=none; b=MlbjKECn6hGRa/1RbpqNw9UHYnC58tYu5s4J12CwNQsz5+qYCpvt4TwT3/bb7RZGpJgValcNHg5XbNZQWyBvp2h4Ariy8C3f8SeaWn6vO/6fjyZ+f1oK3TPcakaYFSLSf62h2TWIpM1cRGCsyfCtwwkjlOFLY5S46nQzKQO5NDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983564; c=relaxed/simple;
	bh=GBVPaWdyQMjqV7lJr/UEOAcH50QQ1GhQUJ7sFG+f3ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+/AeHlqtnJMB0G2uydt2q8qQJt+9J4/WKoFD0+UV6SX11CJB0wjhOWbPxL9xQhY9RTVCFmBlGZxGHZ1Pocc+evmQ2AH6722l/kL1ycq87VT2fgKBWfxKl8Mla+ua0+VFHYgAMdjZmRGpA0jZZwklI2A2eej/s57dqM7JP/zeLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFu8IBbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFu8IBbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637EEC116D0;
	Wed, 25 Feb 2026 01:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983564;
	bh=GBVPaWdyQMjqV7lJr/UEOAcH50QQ1GhQUJ7sFG+f3ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFu8IBbBUZycmQdAnGzZtkw62ukTKxhZCengFqEWiX2oyB+gaPYCjc3JSckyQHLLl
	 ZsZQ8qXLp6BZCp2lvcdmvQDWYm5wYW+d9ELZo9zO0Ee5YocKfXsEBpJ89AGlxRO0xC
	 tCMvU+7cbq8HmLgih6G1LvasA6qY08zQLf390ytQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 663/781] netfilter: nf_tables: revert commit_mutex usage in reset path
Date: Tue, 24 Feb 2026 17:22:52 -0800
Message-ID: <20260225012416.050505401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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
index daef07ee09427..f807183235e79 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3900,23 +3900,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
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
@@ -3936,16 +3919,10 @@ static int nf_tables_dump_rules_start(struct netlink_callback *cb)
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
@@ -4011,6 +3988,8 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
+	bool reset = false;
+	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -4024,47 +4003,16 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -6323,6 +6271,10 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
+	if (dump_ctx->reset && args.iter.count > args.iter.skip)
+		audit_log_nft_set_reset(table, cb->seq,
+					args.iter.count - args.iter.skip);
+
 	rcu_read_unlock();
 
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
@@ -6338,26 +6290,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -6601,8 +6533,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
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
@@ -6612,7 +6549,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			.module = THIS_MODULE,
 		};
 
-		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, false);
+		err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, reset);
 		if (err)
 			return err;
 
@@ -6623,75 +6560,21 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
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
@@ -8562,19 +8445,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -8591,16 +8461,10 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
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
@@ -8662,42 +8526,16 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
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
@@ -8706,18 +8544,16 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
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
@@ -10035,7 +9871,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE_RESET] = {
-		.call		= nf_tables_getrule_reset,
+		.call		= nf_tables_getrule,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
@@ -10089,7 +9925,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM_RESET] = {
-		.call		= nf_tables_getsetelem_reset,
+		.call		= nf_tables_getsetelem,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
@@ -10135,7 +9971,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj_reset,
+		.call		= nf_tables_getobj,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.51.0



