Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D2025525C;
	Thu, 17 Apr 2025 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915109; cv=none; b=XQEXcuA1Cl+FScgvdg2mjf6DBQkutl2CUDD2Y4S42h7aSQtiULXfzDXpQ2dZZ5xIhH4W6uZ1rvIyhb47dBINhFXjxfASXr9J2fbQ7Ti643xc+gJRPM0Fj5Eg+XiPtfFR3RtNw54SMl/rEP7rP6p8NcvTMSGI3EmiAPVjWXTdS6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915109; c=relaxed/simple;
	bh=jaZj5fLACdJhG7mKNEEuHX6R8wGvB69YPhrFK0q19p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUQTW3JM6YQiX/ZAzfExpuaoBJqp0ceehEZyg11u/jP7CTMZlXMva3o+KkHgWGZ9VorCutHfxoh1rEQRWffJJKqhipt8oKyH6IdtKV1J5fDhDEv06w5C7PTEWH7JikDUS76yBFV5If2q+Lpg5fzyQFIwSt2Oba1QJ41ZfLbgl0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozhshRZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozhshRZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108B7C4CEE4;
	Thu, 17 Apr 2025 18:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915109;
	bh=jaZj5fLACdJhG7mKNEEuHX6R8wGvB69YPhrFK0q19p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozhshRZyUcJBwbNRKE1N0GhipV/YiBRqq79Y9p7a9Fht0tDaedq7kwf8IpMylb3P4
	 pAOt9DvjbE3bW0q3yf2LKpKr/cvv6McUck67DN00BtDZU6Aw1DCe4DkiNp3caz9X25
	 eWbY1Qt1D/ko7Aph57yPVcCO4VnlV+DHDuE/dOkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frode Nordahl <frode.nordahl@canonical.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/393] tc: Ensure we have enough buffer space when sending filter netlink notifications
Date: Thu, 17 Apr 2025 19:47:10 +0200
Message-ID: <20250417175108.444426208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 998ea3b5badfc..a3bab5e27e71b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2051,6 +2051,7 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
 	unsigned char *b = skb_tail_pointer(skb);
+	int ret = -EMSGSIZE;
 
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*tcm), flags);
 	if (!nlh)
@@ -2095,11 +2096,45 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 
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
@@ -2115,16 +2150,10 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
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
@@ -2147,16 +2176,11 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
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



