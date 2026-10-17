Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0263A7F54;
	Sat, 17 Oct 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258635; cv=none; b=elqt/H/KFEIuS+Ul+9p3vjQTeZUYNVds8f/T9AG6uW/hoS7jk0KcIh2RDsQgiSUghbX7G+1zv6hdqFBYK5e52GjlTdAtOei5GDBKSBULtp2W3rwfYY/1/RnJ+hgATsgiuus7kYP5cHKPSP2ScM614sprQCcNk0oKdLWwMd2G7RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258635; c=relaxed/simple;
	bh=fDPT7Tg3SSeueP/p9o/zDjhRN9TlGRKMcm7mvRQY4Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCD7eGN+Esx9whv9sVXIkevjAwq81DAnNuw27k5qiQQeArHcnjm9B2cqH0VBPMGrYEE619hn9ckyLIyye4Qfs+9/A29Z/zZ5CfCYxYRpXQJrMVU67a8Q7EAcCItUFTiVM8vcdLDD0onr834rQk9FabP1co2MvcnluA6uZkVS6ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPPwO0bA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPPwO0bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A251F000C4;
	Sat, 17 Oct 2026 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258634;
	bh=+X7WaYUXqP9s8M148jVoOBiIieyj+2qvyeiQC4RVh6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPPwO0bAs17W6JfKvURmeI+JHtKri0apSdEU2XCciv/d0V+r1JqdEqidc2BIxRb1+
	 DK9joOtupzM3CiIsq5wT9kg3ZjVLTEUa8KqzluYV9/l9WilgaRzxT468rsW8uIs0v4
	 CbFUQCJszTlF8Dt9f6O0iIw9amrPIlCNvJId+BD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0949/1674] netfilter: nf_tables: revert commit_mutex usage in reset path
Date: Sat, 17 Oct 2026 17:53:41 +0200
Message-ID: <20261017160455.490171215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 net/netfilter/nf_tables_api.c | 73 +++++++----------------------------
 1 file changed, 13 insertions(+), 60 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9c533c0776806..ecdbb0d7a6c4c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7950,19 +7950,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -7979,16 +7966,10 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	return 0;
-}
-
-static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
-{
-	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
 
-	ctx->reset = true;
-
-	return nf_tables_dump_obj_start(cb);
+	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
@@ -8050,42 +8031,16 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
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
@@ -8094,18 +8049,16 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
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
@@ -9413,7 +9366,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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



