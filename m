Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853B451A744;
	Wed, 30 Sep 2026 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784944; cv=none; b=DaarkTaqDdTg5ohqYIpAyCfxN/KJ/OnNdroK53PPySZ3lNxZNbKo+Ubr6A30iRKOIujL1PEJlde+SxdcqOPMcZRxEFnrugF1pO3EK5KfNJFcrH01Ex0odVmRBDRVWdaJfOaHY9SZrhrS9A7KDs0KhzowP5sRbfZcGEMHCv7d8EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784944; c=relaxed/simple;
	bh=3/AjNBOj3itYRmcZhJzqyHx1VvVJIk7QrtYRUCiiU7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZvVJWc5GTkLHKEJF/wogJzcwg75IKBaaPTqCVmXq+ToNwJJRkHUSjEddnMTxldkRm4ryo3PCn2Gev0u83nVGps0WbeU/FSq7aN06TK00Rztb72i7YOC8RPtGGBr+WRiGrcZ7mpqQXry0RVrfAP0mPz9HdK36v16k1vReIHWHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQ4xlcIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQ4xlcIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ABD1F000FF;
	Wed, 30 Sep 2026 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784940;
	bh=6htRyWwpwCIGIrCPJGesxjmt/y1NCDbD7UFCpJhcA/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQ4xlcIOAxNeaM1KUbwMCi9C3lHpQ9dIEBE1BFNDsa5bT3OWxSULaZpG9ikKugeVn
	 hRiWTEqU8ybQY3nsl6P2f8fjebmawsER5qzvrqAmg6ocRmSbiSK86EisqJL7WzfQu5
	 vpYSwtfys0FqiUBbS0/5/RdFWWozvpZUFjOWn3zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/982] net/sched: act_api: conditional notification of events
Date: Wed, 30 Sep 2026 17:17:48 +0200
Message-ID: <20260930152423.951015766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 8d4390f51920c1edb2d09d44d918c7940ac51e54 ]

As of today tc-action events are unconditionally built and sent to
RTNLGRP_TC. As with the introduction of rtnl_notify_needed we can check
before-hand if they are really needed.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20231208192847.714940-6-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 251367a0a331 ("net/sched: act_api: fix skb sizing and action leak on reoffload delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 98 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 23 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index e68c1cacb5e58..8b81c25b3e8b2 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1832,30 +1832,45 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
 	return 0;
 }
 
-static int
-tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
+static struct sk_buff *tcf_reoffload_del_notify_msg(struct net *net,
+						    struct tc_action *action)
 {
 	size_t attr_size = tcf_action_fill_size(action);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
 		[0] = action,
 	};
-	const struct tc_action_ops *ops = action->ops;
 	struct sk_buff *skb;
-	int ret;
 
 	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
-		return -ENOBUFS;
+		return ERR_PTR(-ENOBUFS);
 
 	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1, NULL) <= 0) {
 		kfree_skb(skb);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
+	}
+
+	return skb;
+}
+
+static int tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
+{
+	const struct tc_action_ops *ops = action->ops;
+	struct sk_buff *skb;
+	int ret;
+
+	if (!rtnl_notify_needed(net, 0, RTNLGRP_TC)) {
+		skb = NULL;
+	} else {
+		skb = tcf_reoffload_del_notify_msg(net, action);
+		if (IS_ERR(skb))
+			return PTR_ERR(skb);
 	}
 
 	ret = tcf_idr_release_unsafe(action);
 	if (ret == ACT_P_DELETED) {
 		module_put(ops->owner);
-		ret = rtnetlink_send(skb, net, 0, RTNLGRP_TC, 0);
+		ret = rtnetlink_maybe_send(skb, net, 0, RTNLGRP_TC, 0);
 	} else {
 		kfree_skb(skb);
 	}
@@ -1921,22 +1936,41 @@ int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
 	return 0;
 }
 
-static int
-tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
-	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
+static struct sk_buff *tcf_del_notify_msg(struct net *net, struct nlmsghdr *n,
+					  struct tc_action *actions[],
+					  u32 portid, size_t attr_size,
+					  struct netlink_ext_ack *extack)
 {
-	int ret;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
-		return -ENOBUFS;
+		return ERR_PTR(-ENOBUFS);
 
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, 0, RTM_DELACTION,
 			 0, 2, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink TC action attributes");
 		kfree_skb(skb);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
+	}
+
+	return skb;
+}
+
+static int tcf_del_notify(struct net *net, struct nlmsghdr *n,
+			  struct tc_action *actions[], u32 portid,
+			  size_t attr_size, struct netlink_ext_ack *extack)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	if (!rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC)) {
+		skb = NULL;
+	} else {
+		skb = tcf_del_notify_msg(net, n, actions, portid, attr_size,
+					 extack);
+		if (IS_ERR(skb))
+			return PTR_ERR(skb);
 	}
 
 	/* now do the delete */
@@ -1947,9 +1981,8 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return ret;
 	}
 
-	ret = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	return ret;
+	return rtnetlink_maybe_send(skb, net, portid, RTNLGRP_TC,
+				    n->nlmsg_flags & NLM_F_ECHO);
 }
 
 static int
@@ -2001,25 +2034,44 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	return ret;
 }
 
-static int
-tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
-	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
+static struct sk_buff *tcf_add_notify_msg(struct net *net, struct nlmsghdr *n,
+					  struct tc_action *actions[],
+					  u32 portid, size_t attr_size,
+					  struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 
 	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
-		return -ENOBUFS;
+		return ERR_PTR(-ENOBUFS);
 
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, n->nlmsg_flags,
 			 RTM_NEWACTION, 0, 0, extack) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to fill netlink attributes while adding TC action");
 		kfree_skb(skb);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
+	}
+
+	return skb;
+}
+
+static int tcf_add_notify(struct net *net, struct nlmsghdr *n,
+			  struct tc_action *actions[], u32 portid,
+			  size_t attr_size, struct netlink_ext_ack *extack)
+{
+	struct sk_buff *skb;
+
+	if (!rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC)) {
+		skb = NULL;
+	} else {
+		skb = tcf_add_notify_msg(net, n, actions, portid, attr_size,
+					 extack);
+		if (IS_ERR(skb))
+			return PTR_ERR(skb);
 	}
 
-	return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			      n->nlmsg_flags & NLM_F_ECHO);
+	return rtnetlink_maybe_send(skb, net, portid, RTNLGRP_TC,
+				    n->nlmsg_flags & NLM_F_ECHO);
 }
 
 static int tcf_action_add(struct net *net, struct nlattr *nla,
-- 
2.53.0



