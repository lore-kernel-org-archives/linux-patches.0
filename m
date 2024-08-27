Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA9F73466;
	Tue, 27 Aug 2024 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769919; cv=none; b=o7LZQr0l3Cj19E2QCbhYlxsagXH+vIizUCplVWPI4QnnAP/VMcCtbRUBmfjY3uxQmF7QmQD9cGqHwrzIsD14AZGvztHYjT0CwtZ2GwBRazgGai5lhsJIVFonevpAoOSvt7xIud+fNuAFogymlJfdwkHT5uZZl3pxBopjuZJPQv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769919; c=relaxed/simple;
	bh=2vb4KZFNxPx1vKhB8+koLTuzY/MvY6OmUnZwtbvX7Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOVeFu9Qc4nXndnPU3L1zXEzZY0EvHbNfJeYLtsBEnMVVxrYFgDqJA35Vy/qfBMRRWnY82seJnEEt2ilxHzye2z/ya65+NVAWo48HLK6o7g0sXHOZvXqNsgxxzStm39sJZofZx9UFVGsgvo6B9rd/pMyYS9AIEa9t+fGz/5f0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtS231eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtS231eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22883C6106D;
	Tue, 27 Aug 2024 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769918;
	bh=2vb4KZFNxPx1vKhB8+koLTuzY/MvY6OmUnZwtbvX7Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtS231eRw8BGX3qA9pnLj8vwHcSTm7yjMI3FEciq9w3/9XhUtVvosJDVWmV1b+Aqw
	 CUnGOP18mfvSLCSLJ4YVDiyNyzquuVqvPTDn8KhngQyM0lF884X093sNVghT0eh5QT
	 5co+ogofWz/YRWdlFNf3Is1f14YJ5AOiYRai3JX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/341] netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
Date: Tue, 27 Aug 2024 16:35:05 +0200
Message-ID: <20240827143846.226455124@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit bd662c4218f9648e888bebde9468146965f3f8a0 ]

Objects' dump callbacks are not concurrency-safe per-se with reset bit
set. If two CPUs perform a reset at the same time, at least counter and
quota objects suffer from value underrun.

Prevent this by introducing dedicated locking callbacks for nfnetlink
and the asynchronous dump handling to serialize access.

Fixes: 43da04a593d8 ("netfilter: nf_tables: atomic dump and reset for stateful objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 72 ++++++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3ed9437e21b4..fc99a5e91829d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7783,6 +7783,19 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_obj(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	mutex_lock(&nft_net->commit_mutex);
+	ret = nf_tables_dump_obj(skb, cb);
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -7799,12 +7812,18 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		ctx->reset = true;
-
 	return 0;
 }
 
+static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
+{
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
+
+	ctx->reset = true;
+
+	return nf_tables_dump_obj_start(cb);
+}
+
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -7863,18 +7882,43 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
+{
+	u32 portid = NETLINK_CB(skb).portid;
+	struct sk_buff *skb2;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	skb2 = nf_tables_getobj_single(portid, info, nla, false);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
+}
+
+static int nf_tables_getobj_reset(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
-	bool reset = false;
 	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
+			.start = nf_tables_dumpreset_obj_start,
+			.dump = nf_tables_dumpreset_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -7883,16 +7927,18 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	skb2 = nf_tables_getobj_single(portid, info, nla, true);
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
-	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
-	if (!reset)
-		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
-
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_OBJ_TABLE]),
 			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
@@ -9179,7 +9225,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
+		.call		= nf_tables_getobj_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.43.0



