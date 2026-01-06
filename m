Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5912A35CBAE;
	Tue,  6 Jan 2026 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721655; cv=none; b=NYFbaGTdrVjPqGxcgmUXrwHZgrpfzjYIdh+TJpCDmxCZAeZ6ZD2ANksaNKUhKaFyJMEWewuQyZ6M0lASegSZI4J6RBT+fwLps0Up4aQDh8whdkN4gamUdr/n/hKNbXNsFzsEAsVxkMT+ARp9o3gwr4uxLXGX7WgECYacPctlj2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721655; c=relaxed/simple;
	bh=CMeTiRZbOHYACL+YslPcL5K3lOw7Rn77dMqAuk7vl8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3XWDVicFA3COzOhDNLivSTQa16J1LMhF8njQio2yBefq5xcgzsnXqG/iH/aXicAgthe+GEUJRiLsopP1QNHM73ut/ucozwjNkyyG7cQJZy76pnBG4LGrq+K4q6yFWEKiwZizRMH/dcWFIstRh+M0GQcDU5AHB8jQCkFnWq5Koo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+7aXHoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+7aXHoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC659C16AAE;
	Tue,  6 Jan 2026 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721655;
	bh=CMeTiRZbOHYACL+YslPcL5K3lOw7Rn77dMqAuk7vl8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+7aXHoWjRORnvSgIcRqK3q5Bzc6j4L1rkGr1/Lza3esigHm7S5h30Aib+0JHJLoW
	 kofpq/HJ5m/fbizDvPfB2N0n6enynO5eqGo4Y7b4keWcdABVaEmwj8Nfd5m2qfkK29
	 rctIPlDyUByQpG8a7mlI8LpOYdqbiUkHPO9hUnDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+422806e5f4cce722a71f@syzkaller.appspotmail.com,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/312] team: fix check for port enabled in team_queue_override_port_prio_changed()
Date: Tue,  6 Jan 2026 18:01:47 +0100
Message-ID: <20260106170549.054284538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 932ac51d9953eaf77a1252f79b656d4ca86163c6 ]

There has been a syzkaller bug reported recently with the following
trace:

list_del corruption, ffff888058bea080->prev is LIST_POISON2 (dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:59!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 3 UID: 0 PID: 21246 Comm: syz.0.2928 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__list_del_entry_valid_or_report+0x13e/0x200 lib/list_debug.c:59
Code: 48 c7 c7 e0 71 f0 8b e8 30 08 ef fc 90 0f 0b 48 89 ef e8 a5 02 55 fd 48 89 ea 48 89 de 48 c7 c7 40 72 f0 8b e8 13 08 ef fc 90 <0f> 0b 48 89 ef e8 88 02 55 fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc9000d49f370 EFLAGS: 00010286
RAX: 000000000000004e RBX: ffff888058bea080 RCX: ffffc9002817d000
RDX: 0000000000000000 RSI: ffffffff819becc6 RDI: 0000000000000005
RBP: dead000000000122 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffff888039e9c230
R13: ffff888058bea088 R14: ffff888058bea080 R15: ffff888055461480
FS:  00007fbbcfe6f6c0(0000) GS:ffff8880d6d0a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c3afcb0 CR3: 00000000382c7000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del_rcu include/linux/rculist.h:178 [inline]
 __team_queue_override_port_del drivers/net/team/team_core.c:826 [inline]
 __team_queue_override_port_del drivers/net/team/team_core.c:821 [inline]
 team_queue_override_port_prio_changed drivers/net/team/team_core.c:883 [inline]
 team_priority_option_set+0x171/0x2f0 drivers/net/team/team_core.c:1534
 team_option_set drivers/net/team/team_core.c:376 [inline]
 team_nl_options_set_doit+0x8ae/0xe60 drivers/net/team/team_core.c:2653
 genl_family_rcv_msg_doit+0x209/0x2f0 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x55c/0x800 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2552
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa98/0xc70 net/socket.c:2630
 ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
 __sys_sendmsg+0x16d/0x220 net/socket.c:2716
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The problem is in this flow:
1) Port is enabled, queue_id != 0, in qom_list
2) Port gets disabled
        -> team_port_disable()
        -> team_queue_override_port_del()
        -> del (removed from list)
3) Port is disabled, queue_id != 0, not in any list
4) Priority changes
        -> team_queue_override_port_prio_changed()
        -> checks: port disabled && queue_id != 0
        -> calls del - hits the BUG as it is removed already

To fix this, change the check in team_queue_override_port_prio_changed()
so it returns early if port is not enabled.

Reported-by: syzbot+422806e5f4cce722a71f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=422806e5f4cce722a71f
Fixes: 6c31ff366c11 ("team: remove synchronize_rcu() called during queue override change")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251212102953.167287-1-jiri@resnulli.us
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 25562b17debe..2fd3469d1046 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -878,7 +878,7 @@ static void __team_queue_override_enabled_check(struct team *team)
 static void team_queue_override_port_prio_changed(struct team *team,
 						  struct team_port *port)
 {
-	if (!port->queue_id || team_port_enabled(port))
+	if (!port->queue_id || !team_port_enabled(port))
 		return;
 	__team_queue_override_port_del(team, port);
 	__team_queue_override_port_add(team, port);
-- 
2.51.0



