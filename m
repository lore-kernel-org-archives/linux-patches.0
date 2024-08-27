Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380E71C6F5F;
	Tue, 27 Aug 2024 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772054; cv=none; b=m/KstTZbCogwnx3zI0WbgOyNwnk2ELKgLrNtIDpMQtdyZf5WcP/Ftn9L43s7680i+7vjjKjaeqDdAEPMtgk8vWqWMTRPG8SPzGuOd607o79o7aEpUSHdXIR924g6c0uclkowlZs1RYd1LzGte31or4/xrjnqfwh95D8fE7XRJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772054; c=relaxed/simple;
	bh=qnBbF2E9yCfXJaZUWYUb1gKjdT6nbabRDQKOdDzqYeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ectf2sw3r6r0YN2mBA+E4Hbm1uB0GmFHa8f6CnO/2N3uT5TouvOPq3VtDkKLBnplIj5g1+co3YxNwZofkC2pDTqrlGFulqmDwCeEaY3YzSpvDnZBNxgDJC3G2PVBE454S/hyEMETXy5GtO7Fr4wnJJnYvt4EjCAy+Gii1T1AM1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExT6lS1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExT6lS1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D9CC4DE1E;
	Tue, 27 Aug 2024 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772054;
	bh=qnBbF2E9yCfXJaZUWYUb1gKjdT6nbabRDQKOdDzqYeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExT6lS1HqEBBiars78avmlxd14Nurce3CLBtzddX6saGsX/hwWTrggL2/2XLokf5N
	 R3vGRFBpYENuz18X7vOAgbAv10C4taNkAOi+3dTwyEmQgu/vkH2XuA9J2b7p3xkE9M
	 hZQG8JlWgGla01YfTDx38Evdu34kq8WGllonDESM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/321] netfilter: nf_tables: Audit log dump reset after the fact
Date: Tue, 27 Aug 2024 16:36:46 +0200
Message-ID: <20240827143841.978590160@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit e0b6648b0446e59522819c75ba1dcb09e68d3e94 ]

In theory, dumpreset may fail and invalidate the preceeding log message.
Fix this and use the occasion to prepare for object reset locking, which
benefits from a few unrelated changes:

* Add an early call to nfnetlink_unicast if not resetting which
  effectively skips the audit logging but also unindents it.
* Extract the table's name from the netlink attribute (which is verified
  via earlier table lookup) to not rely upon validity of the looked up
  table pointer.
* Do not use local variable family, it will vanish.

Fixes: 8e6cf365e1d5 ("audit: log nftables configuration change events")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 10180d280e792..747033129c0fe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7531,6 +7531,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
+	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -7540,6 +7541,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct sk_buff *skb2;
 	bool reset = false;
 	u32 objtype;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -7578,27 +7580,23 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	if (reset) {
-		const struct nftables_pernet *nft_net;
-		char *buf;
-
-		nft_net = nft_pernet(net);
-		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
-
-		audit_log_nfcfg(buf,
-				family,
-				1,
-				AUDIT_NFT_OP_OBJ_RESET,
-				GFP_ATOMIC);
-		kfree(buf);
-	}
-
 	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
 	if (err < 0)
 		goto err_fill_obj_info;
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
+			nla_len(nla[NFTA_OBJ_TABLE]),
+			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
+			nft_net->base_seq);
+	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
+			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	kfree(buf);
+
 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
 err_fill_obj_info:
-- 
2.43.0



