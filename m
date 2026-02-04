Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E441C2E4;
	Wed,  4 Feb 2026 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216904; cv=none; b=K1lm6XtT03h2rRvWqwcHKDKnaCGqRz3It4E3y7SCvz+fW7IMDpEEwXgRPVraTl7dAwcOX/vJZeFUKrx45sgmi5K7ExJc7/WYtyrt1EaCO9itT8CDBpQiWzXMmtvvl6eZJqOoot0SSqpRLWHYtKrOpobYPqNnsKfuOuaEbHTlj20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216904; c=relaxed/simple;
	bh=cvhIcxjnubwmnqAV0/C6PGgn6ubJprMcofkHk+q7Kio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb8k6tWZUf3mpKu0R0YkKpxp85AYsV8ZzHOQEFsvDqzRCvajp2bmrkW7hwaZrAn5dTuK3QkctfpQWGWfu4Q4A4l3H25Tmb+aTZALMtOWhvMkangWpx+h4pZjFuVhbtFXPojq0tIzZP6AdQgHFm8spkyRKyPb/L5y5ztYNd/NciA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOhz92NO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOhz92NO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B0FC4CEF7;
	Wed,  4 Feb 2026 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216904;
	bh=cvhIcxjnubwmnqAV0/C6PGgn6ubJprMcofkHk+q7Kio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOhz92NOrP/kgByn7wjz4D2SFRCeV5Xk1glQQRl2rqfetbSVzQqc3TFlF9ApnA1pQ
	 g2C3owJbFCpeu7AspRj7iuc8usNVWtSnLqc+/jomVAXo6x8sVasMK9D9HKCrzt1Ix1
	 0RynAJFvO38nCYxqoiG4DUMiIn8LdPYWMm3vsbMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c081b17773615f24672@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/206] bonding: limit BOND_MODE_8023AD to Ethernet devices
Date: Wed,  4 Feb 2026 15:38:18 +0100
Message-ID: <20260204143900.627093511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c84fcb79e5dbde0b8d5aeeaf04282d2149aebcf6 ]

BOND_MODE_8023AD makes sense for ARPHRD_ETHER only.

syzbot reported:

 BUG: KASAN: global-out-of-bounds in __hw_addr_create net/core/dev_addr_lists.c:63 [inline]
 BUG: KASAN: global-out-of-bounds in __hw_addr_add_ex+0x25d/0x760 net/core/dev_addr_lists.c:118
Read of size 16 at addr ffffffff8bf94040 by task syz.1.3580/19497

CPU: 1 UID: 0 PID: 19497 Comm: syz.1.3580 Tainted: G             L      syzkaller #0 PREEMPT(full)
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
  print_address_description mm/kasan/report.c:378 [inline]
  print_report+0xca/0x240 mm/kasan/report.c:482
  kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
  kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
  __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
  __hw_addr_create net/core/dev_addr_lists.c:63 [inline]
  __hw_addr_add_ex+0x25d/0x760 net/core/dev_addr_lists.c:118
  __dev_mc_add net/core/dev_addr_lists.c:868 [inline]
  dev_mc_add+0xa1/0x120 net/core/dev_addr_lists.c:886
  bond_enslave+0x2b8b/0x3ac0 drivers/net/bonding/bond_main.c:2180
  do_set_master+0x533/0x6d0 net/core/rtnetlink.c:2963
  do_setlink+0xcf0/0x41c0 net/core/rtnetlink.c:3165
  rtnl_changelink net/core/rtnetlink.c:3776 [inline]
  __rtnl_newlink net/core/rtnetlink.c:3935 [inline]
  rtnl_newlink+0x161c/0x1c90 net/core/rtnetlink.c:4072
  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6958
  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
  sock_sendmsg_nosec net/socket.c:727 [inline]
  __sock_sendmsg+0x21c/0x270 net/socket.c:742
  ____sys_sendmsg+0x505/0x820 net/socket.c:2592
  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2646
  __sys_sendmsg+0x164/0x220 net/socket.c:2678
  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
  __do_fast_syscall_32+0x1dc/0x560 arch/x86/entry/syscall_32.c:307
  do_fast_syscall_32+0x34/0x80 arch/x86/entry/syscall_32.c:332
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
 </TASK>

The buggy address belongs to the variable:
 lacpdu_mcast_addr+0x0/0x40

Fixes: 872254dd6b1f ("net/bonding: Enable bonding to enslave non ARPHRD_ETHER")
Reported-by: syzbot+9c081b17773615f24672@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6966946b.a70a0220.245e30.0002.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260113191201.3970737-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3fae636eb9ddd..86be928b210a2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1836,6 +1836,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	 */
 	if (!bond_has_slaves(bond)) {
 		if (bond_dev->type != slave_dev->type) {
+			if (slave_dev->type != ARPHRD_ETHER &&
+			    BOND_MODE(bond) == BOND_MODE_8023AD) {
+				SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+					     "8023AD mode requires Ethernet devices");
+				return -EINVAL;
+			}
 			slave_dbg(bond_dev, slave_dev, "change device type from %d to %d\n",
 				  bond_dev->type, slave_dev->type);
 
-- 
2.51.0



