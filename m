Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADDB7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1314C433C9;
	Sun, 17 Sep 2023 19:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980131;
	bh=NtVjRWhXGN23KRDtLWiXQA+uVwiOXr+7/CUy9ePqRtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymoroV9f1lxozSLzuQlVJSPww9KNCnfEbbl1a3DojpvGaudXGu5bq4b6pQbZHmvXU
	 k65l1MUZONsJkyCt5rE/Rea1OY8pSD8LVkOu0s73y/he3829uNBRPscln/0YBA0cHj
	 sMJ5pHXpX+QndK14TTRANmYwccd3z68Brlb5Ct0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Richard Guy Briggs <rgb@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 104/285] netfilter: nf_tables: Audit log setelem reset
Date: Sun, 17 Sep 2023 21:11:44 +0200
Message-ID: <20230917191055.270581975@linuxfoundation.org>
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

[ Upstream commit 7e9be1124dbe7888907e82cab20164578e3f9ab7 ]

Since set element reset is not integrated into nf_tables' transaction
logic, an explicit log call is needed, similar to NFT_MSG_GETOBJ_RESET
handling.

For the sake of simplicity, catchall element reset will always generate
a dedicated log entry. This relieves nf_tables_dump_set() from having to
adjust the logged element count depending on whether a catchall element
was found or not.

Fixes: 079cd633219d7 ("netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/audit.h         |  1 +
 kernel/auditsc.c              |  1 +
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++---
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6a3a9e122bb5e..192bf03aacc52 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -117,6 +117,7 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_OBJ_RESET,
 	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+	AUDIT_NFT_OP_SETELEM_RESET,
 	AUDIT_NFT_OP_INVALID,
 };
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8dfd581cd5543..87342b7126bcd 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -143,6 +143,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
 	{ AUDIT_NFT_OP_OBJ_RESET,		"nft_reset_obj"		   },
 	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
 	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
+	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
 	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eb8b1167dced2..2e3844d5923f5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -102,6 +102,7 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 	[NFT_MSG_NEWFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	[NFT_MSG_GETFLOWTABLE]	= AUDIT_NFT_OP_INVALID,
 	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+	[NFT_MSG_GETSETELEM_RESET] = AUDIT_NFT_OP_SETELEM_RESET,
 };
 
 static void nft_validate_state_update(struct nft_table *table, u8 new_validate_state)
@@ -5621,13 +5622,25 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	return nf_tables_fill_setelem(args->skb, set, elem, args->reset);
 }
 
+static void audit_log_nft_set_reset(const struct nft_table *table,
+				    unsigned int base_seq,
+				    unsigned int nentries)
+{
+	char *buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, base_seq);
+
+	audit_log_nfcfg(buf, table->family, nentries,
+			AUDIT_NFT_OP_SETELEM_RESET, GFP_ATOMIC);
+	kfree(buf);
+}
+
 struct nft_set_dump_ctx {
 	const struct nft_set	*set;
 	struct nft_ctx		ctx;
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
-				 const struct nft_set *set, bool reset)
+				 const struct nft_set *set, bool reset,
+				 unsigned int base_seq)
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
@@ -5643,6 +5656,8 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 
 		elem.priv = catchall->elem;
 		ret = nf_tables_fill_setelem(skb, set, &elem, reset);
+		if (reset && !ret)
+			audit_log_nft_set_reset(set->table, base_seq, 1);
 		break;
 	}
 
@@ -5722,12 +5737,17 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
-		args.iter.err = nft_set_catchall_dump(net, skb, set, reset);
+		args.iter.err = nft_set_catchall_dump(net, skb, set,
+						      reset, cb->seq);
 	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
+	if (reset && args.iter.count > args.iter.skip)
+		audit_log_nft_set_reset(table, cb->seq,
+					args.iter.count - args.iter.skip);
+
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
 		return args.iter.err;
 	if (args.iter.count == cb->args[0])
@@ -5952,13 +5972,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
+	int rem, err = 0, nelems = 0;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
 	bool reset = false;
-	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6001,8 +6021,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
+		nelems++;
 	}
 
+	if (reset)
+		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
+					nelems);
+
 	return err;
 }
 
-- 
2.40.1



