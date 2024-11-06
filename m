Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B1F1EF0A7;
	Wed,  6 Nov 2024 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897355; cv=none; b=qfol26imEaIp+57LC4Y46Pf9Ylse1anFQGBzCmRDnSTI7Czwg8w93gTxP7yboztNNDzZOjJY8EYcxLZKrLK6IZLpnjjHbtBWLN07lpIY9tJTSn1RrO2wo9v5XxpLDnFakgAqs9oQYoBust/fb283ucE9X5LlGNMCAyv7ZSu3rOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897355; c=relaxed/simple;
	bh=ij0VwgjoEhDmc/nw2aUWkdFfdzjBCvSY/JMwTRdee1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch4e8+hnsLKco1JLwtIouw3AZRI/5hf1ZGHLlkVmPU9x8h3CxOpWv7eCWmCN1sFjTR0d+od93MeVqmPNDIJc2OZ38/iw8NtOcqDp4EcJCrXvwKOHmP00By4ut9Nvxc9RKLhwp5107iMXnw9KKBQescpgIp7B0P5UuFI6OirDQzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpVtNsXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpVtNsXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18709C4CECD;
	Wed,  6 Nov 2024 12:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897355;
	bh=ij0VwgjoEhDmc/nw2aUWkdFfdzjBCvSY/JMwTRdee1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpVtNsXnXY0LCF1UK+iJ+W0OpQD8nN48YgJ8V6sK2mbkLgp5d33uvCoQtEYV8QRH8
	 4zf/quG0xlpwbNndE3GBq954x51RtcGJkDN1PmDPAmn5koFTiFg0ISwwKQvu4orTpS
	 2uqyZH9GjdDeTxMWpW00Kos8JZQ98Xp72rsBSLmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/151] ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()
Date: Wed,  6 Nov 2024 13:03:33 +0100
Message-ID: <20241106120309.523473521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4e69f52a51177..006a61ddd36fa 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -260,7 +260,7 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 	memset(fl4, 0, sizeof(*fl4));
 
 	if (oif) {
-		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index_rcu(net, oif);
+		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index(net, oif);
 		/* Legacy VRF/l3mdev use case */
 		fl4->flowi4_oif = fl4->flowi4_l3mdev ? 0 : oif;
 	}
-- 
2.43.0



