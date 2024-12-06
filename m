Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366F81FF7D1;
	Fri,  6 Dec 2024 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497209; cv=none; b=qnQq64WVZX+X3MAVvzDUwriYQuq//DD43Y3fEcP5DKhWCLs1He1cAk+g/Gh81mx9tBSFu7T/hNFxMjZ3oui3EU5gX7SPz5s7hL2M9+FXIfGotUD64i6NjBVzxSjSuhA5XoNzofl5vjeFAbkoVqjPKE7wAETZhfkYaQepQiTSvY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497209; c=relaxed/simple;
	bh=dsULX+3Im9RAE1wuTKcml9WNh88hfaRqAwSHmHgYI8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUz5U7lspxI/plTJCxLPc6XksaS0YzhK95DGSSOiqBe6LV0hSKHfpREzS/np/RfCmz4bFU0wFMrY1EIuuR9iiR+XUW8Od3zIpARO3ercm2Gcnmix7YAd5q3pNfz0ilQN2fYQEzmPtvrmU1kt608ddofZRQGvma4E3RIdNWYY9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUHoeLx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUHoeLx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BE3C4CED1;
	Fri,  6 Dec 2024 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497208;
	bh=dsULX+3Im9RAE1wuTKcml9WNh88hfaRqAwSHmHgYI8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUHoeLx5qt0GX4PU2FKKIJgCO910Mk/y/L4t35BVMN5870H9LdTWahtJdU8FkSXWh
	 KrhU9g316xeDrx/AYOYx6NQZHn/j7+6YdHOR+rpHcGyIjCBaPtYJSFzfHCa5PIQdLc
	 IpjUr+9jQ2gZQInuPv4Sznhvig52l15MVov+riY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/676] netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()
Date: Fri,  6 Dec 2024 15:30:45 +0100
Message-ID: <20241206143702.165474749@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 8877393029e764036892d39614900987cbd21ca6 ]

The table lookup will be dropped from that function, so remove that
dependency from audit logging code. Using whatever is in
nla[NFTA_RULE_TABLE] is sufficient as long as the previous rule info
filling succeded.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 9adbb4198bf6 ("netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8a583e8f3c136..a75cab71426da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3665,15 +3665,18 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
+	u32 portid = NETLINK_CB(skb).portid;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
 	bool reset = false;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -3713,16 +3716,24 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
 		reset = true;
 
-	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
+	err = nf_tables_fill_rule_info(skb2, net, portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, 0, reset);
 	if (err < 0)
 		goto err_fill_rule_info;
 
-	if (reset)
-		audit_log_rule_reset(table, nft_pernet(net)->base_seq, 1);
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, portid);
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
+			nla_len(nla[NFTA_RULE_TABLE]),
+			(char *)nla_data(nla[NFTA_RULE_TABLE]),
+			nft_net->base_seq);
+	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
+			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+
+	return nfnetlink_unicast(skb2, net, portid);
 
 err_fill_rule_info:
 	kfree_skb(skb2);
-- 
2.43.0



