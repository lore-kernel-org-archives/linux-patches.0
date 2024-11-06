Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19851E04A6;
	Wed,  6 Nov 2024 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896974; cv=none; b=UfcONHQv18c7+wsirEIO3TjJNwNrpXSFEu3PEDZ6+bTrq6pLf3Sxyb+4ZIP4ZrdcgATWJ12m5wJNaMIU+uPtuXN/0viDFYC5palHm3sE792cFJ71a7FsjndqXX/r7bHE+vvTFTQs18VRST57rw/xi5J4xiUn6ROhJNSa6sJQFG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896974; c=relaxed/simple;
	bh=K8POy4QKFwdC/B5pphEpeP0UT5BrgjQEqgDXnKFxJYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6jHgnUFdkOFGDq3uLwJQz6bM2ZIInqxIxlvaPx1GjcQJiEuCxibccbM8li0gB0xzI7gP7ikgU+v9qGEd9LD79U5bR67C+W79aRhjnjLrp/R4hQjyDw1HhZDFRUlTOimmeVbxLVDYooFOih9HvpxfVA8UBfe4a/Bq7AUp2WpH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRK7TLDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRK7TLDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE09AC4CED4;
	Wed,  6 Nov 2024 12:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896974;
	bh=K8POy4QKFwdC/B5pphEpeP0UT5BrgjQEqgDXnKFxJYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRK7TLDgJQ2vrSD5H5mCQUQyZu2Fsucy5+AmCdiwWG/rTvZsDXEpHaYmTTOxAv780
	 oBCIhI25FojodwKqLROYoGD/6C6Q/Wv0Jn6OMGrh+U8KZ8oEKnZgN/hG+K3fY6fT8m
	 iLjS+8/3BbfttRxhH3ukf13g/ZXCMUsbm2czvmbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/126] ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()
Date: Wed,  6 Nov 2024 13:03:45 +0100
Message-ID: <20241106120306.751314841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit ad4a3ca6a8e886f6491910a3ae5d53595e40597d ]

There are code paths from which the function is called without holding
the RCU read lock, resulting in a suspicious RCU usage warning [1].

Fix by using l3mdev_master_upper_ifindex_by_index() which will acquire
the RCU read lock before calling
l3mdev_master_upper_ifindex_by_index_rcu().

[1]
WARNING: suspicious RCU usage
6.12.0-rc3-custom-gac8f72681cf2 #141 Not tainted
-----------------------------
net/core/dev.c:876 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/361:
 #0: ffffffff86fc7cb0 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x377/0xf60

stack backtrace:
CPU: 3 UID: 0 PID: 361 Comm: ip Not tainted 6.12.0-rc3-custom-gac8f72681cf2 #141
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 <TASK>
 dump_stack_lvl+0xba/0x110
 lockdep_rcu_suspicious.cold+0x4f/0xd6
 dev_get_by_index_rcu+0x1d3/0x210
 l3mdev_master_upper_ifindex_by_index_rcu+0x2b/0xf0
 ip_tunnel_bind_dev+0x72f/0xa00
 ip_tunnel_newlink+0x368/0x7a0
 ipgre_newlink+0x14c/0x170
 __rtnl_newlink+0x1173/0x19c0
 rtnl_newlink+0x6c/0xa0
 rtnetlink_rcv_msg+0x3cc/0xf60
 netlink_rcv_skb+0x171/0x450
 netlink_unicast+0x539/0x7f0
 netlink_sendmsg+0x8c1/0xd80
 ____sys_sendmsg+0x8f9/0xc20
 ___sys_sendmsg+0x197/0x1e0
 __sys_sendmsg+0x122/0x1f0
 do_syscall_64+0xbb/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: db53cd3d88dc ("net: Handle l3mdev in ip_tunnel_init_flow")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20241022063822.462057-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_tunnels.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 0cc077c3dda30..f1ba369306fee 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -252,7 +252,7 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 	memset(fl4, 0, sizeof(*fl4));
 
 	if (oif) {
-		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index_rcu(net, oif);
+		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index(net, oif);
 		/* Legacy VRF/l3mdev use case */
 		fl4->flowi4_oif = fl4->flowi4_l3mdev ? 0 : oif;
 	}
-- 
2.43.0



