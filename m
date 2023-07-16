Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604AE8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC458C433C7;
	Sun, 16 Jul 2023 20:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540824;
	bh=LMfrwMKe307O6b1m2nj5B7YPZrEO6y0BOofL2Jpu2Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg23Qyy082uDhUOHKZKxJrx9abmk4crSOLB4jLIWOdD5/29P72d7+HXDfOY6K4XJo
	 IcTtGQ4keyVAhzvez/Li66SyEmUpv5sJ2n+7EH2pE1lm0lgBBZJdOOLJ/M48gDJavf
	 Nvd092AFu6vno7mjaqaP2+7JwfUGDyZrP4YnrwNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 501/591] net: fix net_dev_start_xmit trace event vs skb_transport_offset()
Date: Sun, 16 Jul 2023 21:50:40 +0200
Message-ID: <20230716194936.854755014@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f88fcb1d7d961b4b402d675109726f94db87571c ]

After blamed commit, we must be more careful about using
skb_transport_offset(), as reminded us by syzbot:

WARNING: CPU: 0 PID: 10 at include/linux/skbuff.h:2868 skb_transport_offset include/linux/skbuff.h:2977 [inline]
WARNING: CPU: 0 PID: 10 at include/linux/skbuff.h:2868 perf_trace_net_dev_start_xmit+0x89a/0xce0 include/trace/events/net.h:14
Modules linked in:
CPU: 0 PID: 10 Comm: kworker/u4:1 Not tainted 6.1.30-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:skb_transport_header include/linux/skbuff.h:2868 [inline]
RIP: 0010:skb_transport_offset include/linux/skbuff.h:2977 [inline]
RIP: 0010:perf_trace_net_dev_start_xmit+0x89a/0xce0 include/trace/events/net.h:14
Code: 8b 04 25 28 00 00 00 48 3b 84 24 c0 00 00 00 0f 85 4e 04 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc e8 56 22 01 fd <0f> 0b e9 f6 fc ff ff 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 86 f9 ff
RSP: 0018:ffffc900002bf700 EFLAGS: 00010293
RAX: ffffffff8485d8ca RBX: 000000000000ffff RCX: ffff888100914280
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: ffffc900002bf818 R08: ffffffff8485d5b6 R09: fffffbfff0f8fb5e
R10: 0000000000000000 R11: dffffc0000000001 R12: 1ffff110217d8f67
R13: ffff88810bec7b3a R14: dffffc0000000000 R15: dffffc0000000000
FS: 0000000000000000(0000) GS:ffff8881f6a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f96cf6d52f0 CR3: 000000012224c000 CR4: 0000000000350ef0
Call Trace:
<TASK>
[<ffffffff84715e35>] trace_net_dev_start_xmit include/trace/events/net.h:14 [inline]
[<ffffffff84715e35>] xmit_one net/core/dev.c:3643 [inline]
[<ffffffff84715e35>] dev_hard_start_xmit+0x705/0x980 net/core/dev.c:3660
[<ffffffff8471a232>] __dev_queue_xmit+0x16b2/0x3370 net/core/dev.c:4324
[<ffffffff85416493>] dev_queue_xmit include/linux/netdevice.h:3030 [inline]
[<ffffffff85416493>] batadv_send_skb_packet+0x3f3/0x680 net/batman-adv/send.c:108
[<ffffffff85416744>] batadv_send_broadcast_skb+0x24/0x30 net/batman-adv/send.c:127
[<ffffffff853bc52a>] batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
[<ffffffff853bc52a>] batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:421 [inline]
[<ffffffff853bc52a>] batadv_iv_send_outstanding_bat_ogm_packet+0x69a/0x840 net/batman-adv/bat_iv_ogm.c:1701
[<ffffffff8151023c>] process_one_work+0x8ac/0x1170 kernel/workqueue.c:2289
[<ffffffff81511938>] worker_thread+0xaa8/0x12d0 kernel/workqueue.c:2436

Fixes: 66e4c8d95008 ("net: warn if transport header was not set")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/net.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index da611a7aaf970..f667c76a3b022 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -51,7 +51,8 @@ TRACE_EVENT(net_dev_start_xmit,
 		__entry->network_offset = skb_network_offset(skb);
 		__entry->transport_offset_valid =
 			skb_transport_header_was_set(skb);
-		__entry->transport_offset = skb_transport_offset(skb);
+		__entry->transport_offset = skb_transport_header_was_set(skb) ?
+			skb_transport_offset(skb) : 0;
 		__entry->tx_flags = skb_shinfo(skb)->tx_flags;
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
-- 
2.39.2



