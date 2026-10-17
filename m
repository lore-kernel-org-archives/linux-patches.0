Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A23D45DE;
	Sat, 17 Oct 2026 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258417; cv=none; b=tDgtD+fFKgzWSJJ0n4N26lCiHBusurS03dpZ0dJ/nlTqOc9VCeWWYXKrbkuUUhFIbaocw6gKWuE6RPfzSuBLjeoCxsJ9tuIxVXzSTVLOIFhNP7UzB7o13DH/EZJELDstI6OQvFhlhfK0l3xL0iJ19TlU5uhNurWPiOtJ1DE7xm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258417; c=relaxed/simple;
	bh=mfk42Y2XQskW4ou7MF9fKXJYcMGWRkYELaid7I9Acbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIuedyHhaJr1CMI4bM4CtDTLPkXhEQgO8s6WOy3knpw4RF7TndzPjqXMauJrVdjaeYhj+FMN2YnOk4LH7YykvMN31PfBBbhhtODevesveJ9sdY7cHKgg7OpurNaa6irqFO7F+lYVIUDzx1gBcry0tR9E5wacxsNehEvhxI2Vh9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjkG93o4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjkG93o4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D7F1F000C4;
	Sat, 17 Oct 2026 17:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258415;
	bh=yvYCNkXncvYIFyErWXG8pZ43oBzytUSEl6Hm2Ii4PxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjkG93o4/3dDzf2vQtuRgAc++TmX/CbhTThQBLxdX8FAYPziFsAGPBOkp6BPKUjAI
	 n9fsQCEjiMEUbeVleh/oV8HOmgy3f7rHUffGfhzy6j66PKxw+5srBS8Z4ArkCIbS6R
	 oG134TUbzUtTHcuijk+kfeN+nTwoGDVAfPXHh9pg=
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
Subject: [PATCH 6.6 0876/1674] ipv4: nexthop: allocate skb dynamically in rtm_get_nexthop()
Date: Sat, 17 Oct 2026 17:52:28 +0200
Message-ID: <20261017160453.599685508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 net/ipv4/nexthop.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index dbb12e9d0b48f..16a90d88940cb 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -790,7 +790,8 @@ static size_t nh_nlmsg_size_grp(struct nexthop *nh)
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 	size_t sz = sizeof(struct nexthop_grp) * nhg->num_nh;
 	size_t tot = nla_total_size(sz) +
-		nla_total_size(2); /* NHA_GROUP_TYPE */
+		nla_total_size(2) +	/* NHA_GROUP_TYPE */
+		nla_total_size(0);	/* NHA_FDB */
 
 	if (nhg->resilient)
 		tot += nh_nlmsg_size_grp_res(nhg);
@@ -3070,15 +3071,15 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
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
+	skb = nlmsg_new(nh_nlmsg_size(nh), GFP_KERNEL);
+	if (!skb)
+		goto out;
 
 	err = nh_fill_node(skb, nh, RTM_NEWNEXTHOP, NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0);
-- 
2.53.0



