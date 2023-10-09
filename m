Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBF21A5BB
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDkyO+ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3EDC433C8;
	Mon,  9 Oct 2023 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857681;
	bh=gPyo8Ky/indgNQGiYz0jWUwyukQ/2FD2YrWePHsIbR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDkyO+evcA2n4X397egKCNonkJ0uoWOrdGVn9tTa5lniFZaEY1hhpawuygMnSD4wJ
	 013L9nvVBQAgs4uXY5Wy+v3Ah2uYmkLw8YZErQjmFgREuDKpaOxHbyR3usDLlctJ9W
	 gJWgd35A6oR5o6P46k4bV5yWY37PGMZijn7fjSK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Richard Guy Briggs <rgb@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 122/162] netfilter: nf_tables: Deduplicate nft_register_obj audit logs
Date: Mon,  9 Oct 2023 15:01:43 +0200
Message-ID: <20231009130126.295288998@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

[ Upstream commit 0d880dc6f032e0b541520e9926f398a77d3d433c ]

When adding/updating an object, the transaction handler emits suitable
audit log entries already, the one in nft_obj_notify() is redundant. To
fix that (and retain the audit logging from objects' 'update' callback),
Introduce an "audit log free" variant for internal use.

Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com> (Audit)
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c                 | 44 ++++++++++++-------
 .../testing/selftests/netfilter/nft_audit.sh  | 20 +++++++++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 52b81dc1fcf5b..5e3dbe2652dbd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7576,24 +7576,14 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	return nft_delobj(&ctx, obj);
 }
 
-void nft_obj_notify(struct net *net, const struct nft_table *table,
-		    struct nft_object *obj, u32 portid, u32 seq, int event,
-		    u16 flags, int family, int report, gfp_t gfp)
+static void
+__nft_obj_notify(struct net *net, const struct nft_table *table,
+		 struct nft_object *obj, u32 portid, u32 seq, int event,
+		 u16 flags, int family, int report, gfp_t gfp)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(gfp, "%s:%u",
-			      table->name, nft_net->base_seq);
-
-	audit_log_nfcfg(buf,
-			family,
-			obj->handle,
-			event == NFT_MSG_NEWOBJ ?
-				 AUDIT_NFT_OP_OBJ_REGISTER :
-				 AUDIT_NFT_OP_OBJ_UNREGISTER,
-			gfp);
-	kfree(buf);
 
 	if (!report &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
@@ -7616,13 +7606,35 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
+
+void nft_obj_notify(struct net *net, const struct nft_table *table,
+		    struct nft_object *obj, u32 portid, u32 seq, int event,
+		    u16 flags, int family, int report, gfp_t gfp)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	char *buf = kasprintf(gfp, "%s:%u",
+			      table->name, nft_net->base_seq);
+
+	audit_log_nfcfg(buf,
+			family,
+			obj->handle,
+			event == NFT_MSG_NEWOBJ ?
+				 AUDIT_NFT_OP_OBJ_REGISTER :
+				 AUDIT_NFT_OP_OBJ_UNREGISTER,
+			gfp);
+	kfree(buf);
+
+	__nft_obj_notify(net, table, obj, portid, seq, event,
+			 flags, family, report, gfp);
+}
 EXPORT_SYMBOL_GPL(nft_obj_notify);
 
 static void nf_tables_obj_notify(const struct nft_ctx *ctx,
 				 struct nft_object *obj, int event)
 {
-	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
-		       ctx->flags, ctx->family, ctx->report, GFP_KERNEL);
+	__nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
+			 ctx->seq, event, ctx->flags, ctx->family,
+			 ctx->report, GFP_KERNEL);
 }
 
 /*
diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index 0b3255e7b3538..bb34329e02a7f 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -85,6 +85,26 @@ do_test "nft add set t1 s2 $setblock; add set t1 s3 { $settype; }" \
 do_test "nft add element t1 s3 $setelem" \
 "table=t1 family=2 entries=3 op=nft_register_setelem"
 
+# adding counters
+
+do_test 'nft add counter t1 c1' \
+'table=t1 family=2 entries=1 op=nft_register_obj'
+
+do_test 'nft add counter t2 c1; add counter t2 c2' \
+'table=t2 family=2 entries=2 op=nft_register_obj'
+
+# adding/updating quotas
+
+do_test 'nft add quota t1 q1 { 10 bytes }' \
+'table=t1 family=2 entries=1 op=nft_register_obj'
+
+do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
+'table=t2 family=2 entries=2 op=nft_register_obj'
+
+# changing the quota value triggers obj update path
+do_test 'nft add quota t1 q1 { 20 bytes }' \
+'table=t1 family=2 entries=1 op=nft_register_obj'
+
 # resetting rules
 
 do_test 'nft reset rules t1 c2' \
-- 
2.40.1



