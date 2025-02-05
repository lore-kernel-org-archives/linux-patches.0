Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201897DA6A;
	Wed,  5 Feb 2025 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766117; cv=none; b=azFNK2IsCAD9ZI3iz2OvVwb1du4dUf5fYMRJUF9+RKchySuwmHs8CrKHxxHJS3CSU8WqwfgYqB2+fdFil3duA9kgt4Vbo46oD9ZCn6dif824FOH7vZc5TdAR8xTb6g0+1fC+Q2QbpE4SUclW71tEk1wSIsA69SDPzo2b43i8Mg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766117; c=relaxed/simple;
	bh=it1SmuCvVuRPAMoes0LUg2Cc1mo3Jt8N4mnUfel4Rl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao3JLXOMVnMKTaxVTIx2mnWHYCZxc3xCZPI1/VOT5qmpl07ZACRqy9Ecpn1C7Sxq5asJ11teldBYeHePO0lWE8AM3EfpgpV8o33Kq4q/D2GMOqeB8RlZry+c3ESeMYA69F6+MBrU3hQc4KUdVapRGfsF7ixgpfYGsNMRknvLPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGgALva6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGgALva6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2D7C4CED1;
	Wed,  5 Feb 2025 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766117;
	bh=it1SmuCvVuRPAMoes0LUg2Cc1mo3Jt8N4mnUfel4Rl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGgALva6DS0m7JaUTnH9LDBLzkUYMcNxQ7saB18TZtI2Kl8xAvzZUpyHCwG8ZOGwD
	 YLnivSpt1zmJzzeGATOTEVv+GqJiGL/2CR1nr0cHBWBJrDonU7RDzyfyMe8ADGQrKJ
	 f137m/AABsl2eboaqEYnAW1F7/4memCJLqaeF8Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 331/393] vxlan: Fix uninit-value in vxlan_vnifilter_dump()
Date: Wed,  5 Feb 2025 14:44:10 +0100
Message-ID: <20250205134432.978591444@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 5066293b9b7046a906eff60e3949a887ae185a43 ]

KMSAN reported an uninit-value access in vxlan_vnifilter_dump() [1].

If the length of the netlink message payload is less than
sizeof(struct tunnel_msg), vxlan_vnifilter_dump() accesses bytes
beyond the message. This can lead to uninit-value access. Fix this by
returning an error in such situations.

[1]
BUG: KMSAN: uninit-value in vxlan_vnifilter_dump+0x328/0x920 drivers/net/vxlan/vxlan_vnifilter.c:422
 vxlan_vnifilter_dump+0x328/0x920 drivers/net/vxlan/vxlan_vnifilter.c:422
 rtnl_dumpit+0xd5/0x2f0 net/core/rtnetlink.c:6786
 netlink_dump+0x93e/0x15f0 net/netlink/af_netlink.c:2317
 __netlink_dump_start+0x716/0xd60 net/netlink/af_netlink.c:2432
 netlink_dump_start include/linux/netlink.h:340 [inline]
 rtnetlink_dump_start net/core/rtnetlink.c:6815 [inline]
 rtnetlink_rcv_msg+0x1256/0x14a0 net/core/rtnetlink.c:6882
 netlink_rcv_skb+0x467/0x660 net/netlink/af_netlink.c:2542
 rtnetlink_rcv+0x35/0x40 net/core/rtnetlink.c:6944
 netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
 netlink_unicast+0xed6/0x1290 net/netlink/af_netlink.c:1347
 netlink_sendmsg+0x1092/0x1230 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x330/0x3d0 net/socket.c:726
 ____sys_sendmsg+0x7f4/0xb50 net/socket.c:2583
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2637
 __sys_sendmsg net/socket.c:2669 [inline]
 __do_sys_sendmsg net/socket.c:2674 [inline]
 __se_sys_sendmsg net/socket.c:2672 [inline]
 __x64_sys_sendmsg+0x211/0x3e0 net/socket.c:2672
 x64_sys_call+0x3878/0x3d90 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd9/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4110 [inline]
 slab_alloc_node mm/slub.c:4153 [inline]
 kmem_cache_alloc_node_noprof+0x800/0xe80 mm/slub.c:4205
 kmalloc_reserve+0x13b/0x4b0 net/core/skbuff.c:587
 __alloc_skb+0x347/0x7d0 net/core/skbuff.c:678
 alloc_skb include/linux/skbuff.h:1323 [inline]
 netlink_alloc_large_skb+0xa5/0x280 net/netlink/af_netlink.c:1196
 netlink_sendmsg+0xac9/0x1230 net/netlink/af_netlink.c:1866
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x330/0x3d0 net/socket.c:726
 ____sys_sendmsg+0x7f4/0xb50 net/socket.c:2583
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2637
 __sys_sendmsg net/socket.c:2669 [inline]
 __do_sys_sendmsg net/socket.c:2674 [inline]
 __se_sys_sendmsg net/socket.c:2672 [inline]
 __x64_sys_sendmsg+0x211/0x3e0 net/socket.c:2672
 x64_sys_call+0x3878/0x3d90 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd9/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 30991 Comm: syz.4.10630 Not tainted 6.12.0-10694-gc44daa7e3c73 #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-3.fc41 04/01/2014

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250123145746.785768-1-syoshida@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index d2023e7131bd4..6e6e9f05509ab 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -411,6 +411,11 @@ static int vxlan_vnifilter_dump(struct sk_buff *skb, struct netlink_callback *cb
 	struct tunnel_msg *tmsg;
 	struct net_device *dev;
 
+	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(struct tunnel_msg))) {
+		NL_SET_ERR_MSG(cb->extack, "Invalid msg length");
+		return -EINVAL;
+	}
+
 	tmsg = nlmsg_data(cb->nlh);
 
 	if (tmsg->flags & ~TUNNEL_MSG_VALID_USER_FLAGS) {
-- 
2.39.5



