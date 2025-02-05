Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DE91E89C;
	Wed,  5 Feb 2025 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768586; cv=none; b=u9Ph+Q8r4zR2dQNAHi8VSrLWS2OqrFldjZnIvYj9ilus3xfSmAUhdrK8ONT2PHF4Xs3B3rBK7FSORxhUju567lU40yNMZ2ui/Im+W2fCGx8sWs/HQQ7fo88R1f/oclpGs0i0GjqTVce6ygXEgfRK4Pr3TAcs4wxdxdxhLUHChDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768586; c=relaxed/simple;
	bh=2mqrc3Res2tRfAMoZmGlV0n9aoZluHdGxF7kTUCtnF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izj+7PsHk8T6k7JMgSR71MTvFuUN36KdaAlK7uUXJ3FeJlZqQzgbmF753vzXHV2btngN6ge6kqApD5Ba7SAC5FOBYa8PUJ2699ajQcDotnXxpiw+0BnG3WLHzZl5LnK/qolciBRqji3ici18LPcED68pc1/j6ZPDJ6LQPti2++E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awcvErJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awcvErJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5680C4CED1;
	Wed,  5 Feb 2025 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768586;
	bh=2mqrc3Res2tRfAMoZmGlV0n9aoZluHdGxF7kTUCtnF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awcvErJDokygANtcalDrec96SBfN3hhiS45rhMpJNh0C7nHecawXoXszCjL42FKtm
	 7Mt1ImPwnnL7hel0mXL+CXS8W8VwUkz+8A92sRO6Ci4PrBW52BlsKOKNkKLV2CXXYt
	 bhxigp7R/O+8qlurbK9tJGQwLUke3P8LSy/eUS1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cd16e79c1e45f3fe0377@syzkaller.appspotmail.com,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 600/623] mptcp: pm: only set fullmesh for subflow endp
Date: Wed,  5 Feb 2025 14:45:42 +0100
Message-ID: <20250205134519.178372380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 1bb0d1348546ad059f55c93def34e67cb2a034a6 upstream.

With the in-kernel path-manager, it is possible to change the 'fullmesh'
flag. The code in mptcp_pm_nl_fullmesh() expects to change it only on
'subflow' endpoints, to recreate more or less subflows using the linked
address.

Unfortunately, the set_flags() hook was a bit more permissive, and
allowed 'implicit' endpoints to get the 'fullmesh' flag while it is not
allowed before.

That's what syzbot found, triggering the following warning:

  WARNING: CPU: 0 PID: 6499 at net/mptcp/pm_netlink.c:1496 __mark_subflow_endp_available net/mptcp/pm_netlink.c:1496 [inline]
  WARNING: CPU: 0 PID: 6499 at net/mptcp/pm_netlink.c:1496 mptcp_pm_nl_fullmesh net/mptcp/pm_netlink.c:1980 [inline]
  WARNING: CPU: 0 PID: 6499 at net/mptcp/pm_netlink.c:1496 mptcp_nl_set_flags net/mptcp/pm_netlink.c:2003 [inline]
  WARNING: CPU: 0 PID: 6499 at net/mptcp/pm_netlink.c:1496 mptcp_pm_nl_set_flags+0x974/0xdc0 net/mptcp/pm_netlink.c:2064
  Modules linked in:
  CPU: 0 UID: 0 PID: 6499 Comm: syz.1.413 Not tainted 6.13.0-rc5-syzkaller-00172-gd1bf27c4e176 #0
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
  RIP: 0010:__mark_subflow_endp_available net/mptcp/pm_netlink.c:1496 [inline]
  RIP: 0010:mptcp_pm_nl_fullmesh net/mptcp/pm_netlink.c:1980 [inline]
  RIP: 0010:mptcp_nl_set_flags net/mptcp/pm_netlink.c:2003 [inline]
  RIP: 0010:mptcp_pm_nl_set_flags+0x974/0xdc0 net/mptcp/pm_netlink.c:2064
  Code: 01 00 00 49 89 c5 e8 fb 45 e8 f5 e9 b8 fc ff ff e8 f1 45 e8 f5 4c 89 f7 be 03 00 00 00 e8 44 1d 0b f9 eb a0 e8 dd 45 e8 f5 90 <0f> 0b 90 e9 17 ff ff ff 89 d9 80 e1 07 38 c1 0f 8c c9 fc ff ff 48
  RSP: 0018:ffffc9000d307240 EFLAGS: 00010293
  RAX: ffffffff8bb72e03 RBX: 0000000000000000 RCX: ffff88807da88000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
  RBP: ffffc9000d307430 R08: ffffffff8bb72cf0 R09: 1ffff1100b842a5e
  R10: dffffc0000000000 R11: ffffed100b842a5f R12: ffff88801e2e5ac0
  R13: ffff88805c214800 R14: ffff88805c2152e8 R15: 1ffff1100b842a5d
  FS:  00005555619f6500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000020002840 CR3: 00000000247e6000 CR4: 00000000003526f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   genl_family_rcv_msg_doit net/netlink/genetlink.c:1115 [inline]
   genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
   genl_rcv_msg+0xb14/0xec0 net/netlink/genetlink.c:1210
   netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2542
   genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
   netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
   netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1347
   netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1891
   sock_sendmsg_nosec net/socket.c:711 [inline]
   __sock_sendmsg+0x221/0x270 net/socket.c:726
   ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2583
   ___sys_sendmsg net/socket.c:2637 [inline]
   __sys_sendmsg+0x269/0x350 net/socket.c:2669
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f5fe8785d29
  Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007fff571f5558 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  RAX: ffffffffffffffda RBX: 00007f5fe8975fa0 RCX: 00007f5fe8785d29
  RDX: 0000000000000000 RSI: 0000000020000480 RDI: 0000000000000007
  RBP: 00007f5fe8801b08 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 00007f5fe8975fa0 R14: 00007f5fe8975fa0 R15: 00000000000011f4
   </TASK>

Here, syzbot managed to set the 'fullmesh' flag on an 'implicit' and
used -- according to 'id_avail_bitmap' -- endpoint, causing the PM to
try decrement the local_addr_used counter which is only incremented for
the 'subflow' endpoint.

Note that 'no type' endpoints -- not 'subflow', 'signal', 'implicit' --
are fine, because their ID will not be marked as used in the 'id_avail'
bitmap, and setting 'fullmesh' can help forcing the creation of subflow
when receiving an ADD_ADDR.

Fixes: 73c762c1f07d ("mptcp: set fullmesh flag in pm_netlink")
Cc: stable@vger.kernel.org
Reported-by: syzbot+cd16e79c1e45f3fe0377@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6786ac51.050a0220.216c54.00a6.GAE@google.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/540
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250123-net-mptcp-syzbot-issues-v1-2-af73258a726f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2050,7 +2050,8 @@ int mptcp_pm_nl_set_flags(struct sk_buff
 		return -EINVAL;
 	}
 	if ((addr.flags & MPTCP_PM_ADDR_FLAG_FULLMESH) &&
-	    (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+	    (entry->flags & (MPTCP_PM_ADDR_FLAG_SIGNAL |
+			     MPTCP_PM_ADDR_FLAG_IMPLICIT))) {
 		spin_unlock_bh(&pernet->lock);
 		GENL_SET_ERR_MSG(info, "invalid addr flags");
 		return -EINVAL;


