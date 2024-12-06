Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50D206F3E;
	Fri,  6 Dec 2024 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497215; cv=none; b=ptwfnQP0tAu/jYQYYKXHqYtV9ODAPwZEeZsCOQtcyfSU3ecVJ9ucjpA5FGtDyjP79I4fSs2Pyl9kxAnBqxK1SVfibH6wFr+6ot6rOA7WRb7rr5W7h2wiVIcYRRcBkN+Yhf2ie2cf/KXDtCQm7TC1qAC5Bjl4EboNJYyYXR6vYj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497215; c=relaxed/simple;
	bh=3XVhrWj3mDbBJKhjX332o3VUkWj8jMx5AQw4z4jjSZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB9omrRYzGJlvlNOlo80iKkSzXYXKSLfWqlYAs/gzVRBmLu0HLGadFbZ1gZAChQ7wA46NUqvHtAOhlDuDL3KWRCPkFEJSMpqIkbmycWGWOvCItR5klZMq+db2Kqtf2pvyurcp7T0bCwpcTiRToXvMad2lqUrfznIubTNcyklYRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrtUObvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrtUObvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2445BC4CED1;
	Fri,  6 Dec 2024 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497215;
	bh=3XVhrWj3mDbBJKhjX332o3VUkWj8jMx5AQw4z4jjSZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrtUObvdQBSw/sRn4eG7MUclr0yZ0fjNc3ZLlFa1Q2ne8N2r/uRFRJHuOKCoLUclk
	 am+eURuL9r5t+CeklNhHazQLhBABlOGDXx5QtmQ0lkMG1eiCSA13r7HIl+QTnUotWD
	 kmnGStYfFor1mIEjymIwOaI/6e3llXKZ7PoBeX/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/676] netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion
Date: Fri,  6 Dec 2024 15:30:47 +0100
Message-ID: <20241206143702.241972197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a0eed189441e5..11fe424d9c93a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3349,13 +3349,15 @@ void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr)
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
@@ -3363,13 +3365,14 @@ static struct nft_rule *__nft_rule_lookup(const struct nft_chain *chain,
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
@@ -3661,7 +3664,7 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 	return 0;
 }
 
-/* called with rcu_read_lock held */
+/* Caller must hold rcu read lock or transaction mutex */
 static struct sk_buff *
 nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 			 const struct nlattr * const nla[], bool reset)
@@ -3688,7 +3691,7 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 		return ERR_CAST(chain);
 	}
 
-	rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
+	rule = nft_rule_lookup(net, chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 		return ERR_CAST(rule);
@@ -3961,7 +3964,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (nla[NFTA_RULE_HANDLE]) {
 		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
-		rule = __nft_rule_lookup(chain, handle);
+		rule = __nft_rule_lookup(net, chain, handle);
 		if (IS_ERR(rule)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 			return PTR_ERR(rule);
@@ -3983,7 +3986,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 		if (nla[NFTA_RULE_POSITION]) {
 			pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
-			old_rule = __nft_rule_lookup(chain, pos_handle);
+			old_rule = __nft_rule_lookup(net, chain, pos_handle);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
 				return PTR_ERR(old_rule);
@@ -4200,7 +4203,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (chain) {
 		if (nla[NFTA_RULE_HANDLE]) {
-			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
+			rule = nft_rule_lookup(info->net, chain, nla[NFTA_RULE_HANDLE]);
 			if (IS_ERR(rule)) {
 				if (PTR_ERR(rule) == -ENOENT &&
 				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
@@ -7911,7 +7914,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 	return 0;
 }
 
-/* called with rcu_read_lock held */
+/* Caller must hold rcu read lock or transaction mutex */
 static struct sk_buff *
 nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 			const struct nlattr * const nla[], bool reset)
-- 
2.43.0



