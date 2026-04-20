Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604DB2D77E5;
	Mon, 20 Apr 2026 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700210; cv=none; b=ZjJK19tF2alH3yVDe6wZ+x9JZimDI7vInXM4fyJ2pBlrawxRCPa24uv39OYM6Bhs0M+H2ATJavbSGm02rZKAiuWM8iDu8EZ+3bd9w41+wt+tMotD5eY4e8uRnJZ59P81l1YMnslAm2WAP7IDnqzoTMa/ILKrctW7rqlcn4qQwxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700210; c=relaxed/simple;
	bh=cNf22argBLd+/oKaXFfwNxCYcGQivy7JFjvlUFGKoqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1FFRx1b6WTv1XKW9hfR7nwdP9vNNT2sTPGXFwmx1akTZmONYHgYDcuIozhtOytnR9F8cXoHnL/D1ySV+1vxiBJ5qtOYtB1pjXXYI8sPbZ3HmBWLlqbqcJLl6MECirmvSOUBy21sFkTMfgwsbQqpeeYfjsHgQbzQ1Zuv31aNLCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPvFc0WP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPvFc0WP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4128C19425;
	Mon, 20 Apr 2026 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700210;
	bh=cNf22argBLd+/oKaXFfwNxCYcGQivy7JFjvlUFGKoqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPvFc0WPy9L7nSYMbamT/quofw3T+UaCXW2hM8HJus6uSBowT2VbxRilxdNfcmhgb
	 WdK0tvKwXeT8cyzZbbgOsa5bxng0N2bryllcaFLXpFoN/edVsfDHHUIe05miayH3b9
	 9VYSxZCN6CqXkwvLnW9Pt7Yy9WhTTK006EKalKzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 085/220] ipv4: nexthop: allocate skb dynamically in rtm_get_nexthop()
Date: Mon, 20 Apr 2026 17:40:26 +0200
Message-ID: <20260420153937.097920649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14cf0cd35361f4e94824bf8a42f72713d7702a73 ]

When querying a nexthop object via RTM_GETNEXTHOP, the kernel currently
allocates a fixed-size skb using NLMSG_GOODSIZE. While sufficient for
single nexthops and small Equal-Cost Multi-Path groups, this fixed
allocation fails for large nexthop groups like 512 nexthops.

This results in the following warning splat:

 WARNING: net/ipv4/nexthop.c:3395 at rtm_get_nexthop+0x176/0x1c0, CPU#20: rep/4608
 [...]
 RIP: 0010:rtm_get_nexthop (net/ipv4/nexthop.c:3395)
 [...]
 Call Trace:
  <TASK>
  rtnetlink_rcv_msg (net/core/rtnetlink.c:6989)
  netlink_rcv_skb (net/netlink/af_netlink.c:2550)
  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1344)
  netlink_sendmsg (net/netlink/af_netlink.c:1894)
  ____sys_sendmsg (net/socket.c:721 net/socket.c:736 net/socket.c:2585)
  ___sys_sendmsg (net/socket.c:2641)
  __sys_sendmsg (net/socket.c:2671)
  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>

Fix this by allocating the size dynamically using nh_nlmsg_size() and
using nlmsg_new(), this is consistent with nexthop_notify() behavior. In
addition, adjust nh_nlmsg_size_grp() so it calculates the size needed
based on flags passed. While at it, also add the size of NHA_FDB for
nexthop group size calculation as it was missing too.

This cannot be reproduced via iproute2 as the group size is currently
limited and the command fails as follows:

addattr_l ERROR: message exceeded bound of 1048

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Closes: https://lore.kernel.org/netdev/CAL_bE8Li2h4KO+AQFXW4S6Yb_u5X4oSKnkywW+LPFjuErhqELA@mail.gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260402072613.25262-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index aa53a74ac2389..c958b8edfe540 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1006,16 +1006,32 @@ static size_t nh_nlmsg_size_grp_res(struct nh_group *nhg)
 		nla_total_size_64bit(8);/* NHA_RES_GROUP_UNBALANCED_TIME */
 }
 
-static size_t nh_nlmsg_size_grp(struct nexthop *nh)
+static size_t nh_nlmsg_size_grp(struct nexthop *nh, u32 op_flags)
 {
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 	size_t sz = sizeof(struct nexthop_grp) * nhg->num_nh;
 	size_t tot = nla_total_size(sz) +
-		nla_total_size(2); /* NHA_GROUP_TYPE */
+		nla_total_size(2) +	/* NHA_GROUP_TYPE */
+		nla_total_size(0);	/* NHA_FDB */
 
 	if (nhg->resilient)
 		tot += nh_nlmsg_size_grp_res(nhg);
 
+	if (op_flags & NHA_OP_FLAG_DUMP_STATS) {
+		tot += nla_total_size(0) +	  /* NHA_GROUP_STATS */
+		       nla_total_size(4);	  /* NHA_HW_STATS_ENABLE */
+		tot += nhg->num_nh *
+		       (nla_total_size(0) +	  /* NHA_GROUP_STATS_ENTRY */
+			nla_total_size(4) +	  /* NHA_GROUP_STATS_ENTRY_ID */
+			nla_total_size_64bit(8)); /* NHA_GROUP_STATS_ENTRY_PACKETS */
+
+		if (op_flags & NHA_OP_FLAG_DUMP_HW_STATS) {
+			tot += nhg->num_nh *
+			       nla_total_size_64bit(8); /* NHA_GROUP_STATS_ENTRY_PACKETS_HW */
+			tot += nla_total_size(4);	/* NHA_HW_STATS_USED */
+		}
+	}
+
 	return tot;
 }
 
@@ -1050,14 +1066,14 @@ static size_t nh_nlmsg_size_single(struct nexthop *nh)
 	return sz;
 }
 
-static size_t nh_nlmsg_size(struct nexthop *nh)
+static size_t nh_nlmsg_size(struct nexthop *nh, u32 op_flags)
 {
 	size_t sz = NLMSG_ALIGN(sizeof(struct nhmsg));
 
 	sz += nla_total_size(4); /* NHA_ID */
 
 	if (nh->is_group)
-		sz += nh_nlmsg_size_grp(nh) +
+		sz += nh_nlmsg_size_grp(nh, op_flags) +
 		      nla_total_size(4) +	/* NHA_OP_FLAGS */
 		      0;
 	else
@@ -1073,7 +1089,7 @@ static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(nh_nlmsg_size(nh), gfp_any());
+	skb = nlmsg_new(nh_nlmsg_size(nh, 0), gfp_any());
 	if (!skb)
 		goto errout;
 
@@ -3379,15 +3395,15 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = -ENOBUFS;
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb)
-		goto out;
-
 	err = -ENOENT;
 	nh = nexthop_find_by_id(net, id);
 	if (!nh)
-		goto errout_free;
+		goto out;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(nh_nlmsg_size(nh, op_flags), GFP_KERNEL);
+	if (!skb)
+		goto out;
 
 	err = nh_fill_node(skb, nh, RTM_NEWNEXTHOP, NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0, op_flags);
-- 
2.53.0



