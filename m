Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64DA18E36C;
	Mon, 28 Oct 2024 06:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097360; cv=none; b=ToBVDPxmdUGDzWNV18F7EXZxMKvRtNZNiDU4yfbsU+yl0FEyuNp/fpJ80KFPIOfr+NSIt2Ct5ka3V80T3VpP3FpG/3GWdRXH3yvK4U2+Qu4cGKP69Vm/EHTVJS9eWVIUrOIWW0qyU8jq4e75lI5YjvocGO/ZTNFuZoKqmZ/i3Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097360; c=relaxed/simple;
	bh=X6XZMdFObLAIvIdjs7smjcwfXFxyToMMH9IZe6hLUPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBLv0oI0AqKGqubIN546dJ1zjCu9lCRzq/LbHtcbJ8+AzLPWtqGeDf/o1ZVNbd9Q5TZwcLBWfI6gL7YC0ohgkXm6g6kBIeJCr8RC9NOWzNUEPV6Div4iJkyMAmStlCK/aAfTPnEgAXiCxmm8TbyQJkrlqQeG+pOIpKel2RsGcFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEp+EgG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEp+EgG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBD5C4CEC3;
	Mon, 28 Oct 2024 06:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097359;
	bh=X6XZMdFObLAIvIdjs7smjcwfXFxyToMMH9IZe6hLUPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEp+EgG7VMEIwedpTzJRlzL3zUPRW9iFNq3kcHrLKvQYe5kHjNakrOWOVS6ebl5EL
	 XNLulo3rraQcdXDrlgmdm1DlAnly0sC9FZUKZyzdL1rCbnMqzvNVCEI7dxNllpknJO
	 lW+KcaHSjxuUXRnBlkITCRFDs3AtmGqEvNgh9WJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Loic Poulain <loic.poulain@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/137] net: wwan: fix global oob in wwan_rtnl_policy
Date: Mon, 28 Oct 2024 07:25:32 +0100
Message-ID: <20241028062301.383159343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 47dd5447cab8ce30a847a0337d5341ae4c7476a7 ]

The variable wwan_rtnl_link_ops assign a *bigger* maxtype which leads to
a global out-of-bounds read when parsing the netlink attributes. Exactly
same bug cause as the oob fixed in commit b33fb5b801c6 ("net: qualcomm:
rmnet: fix global oob in rmnet_policy").

==================================================================
BUG: KASAN: global-out-of-bounds in validate_nla lib/nlattr.c:388 [inline]
BUG: KASAN: global-out-of-bounds in __nla_validate_parse+0x19d7/0x29a0 lib/nlattr.c:603
Read of size 1 at addr ffffffff8b09cb60 by task syz.1.66276/323862

CPU: 0 PID: 323862 Comm: syz.1.66276 Not tainted 6.1.70 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x177/0x231 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x14f/0x750 mm/kasan/report.c:395
 kasan_report+0x139/0x170 mm/kasan/report.c:495
 validate_nla lib/nlattr.c:388 [inline]
 __nla_validate_parse+0x19d7/0x29a0 lib/nlattr.c:603
 __nla_parse+0x3c/0x50 lib/nlattr.c:700
 nla_parse_nested_deprecated include/net/netlink.h:1269 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3514 [inline]
 rtnl_newlink+0x7bc/0x1fd0 net/core/rtnetlink.c:3623
 rtnetlink_rcv_msg+0x794/0xef0 net/core/rtnetlink.c:6122
 netlink_rcv_skb+0x1de/0x420 net/netlink/af_netlink.c:2508
 netlink_unicast_kernel net/netlink/af_netlink.c:1326 [inline]
 netlink_unicast+0x74b/0x8c0 net/netlink/af_netlink.c:1352
 netlink_sendmsg+0x882/0xb90 net/netlink/af_netlink.c:1874
 sock_sendmsg_nosec net/socket.c:716 [inline]
 __sock_sendmsg net/socket.c:728 [inline]
 ____sys_sendmsg+0x5cc/0x8f0 net/socket.c:2499
 ___sys_sendmsg+0x21c/0x290 net/socket.c:2553
 __sys_sendmsg net/socket.c:2582 [inline]
 __do_sys_sendmsg net/socket.c:2591 [inline]
 __se_sys_sendmsg+0x19e/0x270 net/socket.c:2589
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x45/0x90 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f67b19a24ad
RSP: 002b:00007f67b17febb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f67b1b45f80 RCX: 00007f67b19a24ad
RDX: 0000000000000000 RSI: 0000000020005e40 RDI: 0000000000000004
RBP: 00007f67b1a1e01d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd2513764f R14: 00007ffd251376e0 R15: 00007f67b17fed40
 </TASK>

The buggy address belongs to the variable:
 wwan_rtnl_policy+0x20/0x40

The buggy address belongs to the physical page:
page:ffffea00002c2700 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xb09c
flags: 0xfff00000001000(reserved|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000001000 ffffea00002c2708 ffffea00002c2708 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffffffff8b09ca00: 05 f9 f9 f9 05 f9 f9 f9 00 01 f9 f9 00 01 f9 f9
 ffffffff8b09ca80: 00 00 00 05 f9 f9 f9 f9 00 00 03 f9 f9 f9 f9 f9
>ffffffff8b09cb00: 00 00 00 00 05 f9 f9 f9 00 00 00 00 f9 f9 f9 f9
                                                       ^
 ffffffff8b09cb80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

According to the comment of `nla_parse_nested_deprecated`, use correct size
`IFLA_WWAN_MAX` here to fix this issue.

Fixes: 88b710532e53 ("wwan: add interface creation support")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241015131621.47503-1-linma@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/wwan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 62e9f7d6c9fe9..7089cb103885d 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -994,7 +994,7 @@ static const struct nla_policy wwan_rtnl_policy[IFLA_WWAN_MAX + 1] = {
 
 static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
 	.kind = "wwan",
-	.maxtype = __IFLA_WWAN_MAX,
+	.maxtype = IFLA_WWAN_MAX,
 	.alloc = wwan_rtnl_alloc,
 	.validate = wwan_rtnl_validate,
 	.newlink = wwan_rtnl_newlink,
-- 
2.43.0



