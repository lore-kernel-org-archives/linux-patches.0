Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1613E34389F;
	Sat, 30 May 2026 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162803; cv=none; b=WlkxKtL9tAGPk/ZDlEhlKwyvz82CQxcYoOFcJqitQPUgPOtd5vX073OPNSsRdUGKaFZsPgbkYeAkdYz9RonPwDktbTeHsCcel6KFftA0d0u/BQbPqKkCbo+L11pXaMtRo5lu0fearf87rVVJUVXZW0tFVSBGVuLjIYnwLhSw6dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162803; c=relaxed/simple;
	bh=9Bmb9Rl9A+DbuC5L9mUb1qqwxFxAk/lS0xRGH6shp84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1436jV9dqT/IeIuKhnTUTTfS/pwFlKwexwRHRupdHtNm2VQyyCH3x0GhuZjWk6YL4rlXStEEeY9rh1BpuZaSHpgqwz8HeTbtbjC2BHhIbl7ysoifMd2zZEqjdrZi47JHqwIT3TIpONxEymHEox29UhF8UoReS+fbNvQZdKA3fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdtPVUiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdtPVUiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152A91F00893;
	Sat, 30 May 2026 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162801;
	bh=Ir82eN5ttKBACyt1Z/U3SW4ZR7uqqyhem5c7vHQw60A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdtPVUiC/Py+iSEMdU4cZzo71cn1lNdn02nWMrt1+fStXpgt0jFw6vAQxfm28Kfzr
	 npOmVvwdAqyZWtZzBALrbgUrbNgqj8DmbtK7sVNhtg6XXEHe+chUbsU8tu1ZAHIk9k
	 msDjdcpdLPjRxArq//xjxD6c/o4RG6KpMVBc6hHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ci3edea60a44225dec@syzkaller.appspotmail.com,
	Alice Mikityanska <alice@isovalent.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/776] l2tp: Drop large packets with UDP encap
Date: Sat, 30 May 2026 17:55:52 +0200
Message-ID: <20260530160241.278368906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 net/l2tp/l2tp_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7e242ebac664a..e429a0749ffea 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1083,6 +1083,11 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
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



