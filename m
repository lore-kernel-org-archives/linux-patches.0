Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461DF33A9CF;
	Thu, 12 Mar 2026 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347274; cv=none; b=UAuaRO7Ti9EIk2g45VyQZ5FbcjYN1GSB1sgw7GTv7XUZMyy+3rjI9oh3Y8+97HK43/VSLmkmNX13Ga37fwa41d3xSUeErhHCfZmTlov0pOUeUqGtiXlml2ZefHbpOXPG/blXQhbrMNYbOCvMGnkxdUL0a2Fr4DOYhY1d6MIgV4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347274; c=relaxed/simple;
	bh=tfkzPsr9Uii+r9qf1narT6iFpZjLJLLXHRbQo9oAlcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXub8K4CH614fUYFDouYlZYYufAYm3qYyLj8Zhu+hpmefm3lo6IjbUquukG42hwiraXEOXkOsNurPbkVYiZP2VKrLinLgaI/ujQQb4/FdeBrpBvhc0BDhFf66CAOQEHSgwrMJtRsZKap2Mse08dXK1mzDBW+aMcEmf2BMtd1Wv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLXdw14Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLXdw14Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC3DC2BCAF;
	Thu, 12 Mar 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347274;
	bh=tfkzPsr9Uii+r9qf1narT6iFpZjLJLLXHRbQo9oAlcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLXdw14ZV919Xc9cnOGomven/rz1ArK9QhxmHqKRDW/0z0lrULGIBEF/Z54c8bPo0
	 Doqrt0L8/nBQ95EGqdiuqvKJx3KRFDGxk5gJ0hxcOZx3VTf6EfYg+YlR9K2OQY6maV
	 IC+/9h/mt7xG1Y/mxARNZKm1eBAJIEeUNlADCiko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 249/265] net/sched: Only allow act_ct to bind to clsact/ingress qdiscs and shared blocks
Date: Thu, 12 Mar 2026 21:10:36 +0100
Message-ID: <20260312201027.333907066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

commit 11cb63b0d1a0685e0831ae3c77223e002ef18189 upstream.

As Paolo said earlier [1]:

"Since the blamed commit below, classify can return TC_ACT_CONSUMED while
the current skb being held by the defragmentation engine. As reported by
GangMin Kim, if such packet is that may cause a UaF when the defrag engine
later on tries to tuch again such packet."

act_ct was never meant to be used in the egress path, however some users
are attaching it to egress today [2]. Attempting to reach a middle
ground, we noticed that, while most qdiscs are not handling
TC_ACT_CONSUMED, clsact/ingress qdiscs are. With that in mind, we
address the issue by only allowing act_ct to bind to clsact/ingress
qdiscs and shared blocks. That way it's still possible to attach act_ct to
egress (albeit only with clsact).

[1] https://lore.kernel.org/netdev/674b8cbfc385c6f37fb29a1de08d8fe5c2b0fbee.1771321118.git.pabeni@redhat.com/
[2] https://lore.kernel.org/netdev/cc6bfb4a-4a2b-42d8-b9ce-7ef6644fb22b@ovn.org/

Reported-by: GangMin Kim <km.kim1503@gmail.com>
Fixes: 3f14b377d01d ("net/sched: act_ct: fix skb leak and crash on ooo frags")
CC: stable@vger.kernel.org
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260225134349.1287037-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h |    1 +
 net/sched/act_ct.c    |    6 ++++++
 net/sched/cls_api.c   |    7 +++++++
 3 files changed, 14 insertions(+)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -68,6 +68,7 @@ struct tc_action {
 #define TCA_ACT_FLAGS_REPLACE	(1U << (TCA_ACT_FLAGS_USER_BITS + 2))
 #define TCA_ACT_FLAGS_NO_RTNL	(1U << (TCA_ACT_FLAGS_USER_BITS + 3))
 #define TCA_ACT_FLAGS_AT_INGRESS	(1U << (TCA_ACT_FLAGS_USER_BITS + 4))
+#define TCA_ACT_FLAGS_AT_INGRESS_OR_CLSACT	(1U << (TCA_ACT_FLAGS_USER_BITS + 5))
 
 /* Update lastuse only if needed, to avoid dirtying a cache line.
  * We use a temp variable to avoid fetching jiffies twice.
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1358,6 +1358,12 @@ static int tcf_ct_init(struct net *net,
 		return -EINVAL;
 	}
 
+	if (bind && !(flags & TCA_ACT_FLAGS_AT_INGRESS_OR_CLSACT)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Attaching ct to a non ingress/clsact qdisc is unsupported");
+		return -EOPNOTSUPP;
+	}
+
 	err = nla_parse_nested(tb, TCA_CT_MAX, nla, ct_policy, extack);
 	if (err < 0)
 		return err;
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2222,6 +2222,11 @@ static bool is_qdisc_ingress(__u32 class
 	return (TC_H_MIN(classid) == TC_H_MIN(TC_H_MIN_INGRESS));
 }
 
+static bool is_ingress_or_clsact(struct tcf_block *block, struct Qdisc *q)
+{
+	return tcf_block_shared(block) || (q && !!(q->flags & TCQ_F_INGRESS));
+}
+
 static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			  struct netlink_ext_ack *extack)
 {
@@ -2415,6 +2420,8 @@ replay:
 		flags |= TCA_ACT_FLAGS_NO_RTNL;
 	if (is_qdisc_ingress(parent))
 		flags |= TCA_ACT_FLAGS_AT_INGRESS;
+	if (is_ingress_or_clsact(block, q))
+		flags |= TCA_ACT_FLAGS_AT_INGRESS_OR_CLSACT;
 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
 			      flags, extack);
 	if (err == 0) {


