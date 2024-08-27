Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7321E520;
	Tue, 27 Aug 2024 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771162; cv=none; b=pB9VzLcJJ9ii4ZzjtfwtEwzI8daCh9G1nlYVDz8M9pBU5h5ikT9cnTEsjCek410YEhG8ql8emHmaHUfivu/ZVfOtbTtOYtkIWbWAclNrvj3LDg7el06a4fJ83uBrsBPFeCMyEt+XbLN/+nUx8F87Czdz/K/uD21XJ3jlstyIeSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771162; c=relaxed/simple;
	bh=Tki843o5/ZnAgtmAus2rSH7QdAzSXBQdb2iY6EGKjwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxTgPY6YQYQm2yn8TpubAYSP1f3t3SIijEt3HGUM5tAG1dd6y+y2tqTFNlQsaXhNAN9CQNA0u7ubj/9K4zszdREFLSXUMa6vYBTBftakXsHjRsHRjcLcnXu5O62CS+xyetRRiZPqZRno9ucrfzmjaQcIMT+0oLLl4fXEesZav9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sClLoTHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sClLoTHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5A2C6107C;
	Tue, 27 Aug 2024 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771162;
	bh=Tki843o5/ZnAgtmAus2rSH7QdAzSXBQdb2iY6EGKjwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sClLoTHsjZfOnxGvlCSDGILpv9TQOuPrG9Cu+hUKM3yD6TFf05R1d/47aZWK2qTTq
	 CMHTZuBSfZjUBBW3oXJKvplULfmcvwHxmeGb5n4eEuyydxKzNm9Qj2kdnSNMREturd
	 izIIkqIPdnTYObmxAeEPGASnDh5XBACZw6qCxL1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 106/273] netfilter: nf_tables: Audit log dump reset after the fact
Date: Tue, 27 Aug 2024 16:37:10 +0200
Message-ID: <20240827143837.443733905@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 91cc3a81ba8f1..7ae055521cf36 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8012,6 +8012,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
+	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -8021,6 +8022,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct sk_buff *skb2;
 	bool reset = false;
 	u32 objtype;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -8059,27 +8061,23 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
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



