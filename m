Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C030143C6E;
	Sun,  1 Sep 2024 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207821; cv=none; b=JkW7Emfd47O3gjZjqZKx/eJrPX1dFcDC6+NNMyBfcs2EJIu3yrP5boVqshG3t95TOzuQXKWPLgu9SLm4OHemNYz1iynCUBqlREQyDB51r2CvD+tPX9vaoM785Pp6+uDd84KpfG/aNpSogYUHZKE5jht4B6BLB4aM89J+SmdKZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207821; c=relaxed/simple;
	bh=gs4CxOFGjNY7I4Qv3+5cPmJlYWUvbLg2S6BJsOoA+4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJMtqwAzLpzt524evaiCQgMqJVpy3aVlXwIylc2mkz50eJ55c085e69Mf9wg/NBFNVG2G2c6ybjvtSTU+QiVbKT708b7bq3yFpRDYz9JJDJBue70122aLJQ/6Sk1pbBqH509VUQDOAs1PFLsUPDRve4fgmCV+JIx+h8ME3xBFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7+I28nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7+I28nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E09C4CEC3;
	Sun,  1 Sep 2024 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207820;
	bh=gs4CxOFGjNY7I4Qv3+5cPmJlYWUvbLg2S6BJsOoA+4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7+I28nrL1qZmxhNJd5om93cLZpVvtsuxyCqtflqWvMkumGpYL/7eb5wETf2jIZ21
	 bO+kL/p9lt7fAWZy8NHAUfeb5uWM2wkP2LCUUGNX5Lv0iBq741BA7q/ss2Bng5VRjF
	 gPEyfo06j71giFTMUuLD1PEGZ7L3DlUGqtC6b0Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 86/98] net: prevent mss overflow in skb_segment()
Date: Sun,  1 Sep 2024 18:16:56 +0200
Message-ID: <20240901160806.940629452@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 23d05d563b7e7b0314e65c8e882bc27eac2da8e7 upstream.

Once again syzbot is able to crash the kernel in skb_segment() [1]

GSO_BY_FRAGS is a forbidden value, but unfortunately the following
computation in skb_segment() can reach it quite easily :

	mss = mss * partial_segs;

65535 = 3 * 5 * 17 * 257, so many initial values of mss can lead to
a bad final result.

Make sure to limit segmentation so that the new mss value is smaller
than GSO_BY_FRAGS.

[1]

general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 PID: 5079 Comm: syz-executor993 Not tainted 6.7.0-rc4-syzkaller-00141-g1ae4cd3cbdd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/10/2023
RIP: 0010:skb_segment+0x181d/0x3f30 net/core/skbuff.c:4551
Code: 83 e3 02 e9 fb ed ff ff e8 90 68 1c f9 48 8b 84 24 f8 00 00 00 48 8d 78 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 8a 21 00 00 48 8b 84 24 f8 00
RSP: 0018:ffffc900043473d0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000010046 RCX: ffffffff886b1597
RDX: 000000000000000e RSI: ffffffff886b2520 RDI: 0000000000000070
RBP: ffffc90004347578 R08: 0000000000000005 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000002 R12: ffff888063202ac0
R13: 0000000000010000 R14: 000000000000ffff R15: 0000000000000046
FS: 0000555556e7e380(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020010000 CR3: 0000000027ee2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
udp6_ufo_fragment+0xa0e/0xd00 net/ipv6/udp_offload.c:109
ipv6_gso_segment+0x534/0x17e0 net/ipv6/ip6_offload.c:120
skb_mac_gso_segment+0x290/0x610 net/core/gso.c:53
__skb_gso_segment+0x339/0x710 net/core/gso.c:124
skb_gso_segment include/net/gso.h:83 [inline]
validate_xmit_skb+0x36c/0xeb0 net/core/dev.c:3626
__dev_queue_xmit+0x6f3/0x3d60 net/core/dev.c:4338
dev_queue_xmit include/linux/netdevice.h:3134 [inline]
packet_xmit+0x257/0x380 net/packet/af_packet.c:276
packet_snd net/packet/af_packet.c:3087 [inline]
packet_sendmsg+0x24c6/0x5220 net/packet/af_packet.c:3119
sock_sendmsg_nosec net/socket.c:730 [inline]
__sock_sendmsg+0xd5/0x180 net/socket.c:745
__sys_sendto+0x255/0x340 net/socket.c:2190
__do_sys_sendto net/socket.c:2202 [inline]
__se_sys_sendto net/socket.c:2198 [inline]
__x64_sys_sendto+0xe0/0x1b0 net/socket.c:2198
do_syscall_x64 arch/x86/entry/common.c:52 [inline]
do_syscall_64+0x40/0x110 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe+0x63/0x6b
RIP: 0033:0x7f8692032aa9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff8d685418 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f8692032aa9
RDX: 0000000000010048 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000000f4240 R08: 0000000020000540 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff8d685480
R13: 0000000000000001 R14: 00007fff8d685480 R15: 0000000000000003
</TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_segment+0x181d/0x3f30 net/core/skbuff.c:4551
Code: 83 e3 02 e9 fb ed ff ff e8 90 68 1c f9 48 8b 84 24 f8 00 00 00 48 8d 78 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 8a 21 00 00 48 8b 84 24 f8 00
RSP: 0018:ffffc900043473d0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000010046 RCX: ffffffff886b1597
RDX: 000000000000000e RSI: ffffffff886b2520 RDI: 0000000000000070
RBP: ffffc90004347578 R08: 0000000000000005 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000002 R12: ffff888063202ac0
R13: 0000000000010000 R14: 000000000000ffff R15: 0000000000000046
FS: 0000555556e7e380(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020010000 CR3: 0000000027ee2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 3953c46c3ac7 ("sk_buff: allow segmenting based on frag sizes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20231212164621.4131800-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3625,8 +3625,9 @@ struct sk_buff *skb_segment(struct sk_bu
 		/* GSO partial only requires that we trim off any excess that
 		 * doesn't fit into an MSS sized block, so take care of that
 		 * now.
+		 * Cap len to not accidentally hit GSO_BY_FRAGS.
 		 */
-		partial_segs = len / mss;
+		partial_segs = min(len, (unsigned int)(GSO_BY_FRAGS - 1)) / mss;
 		if (partial_segs > 1)
 			mss *= partial_segs;
 		else


