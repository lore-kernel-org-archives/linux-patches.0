Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17FD280CFF;
	Wed, 23 Apr 2025 14:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419869; cv=none; b=Qkmy1XiTgbq5xYF4LdlnI2wjZc5uSX1lo8q0cK7UXXxJvr6cZXCBkrF7bKbvIgES5Wa7aGstBqYtDVJTDB1NHxzBb+DkcckwKs7OS9MNzZ8vBJhx4HRSomUMpYtwfc438QwnygvAOgJ8LCu5b4cd+xsF/Ci9D42VF1BEFtlMOAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419869; c=relaxed/simple;
	bh=3nL7GEnfTEIfxjQaf7myhvkOtAvRyYDpE+ro3j5BDYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmxBECdCOUV1MqDYAn9Ka8ncR+YY1VCbQgHF3ncGE7mCK6ABWJX6EfY0nW8MY5IQQRjDCzrIxo8s6g9BgV77kdINLOfp216Plxf65+xiVRJFukMP2HDeN9HyP+6NFXkKIIseZZWStZJoOJ1/lo1lKpWiu4WqyPPv7T/nQ768IL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKv6NIZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKv6NIZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2EEC4CEE8;
	Wed, 23 Apr 2025 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419868;
	bh=3nL7GEnfTEIfxjQaf7myhvkOtAvRyYDpE+ro3j5BDYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKv6NIZChY7o1nfADk3kcV5rrVxU70bWK0vT1gMHjbZRf5qvOKR3uLwWgw8N5lYmZ
	 miPU6KezIW1pGH5ehW5QtZC+mddc966GWswIJmN89qI4s0P9+RGRlqEOhJSYCuUbUc
	 pTYJtclByDwc7PkkwbYofLp2QZHDqXXAqiCWIRX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/393] net/sched: cls_api: conditional notification of events
Date: Wed, 23 Apr 2025 16:38:30 +0200
Message-ID: <20250423142643.860517417@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 96c39e9a873c7..a0eb389b4fb4b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2038,6 +2038,9 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	int err = 0;
 
+	if (!unicast && !rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC))
+		return 0;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
@@ -2067,6 +2070,9 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
 	int err;
 
+	if (!rtnl_notify_needed(net, n->nlmsg_flags, RTNLGRP_TC))
+		return tp->ops->delete(tp, fh, last, rtnl_held, extack);
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
@@ -2891,6 +2897,9 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 	struct sk_buff *skb;
 	int err = 0;
 
+	if (!unicast && !rtnl_notify_needed(net, flags, RTNLGRP_TC))
+		return 0;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
@@ -2920,6 +2929,9 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
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



