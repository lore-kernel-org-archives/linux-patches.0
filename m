Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF07F215764;
	Thu, 12 Dec 2024 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017629; cv=none; b=gzWlSNa2zbF3JXARsGj40bATLlkHTOcgbvh7ToeXg9F+uwJMYZnOUCyOUB1w0vAWGCdyeBYutuuNEtp6vHtptM2lmSeWmUTK6GSNRKV6qmFNc7dqSPX7/Ie7aUlHct218OE0eMHgqNNBlFsJiT+2yuQB1iMQaZUgYbekUNT0+AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017629; c=relaxed/simple;
	bh=C8Yqh6IvEETpbmYx58sG263UQOIcX7xyT62+SY+uAw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8n4x+tS/tgmI7NZA92EM+5vsg5YmclSKUeLlKwvBlfE+wTPxTKBNETjRjp3fmejWaccVPVHk9yVpZ7icLKbx6MvmbCyeMNWUJICtwt/QpWXmFkKN5Uvm5mAHeOffmraY+tKIRn0r6TUevJ8NlWpAx9VT/x6mHVccRKPOWxPsfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKO9FjtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKO9FjtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C016C4CECE;
	Thu, 12 Dec 2024 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017628;
	bh=C8Yqh6IvEETpbmYx58sG263UQOIcX7xyT62+SY+uAw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKO9FjtFaVfdR0SrqUHljzaWo857sP4BluVof5Mpj+Uglk8RZGiRf5azk4VY/03zx
	 w+LpEjrkOC9Py3mVAsPzXOxFcLqirtToPP0RZa1EV2eGaxygjvdnBTRnJa6cdLW3uy
	 E0S+eqBi9q2RoVWoqc3Fu9fMWhZJqpTQvvpjxC/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ec5271486d7cb2d242a@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/356] geneve: do not assume mac header is set in geneve_xmit_skb()
Date: Thu, 12 Dec 2024 15:56:19 +0100
Message-ID: <20241212144247.005715167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8588c99c7d47448fcae39e3227d6e2bb97aad86d ]

We should not assume mac header is set in output path.

Use skb_eth_hdr() instead of eth_hdr() to fix the issue.

sysbot reported the following :

 WARNING: CPU: 0 PID: 11635 at include/linux/skbuff.h:3052 skb_mac_header include/linux/skbuff.h:3052 [inline]
 WARNING: CPU: 0 PID: 11635 at include/linux/skbuff.h:3052 eth_hdr include/linux/if_ether.h:24 [inline]
 WARNING: CPU: 0 PID: 11635 at include/linux/skbuff.h:3052 geneve_xmit_skb drivers/net/geneve.c:898 [inline]
 WARNING: CPU: 0 PID: 11635 at include/linux/skbuff.h:3052 geneve_xmit+0x4c38/0x5730 drivers/net/geneve.c:1039
Modules linked in:
CPU: 0 UID: 0 PID: 11635 Comm: syz.4.1423 Not tainted 6.12.0-syzkaller-10296-gaaf20f870da0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
 RIP: 0010:skb_mac_header include/linux/skbuff.h:3052 [inline]
 RIP: 0010:eth_hdr include/linux/if_ether.h:24 [inline]
 RIP: 0010:geneve_xmit_skb drivers/net/geneve.c:898 [inline]
 RIP: 0010:geneve_xmit+0x4c38/0x5730 drivers/net/geneve.c:1039
Code: 21 c6 02 e9 35 d4 ff ff e8 a5 48 4c fb 90 0f 0b 90 e9 fd f5 ff ff e8 97 48 4c fb 90 0f 0b 90 e9 d8 f5 ff ff e8 89 48 4c fb 90 <0f> 0b 90 e9 41 e4 ff ff e8 7b 48 4c fb 90 0f 0b 90 e9 cd e7 ff ff
RSP: 0018:ffffc90003b2f870 EFLAGS: 00010283
RAX: 000000000000037a RBX: 000000000000ffff RCX: ffffc9000dc3d000
RDX: 0000000000080000 RSI: ffffffff86428417 RDI: 0000000000000003
RBP: ffffc90003b2f9f0 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000002 R12: ffff88806603c000
R13: 0000000000000000 R14: ffff8880685b2780 R15: 0000000000000e23
FS:  00007fdc2deed6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30a1dff8 CR3: 0000000056b8c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  __netdev_start_xmit include/linux/netdevice.h:5002 [inline]
  netdev_start_xmit include/linux/netdevice.h:5011 [inline]
  __dev_direct_xmit+0x58a/0x720 net/core/dev.c:4490
  dev_direct_xmit include/linux/netdevice.h:3181 [inline]
  packet_xmit+0x1e4/0x360 net/packet/af_packet.c:285
  packet_snd net/packet/af_packet.c:3146 [inline]
  packet_sendmsg+0x2700/0x5660 net/packet/af_packet.c:3178
  sock_sendmsg_nosec net/socket.c:711 [inline]
  __sock_sendmsg net/socket.c:726 [inline]
  __sys_sendto+0x488/0x4f0 net/socket.c:2197
  __do_sys_sendto net/socket.c:2204 [inline]
  __se_sys_sendto net/socket.c:2200 [inline]
  __x64_sys_sendto+0xe0/0x1c0 net/socket.c:2200
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
Reported-by: syzbot+3ec5271486d7cb2d242a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/674f4b72.050a0220.17bd51.004a.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://patch.msgid.link/20241203182122.2725517-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8333a5620deff..b939d4711c59b 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -986,7 +986,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		if (geneve->cfg.df == GENEVE_DF_SET) {
 			df = htons(IP_DF);
 		} else if (geneve->cfg.df == GENEVE_DF_INHERIT) {
-			struct ethhdr *eth = eth_hdr(skb);
+			struct ethhdr *eth = skb_eth_hdr(skb);
 
 			if (ntohs(eth->h_proto) == ETH_P_IPV6) {
 				df = htons(IP_DF);
-- 
2.43.0



