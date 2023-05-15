Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6072FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210ECC433EF;
	Mon, 15 May 2023 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170270;
	bh=WQa5sOYdTrRKzNJUG4rsU3bj55qdENHExxL5L6pgAF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTYJESrA18P1taRpTogPOH8lCxKG1o9O+2dZ/WgrM/h4Tat7aLV2zsiy1KXj0CYEG
	 aKI8DKkPXR0u/mr4nkB1ch3eWFBQ0M2sgckCZt/R7JrgWXMTBKBGal4R5uLUzPAQ3e
	 EdHr5RXyirsRYDC6lkHQkBzwpiEvhBvZwvWilI7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com
Subject: [PATCH 6.1 077/239] ethtool: Fix uninitialized number of lanes
Date: Mon, 15 May 2023 18:25:40 +0200
Message-Id: <20230515161723.995097214@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 9ad685dbfe7e856bbf17a7177b64676d324d6ed7 ]

It is not possible to set the number of lanes when setting link modes
using the legacy IOCTL ethtool interface. Since 'struct
ethtool_link_ksettings' is not initialized in this path, drivers receive
an uninitialized number of lanes in 'struct
ethtool_link_ksettings::lanes'.

When this information is later queried from drivers, it results in the
ethtool code making decisions based on uninitialized memory, leading to
the following KMSAN splat [1]. In practice, this most likely only
happens with the tun driver that simply returns whatever it got in the
set operation.

As far as I can tell, this uninitialized memory is not leaked to user
space thanks to the 'ethtool_ops->cap_link_lanes_supported' check in
linkmodes_prepare_data().

Fix by initializing the structure in the IOCTL path. Did not find any
more call sites that pass an uninitialized structure when calling
'ethtool_ops::set_link_ksettings()'.

[1]
BUG: KMSAN: uninit-value in ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
BUG: KMSAN: uninit-value in ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
 ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
 ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
 ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
 genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
 __sys_sendmsg net/socket.c:2584 [inline]
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 tun_get_link_ksettings+0x37/0x60 drivers/net/tun.c:3544
 __ethtool_get_link_ksettings+0x17b/0x260 net/ethtool/ioctl.c:441
 ethnl_set_linkmodes+0xee/0x19d0 net/ethtool/linkmodes.c:327
 ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
 genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
 __sys_sendmsg net/socket.c:2584 [inline]
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 tun_set_link_ksettings+0x37/0x60 drivers/net/tun.c:3553
 ethtool_set_link_ksettings+0x600/0x690 net/ethtool/ioctl.c:609
 __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
 dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
 dev_ioctl+0xb07/0x1270 net/core/dev_ioctl.c:524
 sock_do_ioctl+0x295/0x540 net/socket.c:1213
 sock_ioctl+0x729/0xd90 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x222/0x400 fs/ioctl.c:856
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Local variable link_ksettings created at:
 ethtool_set_link_ksettings+0x54/0x690 net/ethtool/ioctl.c:577
 __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
 dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078

Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
Reported-and-tested-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com
Link: https://lore.kernel.org/netdev/0000000000004bb41105fa70f361@google.com/
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 038398d41a937..940c0e27be735 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -580,8 +580,8 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 static int ethtool_set_link_ksettings(struct net_device *dev,
 				      void __user *useraddr)
 {
+	struct ethtool_link_ksettings link_ksettings = {};
 	int err;
-	struct ethtool_link_ksettings link_ksettings;
 
 	ASSERT_RTNL();
 
-- 
2.39.2



