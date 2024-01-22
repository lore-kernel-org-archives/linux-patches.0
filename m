Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F595732C;
	Tue, 23 Jan 2024 00:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970145; cv=none; b=JGts6lyosFkXuWl7AQYL9LlAPWHIXiGpr9X82+z36hfVadp/nDt5YnPFUbyq77nBRfrYwxb4ORTRyLLYhIqWANePwiYi4dvJNlcnxPbcbJFKKa1z3b7wokPx5rKWNj9xDrKvzkmg1ob15luMM+g9ox6Z5MVp3w2UrTBA4yHzI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970145; c=relaxed/simple;
	bh=N8IdZHxITNZv/CTh7pjYndSCQnqWlLhYzt9S9elaI40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z596ebEJX/84dfpBJHK3cOMUfZr/AzNdDD/j63btb+2f9ahDcHT1+0x9kKDchHIzHknqJoosY8cdTTdD1A4AFzGFDWrooxiot9dW9QvSWvPiLwJ5YJL7DtUC8rGM+YbiFrdw4JT4sKRQ2MMZZnI/W0zwhttSgmvKiy4e3QmFjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXudrkas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXudrkas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C227C433F1;
	Tue, 23 Jan 2024 00:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970144;
	bh=N8IdZHxITNZv/CTh7pjYndSCQnqWlLhYzt9S9elaI40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXudrkasQPqfPcNU/tUhDuIprF3LqFndxfugjw5MdcTWctbTEjqDhB7hPnQHT753l
	 bsazkA0l67URNYj/pGfe3NC60pNU+t3YCCUSaQ0q+7AZs1Z+TaHDC9lTqUrumwXU4H
	 6zKcjeBUKdvIHDZjsAB/nQmzBvjJ4NHSKmy89eEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 581/641] net: qualcomm: rmnet: fix global oob in rmnet_policy
Date: Mon, 22 Jan 2024 15:58:05 -0800
Message-ID: <20240122235836.368860115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit b33fb5b801c6db408b774a68e7c8722796b59ecc ]

The variable rmnet_link_ops assign a *bigger* maxtype which leads to a
global out-of-bounds read when parsing the netlink attributes. See bug
trace below:

==================================================================
BUG: KASAN: global-out-of-bounds in validate_nla lib/nlattr.c:386 [inline]
BUG: KASAN: global-out-of-bounds in __nla_validate_parse+0x24af/0x2750 lib/nlattr.c:600
Read of size 1 at addr ffffffff92c438d0 by task syz-executor.6/84207

CPU: 0 PID: 84207 Comm: syz-executor.6 Tainted: G                 N 6.1.0 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x8b/0xb3 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x172/0x475 mm/kasan/report.c:395
 kasan_report+0xbb/0x1c0 mm/kasan/report.c:495
 validate_nla lib/nlattr.c:386 [inline]
 __nla_validate_parse+0x24af/0x2750 lib/nlattr.c:600
 __nla_parse+0x3e/0x50 lib/nlattr.c:697
 nla_parse_nested_deprecated include/net/netlink.h:1248 [inline]
 __rtnl_newlink+0x50a/0x1880 net/core/rtnetlink.c:3485
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3594
 rtnetlink_rcv_msg+0x43c/0xd70 net/core/rtnetlink.c:6091
 netlink_rcv_skb+0x14f/0x410 net/netlink/af_netlink.c:2540
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x54e/0x800 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x930/0xe50 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0x154/0x190 net/socket.c:734
 ____sys_sendmsg+0x6df/0x840 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fdcf2072359
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdcf13e3168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fdcf219ff80 RCX: 00007fdcf2072359
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007fdcf20bd493 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffbb8d7bdf R14: 00007fdcf13e3300 R15: 0000000000022000
 </TASK>

The buggy address belongs to the variable:
 rmnet_policy+0x30/0xe0

The buggy address belongs to the physical page:
page:0000000065bdeb3c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x155243
flags: 0x200000000001000(reserved|node=0|zone=2)
raw: 0200000000001000 ffffea00055490c8 ffffea00055490c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffffffff92c43780: f9 f9 f9 f9 00 00 00 02 f9 f9 f9 f9 00 00 00 07
 ffffffff92c43800: f9 f9 f9 f9 00 00 00 05 f9 f9 f9 f9 06 f9 f9 f9
>ffffffff92c43880: f9 f9 f9 f9 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9
                                                 ^
 ffffffff92c43900: 00 00 00 00 00 00 00 00 07 f9 f9 f9 f9 f9 f9 f9
 ffffffff92c43980: 00 00 00 07 f9 f9 f9 f9 00 00 00 05 f9 f9 f9 f9

According to the comment of `nla_parse_nested_deprecated`, the maxtype
should be len(destination array) - 1. Hence use `IFLA_RMNET_MAX` here.

Fixes: 14452ca3b5ce ("net: qualcomm: rmnet: Export mux_id and flags to netlink")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240110061400.3356108-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 39d24e07f306..5b69b9268c75 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -396,7 +396,7 @@ static int rmnet_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 struct rtnl_link_ops rmnet_link_ops __read_mostly = {
 	.kind		= "rmnet",
-	.maxtype	= __IFLA_RMNET_MAX,
+	.maxtype	= IFLA_RMNET_MAX,
 	.priv_size	= sizeof(struct rmnet_priv),
 	.setup		= rmnet_vnd_setup,
 	.validate	= rmnet_rtnl_validate,
-- 
2.43.0



