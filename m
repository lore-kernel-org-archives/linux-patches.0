Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA12D7D3A;
	Sat, 17 Oct 2026 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260159; cv=none; b=ZobWZvRIwGr5vu3B7B4XD+wN9bhwFX+9w1UjKvj0SjX1Icwd8cFyGrtZH7YuIDeJ9cz4nSZm3BrfIynhoFaqfU6ReQz98qvP6HyjizV0Yz9MoFRRvZmGRZqe7lyB07YZ/2m9zjliN/kZvYHwjkYqBBDjhUjIo3/KoJI80ftT/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260159; c=relaxed/simple;
	bh=xBUdZmWc03jeAA7UfI2YOVxT3nfSgX45anv11denb8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT9KQJxKm5aJLIg1d40CgtpRtmeDZfJgn7Efs3RcT6Y+ErzWD67Yk8FfGZMxV82OP2URqAjPEOLTPdCMBAO8aWMJDYAorGq7yoJ5ycdrJ0B8uwlUP4soGopa7NbOnPEq0dnBNzJddR5h+dQoCujUG0OFOmOT3WSmpBG5aeE21V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ2G9Dcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ2G9Dcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADB81F000C4;
	Sat, 17 Oct 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260158;
	bh=hrtIhybPv+N6WvQgO7AKCk45CZqZJW/8eiJwFA3IgK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZ2G9DcxrxCKRXC/4Ui3ZZf6XZS7IAWbTAY8b0UIBs+CA78UZu7VNQ7SXEBEzGhc1
	 3uFEpPvfDwvpYtUSpkt8Q2Cm7D7KuHNLarVPgNKy7LeZ5y9Xn/nQoJSdWLlcdk/6uP
	 bbx3bBO3J+fJSqU6ckJe2RAHPognnVP8B2N7bEVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1412/1674] amt: Dont support cross-netns setup.
Date: Sat, 17 Oct 2026 18:01:24 +0200
Message-ID: <20261017160507.423100853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 33614c802be1c..9bdc6c0e7bf9c 100644
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



