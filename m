Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48C74F85BC;
	Tue, 13 Oct 2026 12:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893761; cv=none; b=jdTvJ7/3Ff19LxF1klWMod1l3Cq3HuTScxBurCM/4p0zfQJfixraIAqrEQvp0R9/gMM1v636k4k5ut6IudJajZ1lmQJxJwDvmTtGVj3dab2xFCzwnkQyQp/5Rf6iopA1Q6FRMBSJgu6Xt7wBTbtvwisRS0HvtWCN6Mq9ML3yQcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893761; c=relaxed/simple;
	bh=uMGiJ316hAVEq0zjaK/r2DHahg51DgVnoiB7FUBI6a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXSVg+QGRQrl/jh8rpkEZ7iXJkSnnXyAqoOfioTkvBeXGL3dUmMdqOp3vj3Q6onRvIWJLxYnr+fLE7XzCi/NYoUj/aiLk6G5DjZKz/Q7j7OHxWijo21GTsloXDv/SH9EXRT+QSdLjvAlRmh/rEKT56a8YmSe8MAT/Cc57nlIIn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZkDvP+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZkDvP+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D98B1F000FF;
	Tue, 13 Oct 2026 12:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893758;
	bh=gW63FK51mUVRttx8itfHAtDgCTPj6tExyq/lOwVcWAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZkDvP+bRxBcz0ukZVWb8ozBHt9Y3ZAQ7X+30xThD8sJ8QGLue20eVC++UivuFr/H
	 1GXxQRy2neR2Dj9Bp8ePhWELZhitNPNb+o2QhlC8zMSG6h61JeGV5JGfwMcwwQLidF
	 hij01pBwcrlNa7heEgl5/CUDbB+Wx1fpVPZv77lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 332/621] nexthop: take nh->lock for f6i_list walks in replace check and notify
Date: Tue, 13 Oct 2026 13:35:27 +0200
Message-ID: <20261013112928.731417305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 072cd1f21819dedd2252e704d255de3b0cfc61a7 ]

fib6_check_nh_list() and __nexthop_replace_notify() walk nh->f6i_list
during an RTNL-serialized nexthop replace without holding nh->lock. IPv6
RTM_NEWROUTE/RTM_DELROUTE run without RTNL and mutate that list under
nh->lock (fib6_add_rt2node_nh(), fib6_purge_rt()), so both walks race a
concurrent route delete that unlinks and frees a fib6_info:

  BUG: KASAN: slab-use-after-free in rt6_fill_node.isra.0 (net/ipv6/route.c:5799)
  Read of size 4 at addr ffff888014607e64 by task exploit/143
   rt6_fill_node.isra.0 (net/ipv6/route.c:5799)
   fib6_rt_update (net/ipv6/route.c:6412)
   __nexthop_replace_notify (net/ipv4/nexthop.c:2542)
   rtm_new_nexthop (net/ipv4/nexthop.c:2554)
   rtnetlink_rcv_msg (net/core/rtnetlink.c:7076)

  BUG: KASAN: slab-use-after-free in fib6_check_nh_list (net/ipv4/nexthop.c:1605)
  Read of size 8 at addr ffff888014a7d068 by task exploit/142
   fib6_check_nh_list (net/ipv4/nexthop.c:1605)
   rtm_new_nexthop (net/ipv4/nexthop.c:2575)
   rtnetlink_rcv_msg (net/core/rtnetlink.c:7076)

Both walks only read the entries and take no tb6_lock, so protect them
with nh->lock; fib6_rt_update() uses gfp_any(), which returns GFP_ATOMIC
under the lock.

Fixes: 081efd18326e ("ipv6: Protect nh->f6i_list with spinlock and flag.")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260722002951.2614721-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7adec5cc263e4..21bd8b66e2fe9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1600,14 +1600,21 @@ static int fib6_check_nh_list(struct nexthop *old, struct nexthop *new,
 			      struct netlink_ext_ack *extack)
 {
 	struct fib6_info *f6i;
+	int err = 0;
 
 	if (list_empty(&old->f6i_list))
 		return 0;
 
+	spin_lock_bh(&old->lock);
 	list_for_each_entry(f6i, &old->f6i_list, nh_list) {
-		if (check_src_addr(&f6i->fib6_src.addr, extack) < 0)
-			return -EINVAL;
+		err = check_src_addr(&f6i->fib6_src.addr, extack);
+		if (err)
+			break;
 	}
+	spin_unlock_bh(&old->lock);
+
+	if (err)
+		return err;
 
 	return fib6_check_nexthop(new, NULL, extack);
 }
@@ -2524,8 +2531,10 @@ static void __nexthop_replace_notify(struct net *net, struct nexthop *nh,
 			fi->nh_updated = false;
 	}
 
+	spin_lock_bh(&nh->lock);
 	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
 		ipv6_stub->fib6_rt_update(net, f6i, info);
+	spin_unlock_bh(&nh->lock);
 }
 
 /* send RTM_NEWROUTE with REPLACE flag set for all FIB entries
-- 
2.53.0



