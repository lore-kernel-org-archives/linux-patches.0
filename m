Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8A26560A;
	Wed, 25 Feb 2026 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983575; cv=none; b=iQTN34slGerY7hhcVZO9X+I5F/OW3M/pfN5NXMdo1H+Y2OVB1mPNZf6OKfSydFJQeSBrj92wgqME4Arhh1PFYF4kFnqLzg27R53hUDuBciL1dGjmXY+YYOYd5L93nDmdcyefDnBGrlL4sTvXGy5ADyMbw6H6yNqeeTQvhx1OSzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983575; c=relaxed/simple;
	bh=b3OhcQY6ULhoh8pGE1bXKzig1IzC/8CRHyFX6LdhkwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVTyWD7389m4q0tv4w8U4Ji05NSH35cSy4fh9OiFCMXU8/GRs3299oUS0qKoKa0a8gAKqtsTkHLTcfe3MSRxi9BAcv9ySuHJL7o5OgOxq/enExi98iEJ1qMOm93qzL9TiYCzL6yAIIIVIw0OtK7f87rxQ6YvexEr6VdbvScAKME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUGip3l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUGip3l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2701FC116D0;
	Wed, 25 Feb 2026 01:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983575;
	bh=b3OhcQY6ULhoh8pGE1bXKzig1IzC/8CRHyFX6LdhkwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUGip3l63j3EJ0I4en2PYrhhcbu1xT26mXWnO8PDkiGqIjV0ry5YvGewOjZrONdk5
	 zs0uddidy1KxxFvlHgtP9JW6x1mmDnKnxIENqz9YJdJJWVXLl+wT6/YqoTenlzEGx8
	 puos8NHTj+Z09pRl1qnBzyDzV6gPHzao4TyARaTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	valis <sec@valis.email>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 676/781] macvlan: observe an RCU grace period in macvlan_common_newlink() error path
Date: Tue, 24 Feb 2026 17:23:05 -0800
Message-ID: <20260225012416.359155403@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e3f000f0dee1bfab52e2e61ca6a3835d9e187e35 ]

valis reported that a race condition still happens after my prior patch.

macvlan_common_newlink() might have made @dev visible before
detecting an error, and its caller will directly call free_netdev(dev).

We must respect an RCU period, either in macvlan or the core networking
stack.

After adding a temporary mdelay(1000) in macvlan_forward_source_one()
to open the race window, valis repro was:

ip link add p1 type veth peer p2
ip link set address 00:00:00:00:00:20 dev p1
ip link set up dev p1
ip link set up dev p2
ip link add mv0 link p2 type macvlan mode source

(ip link add invalid% link p2 type macvlan mode source macaddr add
00:00:00:00:00:20 &) ; sleep 0.5 ; ping -c1 -I p1 1.2.3.4
PING 1.2.3.4 (1.2.3.4): 56 data bytes
RTNETLINK answers: Invalid argument

BUG: KASAN: slab-use-after-free in macvlan_forward_source
(drivers/net/macvlan.c:408 drivers/net/macvlan.c:444)
Read of size 8 at addr ffff888016bb89c0 by task e/175

CPU: 1 UID: 1000 PID: 175 Comm: e Not tainted 6.19.0-rc8+ #33 NONE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
<IRQ>
dump_stack_lvl (lib/dump_stack.c:123)
print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
? macvlan_forward_source (drivers/net/macvlan.c:408 drivers/net/macvlan.c:444)
kasan_report (mm/kasan/report.c:597)
? macvlan_forward_source (drivers/net/macvlan.c:408 drivers/net/macvlan.c:444)
macvlan_forward_source (drivers/net/macvlan.c:408 drivers/net/macvlan.c:444)
? tasklet_init (kernel/softirq.c:983)
macvlan_handle_frame (drivers/net/macvlan.c:501)

Allocated by task 169:
kasan_save_stack (mm/kasan/common.c:58)
kasan_save_track (./arch/x86/include/asm/current.h:25
mm/kasan/common.c:70 mm/kasan/common.c:79)
__kasan_kmalloc (mm/kasan/common.c:419)
__kvmalloc_node_noprof (./include/linux/kasan.h:263 mm/slub.c:5657
mm/slub.c:7140)
alloc_netdev_mqs (net/core/dev.c:12012)
rtnl_create_link (net/core/rtnetlink.c:3648)
rtnl_newlink (net/core/rtnetlink.c:3830 net/core/rtnetlink.c:3957
net/core/rtnetlink.c:4072)
rtnetlink_rcv_msg (net/core/rtnetlink.c:6958)
netlink_rcv_skb (net/netlink/af_netlink.c:2550)
netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1344)
netlink_sendmsg (net/netlink/af_netlink.c:1894)
__sys_sendto (net/socket.c:727 net/socket.c:742 net/socket.c:2206)
__x64_sys_sendto (net/socket.c:2209)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:131)

Freed by task 169:
kasan_save_stack (mm/kasan/common.c:58)
kasan_save_track (./arch/x86/include/asm/current.h:25
mm/kasan/common.c:70 mm/kasan/common.c:79)
kasan_save_free_info (mm/kasan/generic.c:587)
__kasan_slab_free (mm/kasan/common.c:287)
kfree (mm/slub.c:6674 mm/slub.c:6882)
rtnl_newlink (net/core/rtnetlink.c:3845 net/core/rtnetlink.c:3957
net/core/rtnetlink.c:4072)
rtnetlink_rcv_msg (net/core/rtnetlink.c:6958)
netlink_rcv_skb (net/netlink/af_netlink.c:2550)
netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1344)
netlink_sendmsg (net/netlink/af_netlink.c:1894)
__sys_sendto (net/socket.c:727 net/socket.c:742 net/socket.c:2206)
__x64_sys_sendto (net/socket.c:2209)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:131)

Fixes: f8db6475a836 ("macvlan: fix error recovery in macvlan_common_newlink()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: valis <sec@valis.email>
Link: https://patch.msgid.link/20260213142557.3059043-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c509228be84d1..4433b8e95b6ac 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1572,6 +1572,11 @@ int macvlan_common_newlink(struct net_device *dev,
 		if (create)
 			macvlan_port_destroy(port->dev);
 	}
+	/* @dev might have been made visible before an error was detected.
+	 * Make sure to observe an RCU grace period before our caller
+	 * (rtnl_newlink()) frees it.
+	 */
+	synchronize_net();
 	return err;
 }
 EXPORT_SYMBOL_GPL(macvlan_common_newlink);
-- 
2.51.0



