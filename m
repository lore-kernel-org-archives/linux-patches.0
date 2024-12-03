Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEB01E3DF9;
	Tue,  3 Dec 2024 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238552; cv=none; b=eutSA+aOJscu3th6vevOuWSrLXJiUt9DXqBAatKXKUAUTySXL+q/MxhIVzgVlnlbLVBVC09KVVXGk0mALEdrhUww8Aqsdc9ISy4If91VizjkAh8mSJIQr5nzkdyc/n3uKa3gQcnu09DeH7cVUiplkmORqP+88RgixRUPVMimghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238552; c=relaxed/simple;
	bh=gZCV5A3B3lQaVXsv9l3xK9PVjqN8CBpNdwXEeGFBMFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEZqMzrWTVtg0fPl5phXUpqOK+dHJwmnOyJKBGTmlP4l2RM5middz9eE3o329Mz+G8LnnWQXHO7wjyGbcL2mjQi6mlngtOFn/HP53oQiNp2AsHLpA78Vw8g6eLTz8R+S/v/O+IE28rcIop6Fprq6iWpiKRxfYBUp4vPSwWy+MFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN0dC8sL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN0dC8sL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AE7C4CECF;
	Tue,  3 Dec 2024 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238551;
	bh=gZCV5A3B3lQaVXsv9l3xK9PVjqN8CBpNdwXEeGFBMFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN0dC8sLk61QLsEdvgm0Lx6vLMZrei6UtWn79lZjH5BBzg/8dLthMqWItGsZINcxw
	 eqSt3JdUqBksCYLE9tWzbFOfUmkA7Ipp8qVlUIOPBUsvD0Zdg2ZIBX18MVL3Soo+h5
	 I9JvNC1WYAqlkx+3MqSfDafyVzrPGbC8o1A7LErw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 317/817] netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion
Date: Tue,  3 Dec 2024 15:38:09 +0100
Message-ID: <20241203144008.192754075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9adbb4198bf6cf3634032871118a7052aeaa573f ]

On rule delete we get:
 WARNING: suspicious RCU usage
 net/netfilter/nf_tables_api.c:3420 RCU-list traversed in non-reader section!!
 1 lock held by iptables/134:
   #0: ffff888008c4fcc8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid (include/linux/jiffies.h:101) nf_tables

Code is fine, no other CPU can change the list because we're holding
transaction mutex.

Pass the needed lockdep annotation to the iterator and fix
two comments for functions that are no longer restricted to rcu-only
context.

This is enough to resolve rule delete, but there are several other
missing annotations, added in followup-patches.

Fixes: 28875945ba98 ("rcu: Add support for consolidated-RCU reader checking")
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58503348ed3a3..18579897e7fe2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3410,13 +3410,15 @@ void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr)
  * Rules
  */
 
-static struct nft_rule *__nft_rule_lookup(const struct nft_chain *chain,
+static struct nft_rule *__nft_rule_lookup(const struct net *net,
+					  const struct nft_chain *chain,
 					  u64 handle)
 {
 	struct nft_rule *rule;
 
 	// FIXME: this sucks
-	list_for_each_entry_rcu(rule, &chain->rules, list) {
+	list_for_each_entry_rcu(rule, &chain->rules, list,
+				lockdep_commit_lock_is_held(net)) {
 		if (handle == rule->handle)
 			return rule;
 	}
@@ -3424,13 +3426,14 @@ static struct nft_rule *__nft_rule_lookup(const struct nft_chain *chain,
 	return ERR_PTR(-ENOENT);
 }
 
-static struct nft_rule *nft_rule_lookup(const struct nft_chain *chain,
+static struct nft_rule *nft_rule_lookup(const struct net *net,
+					const struct nft_chain *chain,
 					const struct nlattr *nla)
 {
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	return __nft_rule_lookup(chain, be64_to_cpu(nla_get_be64(nla)));
+	return __nft_rule_lookup(net, chain, be64_to_cpu(nla_get_be64(nla)));
 }
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
@@ -3731,7 +3734,7 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 	return 0;
 }
 
-/* called with rcu_read_lock held */
+/* Caller must hold rcu read lock or transaction mutex */
 static struct sk_buff *
 nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 			 const struct nlattr * const nla[], bool reset)
@@ -3758,7 +3761,7 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 		return ERR_CAST(chain);
 	}
 
-	rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
+	rule = nft_rule_lookup(net, chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 		return ERR_CAST(rule);
@@ -4057,7 +4060,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (nla[NFTA_RULE_HANDLE]) {
 		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
-		rule = __nft_rule_lookup(chain, handle);
+		rule = __nft_rule_lookup(net, chain, handle);
 		if (IS_ERR(rule)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 			return PTR_ERR(rule);
@@ -4079,7 +4082,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 		if (nla[NFTA_RULE_POSITION]) {
 			pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
-			old_rule = __nft_rule_lookup(chain, pos_handle);
+			old_rule = __nft_rule_lookup(net, chain, pos_handle);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
 				return PTR_ERR(old_rule);
@@ -4296,7 +4299,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (chain) {
 		if (nla[NFTA_RULE_HANDLE]) {
-			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
+			rule = nft_rule_lookup(info->net, chain, nla[NFTA_RULE_HANDLE]);
 			if (IS_ERR(rule)) {
 				if (PTR_ERR(rule) == -ENOENT &&
 				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
@@ -8082,7 +8085,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 	return 0;
 }
 
-/* called with rcu_read_lock held */
+/* Caller must hold rcu read lock or transaction mutex */
 static struct sk_buff *
 nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 			const struct nlattr * const nla[], bool reset)
-- 
2.43.0



