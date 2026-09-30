Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E977D3515D1;
	Wed, 30 Sep 2026 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796756; cv=none; b=jbrH2CfEUuAVNuPo02X/Uc/slou0ms0vu+5OV46LBs8S4mR27eQtdOorsoJhkoxWXlGn4FQOVTbNkwU+TqpDQDQco9nKWHkEzONRiA7XdRTENPjmgDWDlvwdAp2Vyz/234VruMNza/lQVNp7m/Tw40a2sWbnIFZ3Px1EwWv92HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796756; c=relaxed/simple;
	bh=DBwgswMhlglwrRQU0aylRmcs7pZcpx+c3x0E6TXtEJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INq1XwHmer84c3fkFwgpCfOvmilVwzpJy81ru67dg5ps9HOG7IvgDq0Wt38ZiQIN57q/l8vw9NeK0950o7J/r6mosiK76wjwmsV7Gr9SDNtRL9jOXe+fv2oZvDB69SDAbbMALPhMeHhCHYetdLgmCjKshXK00/g+NBAfuHODbRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYBjIOnT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYBjIOnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547FC1F000FF;
	Wed, 30 Sep 2026 19:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796754;
	bh=rvJX5GEek3yiP+n3MCxHQtslyLtbXEsabUmC1RNqxyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYBjIOnTQLN24uhORyDMZqm7bMLioBsepGU7ikPspMc8v6YICfTNgicRkx4YsTrvh
	 W6LF4bzzPL1Rod+ZmEjVqtFng09TEoEHTFM+O2O7tMtM+Q3IwBf/TbwK6fMJRzp9zJ
	 J5r+/X6/IfA7b+gZkZXgsBrB7bkKxOCfIHWyeKoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1025/1193] genetlink: report the real command id for dump-only ops in policy dumps
Date: Wed, 30 Sep 2026 17:28:29 +0200
Message-ID: <20260930152457.006494679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 261e8a37ecbaf462cdf9c336d2b2f5056088401a ]

The op-to-policy map a CTRL_CMD_GETPOLICY dump returns is the only way
for userspace to find out which policy index belongs to which command.
ctrl_dumppolicy_put_op() tags the nest with doit->cmd, but an op which
only has a dumpit has no doit and every path which fills the split ops
in zeroes it out, so those entries all claim to be command 0.  nlctrl's
own CTRL_CMD_GETPOLICY and NETDEV_CMD_QSTATS_GET are both in that group:

  [{'family-id': 16, 'op-policy': {'do': 0, 'dump': 0, 'op-id': 3}},
   {'family-id': 16, 'op-policy': {'dump': 1, 'op-id': 0}},

ctrl_fill_info() gets this right - it uses the iterator's cmd for
CTRL_ATTR_OP_ID - so the two introspection interfaces of the same family
contradict each other today.

Pass the command in rather than reconstructing it from
doit->cmd | dumpit->cmd inside the helper, both callers already have it.

Fixes: 26588edbef60 ("genetlink: support split policies in ctrl_dumppolicy_put_op()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260918222949.4190284-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9825369505669..015b14b852f84 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1501,7 +1501,7 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 }
 
 static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
-				  struct netlink_callback *cb,
+				  struct netlink_callback *cb, u32 cmd,
 				  struct genl_split_ops *doit,
 				  struct genl_split_ops *dumpit)
 {
@@ -1522,7 +1522,7 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 	if (!nest_pol)
 		goto err;
 
-	nest_op = nla_nest_start(skb, doit->cmd);
+	nest_op = nla_nest_start(skb, cmd);
 	if (!nest_op)
 		goto err;
 
@@ -1566,7 +1566,8 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 						      &doit, &dumpit)))
 				return -ENOENT;
 
-			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
+			if (ctrl_dumppolicy_put_op(skb, cb, ctx->op,
+						   &doit, &dumpit))
 				return skb->len;
 
 			/* done with the per-op policy index list */
@@ -1575,6 +1576,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 
 		while (ctx->dump_map) {
 			if (ctrl_dumppolicy_put_op(skb, cb,
+						   ctx->op_iter->cmd,
 						   &ctx->op_iter->doit,
 						   &ctx->op_iter->dumpit))
 				return skb->len;
-- 
2.53.0



