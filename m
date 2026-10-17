Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0C36CE19;
	Sat, 17 Oct 2026 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255019; cv=none; b=Mr57hK4ydAUUHYcMFfNtiPRaVPvwO/D7B+6c7HYfBPH8n0VRE8ePKOPJtpBy0SbhRbjP7X3cd6tUaZ7P1V6CvF/7c+8aBL7o9vz0TE95pX5yd39oS1A8bB2WPZYLOREaTkNrqgU1dNCJmolpm9cy3lR+lbnegZa39nHVCZmPzPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255019; c=relaxed/simple;
	bh=5sqU74jwRQPdU0Oer1RUgLEwhcXLXbxvl/5zVnRYd3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEDa2rv7G6QnmMPDpHtY8lvdnQl4YlAQSbl5LN4iXj+CUidO6CJXskJvfDaw6+IVZ4eQFkKecRtDcsThN4F+KdTxOygbGtj3az6CCHsIQOrOhCI7QaAXmrAUw0m5g4b9IhHt/TyrGg+1Q4/EEK81zyrfOAP8MZf0B+lSMxgKZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09+kagxL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09+kagxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0101F000C4;
	Sat, 17 Oct 2026 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255018;
	bh=jydfWO9NKNqOYOZ5gIosXQeYsTZ24fIUUo7/QxnvoqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09+kagxLxqEzLC2v/ZF8UJD0Sx1S1ejewHpJjG+uivK2h8KxvkQd9JIeonxmgmBUl
	 znIjA9Kzs1Se0LZx1itA/Wiz/F3u9km0rdK8RFWUwMb5fOwX+IkGzlfRGJ6dqvqTB/
	 FhJ5mTxxISnVaWwuqrTXPJ90Fm+PCDPvtRVaQdQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 637/869] amt: Dont support cross-netns setup.
Date: Sat, 17 Oct 2026 17:57:58 +0200
Message-ID: <20261017160053.354312291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit e99ecc3046ea5f5c6b5e1f8b4ef854c6c6998e06 ]

When a lower device is unregistered, amt_device_event() tries
to unregister its upper AMT device, but it has two problems.

  1. amt_lookup_upper_dev() looks up an upper device in the
      lower device's netns only

  2. amt_device_event() unregisters a single upper device only

If AMT device is created on a lower device in another netns,
removing the lower device triggers the splat below and gets
stuck until all upper devices are removed. [0]

The cross-netns setup seems unintentional considering 1. and
the following points:

  * amt_link_setup() sets dev->netns_immutable to true
  * skb_scrub_packet() is not called in the fast path
  * iproute2 binary fails to find cross-netns lower device via
    link-netns:
      # ip -n ns1 link add amt0 link-netns ns2 type amt dev veth1
      Cannot find device "veth1"

Instead of supporting it properly and preparing for per-netns
netdev unreg, let's forbid cross-netns setup.

Note that the problem 2. needs a separate fix.

[0]:
WARNING: net/core/dev.c:12518 at unregister_netdevice_many_notify+0x1cce/0x2250, CPU#48: ip/2031
Modules linked in:
CPU: 48 UID: 0 PID: 2031 Comm: ip Not tainted 7.2.0-rc5+ #27 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
RIP: 0010:unregister_netdevice_many_notify (net/core/dev.c:12518)
Code: 89 ef e8 d5 52 ae fe e9 d0 f4 ff ff 48 8d 3d f9 3b 9c 02 48 c7 c6 c0 0b 63 84 ba ab 1f 00 00 67 48 0f b9 3a e9 65 ff ff ff 90 <0f> 0b 90 eb 81 48 8d 3d f6 3b 9c 02 48 c7 c6 c0 0b 63 84 ba e2 1f
RSP: 0018:ffffc90004abf160 EFLAGS: 00010212
RAX: ffff888104d38260 RBX: ffff88800b0911b8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff85b9f880
RBP: ffffc90004abf2d0 R08: ffffffff85b9f887 R09: 1ffffffff0b73f10
R10: dffffc0000000000 R11: fffffbfff0b73f11 R12: ffff88800b091d08
R13: ffff88800b091178 R14: dffffc0000000000 R15: ffff88800b091000
FS:  00007f555b86c600(0000) GS:ffff8881942a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562107d489c0 CR3: 0000000109a40002 CR4: 0000000000372ef0
Call Trace:
 <TASK>
 rtnl_dellink (net/core/rtnetlink.c:3632 net/core/rtnetlink.c:3674)
 rtnetlink_rcv_msg (net/core/rtnetlink.c:7112)
 netlink_rcv_skb (net/netlink/af_netlink.c:2556)
 netlink_unicast (net/netlink/af_netlink.c:1319)
 netlink_sendmsg (net/netlink/af_netlink.c:1900)
 ____sys_sendmsg (net/socket.c:775)
 __sys_sendmsg (net/socket.c:2738)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
...
unregister_netdevice: waiting for veth0 to become free. Usage count = 7
ref_tracker: netdev@ffff88800d7496d8 has 3/3 users at
     __netdev_adjacent_dev_insert (./include/linux/netdevice.h:4525 ./include/linux/netdevice.h:4554 net/core/dev.c:8791)
     __netdev_upper_dev_link (net/core/dev.c:8879 net/core/dev.c:8963)
     netdev_upper_dev_link (net/core/dev.c:9009)
     amt_newlink (drivers/net/amt.c:3321)

Fixes: b9022b53adad ("amt: add control plane of amt interface")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20260807020326.2519445-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index ac87ea8478077..bf890f90f51e2 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3195,6 +3195,9 @@ static int amt_newlink(struct net *net, struct net_device *dev,
 	struct amt_dev *amt = netdev_priv(dev);
 	int err = -EINVAL;
 
+	if (!net_eq(net, dev_net(dev)))
+		return err;
+
 	amt->net = net;
 	amt->mode = nla_get_u32(data[IFLA_AMT_MODE]);
 
-- 
2.53.0



