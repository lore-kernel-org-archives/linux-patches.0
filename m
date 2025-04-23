Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52382481CD;
	Wed, 23 Apr 2025 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420171; cv=none; b=V1p/W5N2rQDh/A2Gedycq/5+AdtiJVIKNV38RCcf69F/yDdFLwxxNTOszzzu5Z+VnYrTYmmS2SwVKwPKmgeYhhUGoO1Hu2ZBFjMMSEbxs6m1SflhokFcA03FlMlN9ZQv65iapcivXRYrNhKwLcKR1KFfoMjKJ42R3WSODgmZrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420171; c=relaxed/simple;
	bh=42M8zHsDkoeSD1PzMc/W20L282vRFLcfM6kLolJ+x2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+9EwCbzHD2nwCmi27vjRHejxcDZa3KzYNaEv5AvQaZRd1AKELwDhaAA+9DpcLnatfiGVK3ICnbhua54jtrbeB7cCclHXmobpq+v//t8WOqtYlvjvzFHHr/8BxrYy2kjNoOPd1Qs4dGij6QNOSNlcRAY8Q2pgTgN7rGEq3M6IRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUAQhA8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUAQhA8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FE3C4CEE2;
	Wed, 23 Apr 2025 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420171;
	bh=42M8zHsDkoeSD1PzMc/W20L282vRFLcfM6kLolJ+x2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUAQhA8s1lXlM9UvRMNK5/WkofJyptRFaH//3oRSVztHfO0l7EL+AsUGFhyAeA1mj
	 d0Htc64WhoO/kcJEp1mDczDLvHv0QVIcZqyVcAZiC0fdr0CW5UW356xBbQ93uzEWgR
	 rj8qJJLnaIcQgdi7VvMDWmXzN2SUhw2H4ntnG7tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/291] net/sched: cls_api: conditional notification of events
Date: Wed, 23 Apr 2025 16:39:57 +0200
Message-ID: <20250423142624.752119822@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 93775590b1ee98bf2976b1f4a1ed24e9ff76170f ]

As of today tc-filter/chain events are unconditionally built and sent to
RTNLGRP_TC. As with the introduction of rtnl_notify_needed we can check
before-hand if they are really needed. This will help to alleviate
system pressure when filters are concurrently added without the rtnl
lock as in tc-flower.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20231208192847.714940-8-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 369609fc6272 ("tc: Ensure we have enough buffer space when sending filter netlink notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 445ab1b0537da..2b44b82877f5a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1885,6 +1885,9 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	int err = 0;
 
+	if (!unicast && !rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC))
+		return 0;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
@@ -1914,6 +1917,9 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	int err;
 
+	if (!rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC))
+		return tp->ops->delete(tp, fh, last, rtnl_held, extack);
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
@@ -2731,6 +2737,9 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 	struct sk_buff *skb;
 	int err = 0;
 
+	if (!unicast && !rtnl_notify_needed(net, flags, RTNLGRP_TC))
+		return 0;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
@@ -2760,6 +2769,9 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
 	struct net *net = block->net;
 	struct sk_buff *skb;
 
+	if (!rtnl_notify_needed(net, flags, RTNLGRP_TC))
+		return 0;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
-- 
2.39.5



