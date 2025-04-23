Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E7B27CB12;
	Wed, 23 Apr 2025 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419876; cv=none; b=mv5tbYq/pqkj3e38sMr/NtygS3vIwkgP+0KN9kWnXu/mJ6WtpPopHfjtGe73FOHXMfFTYDNOqZQOVMG4qjCgianWW69eRIGsoO7Diif5qALglqzygqC4Byqri1wHXg4+gcAB527JQ2NHTWnG1Q6ugBqfe6ZD++YAMPSHafbRUr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419876; c=relaxed/simple;
	bh=TwFsPhVAjPMy2625eu+6oY8Jt24pEYDNe0zsF//gYVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDKq9ZsX+gzl80FzKLE0uVyFRUgbfix53tkf7/KsQVS/hc5XFeedV6Nh88IrX3SaoAnxAkKLc6PfQUS1E0U54p+4RbM/4ZP5USyBlfHEa1z6ubKv1EVz5e8uhe3GO9grxvQ71l82kdaXNDoNWUuZu1+j0409AOCPk1VIgYIhaSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0YZX0R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0YZX0R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBE4C4CEE2;
	Wed, 23 Apr 2025 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419876;
	bh=TwFsPhVAjPMy2625eu+6oY8Jt24pEYDNe0zsF//gYVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0YZX0R9lcstw9uxLOi2C4ouxqYsCqtsC+ELyT+fQ84hFa+A6Ba7XWQNil8JktUX3
	 KFh5D9U/AMf9ClUX3JI8eCphUPKY24Jok1rq/us5qHpp57PX8hCVoA4vVqVu7mJF71
	 OaH1FtmlUVudiZxA9bvibOuIzUdLg4E/qa1h7h+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frode Nordahl <frode.nordahl@canonical.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/393] tc: Ensure we have enough buffer space when sending filter netlink notifications
Date: Wed, 23 Apr 2025 16:38:31 +0200
Message-ID: <20250423142643.901604408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 369609fc6272c2f6ad666ba4fd913f3baf32908f ]

The tfilter_notify() and tfilter_del_notify() functions assume that
NLMSG_GOODSIZE is always enough to dump the filter chain. This is not
always the case, which can lead to silent notify failures (because the
return code of tfilter_notify() is not always checked). In particular,
this can lead to NLM_F_ECHO not being honoured even though an action
succeeds, which forces userspace to create workarounds[0].

Fix this by increasing the message size if dumping the filter chain into
the allocated skb fails. Use the size of the incoming skb as a size hint
if set, so we can start at a larger value when appropriate.

To trigger this, run the following commands:

 # ip link add type veth
 # tc qdisc replace dev veth0 root handle 1: fq_codel
 # tc -echo filter add dev veth0 parent 1: u32 match u32 0 0 $(for i in $(seq 32); do echo action pedit munge ip dport set 22; done)

Before this fix, tc just returns:

Not a filter(cmd 2)

After the fix, we get the correct echo:

added filter dev veth0 parent 1: protocol all pref 49152 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 terminal flowid not_in_hw
  match 00000000/00000000 at 0
	action order 1:  pedit action pass keys 1
 	index 1 ref 1 bind 1
	key #0  at 20: val 00000016 mask ffff0000
[repeated 32 times]

[0] https://github.com/openvswitch/ovs/commit/106ef21860c935e5e0017a88bf42b94025c4e511

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Frode Nordahl <frode.nordahl@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/openvswitch/+bug/2018500
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20250407105542.16601-1-toke@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 66 ++++++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a0eb389b4fb4b..7245f39d1e652 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1977,6 +1977,7 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
 	unsigned char *b = skb_tail_pointer(skb);
+	int ret = -EMSGSIZE;
 
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*tcm), flags);
 	if (!nlh)
@@ -2021,11 +2022,45 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 
 	return skb->len;
 
+cls_op_not_supp:
+	ret = -EOPNOTSUPP;
 out_nlmsg_trim:
 nla_put_failure:
-cls_op_not_supp:
 	nlmsg_trim(skb, b);
-	return -1;
+	return ret;
+}
+
+static struct sk_buff *tfilter_notify_prep(struct net *net,
+					   struct sk_buff *oskb,
+					   struct nlmsghdr *n,
+					   struct tcf_proto *tp,
+					   struct tcf_block *block,
+					   struct Qdisc *q, u32 parent,
+					   void *fh, int event,
+					   u32 portid, bool rtnl_held,
+					   struct netlink_ext_ack *extack)
+{
+	unsigned int size = oskb ? max(NLMSG_GOODSIZE, oskb->len) : NLMSG_GOODSIZE;
+	struct sk_buff *skb;
+	int ret;
+
+retry:
+	skb = alloc_skb(size, GFP_KERNEL);
+	if (!skb)
+		return ERR_PTR(-ENOBUFS);
+
+	ret = tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
+			    n->nlmsg_seq, n->nlmsg_flags, event, false,
+			    rtnl_held, extack);
+	if (ret <= 0) {
+		kfree_skb(skb);
+		if (ret == -EMSGSIZE) {
+			size += NLMSG_GOODSIZE;
+			goto retry;
+		}
+		return ERR_PTR(-EINVAL);
+	}
+	return skb;
 }
 
 static int tfilter_notify(struct net *net, struct sk_buff *oskb,
@@ -2041,16 +2076,10 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 	if (!unicast && !rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC))
 		return 0;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb)
-		return -ENOBUFS;
-
-	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
-			  n->nlmsg_seq, n->nlmsg_flags, event,
-			  false, rtnl_held, extack) <= 0) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
+	skb = tfilter_notify_prep(net, oskb, n, tp, block, q, parent, fh, event,
+				  portid, rtnl_held, extack);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
 	if (unicast)
 		err = rtnl_unicast(skb, net, portid);
@@ -2073,16 +2102,11 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 	if (!rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC))
 		return tp->ops->delete(tp, fh, last, rtnl_held, extack);
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb)
-		return -ENOBUFS;
-
-	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
-			  n->nlmsg_seq, n->nlmsg_flags, RTM_DELTFILTER,
-			  false, rtnl_held, extack) <= 0) {
+	skb = tfilter_notify_prep(net, oskb, n, tp, block, q, parent, fh,
+				  RTM_DELTFILTER, portid, rtnl_held, extack);
+	if (IS_ERR(skb)) {
 		NL_SET_ERR_MSG(extack, "Failed to build del event notification");
-		kfree_skb(skb);
-		return -EINVAL;
+		return PTR_ERR(skb);
 	}
 
 	err = tp->ops->delete(tp, fh, last, rtnl_held, extack);
-- 
2.39.5



