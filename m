Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC6B51EE1B;
	Wed, 30 Sep 2026 18:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793117; cv=none; b=bAhZB2CDXAgWHisPjgEzWucD0J97QMDIYtuc2LeiEkt5CENstN7wgUAH3xNkVWUA9Vdjo1fxBIGNOBEYTgnDlKiOiX+rQdLDuOkctd9utwtt/l5Hg5oPjr9XmSso4o7hrlWEV39QC2pOwNxvb7rDRQtb5sDfHOVSGh+vPWbtEXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793117; c=relaxed/simple;
	bh=idD0gYGK2rnEdjxWQhLfBw+ccZYHTjfkz1xFemV3zMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVdp9ELmnKqpEjtnrlnQGC8h0/MIQM1LC0VBtxFXt5lvW8/7phZkdBayYpeWlIasu6jTLrFLZxz+yzvEO8tXDwUon4Q9tEeJ8os3k9mThXvzCyrrzdJZ43tuesl06vvUq/LfBLtsdDljgm8Ux28vxBYXN/3IAcuFhmkBSJQphG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzWLiz3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzWLiz3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F611F000FF;
	Wed, 30 Sep 2026 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793115;
	bh=jOwheGPsrR7RSZ9uACsEoQeRtgiI7QcUeY05uvrmgAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzWLiz3fZ/j641/26R9hdlpV3D6N7QX61sEmOye5vO9n5KJkYC5xdxwNouDvjwQvX
	 VPHDvfe0Vy2ALdNT1foC9Lf4ItSnh1Z5VZh2v6JPv2SAMR903zjWmItCjBe5iJei9S
	 A3pRbADrW6qYP6eknEjx+63EjpnxanWbB4LZwX80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/395] genetlink: report the real command id for dump-only ops in policy dumps
Date: Wed, 30 Sep 2026 17:26:26 +0200
Message-ID: <20260930152343.333357694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 81b4494e2db74..7925a7913bc4f 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1657,7 +1657,7 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 }
 
 static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
-				  struct netlink_callback *cb,
+				  struct netlink_callback *cb, u32 cmd,
 				  struct genl_split_ops *doit,
 				  struct genl_split_ops *dumpit)
 {
@@ -1678,7 +1678,7 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 	if (!nest_pol)
 		goto err;
 
-	nest_op = nla_nest_start(skb, doit->cmd);
+	nest_op = nla_nest_start(skb, cmd);
 	if (!nest_op)
 		goto err;
 
@@ -1722,7 +1722,8 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 						      &doit, &dumpit)))
 				return -ENOENT;
 
-			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
+			if (ctrl_dumppolicy_put_op(skb, cb, ctx->op,
+						   &doit, &dumpit))
 				return skb->len;
 
 			/* done with the per-op policy index list */
@@ -1731,6 +1732,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 
 		while (ctx->dump_map) {
 			if (ctrl_dumppolicy_put_op(skb, cb,
+						   ctx->op_iter->cmd,
 						   &ctx->op_iter->doit,
 						   &ctx->op_iter->dumpit))
 				return skb->len;
-- 
2.53.0



