Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D71E0091;
	Wed,  6 Nov 2024 12:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895939; cv=none; b=TPzjtmOPultJfVMn2d6wzyz0VNySskMzgYLeZv6wUpY2jF+dMvG33jemzYb5P1lLhlYZSBADC9ldKy/vMIiTgj2OSAolL52WhkAns/BEwg7ZpOq0+YtpKN/XWMv6pIoNkyGEy32Clq1DpcKl6zuyPtoejxNw1FE6FiWWLoOHgvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895939; c=relaxed/simple;
	bh=jTsI71qFIjpYODNyqXNRVy6XesB/fd78E6sH5n8i0FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzQmQj7ZXk/NfKDzcIo6Uhyuj0aqX38ca2E038NDEvs3bXVCjDYuStAqgjfcovR9o5l3P+zBLpp0apnqe5dle/W1mV9GUGGywyppkX17glF5i5Ti83ObY11cwAloWD422ib29cwbO0YEQMHLYIOt+TdkiYXIeWt40Ab8OQSU2UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6ge5/2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6ge5/2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD38CC4CECD;
	Wed,  6 Nov 2024 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895939;
	bh=jTsI71qFIjpYODNyqXNRVy6XesB/fd78E6sH5n8i0FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6ge5/2u2dCy/cuvMkGhs/996EX0RsfgcTssuQ10gTHl9i3nCIbg1T0O00p/bSh4O
	 Fyw1YfV8ysE4BDiLwuMh3Y9QZxUz+tMU+XeIOc5FxSRZx4po5ae63f+QJc38TtFJRC
	 WdOCRGB62Vjx/WgfkpzxpxKkmjx4koNH5EVEy71g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/245] ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()
Date: Wed,  6 Nov 2024 13:01:27 +0100
Message-ID: <20241106120320.066089488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1db2417b8ff52..35d1e09940b27 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -354,7 +354,7 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 	memset(fl4, 0, sizeof(*fl4));
 
 	if (oif) {
-		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index_rcu(net, oif);
+		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index(net, oif);
 		/* Legacy VRF/l3mdev use case */
 		fl4->flowi4_oif = fl4->flowi4_l3mdev ? 0 : oif;
 	}
-- 
2.43.0



