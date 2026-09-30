Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80895208C9;
	Wed, 30 Sep 2026 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789186; cv=none; b=r+wyyhmrOFlALjDV4/1rVlU8jjFSGhJbjzfrOZAvCbBIymsYKvTcyNrNsqr0Rc//+nzlHaUWQBnlI1PW5xNkKBE92xmqoHIuKJpzflXWVZYl9R6BMle8KeVU6D2tYuSfNAh1eEI1Qmo8tpDi4DXMWWsfRmBwW5OJyV4lneN6xqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789186; c=relaxed/simple;
	bh=zENqPctALHpF5x1N1koeGDunLbJxyscODAyKFg9E/mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFMEMMxc88K1OT8r6T6BwNXVI6GeRJmcPfEWUWIph5gHm6pXurTygzZZUxp4JJHz3Wcda5BsNSbJlv7M7XK4IolvhIyF+FWRp4UYwcjo3eAvwZOqlEt2M65lnA8hFwvOWdVC79Ylr67MMu+uo0htlw3umoGkcR7C8iWUssByM54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CXrzjZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CXrzjZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4B51F000FF;
	Wed, 30 Sep 2026 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789184;
	bh=x9lk4vgkyGgeIuESDQgVR94EyCcDxYx9+Bs1TK6es7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CXrzjZBwXKlkuAquPekW78BtaEXgGddpRL0zpFuHBU8UtqSzR87Ke0DB0BQcTblg
	 1QxpUThTW1um2LEWH3DvFF+g3akw0xV4piHZ8EPahpJPNZBXUPfbsdVMeyfVHu9krk
	 TPAMT9tPp0VN06YS9PI8cSLW5XmMAcep9FP7+0zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/877] genetlink: report the real command id for dump-only ops in policy dumps
Date: Wed, 30 Sep 2026 17:21:38 +0200
Message-ID: <20260930152423.034892692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3327d84518141..ecd5a0fd482a6 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1647,7 +1647,7 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 }
 
 static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
-				  struct netlink_callback *cb,
+				  struct netlink_callback *cb, u32 cmd,
 				  struct genl_split_ops *doit,
 				  struct genl_split_ops *dumpit)
 {
@@ -1668,7 +1668,7 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 	if (!nest_pol)
 		goto err;
 
-	nest_op = nla_nest_start(skb, doit->cmd);
+	nest_op = nla_nest_start(skb, cmd);
 	if (!nest_op)
 		goto err;
 
@@ -1712,7 +1712,8 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 						      &doit, &dumpit)))
 				return -ENOENT;
 
-			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
+			if (ctrl_dumppolicy_put_op(skb, cb, ctx->op,
+						   &doit, &dumpit))
 				return skb->len;
 
 			/* done with the per-op policy index list */
@@ -1721,6 +1722,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 
 		while (ctx->dump_map) {
 			if (ctrl_dumppolicy_put_op(skb, cb,
+						   ctx->op_iter->cmd,
 						   &ctx->op_iter->doit,
 						   &ctx->op_iter->dumpit))
 				return skb->len;
-- 
2.53.0



