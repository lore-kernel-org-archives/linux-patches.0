Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742863C6A27;
	Mon, 20 Apr 2026 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691645; cv=none; b=ZnEpJPlkPqwC99yXOkKo+S+hMkHm/3sLGdg6mlsWH6KWKaOIdrK+B2uuxfZe9Vh/UXnClYITnrgN47QMyIoQO0tDvff7PgGlAMJWMdWAyNaZqsR3JXg+W6IR6hByiR6pCfiVnRlhrakcR3YOVimJgnM5CePSX7IN/ijo73sPXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691645; c=relaxed/simple;
	bh=l12UKowx1jBObkMNyxM6cqzVbJjXFr7pVlMFrJBJQHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+J40pLIwguId6GL/hfbOPwkiBs/LSlAmoHcHMFPpvy/hxlKX2jhUAb3oSd07AXh8WZ1Nz3TsvikbOC+cJV/3iNoWPQZ8oRzf95eL/jfx7Q7lFSFPqYkwkXl0RYk8SqD1jOiM/zLl84WPFLk0mVGfW7bGof35Lexq+bEjKwG9Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EW0HrxPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EW0HrxPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE31C19425;
	Mon, 20 Apr 2026 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691645;
	bh=l12UKowx1jBObkMNyxM6cqzVbJjXFr7pVlMFrJBJQHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW0HrxPjITMdSJbVxSVx26VBy/uhH+eWt2agdDhb7R5K1utDr23/FgbPl3bsMF0Zn
	 gULyZkLCXcwEN23k75UcDdlm/VGloln8XuJthxIkbQSGLhtr5T/PP8Xq4h0oHZwDZt
	 VJwn5ROy9vOAAdKgv/CjYYHB8jqicDALV+wmHIfxDKWmzQRr0bnYETpi30bvhIaonD
	 xXs2iucxqRezI7l0P5vnZf/eJOtqxlOnyRFnRYcUnkyvw14nwbNs3/+/oJeyn7aSfU
	 fjAlDn9zaoif/ve49Y1abVlE5CO7VrhnCNn3pyhekZ0Sk4uzqgo9jrDDjSonpO4bFZ
	 CeXqnJUw+IS8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alice Mikityanska <alice@isovalent.com>,
	syzbot+ci3edea60a44225dec@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	jchapman@katalix.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] l2tp: Drop large packets with UDP encap
Date: Mon, 20 Apr 2026 09:19:03 -0400
Message-ID: <20260420132314.1023554-149-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit ebe560ea5f54134279356703e73b7f867c89db13 ]

syzbot reported a WARN on my patch series [1]. The actual issue is an
overflow of 16-bit UDP length field, and it exists in the upstream code.
My series added a debug WARN with an overflow check that exposed the
issue, that's why syzbot tripped on my patches, rather than on upstream
code.

syzbot's repro:

r0 = socket$pppl2tp(0x18, 0x1, 0x1)
r1 = socket$inet6_udp(0xa, 0x2, 0x0)
connect$inet6(r1, &(0x7f00000000c0)={0xa, 0x0, 0x0, @loopback, 0xfffffffc}, 0x1c)
connect$pppl2tp(r0, &(0x7f0000000240)=@pppol2tpin6={0x18, 0x1, {0x0, r1, 0x4, 0x0, 0x0, 0x0, {0xa, 0x4e22, 0xffff, @ipv4={'\x00', '\xff\xff', @empty}}}}, 0x32)
writev(r0, &(0x7f0000000080)=[{&(0x7f0000000000)="ee", 0x34000}], 0x1)

It basically sends an oversized (0x34000 bytes) PPPoL2TP packet with UDP
encapsulation, and l2tp_xmit_core doesn't check for overflows when it
assigns the UDP length field. The value gets trimmed to 16 bites.

Add an overflow check that drops oversized packets and avoids sending
packets with trimmed UDP length to the wire.

syzbot's stack trace (with my patch applied):

len >= 65536u
WARNING: ./include/linux/udp.h:38 at udp_set_len_short include/linux/udp.h:38 [inline], CPU#1: syz.0.17/5957
WARNING: ./include/linux/udp.h:38 at l2tp_xmit_core net/l2tp/l2tp_core.c:1293 [inline], CPU#1: syz.0.17/5957
WARNING: ./include/linux/udp.h:38 at l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l2tp_core.c:1327, CPU#1: syz.0.17/5957
Modules linked in:
CPU: 1 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:udp_set_len_short include/linux/udp.h:38 [inline]
RIP: 0010:l2tp_xmit_core net/l2tp/l2tp_core.c:1293 [inline]
RIP: 0010:l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l2tp_core.c:1327
Code: 0f 0b 90 e9 21 f9 ff ff e8 e9 05 ec f6 90 0f 0b 90 e9 8d f9 ff ff e8 db 05 ec f6 90 0f 0b 90 e9 cc f9 ff ff e8 cd 05 ec f6 90 <0f> 0b 90 e9 de fa ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 4f
RSP: 0018:ffffc90003d67878 EFLAGS: 00010293
RAX: ffffffff8ad985e3 RBX: ffff8881a6400090 RCX: ffff8881697f0000
RDX: 0000000000000000 RSI: 0000000000034010 RDI: 000000000000ffff
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520007acf00 R12: ffff8881baf20900
R13: 0000000000034010 R14: ffff8881a640008e R15: ffff8881760f7000
FS:  000055557e81f500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000033000 CR3: 00000001612f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 pppol2tp_sendmsg+0x40a/0x5f0 net/l2tp/l2tp_ppp.c:302
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 sock_write_iter+0x503/0x550 net/socket.c:1195
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_writev+0x33c/0x990 fs/read_write.c:1059
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f636479c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffffd4241c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007f6364a15fa0 RCX: 00007f636479c629
RDX: 0000000000000001 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007f6364832b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6364a15fac R14: 00007f6364a15fa0 R15: 00007f6364a15fa0
 </TASK>

[1]: https://lore.kernel.org/all/20260226201600.222044-1-alice.kernel@fastmail.im/

Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: syzbot+ci3edea60a44225dec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69a1dfba.050a0220.3a55be.0026.GAE@google.com/
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Link: https://patch.msgid.link/20260403174949.843941-1-alice.kernel@fastmail.im
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/l2tp/l2tp_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a0682e63fc637..9156a937334ae 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1290,6 +1290,11 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
 		uh->source = inet->inet_sport;
 		uh->dest = inet->inet_dport;
 		udp_len = uhlen + session->hdr_len + data_len;
+		if (udp_len > U16_MAX) {
+			kfree_skb(skb);
+			ret = NET_XMIT_DROP;
+			goto out_unlock;
+		}
 		uh->len = htons(udp_len);
 
 		/* Calculate UDP checksum if configured to do so */
-- 
2.53.0

