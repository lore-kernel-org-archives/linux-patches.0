Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1C97461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787B3C433CA;
	Sun, 17 Sep 2023 19:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980134;
	bh=IypD/JXIcR+bD/Jjk63RQMNMcV1yuByPeFbpAnGS9SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgwYEJiHeBYtveL1g7pl0iS9k4W4WWFAFAI/QAsbT2iX+T3j3jVrck2MXx/4CwfaT
	 6h+v/QQhucnO+G5LSe5WqVE8IJbcSaPkn56Hjus5KAN1Xkosg9eGROIEXhfg/b6OFh
	 I1K8pPCsUwrbsoSm5r2IsyNk9o0xTVfxSBpP1EcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Richard Guy Briggs <rgb@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 105/285] netfilter: nf_tables: Audit log rule reset
Date: Sun, 17 Sep 2023 21:11:45 +0200
Message-ID: <20230917191055.301845427@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit ea078ae9108e25fc881c84369f7c03931d22e555 ]

Resetting rules' stateful data happens outside of the transaction logic,
so 'get' and 'dump' handlers have to emit audit log entries themselves.

Fixes: 8daa8fde3fc3f ("netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/audit.h         |  1 +
 kernel/auditsc.c              |  1 +
 net/netfilter/nf_tables_api.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 192bf03aacc52..51b1b7054a233 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -118,6 +118,7 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
 	AUDIT_NFT_OP_SETELEM_RESET,
+	AUDIT_NFT_OP_RULE_RESET,
 	AUDIT_NFT_OP_INVALID,
 };
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 87342b7126bcd..eae5dfe9b9a01 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -144,6 +144,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
 	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
 	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
 	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
+	{ AUDIT_NFT_OP_RULE_RESET,		"nft_reset_rule"           },
 	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2e3844d5923f5..cc70482b94907 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3422,6 +3422,18 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
+static void audit_log_rule_reset(const struct nft_table *table,
+				 unsigned int base_seq,
+				 unsigned int nentries)
+{
+	char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
+			      table->name, base_seq);
+
+	audit_log_nfcfg(buf, table->family, nentries,
+			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+}
+
 struct nft_rule_dump_ctx {
 	char *table;
 	char *chain;
@@ -3528,6 +3540,9 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 done:
 	rcu_read_unlock();
 
+	if (reset && idx > cb->args[0])
+		audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
+
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -3635,6 +3650,9 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_fill_rule_info;
 
+	if (reset)
+		audit_log_rule_reset(table, nft_pernet(net)->base_seq, 1);
+
 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
 err_fill_rule_info:
-- 
2.40.1



