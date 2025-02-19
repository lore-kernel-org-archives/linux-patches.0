Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CA717A2FE;
	Wed, 19 Feb 2025 09:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957282; cv=none; b=UDrrZJm3uCFcinCOMiNQLsAH4tA4pDjSoRONrBpaLxp7Zoia4OddzDOcgX2meK+z0w+JUymUMqgkEVnfdZcHjGTpCse74rndtm1kmyKYRQ2o460uRJ+NsQ3o7+52mXu3LXtxprN9bOkGRppdmTyt2HEqpANTiO3iUlg5zPmVzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957282; c=relaxed/simple;
	bh=v9XpLGmCdIJ0uEOkkuhXjvnGE3kfnDhno2tmqJ6LQiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8WVqpp839M0STulJIN4AZoWveErqXigSnyStvIk45KkfKBroKNn3PZiF68eNDLjq0huSeKrm/BhVxFB+WXs1Qn/Wr0SWXdalxP9kGlf6W6u92W55XbMTA1KzJoI3Uj1Z7YubP+I67waLcvHmMSi3ROPJgw01MCLyzFeDXUiWYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMPjV6j0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMPjV6j0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90670C4CED1;
	Wed, 19 Feb 2025 09:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957282;
	bh=v9XpLGmCdIJ0uEOkkuhXjvnGE3kfnDhno2tmqJ6LQiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMPjV6j0fxydnlWmLjCOcJtwKOlY/yI1k1LON/qZL1iKpFhqhQ08h9h+eAnsVpFS8
	 LsCaSWnEkIuNuxadW48jnIoM1PtRH6iiSLSms/MtxacewsMqJUUuDJa9KQ7pJ7hqyY
	 bn9lkakZPEfkTyBdvqJkB1wysvssK0RgwikphSUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1fcd957a82e3a1baa94d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/578] team: better TEAM_OPTION_TYPE_STRING validation
Date: Wed, 19 Feb 2025 09:27:55 +0100
Message-ID: <20250219082711.538310486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5bef3ac184b5626ea62385d6b82a1992b89d7940 ]

syzbot reported following splat [1]

Make sure user-provided data contains one nul byte.

[1]
 BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:633 [inline]
 BUG: KMSAN: uninit-value in string+0x3ec/0x5f0 lib/vsprintf.c:714
  string_nocheck lib/vsprintf.c:633 [inline]
  string+0x3ec/0x5f0 lib/vsprintf.c:714
  vsnprintf+0xa5d/0x1960 lib/vsprintf.c:2843
  __request_module+0x252/0x9f0 kernel/module/kmod.c:149
  team_mode_get drivers/net/team/team_core.c:480 [inline]
  team_change_mode drivers/net/team/team_core.c:607 [inline]
  team_mode_option_set+0x437/0x970 drivers/net/team/team_core.c:1401
  team_option_set drivers/net/team/team_core.c:375 [inline]
  team_nl_options_set_doit+0x1339/0x1f90 drivers/net/team/team_core.c:2662
  genl_family_rcv_msg_doit net/netlink/genetlink.c:1115 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
  genl_rcv_msg+0x1214/0x12c0 net/netlink/genetlink.c:1210
  netlink_rcv_skb+0x375/0x650 net/netlink/af_netlink.c:2543
  genl_rcv+0x40/0x60 net/netlink/genetlink.c:1219
  netlink_unicast_kernel net/netlink/af_netlink.c:1322 [inline]
  netlink_unicast+0xf52/0x1260 net/netlink/af_netlink.c:1348
  netlink_sendmsg+0x10da/0x11e0 net/netlink/af_netlink.c:1892
  sock_sendmsg_nosec net/socket.c:718 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:733
  ____sys_sendmsg+0x877/0xb60 net/socket.c:2573
  ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2627
  __sys_sendmsg net/socket.c:2659 [inline]
  __do_sys_sendmsg net/socket.c:2664 [inline]
  __se_sys_sendmsg net/socket.c:2662 [inline]
  __x64_sys_sendmsg+0x212/0x3c0 net/socket.c:2662
  x64_sys_call+0x2ed6/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:47
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Reported-by: syzbot+1fcd957a82e3a1baa94d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1fcd957a82e3a1baa94d
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20250212134928.1541609-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b23aa3c8bdf8e..c2327fa10747c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2670,7 +2670,9 @@ static int team_nl_cmd_options_set(struct sk_buff *skb, struct genl_info *info)
 				ctx.data.u32_val = nla_get_u32(attr_data);
 				break;
 			case TEAM_OPTION_TYPE_STRING:
-				if (nla_len(attr_data) > TEAM_STRING_MAX_LEN) {
+				if (nla_len(attr_data) > TEAM_STRING_MAX_LEN ||
+				    !memchr(nla_data(attr_data), '\0',
+					    nla_len(attr_data))) {
 					err = -EINVAL;
 					goto team_put;
 				}
-- 
2.39.5



