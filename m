Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E385D611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029E5C433C7;
	Mon, 28 Aug 2023 10:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219454;
	bh=MFTT5R5u/rNisn1JPmJcJgnd+MRRIvk8KHHgsHAK5po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EszN/Pc4ix1UCLUlTacOePyCHt9mbEif42/fwMdzZsvPTPk9MGZ79Dl+8bxsP79WG
	 v4NA/DZ6eBYEOntcJBWo9L3niPWzJwBQHV/bg9RWBJRw3OtxXexQ7obZlwN0PMQtz2
	 BRuJksX0IJ0ylC65B3cu0kfAliljbzC4NFAnI9SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5ba06978f34abb058571@syzkaller.appspotmail.com,
	Ido Schimmel <idosch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/89] rtnetlink: Reject negative ifindexes in RTM_NEWLINK
Date: Mon, 28 Aug 2023 12:13:42 +0200
Message-ID: <20230828101151.564388223@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 30188bd7838c16a98a520db1fe9df01ffc6ed368 ]

Negative ifindexes are illegal, but the kernel does not validate the
ifindex in the ancillary header of RTM_NEWLINK messages, resulting in
the kernel generating a warning [1] when such an ifindex is specified.

Fix by rejecting negative ifindexes.

[1]
WARNING: CPU: 0 PID: 5031 at net/core/dev.c:9593 dev_index_reserve+0x1a2/0x1c0 net/core/dev.c:9593
[...]
Call Trace:
 <TASK>
 register_netdevice+0x69a/0x1490 net/core/dev.c:10081
 br_dev_newlink+0x27/0x110 net/bridge/br_netlink.c:1552
 rtnl_newlink_create net/core/rtnetlink.c:3471 [inline]
 __rtnl_newlink+0x115e/0x18c0 net/core/rtnetlink.c:3688
 rtnl_newlink+0x67/0xa0 net/core/rtnetlink.c:3701
 rtnetlink_rcv_msg+0x439/0xd30 net/core/rtnetlink.c:6427
 netlink_rcv_skb+0x16b/0x440 net/netlink/af_netlink.c:2545
 netlink_unicast_kernel net/netlink/af_netlink.c:1342 [inline]
 netlink_unicast+0x536/0x810 net/netlink/af_netlink.c:1368
 netlink_sendmsg+0x93c/0xe40 net/netlink/af_netlink.c:1910
 sock_sendmsg_nosec net/socket.c:728 [inline]
 sock_sendmsg+0xd9/0x180 net/socket.c:751
 ____sys_sendmsg+0x6ac/0x940 net/socket.c:2538
 ___sys_sendmsg+0x135/0x1d0 net/socket.c:2592
 __sys_sendmsg+0x117/0x1e0 net/socket.c:2621
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 38f7b870d4a6 ("[RTNETLINK]: Link creation API")
Reported-by: syzbot+5ba06978f34abb058571@syzkaller.appspotmail.com
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230823064348.2252280-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7c1a2fd7d9532..1b71e5c582bbc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3318,6 +3318,9 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0) {
 		link_specified = true;
 		dev = __dev_get_by_index(net, ifm->ifi_index);
+	} else if (ifm->ifi_index < 0) {
+		NL_SET_ERR_MSG(extack, "ifindex can't be negative");
+		return -EINVAL;
 	} else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
 		link_specified = true;
 		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
-- 
2.40.1



