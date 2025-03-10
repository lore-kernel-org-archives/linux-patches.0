Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D722236E4;
	Mon, 10 Mar 2025 18:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630850; cv=none; b=UucHZqZVPvYEtyvoxvPc+c9H9VUc+RBW2gDCvR1W8eo6MEtF2i2ne/w9nltV0BPwgowBiPbjAP3MIyVzL28jnx6HBimxYBqilhSb+UMWz3KJthijrtxVU4r+EirNnY+2K+sWD4i+r7P/COXXJuOf7JtlNz7FKxxPPnVXbbBbMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630850; c=relaxed/simple;
	bh=XiQG8Kp9mDsZOKRLlhdpcoIDLR1a5Fxn8pYYVElsQDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx4+zN9o4x8fijt9lgbX3r/jxEqApv5o1/8cUC9WX80z4bf3F2IHb+SgoWOGi/AVl/pGcTwp2GI4g79N4q3SnyIhgTTJh3j71xriZC+5jGb3XOoE4t8tfPAYE7lheMIk/oJ2BhsdRm9ZVkgTi2JzVjfbxS0+qugBl3Yz9kRjRX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1tMuT5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1tMuT5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488D3C4CEE5;
	Mon, 10 Mar 2025 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630850;
	bh=XiQG8Kp9mDsZOKRLlhdpcoIDLR1a5Fxn8pYYVElsQDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1tMuT5AolNsky+bF9XRwsi7G8g/upqP1XSEUtk1rgxJClFezZ8dYJbNOPbJ3NvSt
	 wjAzay0dn4/JWUBwKozdw64kRYdsY/hcJD9L9Vxc/p2iAzCTKvql6oXaOMdjFtBQE/
	 t+MZuX+YAclCAZCzTLymYsI+TeAjqcbd6JkLwQPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cd3ce3d03a3393ae9700@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 525/620] mptcp: always handle address removal under msk socket lock
Date: Mon, 10 Mar 2025 18:06:11 +0100
Message-ID: <20250310170606.273295696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit f865c24bc55158313d5779fc81116023a6940ca3 upstream.

Syzkaller reported a lockdep splat in the PM control path:

  WARNING: CPU: 0 PID: 6693 at ./include/net/sock.h:1711 sock_owned_by_me include/net/sock.h:1711 [inline]
  WARNING: CPU: 0 PID: 6693 at ./include/net/sock.h:1711 msk_owned_by_me net/mptcp/protocol.h:363 [inline]
  WARNING: CPU: 0 PID: 6693 at ./include/net/sock.h:1711 mptcp_pm_nl_addr_send_ack+0x57c/0x610 net/mptcp/pm_netlink.c:788
  Modules linked in:
  CPU: 0 UID: 0 PID: 6693 Comm: syz.0.205 Not tainted 6.14.0-rc2-syzkaller-00303-gad1b832bf1cf #0
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
  RIP: 0010:sock_owned_by_me include/net/sock.h:1711 [inline]
  RIP: 0010:msk_owned_by_me net/mptcp/protocol.h:363 [inline]
  RIP: 0010:mptcp_pm_nl_addr_send_ack+0x57c/0x610 net/mptcp/pm_netlink.c:788
  Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 ca 7b d3 f5 eb b9 e8 c3 7b d3 f5 90 0f 0b 90 e9 dd fb ff ff e8 b5 7b d3 f5 90 <0f> 0b 90 e9 3e fb ff ff 44 89 f1 80 e1 07 38 c1 0f 8c eb fb ff ff
  RSP: 0000:ffffc900034f6f60 EFLAGS: 00010283
  RAX: ffffffff8bee3c2b RBX: 0000000000000001 RCX: 0000000000080000
  RDX: ffffc90004d42000 RSI: 000000000000a407 RDI: 000000000000a408
  RBP: ffffc900034f7030 R08: ffffffff8bee37f6 R09: 0100000000000000
  R10: dffffc0000000000 R11: ffffed100bcc62e4 R12: ffff88805e6316e0
  R13: ffff88805e630c00 R14: dffffc0000000000 R15: ffff88805e630c00
  FS:  00007f7e9a7e96c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000001b2fd18ff8 CR3: 0000000032c24000 CR4: 00000000003526f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   mptcp_pm_remove_addr+0x103/0x1d0 net/mptcp/pm.c:59
   mptcp_pm_remove_anno_addr+0x1f4/0x2f0 net/mptcp/pm_netlink.c:1486
   mptcp_nl_remove_subflow_and_signal_addr net/mptcp/pm_netlink.c:1518 [inline]
   mptcp_pm_nl_del_addr_doit+0x118d/0x1af0 net/mptcp/pm_netlink.c:1629
   genl_family_rcv_msg_doit net/netlink/genetlink.c:1115 [inline]
   genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
   genl_rcv_msg+0xb1f/0xec0 net/netlink/genetlink.c:1210
   netlink_rcv_skb+0x206/0x480 net/netlink/af_netlink.c:2543
   genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
   netlink_unicast_kernel net/netlink/af_netlink.c:1322 [inline]
   netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1348
   netlink_sendmsg+0x8de/0xcb0 net/netlink/af_netlink.c:1892
   sock_sendmsg_nosec net/socket.c:718 [inline]
   __sock_sendmsg+0x221/0x270 net/socket.c:733
   ____sys_sendmsg+0x53a/0x860 net/socket.c:2573
   ___sys_sendmsg net/socket.c:2627 [inline]
   __sys_sendmsg+0x269/0x350 net/socket.c:2659
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f7e9998cde9
  Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f7e9a7e9038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  RAX: ffffffffffffffda RBX: 00007f7e99ba5fa0 RCX: 00007f7e9998cde9
  RDX: 000000002000c094 RSI: 0000400000000000 RDI: 0000000000000007
  RBP: 00007f7e99a0e2a0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 0000000000000000 R14: 00007f7e99ba5fa0 R15: 00007fff49231088

Indeed the PM can try to send a RM_ADDR over a msk without acquiring
first the msk socket lock.

The bugged code-path comes from an early optimization: when there
are no subflows, the PM should (usually) not send RM_ADDR
notifications.

The above statement is incorrect, as without locks another process
could concurrent create a new subflow and cause the RM_ADDR generation.

Additionally the supposed optimization is not very effective even
performance-wise, as most mptcp sockets should have at least one
subflow: the MPC one.

Address the issue removing the buggy code path, the existing "slow-path"
will handle correctly even the edge case.

Fixes: b6c08380860b ("mptcp: remove addr and subflow in PM netlink")
Cc: stable@vger.kernel.org
Reported-by: syzbot+cd3ce3d03a3393ae9700@syzkaller.appspotmail.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/546
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250224-net-mptcp-misc-fixes-v1-1-f550f636b435@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1406,11 +1406,6 @@ static int mptcp_nl_remove_subflow_and_s
 		struct sock *sk = (struct sock *)msk;
 		bool remove_subflow;
 
-		if (list_empty(&msk->conn_list)) {
-			mptcp_pm_remove_anno_addr(msk, addr, false);
-			goto next;
-		}
-
 		lock_sock(sk);
 		remove_subflow = lookup_subflow_by_saddr(&msk->conn_list, addr);
 		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow);
@@ -1418,7 +1413,6 @@ static int mptcp_nl_remove_subflow_and_s
 			mptcp_pm_remove_subflow(msk, &list);
 		release_sock(sk);
 
-next:
 		sock_put(sk);
 		cond_resched();
 	}


